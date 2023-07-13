package products

import (
	"bytes"
	"ecommerce/core"
	"ecommerce/helpers"
	"encoding/base64"
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/spf13/viper"
)

type Services interface {
	CreateNewProduct(s3 *session.Session, request CreateProductRequest) (core.Product, error)
	GetAllProducts() ([]core.Product, error)
	UpdateProduct(s3 *session.Session, productID, merchant_id string, request CreateProductRequest) (core.Product, error)
	DeleteProduct(productID string) error
}

type services struct {
	repository Repository
}

func NewServices(repository Repository) *services {
	return &services{repository}
}

func (s *services) CreateNewProduct(s3 *session.Session, request CreateProductRequest) (core.Product, error) {
	product := core.Product{}
	var pathURLPicture string
	product.ProductID = helpers.GenerateUUID()
	product.CategoryID = request.CategoryID
	product.MerchantID = request.MerchantID
	product.ProductName = request.ProductName
	product.ProductPrice = request.ProductPrice
	if request.ProductImage != "" {
		decodedImage, _ := base64.StdEncoding.DecodeString(request.ProductImage)
		file := bytes.NewReader(decodedImage)
		fileType := http.DetectContentType(decodedImage)
		if fileType != "image/jpeg" && fileType != "image/jpg" && fileType != "image/png" {
			return product, fmt.Errorf("format image not permitted: %v", fileType)
		}

		picture := fmt.Sprintf("%s.%s", product.ProductID, strings.Split(fileType, "/")[1])
		err := helpers.SaveObjectToS3(s3, "ecommerce/picture/", picture, file)
		if err != nil {
			return product, errors.New("Failed to Save Picture on S3 Storage. Please Check Your Code!")
		}
		pathURLPicture = fmt.Sprintf("%s/%s/%s", viper.GetString("S3_CREDENTIALS.RESP_URL"), viper.GetString("S3_CREDENTIALS.BUCKET"), "picture/"+picture)
	}
	product.ProductImage = pathURLPicture
	save, err := s.repository.CreateNewProduct(product)
	if err != nil {
		return product, err
	}
	return save, nil
}
func (s *services) UpdateProduct(s3 *session.Session, productID, merchant_id string, request CreateProductRequest) (core.Product, error) {
	product := core.Product{}
	var pathURLPicture string
	product.ProductID = helpers.GenerateUUID()
	product.CategoryID = request.CategoryID
	product.MerchantID = request.MerchantID
	product.ProductName = request.ProductName
	product.ProductPrice = request.ProductPrice
	if request.ProductImage != "" {
		decodedImage, _ := base64.StdEncoding.DecodeString(request.ProductImage)
		file := bytes.NewReader(decodedImage)
		fileType := http.DetectContentType(decodedImage)
		if fileType != "image/jpeg" && fileType != "image/jpg" && fileType != "image/png" {
			return product, fmt.Errorf("format image not permitted: %v", fileType)
		}

		picture := fmt.Sprintf("%s.%s", product.ProductID, strings.Split(fileType, "/")[1])
		err := helpers.SaveObjectToS3(s3, "ecommerce/picture/", picture, file)
		if err != nil {
			return product, errors.New("Failed to Save Picture on S3 Storage. Please Check Your Code!")
		}
		pathURLPicture = fmt.Sprintf("%s/%s/%s", viper.GetString("S3_CREDENTIALS.RESP_URL"), viper.GetString("S3_CREDENTIALS.BUCKET"), "picture/"+picture)
	}
	product.ProductImage = pathURLPicture
	save, err := s.repository.UpdateProduct(productID, merchant_id, product)
	if err != nil {
		return product, err
	}
	return save, nil
}
func (s *services) GetAllProducts() ([]core.Product, error) {
	return s.repository.GetAllProducts()
}
func (s *services) DeleteProduct(productID string) error {
	return s.repository.DeleteProduct(productID)
}
