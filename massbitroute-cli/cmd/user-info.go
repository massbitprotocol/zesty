package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

// userCmd represents the user command
var userInfoCmd = &cobra.Command{
	Use:     "info",
	GroupID: "user",
	Short:   "View user infomation",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("user info called")
	},
}

func init() {
	userCmd.AddCommand(userInfoCmd)
}
