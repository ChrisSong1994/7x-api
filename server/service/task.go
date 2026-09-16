package service

import (
	"strings"

	"github.com/ChrisSong1994/7x-api/constant"
)

func CoverTaskActionToModelName(platform constant.TaskPlatform, action string) string {
	return strings.ToLower(string(platform)) + "_" + strings.ToLower(action)
}
