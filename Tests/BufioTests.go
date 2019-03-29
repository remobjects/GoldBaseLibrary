package GoldLibrary.Tests.Shared;

import (
	"bufio"
	"fmt"
	"strings"
)

func DoScannerTest() bool {
	// An artificial input source.
	//const input = "1234 5678 1234567901234567890"
	const input = "1234 5678 1234567890"
	scanner := bufio.NewScanner(strings.NewReader(input))
	// Create a custom split function by wrapping the existing ScanWords function.
	split := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		advance, token, err = bufio.ScanWords(data, atEOF)
		if err == nil && token != nil {
			_, err = strconv.ParseInt(string(token), 10, 32)
		}
		return
	}
	// Set the split function for the scanning operation.
	scanner.Split(split)
	// Validate the input
	i := 0;
	lRes := make([]string, 3, 3);
	for scanner.Scan() {
		lRes[i] = scanner.Text()
		i++
	}

	if err := scanner.Err(); err != nil {
		fmt.Printf("Invalid input: %s", err)
	}

	var lOk bool
	if ((strings.Compare(lRes[0], "1234") == 0)  && (strings.Compare(lRes[1], "5678") == 0) && (strings.Compare(lRes[2], "1234567890") == 0)) {
		lOk = true
	} else {
		lOk = false
	}
	return (i == 3) && (lOk)
}

func DoScannerCommaSeparatedTest() Integer {
	// Comma-separated list; last entry is empty.
	const input = "1,2,3,4,"
	scanner := bufio.NewScanner(strings.NewReader(input))
	// Define a split function that separates on commas.
	onComma := func(data []byte, atEOF bool) (advance int, token []byte, err error) {
		for i := 0; i < len(data); i++ {
			if data[i] == ',' {
				return i + 1, data[:i], nil
			}
		}
		// There is one final token to be delivered, which may be the empty string.
		// Returning bufio.ErrFinalToken here tells Scan there are no more tokens after this
		// but does not trigger an error to be returned from Scan itself.
		return 0, data, bufio.ErrFinalToken
	}
	scanner.Split(onComma)
	// Scan.
	i := 0
	for scanner.Scan() {
		scanner.Text()
		i++
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading input:", err)
	}

	return i
}

func DoScannerCountWords() Integer {
	// An artificial input source.
	const input = "Now is the winter of our discontent,\nMade glorious summer by this sun of York.\n"
	scanner := bufio.NewScanner(strings.NewReader(input))
	// Set the split function for the scanning operation.
	scanner.Split(bufio.ScanWords)
	// Count the words.
	count := 0
	for scanner.Scan() {
		count++
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading input:", err)
	}

	return count
}