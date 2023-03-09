package services

import (
	"fmt"
	"os"

	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/utils"
)

type FileService struct {
	Path common.Paths
}

func (s FileService) MkdirRoot() error {
	path, err := utils.MkHomePath(s.Path.Root)
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
	path, err = utils.MkHomePath(fmt.Sprintf("%s/%s", s.Path.Root, path))
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
	data, err := s.ReadRootFile(s.Path.UserCredential)
	if err != nil {
		return
	}
	// TODO: decrypt this token
	token = string(data)
	return
}

func (s FileService) WriteUserCredential(token string) (err error) {
	// TODO: encrypt this token
	err = s.WriteFile(s.Path.UserCredentialPath(), []byte(token))
	return
}

func (s FileService) RemoveUserCredential() error {
	return s.RemoveFile(s.Path.UserCredentialPath())
}
