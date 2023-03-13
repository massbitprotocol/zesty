//go:build prod
// +build prod

package main

import (
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/configs"
)

func init() {
	common.DefaultConfig = configs.ProdConfig
}
