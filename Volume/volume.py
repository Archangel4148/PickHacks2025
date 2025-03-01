import librosa
import numpy as np
import pandas as pd

# Load the audio file (replace with your file path)
y, sr = librosa.load(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\Assets\Music\otherside.ogg')

# Set analysis parameters
frame_length = 2048
hop_length = 512

# Compute the RMS energy for each frame
rms = librosa.feature.rms(y=y, frame_length=frame_length, hop_length=hop_length)[0]

# Normalize the RMS values so that the maximum value is 1
rms_normalized = rms / np.max(rms)

# Convert frame indices to time values
times = librosa.frames_to_time(np.arange(len(rms)), sr=sr, hop_length=hop_length)

# Create a DataFrame with time and normalized RMS columns
df = pd.DataFrame({'time': times, 'rms_normalized': rms_normalized})

# Export the DataFrame to a CSV file
df.to_csv(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\Volume\otherside_volume.csv', index=False)
