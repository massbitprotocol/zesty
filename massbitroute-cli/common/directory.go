package common

import "fmt"

type Directories struct {
	Root           string
	UserCredential string
	CurrentGateway string
}

func (d Directories) UserCredentialPath() string {
	return fmt.Sprintf("%s/%s", d.Root, d.UserCredential)
}

func (d Directories) CurrentGatewayPath() string {
	return fmt.Sprintf("%s/%s", d.Root, d.CurrentGateway)
}
