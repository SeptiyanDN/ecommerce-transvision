package categories

import (
	"ecommerce/core"
	"ecommerce/kedaihelpers"

	"gorm.io/gorm"
)

type Repository interface {
	Save(category core.Category) (core.Category, error)
	GetRoleData(role_id string) map[string]interface{}
	GetDataCategorySeller(merchant_id string) []map[string]interface{}
	GetDataCategory() []map[string]interface{}
}

type repository struct {
	db  *gorm.DB
	dbs kedaihelpers.DBStruct
}

func NewRepository(db *gorm.DB, dbs kedaihelpers.DBStruct) *repository {
	return &repository{db, dbs}
}

func (r *repository) Save(category core.Category) (core.Category, error) {
	err := r.db.Create(&category).Error

	if err != nil {
		return category, err
	}

	return category, nil
}

func (r *repository) GetRoleData(role_id string) map[string]interface{} {
	sql := `select role_id, role_name from roles where role_id = '` + role_id + `' `
	data := r.dbs.DatabaseQuerySingleRow(sql)
	return data
}

func (r *repository) GetDataCategorySeller(merchant_id string) []map[string]interface{} {
	sql := `select a.category_name, b.merchant_name, a.merchant_id, a.category_id
	from categories as a 
	left join merchants as b on b.merchant_id = a.merchant_id
	where a.merchant_id = '` + merchant_id + `'`
	rows := r.dbs.DatabaseQueryRows(sql)
	return rows
}
func (r *repository) GetDataCategory() []map[string]interface{} {
	sql := `select a.category_name, b.merchant_name, a.merchant_id, a.category_id
	from categories as a 
	left join merchants as b on b.merchant_id = a.merchant_id`
	rows := r.dbs.DatabaseQueryRows(sql)
	return rows
}
