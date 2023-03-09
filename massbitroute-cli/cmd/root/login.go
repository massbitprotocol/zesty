package root

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
	"massbit.io/cli/mbr/utils"
)

// loginCmd represents the login command
func LoginCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "login",
		GroupID: "mbr",
		Short:   "Login user",
		Run: func(cmd *cobra.Command, args []string) {
			isLoggedIn, err := portalService.IsUserLoggedIn()
			if err != nil {
				log.Fatalln(err)
			}
			var loggedOut bool
			if isLoggedIn {
				ans, err := utils.AskBoolean("You are already logged in, do you want to logged out")
				if err != nil {
					log.Fatalln(err)
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
				log.Fatalln(err)
			}
			password, err := utils.AskSecret("And your password: ")
			if err != nil {
				log.Fatalln(err)
			}
			fmt.Println()
			_, err = portalService.UserLogin(email, string(password), loggedOut)
			if err == nil {
				fmt.Println("Login success!")
			} else {
				fmt.Printf("\n%v\n", err)
			}
		},
	}
}
