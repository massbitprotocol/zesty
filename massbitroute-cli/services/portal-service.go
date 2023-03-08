package services

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
)

type PortalService struct {
	Url string
}

func (s PortalService) Login(email string, password string) (accessToken string, err error) {
	URL := fmt.Sprintf("%v/auth/login", s.Url)
	values := map[string]string{"email": strings.TrimSpace(email), "password": strings.TrimSpace(string(password))}
	json_data, err := json.Marshal(values)

	if err != nil {
		return
	}
	// Get the data
	response, err := http.Post(URL, "application/json", bytes.NewBuffer(json_data))
	if err != nil {
		return
	}
	defer response.Body.Close()
	var res map[string]interface{}

	json.NewDecoder(response.Body).Decode(&res)
	if response.StatusCode == 200 || response.StatusCode == 201 {
		accessToken = res["accessToken"].(string)
	} else {
		err = errors.New("login failed, please try again")
	}
	return
}
