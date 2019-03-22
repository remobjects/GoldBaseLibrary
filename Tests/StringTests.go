package GoldLibrary.Tests.Shared

import (
	"fmt"
	"strings"
)

func DoStringsCompareTest() bool {
	if(strings.Compare("a", "b") != -1) {
		return false
	}
	if(strings.Compare("a", "a") != 0) {
		return false
	}
	if(strings.Compare("b", "a") != 1) {
		return false
	}
	return true
}

func DoStringsContainsTest() bool {
	if(!strings.Contains("seafood", "foo")) {
		return false
	}
	if(strings.Contains("seafood", "bar")) {
		return false
	}
	if(!strings.Contains("seafood", "")) {
		return false
	}
	if(!strings.Contains("", "")) {
		return false
	}
	return true
}

func DoStringsContainsAnyTest() bool {
	if(strings.ContainsAny("team", "i")) {
		return false
	}
	if(!strings.ContainsAny("failure", "u & i")) {
		return false
	}
	if(strings.ContainsAny("foo", "")) {
		return false
	}
	if(strings.ContainsAny("", "")) {
		return false
	}
	return true
}

func DoStringsContainsRuneTest() bool {
	// Finds whether a string contains a particular Unicode code point.
	// The code point for the lowercase letter "a", for example, is 97.
	if(!strings.ContainsRune("aardvark", 97)) {
		return false
	}
	if(strings.ContainsRune("timeout", 97)) {
		return false
	}
	return true
}

func DoStringsCountTest() bool {
	if(strings.Count("cheese", "e") != 3) {
		return false
	}
	if(strings.Count("five", "") != 5) {// before & after each rune
		return false
	}
	return true
}

func DoStringsEqualFoldTest() bool {
	if(!strings.EqualFold("Go", "go")) {
		return false
	}
	return true
}

func DoStringsFieldsTest() bool {
	lFields := strings.Fields("  foo bar  baz   ")
	return len(lFields) == 3
}

func DoStringsHasPrefixTest() bool {
	if(!strings.HasPrefix("Gopher", "Go")) {
		return false
	}
	if(strings.HasPrefix("Gopher", "C")) {
		return false
	}
	if(!strings.HasPrefix("Gopher", "")) {
		return false
	}
	return true
}

func DoStringsHasSuffixTest() bool {
	if(!strings.HasSuffix("Amigo", "go")) {
		return false
	}
	if(strings.HasSuffix("Amigo", "O")) {
		return false
	}
	if(strings.HasSuffix("Amigo", "Ami")) {
		return false
	}
	if(!strings.HasSuffix("Amigo", "")) {
		return false
	}
	return true
}

func DoStringsIndexTest() bool {
	if(strings.Index("chicken", "ken") != 4) {
		return false
	}
	if(strings.Index("chicken", "dmr") != -1) {
		return false
	}
	return true
}

func DoStringsIndexAnyTest() bool {
	if(strings.IndexAny("chicken", "aeiouy") != 2) {
		return false
	}
	if(strings.IndexAny("crwth", "aeiouy") != -1) {
		return false
	}
	return true
}

func DoStringsIndexRuneTest() bool {
	if(strings.IndexRune("chicken", 'k') != 4) {
		return false
	}
	if(strings.IndexRune("chicken", 'd') != -1) {
		return false
	}
	return true
}

func DoStringsJoinTest() bool {
	s := []string{"foo", "bar", "baz"}
	return strings.Join(s, ", ") == "foo, bar, baz"
}

func DoStringsLastIndexTest() bool {
	if(strings.Index("go gopher", "go") != 0) {
		return false
	}
	if(strings.LastIndex("go gopher", "go") != 3) {
		return false
	}
	if(strings.LastIndex("go gopher", "rodent") != -1) {
		return false
	}
	return true
}

func DoStringsMapTest() bool {
	rot13 := func(r rune) rune {
		switch {
			case r >= 'A' && r <= 'Z':
			return 'A' + (r-'A'+13)%26
			case r >= 'a' && r <= 'z':
			return 'a' + (r-'a'+13)%26
		}
		return r
	}
	return strings.Map(rot13, "'Twas brillig and the slithy gopher...") == "'Gjnf oevyyvt naq gur fyvgul tbcure..."
}

func DoStringsReplaceTest() bool {
	if(strings.Replace("oink oink oink", "k", "ky", 2) != "oinky oinky oink") {
		return false
	}
	if(strings.Replace("oink oink oink", "oink", "moo", -1) != "moo moo moo") {
		return false
	}
	return true
}

func DoStringsReplaceAllTest() bool {
	if(strings.ReplaceAll("oink oink oink", "oink", "moo") != "moo moo moo") {
		return false
	}
	return true
}

func DoStringsSplitTest() bool {
	lSplit1 := strings.Split("a,b,c", ",")
	if ((len(lSplit1) != 3) || (lSplit1[0] != "a") || (lSplit1[1] != "b") || (lSplit1[2] != "c")) {
		return false
	}
	lSplit2 := strings.Split("a man a plan a canal panama", "a ")
	if ((len(lSplit2) != 4) || (lSplit2[3] != "canal panama")) {
		return false
	}
	lSplit3 := strings.Split(" xyz ", "")
	if ((len(lSplit3) != 5) || (lSplit3[4] != " ")) {
		return false
	}
	lSplit4 := strings.Split("", "Bernardo O'Higgins")
	if ((len(lSplit4) != 1) || (lSplit4[0] != "")) {
		return false
	}
	return true
}

func DoStringsToLowerTest() bool {
	return strings.ToLower("Gopher") == "gopher"
}

func DoStringsToLowerSpecialTest() bool {
	return strings.ToLowerSpecial(unicode.TurkishCase, "Önnek İş") == "önnek iş"
}

func DoStringsToTitleTest() bool {
	if (strings.ToTitle("loud noises") != "LOUD NOISES") {
		return false
	}
	if (strings.ToTitle("хлеб") != "ХЛЕБ") {
		return false
	}
	return true
}

func DoStringsToTitleSpecialTest() bool {
	return strings.ToTitleSpecial(unicode.TurkishCase, "dünyanın ilk borsa yapısı Aizonai kabul edilir") == "DÜNYANIN İLK BORSA YAPISI AİZONAİ KABUL EDİLİR"
}

func DoStringsToUpperTest() bool {
	return strings.ToUpper("Gopher") == "GOPHER"
}

func DoStringsTrimTest() bool {
	return strings.Trim("¡¡¡Hello, Gophers!!!", "!¡") == "Hello, Gophers"
}

func DoStringsBuilderTest() bool {
	var b strings.Builder
	for i := 3; i >= 1; i-- {
		fmt.Fprintf(&b, "%d...", i)
	}
	b.WriteString("ignition")
	return b.String() == "3...2...1...ignition"
}