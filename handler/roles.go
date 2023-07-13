package handler

import (
	"ecommerce/helpers"
	"ecommerce/users"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *userHandler) SaveNewRole(c *gin.Context) {
	var request users.NewRoleRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	newRole, err := h.userServices.SaveNewRole(request)
	if err != nil {
		response := helpers.APIResponse("Failed To Save New Role", http.StatusUnprocessableEntity, "Failed", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	response := helpers.APIResponse("Success To Create New Role!", http.StatusOK, "Successfully", newRole)
	c.JSON(http.StatusOK, response)
}
