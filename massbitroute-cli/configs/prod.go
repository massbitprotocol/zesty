package configs

import "massbit.io/cli/mbr/common"

var ProdConfig = common.Config{
	Env: "prod",
	Services: common.Services{
		Portal: "http://portal-beta.massbitroute.net",
	},
	Directories: common.Directories{
		Root:           "~/.mbr",
		UserCredential: ".credential",
		CurrentGateway: "current-gateway.json",
	},
}
