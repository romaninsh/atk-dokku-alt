CREATE TABLE `dam_host` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `addr` varchar(255) DEFAULT NULL,
  `notes` text,
  `private_key` text,
  `public_key` text,
  `is_debug` tinyint(1) DEFAULT NULL,
  `dokku_version` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_host_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host_id` int(11) NOT NULL,
  `line` text,
  `ts` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_host_log_host1_idx` (`host_id`),
  CONSTRAINT `fk_host_log_host1` FOREIGN KEY (`host_id`) REFERENCES `dam_host` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=203 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_db` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `host_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_db_host1_idx` (`host_id`),
  CONSTRAINT `fk_db_host1` FOREIGN KEY (`host_id`) REFERENCES `dam_host` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_keychain` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `class` varchar(255) DEFAULT NULL,
  `host` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `data` text,
  `notes` text,
  `is_secure` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `host_id` int(11) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `is_started` tinyint(1) DEFAULT NULL,
  `is_enabled` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `buildpack_url` varchar(255) DEFAULT NULL,
  `last_build` text,
  `keychain_id` int(11) unsigned DEFAULT NULL,
  `repository` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_app_host_idx` (`host_id`),
  KEY `fk_app_keychain1_idx` (`keychain_id`),
  CONSTRAINT `fk_app_host` FOREIGN KEY (`host_id`) REFERENCES `dam_host` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_app_keychain1` FOREIGN KEY (`keychain_id`) REFERENCES `dam_keychain` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `value` text,
  `app_id` int(11) NOT NULL,
  `is_dam_controlled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_config_app1_idx` (`app_id`),
  CONSTRAINT `fk_config_app1` FOREIGN KEY (`app_id`) REFERENCES `dam_app` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dam_access` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fingerprint` varchar(255) DEFAULT NULL,
  `publickey` text,
  `privatekey` text,
  `app_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `host_id` int(11) DEFAULT NULL,
  `is_dam_controlled` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_access_app1_idx` (`app_id`),
  KEY `fk_access_host1_idx` (`host_id`),
  CONSTRAINT `fk_access_app1` FOREIGN KEY (`app_id`) REFERENCES `dam_app` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_access_host1` FOREIGN KEY (`host_id`) REFERENCES `dam_host` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `dam_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `app_id` int(11) NOT NULL,
  `is_redirect` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_domain_app1_idx` (`app_id`),
  CONSTRAINT `fk_domain_app1` FOREIGN KEY (`app_id`) REFERENCES `dam_app` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `dam_db_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `db_id` int(11) NOT NULL,
  `app_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_db_link_db1_idx` (`db_id`),
  KEY `fk_db_link_app1_idx` (`app_id`),
  CONSTRAINT `fk_db_link_app1` FOREIGN KEY (`app_id`) REFERENCES `dam_app` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_db_link_db1` FOREIGN KEY (`db_id`) REFERENCES `dam_db` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8
