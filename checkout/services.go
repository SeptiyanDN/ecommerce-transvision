package checkout

import (
	"ecommerce/helpers"
	"ecommerce/transaction"
	"encoding/json"

	"github.com/spf13/cast"
)

type CheckoutService interface {
	ProcessCheckout(request CheckoutRequest, buyerID string) error
	HistoryPayment(buyerID string) []map[string]interface{}
}

type checkoutService struct {
	checkoutRepo          CheckoutRepository
	transactionRepository transaction.Repository
}

func NewCheckoutService(checkoutRepo CheckoutRepository, transactionRepository transaction.Repository) CheckoutService {
	return &checkoutService{
		checkoutRepo:          checkoutRepo,
		transactionRepository: transactionRepository,
	}
}

// Service

func (s *checkoutService) ProcessCheckout(request CheckoutRequest, buyerID string) error {
	TotalAmount := 0
	detail_transcation := []map[string]interface{}{}
	for _, transactionID := range request.TransactionID {
		transaction, err := s.transactionRepository.GetTransactionByID(transactionID)
		if err != nil {
			return err
		}
		data := map[string]interface{}{
			"transaction_id":     transactionID,
			"total_amount":       transaction.TotalAmount,
			"detail_transaction": transaction.Details,
		}

		detail_transcation = append(detail_transcation, data)

		TotalAmount += int(transaction.TotalAmount)

	}
	data_payment := map[string]interface{}{
		"payment_id":         helpers.GenerateUUID(),
		"buyer_id":           buyerID,
		"amount":             TotalAmount,
		"payment_method":     request.PaymentMethod,
		"detail_transaction": detail_transcation,
	}
	data_shippings := map[string]interface{}{
		"shipping_id":        helpers.GenerateUUID(),
		"buyer_id":           buyerID,
		"ship_name":          request.ShipName,
		"ship_address":       request.ShipAddress,
		"ship_city":          request.ShipCity,
		"ship_state":         request.ShipState,
		"ship_country":       request.ShipCountry,
		"ship_phone":         request.ShipPhone,
		"tracking_number":    request.TrackingNumber,
		"detail_transaction": detail_transcation,
	}
	err := s.checkoutRepo.CreatePayment(data_payment, data_shippings)
	if err != nil {
		return err
	}
	return nil
}

func (s *checkoutService) HistoryPayment(buyerID string) []map[string]interface{} {
	rows := s.checkoutRepo.HistoryPayment(buyerID)
	if len(rows) < 1 {
		return []map[string]interface{}{}
	}
	result := []map[string]interface{}{}
	for _, v := range rows {
		detail_payment := []map[string]interface{}{}
		json.Unmarshal([]byte(cast.ToString(v["detail_payment"])), &detail_payment)
		v["detail_payment"] = detail_payment
		userDetail := map[string]interface{}{}
		json.Unmarshal([]byte(cast.ToString(v["user_detail"])), &userDetail)
		v["user_detail"] = userDetail
		result = append(result, v)
	}
	return result
}
