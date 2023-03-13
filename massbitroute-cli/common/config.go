package common

import (
	"log"
	"os"

	"github.com/spf13/viper"
	"massbit.io/cli/mbr/utils"
)

type Config struct {
	Env         string
	Services    Services
	Directories Directories
}

var DefaultConfig Config

func ReadConfig() (config *Config, err error) {
	var configFile = os.Getenv("MBR_CONFIG_FILE")
	if configFile == "" {
		return &DefaultConfig, nil
	} else {
		configFile, err = utils.MkHomePath(configFile)
		if err != nil {
			log.Fatalln(err)
		}
	}
	viper.SetConfigFile(configFile)
	viper.SetConfigType("yaml")
	// viper.AddConfigPath(".")
	err = viper.ReadInConfig()
	if err != nil {
		return nil, err
	}
	config = &Config{}
	viper.Unmarshal(&config)
	return
}
