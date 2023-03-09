package utils

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"syscall"

	"golang.org/x/term"
)

var reader = bufio.NewReader(os.Stdin)

func AskBoolean(question string) (ans bool, err error) {
	answer, err := Ask(fmt.Sprintf("%s? (y|n) ", question))
	if err != nil {
		return
	}
	answer = strings.ToLower(answer)
	if answer == "y" || answer == "yes" || answer == "" {
		ans = true
	}
	return
}

func Ask(question string) (answer string, err error) {
	fmt.Print(question)
	answer, err = reader.ReadString('\n')
	if err == nil {
		return strings.TrimSpace(answer), nil
	}
	return
}

func AskSecret(question string) (answer []byte, err error) {
	fmt.Print(question)
	answer, err = term.ReadPassword(int(syscall.Stdin))
	return
}
