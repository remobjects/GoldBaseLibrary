package GoldLibrary.Tests.Shared;

import (
	"fmt"
)

const (
	secondsPerDay = 24 * 60 * 60
	// The unsigned zero year for internal calculations.
	// Must be 1 mod 400, and times before it will not compute correctly,
	// but otherwise can be changed at will.
	absoluteZeroYear = -292277022399

	// The year of the zero Time.
	// Assumed by the unixToInternal computation below.
	internalYear = 1

	// Offsets to convert between internal and absolute or Unix times.
	absoluteToInternal int64 = (absoluteZeroYear - internalYear) * 365.2425 * secondsPerDay

	unixToInternal int64 = (1969*365 + 1969/4 - 1969/100 + 1969/400) * secondsPerDay

	wallToInternal int64 = (1884*365 + 1884/4 - 1884/100 + 1884/400) * secondsPerDay
)

func CheckAbsoluteToInternal() int64 {
	return absoluteToInternal;
}

func DoSliceTest() Boolean {
	b := make([]int, 0, 5) // len(b)=0, cap(b)=5
	if len(b) != 0 || cap(b) != 5{
		return false
	}

	a := make([]int, 5);
	if len(a) != 5 || cap(a) != 5{
		return false
	}

	b = a[:cap(b)] // len(b)=5, cap(b)=5
	if len(b) != 5 || cap(b) != 5{
		return false
	}

	b = b[1:]      // len(b)=4, cap(b)=4
	if len(b) != 4 || cap(b) != 4{
		return false
	}

	return true;
}