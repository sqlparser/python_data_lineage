CREATE TABLE `permissions`(
    `id` BIGINT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `guard_name` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `updated_at` DATETIME NOT NULL
);
ALTER TABLE
    `permissions` ADD PRIMARY KEY `permissions_id_primary`(`id`);
CREATE TABLE `roles`(
    `id` BIGINT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `guard_name` VARCHAR(255) NOT NULL,
    `created_at` DATETIME NOT NULL,
    `updated_at` DATETIME NOT NULL
);
ALTER TABLE
    `roles` ADD PRIMARY KEY `roles_id_primary`(`id`);
CREATE TABLE `model_has_permissions`(
    `permission_id` BIGINT NOT NULL,
    `model_type` VARCHAR(255) NOT NULL,
    `model_id` INT NOT NULL
);
ALTER TABLE
    `model_has_permissions` ADD PRIMARY KEY `model_has_permissions_permission_id_model_id_model_type_primary`(
        `permission_id`,
        `model_id`,
        `model_type`
    );
ALTER TABLE
    `model_has_permissions` ADD INDEX `model_has_permissions_model_id_model_type_index`(`model_id`, `model_type`);
ALTER TABLE
    `model_has_permissions` ADD PRIMARY KEY `model_has_permissions_permission_id_primary`(`permission_id`);
ALTER TABLE
    `model_has_permissions` ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY(`permission_id`) REFERENCES `permissions`(`id`);
	
CREATE TABLE `model_has_roles`(
    `role_id` BIGINT NOT NULL,
    `model_type` VARCHAR(255) NOT NULL,
    `model_id` INT NOT NULL
);
ALTER TABLE
    `model_has_roles` ADD PRIMARY KEY `model_has_roles_role_id_model_id_model_type_primary`(`role_id`, `model_id`, `model_type`);
ALTER TABLE
    `model_has_roles` ADD INDEX `model_has_roles_model_id_model_type_index`(`model_id`, `model_type`);
ALTER TABLE
    `model_has_roles` ADD PRIMARY KEY `model_has_roles_role_id_primary`(`role_id`);
ALTER TABLE
    `model_has_roles`  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY(`role_id`) REFERENCES `roles`(`id`);

	
CREATE TABLE `role_has_permissions`(
    `permission_id` BIGINT NOT NULL,
    `role_id` BIGINT NOT NULL
);
ALTER TABLE
    `role_has_permissions` ADD PRIMARY KEY `role_has_permissions_permission_id_role_id_primary`(`permission_id`, `role_id`);
ALTER TABLE
    `role_has_permissions` ADD PRIMARY KEY `role_has_permissions_permission_id_primary`(`permission_id`);
ALTER TABLE
    `role_has_permissions` ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY(`role_id`) REFERENCES `roles`(`id`);
ALTER TABLE
    `role_has_permissions` ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY(`permission_id`) REFERENCES `permissions`(`id`);