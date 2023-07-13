package checkout

import (
	"ecommerce/kedaihelpers"
	"ecommerce/transaction"
	"encoding/json"

	"github.com/spf13/cast"
	"gorm.io/gorm"
)

type CheckoutRepository interface {
	CreatePayment(data_payment map[string]interface{}, data_shipping map[string]interface{}) error
	HistoryPayment(buyerID string) []map[string]interface{}
}

type checkoutRepository struct {
	db                    *gorm.DB
	transactionRepository transaction.Repository
	dbs                   kedaihelpers.DBStruct
}

func NewCheckoutRepository(db *gorm.DB, transactionRepository transaction.Repository, dbs kedaihelpers.DBStruct) CheckoutRepository {
	return &checkoutRepository{
		db:                    db,
		transactionRepository: transactionRepository,
		dbs:                   dbs,
	}
}

// Repository
func (r *checkoutRepository) CreatePayment(data_payment map[string]interface{}, data_shipping map[string]interface{}) error {
	detail_transaction, _ := json.Marshal(data_payment["detail_transaction"])
	_, err := r.dbs.Dbx.Exec(`
	INSERT INTO
		payments(
			payment_id,
			buyer_id,
			amount,
			payment_method,
			detail_transaction
		) VALUES($1,$2,$3,$4,$5)`, cast.ToString(data_payment["payment_id"]), cast.ToString(data_payment["buyer_id"]), cast.ToFloat64(data_payment["amount"]), cast.ToString(data_payment["payment_method"]), detail_transaction)

	if err != nil {
		return err
	}
	_, err = r.dbs.Dbx.Exec(`
	INSERT INTO
		shippings (
			shipping_id,
			buyer_id,
			ship_name,
			ship_address,
			ship_city,
			ship_state,
			ship_country,
			ship_phone,
			tracking_number,
			detail_transaction
		) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)
	`, cast.ToString(data_shipping["shipping_id"]), cast.ToString(data_shipping["buyer_id"]), cast.ToString(data_shipping["ship_name"]), cast.ToString(data_shipping["ship_address"]), cast.ToString(data_shipping["ship_city"]), cast.ToString(data_shipping["ship_state"]), cast.ToString(data_shipping["ship_country"]), cast.ToString(data_shipping["ship_phone"]), cast.ToString(data_shipping["tracking_number"]), detail_transaction)
	if err != nil {
		return err
	}
	return nil
}

func (r *checkoutRepository) HistoryPayment(buyerID string) []map[string]interface{} {
	sql := `
	SELECT 
	   a.payment_id,
	   a.buyer_id,
	   a.amount,
	   a.payment_method,
	   a.detail_transaction as detail_payment,
	   b.uuid,
	   b.username,
	   b.email,
	   b.role_id,
	   b.user_detail,
	   c.role_name
	FROM payments as a 
	LEFT JOIN users as b on b.uuid = a.buyer_id
	LEFT JOIN roles as c on c.role_id = b.role_id
	WHERE a.buyer_id = '` + buyerID + `'
	   `
	rows := r.dbs.DatabaseQueryRows(sql)
	return rows
}
