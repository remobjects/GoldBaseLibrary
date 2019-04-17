package GoldLibrary.Tests.Shared;

import (
	"bytes"
	"encoding/base64"
	"fmt"
)

func DoBufferInitTest() Integer {
	var b bytes.Buffer // A Buffer needs no initialization.
	b.Write([]byte("Hello"))
	return b.Len()
}

func DoReader64Test() string {
	// A Buffer can turn a string or a []byte into an io.Reader.
	buf := bytes.NewBufferString("R29waGVycyBydWxlIQ==")
	dec := base64.NewDecoder(base64.StdEncoding, buf)
	var z Bytes.Buffer
	lRes := make([]byte, 20, 20)
	lTotal, _ := dec.Read(lRes)
	return string(lRes[0:lTotal])
}

func DoContainsTest() bool {
	if(!bytes.Contains([]byte("seafood"), []byte("foo"))) {
		return false
	}

	if(bytes.Contains([]byte("seafood"), []byte("bar"))) {
		return false
	}

	if(!bytes.Contains([]byte("seafood"), []byte(""))) {
		return false
	}

	if(!bytes.Contains([]byte(""), []byte(""))) {
		return false
	}
	return true
}

func DoContainsAnyTest() bool {
	if(!bytes.ContainsAny([]byte("I like seafood."), "fÄo!")) {
		return false
	}
	if(!bytes.ContainsAny([]byte("I like seafood."), "去是伟大的.")) {
		return false
	}
	if(bytes.ContainsAny([]byte("I like seafood."), "")) {
		return false
	}
	if(bytes.ContainsAny([]byte(""), "")) {
		return false
	}
	return true
}

func DoContainsRuneTest() bool {
	if(!bytes.ContainsRune([]byte("I like seafood."), 'f')) {
		return false
	}
	if(bytes.ContainsRune([]byte("I like seafood."), 'ö')) {
		return false
	}
	if(!bytes.ContainsRune([]byte("去是伟大的!"), '大')) {
		return false
	}
	if(!bytes.ContainsRune([]byte("去是伟大的!"), '!')) {
		return false
	}
	if(bytes.ContainsRune([]byte(""), '@')) {
		return false
	}
	return true
}

func DoCountTest() bool {
	if(bytes.Count([]byte("cheese"), []byte("e")) != 3) {
		return false
	}
	if(bytes.Count([]byte("five"), []byte("")) != 5)  { // before & after each rune
		return false
	}
	return true
}

func DoBytesEqualTest() bool {
	if(!bytes.Equal([]byte("Go"), []byte("Go"))) {
		return false
	}
	if(bytes.Equal([]byte("Go"), []byte("C++"))) {
		return false
	}
	return true
}

func DoBytesEqualFoldTest() bool {
	if(!bytes.EqualFold([]byte("Go"), []byte("go"))) {
		return false
	}
	return true
}

func DoBytesFieldsTest() bool {
	lFields := bytes.Fields([]byte("  foo bar  baz   "))
	return lFields.Len() == 3
}

func DoBytesFieldsFuncTest() bool {
	f := func(c rune) bool {
		return !unicode.IsLetter(c) && !unicode.IsNumber(c)
	}
	lFields := bytes.FieldsFunc([]byte("  foo1;bar2,baz3..."), f)
	return lFields.Len() == 3
}

func DoBytesHasPrefix() bool {
	if(!bytes.HasPrefix([]byte("Gopher"), []byte("Go"))) {
		return false
	}
	if(bytes.HasPrefix([]byte("Gopher"), []byte("C"))) {
		return false
	}
	if(!bytes.HasPrefix([]byte("Gopher"), []byte(""))) {
		return false
	}
	return true
}

func DoBytesHasSuffixTest() bool {
	if(!bytes.HasSuffix([]byte("Amigo"), []byte("go"))) {
		return false
	}
	if(bytes.HasSuffix([]byte("Amigo"), []byte("O"))) {
		return false
	}
	if(bytes.HasSuffix([]byte("Amigo"), []byte("Ami"))) {
		return false
	}
	if(!bytes.HasSuffix([]byte("Amigo"), []byte(""))) {
		return false
	}
	return true
}

func DoBytesIndexTest() bool {
	if(bytes.Index([]byte("chicken"), []byte("ken")) != 4) {
		return false
	}
	if(bytes.Index([]byte("chicken"), []byte("dmr")) != -1) {
		return false
	}
	return true
}

func DoBytesIndexAnyTest() bool {
	if(bytes.IndexAny([]byte("chicken"), "aeiouy") != 2) {
		return false
	}
	if(bytes.IndexAny([]byte("crwth"), "aeiouy") != -1) {
		return false
	}
	return true
}

func DoIndexByteTest() bool {
	if(bytes.IndexByte([]byte("chicken"), byte('k')) != 4) {
		return false
	}
	if(bytes.IndexByte([]byte("chicken"), byte('g')) != -1) {
		return false
	}
	return true
}

