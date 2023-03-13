package cmd

import (
	"log"
	"os"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/cmd/gateway"
	"massbit.io/cli/mbr/cmd/root"
	"massbit.io/cli/mbr/cmd/user"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/configs"
	"massbit.io/cli/mbr/services"
)

var rootCmd = &cobra.Command{
	Use:     "mbr",
	Version: configs.Version,
}
var userCmd = &cobra.Command{
	Use:     "user",
	GroupID: "mbr",
	Short:   "Group of user functions",
}
var gatewayCmd = &cobra.Command{
	Use:     "gateway",
	GroupID: "mbr",
	Short:   "Group of gateway functions",
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	conf, err := common.ReadConfig()
	if err != nil {
		log.Fatalln(err)
	}
	fileService := services.FileService{
		Dirs: conf.Directories,
	}
	portalService := services.PortalService{
		ServiceConf: conf.Services,
		FileService: fileService,
	}
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
	rootCmd.AddGroup(&cobra.Group{ID: "mbr"})
	rootCmd.AddCommand(root.LoginCmd(conf, portalService))
	rootCmd.AddCommand(root.LogoutCmd(conf, portalService))
	rootCmd.AddCommand(root.EnvCmd())

	// user
	rootCmd.AddCommand(userCmd)
	userCmd.AddGroup(&cobra.Group{ID: "user"})
	userCmd.AddCommand(user.UserInfoCmd(conf, portalService))

	// gateway
	rootCmd.AddCommand(gatewayCmd)
	gatewayCmd.AddGroup(&cobra.Group{ID: "gateway"})
	gatewayCmd.AddCommand(gateway.GatewayInfoCmd(conf, portalService))
	gatewayCmd.AddCommand(gateway.GatewayListCmd(conf, portalService))
	gatewayCmd.AddCommand(gateway.GatewayBootCmd(conf, fileService, portalService))
	gatewayCmd.AddCommand(gateway.GatewayCurrentCmd(conf, fileService))
}
