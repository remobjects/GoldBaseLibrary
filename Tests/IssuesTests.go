package GoldLibrary.Tests.Shared

import (
	"fmt"
)

type span struct {
	start, end int
}

func DoAppendArrayTest() bool {
	var pendingAttr   [2]span
	var attr          [][2]span
	pendingAttr[0].start = 1
	pendingAttr[0].end = 2
	pendingAttr[1].start = 3
	pendingAttr[1].end = 4

	attr = append(attr, pendingAttr)
	attr[0][0].start = 200;

	return pendingAttr[0].start == 1
}