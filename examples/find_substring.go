package examples

func findSubstring(str string, subStr string) bool {
    r := []rune(str)
    sr := []rune(subStr)
    if len(sr) == 0 {
        return false
    }
str:
    for i, ru := range r {
        if ru == sr[0] {
            for j, x := range sr[1:] {
                if r[i+j+1] != x {
                    continue str
                }
            }
            return true
        }
    }
    return false
}
