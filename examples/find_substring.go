package examples

func findSubstring(str string, match string) bool {
    if len(str) < len(match) {
        return false
    }
    for i := 0; i <= len(str)-len(match); i++ {
        subStr := str[i : i+len(match)]
        if subStr == match {
            return true
        }
    }
    return false
}
