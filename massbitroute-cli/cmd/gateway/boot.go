package gateway

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
	"massbit.io/cli/mbr/utils"
)

var gatewayId string

// GatewayInfoCmd represents the gatewayinfo command
func GatewayBootCmd(
	conf *common.Config,
	fileService services.FileService,
	portalService services.PortalService,
) *cobra.Command {
	cmd := &cobra.Command{
		Use:     "boot",
		GroupID: "gateway",
		Short:   "Set current machine as gateway and boot it",
		Run: func(cmd *cobra.Command, args []string) {
			gw, err := portalService.GetGatewayDetail(gatewayId)
			if err != nil {
				log.Fatalln(err)
			}
			if gw == nil {
				log.Fatalln("gateway not found!")
			}
			current, err := fileService.GetCurrentGateway()
			if err != nil {
				log.Fatalln(err)
			}
			if current != nil {
				yes, err := utils.AskBoolean(fmt.Sprintf("This machine was set as gateway %s (%s), do you want to replace", gw.Name, gw.Id))
				if err != nil {
					log.Fatalln(err)
				}
				if !yes {
					return
				}
			}
			if err = portalService.GatewayBoot(gatewayId); err != nil {
				log.Fatalln(err)
			}
			if err = fileService.SetCurrentGateway(*gw); err != nil {
				log.Fatalln(err)
			}
			fmt.Printf("This machine was set as gateway %s\n", gw.Id)
		},
	}
	cmd.Flags().StringVar(&gatewayId, "id", "", "Gateway Id")
	cmd.MarkFlagRequired("id")

	return cmd
}
