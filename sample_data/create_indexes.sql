ALTER TABLE exposure ADD INDEX `property_ts` (`property_id`, `gad`, `ebc`);
ALTER TABLE exposure ADD INDEX `arrival_ts` (`gad`, `property_id`, `toro_flag`);
ALTER TABLE exposure ADD INDEX `booking_ts` (`exposure_date`, `property_id`, `toro_flag`);

ALTER TABLE x_upgrade_request ADD INDEX `index_property_id` (`PROPERTY_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_booking_id` (`BOOKING_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_to_category_id` (`TO_CATEGORY_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `index_awarded` (`AWARDED`);
ALTER TABLE x_upgrade_request ADD INDEX `index_modified_user_id` (`MODIFIED_USER_ID`);
ALTER TABLE x_upgrade_request ADD INDEX `revenue_ts` (`booking_id`,`awarded`,`total`);
ALTER TABLE x_upgrade_request ADD INDEX `property_id_ts` (`property_id`);
ALTER TABLE x_upgrade_request ADD INDEX `booking_id_ts` (`booking_id`);
ALTER TABLE x_upgrade_request ADD INDEX `category_id_ts` (`to_category_id`);
   

ALTER TABLE x_booking ADD INDEX  `toro_join` (`PROPERTY_ID`,`ARRIVAL`,`EXT_BOOKING_ID`,`UPGRADE_STATUS`,`UPGRADE_MATRIX_TYPE`);
ALTER TABLE x_booking ADD INDEX  `matrix_join` (`PROPERTY_ID`,`UPGRADE_MATRIX_ID`,`CATEGORY_ID`,`UPGRADE_STATUS`,`UPGRADE_MATRIX_TYPE`);
ALTER TABLE x_booking ADD INDEX  `arrival_ts` (`ARRIVAL`,`PROPERTY_ID`,`UPGRADE_STATUS`);
ALTER TABLE x_booking ADD INDEX  `created_ts` (`CREATED_DATE`,`PROPERTY_ID`,`UPGRADE_STATUS`);
ALTER TABLE x_booking ADD INDEX  `matrix_type_status` (`UPGRADE_MATRIX_TYPE`,`UPGRADE_STATUS`);