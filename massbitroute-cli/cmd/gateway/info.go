package gateway

import (
	"fmt"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// GatewayInfoCmd represents the gatewayinfo command
func GatewayInfoCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "info",
		GroupID: "gateway",
		Short:   "Get gateway info",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("gatewayinfo called")
		},
	}
}
