package common

import "fmt"

type Services struct {
	Portal string
	Fairy  string
}

func (s Services) AuthLogin() string {
	return fmt.Sprintf("%s/auth/login", s.Portal)
}

func (s Services) GatewayURL() string {
	return fmt.Sprintf("%s/mbr/gateway", s.Portal)
}

func (s Services) GatewayListFull() string {
	return fmt.Sprintf("%s/list-full", s.GatewayURL())
}
