package transaction

import (
	"ecommerce/core"
	"ecommerce/helpers"
	"ecommerce/products"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/spf13/cast"
)

type Services interface {
	CreateTransaction(buyerID string, productIDs []string, quantities []int) error
	GetTransactionByID(transactionID string) (core.Transaction, error)
	GetAllTransaction(buyerID string) ([]core.Transaction, error)
}

type services struct {
	repository        Repository
	productRepository products.Repository
}

func NewTransactionService(repository Repository, productRepository products.Repository) *services {
	return &services{repository, productRepository}
}

func (s *services) CreateTransaction(buyerID string, productIDs []string, quantities []int) error {
	// Validasi jumlah produk
	if len(productIDs) != len(quantities) {
		return errors.New("invalid product and quantity data")
	}

	// Buat transaksi baru
	transaction := core.Transaction{
		TransactionID:   "TRX_" + uuid.New().String(),
		BuyerID:         buyerID,
		TransactionDate: time.Now(),
		Status:          "Un-Paid",
		TotalAmount:     0, // Inisialisasi nilai TotalAmount dengan 0
		Details:         make([]core.DetailTransaction, 0),
	}

	// Iterasi produk dan jumlahnya
	for i := 0; i < len(productIDs); i++ {
		productID := productIDs[i]
		quantity := quantities[i]
		if quantity == 0 {
			return errors.New("invalid product and quantity data")
		}

		// Cari produk berdasarkan ID
		product, err := s.productRepository.GetProductByID(productID)
		if err != nil {
			return err
		}

		// Buat detail transaksi
		detail := core.DetailTransaction{
			DetailTransactionID: "DETAIL_" + helpers.GenerateUUID(),
			TransactionID:       transaction.TransactionID,
			ProductID:           productID,
			Quantity:            quantity,
			MerchantID:          product.MerchantID,
			Price:               cast.ToFloat64(product.ProductPrice),
			Subtotal:            cast.ToFloat64(product.ProductPrice) * float64(quantity),
		}

		// Tambahkan detail transaksi ke transaksi
		transaction.Details = append(transaction.Details, detail)
		transaction.TotalAmount += detail.Subtotal

	}

	// Simpan transaksi ke database
	if err := s.repository.CreateTransaction(transaction); err != nil {
		return err
	}

	return nil
}
func (s *services) GetTransactionByID(transactionID string) (core.Transaction, error) {
	return s.repository.GetTransactionByID(transactionID)
}

func (s *services) GetAllTransaction(buyerID string) ([]core.Transaction, error) {
	return s.repository.GetAllTransaction(buyerID)
}
