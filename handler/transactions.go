package handler

import (
	"ecommerce/authorization"
	"ecommerce/helpers"
	"ecommerce/transaction"
	"net/http"

	"github.com/gin-gonic/gin"
)

type transactionHandler struct {
	services transaction.Services
}

func NewTransactionHandler(services transaction.Services) *transactionHandler {
	return &transactionHandler{services}
}

func (h *transactionHandler) CreateTransaction(c *gin.Context) {
	// Mendapatkan buyerID dari JWT
	current := c.MustGet("current").(*authorization.JWTClaim)
	buyerID, _ := helpers.DecryptString(current.Uuid)

	// Mendapatkan productIDs dan quantities dari body JSON
	var requestBody struct {
		Product []struct {
			ProductID string `json:"product_id"`
			Quantity  int    `json:"quantity"`
		} `json:"product"`
	}
	if err := c.ShouldBindJSON(&requestBody); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	// Mengambil productIDs dan quantities dari requestBody
	productIDs := make([]string, len(requestBody.Product))
	quantities := make([]int, len(requestBody.Product))
	for i, item := range requestBody.Product {
		productIDs[i] = item.ProductID
		quantities[i] = item.Quantity
	}

	// Memanggil service untuk membuat transaksi
	err := h.services.CreateTransaction(buyerID, productIDs, quantities)
	if err != nil {
		response := helpers.APIResponse("Oh No! Create New Order Failed", http.StatusBadRequest, "Success", false)
		c.JSON(http.StatusBadRequest, response)
		return
	}
	response := helpers.APIResponse("Congratulations. Order Success Replaced! Status Pending. Please Payment Your Order. Thank You", http.StatusOK, "Success", true)
	c.JSON(http.StatusOK, response)
}

func (h *transactionHandler) GetTransactionByID(c *gin.Context) {
	transaction_id := c.Param("transaction_id")
	transaction, err := h.services.GetTransactionByID(transaction_id)
	if err != nil {
		response := helpers.APIResponse("Oh No! Failed To Get Detail Transactions", http.StatusBadRequest, "Success", false)
		c.JSON(http.StatusBadRequest, response)
		return
	}
	response := helpers.APIResponse("Congratulations. Success To Get Detail Transactions BY ID", http.StatusOK, "Success", transaction)
	c.JSON(http.StatusOK, response)
}

func (h *transactionHandler) GetAllTransactions(c *gin.Context) {
	current := c.MustGet("current").(*authorization.JWTClaim)
	buyerID, _ := helpers.DecryptString(current.Uuid)
	rows, err := h.services.GetAllTransaction(buyerID)
	if err != nil {
		response := helpers.APIResponse("Oh No! Failed To Get List History Transaction", http.StatusBadRequest, "Success", false)
		c.JSON(http.StatusBadRequest, response)
		return
	}
	response := helpers.APIResponse("Congratulations. Success To Get History Transactions Users", http.StatusOK, "Success", rows)
	c.JSON(http.StatusOK, response)
}
