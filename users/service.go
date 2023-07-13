package users

import (
	"bytes"
	"ecommerce/core"
	"ecommerce/helpers"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/jinzhu/gorm/dialects/postgres"
	"github.com/spf13/viper"
	"golang.org/x/crypto/bcrypt"
)

type Services interface {
	RegisterUser(s3 *session.Session, request RegisterUserRequest) (map[string]interface{}, error)
	Login(request LoginRequest) (core.User, error)
	SaveNewRole(request NewRoleRequest) (core.Role, error)
	Verification(request VerificationRequest) (bool, error)
	GetRoleByUserID(uuid string) (map[string]interface{}, error)
}

type services struct {
	repository Repository
}

func NewServices(repository Repository) *services {
	return &services{repository}
}

func (s *services) RegisterUser(s3 *session.Session, request RegisterUserRequest) (map[string]interface{}, error) {
	result := map[string]interface{}{}
	var picture string
	user := core.User{}
	user.Uuid = helpers.GenerateUUID()
	user.Username = request.Username
	user.Email = request.Email
	if request.Password != request.PasswordRetype {
		return result, errors.New("Password Not Match! Please Makesure Password Same.")
	}
	password, err := bcrypt.GenerateFromPassword([]byte(request.Password), bcrypt.DefaultCost)
	if err != nil {
		return result, errors.New("Failed To Generate Password Hashing")
	}
	user.Password = string(password)
	if request.RoleName != "Seller" && request.RoleName != "Buyer" {
		return result, errors.New("Anda Hanya Boleh Memasukan Role Seller / Buyer")
	}
	role, err := s.repository.FindRoleByRoleName(request.RoleName)
	if err != nil {
		return result, errors.New("Register Failed! RoleID Not Found")
	}
	user.RoleID = role.RoleID

	if request.Picture != "" {
		decodedImage, _ := base64.StdEncoding.DecodeString(request.Picture)
		file := bytes.NewReader(decodedImage)
		fileType := http.DetectContentType(decodedImage)
		if fileType != "image/jpeg" && fileType != "image/jpg" && fileType != "image/png" {
			return result, fmt.Errorf("format image not permitted: %v", fileType)
		}

		picture = fmt.Sprintf("%s.%s", request.Username, strings.Split(fileType, "/")[1])
		err := helpers.SaveObjectToS3(s3, "ecommerce/picture/users/", picture, file)
		fmt.Println(err)
		if err != nil {
			return result, errors.New("Failed to Save Picture on S3 Storage. Please Check Your Code!")
		}
	}
	pathURLPicture := fmt.Sprintf("%s/%s/%s", viper.GetString("S3_CREDENTIALS.RESP_URL"), viper.GetString("S3_CREDENTIALS.BUCKET"), "picture/"+picture)
	user_detail := make(map[string]interface{})
	user_detail["full_name"] = request.FullName
	user_detail["telepon"] = request.Telepon
	user_detail["Address"] = request.Address
	user_detail["picture"] = pathURLPicture
	dataJson, _ := json.Marshal(user_detail)
	JsonRaw := json.RawMessage(dataJson)
	user.UserDetail = postgres.Jsonb{JsonRaw}

	newUser, err := s.repository.Save(user)
	if err != nil {
		err = helpers.HandleDuplicateKeyError(err)
		return result, err
	}

	// response result setelah di filter data apa aja yang akan di tampilkan
	result = map[string]interface{}{
		"uuid":         newUser.Uuid,
		"username":     newUser.Username,
		"email":        newUser.Email,
		"role_name":    role.RoleName,
		"role_id":      role.RoleID,
		"verification": newUser.Verification,
		"user_detail":  user_detail,
	}
	return result, nil
}

func (s *services) SaveNewRole(request NewRoleRequest) (core.Role, error) {
	role := core.Role{}
	role.RoleID = helpers.GenerateUUID()
	role.RoleName = request.RoleName
	if request.RoleName != "Buyer" && request.RoleName != "Seller" {
		return role, errors.New("You only can fill role name is Buyer or Seller")
	}
	newRole, err := s.repository.SaveNewRole(role)
	if err != nil {
		err = helpers.HandleDuplicateKeyError(err)
		return role, err
	}
	return newRole, nil
}

func (s *services) Login(request LoginRequest) (core.User, error) {

	user, err := s.repository.FindByUsername(request.Username)
	if err != nil {
		return user, errors.New("User Not Found on Database, Please Check Your Credentials")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(request.Password))
	if err != nil {
		return user, errors.New("Password Your Given Not Match! Password Wrong.")
	}

	return user, nil
}

func (s *services) Verification(request VerificationRequest) (bool, error) {
	return s.repository.Verification(request.UUID)
}

func (s *services) GetRoleByUserID(uuid string) (map[string]interface{}, error) {
	return s.repository.GetRoleByUserID(uuid)
}
