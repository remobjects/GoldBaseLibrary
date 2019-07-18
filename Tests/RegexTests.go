package GoldLibrary.Tests.Shared
import (
	"bytes"
	"fmt"
	"regexp"
)


func DoSimpleMatchTest() bool {
 matched, _ := regexp.MatchString("foo.*", "seafood")
 return matched
}

func DoMustCompileTest() bool {
	var validID = regexp.MustCompile(`^[a-z]+\[[0-9]+\]$`)
	return validID.MatchString("adam[23]")
}