package users

type RegisterUserRequest struct {
	Username       string `form:"username"  json:"username" binding:"required"`
	Email          string `form:"email"  json:"email" binding:"required,email"`
	Password       string `form:"password"  json:"password" binding:"required"`
	PasswordRetype string `form:"password_retype" json:"password_retype" binding:"required"`
	RoleName       string `form:"role_name" json:"role_name" binding:"required"`
	FullName       string `form:"full_name"  json:"full_name" binding:"required"`
	Telepon        string `form:"telepon" binding:"required" json:"telepon"`
	Address        string `form:"address" json:"address" binding:"required"`
	Picture        string `form:"picture" json:"picture" binding:"required"`
}

type LoginRequest struct {
	Username string `form:"username" binding:"required"`
	Password string `form:"password" binding:"required"`
}

type NewRoleRequest struct {
	RoleName string `form:"role_name" json:"role_name" binding:"required"`
}

type RefreshTokenRequest struct {
	RefreshToken string `json:"refresh_token" binding:"required"`
}

type VerificationRequest struct {
	UUID string `json:"uuid" binding:"required"`
}
