package core

import (
	"time"

	"github.com/jinzhu/gorm/dialects/postgres"
)

type Role struct {
	RoleID    string    `json:"role_id" gorm:"primaryKey"`
	RoleName  string    `json:"role_name" gorm:"unique"`
	CreatedAt time.Time `json:"created_at" gorm:"type:timestamp;default:CURRENT_TIMESTAMP"`
	UpdatedAt time.Time `json:"updated_at"`
}

type User struct {
	Uuid         string         `json:"uuid" gorm:"primaryKey"`
	Username     string         `json:"username" gorm:"unique"`
	Email        string         `json:"email" gorm:"unique"`
	Password     string         `json:"password"`
	RoleID       string         `json:"role_id"`
	MerchantID   string         `json:"merchant_id,omitempty" gorm:"default:null"`
	Verification bool           `json:"verification,omitempty" gorm:"default:false"`
	UserDetail   postgres.Jsonb `gorm:"type:jsonb" json:"user_detail"`
	CreatedAt    time.Time      `json:"created_at" gorm:"type:timestamp;default:CURRENT_TIMESTAMP"`
	UpdatedAt    time.Time      `json:"updated_at"`
}

type Merchant struct {
	MerchantID      string    `json:"merchant_id" gorm:"primaryKey"`
	MerchantName    string    `json:"merchant_name"`
	MerchantAddress string    `json:"merchant_address"`
	MerchantImage   string    `json:"merchant_image"`
	CreatedAt       time.Time `gorm:"type:timestamp;default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type Category struct {
	CategoryID   string    `json:"category_id" gorm:"primaryKey"`
	CategoryName string    `json:"category_name"`
	MerchantID   string    `json:"merchant_id"`
	CreatedAt    time.Time `gorm:"type:timestamp;default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Product struct {
	ProductID    string    `json:"product_id" gorm:"primaryKey"`
	CategoryID   string    `json:"category_id" gorm:"foreignKey:CategoryID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	MerchantID   string    `json:"merchant_id" gorm:"foreignKey:MerchantID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	ProductName  string    `json:"product_name"`
	ProductPrice string    `json:"product_price"`
	ProductImage string    `json:"product_image"`
	CreatedAt    time.Time `gorm:"type:timestamp;default:CURRENT_TIMESTAMP" json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type Transaction struct {
	TransactionID   string              `json:"transaction_id" gorm:"primaryKey"`
	BuyerID         string              `json:"buyer_id" gorm:"foreignKey:BuyerID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	Buyer           User                `json:"buyer" gorm:"foreignKey:BuyerID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL"`
	TransactionDate time.Time           `json:"transaction_date" gorm:"type:date"`
	TotalAmount     float64             `json:"total_amount"`
	Status          string              `json:"status"`
	Details         []DetailTransaction `json:"details" gorm:"foreignKey:TransactionID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	CreatedAt       time.Time           `json:"created_at" gorm:"type:timestamp;default:CURRENT_TIMESTAMP"`
	UpdatedAt       time.Time           `json:"updated_at"`
}

type DetailTransaction struct {
	DetailTransactionID string    `json:"detail_transaction_id" gorm:"primaryKey"`
	TransactionID       string    `json:"transaction_id" gorm:"foreignKey:TransactionID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	ProductID           string    `json:"product_id" gorm:"foreignKey:ProductID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	Quantity            int       `json:"quantity"`
	Price               float64   `json:"price"`
	Subtotal            float64   `json:"subtotal"`
	Merchant            Merchant  `json:"merchant" gorm:"foreignKey:MerchantID;references:MerchantID;constraint:OnUpdate:CASCADE,OnDelete:CASCADE"`
	MerchantID          string    `json:"merchant_id"`
	CreatedAt           time.Time `json:"created_at" gorm:"type:timestamp;default:CURRENT_TIMESTAMP"`
	UpdatedAt           time.Time `json:"updated_at"`
}

type Checkout struct {
	Payment  Payment  `json:"payment"`
	Shipping Shipping `json:"shipping"`
}

type Payment struct {
	PaymentID     string   `json:"payment_id"`
	TransactionID []string `json:"transaction_id"`
	Amount        float64  `json:"amount"`
	PaymentMethod string   `json:"payment_method"`
}

type Shipping struct {
	ShippingID     string   `json:"shipping_id"`
	TransactionID  []string `json:"transaction_id"`
	ShipName       string   `json:"ship_name"`
	ShipAddress    string   `json:"ship_address"`
	ShipCity       string   `json:"ship_city"`
	ShipState      string   `json:"ship_state"`
	ShipCountry    string   `json:"ship_country"`
	ShipPhone      string   `json:"ship_phone"`
	TrackingNumber string   `json:"tracking_number"`
}
