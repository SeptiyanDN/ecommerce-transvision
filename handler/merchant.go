package handler

import (
	"ecommerce/authorization"
	"ecommerce/helpers"
	"ecommerce/merchant"
	"net/http"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/gin-gonic/gin"
)

type merchantHandler struct {
	services merchant.Services
}

func NewMerchantHandler(services merchant.Services) *merchantHandler {
	return &merchantHandler{services}
}

func (h *merchantHandler) RegistrasiMerchant(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	s3 := c.MustGet("S3").(*session.Session)
	uuid, _ := helpers.DecryptString(current.Uuid)
	merchant_id, _ := helpers.DecryptString(current.MerchantID)

	var request merchant.CreateMerchantRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	if merchant_id != "" {
		response := helpers.APIResponse("Failed To Registered Merchant! You Already Have a Merchant", http.StatusBadRequest, "Failed", err.Error())
		c.JSON(http.StatusBadRequest, response)
		return
	}

	registrasi, err := h.services.RegistrasiMerchant(s3, uuid, request)
	if err != nil {
		response := helpers.APIResponse("Failed To Registered Merchant! Please Contact Admin Support", http.StatusBadRequest, "Failed", err.Error())
		c.JSON(http.StatusBadRequest, response)
		return
	}
	response := helpers.APIResponse("Congratulation. Success To Register New Merchant!", http.StatusOK, "Successfully", registrasi)
	c.JSON(http.StatusOK, response)
}
