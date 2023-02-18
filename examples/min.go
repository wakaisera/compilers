package examples

func min(array []int, size int) int {
	min_elem := array[0]
	for i := 1; i < size; i++ {
		if array[i] < min_elem {
			min_elem = array[i]
		}
	}
	return min_elem
}
