package gateway

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

// GatewayInfoCmd represents the gatewayinfo command
func GatewayListCmd(conf *common.Config, fileService services.FileService, portalService services.PortalService) *cobra.Command {
	return &cobra.Command{
		Use:     "list",
		GroupID: "gateway",
		Short:   "List all gateways",
		Run: func(cmd *cobra.Command, args []string) {
			gateways, err := portalService.ListGateway()
			if err != nil {
				log.Fatalln(err)
			}
			current, err := fileService.GetCurrentGateway()
			if err != nil {
				log.Fatalln(err)
			}
			fmt.Printf("%v gateway(s) found:\n", len(gateways))
			for _, gateway := range gateways {
				fmt.Printf("- %s (%s)", gateway.Name, gateway.Id)
				if current != nil && current.Id == gateway.Id {
					fmt.Print("    => current gateway")
				}
				fmt.Println()
			}
		},
	}
}
