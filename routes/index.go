package routes

import (
	"ecommerce/authorization"
	"ecommerce/categories"
	"ecommerce/checkout"
	"ecommerce/handler"
	"ecommerce/helpers"
	"ecommerce/merchant"
	"ecommerce/privatehelpers"
	"ecommerce/products"
	"ecommerce/transaction"
	"ecommerce/users"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/spf13/cast"
	"github.com/spf13/viper"
	"gorm.io/gorm"
)

func Routing(router *gin.Engine, dbs privatehelpers.DBStruct, initGorm *gorm.DB) {

	// repository
	userRepository := users.NewRepository(initGorm, dbs)
	merchantRepository := merchant.NewRepository(initGorm, dbs)
	categoryRepository := categories.NewRepository(initGorm, dbs)
	productRepository := products.NewRepository(initGorm, dbs)
	transactionRepository := transaction.NewRepository(initGorm, dbs)
	checkoutRepository := checkout.NewCheckoutRepository(initGorm, transactionRepository, dbs)

	// services
	authServices := authorization.NewServices()
	userServices := users.NewServices(userRepository)
	merchantServices := merchant.NewServices(merchantRepository)
	categoryServices := categories.NewServices(categoryRepository)
	productServices := products.NewServices(productRepository)
	transactionServices := transaction.NewTransactionService(transactionRepository, productRepository)
	checkoutServices := checkout.NewCheckoutService(checkoutRepository, transactionRepository)

	// handler
	userHandler := handler.NewUserHandler(userServices, authServices)
	merchantHandler := handler.NewMerchantHandler(merchantServices)
	categoryHandler := handler.NewCategoryHandler(categoryServices)
	productHandler := handler.NewProductHandler(productServices)
	transactionHandler := handler.NewTransactionHandler(transactionServices)
	checkoutHandler := handler.NewCheckOutHandler(checkoutServices)
	versioning := router.Group("api/v1")
	versioning.Any("", func(ctx *gin.Context) {
		ctx.JSON(200, gin.H{
			"status":  "OK",
			"Message": "Welcome to " + viper.GetString("appName"),
		})
	})
	authRouter := versioning.Group("auth")
	{
		authRouter.POST("/login/", userHandler.Login)
		authRouter.POST("/register/", userHandler.RegisterUser)
		authRouter.POST("/verification/", userHandler.Verification)
		authRouter.POST("/refresh-token/", userHandler.RefreshToken)

	}
	rolesRouter := versioning.Group("roles")
	{
		rolesRouter.POST("/create-new/", userHandler.SaveNewRole)
	}
	merchantRouter := versioning.Group("merchant")
	{
		merchantRouter.Use(AuthMiddleware(authServices, userServices, []string{"Seller"}))
		merchantRouter.POST("/registrasi-merchant/", merchantHandler.RegistrasiMerchant)
	}
	categoriesRouter := versioning.Group("categories")
	{
		categoriesRouter.Use(AuthMiddleware(authServices, userServices, []string{"Seller", "Buyer"}))
		categoriesRouter.GET("/", categoryHandler.ListAllCategory)
		categoriesRouter.Use(AuthMiddleware(authServices, userServices, []string{"Seller"}))
		categoriesRouter.POST("/create-new/", categoryHandler.CreateNewCategory)
	}
	productRouter := versioning.Group("products")
	{
		productRouter.Use(AuthMiddleware(authServices, userServices, []string{"Seller", "Buyer"}))
		productRouter.GET("/", productHandler.GetAllProduct)
		productRouter.Use(AuthMiddleware(authServices, userServices, []string{"Buyer"}))
		productRouter.POST("/create-new/", productHandler.CreateNewProduct)
		productRouter.POST("/:product_id/", productHandler.UpdateProduct)
		productRouter.DELETE("/:product_id/", productHandler.DeleteProduct)
	}
	transactionRouter := versioning.Group("transactions")
	{
		transactionRouter.Use(AuthMiddleware(authServices, userServices, []string{"Buyer", "Seller"}))
		transactionRouter.GET("/", transactionHandler.GetAllTransactions)
		transactionRouter.POST("/", transactionHandler.CreateTransaction)
		transactionRouter.GET("/detail/:transaction_id/", transactionHandler.GetTransactionByID)

	}
	checkoutRouter := versioning.Group("checkout")
	{
		checkoutRouter.Use(AuthMiddleware(authServices, userServices, []string{"Buyer", "Seller"}))
		checkoutRouter.POST("/actions/", checkoutHandler.CheckOutOrders)
		checkoutRouter.GET("/history/", checkoutHandler.HistoryPayment)
	}
}

func AuthMiddleware(authServices authorization.Services, userServices users.Services, allowedRoles []string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if !strings.Contains(authHeader, "Bearer") {
			response := helpers.APIResponse("Unauthorized Access ", http.StatusUnauthorized, "error", "You do not have permission to access this site! Please login or exit.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}
		tokenString := ""
		arrayToken := strings.Split(authHeader, " ")
		if len(arrayToken) == 2 {
			tokenString = arrayToken[1]
		}
		token, err := authServices.ValidateToken(tokenString)
		if err != nil {
			response := helpers.APIResponse("Unauthorized Access", http.StatusUnauthorized, "error", "You do not have permission to access this site! Please login or exit.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}
		claims, ok := token.Claims.(*authorization.JWTClaim)
		if !ok || !token.Valid {
			response := helpers.APIResponse("Unauthorized Access", http.StatusUnauthorized, "error", "You do not have permission to access this site! Please login or exit.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}
		verificationStatus, _ := helpers.DecryptString(claims.Verificaction)
		if !cast.ToBool(verificationStatus) {
			response := helpers.APIResponse("Must Be Verified", http.StatusUnauthorized, "error", "You have not verified your account! Please check your email or contact the call center.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}
		if claims.ExpiresAt < time.Now().Local().Unix() {
			response := helpers.APIResponse("Token Expired", http.StatusUnauthorized, "error", "Your token has expired! Please login or exit.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}

		// Check if the user's role is allowed
		userID := claims.Uuid
		role, err := userServices.GetRoleByUserID(userID)
		if err != nil {
			response := helpers.APIResponse("Unauthorized Access", http.StatusUnauthorized, "error", "You do not have permission to access this site! Please login or exit.")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}
		isAllowed := false
		for _, allowedRole := range allowedRoles {
			if cast.ToString(role["role_name"]) == allowedRole {
				isAllowed = true
				break
			}
		}
		if !isAllowed {
			response := helpers.APIResponse("Unauthorized Access", http.StatusUnauthorized, "error", "You do not have permission to access this site!")
			c.AbortWithStatusJSON(http.StatusUnauthorized, response)
			return
		}

		c.Set("current", claims)
		c.Next()
	}
}
