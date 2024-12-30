extends Node

#References to important nodes
var curr_map
var minimap_map
var player

var moused_over_objects = []

#Gets the closest object to the player from the array
func get_closest_to_player(arr):
	var distance = 999999999
	var curr_closest
	for obj in arr:
		if player.position.distance_to(obj.position) < distance:
			distance = player.position.distance_to(obj.position)
			curr_closest = obj
	return curr_closest

#Generates a random weighted entry of the given array and weights
func random_entry(arr, weights = []):
	#Generates a generic weight array in case the weights were not provided
	if len(arr) != len(weights):
		for x in arr:
			weights.append(1)
	
	#Create a temporary array, stuffed with the weighted indexes
	var temp = []
	for i in range(len(weights)):
		for w in weights[i]:
			temp.append(i)
	
	#Return random element
	return arr[temp[randi_range(0, len(temp) - 1)]]
