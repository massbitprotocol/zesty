package gateway

import (
	"fmt"
	"log"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/services"
)

func GatewayCurrentCmd(conf *common.Config, fileService services.FileService) *cobra.Command {
	cmd := &cobra.Command{
		Use:     "current",
		GroupID: "gateway",
		Short:   "Get gateway info of this machine",
		Run: func(cmd *cobra.Command, args []string) {
			current, err := fileService.GetCurrentGateway()
			if err != nil {
				log.Fatalln(current)
			}
			if current == nil {
				fmt.Println("This machine was not set as gateway!")
			} else {
				fmt.Printf(`- id: %s
- name: %s
- blockchain: %s
- network: %s
- ip: %s
`,
					current.Id,
					current.Name,
					current.Blockchain,
					current.Network,
					current.Ip)
			}
		},
	}

	return cmd
}
