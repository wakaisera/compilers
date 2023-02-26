package examples

func gcd(first int, second int) int {
	for second != 0 {
		temp := second
		second = first % second
		first = temp
	}
	return first
}
