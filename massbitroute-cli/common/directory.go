package common

import "fmt"

type Directories struct {
	Root           string
	UserCredential string
	GatewayInfo    string
}

func (d Directories) UserCredentialPath() string {
	return fmt.Sprintf("%s/%s", d.Root, d.UserCredential)
}

func (d Directories) GatewayInfoPath() string {
	return fmt.Sprintf("%s/%s", d.Root, d.GatewayInfo)
}
