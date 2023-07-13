package products

import (
	"ecommerce/core"
	"ecommerce/privatehelpers"
	"errors"

	"gorm.io/gorm"
)

type Repository interface {
	CreateNewProduct(product core.Product) (core.Product, error)
	GetAllProducts() ([]core.Product, error)
	UpdateProduct(productID, merchant_id string, updatedProduct core.Product) (core.Product, error)
	DeleteProduct(productID string) error
	GetProductByID(productID string) (core.Product, error)
}

type repository struct {
	db  *gorm.DB
	dbs privatehelpers.DBStruct
}

func NewRepository(db *gorm.DB, dbs privatehelpers.DBStruct) *repository {
	return &repository{db, dbs}
}

func (r *repository) CreateNewProduct(product core.Product) (core.Product, error) {
	err := r.db.Create(&product).Error
	if err != nil {
		return product, err
	}
	return product, nil
}

func (r *repository) GetAllProducts() ([]core.Product, error) {
	var products []core.Product
	err := r.db.Find(&products).Error
	if err != nil {
		return nil, err
	}
	return products, nil
}
func (r *repository) UpdateProduct(productID, merchant_id string, updatedProduct core.Product) (core.Product, error) {
	var exist core.Product
	err := r.db.Where("product_id = ?", productID).First(&exist).Error
	if err != nil {
		return exist, err
	}
	if merchant_id != exist.MerchantID {
		return exist, errors.New("Ilegal! You don't have permissions to update this product")
	}

	// Update field individu pada objek exist dengan nilai dari updatedProduct
	exist.ProductName = updatedProduct.ProductName
	exist.ProductPrice = updatedProduct.ProductPrice
	exist.ProductImage = updatedProduct.ProductImage
	exist.CategoryID = updatedProduct.CategoryID
	exist.MerchantID = updatedProduct.MerchantID

	err = r.db.Save(&exist).Error
	if err != nil {
		return exist, err
	}

	return exist, nil
}
func (r *repository) DeleteProduct(productID string) error {
	var product core.Product
	result := r.db.Where("product_id = ?", productID).Delete(&product)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return errors.New("product not found")
	}
	return nil
}

func (r *repository) GetProductByID(productID string) (core.Product, error) {
	var product core.Product
	err := r.db.Where("product_id = ?", productID).First(&product).Error
	if err != nil {
		return product, err
	}
	return product, nil
}
