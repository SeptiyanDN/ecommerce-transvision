package handler

import (
	"ecommerce/authorization"
	"ecommerce/checkout"
	"ecommerce/helpers"
	"net/http"

	"github.com/gin-gonic/gin"
)

type checkoutHandler struct {
	services checkout.CheckoutService
}

func NewCheckOutHandler(services checkout.CheckoutService) *checkoutHandler {
	return &checkoutHandler{services}
}

func (h *checkoutHandler) CheckOutOrders(c *gin.Context) {
	var request checkout.CheckoutRequest
	current := c.MustGet("current").(*authorization.JWTClaim)
	uuid, _ := helpers.DecryptString(current.Uuid)
	if err := c.ShouldBindJSON(&request); err != nil {
		response := helpers.APIResponse("Invalid Request", http.StatusBadRequest, "Failed", err.Error())
		c.JSON(http.StatusBadRequest, response)
		return
	}
	err := h.services.ProcessCheckout(request, uuid)
	if err != nil {
		response := helpers.APIResponse("Failed", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Checkout And Payment Your Orders! Thank You", http.StatusOK, "Succcess", true)
	c.JSON(http.StatusOK, response)
}

func (h *checkoutHandler) HistoryPayment(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	uuid, _ := helpers.DecryptString(current.Uuid)
	rows := h.services.HistoryPayment(uuid)
	response := helpers.APIResponse("Success", http.StatusOK, "Succcess", rows)
	c.JSON(http.StatusOK, response)
}
