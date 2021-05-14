package GoldLibrary.Tests.Shared;

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func DoGetTest() string {
	res, err := http.Get("http://www.google.com/robots.txt")
	if err != nil {
		log.Fatal(err)
	}
	robots, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		log.Fatal(err)
	}
	//fmt.Printf("%s", robots)
}

func DoSSLGetTest() string {
	res, err := http.Get("https://www.google.com/robots.txt")
	if err != nil {
		log.Fatal(err)
	}
	robots, err := ioutil.ReadAll(res.Body)
	res.Body.Close()
	if err != nil {
		log.Fatal(err)
	}
	//fmt.Printf("%s", robots)
}