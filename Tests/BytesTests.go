package GoldLibrary.Tests.Shared;

import (
	"bytes"
	"buffer"
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