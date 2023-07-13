package users

import (
	"ecommerce/core"
	"ecommerce/helpers"
	"ecommerce/kedaihelpers"
	"errors"

	"gorm.io/gorm"
)

type Repository interface {
	Save(user core.User) (core.User, error)
	FindRoleByRoleName(roleName string) (core.Role, error)
	SaveNewRole(role core.Role) (core.Role, error)
	FindByUsername(username string) (core.User, error)
	Verification(uuid string) (bool, error)
	GetRoleByUserID(uuid string) (map[string]interface{}, error)
}

type repository struct {
	db  *gorm.DB
	dbs kedaihelpers.DBStruct
}

func NewRepository(db *gorm.DB, dbs kedaihelpers.DBStruct) *repository {
	return &repository{db, dbs}
}

func (r *repository) Save(user core.User) (core.User, error) {
	err := r.db.Create(&user).Error

	if err != nil {
		return user, err
	}

	return user, nil
}

func (r *repository) FindRoleByRoleName(roleName string) (core.Role, error) {
	var role core.Role
	err := r.db.Where("role_name = ?", roleName).First(&role).Error
	if err != nil {
		return role, err
	}
	return role, nil
}

func (r *repository) SaveNewRole(role core.Role) (core.Role, error) {
	err := r.db.Create(&role).Error

	if err != nil {
		return role, err
	}

	return role, nil
}

func (r *repository) FindByUsername(username string) (core.User, error) {
	var user core.User
	err := r.db.Where("username = ?", username).First(&user).Error
	if err != nil {
		return user, err
	}
	return user, nil
}

func (r *repository) Verification(uuid string) (bool, error) {
	var user core.User
	err := r.db.Where("uuid = ?", uuid).First(&user).Error
	if err != nil {
		return false, errors.New("Users Not Found")
	}
	if user.Verification {
		return false, errors.New("You Already Verified!")
	}
	user.Verification = true
	err = r.db.Save(&user).Error
	if err != nil {
		return false, errors.New("Failed To Update Data Users")
	}
	return true, nil
}
func (r *repository) GetRoleByUserID(uuid string) (map[string]interface{}, error) {
	newuuid, _ := helpers.DecryptString(uuid)
	sql := `SELECT a.role_id, b.role_name
	        from users as a
			left join roles as b on b.role_id = a.role_id
			where a.uuid = '` + newuuid + `'
	`
	data := r.dbs.DatabaseQuerySingleRow(sql)
	if data["role_id"] == "" {
		return data, errors.New("Users Not Have any Role")
	}
	return data, nil
}
