from copy import deepcopy
import numpy as np
import pandas as pd
song_file_name = r"\barber_of_seville_chords.txt"
song_csv_data = r"\barber_of_seville_chords_with_values.csv"

a = pd.read_csv(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\chords' + song_file_name, sep='\t', header=None)
time = a[0]
chord = a[2]
print(time)
print(chord)
def clean_chord(chord, simplified = False):
    # Remove anything after a slash
    chord = chord.split('/')[0]
    #remove other fluff
    chord = chord.replace('aug', '').replace('dim', '').replace('b5', '').replace('maj', 'M').replace('6', '')
    if simplified:
        #remove more fluff for just major and minor chords
        chord = chord.replace('7', '').replace('M7', '').replace('M', '')
    return chord

# Apply cleaning function to all chords
# cleaned_chords = chord.apply(clean_chord, simplified = False)
simplified_cleaned_chords = chord.apply(clean_chord, simplified = True)

# Print the cleaned chords
# for chord in cleaned_chords:
    # print(chord)

# print("Normal Chords:")
# print(sorted(list(set(cleaned_chords))))
# print(len(sorted(list(set(cleaned_chords)))))

print("Simplified Chords:")
print(sorted(list(set(simplified_cleaned_chords))))
print(len(sorted(list(set(simplified_cleaned_chords)))))
print(simplified_cleaned_chords)

note_order = ['A', 'Bb', 'B', 'C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab']
enharmonic_equivalents = {'A#': 'Bb', 'Db': 'C#', 'D#': 'Eb', 'Gb': 'F#', 'G#': 'Ab'}

all_chords = []
for note in note_order:
    minor = note + 'm'
    major = note
    all_chords.append(minor)
    all_chords.append(major)

# Remove enharmonic duplicates
unique_chords = []
seen = set()
for chord in all_chords:
    root = chord[:-1] if chord.endswith('m') else chord  # Extract root note
    root = enharmonic_equivalents.get(root, root)  # Convert to primary equivalent
    normalized_chord = root + ('m' if chord.endswith('m') else '')

    if normalized_chord not in seen:
        unique_chords.append(normalized_chord)
        seen.add(normalized_chord)

#Assign equally spaced values between 0 and 1
values = np.linspace(0, 1, len(unique_chords))
chord_mapping = dict(zip(unique_chords, values))

# Map each simplified chord to its corresponding value
chord_values = simplified_cleaned_chords.map(chord_mapping)

prev_time = 0
differences = []
for t in time:
    differences.append(t-prev_time)
    prev_time = t
# differences = differences[:-1]
# simplified_cleaned_chords = simplified_cleaned_chords[:-1]
# chord_values = chord_values[:-1]
values = pd.DataFrame({'Time': differences, 'Chord': simplified_cleaned_chords, 'Value': chord_values})
# values = values.dropna() #drop na values
#if last line is a newline:
# values = values[:-1]
values.to_csv(r'C:\Users\joshu\PycharmProjects\pickhacks2025\PickHacks2025\chords' + song_csv_data, index=False)
