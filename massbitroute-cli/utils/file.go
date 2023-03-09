package utils

import (
	"os"
	"strings"
)

func MkHomePath(path string) (string, error) {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return strings.ReplaceAll(path, "~", homeDir), nil
}
