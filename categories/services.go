package categories

import (
	"ecommerce/authorization"
	"ecommerce/core"
	"ecommerce/helpers"

	"github.com/spf13/cast"
)

type Services interface {
	Save(request CreateCategoryRequest, merchant_id string) (core.Category, error)
	ListAllCategory(current *authorization.JWTClaim) []map[string]interface{}
}

type services struct {
	repository Repository
}

func NewServices(repository Repository) *services {
	return &services{repository}
}

func (s *services) Save(request CreateCategoryRequest, merchant_id string) (core.Category, error) {
	category := core.Category{}
	category.CategoryID = helpers.GenerateUUID()
	category.CategoryName = request.CategoryName
	category.MerchantID = merchant_id
	newCategory, err := s.repository.Save(category)
	if err != nil {
		return category, err
	}
	return newCategory, nil
}
func (s *services) ListAllCategory(current *authorization.JWTClaim) []map[string]interface{} {
	role_id, _ := helpers.DecryptString(current.RoleID)
	merchant_id, _ := helpers.DecryptString(current.MerchantID)
	role_data := s.repository.GetRoleData(role_id)
	var data []map[string]interface{}
	if cast.ToString(role_data["role_name"]) == "Seller" {
		data = s.repository.GetDataCategorySeller(merchant_id)
		return data
	}
	data = s.repository.GetDataCategory()

	return data
}
