-- CreateEnum
CREATE TYPE "public"."UserRole" AS ENUM ('super_admin', 'admin', 'account', 'dispatch', 'support');

-- CreateEnum
CREATE TYPE "public"."NbfcUserRole" AS ENUM ('super_admin', 'admin', 'user');

-- CreateEnum
CREATE TYPE "public"."CustomerRole" AS ENUM ('customer');

-- CreateEnum
CREATE TYPE "public"."OtpReferenceType" AS ENUM ('user', 'customer', 'nbfc');

-- CreateEnum
CREATE TYPE "public"."AddressType" AS ENUM ('billing_address', 'shipping_address', 'billing_same_as_shipping');

-- CreateEnum
CREATE TYPE "public"."CustomerDocumentType" AS ENUM ('bank', 'it', 'gst', 'loc');

-- CreateEnum
CREATE TYPE "public"."QuotationStatus" AS ENUM ('pending', 'accepted', 'rejected', 'admin_approved');

-- CreateEnum
CREATE TYPE "public"."QuotationCreatorType" AS ENUM ('user', 'customer');

-- CreateEnum
CREATE TYPE "public"."LocApprovalStatus" AS ENUM ('approved', 'rejected');

-- CreateEnum
CREATE TYPE "public"."CustomerApprovalStatus" AS ENUM ('pending', 'approved', 'rejected');

-- CreateEnum
CREATE TYPE "public"."PaymentType" AS ENUM ('online', 'offline', 'line_of_credit');

-- CreateEnum
CREATE TYPE "public"."PaymentStatus" AS ENUM ('pending', 'completed', 'failed', 'rejected');

-- CreateEnum
CREATE TYPE "public"."OfflinePaymentType" AS ENUM ('bank_payment', 'upi');

-- CreateEnum
CREATE TYPE "public"."OrderStatus" AS ENUM ('order_not_confirmed', 'order_confirmed', 'processing', 'packed', 'generate_invoice', 'generated_invoice', 'out_for_delivery', 'delivered', 'cancelled_order');

-- CreateEnum
CREATE TYPE "public"."ShipmentModeType" AS ENUM ('bus_agency', 'porter', 'own_transport');

-- CreateEnum
CREATE TYPE "public"."ProductVariation" AS ENUM ('diameter', 'volume', 'length', 'grade');

