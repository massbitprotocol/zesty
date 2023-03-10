package common

import (
	"log"
	"os"

	"github.com/spf13/viper"
	"massbit.io/cli/mbr/utils"
)

type Config struct {
	Services    Services
	Directories Directories
}

func ReadConfig() (config *Config, err error) {
	var configFile = os.Getenv("MBR_CONFIG_FILE")
	if configFile == "" {
		configFile = "configs/env.yaml"
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
