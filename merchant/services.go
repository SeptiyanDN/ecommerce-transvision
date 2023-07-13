package merchant

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
	RegistrasiMerchant(s3 *session.Session, uuid string, request CreateMerchantRequest) (core.Merchant, error)
}

type services struct {
	repository Repository
}

func NewServices(repository Repository) *services {
	return &services{repository}
}

func (s *services) RegistrasiMerchant(s3 *session.Session, uuid string, request CreateMerchantRequest) (core.Merchant, error) {
	merchant := core.Merchant{}
	isRegistered := s.repository.CheckRegisteredMerchant(uuid)
	if isRegistered {
		return merchant, errors.New("Failed! Your Already Have a Merchant")
	}
	var pathURLPicture string
	merchant.MerchantID = helpers.GenerateUUID()
	merchant.MerchantName = request.MerchantName
	merchant.MerchantAddress = request.MerchantAddress
	if request.MerchantImage != "" {
		decodedImage, _ := base64.StdEncoding.DecodeString(request.MerchantImage)
		file := bytes.NewReader(decodedImage)
		fileType := http.DetectContentType(decodedImage)
		if fileType != "image/jpeg" && fileType != "image/jpg" && fileType != "image/png" {
			return merchant, fmt.Errorf("format image not permitted: %v", fileType)
		}

		picture := fmt.Sprintf("%s.%s", merchant.MerchantID, strings.Split(fileType, "/")[1])
		err := helpers.SaveObjectToS3(s3, "ecommerce/picture/", picture, file)
		if err != nil {
			return merchant, errors.New("Failed to Save Picture on S3 Storage. Please Check Your Code!")
		}
		pathURLPicture = fmt.Sprintf("%s/%s/%s", viper.GetString("S3_CREDENTIALS.RESP_URL"), viper.GetString("S3_CREDENTIALS.BUCKET"), "picture/"+picture)
	}

	merchant.MerchantImage = pathURLPicture
	save, err := s.repository.RegistrasiMerchant(merchant)
	if err != nil {
		return merchant, err
	}
	err = s.repository.UpdateUserAfterRegisterMerchant(uuid, merchant.MerchantID)
	return save, nil
}
