package utils

import (
	"fmt"
	"io"
	"net/http"
	"strings"
)

func GetResponseBody(res *http.Response) (body string, err error) {
	buf := new(strings.Builder)
	if _, err = io.Copy(buf, res.Body); err != nil {
		return
	}
	body = buf.String()
	return
}

func ResponseError(res *http.Response) error {
	if body, err := GetResponseBody(res); err != nil {
		return err
	} else {
		return fmt.Errorf("ERROR %v: %s", res.StatusCode, body)
	}
}
