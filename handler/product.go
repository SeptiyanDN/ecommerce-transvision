package handler

import (
	"ecommerce/authorization"
	"ecommerce/helpers"
	"ecommerce/products"
	"net/http"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/gin-gonic/gin"
)

type productHandler struct {
	services products.Services
}

func NewProductHandler(services products.Services) *productHandler {
	return &productHandler{services}
}

func (h *productHandler) CreateNewProduct(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	s3 := c.MustGet("S3").(*session.Session)
	merchant_id, _ := helpers.DecryptString(current.MerchantID)

	var request products.CreateProductRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	if merchant_id == "" {
		response := helpers.APIResponse("If You have created a new merchant, you must re-login!, if you don't have a merchant yet, you must register a merchant", http.StatusBadRequest, "Failed", false)
		c.JSON(http.StatusBadRequest, response)
		return
	}
	save, err := h.services.CreateNewProduct(s3, request)
	if err != nil {
		response := helpers.APIResponse("Failed To Create New Data Products", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Create New Data Products", http.StatusOK, "Success", save)
	c.JSON(http.StatusOK, response)

}
func (h *productHandler) UpdateProduct(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	s3 := c.MustGet("S3").(*session.Session)
	merchant_id, _ := helpers.DecryptString(current.MerchantID)
	product_id := c.Param("product_id")
	var request products.CreateProductRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	if merchant_id == "" {
		response := helpers.APIResponse("If You have created a new merchant, you must re-login!, if you don't have a merchant yet, you must register a merchant", http.StatusBadRequest, "Failed", false)
		c.JSON(http.StatusBadRequest, response)
		return
	}
	save, err := h.services.UpdateProduct(s3, product_id, merchant_id, request)
	if err != nil {
		response := helpers.APIResponse("Failed To Update Data Products", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Update Data Products", http.StatusOK, "Success", save)
	c.JSON(http.StatusOK, response)

}
func (h *productHandler) DeleteProduct(c *gin.Context) {
	product_id := c.Param("product_id")
	err := h.services.DeleteProduct(product_id)
	if err != nil {
		response := helpers.APIResponse("Failed To Remove Data Products", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Remove Data Products", http.StatusOK, "Success", true)
	c.JSON(http.StatusOK, response)

}

func (h *productHandler) GetAllProduct(c *gin.Context) {
	rows, err := h.services.GetAllProducts()
	if err != nil {
		response := helpers.APIResponse("Failed To Get Data Products", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Get Data Products", http.StatusOK, "Success", rows)
	c.JSON(http.StatusOK, response)
}
