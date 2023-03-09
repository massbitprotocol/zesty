package services

import (
	"encoding/json"
	"fmt"
	"os"

	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/models"
	"massbit.io/cli/mbr/utils"
)

type FileService struct {
	Dirs common.Directories
}

func (s FileService) MkdirRoot() error {
	path, err := utils.MkHomePath(s.Dirs.Root)
	if err != nil {
		return err
	}
	err = os.Mkdir(path, os.ModePerm)
	if os.IsExist(err) {
		return nil
	}
	return err
}

func (s FileService) ReadRootFile(path string) (data []byte, err error) {
	path, err = utils.MkHomePath(fmt.Sprintf("%s/%s", s.Dirs.Root, path))
	if err != nil {
		return
	}
	err = s.MkdirRoot()
	if err != nil {
		return
	}
	data, err = os.ReadFile(path)
	if err != nil && os.IsNotExist(err) {
		return nil, nil
	}
	return
}

func (s FileService) WriteFile(path string, data []byte) (err error) {
	path, err = utils.MkHomePath(path)
	if err != nil {
		return
	}
	err = os.WriteFile(path, data, os.ModePerm)
	return
}

func (s FileService) RemoveFile(path string) (err error) {
	path, err = utils.MkHomePath(path)
	if err != nil {
		return
	}
	err = os.Remove(path)
	return
}

func (s FileService) ReadUserCredential() (token string, err error) {
	data, err := s.ReadRootFile(s.Dirs.UserCredential)
	if err != nil {
		return
	}
	// TODO: decrypt this token
	token = string(data)
	return
}

func (s FileService) WriteUserCredential(token string) (err error) {
	// TODO: encrypt this token
	err = s.WriteFile(s.Dirs.UserCredentialPath(), []byte(token))
	return
}

func (s FileService) RemoveUserCredential() error {
	return s.RemoveFile(s.Dirs.UserCredentialPath())
}

func (s FileService) GetCurrentGateway() (gw *models.Gateway, err error) {
	data, err := s.ReadRootFile(s.Dirs.CurrentGateway)
	if err != nil {
		return
	}
	if string(data) == "" {
		return nil, nil
	}
	gw = &models.Gateway{}
	err = json.Unmarshal(data, gw)
	return
}

func (s FileService) SetCurrentGateway(gw models.Gateway) (err error) {
	data, err := json.Marshal(gw)
	if err != nil {
		return
	}
	err = s.WriteFile(s.Dirs.CurrentGatewayPath(), data)
	return
}
