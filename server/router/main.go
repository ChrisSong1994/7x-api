package router

import (
	"net/http"

	"github.com/QuantumNous/7x-api/middleware"

	"github.com/gin-gonic/gin"
)

func SetRouter(router *gin.Engine) {
	SetApiRouter(router)
	SetDashboardRouter(router)
	SetRelayRouter(router)
	SetVideoRouter(router)

	// API-only mode: frontend served separately by nginx
	// Handle 404 for API routes
	router.NoRoute(func(c *gin.Context) {
		c.Set(middleware.RouteTagKey, "api")
		c.JSON(http.StatusNotFound, gin.H{
			"success": false,
			"message": "API endpoint not found",
		})
	})
}
