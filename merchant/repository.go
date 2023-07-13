package merchant

import (
	"ecommerce/core"
	"ecommerce/privatehelpers"

	"gorm.io/gorm"
)

type Repository interface {
	RegistrasiMerchant(merchant core.Merchant) (core.Merchant, error)
	UpdateUserAfterRegisterMerchant(uuid string, merchantID string) error
	CheckRegisteredMerchant(uuid string) bool
}

type repository struct {
	db  *gorm.DB
	dbs privatehelpers.DBStruct
}

func NewRepository(db *gorm.DB, dbs privatehelpers.DBStruct) *repository {
	return &repository{db, dbs}
}

func (r *repository) RegistrasiMerchant(merchant core.Merchant) (core.Merchant, error) {
	err := r.db.Create(&merchant).Error
	if err != nil {
		return merchant, err
	}
	return merchant, nil
}

func (r *repository) UpdateUserAfterRegisterMerchant(uuid string, merchantID string) error {
	var user core.User
	err := r.db.Where("uuid = ?", uuid).First(&user).Error
	if err != nil {
		return err
	}

	user.MerchantID = merchantID
	err = r.db.Save(&user).Error
	if err != nil {
		return err
	}

	return nil
}
func (r *repository) CheckRegisteredMerchant(uuid string) bool {
	var user core.User
	err := r.db.Where("uuid = ?", uuid).First(&user).Error
	if err != nil {
		return false
	}
	if user.MerchantID != "" {
		return true
	}
	return false
}
