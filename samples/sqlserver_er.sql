CREATE TABLE "users"(
    "id" INT NOT NULL,
    "name" NVARCHAR(255) NOT NULL,
    "email" NVARCHAR(255) NOT NULL,
    "email_verified_at" DATETIME NULL,
    "password" NVARCHAR(255) NOT NULL,
    "remember_token" NVARCHAR(255) NULL,
    "created_at" DATETIME NOT NULL,
    "updated_at" DATETIME NOT NULL,
    "phone_number" NVARCHAR(255) NOT NULL,
    "description" NVARCHAR(255) NOT NULL,
    "profile_image" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "users" ADD CONSTRAINT "users_id_primary" PRIMARY KEY("id");
CREATE UNIQUE INDEX "users_email_unique" ON
    "users"("email");
CREATE TABLE "rooms"(
    "id" INT NOT NULL,
    "home_type" NVARCHAR(255) NOT NULL,
    "room_type" NVARCHAR(255) NOT NULL,
    "total_occupancy" INT NOT NULL,
    "total_bedrooms" INT NOT NULL,
    "total_bathrooms" INT NOT NULL,
    "summary" NVARCHAR(255) NOT NULL,
    "address" NVARCHAR(255) NOT NULL,
    "has_tv" BIT NOT NULL,
    "has_kitchen" BIT NOT NULL,
    "has_air_con" BIT NOT NULL,
    "has_heating" BIT NOT NULL,
    "has_internet" BIT NOT NULL,
    "price" INT NOT NULL,
    "published_at" DATETIME NOT NULL,
    "owner_id" INT NOT NULL,
    "created_at" DATETIME NOT NULL,
    "updated_at" DATETIME NOT NULL,
    "latitude" FLOAT NOT NULL,
    "longitude" FLOAT NOT NULL
);
ALTER TABLE
    "rooms" ADD CONSTRAINT "rooms_id_primary" PRIMARY KEY("id");
CREATE TABLE "reservations"(
    "id" INT NOT NULL,
    "user_id" INT NOT NULL,
    "room_id" INT NOT NULL,
    "start_date" DATETIME NOT NULL,
    "end_date" DATETIME NOT NULL,
    "price" INT NOT NULL,
    "total" INT NOT NULL,
    "created_at" DATETIME NOT NULL,
    "updated_at" DATETIME NOT NULL
);
ALTER TABLE
    "reservations" ADD CONSTRAINT "reservations_id_primary" PRIMARY KEY("id");
CREATE TABLE "media"(
    "id" INT NOT NULL,
    "model_id" INT NOT NULL,
    "model_type" NVARCHAR(255) NOT NULL,
    "file_name" NVARCHAR(255) NOT NULL,
    "mime_type" NVARCHAR(255) NULL
);
ALTER TABLE
    "media" ADD CONSTRAINT "media_id_primary" PRIMARY KEY("id");
CREATE TABLE "reviews"(
    "id" INT NOT NULL,
    "reservation_id" INT NOT NULL,
    "rating" INT NOT NULL,
    "comment" NVARCHAR(255) NOT NULL
);
ALTER TABLE
    "reviews" ADD CONSTRAINT "reviews_id_primary" PRIMARY KEY("id");
ALTER TABLE
    "rooms" ADD CONSTRAINT "rooms_published_at_foreign" FOREIGN KEY("published_at") REFERENCES "users"("id");
ALTER TABLE
    "reservations" ADD CONSTRAINT "reservations_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "reservations" ADD CONSTRAINT "reservations_room_id_foreign" FOREIGN KEY("room_id") REFERENCES "rooms"("id");
ALTER TABLE
    "reviews" ADD CONSTRAINT "reviews_reservation_id_foreign" FOREIGN KEY("reservation_id") REFERENCES "reservations"("id");
ALTER TABLE
    "media" ADD CONSTRAINT "media_model_id_foreign" FOREIGN KEY("model_id") REFERENCES "reviews"("id");
ALTER TABLE
    "media" ADD CONSTRAINT "media_model_id_foreign" FOREIGN KEY("model_id") REFERENCES "rooms"("id");