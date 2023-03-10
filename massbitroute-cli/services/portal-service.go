package services

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strings"

	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/models"
	"massbit.io/cli/mbr/utils"
)

type PortalService struct {
	ServiceConf common.Services
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
	values := map[string]string{"email": strings.TrimSpace(email), "password": strings.TrimSpace(string(password))}
	json_data, err := json.Marshal(values)

	if err != nil {
		return
	}
	// Get the data
	response, err := http.Post(s.ServiceConf.AuthLogin(), "application/json", bytes.NewBuffer(json_data))
	if err != nil {
		return
	}
	defer response.Body.Close()
	var res map[string]interface{}

	if response.StatusCode == 200 || response.StatusCode == 201 {
		err = json.NewDecoder(response.Body).Decode(&res)
		if err != nil {
			return
		}
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

func (s PortalService) ListGateway() (result []*models.Gateway, err error) {
	request, err := s.NewAuthenticatedRequest("GET", s.ServiceConf.GatewayListFull(), nil)
	if err != nil {
		return
	}
	res, err := (&http.Client{}).Do(request)
	if err != nil {
		return
	}
	defer res.Body.Close()

	if res.StatusCode == 200 {
		err = json.NewDecoder(res.Body).Decode(&result)
	} else {
		return nil, utils.ResponseError(res)
	}
	return
}

func (s PortalService) GetGatewayDetail(gatewayId string) (result *models.Gateway, err error) {
	request, err := s.NewAuthenticatedRequest("GET", s.ServiceConf.GatewayDetail(gatewayId), nil)
	if err != nil {
		return
	}
	res, err := (&http.Client{}).Do(request)
	if err != nil {
		return
	}
	defer res.Body.Close()

	if res.StatusCode == 200 {
		result = &models.Gateway{}
		err = json.NewDecoder(res.Body).Decode(result)
	} else {
		return nil, utils.ResponseError(res)
	}
	return
}

func (s PortalService) GatewayBoot(gatewayId string) (err error) {
	data := map[string]string{
		"gatewayId": gatewayId,
	}
	txt, err := json.Marshal(data)
	if err != nil {
		return
	}
	request, err := s.NewAuthenticatedRequest("POST", s.ServiceConf.GatewayBoot(), strings.NewReader(string(txt)))
	if err != nil {
		return
	}
	res, err := (&http.Client{}).Do(request)
	if err != nil {
		return
	}
	defer res.Body.Close()
	if res.StatusCode < 200 {
		return utils.ResponseError(res)
	}
	return
}

func (s PortalService) NewAuthenticatedRequest(method string, url string, body io.Reader) (*http.Request, error) {
	request, err := http.NewRequest(method, url, body)
	if err != nil {
		return nil, err
	}
	token, err := s.FileService.ReadUserCredential()
	if err != nil {
		return nil, err
	}
	request.Header.Add("Authorization", fmt.Sprintf("Bearer %s", token))
	return request, nil
}
