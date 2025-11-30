Create DATABASE CRM_General;

-- ENUMS
CREATE TYPE User_Status_Enum AS ENUM ('ACTIVE', 'INACTIVE', 'VERIFYING', 'BANNED');
CREATE TYPE User_Type_Enum AS ENUM ('USER', 'ADMIN', 'STAFF', 'MANAGER', 'OWNER', 'GUEST', 'RECEPTION', 'SUPPLIERS');
CREATE TYPE Assets_Type_Enum AS ENUM ('USER', 'ENTITY', 'SERVICE', 'PRODUCT');
CREATE TYPE Change_Inventory_Type_Enum AS ENUM ('ADD', 'REMOVE', 'ADJUST');
CREATE TYPE Appointment_Enum AS ENUM ('SCHEDULED','ACEPTED','ARRIVING','WAITING','IN-PROCESS','COMPLETED','CANCELLED');

-- TABLES --------

-- Users Tables

CREATE TABLE USER_TYPE (
    Id_User_Type    SERIAL PRIMARY KEY NOT NULL,
    Name_Type       User_Type_Enum DEFAULT 'USER',
    Description     TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE
);

CREATE TABLE USERS(
    Id_User         UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    First_Name	    VARCHAR(100) NOT NULL,
    Second_Name	    VARCHAR(100),
    RFC	            VARCHAR(13) UNIQUE,
    Birthday        TIMESTAMP,
    Phone	        VARCHAR(15) NOT NULL UNIQUE,
    Email	        VARCHAR(100) NOT NULL UNIQUE,
    Gender	        VARCHAR(20) DEFAULT 'Not Specified',
    Address	        VARCHAR(100),
    Social_link     VARCHAR(100),
    Region	        VARCHAR(10),
    Rating	        INT DEFAULT 0,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    User_Verified   BOOLEAN DEFAULT TRUE,
    Status          User_Status_Enum DEFAULT 'ACTIVE',
    Image_URL       VARCHAR(255),
    Id_User_Type_f  INT REFERENCES User_Type(Id_User_Type),
);

CREATE TABLE USER_REVIEWS (
    Id_Review       UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Rating          INT DEFAULT 0,
    Comment         TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Reviewer_f   UUID REFERENCES USERS(Id_User)
);

CREATE TABLE USER_PERMISSIONS (
    Id_Permission   UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Permission_Code VARCHAR(100) NOT NULL,
    Can_Create      BOOLEAN DEFAULT TRUE,
    Can_Read        BOOLEAN DEFAULT TRUE,
    Can_Update      BOOLEAN DEFAULT TRUE,
    Can_Delete      BOOLEAN DEFAULT TRUE,
    Description     TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_User_Type_f  INT REFERENCES USER_TYPE(Id_User_Type)
);

CREATE TABLE REWARDS (
    Id_Rewards      UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Points          VARCHAR(100),
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_User_f       UUID REFERENCES USERS(Id_User)
);

-- Services Tables

CREATE TABLE SERVICE_CATEGORY (
    Id_Service_Cat  SERIAL PRIMARY KEY NOT NULL,
    Name_Category   VARCHAR(100),
    Description     TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE
);

CREATE TABLE SERVICES (
    Id_Service      UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Name_Service    VARCHAR(100) NOT NULL,
    Description     TEXT,
    Duration_Min    INT DEFAULT 0,
    Price           DECIMAL(10, 2),
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Image_URL       VARCHAR(255),
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity),
    Id_Category_f   INT REFERENCES SERVICE_CATEGORY(Id_Service_Cat)
);


CREATE TABLE SERVICE_REVIEWS (
    Id_Review       UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Rating          INT DEFAULT 0,
    Comment         TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Service_f    UUID REFERENCES SERVICES(Id_Service)
);

CREATE TABLE SERVICE_PHOTOS (
    Id_Photo        UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Photo_URL       VARCHAR(255),
    Classification  Assets_Type_Enum DEFAULT 'SERVICE',
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Service_f    UUID REFERENCES SERVICES(Id_Service)
);

