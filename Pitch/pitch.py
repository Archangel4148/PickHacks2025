from copy import deepcopy
import numpy as np
import pandas as pd
# song_file_name = r"\barber pitch.txt"
# song_csv_data = r"\barber pitch values.csv"

a = pd.read_csv(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\Pitch\barber pitch.txt', sep='\t', header=None)
time = a[0]
pitch = a[2]
maxPitch = max(a[2])
minPitch = min(a[2])

normalized_pitch = (pitch - minPitch) / (maxPitch - minPitch)

# Check the result by printing normalized pitch values
print(normalized_pitch)

prev_time = 0
differences = []
for t in time:
    differences.append(t-prev_time)
    prev_time = t
values = pd.DataFrame({'Time': differences, 'Value': normalized_pitch})
values.to_csv(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\Pitch\pitch.csv', index=False)
