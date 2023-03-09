package cmd

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// logoutCmd represents the logout command
var logoutCmd = &cobra.Command{
	Use:     "logout",
	GroupID: "mbr",
	Short:   "Logout user",
	Run: func(cmd *cobra.Command, args []string) {
		conf, err := common.ReadConfig()
		if err != nil {
			log.Fatal(err)
		}
		portalService := services.PortalService{
			Url: conf.Services.Portal,
			FileService: services.FileService{
				Path: conf.Paths,
			},
		}
		isLoggedIn, err := portalService.IsUserLoggedIn()
		if err != nil {
			log.Fatal(err)
		}
		if isLoggedIn {
			fmt.Println("Logging out...")
			err = portalService.UserLogOut()
			if err != nil {
				log.Fatal(err)
			}
		} else {
			fmt.Println("You are not logged in!")
		}
	},
}

func init() {
	rootCmd.AddCommand(logoutCmd)
}
