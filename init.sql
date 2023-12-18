SET
    CLIENT_ENCODING TO UTF8;

SET
    STANDARD_CONFORMING_STRINGS TO ON;

BEGIN;

CREATE TYPE physical_dimentions AS (
    height numeric(4, 2),
    width numeric(4, 2),
    weight numeric(4, 2)
);

CREATE TYPE ADDRESS AS (
    line1 text,
    line2 text,
    country text,
    state_province text,
    city text,
    postal_code text
);

CREATE DOMAIN MONEY AS numeric(10, 2);

CREATE TABLE "product" (
    "product_id" serial,
    "short_name" varchar(16),
    "long_name" varchar(128),
    "sku" text,
    "dimentions" physical_dimentions,
    "price" MONEY,
    "short_description" text,
    "long_description" text,
    "thumbnail" text,
    "created_at" date,
    "last_updated_at" date,
    "stock" integer,
    PRIMARY KEY ("product_id")
);

CREATE TABLE "product_category" (
    "product_id" INTEGER REFERENCES "product" ("product_id"),
    "category" varchar(16),
    PRIMARY KEY ("product_id", "category")
);

CREATE TABLE "user" (
    "user_id" serial,
    "full_name" text,
    "email" text,
    "verified_email" boolean,
    "phone_number" text,
    "verified_phone_number" boolean,
    "created_at" date,
    "last_updated_at" date,
    PRIMARY KEY ("user_id")
);

CREATE TABLE "cart_item" (
    "user_id" INTEGER REFERENCES "user" ("user_id"),
    "product_id" INTEGER REFERENCES "product" ("product_id"),
    "quantity" integer,
    PRIMARY KEY ("user_id", "product_id")
);

CREATE TABLE "order" (
    "order_id" serial,
    "user_id" INTEGER REFERENCES "user" ("user_id"),
    "billing_address" ADDRESS,
    "shiping_address" ADDRESS,
    "shipping" MONEY,
    "line_total" MONEY,
    "tax" MONEY,
    "order_amount" MONEY,
    "shipped" boolean,
    "tracking_ref" text,
    PRIMARY KEY ("order_id")
);

CREATE TABLE "order_line" (
    "order_id" INTEGER REFERENCES "order" ("order_id"),
    "product_id" INTEGER REFERENCES "product" ("product_id"),
    "quantity" integer,
    PRIMARY KEY ("order_id", "product_id")
);

CREATE ROLE anon NOLOGIN NOINHERIT NOCREATEDB NOCREATEROLE NOSUPERUSER;

REVOKE ALL PRIVILEGES ON DATABASE "store"
FROM
    PUBLIC;

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public
FROM
    PUBLIC;

-- REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public
FROM
    PUBLIC;

-- Allow the user to only use the specified functions.
GRANT CONNECT ON DATABASE "store" TO anon;

GRANT
SELECT
    ON TABLE "product" TO anon;

GRANT
SELECT
    ON TABLE "cart_item" TO anon;

GRANT
SELECT
    ON TABLE "order" TO anon;

GRANT
SELECT
    ON TABLE "order_line" TO anon;

COMMIT;