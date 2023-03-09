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
	Url         string
	FileService FileService
}

func (s PortalService) IsUserLoggedIn() (isLoggedIn bool, err error) {
	token, err := s.FileService.ReadUserCredential()
	if err == nil && token != "" {
		// TODO: call portal API to check token
		isLoggedIn = true
	}
	return
}

func (s PortalService) UserLogin(email string, password string, loggedOut bool) (accessToken string, err error) {
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
		if loggedOut {
			fmt.Println("Logging out...")
			s.UserLogOut()
		}
		err = s.FileService.WriteUserCredential(accessToken)
	} else {
		err = errors.New("login failed, please check email and password again")
	}
	return
}

func (s PortalService) UserLogOut() (err error) {
	// TODO: check status of gateway before log out
	err = s.FileService.RemoveUserCredential()
	return
}
