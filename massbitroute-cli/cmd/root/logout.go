package root

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// logoutCmd represents the logout command
func LogoutCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "logout",
		GroupID: "mbr",
		Short:   "Logout user",
		Run: func(cmd *cobra.Command, args []string) {
			isLoggedIn, err := portalService.IsUserLoggedIn()
			if err != nil {
				log.Fatalln(err)
			}
			if isLoggedIn {
				fmt.Println("Logging out...")
				err = portalService.UserLogOut()
				if err != nil {
					log.Fatalln(err)
				}
			} else {
				fmt.Println("You are not logged in!")
			}
		},
	}
}
