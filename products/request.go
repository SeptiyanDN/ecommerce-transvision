package products

type CreateProductRequest struct {
	CategoryID   string `json:"category_id" binding:"required"`
	MerchantID   string `json:"merchant_id" binding:"required"`
	ProductName  string `json:"product_name" binding:"required"`
	ProductPrice string `json:"product_price" binding:"required"`
	ProductImage string `json:"product_image" binding:"required"`
}
