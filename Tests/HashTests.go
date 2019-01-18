package GoldLibrary.Tests.Shared

import (
	"bytes"
	"crypto/sha256"
	"encoding"
	"fmt"
	"log"
)

func DoHashTest() Boolean {
		const (
		input1 = "The tunneling gopher digs downwards, "
		input2 = "unaware of what he will find."
		)

		first := sha256.New()
		first.Write([]byte(input1))

		marshaler, ok := first.(encoding.BinaryMarshaler)
		if !ok {
			log.Fatal("first does not implement encoding.BinaryMarshaler")
		}
		state, err := marshaler.MarshalBinary()
		if err != nil {
			log.Fatal("unable to marshal hash:", err)
		}

		second := sha256.New()

		unmarshaler, ok := second.(encoding.BinaryUnmarshaler)
		if !ok {
			log.Fatal("second does not implement encoding.BinaryUnmarshaler")
		}
		if err := unmarshaler.UnmarshalBinary(state); err != nil {
			log.Fatal("unable to unmarshal hash:", err)
		}

		first.Write([]byte(input2))
		second.Write([]byte(input2))
		return bytes.Equal(first.Sum(nil), second.Sum(nil))

		//fmt.Printf("%x\n", first.Sum(nil))
		//fmt.Printf("%x\n", second.Sum(nil))
		//fmt.Println(bytes.Equal(first.Sum(nil), second.Sum(nil)))
}

func DoCrash() {
	fmt.Println(true)
}