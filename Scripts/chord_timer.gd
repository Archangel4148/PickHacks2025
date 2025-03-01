extends Node2D

var csv_data = []
var current_index = 0  # Track the current index in csv_data

signal send_chord_data(progress: float)
signal chord_timer_start

func _ready():
	# Load CSV data
	load_csv("res://Pitch/pitch.csv")
	
	# Create and setup the timer
	
	$Timer.autostart = false
	$Timer.timeout.connect(_on_timer_timeout)
	
	# Start the first timer based on the first entry in the CSV
	start_next_timer()
	chord_timer_start.emit()

# Function to load and parse CSV data
func load_csv(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	# Check if file cannot be opened
	if file == null:
		print("Error: Could not open file.")
		return
	var first_line = true  # Flag to handle the header
	while !file.eof_reached():
		var line = file.get_line().strip_edges()
		if first_line:
			first_line = false  # Skip the header line
			continue
		var data = line.split(",")
		
		if data.size() >= 3:  # Ensure there are at least 3 elements in the split
			#Chords:
			#var time = float(data[0])
			#var chord = data[1]
			#var value = float(data[2])
			#Pitch:
			var time  = float(data[0])
			var value = float(data[1])
		
			csv_data.append({"time": time, "value": value})
		else:
			# Skipping invalid line
			pass
	file.close()

# Function to start the next timer based on the next "time" in csv_data
func start_next_timer():
	if current_index < csv_data.size():
		var time_to_wait = csv_data[current_index]["time"]
		# Start the timer with the correct delay
		$Timer.start(time_to_wait)
	else:
		# Reached the end of the song
		pass
	
# Called when the timer times out
func _on_timer_timeout():
	if current_index < csv_data.size():
		var data = csv_data[current_index]
		var progress = data["value"]
		# Send the position of the next platform
		send_chord_data.emit(progress)

		# Start the next timer
		current_index += 1
		start_next_timer()
