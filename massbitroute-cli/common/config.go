package common

import (
	"fmt"

	"github.com/spf13/viper"
)

type Config struct {
	Services Services
	Paths    Paths
}

type Services struct {
	Portal string
	Fairy  string
}

type Paths struct {
	Root           string
	UserCredential string
	GatewayInfo    string
}

func ReadConfig() (*Config, error) {
	viper.SetConfigFile("configs/env.yaml")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")
	err := viper.ReadInConfig()
	if err != nil {
		return nil, err
	}
	var config Config
	viper.Unmarshal(&config)
	return &config, nil
}

func (p Paths) UserCredentialPath() string {
	return fmt.Sprintf("%s/%s", p.Root, p.UserCredential)
}

func (p Paths) GatewayInfoPath() string {
	return fmt.Sprintf("%s/%s", p.Root, p.GatewayInfo)
}
