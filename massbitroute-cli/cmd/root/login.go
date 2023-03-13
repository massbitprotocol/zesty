package root

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
	"massbit.io/cli/mbr/utils"
)

var (
	email, password string
	forceLogout     bool
)

func LoginCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	var cmd = &cobra.Command{
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
				if forceLogout {
					loggedOut = true
				} else {
					var ans bool
					if ans, err = utils.AskBoolean("You are already logged in, do you want to logged out"); err != nil {
						log.Fatalln(err)
					}
					if ans {
						loggedOut = true
					} else {
						fmt.Println("Ok, bye!")
						return
					}
				}
			}

			if email == "" {
				if email, err = utils.Ask("Please input your email: "); err != nil {
					log.Fatalln(err)
				}
			}
			if password == "" {
				passwordTmp, err := utils.AskSecret("And your password: ")
				if err != nil {
					log.Fatalln(err)
				}
				password = string(passwordTmp)
			}
			_, err = portalService.UserLogin(email, string(password), loggedOut)
			if err == nil {
				fmt.Println("Login success!")
			} else {
				fmt.Printf("\n%v\n", err)
			}
		},
	}
	cmd.Flags().StringVarP(&email, "email", "e", "", "email")
	cmd.Flags().StringVarP(&password, "password", "p", "", "password")
	cmd.Flags().BoolVarP(&forceLogout, "force-logout", "f", false, "force logout if already login")
	return cmd
}
