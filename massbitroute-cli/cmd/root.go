package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use: "mbr",
}
var userCmd = &cobra.Command{
	Use:     "user",
	GroupID: "mbr",
	Short:   "Group of user functions",
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
	rootCmd.AddGroup(&cobra.Group{ID: "mbr"})
	// user
	rootCmd.AddCommand(userCmd)
	userCmd.AddGroup(&cobra.Group{ID: "user"})
}
