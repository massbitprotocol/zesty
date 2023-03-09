package gateway

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// GatewayInfoCmd represents the gatewayinfo command
func GatewayListCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "list",
		GroupID: "gateway",
		Short:   "List all gateways",
		Run: func(cmd *cobra.Command, args []string) {
			gateways, err := portalService.ListGateway()
			if err != nil {
				log.Fatal(err)
			}
			fmt.Printf("%v gateway(s) found:\n", len(gateways))
			for _, gateway := range gateways {
				// TODO: mark current gateway
				fmt.Printf("- %s (%s)\n", gateway.Name, gateway.Id)
			}
		},
	}
}
