
# Test Case Recruitment E-Commerce - Transvision

This is a mini e-commerce project developed using the Golang Gin framework. It is designed to fulfill the requirements of a task given by a recruiter. The project aims to showcase basic e-commerce functionalities, such as browsing product, and processing orders.

# Features E-Commerce

Product Listing: Users can view a list of available products with their details, including name, price, and description.
Product Search: Users can search for specific products based on keywords or filters.



## Installation Project And How To Running

Tutorial Setup Environtmen

```bash
  All Config Environments are in the app.conf.json file

  I have set up on my private server
  
  Opsi 1 :
  You can use the database that is on my private server

  Opsi 2 :
  please look at the root of the project there is a query.txt file
  You can open the query.txt file 
  then run the queries one by one to create the database and the relationships from each table
  
  Opsi 3 : 
  you can restore the database that I have prepared a backup file in this project
```

Tutorial Installation Project E-Commerce

```bash
  go mod init ecommerce
  go mod tidy
  go run .
```

Users Testing

```bash
  Credentials Account Seller
  Username : seller
  Password : iyanjipyeong

  Credentials Account Buyer / User
  Username : septiyan
  Password : iyanjipyeong
```

# Information
- The API route I'm using is 
- Authorization
- 1. {{baseURL}}/api/v1/auth/login/
- 2. {{baseURL}}/api/v1/auth/register/
- 3. {{baseURL}}/api/v1/refresh-token/
- 4. {{baseURL}}/api/v1/verification/

- Roles
- 1. {{baseURL}}/api/v1/roles/create-new/

- Merchant
- 1. {{baseURL}}/api/v1/merchant/registrasi-merchant/ (Seller Access)

- Categories
- 1. {{baseURL}}/api/v1/categories/ (Seller & Buyer Access)
- 2. {{baseURL}}/api/v1/categories/create-new/ (Seller Access)

- Products
- 1. {{baseURL}}/api/v1/products/ (Seller & Buyer Access)
- 2. {{baseURL}}/api/v1/products/create-new/ (Seller Access)
- 3. {{baseURL}}/api/v1/products/:product_id/ -> Update Product (Seller Access)
- 4. {{baseURL}}/api/v1/products/:product_id/ -> Remove Product (Seller Access)

- Transaction
- 1. {{baseURL}}/api/v1/transactions/ -> Get Transaction (Seller & Buyer Access)
- 2. {{baseURL}}/api/v1/transactions/ -> Create Transaction (Seller & Buyer Access)
- 3. {{baseURL}}/api/v1/transactions/detail/:transaction_id/ (Seller & Buyer Access)

- Checkout (Payment)
- 1. {{baseURL}}/api/v1/checkout/actions/ (Seller & Buyer Access)
- 2. {{baseURL}}/api/v1/checkout/history/ (Seller & Buyer Access)


Thank You and Please Review My Code

