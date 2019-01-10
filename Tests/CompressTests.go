package GoldLibrary.Tests.Shared

import (
	"bytes"
	"compress/gzip"
	"compress/flate"
	"compress/zlib"
	"strings"
	"fmt"
	"io"
	"log"
	"os"
	"time"
)


func DoGZIPTest() {
	var buf bytes.Buffer
	zw := gzip.NewWriter(&buf)

	// Setting the Header fields is optional.
	zw.Name = "a-new-hope.txt"
	zw.Comment = "an epic space opera by George Lucas"
	zw.ModTime = time.Date(1977, time.May, 25, 0, 0, 0, 0, time.UTC)

	_, err := zw.Write([]byte("A long time ago in a galaxy far, far away..."))
	if err != nil {
		log.Fatal(err)
	}

	if err := zw.Close(); err != nil {
		log.Fatal(err)
	}

	zr, err := gzip.NewReader(&buf)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Printf("Name: %s\nComment: %s\nModTime: %s\n\n", zr.Name, zr.Comment, zr.ModTime.UTC())

	if _, err := io.Copy(os.Stdout, zr); err != nil {
		log.Fatal(err)
	}

	if err := zr.Close(); err != nil {
		log.Fatal(err)
	}
}

func DoFlateTest() {
	// The dictionary is a string of bytes. When compressing some input data,
	// the compressor will attempt to substitute substrings with matches found
	// in the dictionary. As such, the dictionary should only contain substrings
	// that are expected to be found in the actual data stream.
	const dict = `<?xml version="1.0"?>` + `<book>` + `<data>` + `<meta name="` + `" content="`

	// The data to compress should (but is not required to) contain frequent
	// substrings that match those in the dictionary.
	const data = `<?xml version="1.0"?>
<book>
	<meta name="title" content="The Go Programming Language"/>
	<meta name="authors" content="Alan Donovan and Brian Kernighan"/>
	<meta name="published" content="2015-10-26"/>
	<meta name="isbn" content="978-0134190440"/>
	<data>...</data>
</book>
`

	var b bytes.Buffer

	// Compress the data using the specially crafted dictionary.
	zw, err := flate.NewWriterDict(&b, flate.DefaultCompression, []byte(dict))
	if err != nil {
		log.Fatal(err)
	}
	if _, err := io.Copy(zw, strings.NewReader(data)); err != nil {
		log.Fatal(err)
	}
	if err := zw.Close(); err != nil {
		log.Fatal(err)
	}

	// The decompressor must use the same dictionary as the compressor.
	// Otherwise, the input may appear as corrupted.
	fmt.Println("Decompressed output using the dictionary:")
	zr := flate.NewReaderDict(bytes.NewReader(b.Bytes()), []byte(dict))
	if _, err := io.Copy(os.Stdout, zr); err != nil {
		log.Fatal(err)
	}
	if err := zr.Close(); err != nil {
		log.Fatal(err)
	}

	fmt.Println()

	// Substitute all of the bytes in the dictionary with a '#' to visually
	// demonstrate the approximate effectiveness of using a preset dictionary.
	fmt.Println("Substrings matched by the dictionary are marked with #:")
	hashDict := []byte(dict)
	for i := range hashDict {
		hashDict[i] = '#'
	}
	zr = flate.NewReaderDict(&b, hashDict)
	if _, err := io.Copy(os.Stdout, zr); err != nil {
		log.Fatal(err)
	}
	if err := zr.Close(); err != nil {
		log.Fatal(err)
	}
}


func DoZLibTest() {
	buff := []byte{120, 156, 202, 72, 205, 201, 201, 215, 81, 40, 207,
		47, 202, 73, 225, 2, 4, 0, 0, 255, 255, 33, 231, 4, 147}
	b := bytes.NewReader(buff)

	r, err := zlib.NewReader(b)
	if err != nil {
		panic(err)
	}
	io.Copy(os.Stdout, r)

	r.Close()
}