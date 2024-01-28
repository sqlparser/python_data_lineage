CREATE TABLE "ticketit_statuses"(
    "id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "color" BIGINT NOT NULL
);
ALTER TABLE
    "ticketit_statuses" ADD PRIMARY KEY("id");
CREATE TABLE "ticketit_priorities"(
    "id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "color" BIGINT NOT NULL
);
ALTER TABLE
    "ticketit_priorities" ADD PRIMARY KEY("id");
CREATE TABLE "ticketit_categories"(
    "id" INTEGER NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "color" BIGINT NOT NULL
);
ALTER TABLE
    "ticketit_categories" ADD PRIMARY KEY("id");
CREATE TABLE "ticketit_categories_users"(
    "category_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL
);
ALTER TABLE
    "ticketit_categories_users" ADD PRIMARY KEY("category_id");
CREATE TABLE "ticketit"(
    "id" INTEGER NOT NULL,
    "subject" VARCHAR(255) NOT NULL,
    "content" TEXT NOT NULL,
    "html" TEXT NULL,
    "status_id" INTEGER NOT NULL,
    "priority_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "agent_id" INTEGER NOT NULL,
    "category_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "updated_at" BIGINT NOT NULL,
    "completed_at" TIMESTAMP(0) WITHOUT TIME ZONE NULL
);
ALTER TABLE
    "ticketit" ADD PRIMARY KEY("id");
CREATE INDEX "ticketit_subject_index" ON
    "ticketit"("subject");
CREATE INDEX "ticketit_status_id_index" ON
    "ticketit"("status_id");
CREATE INDEX "ticketit_priority_id_index" ON
    "ticketit"("priority_id");
CREATE INDEX "ticketit_user_id_index" ON
    "ticketit"("user_id");
CREATE INDEX "ticketit_agent_id_index" ON
    "ticketit"("agent_id");
CREATE INDEX "ticketit_category_id_index" ON
    "ticketit"("category_id");
CREATE INDEX "ticketit_completed_at_index" ON
    "ticketit"("completed_at");
CREATE TABLE "ticketit_comments"(
    "id" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "ticket_id" INTEGER NOT NULL,
    "created_at" BIGINT NOT NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "content" TEXT NOT NULL,
    "html" TEXT NULL
);
ALTER TABLE
    "ticketit_comments" ADD PRIMARY KEY("id");
CREATE INDEX "ticketit_comments_user_id_index" ON
    "ticketit_comments"("user_id");
CREATE INDEX "ticketit_comments_ticket_id_index" ON
    "ticketit_comments"("ticket_id");
CREATE TABLE "ticketit_audits"(
    "id" INTEGER NOT NULL,
    "operation" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "ticket_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "ticketit_audits" ADD PRIMARY KEY("id");
CREATE TABLE "users"(
    "id" INTEGER NOT NULL,
    "ticketit_admin" BOOLEAN NOT NULL,
    "ticketit_agent" BOOLEAN NOT NULL
);
ALTER TABLE
    "users" ADD PRIMARY KEY("id");
CREATE TABLE "ticketit_settings"(
    "id" INTEGER NOT NULL,
    "lang" VARCHAR(255) NULL,
    "slug" VARCHAR(255) NOT NULL,
    "value" TEXT NOT NULL,
    "default" TEXT NOT NULL,
    "created_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "updated_at" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "ticketit_settings" ADD PRIMARY KEY("id");
ALTER TABLE
    "ticketit_settings" ADD CONSTRAINT "ticketit_settings_lang_unique" UNIQUE("lang");
ALTER TABLE
    "ticketit_settings" ADD CONSTRAINT "ticketit_settings_slug_unique" UNIQUE("slug");
ALTER TABLE
    "ticketit" ADD CONSTRAINT "ticketit_priority_id_foreign" FOREIGN KEY("priority_id") REFERENCES "ticketit_priorities"("id");
ALTER TABLE
    "ticketit" ADD CONSTRAINT "ticketit_status_id_foreign" FOREIGN KEY("status_id") REFERENCES "ticketit_statuses"("id");
ALTER TABLE
    "ticketit" ADD CONSTRAINT "ticketit_agent_id_foreign" FOREIGN KEY("agent_id") REFERENCES "users"("id");
ALTER TABLE
    "ticketit" ADD CONSTRAINT "ticketit_category_id_foreign" FOREIGN KEY("category_id") REFERENCES "ticketit_categories"("id");
ALTER TABLE
    "ticketit_comments" ADD CONSTRAINT "ticketit_comments_ticket_id_foreign" FOREIGN KEY("ticket_id") REFERENCES "ticketit"("id");
ALTER TABLE
    "ticketit_audits" ADD CONSTRAINT "ticketit_audits_ticket_id_foreign" FOREIGN KEY("ticket_id") REFERENCES "ticketit"("id");
ALTER TABLE
    "ticketit" ADD CONSTRAINT "ticketit_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "ticketit_categories_users" ADD CONSTRAINT "ticketit_categories_users_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "ticketit_comments" ADD CONSTRAINT "ticketit_comments_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");
ALTER TABLE
    "ticketit_audits" ADD CONSTRAINT "ticketit_audits_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "users"("id");