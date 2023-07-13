package handler

import (
	"ecommerce/authorization"
	"ecommerce/categories"
	"ecommerce/helpers"
	"net/http"

	"github.com/gin-gonic/gin"
)

type categoryHandler struct {
	services categories.Services
}

func NewCategoryHandler(services categories.Services) *categoryHandler {
	return &categoryHandler{services}
}

func (h *categoryHandler) CreateNewCategory(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	merchant_id, _ := helpers.DecryptString(current.MerchantID)
	var request categories.CreateCategoryRequest
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
	save, err := h.services.Save(request, merchant_id)
	if err != nil {
		response := helpers.APIResponse("Failed To Create New Data Category", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Create New Data Category", http.StatusOK, "Success", save)
	c.JSON(http.StatusOK, response)

}

func (h *categoryHandler) ListAllCategory(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	result := h.services.ListAllCategory(current)
	response := helpers.APIResponse("Success To Get All Data Category", http.StatusOK, "Success", result)
	c.JSON(http.StatusOK, response)
}
