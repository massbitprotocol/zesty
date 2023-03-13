//go:build uat
// +build uat

package main

import (
	"massbit.io/cli/mbr/common"
	"massbit.io/cli/mbr/configs"
)

func init() {
	common.DefaultConfig = configs.UatConfig
}
