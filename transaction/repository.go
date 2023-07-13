package transaction

import (
	"ecommerce/core"
	"ecommerce/privatehelpers"
	"fmt"

	"gorm.io/gorm"
)

type Repository interface {
	CreateTransaction(transaction core.Transaction) error
	GetTransactionByID(transactionID string) (core.Transaction, error)
	GetAllTransaction(buyerID string) ([]core.Transaction, error)
}

type repository struct {
	db  *gorm.DB
	dbs privatehelpers.DBStruct
}

func NewRepository(db *gorm.DB, dbs privatehelpers.DBStruct) *repository {
	return &repository{db, dbs}
}

func (r *repository) CreateTransaction(transaction core.Transaction) error {
	// Buat transaksi baru
	if err := r.db.Create(&transaction).Error; err != nil {
		fmt.Println(err, ": err trans")
		return err
	}

	// Simpan detail transaksi
	for _, detail := range transaction.Details {
		var existingDetail core.DetailTransaction
		err := r.db.Where(&core.DetailTransaction{DetailTransactionID: detail.DetailTransactionID}).FirstOrCreate(&existingDetail, detail).Error
		if err != nil {
			fmt.Println(err, " : err detail ")
			return err
		}
	}

	return nil
}

func (r *repository) GetTransactionByID(transactionID string) (core.Transaction, error) {
	var transaction core.Transaction
	err := r.db.Preload("Buyer").Preload("Details").First(&transaction, "transaction_id = ?", transactionID).Error
	if err != nil {
		return transaction, err
	}

	// Fetch Merchant data for each DetailTransaction
	for i := range transaction.Details {
		var merchant core.Merchant
		err := r.db.First(&merchant, "merchant_id = ?", transaction.Details[i].MerchantID).Error
		if err != nil {
			return transaction, err
		}
		transaction.Details[i].Merchant = merchant
	}

	return transaction, nil
}

func (r *repository) GetAllTransaction(buyerID string) ([]core.Transaction, error) {
	var transactions []core.Transaction
	err := r.db.Where("buyer_id = ?", buyerID).Preload("Buyer").Find(&transactions).Error
	if err != nil {
		return nil, err
	}
	return transactions, nil
}
