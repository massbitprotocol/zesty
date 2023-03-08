package common

import (
	"github.com/spf13/viper"
)

type Config struct {
	Services Services
}

type Services struct {
	Portal string
	Fairy  string
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
