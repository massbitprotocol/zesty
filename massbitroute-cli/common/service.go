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

func (s Services) GatewayDetail(gatewayId string) string {
	return fmt.Sprintf("%s/%s", s.GatewayURL(), gatewayId)
}

func (s Services) GatewayBoot() string {
	return fmt.Sprintf("%s/boot", s.GatewayURL())
}
