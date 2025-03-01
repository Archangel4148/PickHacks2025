extends Node2D

var csv_data = []
func _ready():
	load_csv("res://Pitch/pitch.csv")
func load_csv(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	# check if file cannot be opened
	if file == null:
		print("error: could not open file")
		return
	var first_line = true  # Flag to handle the header
	while !file.eof_reached():
		var line = file.get_line().strip_edges()  # Strip any surrounding spaces/newlines
		if first_line:
			first_line = false  # Skip the header line
			continue
		var data = line.split(",")
		
		if data.size() >= 3:  # Ensure there are at least 3 elements in the split
			var time = float(data[0])
			var chord = data[1]
			var value = float(data[2])
		
			csv_data.append({"time": time, "value": value})
		else:
			print("Skipping invalid line:", line)  # Print skipped line for debugging
	print(csv_data)
	file.close()
