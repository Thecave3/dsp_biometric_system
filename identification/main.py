import glob
import joblib
import numpy as np
import os
import pandas as pd
import parselmouth
import pickle
import pyaudio
import python_speech_features as mfcc
import sys
import time
import warnings
import wave
from parselmouth.praat import call
from scipy.io.wavfile import read
from sklearn import preprocessing, mixture


def load_model(PATH):
    clf = joblib.load(PATH)
    return clf


def measure_pitch(voiceID, f0min, f0max, unit):
    sound = parselmouth.Sound(voiceID)  # read the sound
    pitch = call(sound, "To Pitch", 0.0, f0min, f0max)
    pointProcess = call(sound, "To PointProcess (periodic, cc)", f0min, f0max)  # create a praat pitch object
    localJitter = call(pointProcess, "Get jitter (local)", 0, 0, 0.0001, 0.02, 1.3)
    localabsoluteJitter = call(pointProcess, "Get jitter (local, absolute)", 0, 0, 0.0001, 0.02, 1.3)
    rapJitter = call(pointProcess, "Get jitter (rap)", 0, 0, 0.0001, 0.02, 1.3)
    ppq5Jitter = call(pointProcess, "Get jitter (ppq5)", 0, 0, 0.0001, 0.02, 1.3)
    localShimmer = call([sound, pointProcess], "Get shimmer (local)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    localdbShimmer = call([sound, pointProcess], "Get shimmer (local_dB)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    apq3Shimmer = call([sound, pointProcess], "Get shimmer (apq3)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    aqpq5Shimmer = call([sound, pointProcess], "Get shimmer (apq5)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    apq11Shimmer = call([sound, pointProcess], "Get shimmer (apq11)", 0, 0, 0.0001, 0.02, 1.3, 1.6)
    harmonicity05 = call(sound, "To Harmonicity (cc)", 0.01, 500, 0.1, 1.0)
    hnr05 = call(harmonicity05, "Get mean", 0, 0)
    harmonicity15 = call(sound, "To Harmonicity (cc)", 0.01, 1500, 0.1, 1.0)
    hnr15 = call(harmonicity15, "Get mean", 0, 0)
    harmonicity25 = call(sound, "To Harmonicity (cc)", 0.01, 2500, 0.1, 1.0)
    hnr25 = call(harmonicity25, "Get mean", 0, 0)
    harmonicity35 = call(sound, "To Harmonicity (cc)", 0.01, 3500, 0.1, 1.0)
    hnr35 = call(harmonicity35, "Get mean", 0, 0)
    harmonicity38 = call(sound, "To Harmonicity (cc)", 0.01, 3800, 0.1, 1.0)
    hnr38 = call(harmonicity38, "Get mean", 0, 0)
    return localJitter, localabsoluteJitter, rapJitter, ppq5Jitter, localShimmer, localdbShimmer, apq3Shimmer, aqpq5Shimmer, apq11Shimmer, hnr05, hnr15, hnr25, hnr35, hnr38


def predict(clf, wavPath):
    file_list = []
    localJitter_list = []
    localabsoluteJitter_list = []
    rapJitter_list = []
    ppq5Jitter_list = []
    localShimmer_list = []
    localdbShimmer_list = []
    apq3Shimmer_list = []
    aqpq5Shimmer_list = []
    apq11Shimmer_list = []
    hnr05_list = []
    hnr15_list = []
    hnr25_list = []
    hnr35_list = []
    hnr38_list = []

    sound = parselmouth.Sound(wavPath)
    (localJitter, localabsoluteJitter, rapJitter, ppq5Jitter, localShimmer, localdbShimmer, apq3Shimmer, aqpq5Shimmer,
     apq11Shimmer, hnr05, hnr15, hnr25, hnr35, hnr38) = measure_pitch(sound, 75, 1000, "Hertz")
    localJitter_list.append(localJitter)  # make a mean F0 list
    localabsoluteJitter_list.append(localabsoluteJitter)  # make a sd F0 list
    rapJitter_list.append(rapJitter)
    ppq5Jitter_list.append(ppq5Jitter)
    localShimmer_list.append(localShimmer)
    localdbShimmer_list.append(localdbShimmer)
    apq3Shimmer_list.append(apq3Shimmer)
    aqpq5Shimmer_list.append(aqpq5Shimmer)
    apq11Shimmer_list.append(apq11Shimmer)
    hnr05_list.append(hnr05)
    hnr15_list.append(hnr15)
    hnr25_list.append(hnr25)
    hnr35_list.append(hnr35)
    hnr38_list.append(hnr38)

    toPred = pd.DataFrame(np.column_stack(
        [localJitter_list, localabsoluteJitter_list, rapJitter_list, ppq5Jitter_list, localShimmer_list,
         localdbShimmer_list, apq3Shimmer_list, aqpq5Shimmer_list, apq11Shimmer_list, hnr05_list, hnr15_list,
         hnr25_list]),
        columns=["Jitter_rel", "Jitter_abs", "Jitter_RAP", "Jitter_PPQ", "Shim_loc", "Shim_dB",
                 "Shim_APQ3", "Shim_APQ5", "Shi_APQ11", "hnr05", "hnr15",
                 "hnr25"])  # add these lists to pandas in the right order

    resp = clf.predict(toPred)
    resp = str(resp)

    if resp == "[1.]":
        return True
    else:
        return False


warnings.filterwarnings("ignore")
np.set_printoptions(threshold=sys.maxsize)


# Calculate and returns the delta of given feature vector matrix
def calculate_delta(array):
    rows, cols = array.shape
    deltas = np.zeros((rows, 20))
    N = 2
    for i in range(rows):
        index = []
        j = 1
        while j <= N:
            if i - j < 0:
                first = 0
            else:
                first = i - j
            if i + j > rows - 1:
                second = rows - 1
            else:
                second = i + j
            index.append((second, first))
            j += 1
        deltas[i] = (array[index[0][0]] - array[index[0][1]] + (2 * (array[index[1][0]] - array[index[1][1]]))) / 10
    return deltas


# convert audio to mfcc features
def extract_features(audio, rate):
    mfcc_feat = mfcc.mfcc(audio, rate, 0.025, 0.01, 20, appendEnergy=True, nfft=1103)
    mfcc_feat = preprocessing.scale(mfcc_feat)
    delta = calculate_delta(mfcc_feat)

    # combining both mfcc features and delta
    combined = np.hstack((mfcc_feat, delta))
    return combined


def add_user(name="test"):
    # Check for existing name
    if os.path.exists("./lib/gmm_models/" + name + ".gmm") or name == "Unknown":
        print("Name Already Exists! Try Another Name...")
        return

    # Voice authentication
    FORMAT = pyaudio.paInt16
    CHANNELS = 2
    RATE = 44100
    CHUNK = 1024
    RECORD_SECONDS = 4

    main_path = "./voice_database/"
    if not os.path.exists(main_path):
        os.mkdir(main_path)

    source = main_path + name
    if not os.path.exists(source):
        os.mkdir(source)

    for i in range(3):
        audio = pyaudio.PyAudio()
        if i == 0:
            j = 3
            while j >= 0:
                time.sleep(1.0)
                os.system("cls" if os.name == "nt" else "clear")
                print(f"Speak your name in {j} seconds")
                j -= 1
        elif i == 1:
            time.sleep(2.0)
            print("Speak your name one more time")
            time.sleep(0.8)
        else:
            time.sleep(2.0)
            print("Speak your name one last time")
            time.sleep(0.8)

        # start Recording
        stream = audio.open(format=FORMAT, channels=CHANNELS,
                            rate=RATE, input=True,
                            frames_per_buffer=CHUNK)

        print("Recording...")
        frames = []

        for _ in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
            data = stream.read(CHUNK)
            frames.append(data)

        # stop Recording
        stream.stop_stream()
        stream.close()
        audio.terminate()

        # saving wav file of speaker
        waveFile = wave.open(source + "/" + str((i + 1)) + ".wav", "wb")
        waveFile.setnchannels(CHANNELS)
        waveFile.setsampwidth(audio.get_sample_size(FORMAT))
        waveFile.setframerate(RATE)
        waveFile.writeframes(b"".join(frames))
        waveFile.close()
        print("Done")

    dest = "./gmm_models/"
    if not os.path.exists(dest):
        os.mkdir(dest)

    count = 1

    for path in os.listdir(source):
        path = os.path.join(source, path)

        features = np.array([])

        # reading audio files of speaker
        (sr, audio) = read(path)

        # extract 40 dimensional MFCC & delta MFCC features
        vector = extract_features(audio, sr)

        if features.size == 0:
            features = vector
        else:
            features = np.vstack((features, vector))

        # when features of 3 files of speaker are concatenated, then do model training
        if count == 3:
            gmm = mixture.GaussianMixture(n_components=16, max_iter=200, covariance_type="diag", n_init=3).fit(features)

            # saving the trained Gaussian model
            pickle.dump(gmm, open(dest + name + ".gmm", "wb"))
            print(name + " added successfully")
            features = np.asarray(())
            count = 0
        count = count + 1


# Deletes a registered user from database
def delete_user(name="test"):
    # Check for existing name
    if os.path.exists("./gmm_models/" + name + ".gmm"):
        [os.remove(path) for path in glob.glob("./voice_database/" + name + "/*")]
        os.removedirs("./voice_database/" + name)
        os.remove("./gmm_models/" + name + ".gmm")
        print("User " + name + " deleted successfully!")
    else:
        print("No such user!")
        return


# Recognize a registered user
def recognize():
    # Voice Authentication
    FORMAT = pyaudio.paInt16
    CHANNELS = 2
    RATE = 44100
    CHUNK = 1024
    RECORD_SECONDS = 5
    FILENAME = "./test.wav"

    audio = pyaudio.PyAudio()

    # start Recording
    stream = audio.open(format=FORMAT, channels=CHANNELS, rate=RATE, input=True, frames_per_buffer=CHUNK)
    print("Recording...")
    time.sleep(1.0)
    frames = []

    for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)
    print("Recording finished")

    # stop Recording
    stream.stop_stream()
    stream.close()
    audio.terminate()

    # saving wav file
    waveFile = wave.open(FILENAME, "wb")
    waveFile.setnchannels(CHANNELS)
    waveFile.setsampwidth(audio.get_sample_size(FORMAT))
    waveFile.setframerate(RATE)
    waveFile.writeframes(b"".join(frames))
    waveFile.close()

    modelpath = "./gmm_models/"
    gmm_files = [os.path.join(modelpath, fname) for fname in os.listdir(modelpath) if fname.endswith(".gmm")]
    models = [pickle.load(open(fname, "rb")) for fname in gmm_files]
    speakers = [fname.split("/")[-1].split(".gmm")[0] for fname in gmm_files]

    if len(models) == 0:
        print("No such user in the database!")
        return

    # Read test file
    sr, audio = read(FILENAME)

    # Extract mfcc features
    vector = extract_features(audio, sr)
    log_likelihood = np.zeros(len(models))

    # Checking with each model one by one
    for i in range(len(models)):
        gmm = models[i]
        scores = np.array(gmm.score(vector))
        log_likelihood[i] = scores.sum()

    pred = np.argmax(log_likelihood)
    print(log_likelihood[pred])
    identity = speakers[pred]

    # if voice not recognized than terminate the process
    if identity == "Unknown" or identity == "null" or log_likelihood[pred] <= -20.0:
        print("Not recognized! Try talking shortly\nafter the sign 'Recording' appears")
        return
    if identity == "null":
        print("No voice detected, check the microphone" + identity)
        return
    print("Recognized as - " + identity)
    return


if __name__ == '__main__':
    add_user("andrea")
    recognize()
