import pandas as pd

# Read the CSV file (ensure this file is in the same directory or provide the full path)
df = pd.read_csv('rms_values_normalized.csv')

# Remove the first 5515 rows (excluding the header)
df_modified = df.iloc[5515:]

# Save the modified DataFrame to a new CSV file
df_modified.to_csv('modified_rms_values.csv', index=False)

print("Successfully removed the first 5515 lines. Saved to 'modified_rms_values.csv'.")
