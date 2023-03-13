package configs

import "massbit.io/cli/mbr/common"

var UatConfig = common.Config{
	Env: "uat",
	Services: common.Services{
		Portal: "http://portal-beta.massbitroute.net",
	},
	Directories: common.Directories{
		Root:           "~/.mbr",
		UserCredential: ".credential",
		CurrentGateway: "current-gateway.json",
	},
}
