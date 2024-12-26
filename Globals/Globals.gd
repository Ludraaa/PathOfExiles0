extends Node

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
