package service

import (
	"github.com/QuantumNous/7x-api/setting/operation_setting"
	"github.com/QuantumNous/7x-api/setting/system_setting"
)

func GetCallbackAddress() string {
	if operation_setting.CustomCallbackAddress == "" {
		return system_setting.ServerAddress
	}
	return operation_setting.CustomCallbackAddress
}
