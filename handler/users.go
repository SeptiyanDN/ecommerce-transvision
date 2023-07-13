package handler

import (
	"ecommerce/authorization"
	"ecommerce/helpers"
	"ecommerce/users"
	"net/http"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/gin-gonic/gin"
	"github.com/spf13/cast"
)

type userHandler struct {
	userServices users.Services
	authServices authorization.Services
}

func NewUserHandler(userServices users.Services, authServices authorization.Services) *userHandler {
	return &userHandler{userServices, authServices}
}

func (h *userHandler) RegisterUser(c *gin.Context) {
	s3 := c.MustGet("S3").(*session.Session)

	var request users.RegisterUserRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}

	result, err := h.userServices.RegisterUser(s3, request)
	if err != nil {
		response := helpers.APIResponse("Register Account Failed", http.StatusBadRequest, "error", err.Error())
		c.JSON(http.StatusBadRequest, response)
		return
	}

	response := helpers.APIResponse("Account Has Been Created", http.StatusOK, "success", result)
	c.JSON(http.StatusOK, response)
}

func (h *userHandler) Login(c *gin.Context) {
	var request users.LoginRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}

	loggedinUser, err := h.userServices.Login(request)
	if err != nil {
		errorMessage := gin.H{"error": err.Error()}
		response := helpers.APIResponse("Login Failed", http.StatusUnprocessableEntity, "error", errorMessage)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	if !loggedinUser.Verification {
		response := helpers.APIResponse("Login Failed! You Must Verification Before Login. Thank You", http.StatusUnauthorized, "Un-Verified", false)
		c.JSON(http.StatusUnauthorized, response)
		return
	}

	token, refreshTokenString, err := h.authServices.GenerateJWT(loggedinUser.Uuid, loggedinUser.Username, loggedinUser.MerchantID, loggedinUser.RoleID, cast.ToString(loggedinUser.Verification))
	if err != nil {
		response := helpers.APIResponse("Login Failed", http.StatusUnprocessableEntity, "error", err.Error())
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	result := map[string]interface{}{
		"token":         token,
		"refresh_token": refreshTokenString,
		"uuid":          loggedinUser.Uuid,
		"merchant_id":   loggedinUser.MerchantID,
		"verified":      loggedinUser.Verification,
	}

	// formatter := users.FormatUserLogin(token)
	response := helpers.APIResponse("Login Successfully", http.StatusOK, "success", result)
	c.JSON(http.StatusOK, response)
}

func (controller *userHandler) RefreshToken(c *gin.Context) {
	var request users.RefreshTokenRequest

	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}

	// Validasi refresh token
	refreshToken, err := controller.authServices.ValidateToken(request.RefreshToken)
	if err != nil {
		response := helpers.APIResponse("Invalid refresh token", http.StatusUnauthorized, "error", nil)
		c.JSON(http.StatusUnauthorized, response)
		return
	}

	claims, ok := refreshToken.Claims.(*authorization.JWTClaim)
	if !ok || !refreshToken.Valid {
		response := helpers.APIResponse("Invalid refresh token", http.StatusUnauthorized, "error", nil)
		c.JSON(http.StatusUnauthorized, response)
		return
	}

	// Generate token akses baru
	uuid, _ := helpers.DecryptString(claims.Uuid)
	username, _ := helpers.DecryptString(claims.Username)
	merchantID, _ := helpers.DecryptString(claims.MerchantID)
	roleID, _ := helpers.DecryptString(claims.RoleID)
	verif, _ := helpers.DecryptString(claims.Verificaction)

	tokenString, refreshTokenString, err := controller.authServices.GenerateJWT(uuid, username, merchantID, roleID, verif)
	if err != nil {
		response := helpers.APIResponse("Failed to generate new access token", http.StatusInternalServerError, "error", nil)
		c.JSON(http.StatusInternalServerError, response)
		return
	}

	// Merespon token akses baru
	response := helpers.APIResponse("New access token generated", http.StatusOK, "success", gin.H{
		"token":         tokenString,
		"refresh_token": refreshTokenString,
	})
	c.JSON(http.StatusOK, response)
}

func (h *userHandler) Verification(c *gin.Context) {
	var request users.VerificationRequest
	err := c.ShouldBind(&request)
	if err != nil {
		error_request := helpers.ErrorEntityRequest(err)
		response := helpers.APIResponse("Request Invalid! Please Check Your Request", http.StatusUnprocessableEntity, "Failed", error_request)
		c.JSON(http.StatusUnprocessableEntity, response)
		return
	}
	verification, err := h.userServices.Verification(request)
	if !verification {
		response := helpers.APIResponse("Failed To Verification. Please Check Your Credentials", http.StatusUnauthorized, "Failed", err.Error())
		c.JSON(http.StatusUnauthorized, response)
		return
	}
	response := helpers.APIResponse("Success To Verification. Please Login Using Your Credentials", http.StatusOK, "Successfully", true)
	c.JSON(http.StatusOK, response)

}