-- CreateTable
CREATE TABLE "public"."users" (
    "id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "phone_number" TEXT NOT NULL,
    "email" TEXT,
    "role" "public"."UserRole" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."nbfc_companies" (
    "id" TEXT NOT NULL,
    "company_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "gst_number" TEXT NOT NULL,
    "rate_of_interest" DECIMAL(5,2),
    "building_number" TEXT NOT NULL,
    "street_details" TEXT NOT NULL,
    "area" TEXT NOT NULL,
    "landmark" TEXT,
    "city" TEXT NOT NULL,
    "pin_code" TEXT NOT NULL,
    "state" TEXT NOT NULL,

    CONSTRAINT "nbfc_companies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."nbfc_users" (
    "id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "phone_number" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "nbfc_company_id" TEXT NOT NULL,
    "role" "public"."NbfcUserRole" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_created_by_dygus" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "nbfc_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."sector_category_images" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,

    CONSTRAINT "sector_category_images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."sectors" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "image_id" TEXT,

    CONSTRAINT "sectors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "sector_id" TEXT,
    "image_id" TEXT,
    "description" TEXT,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."sub_categories" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "category_id" TEXT NOT NULL,
    "image_id" TEXT,

    CONSTRAINT "sub_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."hsn_codes" (
    "id" TEXT NOT NULL,
    "hsn_code" TEXT NOT NULL,
    "cgst" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "sgst" DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    CONSTRAINT "hsn_codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."brands" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "sub_category_id" TEXT NOT NULL,
    "image_id" TEXT,

    CONSTRAINT "brands_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."products" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "variation_name" "public"."ProductVariation",
    "category_id" TEXT,
    "sub_category_id" TEXT,
    "hsn_code_id" TEXT NOT NULL,
    "unit" TEXT,
    "brand_id" TEXT,
    "description" TEXT,
    "deleted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."inventories" (
    "id" TEXT NOT NULL,
    "product_id" TEXT NOT NULL,
    "variation_value" TEXT,
    "sku_id" TEXT,
    "price" DECIMAL(10,2) NOT NULL,
    "stock" INTEGER NOT NULL,
    "description" TEXT,
    "discount" DECIMAL(5,2) DEFAULT 0,

    CONSTRAINT "inventories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."product_images" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "product_id" TEXT NOT NULL,

    CONSTRAINT "product_images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."customers" (
    "id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT,
    "phone_number" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "director_or_partner_pan_number" TEXT,
    "secondary_pan" TEXT,
    "role" "public"."CustomerRole" NOT NULL DEFAULT 'customer',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "customers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."otp_logins" (
    "id" TEXT NOT NULL,
    "otp" CHAR(4) NOT NULL,
    "is_used" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "reference_by" TEXT NOT NULL,
    "reference_by_type" "public"."OtpReferenceType" NOT NULL,

    CONSTRAINT "otp_logins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."business_details" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "business_type" TEXT,
    "secondary_contact" TEXT,
    "gst_number" TEXT,

    CONSTRAINT "business_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."addresses" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "address_type" "public"."AddressType" NOT NULL,
    "building_number" VARCHAR(50) NOT NULL,
    "street_details" VARCHAR(255) NOT NULL,
    "area" VARCHAR(255) NOT NULL,
    "landmark" VARCHAR(255),
    "city" VARCHAR(100) NOT NULL,
    "pin_code" VARCHAR(20) NOT NULL,
    "state" VARCHAR(100) NOT NULL,
    "contact_name" VARCHAR(100) NOT NULL,
    "contact_email" VARCHAR(255),
    "contact_phone" VARCHAR(20) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "addresses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."bank_details" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "name" TEXT,
    "account_number" TEXT NOT NULL,
    "ifsc_code" TEXT NOT NULL,
    "is_primary" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "bank_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."gst_details" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "gstin" TEXT NOT NULL,
    "legal_name" TEXT NOT NULL,
    "trade_name" TEXT NOT NULL,
    "gst_filing_status" TEXT NOT NULL,
    "date_of_gst_registration" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gst_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."it_details" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "taxpayer_name" TEXT NOT NULL,
    "pan" TEXT NOT NULL,
    "tan" TEXT NOT NULL,
    "date_of_registration" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "it_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."line_of_credit_applications" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "bank_id" TEXT NOT NULL,
    "it_id" TEXT NOT NULL,
    "gst_id" TEXT NOT NULL,
    "requested_line_of_credit_amount" TEXT,
    "declaration" TEXT,
    "is_agreed_or_not" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "line_of_credit_applications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."loc_approvals" (
    "id" TEXT NOT NULL,
    "loc_id" TEXT NOT NULL,
    "status" "public"."LocApprovalStatus" NOT NULL,
    "approved_limit" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "rejection_reason" TEXT,
    "approved_by" TEXT NOT NULL,
    "number_of_interest" INTEGER,
    "status_updated_at" TIMESTAMP(3) NOT NULL,
    "available_limit" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "customer_approved_status" "public"."CustomerApprovalStatus" NOT NULL DEFAULT 'pending',
    "is_blocked" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "loc_approvals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."credit_reimbursements" (
    "id" TEXT NOT NULL,
    "loc_approval_id" TEXT NOT NULL,
    "payment_amount" DECIMAL(15,2) NOT NULL,
    "payment_date" DATE NOT NULL,
    "reimbursement_amount" DECIMAL(15,2) NOT NULL,
    "is_verified" BOOLEAN DEFAULT false,

    CONSTRAINT "credit_reimbursements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."customer_documents" (
    "id" TEXT NOT NULL,
    "reference_id" TEXT NOT NULL,
    "reference_type" "public"."CustomerDocumentType" NOT NULL,
    "file_url" TEXT NOT NULL,

    CONSTRAINT "customer_documents_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."coupons" (
    "id" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "coupon_code" TEXT NOT NULL,
    "discount" DECIMAL(10,2) NOT NULL,
    "image_url" TEXT,
    "start_date" TIMESTAMP(3) NOT NULL,
    "end_date" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "is_applied" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "coupons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."carts" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "inventory_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "quotation_applied" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "carts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."quotations" (
    "id" TEXT NOT NULL,
    "quotation_number" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "coupon_discount" DECIMAL(10,2),
    "coupon_id" TEXT,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "cgst_amount" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "sgst_amount" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "total_amount_with_gst" DECIMAL(10,2) NOT NULL,
    "total_discounted_amount" DECIMAL(10,2),
    "status" "public"."QuotationStatus" NOT NULL DEFAULT 'pending',
    "rejection_reason" TEXT,
    "created_by" TEXT NOT NULL,
    "created_by_type" "public"."QuotationCreatorType" NOT NULL,
    "address_id" TEXT NOT NULL,
    "updated_by" TEXT,
    "updated_by_type" "public"."QuotationCreatorType",
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "quotations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."quotations_items" (
    "id" TEXT NOT NULL,
    "cart_id" TEXT,
    "quotation_id" TEXT NOT NULL,
    "product_name" TEXT NOT NULL,
    "hsn_code" TEXT NOT NULL,
    "hsn_code_id" TEXT,
    "unit" TEXT,
    "quantity" INTEGER NOT NULL,
    "rate" DECIMAL(10,2) NOT NULL,
    "discount" DECIMAL(10,2),
    "total_amount" DECIMAL(10,2) NOT NULL,
    "discounted_amt" DECIMAL(10,2),
    "discounted_total_amount" DECIMAL(10,2),

    CONSTRAINT "quotations_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."calculate_gsts" (
    "id" TEXT NOT NULL,
    "hsn_code_id" TEXT NOT NULL,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "cgst_total" DECIMAL(10,2) NOT NULL,
    "sgst_total" DECIMAL(10,2) NOT NULL,
    "tax_amount" DECIMAL(10,2) NOT NULL,
    "quotation_id" TEXT NOT NULL,

    CONSTRAINT "calculate_gsts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."payments" (
    "id" TEXT NOT NULL,
    "quotation_id" TEXT,
    "payment_type" "public"."PaymentType" NOT NULL,
    "status" "public"."PaymentStatus" NOT NULL DEFAULT 'pending',
    "amount" DECIMAL(10,2) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."offline_payments" (
    "id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "file_url" TEXT NOT NULL,
    "offline_payment_type" "public"."OfflinePaymentType" NOT NULL DEFAULT 'upi',

    CONSTRAINT "offline_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."online_payments" (
    "id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "currency" TEXT NOT NULL,
    "payment_method" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "signature_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "online_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."credit_payments" (
    "id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "used_credit" DECIMAL(10,2) NOT NULL,
    "remaining_credit" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "credit_payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."orders" (
    "id" TEXT NOT NULL,
    "payment_id" TEXT NOT NULL,
    "order_status" "public"."OrderStatus" NOT NULL,
    "order_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."shipment_modes" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "mode_name" "public"."ShipmentModeType" NOT NULL,

    CONSTRAINT "shipment_modes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."transport_details" (
    "id" TEXT NOT NULL,
    "mode_id" TEXT NOT NULL,
    "vehicle_number" TEXT NOT NULL,
    "driver_number" TEXT NOT NULL,

    CONSTRAINT "transport_details_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."travel_agencies" (
    "id" TEXT NOT NULL,
    "mode_id" TEXT NOT NULL,
    "agency_name" TEXT NOT NULL,
    "lr_number" TEXT,

    CONSTRAINT "travel_agencies_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."articles" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "image_url" TEXT NOT NULL,
    "numbers" INTEGER NOT NULL,

    CONSTRAINT "articles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."eway_bills" (
    "id" TEXT NOT NULL,
    "order_id" TEXT NOT NULL,
    "eway_bill" TEXT NOT NULL,
    "ack_no" TEXT,
    "ack_dt" TIMESTAMP(3),
    "irn" TEXT,
    "signed_invoice" TEXT,
    "signed_qr_code" TEXT,
    "status" TEXT,
    "ewb_no" TEXT,
    "ewb_dt" TIMESTAMP(3),
    "ewb_valid_till" TIMESTAMP(3),
    "e_invoice_doc" TEXT,

    CONSTRAINT "eway_bills_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."eway_bill_auth_tokens" (
    "id" TEXT NOT NULL,
    "auth_token" TEXT NOT NULL,
    "token_expiry" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "eway_bill_auth_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."profile_images" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "image_url" TEXT,

    CONSTRAINT "profile_images_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_number_key" ON "public"."users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "public"."users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_companies_company_name_key" ON "public"."nbfc_companies"("company_name");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_companies_email_key" ON "public"."nbfc_companies"("email");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_companies_phone_number_key" ON "public"."nbfc_companies"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_companies_gst_number_key" ON "public"."nbfc_companies"("gst_number");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_users_phone_number_key" ON "public"."nbfc_users"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "nbfc_users_email_key" ON "public"."nbfc_users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "sector_category_images_url_key" ON "public"."sector_category_images"("url");

-- CreateIndex
CREATE UNIQUE INDEX "sectors_name_key" ON "public"."sectors"("name");

-- CreateIndex
CREATE UNIQUE INDEX "sectors_image_id_key" ON "public"."sectors"("image_id");

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "public"."categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "sub_categories_name_key" ON "public"."sub_categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "sub_categories_image_id_key" ON "public"."sub_categories"("image_id");

-- CreateIndex
CREATE UNIQUE INDEX "hsn_codes_hsn_code_key" ON "public"."hsn_codes"("hsn_code");

-- CreateIndex
CREATE UNIQUE INDEX "brands_name_key" ON "public"."brands"("name");

-- CreateIndex
CREATE UNIQUE INDEX "products_name_key" ON "public"."products"("name");

-- CreateIndex
CREATE UNIQUE INDEX "products_name_sub_category_id_brand_id_key" ON "public"."products"("name", "sub_category_id", "brand_id");

-- CreateIndex
CREATE UNIQUE INDEX "inventories_sku_id_key" ON "public"."inventories"("sku_id");

-- CreateIndex
CREATE UNIQUE INDEX "inventories_product_id_variation_value_key" ON "public"."inventories"("product_id", "variation_value");

-- CreateIndex
CREATE UNIQUE INDEX "product_images_url_key" ON "public"."product_images"("url");

-- CreateIndex
CREATE UNIQUE INDEX "customers_phone_number_key" ON "public"."customers"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "customers_email_key" ON "public"."customers"("email");

-- CreateIndex
CREATE UNIQUE INDEX "bank_details_customer_id_key" ON "public"."bank_details"("customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "bank_details_account_number_key" ON "public"."bank_details"("account_number");

-- CreateIndex
CREATE UNIQUE INDEX "gst_details_customer_id_key" ON "public"."gst_details"("customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "gst_details_gstin_key" ON "public"."gst_details"("gstin");

-- CreateIndex
CREATE UNIQUE INDEX "it_details_customer_id_key" ON "public"."it_details"("customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "it_details_pan_key" ON "public"."it_details"("pan");

-- CreateIndex
CREATE UNIQUE INDEX "customer_documents_file_url_key" ON "public"."customer_documents"("file_url");

-- CreateIndex
CREATE UNIQUE INDEX "coupons_coupon_code_key" ON "public"."coupons"("coupon_code");

-- CreateIndex
CREATE UNIQUE INDEX "quotations_quotation_number_key" ON "public"."quotations"("quotation_number");

-- CreateIndex
CREATE UNIQUE INDEX "offline_payments_payment_id_key" ON "public"."offline_payments"("payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "online_payments_payment_id_key" ON "public"."online_payments"("payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "credit_payments_payment_id_key" ON "public"."credit_payments"("payment_id");

-- CreateIndex
CREATE UNIQUE INDEX "orders_order_number_key" ON "public"."orders"("order_number");

-- AddForeignKey
ALTER TABLE "public"."nbfc_users" ADD CONSTRAINT "nbfc_users_nbfc_company_id_fkey" FOREIGN KEY ("nbfc_company_id") REFERENCES "public"."nbfc_companies"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."sectors" ADD CONSTRAINT "sectors_image_id_fkey" FOREIGN KEY ("image_id") REFERENCES "public"."sector_category_images"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."categories" ADD CONSTRAINT "categories_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "public"."sectors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."categories" ADD CONSTRAINT "categories_image_id_fkey" FOREIGN KEY ("image_id") REFERENCES "public"."sector_category_images"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."sub_categories" ADD CONSTRAINT "sub_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."sub_categories" ADD CONSTRAINT "sub_categories_image_id_fkey" FOREIGN KEY ("image_id") REFERENCES "public"."sector_category_images"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."brands" ADD CONSTRAINT "brands_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "public"."sub_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."brands" ADD CONSTRAINT "brands_image_id_fkey" FOREIGN KEY ("image_id") REFERENCES "public"."sector_category_images"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "public"."sub_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_hsn_code_id_fkey" FOREIGN KEY ("hsn_code_id") REFERENCES "public"."hsn_codes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."products" ADD CONSTRAINT "products_brand_id_fkey" FOREIGN KEY ("brand_id") REFERENCES "public"."brands"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."inventories" ADD CONSTRAINT "inventories_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."product_images" ADD CONSTRAINT "product_images_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."business_details" ADD CONSTRAINT "business_details_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."addresses" ADD CONSTRAINT "addresses_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."bank_details" ADD CONSTRAINT "bank_details_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."gst_details" ADD CONSTRAINT "gst_details_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."it_details" ADD CONSTRAINT "it_details_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."line_of_credit_applications" ADD CONSTRAINT "line_of_credit_applications_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."line_of_credit_applications" ADD CONSTRAINT "line_of_credit_applications_bank_id_fkey" FOREIGN KEY ("bank_id") REFERENCES "public"."bank_details"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."line_of_credit_applications" ADD CONSTRAINT "line_of_credit_applications_it_id_fkey" FOREIGN KEY ("it_id") REFERENCES "public"."it_details"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."line_of_credit_applications" ADD CONSTRAINT "line_of_credit_applications_gst_id_fkey" FOREIGN KEY ("gst_id") REFERENCES "public"."gst_details"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."loc_approvals" ADD CONSTRAINT "loc_approvals_loc_id_fkey" FOREIGN KEY ("loc_id") REFERENCES "public"."line_of_credit_applications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."loc_approvals" ADD CONSTRAINT "loc_approvals_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "public"."nbfc_users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."credit_reimbursements" ADD CONSTRAINT "credit_reimbursements_loc_approval_id_fkey" FOREIGN KEY ("loc_approval_id") REFERENCES "public"."loc_approvals"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."coupons" ADD CONSTRAINT "coupons_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."coupons" ADD CONSTRAINT "coupons_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."carts" ADD CONSTRAINT "carts_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."carts" ADD CONSTRAINT "carts_inventory_id_fkey" FOREIGN KEY ("inventory_id") REFERENCES "public"."inventories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations" ADD CONSTRAINT "quotations_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations" ADD CONSTRAINT "quotations_coupon_id_fkey" FOREIGN KEY ("coupon_id") REFERENCES "public"."coupons"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations" ADD CONSTRAINT "quotations_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."addresses"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations" ADD CONSTRAINT "quotations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations" ADD CONSTRAINT "quotations_updated_by_fkey" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations_items" ADD CONSTRAINT "quotations_items_cart_id_fkey" FOREIGN KEY ("cart_id") REFERENCES "public"."carts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations_items" ADD CONSTRAINT "quotations_items_quotation_id_fkey" FOREIGN KEY ("quotation_id") REFERENCES "public"."quotations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."quotations_items" ADD CONSTRAINT "quotations_items_hsn_code_id_fkey" FOREIGN KEY ("hsn_code_id") REFERENCES "public"."hsn_codes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."calculate_gsts" ADD CONSTRAINT "calculate_gsts_hsn_code_id_fkey" FOREIGN KEY ("hsn_code_id") REFERENCES "public"."hsn_codes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."calculate_gsts" ADD CONSTRAINT "calculate_gsts_quotation_id_fkey" FOREIGN KEY ("quotation_id") REFERENCES "public"."quotations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."payments" ADD CONSTRAINT "payments_quotation_id_fkey" FOREIGN KEY ("quotation_id") REFERENCES "public"."quotations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."offline_payments" ADD CONSTRAINT "offline_payments_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."online_payments" ADD CONSTRAINT "online_payments_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."credit_payments" ADD CONSTRAINT "credit_payments_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."orders" ADD CONSTRAINT "orders_payment_id_fkey" FOREIGN KEY ("payment_id") REFERENCES "public"."payments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."shipment_modes" ADD CONSTRAINT "shipment_modes_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."transport_details" ADD CONSTRAINT "transport_details_mode_id_fkey" FOREIGN KEY ("mode_id") REFERENCES "public"."shipment_modes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."travel_agencies" ADD CONSTRAINT "travel_agencies_mode_id_fkey" FOREIGN KEY ("mode_id") REFERENCES "public"."shipment_modes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."articles" ADD CONSTRAINT "articles_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."eway_bills" ADD CONSTRAINT "eway_bills_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."profile_images" ADD CONSTRAINT "profile_images_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON DELETE CASCADE ON UPDATE CASCADE;
