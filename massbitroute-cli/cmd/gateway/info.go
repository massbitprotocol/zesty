package gateway

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

func GatewayInfoCmd(conf *common.Config, portalService services.PortalService) *cobra.Command {
	cmd := &cobra.Command{
		Use:     "info",
		GroupID: "gateway",
		Short:   "Get gateway info",
		Run: func(cmd *cobra.Command, args []string) {
			gw, err := portalService.GetGatewayDetail(gatewayId)
			if err != nil {
				log.Fatalln(err)
			}
			fmt.Printf(`- id: %s
- name: %s
- blockchain: %s
- network: %s
- ip: %s
`,
				gw.Id,
				gw.Name,
				gw.Blockchain,
				gw.Network,
				gw.Ip)
		},
	}
	cmd.Flags().StringVar(&gatewayId, "id", "", "Gateway Id")
	cmd.MarkFlagRequired("id")

	return cmd
}