func DoIndexRuneTest() bool {
	if(bytes.IndexRune([]byte("chicken"), 'k') != 4) {
		return false
	}
	if(bytes.IndexRune([]byte("chicken"), 'd') != -1) {
		return false
	}
	return true
}

func DoBytesJoinTest() bool {
	s := [][]byte{[]byte("foo"), []byte("bar"), []byte("baz")}
	lJoin := bytes.Join(s, []byte(", "))
	if (string(lJoin) == "foo, bar, baz") {
		return true
	} else {
		return false
	}
}

func DoBytesLasIndexTest() bool {
	if(bytes.Index([]byte("go gopher"), []byte("go")) != 0) {
		return false
	}
	if(bytes.LastIndex([]byte("go gopher"), []byte("go")) != 3) {
		return false
	}
	if(bytes.LastIndex([]byte("go gopher"), []byte("rodent")) != -1) {
		return false
	}
	return true
}

func DoBytesLastIndexAnyTest() bool {
	if(bytes.LastIndexAny([]byte("go gopher"), "MüQp") != 5) {
		return false
	}
	if(bytes.LastIndexAny([]byte("go 地鼠"), "地大") != 3) {
		return false
	}
	if(bytes.LastIndexAny([]byte("go gopher"), "z,!.") != -1) {
		return false
	}
	return true
}

func DoBytesMapTest() bool {
	rot13 := func(r rune) rune {
		switch {
			case r >= 'A' && r <= 'Z':
			return 'A' + (r-'A'+13)%26
			case r >= 'a' && r <= 'z':
			return 'a' + (r-'a'+13)%26
		}
		return r
	}
	lMap := bytes.Map(rot13, []byte("'Twas brillig and the slithy gopher..."))
	return string(lMap) == "'Gjnf oevyyvt naq gur fyvgul tbcure..."
}

func DoBytesRepeatTest() bool {
	lRepeat := bytes.Repeat([]byte("lo"), 3)
	return string(lRepeat) == "lololo"
}

func DoBytesReplaceTest() bool {
	lRes1 := bytes.Replace([]byte("oink oink oink"), []byte("k"), []byte("ky"), 2)
	lRes2 := bytes.Replace([]byte("oink oink oink"), []byte("oink"), []byte("moo"), -1)
	if (string(lRes1) != "oinky oinky oink") {
		return false
	}
	if (string(lRes2) != "moo moo moo") {
		return false
	}
	return true
}

func DoBytesReplaceAllTest() bool {
	lReplaced := bytes.ReplaceAll([]byte("oink oink oink"), []byte("oink"), []byte("moo"))
	return string(lReplaced) == "moo moo moo"
}

func DoBytesRuneTest() bool {
	rs := bytes.Runes([]byte("go gopher"))
	return len(rs) == 9
}

func DoBytesSplitTest() bool {
	lSplit1 := bytes.Split([]byte("a,b,c"), []byte(","))
	if(len(lSplit1) != 3) {
		return false
	}
	lSplit2 := bytes.Split([]byte("a man a plan a canal panama"), []byte("a "))
	if(len(lSplit2) != 4) {
		return false
	}
	lSplit3 := bytes.Split([]byte(" xyz "), []byte(""))
	if(len(lSplit3) != 5) {
		return false
	}
	lSplit4 := bytes.Split([]byte(""), []byte("Bernardo O'Higgins"))
	if(len(lSplit4) != 1) {
		return false
	}
	return true
}

func DoBytesSplitAfterTest() bool {
	lSplitAfter := bytes.SplitAfter([]byte("a,b,c"), []byte(","))
	return len(lSplitAfter) == 3
}

func DoBytesToLowerTest() bool {
	lToLower := bytes.ToLower([]byte("Gopher"))
	return string(lToLower) == "gopher"
}

func DoBytesToTitleTest() bool {
	lToTitle1 := bytes.ToTitle([]byte("loud noises"))
	lToTitle2 := bytes.ToTitle([]byte("хлеб"))
	return (string(lToTitle1) == "LOUD NOISES") && (string(lToTitle2) == "ХЛЕБ")
}

func DoBytesToUpperTest() bool {
	lToUpper := bytes.ToUpper([]byte("Gopher"))
	return string(lToUpper) == "GOPHER"
}

func DoBytesTrimTest() bool {
	lStrim := bytes.Trim([]byte(" !!! Achtung! Achtung! !!! "), "! ")
	return String(lStrim) == "Achtung! Achtung"
}

func DoBytesTrimSpaceTest() bool {
	lTrimSpace := bytes.TrimSpace([]byte(" \t\n a lone gopher \n\t\r\n"))
	return string(lTrimSpace) == "a lone gopher"
}

func DoBytesTrimSuffix() bool {
	var b = []byte("Hello, goodbye, etc!")
	b = bytes.TrimSuffix(b, []byte("goodbye, etc!"))
	b = bytes.TrimSuffix(b, []byte("gopher"))
	b = append(b, bytes.TrimSuffix([]byte("world!"), []byte("x!"))...)
	return string(b) == "Hello, world!"
}