package user

import (
	"fmt"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// userCmd represents the user command
func UserInfoCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "info",
		GroupID: "user",
		Short:   "View user infomation",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("user info called")
		},
	}
}
