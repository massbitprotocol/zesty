package cmd

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
	"massbit.io/cli/mbr/utils"
)

// loginCmd represents the login command
var loginCmd = &cobra.Command{
	Use:     "login",
	GroupID: "mbr",
	Short:   "Login user",
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
		var loggedOut bool
		if isLoggedIn {
			ans, err := utils.AskBoolean("You are already logged in, do you want to logged out")
			if err != nil {
				log.Fatal(err)
			}
			if ans {
				loggedOut = true
			} else {
				fmt.Println("Ok, bye!")
				return
			}
		}

		email, err := utils.Ask("Please input your email: ")
		if err != nil {
			log.Fatal(err)
		}
		password, err := utils.AskSecret("And your password: ")
		if err != nil {
			log.Fatal(err)
		}
		_, err = portalService.UserLogin(email, string(password), loggedOut)
		if err == nil {
			fmt.Println("\nLogin success!")
		} else {
			fmt.Printf("\n%v\n", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(loginCmd)
}
