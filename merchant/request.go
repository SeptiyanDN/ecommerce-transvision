package merchant

type CreateMerchantRequest struct {
	MerchantName    string `json:"merchant_name" binding:"required"`
	MerchantAddress string `json:"merchant_address" binding:"required"`
	MerchantImage   string `json:"merchant_image" binding:"required"`
}
