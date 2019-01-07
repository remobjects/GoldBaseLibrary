package GoldLibrary.Tests.Shared

import "fmt"
import b64 "encoding/base64"
import "encoding/binary"
import "encoding/hex"

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
	return pi
}

func DoBinaryPutUvarint(data uint64) []byte {
	buf := make([]byte, binary.MaxVarintLen64)
	n := binary.PutUvarint(buf, data)
	return buf[:n]
}

func DoEncodingHexDecode() string {
	const s = "48656c6c6f20476f7068657221"
	decoded, err := hex.DecodeString(s)
	if err != nil {
		log.Fatal(err)
	}

	return string(decoded)
}

func DoEncodingHexEncode() []byte {
	src := []byte("Hello Gopher!")

	dst := make([]byte, hex.EncodedLen(len(src)))
	hex.Encode(dst, src)
	return dst
}