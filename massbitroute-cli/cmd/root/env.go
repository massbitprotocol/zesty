package root

import (
	"fmt"

	"github.com/spf13/cobra"
	"massbit.io/cli/mbr/common"
)

// loginCmd represents the login command
func EnvCmd() *cobra.Command {
	return &cobra.Command{
		Use:     "env",
		GroupID: "mbr",
		Short:   "Check envionment",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println(common.DefaultConfig.Env)
		},
	}
}
