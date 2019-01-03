package GoldLibrary.Tests.Shared

import "fmt"
import b64 "encoding/base64"
import "encoding/binary"

func DoEncodeBase64() string {
	data := "abc123!?$*&()'-=@~"
	sEnc := b64.StdEncoding.EncodeToString([]byte(data))
	return sEnc
}

func DoDecodeBase64() string {
	data := "abc123!?$*&()'-=@~"
	sEnc := b64.StdEncoding.EncodeToString([]byte(data))

	sDec, _ := b64.StdEncoding.DecodeString(sEnc)
	return string(sDec)
}

func DoBinaryRead() float64 {
	var pi float64
	b := []byte{0x18, 0x2d, 0x44, 0x54, 0xfb, 0x21, 0x09, 0x40}
	buf := bytes.NewReader(b)
	err := binary.Read(buf, binary.LittleEndian, &pi)
	if err != nil {
		fmt.Println("binary.Read failed:", err)
	}
	fmt.Print(pi)
	return pi
}