CREATE TABLE SERVICE_PROMOTIONS (
    Id_Promotion    UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Promo_Code      VARCHAR(50), --AUTO GENERATE IN FRONTEND
    Name_Promotion  VARCHAR(100),
    Description     TEXT,
    URL_Image       VARCHAR(255),
    Use_Limit       INT DEFAULT 0,
    Discount_Per    DECIMAL(5, 2),
    Start_Date      TIMESTAMP,
    End_Date        TIMESTAMP,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Service_f    UUID REFERENCES SERVICES(Id_Service),
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

-- Entity Tables

CREATE TABLE ENTITYS (
    Id_Entity	    UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Name	        VARCHAR(100) NOT NULL,	
    Address	        VARCHAR(100) NOT NULL UNIQUE,	
    Phone	        VARCHAR(15) NOT NULL UNIQUE,	
    Email_Contact	VARCHAR(100) UNIQUE,	
    Description	    TEXT,
    Capacity_Count	INT DEFAULT 0,	
    Staff_Count	    INT DEFAULT 0,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FB_Link	        VARCHAR(100),
    Insta_Link	    VARCHAR(100),	
    TikTok_Link	    VARCHAR(100),	
    Image_URL       VARCHAR(255),
    IsOpen          BOOLEAN DEFAULT TRUE,
    Id_Owner_f      UUID REFERENCES USERS(Id_User)
);

CREATE TABLE ENTITY_REVIEWS (
    Id_Review       UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Rating          INT DEFAULT 0,
    Comment         TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

CREATE TABLE ENTITY_STAFF (
    Id_Staff        UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Role            VARCHAR(100),
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

CREATE TABLE ENTITY_SERVICES (
    Id_Entity_Service UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity),
    Id_Service_f    UUID REFERENCES SERVICES(Id_Service)
);

CREATE TABLE ENTITY_TIMINGS (
    Id_Entity_Timing UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,
    Day_of_Week     VARCHAR(20),
    Open_Time       TIME,
    Close_Time      TIME,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

CREATE TABLE ENTITY_PHOTOS (
    Id_Photo        UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Photo_URL       VARCHAR(255),
    Classification  Assets_Type_Enum DEFAULT 'ENTITY',
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

CREATE TABLE BILL_CATEGORY (
    Id_Bill_Cat     SERIAL PRIMARY KEY NOT NULL,
    Name_Category   VARCHAR(100),
    Description     TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE
);

CREATE TABLE BILLS (
    Id_Bill         SERIAL PRIMARY KEY NOT NULL,
    Name            VARCHAR(100) NOT NULL,
    Description     TEXT,
    Amount          DECIMAL(10, 2),
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsRecurring     BOOLEAN DEFAULT FALSE,
    Type_payment    VARCHAR(50),
    Due_Date        TIMESTAMP,
    Reference_Id    VARCHAR(100),
    Notes           TEXT,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity),
    Id_Category_f   INT REFERENCES BILL_CATEGORY(Id_Bill_Cat)
);


-- Products Tables

CREATE TABLE PRODUCTS (
    Id_Product      UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Name_Product    VARCHAR(100) NOT NULL,
    Description     TEXT,
    Price           DECIMAL(10, 2),
    Stock_Quantity  INT DEFAULT 0,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Image_URL       VARCHAR(255),
    Status          BOOLEAN DEFAULT TRUE,
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity),
    Id_Category_f   INT REFERENCES PRODUCT_CATEGORY(Id_Product_Cat)
);

CREATE TABLE PRODUCT_PHOTOS (
    Id_Photo        UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Photo_URL       VARCHAR(255),
    Classification  Assets_Type_Enum DEFAULT 'PRODUCT',
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Product_f    UUID REFERENCES PRODUCTS(Id_Product)
);

CREATE TABLE PRODUCT_REVIEWS (
    Id_Review       UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Rating          INT DEFAULT 0,
    Comment         TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Product_f    UUID REFERENCES PRODUCTS(Id_Product)
);

CREATE TABLE PRODUCT_CATEGORY (
    Id_Product_Cat  SERIAL PRIMARY KEY NOT NULL,
    Name_Category   VARCHAR(100),
    Description     TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE
);

CREATE Table PRODUCT_INVENTORY_LOGS (
    Id_Inventory_Log UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Change_Quantity INT,
    Change_Type     Change_Inventory_Type_Enum DEFAULT 'ADJUST',
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Id_Product_f    UUID REFERENCES PRODUCTS(Id_Product),
    Id_User_f       UUID REFERENCES USERS(Id_User)
);

CREATE TABLE SUPPLIERS (
    Id_Supplier     UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Name_Supplier   VARCHAR(100) NOT NULL,
    Contact_Name    VARCHAR(100) NOT NULL,
    Phone	        VARCHAR(15) NOT NULL UNIQUE,	
    Email	        VARCHAR(100) NOT NULL UNIQUE,
    RFC             VARCHAR(13) NOT NULL UNIQUE,	
    Address	        VARCHAR(100) NOT NULL,	
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE
);

-- Appointments Table

CREATE TABLE APPOINTMENTS (
    Id_Appointment  UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Appointment_Date TIMESTAMP,
    Promo_Code      VARCHAR(50),
    Notes           TEXT,
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          VARCHAR(50) DEFAULT 'SCHEDULED',
    Id_User_f       UUID REFERENCES USERS(Id_User),
    Id_Staff_f      UUID REFERENCES USERS(Id_User),
    Id_Service_f    UUID REFERENCES SERVICES(Id_Service),
    Id_Entity_f     UUID REFERENCES ENTITYS(Id_Entity)
);

CREATE TABLE APPOINTMENT_PHOTOS (
    Id_Photo        UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    Photo_URL       VARCHAR(255),
    Classification  Assets_Type_Enum DEFAULT 'USER',
    CreatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status          BOOLEAN DEFAULT TRUE,
    Id_Appt_f       UUID REFERENCES APPOINTMENTS(Id_Appointment)
);


-- STORWE PROCEDURES, TRIGGERS, INDEXES

