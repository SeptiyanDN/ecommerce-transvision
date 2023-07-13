package checkout

type CheckoutRequest struct {
	TransactionID  []string `json:"transaction_id"`
	ShipName       string   `json:"ship_name"`
	ShipAddress    string   `json:"ship_address"`
	ShipCity       string   `json:"ship_city"`
	ShipState      string   `json:"ship_state"`
	ShipCountry    string   `json:"ship_country"`
	ShipPhone      string   `json:"ship_phone"`
	TrackingNumber string   `json:"tracking_number"`
	PaymentMethod  string   `json:"payment_method"`
}
