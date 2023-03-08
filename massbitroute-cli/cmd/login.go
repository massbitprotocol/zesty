/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"syscall"

	"github.com/spf13/cobra"
	"golang.org/x/term"
	"massbit.io/massbitroute/cli/common"
	"massbit.io/massbitroute/cli/services"
)

// loginCmd represents the login command
var loginCmd = &cobra.Command{
	Use:   "login",
	Short: "Login as Massbit user",
	Long:  `Login as Massbit user`,
	Run: func(cmd *cobra.Command, args []string) {
		conf, err := common.ReadConfig()
		if err != nil {
			log.Fatal(err)
		}
		portalService := services.PortalService{
			Url: conf.Services.Portal,
		}
		reader := bufio.NewReader(os.Stdin)
		fmt.Print("Please input your email: ")
		email, err := reader.ReadString('\n')
		if err != nil {
			log.Fatal(err)
		}
		fmt.Print("And your password: ")
		password, err := term.ReadPassword(int(syscall.Stdin))
		if err != nil {
			log.Fatal(err)
		}
		_, err = portalService.Login(email, string(password))
		if err == nil {
			fmt.Println("\nLogin success!")
		} else {
			fmt.Printf("\n%v\n", err)
		}
	},
}

func init() {
	rootCmd.AddCommand(loginCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// loginCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// loginCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
