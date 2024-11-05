/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.9-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: core
-- ------------------------------------------------------
-- Server version	10.11.9-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `SESSIONS`
--

DROP TABLE IF EXISTS `SESSIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SESSIONS` (
  `ID` varchar(120) NOT NULL,
  `APP_NAME` varchar(120) NOT NULL,
  `LAST_ACCESSED` bigint(20) NOT NULL,
  `MAX_INACTIVE` int(11) NOT NULL,
  `EXPIRY_TIME` bigint(20) NOT NULL,
  `VALID` char(1) NOT NULL,
  `CONTEXT` varchar(120) NOT NULL,
  `DATA` blob DEFAULT NULL,
  PRIMARY KEY (`ID`,`APP_NAME`,`CONTEXT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SESSIONS`
--

LOCK TABLES `SESSIONS` WRITE;
/*!40000 ALTER TABLE `SESSIONS` DISABLE KEYS */;
/*!40000 ALTER TABLE `SESSIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_dashboard`
--

DROP TABLE IF EXISTS `core_admin_dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_dashboard` (
  `dashboard_name` varchar(100) NOT NULL,
  `dashboard_column` int(11) NOT NULL,
  `dashboard_order` int(11) NOT NULL,
  PRIMARY KEY (`dashboard_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_dashboard`
--

LOCK TABLES `core_admin_dashboard` WRITE;
/*!40000 ALTER TABLE `core_admin_dashboard` DISABLE KEYS */;
INSERT INTO `core_admin_dashboard` VALUES
('usersAdminDashboardComponent',1,2),
('searchAdminDashboardComponent',1,3),
('editorAdminDashboardComponent',1,4),
('autoIncludesAdminDashboardComponent',1,5),
('featuresAdminDashboardComponent',1,6),
('xslExportAdminDashboardComponent',1,7);
/*!40000 ALTER TABLE `core_admin_dashboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_mailinglist`
--

DROP TABLE IF EXISTS `core_admin_mailinglist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_mailinglist` (
  `id_mailinglist` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `workgroup` varchar(50) NOT NULL,
  PRIMARY KEY (`id_mailinglist`)
) ENGINE=MyISAM AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_mailinglist`
--

LOCK TABLES `core_admin_mailinglist` WRITE;
/*!40000 ALTER TABLE `core_admin_mailinglist` DISABLE KEYS */;
INSERT INTO `core_admin_mailinglist` VALUES
(1,'admin','admin','all');
/*!40000 ALTER TABLE `core_admin_mailinglist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_mailinglist_filter`
--

DROP TABLE IF EXISTS `core_admin_mailinglist_filter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_mailinglist_filter` (
  `id_mailinglist` int(11) NOT NULL DEFAULT 0,
  `workgroup` varchar(50) NOT NULL,
  `role` varchar(50) NOT NULL,
  PRIMARY KEY (`id_mailinglist`,`workgroup`,`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_mailinglist_filter`
--

LOCK TABLES `core_admin_mailinglist_filter` WRITE;
/*!40000 ALTER TABLE `core_admin_mailinglist_filter` DISABLE KEYS */;
INSERT INTO `core_admin_mailinglist_filter` VALUES
(1,'all','super_admin');
/*!40000 ALTER TABLE `core_admin_mailinglist_filter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_right`
--

DROP TABLE IF EXISTS `core_admin_right`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_right` (
  `id_right` varchar(255) NOT NULL DEFAULT '',
  `name` varchar(255) DEFAULT NULL,
  `level_right` smallint(6) DEFAULT NULL,
  `admin_url` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_updatable` int(11) NOT NULL DEFAULT 0,
  `plugin_name` varchar(50) DEFAULT NULL,
  `id_feature_group` varchar(50) DEFAULT NULL,
  `icon_url` varchar(255) DEFAULT NULL,
  `documentation_url` varchar(255) DEFAULT NULL,
  `id_order` int(11) DEFAULT NULL,
  `is_external_feature` smallint(6) DEFAULT 0,
  PRIMARY KEY (`id_right`),
  KEY `index_right` (`level_right`,`admin_url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_right`
--

LOCK TABLES `core_admin_right` WRITE;
/*!40000 ALTER TABLE `core_admin_right` DISABLE KEYS */;
INSERT INTO `core_admin_right` VALUES
('CORE_ADMIN_SITE','portal.site.adminFeature.admin_site.name',2,'jsp/admin/site/AdminSite.jsp','portal.site.adminFeature.admin_site.description',1,NULL,'SITE','ti ti-home-edit','jsp/admin/documentation/AdminDocumentation.jsp?doc=admin-site',1,0),
('CORE_ADMINDASHBOARD_MANAGEMENT','portal.admindashboard.adminFeature.right_management.name',0,NULL,'portal.admindashboard.adminFeature.right_management.description',0,'','SYSTEM','ti ti-dashboard',NULL,8,0),
('CORE_CACHE_MANAGEMENT','portal.system.adminFeature.cache_management.name',0,'jsp/admin/system/ManageCaches.jsp','portal.system.adminFeature.cache_management.description',1,'','SYSTEM','ti ti-clock-edit',NULL,1,0),
('CORE_DAEMONS_MANAGEMENT','portal.system.adminFeature.daemons_management.name',0,'jsp/admin/system/ManageDaemons.jsp','portal.system.adminFeature.daemons_management.description',0,'','SYSTEM','ti ti-timeline-event',NULL,7,0),
('CORE_DASHBOARD_MANAGEMENT','portal.dashboard.adminFeature.dashboard_management.name',0,NULL,'portal.dashboard.adminFeature.dashboard_management.description',0,'','SYSTEM','ti ti-layout-dashboard',NULL,9,0),
('CORE_EDITORS_MANAGEMENT','portal.admindashboard.editorManagement.right.name',2,NULL,'portal.admindashboard.editorManagement.right.description',1,'','SYSTEM','ti ti-tools',NULL,10,0),
('CORE_FEATURES_MANAGEMENT','portal.admin.adminFeature.features_management.name',0,NULL,'portal.admin.adminFeature.features_management.description',0,'','SYSTEM','ti ti-apps',NULL,6,0),
('CORE_LEVEL_RIGHT_MANAGEMENT','portal.users.adminFeature.level_right_management.name',2,NULL,'portal.users.adminFeature.level_right_management.description',0,'','MANAGERS','ti ti-list-detail',NULL,4,0),
('CORE_LINK_SERVICE_MANAGEMENT','portal.insert.adminFeature.linkService_management.name',2,NULL,'portal.insert.adminFeature.linkService_management.description',0,NULL,NULL,'ti ti-link',NULL,1,0),
('CORE_LOGS_VISUALISATION','portal.system.adminFeature.logs_visualisation.name',0,'jsp/admin/system/ManageFilesSystem.jsp','portal.system.adminFeature.logs_visualisation.description',1,'','SYSTEM','ti ti-list-search',NULL,4,0),
('CORE_MAILINGLISTS_MANAGEMENT','portal.mailinglist.adminFeature.mailinglists_management.name',2,'jsp/admin/mailinglist/ManageMailingLists.jsp','portal.mailinglist.adminFeature.mailinglists_management.description',0,'','MANAGERS','ti ti-mail-cog',NULL,5,0),
('CORE_PAGE_TEMPLATE_MANAGEMENT','portal.style.adminFeature.page_template_management.name',0,'jsp/admin/style/ManagePageTemplates.jsp','portal.style.adminFeature.page_template_management.description',0,'','STYLE','ti ti-layout-board',NULL,1,0),
('CORE_PLUGINS_MANAGEMENT','portal.system.adminFeature.plugins_management.name',0,'jsp/admin/system/ManagePlugins.jsp','portal.system.adminFeature.plugins_management.description',1,'','SYSTEM','ti ti-apps-filled',NULL,5,0),
('CORE_PROPERTIES_MANAGEMENT','portal.site.adminFeature.properties_management.name',2,'jsp/admin/ManageProperties.jsp','portal.site.adminFeature.properties_management.description',0,NULL,'SITE','ti ti-checklist','jsp/admin/documentation/AdminDocumentation.jsp?doc=admin-properties',2,0),
('CORE_RBAC_MANAGEMENT','portal.rbac.adminFeature.rbac_management.name',0,'jsp/admin/rbac/ManageRoles.jsp','portal.rbac.adminFeature.rbac_management.description',0,'','MANAGERS','ti ti-user-check',NULL,1,0),
('CORE_RIGHT_MANAGEMENT','portal.users.adminFeature.right_management.name',0,'jsp/admin/features/ManageRights.jsp','portal.users.adminFeature.right_management.description',0,'','MANAGERS','ti ti-gavel',NULL,6,0),
('CORE_ROLES_MANAGEMENT','portal.role.adminFeature.roles_management.name',2,'jsp/admin/role/ManagePageRole.jsp','portal.role.adminFeature.roles_management.description',0,'','USERS','ti ti-list-check',NULL,2,0),
('CORE_SEARCH_INDEXATION','portal.search.adminFeature.indexer.name',0,'jsp/admin/search/ManageSearchIndexation.jsp','portal.search.adminFeature.indexer.description',0,'','SYSTEM','ti ti-settings-search',NULL,2,0),
('CORE_SEARCH_MANAGEMENT','portal.search.adminFeature.search_management.name',0,NULL,'portal.search.adminFeature.search_management.description',0,'','SYSTEM','ti ti-database-search',NULL,3,0),
('CORE_STYLES_MANAGEMENT','portal.style.adminFeature.styles_management.name',0,'jsp/admin/style/ManageStyles.jsp','portal.style.adminFeature.styles_management.description',1,'','STYLE','ti ti-brush',NULL,3,0),
('CORE_STYLESHEET_MANAGEMENT','portal.style.adminFeature.stylesheet_management.name',0,'jsp/admin/style/ManageStyleSheets.jsp','portal.style.adminFeature.stylesheet_management.description',1,'','STYLE','ti ti-file-code',NULL,2,0),
('CORE_TEMPLATES_AUTO_INCLUDES_MANAGEMENT','portal.templates.adminFeature.ManageAutoIncludes.name',1,NULL,'portal.templates.adminFeature.ManageAutoIncludes.description',1,'','STYLE','ti ti-code-circle-2',NULL,4,0),
('CORE_USERS_MANAGEMENT','portal.users.adminFeature.users_management.name',2,'jsp/admin/user/ManageUsers.jsp','portal.users.adminFeature.users_management.description',1,'','MANAGERS','ti ti-users',NULL,2,0),
('CORE_WORKGROUPS_MANAGEMENT','portal.workgroup.adminFeature.workgroups_management.name',2,'jsp/admin/workgroup/ManageWorkgroups.jsp','portal.workgroup.adminFeature.workgroups_management.description',0,'','MANAGERS','ti ti-users-group',NULL,3,0),
('CORE_XSL_EXPORT_MANAGEMENT','portal.xsl.adminFeature.xsl_export_management.name',2,NULL,'portal.xsl.adminFeature.xsl_export_management.description',1,'','SYSTEM','ti ti-file-export',NULL,11,0),
('CORE_SECURITY_HEADER_MANAGEMENT','portal.system.adminFeature.security_header_management.name',0,'jsp/admin/system/ManageSecurityHeaders.jsp','portal.system.adminFeature.security_header_management.description',1,'','SYSTEM','ti ti-box-align-top',NULL,12,0),
('MYLUTECE_MANAGEMENT','mylutece.adminFeature.mylutece_management.name',2,'jsp/admin/plugins/mylutece/ManageMylutece.jsp','mylutece.adminFeature.mylutece_management.description',0,'mylutece','SYSTEM',NULL,NULL,14,0),
('MYLUTECE_MANAGE_EXTERNAL_APPLICATION','mylutece.adminFeature.mylutece_management_external_application.name',3,'jsp/admin/plugins/mylutece/ManageExternalApplicationUser.jsp','mylutece.adminFeature.mylutece_management_external_application.description',0,'mylutece','MANAGERS',NULL,NULL,7,0),
('MYLUTECE_MANAGE_AUTHENTICATION_FILTER','mylutece.adminFeature.mylutece_management_authentication_filter.name',3,'jsp/admin/plugins/mylutece/security/ManageAuthenticationFilter.jsp','mylutece.adminFeature.mylutece_management_authentication_filter.description',0,'mylutece','SYSTEM',NULL,NULL,13,0);
/*!40000 ALTER TABLE `core_admin_right` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_role`
--

DROP TABLE IF EXISTS `core_admin_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_role` (
  `role_key` varchar(50) NOT NULL DEFAULT '',
  `role_description` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`role_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_role`
--

LOCK TABLES `core_admin_role` WRITE;
/*!40000 ALTER TABLE `core_admin_role` DISABLE KEYS */;
INSERT INTO `core_admin_role` VALUES
('all_site_manager','Site Manager'),
('super_admin','Super Administrateur');
/*!40000 ALTER TABLE `core_admin_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_role_resource`
--

DROP TABLE IF EXISTS `core_admin_role_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_role_resource` (
  `rbac_id` int(11) NOT NULL AUTO_INCREMENT,
  `role_key` varchar(50) NOT NULL DEFAULT '',
  `resource_type` varchar(50) NOT NULL DEFAULT '',
  `resource_id` varchar(50) NOT NULL DEFAULT '',
  `permission` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`rbac_id`)
) ENGINE=MyISAM AUTO_INCREMENT=897 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_role_resource`
--

LOCK TABLES `core_admin_role_resource` WRITE;
/*!40000 ALTER TABLE `core_admin_role_resource` DISABLE KEYS */;
INSERT INTO `core_admin_role_resource` VALUES
(1,'all_site_manager','PAGE','*','VIEW'),
(2,'all_site_manager','PAGE','*','MANAGE'),
(3,'super_admin','INSERT_SERVICE','*','*'),
(4,'all_site_manager','PORTLET_TYPE','*','*'),
(5,'all_site_manager','ADMIN_USER','*','*'),
(6,'all_site_manager','SEARCH_SERVICE','*','*'),
(7,'all_site_manager','XSL_EXPORT','*','*'),
(8,'super_admin','XSL_EXPORT','*','*'),
(9,'super_admin','PAGE','*','*'),
(10,'super_admin','ADMIN_USER','*','*'),
(11,'super_admin','PORTLET_TYPE','*','*'),
(12,'super_admin','SEARCH_SERVICE','*','*'),
(894,'super_admin','ROLE_TYPE','*','*'),
(895,'super_admin','ROLE_TYPE','*','*'),
(896,'super_admin','MYLUTECE','*','*');
/*!40000 ALTER TABLE `core_admin_role_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_security_header`
--

DROP TABLE IF EXISTS `core_admin_security_header`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_security_header` (
  `id_security_header` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `value` varchar(1024) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `type` varchar(10) NOT NULL,
  `page_category` varchar(25) DEFAULT NULL,
  `is_active` smallint(6) DEFAULT 0,
  PRIMARY KEY (`id_security_header`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_security_header`
--

LOCK TABLES `core_admin_security_header` WRITE;
/*!40000 ALTER TABLE `core_admin_security_header` DISABLE KEYS */;
INSERT INTO `core_admin_security_header` VALUES
(1,'Strict-Transport-Security','max-age=31536000; includeSubDomains','The HTTP Strict-Transport-Security response header (often abbreviated as HSTS) informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. The value recommended by OWASP for this header is \'max-age=31536000; includeSubDomains\' and this is the value retained for Lutece. This setting means that the browser should remember that this site and all of his subdomains are only to be accessed using HTTPS for 31536000 seconds (1 year).','page','all',0),
(2,'X-Content-Type-Options','nosniff','The X-Content-Type-Options response HTTP header is a marker used by the server to indicate that the MIME types advertised in the Content-Type headers should be followed and not be changed. The header allows you to avoid MIME type sniffing by saying that the MIME types are deliberately configured. The value recommended by OWASP for this header is \'nosniff\' and this is the value retained for Lutece. \'nosniff\' value will prevent the browser from MIME-sniffing a response away from the declared content-type.','page','all',0),
(3,'Content-Security-Policy','default-src \'self\'; script-src \'self\' \'unsafe-inline\'; style-src \'self\' \'unsafe-inline\'; img-src \'self\' data: blob:; connect-src \'self\' blob:; object-src \'none\'; form-action \'self\'; frame-ancestors \'self\'; upgrade-insecure-requests','The HTTP Content-Security-Policy response header allows website administrators to control resources the user agent is allowed to load for a given page. With a few exceptions, policies mostly involve specifying server origins and script endpoints. This helps guard against cross-site scripting attacks (Cross-site_scripting). The directives recommended by OWASP are \"\"default-src \'self\'; form-action \'self\'; object-src \'none\'; frame-ancestors \'none\'; upgrade-insecure-requests; block-all-mixed-content\"\". For Lutece, the values of the directives of this policy have been defined as close as possible to this recommendation. However, hey are different because they take into account of the specificities of Lutece existing code and more specifically the constraints of tiny mce library that needs specific configuration for this header.','page','all',0),
(4,'X-Permitted-Cross-Domain-Policies','none','This header is used to limit which data external resources, such as Adobe Flash and PDF documents, can access on the domain. The value recommended by OWASP for this header is \'none\' and this is the value retained for Lutece. It means that o policy files are allowed anywhere on the target server, including this master policy file.','page','all',0),
(5,'Referrer-Policy','no-referrer','The Referrer-Policy HTTP header controls how much referrer information (sent with the Referer header) should be included with requests. Aside from the HTTP header, you can set this policy in HTML. The value recommended by OWASP for this header is \'no-referrer\' and this is the value retained for Lutece. The Referer header included with requests will be omitted entirely. No referrer information is sent along with requests.','page','all',0),
(6,'Cross-Origin-Embedder-Policy','require-corp','The HTTP Cross-Origin-Embedder-Policy (COEP) response header configures embedding cross-origin resources into the document. The value recommended by OWASP for this header is \'require-corp\' and this is the value retained for Lutece. It means that a document can only load resources from the same origin (i.e. protocol/scheme + host + port), or resources explicitly marked as loadable from another origin.','page','all',0),
(7,'Cross-Origin-Opener-Policy','same-origin','The HTTP Cross-Origin-Opener-Policy (COOP) response header allows you to ensure a top-level document does not share a browsing context group with cross-origin documents. The value recommended by OWASP for this header is \'same-origin\' and this is the value retained for Lutece. This value permits to isolates the browsing context exclusively to same-origin documents. Cross-origin documents are not loaded in the same browsing context.','page','all',0),
(8,'Cross-Origin-Resource-Policy','same-site','The HTTP Cross-Origin-Resource-Policy response header conveys a desire that the browser blocks no-cors cross-origin/cross-site requests to the given resource. The value recommended by OWASP for this header is \'same-origin\' and the value retained for Lutece is \'same-site\' which means that only requests from the same Site can read the resource. It is less restrictive than \'same-origin\' in order to allow Lutece sub-domains to access to resources.','page','all',0),
(9,'Cache-Control','max-age=0, must-revalidate, no-cache, no-store, private','The Cache-Control HTTP header field holds directives (instructions) — in both requests and responses — that control caching in browsers and shared caches (e.g. Proxies, CDNs). The value recommended by OWASP for this header is \'no-store, max-age=0\'. For Lutece, the directives retained are \'max-age=0, must-revalidate, no-cache, no-store, private\' and are applied to administration front office/back office pages with authentication in order to prevent caching of any information. Theoretically, OWASP recommended directives should be suficient but in practice some browsers may continue to use the cache or don\'t support no-store directive. So, for Lutece, more directives have been added to prevent caching. For instance, the login page of gmail uses the following directives : no-cache, no-store, max-age=0, must-revalidate','page','auth_admin_BO',0),
(10,'Cache-Control','max-age=0, must-revalidate, no-cache, no-store, private','The Cache-Control HTTP header field holds directives (instructions) — in both requests and responses — that control caching in browsers and shared caches (e.g. Proxies, CDNs). The value recommended by OWASP for this header is \'no-store, max-age=0\'. For Lutece, the directives retained are \'max-age=0, must-revalidate, no-cache, no-store, private\' and are applied to administration front office/back office pages with authentication in order to prevent caching of any information. Theoretically, OWASP recommended directives should be suficient but in practice some browsers may continue to use the cache or don\'t support no-store directive. So, for Lutece, more directives have been added to prevent caching. For instance, the login page of gmail uses the following directives : no-cache, no-store, max-age=0, must-revalidate','page','auth_admin_FO',0),
(11,'Clear-Site-Data','\"cache\",\"cookies\",\"storage\"','The Clear-Site-Data header clears browsing data (cookies, storage, cache) associated with the requesting website. It allows web developers to have more control over the data stored by a client browser for their origins. This header is useful for example, during a logout process, in order to ensure that all stored content on the client side like cookies, storage and cache are removed. The value recommended by OWASP for this header is \'\"cache\",\"cookies\",\"storage\"\' and this is the value retained for Lutece. It is added to the front office/back office logout pages of Lutece.','page','logout_BO',0),
(12,'Clear-Site-Data','\"cache\",\"cookies\",\"storage\"','The Clear-Site-Data header clears browsing data (cookies, storage, cache) associated with the requesting website. It allows web developers to have more control over the data stored by a client browser for their origins. This header is useful for example, during a logout process, in order to ensure that all stored content on the client side like cookies, storage and cache are removed. The value recommended by OWASP for this header is \'\"cache\",\"cookies\",\"storage\"\' and this is the value retained for Lutece. It is added to the front office/back office logout pages of Lutece.','page','logout_FO',0),
(13,'Strict-Transport-Security','max-age=31536000; includeSubDomains','The HTTP Content-Security-Policy response header allows website administrators to control resources the user agent is allowed to load for a given page. With a few exceptions, policies mostly involve specifying server origins and script endpoints. This helps guard against cross-site scripting attacks (Cross-site_scripting). The value recommended by OWASP for this header when used as a response of an API call is \'frame-ancestors \'none\'\' and this is the value retained for Lutece. It prevents any domain from framing the response returned by the API call.','rest_api',NULL,0),
(14,'Content-Security-Policy','frame-ancestors \'none\'','The HTTP Strict-Transport-Security response header (often abbreviated as HSTS) informs browsers that the site should only be accessed using HTTPS, and that any future attempts to access it using HTTP should automatically be converted to HTTPS. The value recommended by OWASP for this header when used as a response of an API call is \'max-age=31536000; includeSubDomains\' and this is the value retained for Lutece. This setting means that the browser should remember that this site and all of his subdomains are only to be accessed using HTTPS for 31536000 seconds (1 year).','rest_api',NULL,0);
/*!40000 ALTER TABLE `core_admin_security_header` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_user`
--

DROP TABLE IF EXISTS `core_admin_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_user` (
  `id_user` int(11) NOT NULL AUTO_INCREMENT,
  `access_code` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(256) NOT NULL DEFAULT '0',
  `status` smallint(6) NOT NULL DEFAULT 0,
  `password` mediumtext DEFAULT NULL,
  `locale` varchar(10) NOT NULL DEFAULT 'fr',
  `level_user` smallint(6) NOT NULL DEFAULT 0,
  `reset_password` smallint(6) NOT NULL DEFAULT 0,
  `accessibility_mode` smallint(6) NOT NULL DEFAULT 0,
  `password_max_valid_date` timestamp NULL DEFAULT NULL,
  `account_max_valid_date` bigint(20) DEFAULT NULL,
  `nb_alerts_sent` int(11) NOT NULL DEFAULT 0,
  `last_login` timestamp NOT NULL DEFAULT '1979-12-31 23:00:00',
  `workgroup_key` varchar(50) DEFAULT 'all',
  PRIMARY KEY (`id_user`)
) ENGINE=MyISAM AUTO_INCREMENT=229 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_user`
--

LOCK TABLES `core_admin_user` WRITE;
/*!40000 ALTER TABLE `core_admin_user` DISABLE KEYS */;
INSERT INTO `core_admin_user` VALUES
(1,'admin','Admin','admin','admin@lutece.fr',0,'PBKDF2WITHHMACSHA512:210000:857a1ff7d78c88d2f7920c1f9316435c:d1a797443298b8ac84d334da8071c2ad233744a29a9b6776209e6a22a78d9da7433196a59838a0301cf6dc1c7b462053a3731ea79f3699f6490165d3d8a0b504879e0c11c0ee62f3d89669e7ba69edca600ae9e2777c6afc23890f1566b7205cf61d81d1f2fadf077a92eb1958006c26e4439b3a7a2ff6e2a9364791c51859fb','fr',0,0,0,'2024-11-13 12:37:27',1761844718265,0,'2024-10-30 16:18:38','all'),
(2,'lutece','Lutece','lutece','lutece@lutece.fr',1,'PBKDF2WITHHMACSHA512:210000:bc734b07cbc2b1ded38446468ba04d6f:532a73f9860957077d27fb2668b0b668d7ba8c79f5fdf3a4b2ca3e2332a7306c45894530afda3291e21e8ba2b3a0a21570ce17f172da41e04cc18519b9536906bccc368d1c5c5acb2dd0708401a53bccbbbf284ba656e8a39b8edcc3a5603e99bc809e7403a867a7d8202c0adfa4688ac5d1f1c2708f5b561511d9547bd5925a','fr',1,1,0,'1979-12-31 23:00:00',1760089393449,0,'1979-12-31 23:00:00','all'),
(3,'redac','redac','redac','redac@lutece.fr',1,'PBKDF2WITHHMACSHA512:210000:5e47296e7ffff318eeaf9ddebfaaa1f4:2dfd56c04f9c7946301a367f3400e447a2b35180eed02f6cedc6d8ac046e859e0e0435d2f3884a3519635770307ce2ac4ca98d0119937653337ab215fded1718f7e7d27900ba209b4ac1e03adbac8cde2753a53195a7650bb655050d8803464c977e14df4fa8981e5fad60b48ecddb6a6b4845e0b860e6767d09f02d08595331','fr',2,1,0,'1979-12-31 23:00:00',1760089396181,0,'1979-12-31 23:00:00','all'),
(4,'valid','valid','valid','valid@lutece.fr',1,'PBKDF2WITHHMACSHA512:210000:b08fd5e354d0dc0d49d9e18850301ea1:2f2974ba5f2a53e784741e959e75f0fed47cda17a2684c9a2f73af69c219da62dbb7acbd9e5ed323c9b7b576f25772564950814af1b72975ff60e15c8546055779c1d35a59239e37d0d9e161238270f49f407b3d1a16b6c1339e70df3ecc542e5e1610b3537dcf19cd98d59cc38eabe11f7c38a3b0c48085c279f031af2cba18','fr',3,1,0,'1979-12-31 23:00:00',1760089369482,0,'1979-12-31 23:00:00','all'),
(94,'user-6390175306366710116','user-6390175306366710116','user-6390175306366710116','user-6390175306366710116@lutece.fr',0,'PBKDF2WITHHMACSHA512:210000:010a942ed41795ab0d06983efc4cbd52:9ea3c78fe16aed6bc910d70fe4064756782127e26fdb5d73ca029a6f12ff9f11c74dc7a51b5e34bc5c9d44722091440dada4a852ad32c8450cf9661148ee28a29ff2242b03689047f86349a42979a5a498a10c3b663ba1a50983624387c16413a2ba9abb48d73004883e2c7e0cf948ad254eb2b7bdeae15dc1c1a2eee481eef9','fr',0,0,0,NULL,NULL,0,'2024-10-07 13:36:15',NULL),
(96,'user-3277059410440144442','user-3277059410440144442','user-3277059410440144442','user-3277059410440144442@lutece.fr',0,'PBKDF2WITHHMACSHA512:210000:ca29f0d9d25d9f295d4655249b95ceef:9af6ef269c4383177f55916756bc16035e48206d6b273ce72cb3d8de7cfff56e311a8897f995152af539a63cd9c1b32a0339fcec091a557b628332bb93fac17d135ed9be1ebdd04b61f58a9ef14782056cebaf055d9dbc8e4f7a3e224fcffe5cc681c6c124ff85b3c1cdb34abc18042e0ab5ad7d16966fd5203ff457ed0a64bb','fr',0,0,0,NULL,NULL,0,'2024-10-07 13:36:21',NULL),
(226,'user552417783143580015','user552417783143580015','user552417783143580015','user552417783143580015@lutece.fr',0,'PBKDF2WITHHMACSHA512:210000:2fe2942f7ac2ae73b2fc544ef947231b:d00cc04e824b24db3263f5c6eefea68d60cbbc8bfcdb4f621ee56b0211b115458edc736f6798ada4243f5193d82816ea8e7910296679e1aafd4b45515a3f3a15d623ade8992ab668f48e7ef49eae68812f1952497501777bc9eb21629ea2ab15cffe1e4e2ec21e5d20f72783eda46b3295b43d726efbb01e785eb20a8b53c43c','fr',0,0,0,NULL,NULL,0,'2024-10-10 09:43:25',NULL),
(228,'user2527866376014743985','user2527866376014743985','user2527866376014743985','user2527866376014743985@lutece.fr',0,'PBKDF2WITHHMACSHA512:210000:bbf77d720fc36f4b6924abe5ce7e1fc1:de39f9fec990f92422b7e3caf845af5643eed6a5d3ded114d55a6be063a4aaef89eaa524bcf105fcb50eafba977d0e421934bc17ea7da40e7e2ef4f424c374161fdd668b0be22df3440405cf7d8652f478b764a4a0b4b81ca4dbddb88a3d291025e11cc3a0a881f5a524d5bec450df4833ace30a686a6891ac9390178737dff8','fr',0,0,0,NULL,NULL,0,'2024-10-10 09:43:32',NULL);
/*!40000 ALTER TABLE `core_admin_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_user_anonymize_field`
--

DROP TABLE IF EXISTS `core_admin_user_anonymize_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_user_anonymize_field` (
  `field_name` varchar(100) NOT NULL,
  `anonymize` smallint(6) NOT NULL,
  PRIMARY KEY (`field_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_user_anonymize_field`
--

LOCK TABLES `core_admin_user_anonymize_field` WRITE;
/*!40000 ALTER TABLE `core_admin_user_anonymize_field` DISABLE KEYS */;
INSERT INTO `core_admin_user_anonymize_field` VALUES
('access_code',1),
('last_name',1),
('first_name',1),
('email',1);
/*!40000 ALTER TABLE `core_admin_user_anonymize_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_user_field`
--

DROP TABLE IF EXISTS `core_admin_user_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_user_field` (
  `id_user_field` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) DEFAULT NULL,
  `id_attribute` int(11) DEFAULT NULL,
  `id_field` int(11) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `user_field_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_user_field`),
  KEY `core_admin_user_field_idx_file` (`id_file`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_user_field`
--

LOCK TABLES `core_admin_user_field` WRITE;
/*!40000 ALTER TABLE `core_admin_user_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_admin_user_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_user_preferences`
--

DROP TABLE IF EXISTS `core_admin_user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_user_preferences` (
  `id_user` varchar(100) NOT NULL,
  `pref_key` varchar(100) NOT NULL,
  `pref_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_user`,`pref_key`),
  KEY `index_admin_user_preferences` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_user_preferences`
--

LOCK TABLES `core_admin_user_preferences` WRITE;
/*!40000 ALTER TABLE `core_admin_user_preferences` DISABLE KEYS */;
INSERT INTO `core_admin_user_preferences` VALUES
('1','portal.nickname','nickname'),
('1','KEY3','false');
/*!40000 ALTER TABLE `core_admin_user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_workgroup`
--

DROP TABLE IF EXISTS `core_admin_workgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_workgroup` (
  `workgroup_key` varchar(50) NOT NULL,
  `workgroup_description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`workgroup_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_workgroup`
--

LOCK TABLES `core_admin_workgroup` WRITE;
/*!40000 ALTER TABLE `core_admin_workgroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_admin_workgroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_admin_workgroup_user`
--

DROP TABLE IF EXISTS `core_admin_workgroup_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_admin_workgroup_user` (
  `workgroup_key` varchar(50) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`workgroup_key`,`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_admin_workgroup_user`
--

LOCK TABLES `core_admin_workgroup_user` WRITE;
/*!40000 ALTER TABLE `core_admin_workgroup_user` DISABLE KEYS */;
INSERT INTO `core_admin_workgroup_user` VALUES
('junitacxdct7lxgbb4jezy15ei1n9m',0),
('junitc6bgztcvqvinqrrzbfrlzgr32',0);
/*!40000 ALTER TABLE `core_admin_workgroup_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_attribute`
--

DROP TABLE IF EXISTS `core_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_attribute` (
  `id_attribute` int(11) NOT NULL AUTO_INCREMENT,
  `type_class_name` varchar(255) DEFAULT NULL,
  `title` mediumtext DEFAULT NULL,
  `help_message` mediumtext DEFAULT NULL,
  `is_mandatory` smallint(6) DEFAULT 0,
  `is_shown_in_search` smallint(6) DEFAULT 0,
  `is_shown_in_result_list` smallint(6) DEFAULT 0,
  `is_field_in_line` smallint(6) DEFAULT 0,
  `attribute_position` int(11) DEFAULT 0,
  `plugin_name` varchar(255) DEFAULT NULL,
  `anonymize` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id_attribute`)
) ENGINE=MyISAM AUTO_INCREMENT=586 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_attribute`
--

LOCK TABLES `core_attribute` WRITE;
/*!40000 ALTER TABLE `core_attribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_attribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_attribute_field`
--

DROP TABLE IF EXISTS `core_attribute_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_attribute_field` (
  `id_field` int(11) NOT NULL AUTO_INCREMENT,
  `id_attribute` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `DEFAULT_value` mediumtext DEFAULT NULL,
  `is_DEFAULT_value` smallint(6) DEFAULT 0,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `max_size_enter` int(11) DEFAULT NULL,
  `is_multiple` smallint(6) DEFAULT 0,
  `field_position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_field`)
) ENGINE=MyISAM AUTO_INCREMENT=1165 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_attribute_field`
--

LOCK TABLES `core_attribute_field` WRITE;
/*!40000 ALTER TABLE `core_attribute_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_attribute_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_connections_log`
--

DROP TABLE IF EXISTS `core_connections_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_connections_log` (
  `access_code` varchar(100) DEFAULT NULL,
  `ip_address` varchar(63) DEFAULT NULL,
  `date_login` timestamp NOT NULL DEFAULT current_timestamp(),
  `login_status` int(11) DEFAULT NULL,
  KEY `index_connections_log` (`ip_address`,`date_login`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_connections_log`
--

LOCK TABLES `core_connections_log` WRITE;
/*!40000 ALTER TABLE `core_connections_log` DISABLE KEYS */;
INSERT INTO `core_connections_log` VALUES
('admin','127.0.0.1','2023-11-06 10:31:04',0),
('admin','127.0.0.1','2023-11-28 11:08:17',0),
('admin','192.168.1.37','2023-12-02 13:29:50',0),
('admin','10.244.0.1','2024-03-06 15:31:43',0),
('admin','192.168.1.38','2024-03-07 11:48:00',0),
('admin','192.168.1.38','2024-03-07 14:06:58',0),
('admin','10.244.0.1','2024-03-12 16:10:03',0),
('admin','10.244.0.1','2024-03-14 15:31:16',0),
('admin','10.244.0.1','2024-03-19 16:39:54',0),
('admin','10.244.0.1','2024-03-20 07:55:36',0),
('admin','10.244.0.1','2024-03-20 14:46:46',0),
('admin','192.168.1.38','2024-04-04 12:43:05',0),
('admin','192.168.1.38','2024-04-04 12:49:09',0),
('admin','192.168.1.38','2024-04-04 13:10:38',0),
('admin','192.168.1.38','2024-04-04 13:18:45',0),
('admin','192.168.1.38','2024-04-04 13:19:47',0),
('admin','192.168.1.38','2024-04-19 14:51:02',0),
('admin','10.5.9.89','2024-04-23 08:25:36',0),
('admin','10.5.9.89','2024-04-23 08:25:45',0),
('admin','192.168.1.38','2024-05-21 14:50:19',0),
('admin','192.168.1.38','2024-05-21 14:51:21',0),
('admin','192.168.1.38','2024-05-22 07:57:46',0),
('admin','127.0.0.1','2024-07-16 12:36:54',0),
('admin','127.0.0.1','2024-10-04 08:35:43',0),
('','127.0.0.1','2024-10-07 13:36:04',0),
('','127.0.0.1','2024-10-07 13:36:05',0),
('','127.0.0.1','2024-10-10 09:43:10',0),
('','127.0.0.1','2024-10-10 09:43:11',0),
('admin','fe80:0:0:0:4d1f:9035:5f6e:513a%3','2024-10-30 16:46:32',0),
('admin','10.244.0.1','2024-10-30 16:34:25',0);
/*!40000 ALTER TABLE `core_connections_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_dashboard`
--

DROP TABLE IF EXISTS `core_dashboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_dashboard` (
  `dashboard_name` varchar(100) NOT NULL,
  `dashboard_column` int(11) NOT NULL,
  `dashboard_order` int(11) NOT NULL,
  PRIMARY KEY (`dashboard_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_dashboard`
--

LOCK TABLES `core_dashboard` WRITE;
/*!40000 ALTER TABLE `core_dashboard` DISABLE KEYS */;
INSERT INTO `core_dashboard` VALUES
('CORE_SYSTEM',1,2),
('CORE_USERS',1,1),
('CORE_USER',4,1),
('CORE_PAGES',2,1);
/*!40000 ALTER TABLE `core_dashboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_datastore`
--

DROP TABLE IF EXISTS `core_datastore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_datastore` (
  `entity_key` varchar(255) NOT NULL,
  `entity_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`entity_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_datastore`
--

LOCK TABLES `core_datastore` WRITE;
/*!40000 ALTER TABLE `core_datastore` DISABLE KEYS */;
INSERT INTO `core_datastore` VALUES
('core.advanced_parameters.password_duration',''),
('core.advanced_parameters.default_user_level','0'),
('core.advanced_parameters.default_user_notification','1'),
('core.advanced_parameters.default_user_language','fr'),
('core.advanced_parameters.default_user_status','0'),
('core.advanced_parameters.email_pattern','^[\\w_.\\-!\\#\\$\\%\\&\'\\*\\+\\/\\=\\?\\^\\\\}\\{\\|\\~]+@[\\w_.\\-]+\\.[\\w]+$'),
('core.advanced_parameters.email_pattern_verify_by',''),
('core.advanced_parameters.force_change_password_reinit','true'),
('core.advanced_parameters.password_minimum_length','8'),
('core.advanced_parameters.password_format_upper_lower_case',''),
('core.advanced_parameters.password_format_numero',''),
('core.advanced_parameters.password_format_special_characters',''),
('core.advanced_parameters.password_history_size',''),
('core.advanced_parameters.maximum_number_password_change',''),
('core.advanced_parameters.tsw_size_password_change',''),
('core.advanced_parameters.use_advanced_security_parameters',''),
('core.advanced_parameters.account_life_time','12'),
('core.advanced_parameters.time_before_alert_account','30'),
('core.advanced_parameters.nb_alert_account','2'),
('core.advanced_parameters.time_between_alerts_account','10'),
('core.advanced_parameters.access_failures_max','3'),
('core.advanced_parameters.access_failures_interval','10'),
('core.advanced_parameters.expired_alert_mail_sender','lutece@nowhere.com'),
('core.advanced_parameters.expired_alert_mail_subject','Votre compte a expir├⌐'),
('core.advanced_parameters.first_alert_mail_sender','lutece@nowhere.com'),
('core.advanced_parameters.first_alert_mail_subject','Votre compte va bient├┤t expirer'),
('core.advanced_parameters.other_alert_mail_sender','lutece@nowhere.com'),
('core.advanced_parameters.other_alert_mail_subject','Votre compte va bient├┤t expirer'),
('core.advanced_parameters.account_reactivated_mail_sender','lutece@nowhere.com'),
('core.advanced_parameters.account_reactivated_mail_subject','Votre compte a bien ├⌐t├⌐ r├⌐activ├⌐'),
('core.advanced_parameters.access_failures_captcha','1'),
('core.advanced_parameters.notify_user_password_expired',''),
('core.advanced_parameters.password_expired_mail_sender','lutece@nowhere.com'),
('core.advanced_parameters.password_expired_mail_subject','Votre mot de passe a expir├⌐'),
('core.advanced_parameters.reset_token_validity','60'),
('core.advanced_parameters.lock_reset_token_to_session','false'),
('core.backOffice.defaultEditor','tinymce'),
('core.frontOffice.defaultEditor','sceeditor'),
('core_banned_domain_names','yopmail.com'),
('portal.site.site_property.name','LUTECE'),
('portal.site.site_property.meta.author','<author>'),
('portal.site.site_property.meta.copyright','<copyright>'),
('portal.site.site_property.meta.description','<description>'),
('portal.site.site_property.meta.keywords','<keywords>'),
('portal.site.site_property.email','<webmaster email>'),
('portal.site.site_property.noreply_email','no-reply@mydomain.com'),
('portal.site.site_property.home_url','jsp/site/Portal.jsp'),
('portal.site.site_property.admin_home_url','jsp/admin/AdminMenu.jsp'),
('portal.site.site_property.popup_credits.textblock','&lt;credits text&gt;'),
('portal.site.site_property.popup_legal_info.copyright.textblock','&lt;copyright text&gt;'),
('portal.site.site_property.popup_legal_info.privacy.textblock','&lt;privacy text&gt;'),
('portal.site.site_property.logo_url','themes/admin/shared/images/logo-header-icon.svg'),
('portal.site.site_property.locale.default','fr'),
('portal.site.site_property.avatar_default','themes/admin/shared/unknown.svg'),
('portal.site.site_property.portlet.title.maxlength','75'),
('portal.site.site_property.back_images','themes/admin/tabler/images/bg_login1.svg, themes/admin/tabler/images/bg_login2.svg'),
('portal.site.site_property.bo.showXs.checkbox','1'),
('portal.site.site_property.bo.showXsWarning.checkbox','0'),
('portal.site.site_property.login.image',''),
('portal.site.site_property.layout.menu.checkbox','0'),
('portal.site.site_property.layout.darkmode.checkbox','1'),
('portal.site.site_property.layout.readmode.checkbox','0'),
('portal.site.site_property.layout.user.readmode.show.checkbox','0'),
('portal.site.site_property.layout.user.darkmode.show.checkbox','1'),
('portal.site.site_property.layout.user.menumode.show.checkbox','1'),
('core.templates.currentCommonsInclude','commonsBoostrap5Tabler'),
('rafik.core.cache.status.pathCacheService.enabled','1'),
('rafik.core.cache.status.LinksIncludeCacheService.enabled','1'),
('rafik.core.cache.status.PageCacheService.enabled','1'),
('rafik.core.cache.status.PortletCacheService.enabled','0'),
('rafik.core.cache.status.BaseUserPreferencesCacheService.enabled','1'),
('rafik.core.cache.status.XMLTransformerCacheService(XSLT).enabled','1'),
('rafik.core.cache.status.DatastoreCacheService.enabled','0'),
('rafik.core.cache.status.PageCachingFilter(CAUTION:NEVERUSEWITHUSERDYNAMICDATA).enabled','0'),
('rafik.core.cache.status.PortalMenuService.enabled','1'),
('rafik.core.cache.status.StaticFilesCachingFilter.enabled','1'),
('rafik.core.cache.status.StaticFilesCachingFilter.timeToLiveSeconds','604800'),
('rafik.core.cache.status.MyPortalWidgetContentService.enabled','1'),
('rafik.core.cache.status.PageCachingFilter.enabled','0'),
('rafik.core.cache.status.MailAttachmentCacheService.timeToLiveSeconds','7200'),
('rafik.core.cache.status.MailAttachmentCacheService.overflowToDisk','true'),
('rafik.core.cache.status.MailAttachmentCacheService.maxElementsInMemory','10'),
('rafik.core.cache.status.MailAttachmentCacheService.enabled','1'),
('rafik.core.cache.status.MailAttachmentCacheService.diskPersistent','true'),
('rafik.core.cache.status.MyPortalWidgetService.enabled','1'),
('rafik.core.cache.status.LuteceUserCacheService.maxElementsInMemory','1000'),
('rafik.core.cache.status.LuteceUserCacheService.enabled','1'),
('rafik.core.cache.status.BaseUserPreferencesCacheService.maxElementsInMemory','1000'),
('rafik.core.cache.status.SiteMapService.enabled','1'),
('rafik.core.plugins.status.core_extensions.installed','true'),
('rafik.core.plugins.status.lucene.installed','true'),
('rafik.core.daemon.indexer.interval','300'),
('rafik.core.daemon.indexer.onStartUp','true'),
('rafik.core.daemon.mailSender.interval','86400'),
('rafik.core.daemon.mailSender.onStartUp','true'),
('rafik.core.daemon.anonymizationDaemon.interval','86400'),
('rafik.core.daemon.anonymizationDaemon.onStartUp','false'),
('rafik.core.daemon.accountLifeTimeDaemon.interval','86400'),
('rafik.core.daemon.accountLifeTimeDaemon.onStartUp','true'),
('rafik.core.daemon.threadLauncherDaemon.interval','86400'),
('rafik.core.daemon.threadLauncherDaemon.onStartUp','true'),
('core.startup.time','Oct 31, 2024, 9:50:01 AM'),
('core.daemon.JUNITAppDaemonServiceConcurrentTest.onStartUp','false'),
('core.plugins.status.core_extensions.installed','true'),
('core.plugins.status.lucene.installed','true'),
('core.daemon.indexer.interval','300'),
('core.daemon.indexer.onStartUp','false'),
('core.daemon.mailSender.interval','86400'),
('core.daemon.mailSender.onStartUp','false'),
('core.daemon.anonymizationDaemon.interval','86400'),
('core.daemon.anonymizationDaemon.onStartUp','false'),
('core.daemon.accountLifeTimeDaemon.interval','86400'),
('core.daemon.accountLifeTimeDaemon.onStartUp','false'),
('core.daemon.threadLauncherDaemon.interval','86400'),
('core.daemon.threadLauncherDaemon.onStartUp','false'),
('core.cache.status.PortalMenuService.enabled','1'),
('core.cache.status.PortletCacheService.enabled','1'),
('core.cache.status.MyPortalWidgetContentService.enabled','1'),
('core.cache.status.MailAttachmentCacheService.timeToLiveSeconds','7200'),
('core.cache.status.MailAttachmentCacheService.overflowToDisk','true'),
('core.cache.status.MailAttachmentCacheService.maxElementsInMemory','10'),
('core.cache.status.MailAttachmentCacheService.enabled','1'),
('core.cache.status.BaseUserPreferencesCacheService.enabled','1'),
('core.cache.status.MailAttachmentCacheService.diskPersistent','true'),
('core.cache.status.LinksIncludeCacheService.enabled','1'),
('core.cache.status.MyPortalWidgetService.enabled','1'),
('core.cache.status.LuteceUserCacheService.maxElementsInMemory','1000'),
('core.cache.status.LuteceUserCacheService.enabled','1'),
('core.cache.status.pathCacheService.enabled','1'),
('core.cache.status.BaseUserPreferencesCacheService.maxElementsInMemory','1000'),
('core.cache.status.SiteMapService.enabled','1'),
('core.cache.status.PageCacheService.enabled','1'),
('core.cache.status.DatastoreCacheService.enabled','1'),
('core.cache.status.XMLTransformerCacheService(XSLT).enabled','1'),
('core.cache.status.ll.enabled','0'),
('core.cache.status.mmm.enabled','1'),
('core.cache.status.mmmll.enabled','0'),
('core.cache.status.test.enabled','1'),
('core.cache.status.IMAGE_RESOURCE_TYPE_ID.enabled','0'),
('core.cache.status.public_image_resource.enabled','0'),
('core.crypto.key','f4ebc771bae8ced5dcb3af0e756b0357720c789f15ee331ebc108c1bf9744560'),
('lutece.rsa.key.public','MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvW1UOgTXgwMMUGv2t3gjuEH18j2pKrgc5jrHVmtMp36d45sOvMvnilTgp+ug41oQFcK5YfQmJXHXwTA45MYCOMVL/6go7iJbK+0bpAUMq0Kn0Cj5UhhaIJCkGodc9MyUtxnHe7PDqa7JQN+8vjYIhYxL3baGvi0NeuSgBlIxI/bB5vynhLACub3br/MwLK/J8wgvxMpaOHt/nv+od4fwa4CfJhIO6gatbjBwKEL1LBfrvoJMYTU7K7LykoMxWmHPbEYQTSiIL91Z6ZMkoGRa42OpRDfrLur1XyLfzq5qhzxV89OHgaIaPjCS8+rh9OehNjzffG7EDOy7A6yZNYBLuwIDAQAB'),
('lutece.rsa.key.private','MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9bVQ6BNeDAwxQa/a3eCO4QfXyPakquBzmOsdWa0ynfp3jmw68y+eKVOCn66DjWhAVwrlh9CYlcdfBMDjkxgI4xUv/qCjuIlsr7RukBQyrQqfQKPlSGFogkKQah1z0zJS3Gcd7s8OprslA37y+NgiFjEvdtoa+LQ165KAGUjEj9sHm/KeEsAK5vduv8zAsr8nzCC/Eylo4e3+e/6h3h/BrgJ8mEg7qBq1uMHAoQvUsF+u+gkxhNTsrsvKSgzFaYc9sRhBNKIgv3VnpkySgZFrjY6lEN+su6vVfIt/OrmqHPFXz04eBoho+MJLz6uH056E2PN98bsQM7LsDrJk1gEu7AgMBAAECggEAXVMfy/XWt5Uo2/ZU9s8Zyg21PkNitMlAc61ByDHU8jBPWXNrL1jGGkD27cQI3/nfMtlcvAWtRYVw5pz7arqjHZUWfD487BXBFUMb+xMByt5sDwIg03Fr9d9M+kT2ZyTjn9Hzld5a555VSMDyHERCrokQV4s1lzxbB9DbhkG4NB7kx25dwk1AH1UJZmv06VuGueQP8BBu8W86/SA5JJSkkiqYKAykSscIDFuW3xI9vi34HNsu5etgG52PutsHWrGlVpt997tH/gjqTHiaZOa+M3vCvEL2N8gsrIW/vFIadFmAfDN0Kc52hzJZ4BwaJEvJbaEQ200iMSPvqRH4hm4MAQKBgQDp6A2Rut5ckDuadnADCwhSLO3njBHPtBVTDxsm+oMASdlTXWlKqxJ48OljIbxqmBCZXLYN6EsmpV5DaZvElrY4Q+CibxDCYR1Kc8V0sjYD0vnKimTBm67U2qL+bUDdcAPWGtaWURoXKOHJ6wWKBVYlvsCSL/17wk9hg6aQGkpMcQKBgQDPUb9YYjcd0Qw1FQ/Fsyg6dVXT3ByDZfe1eJaxJiOQrhecUV/aIjG1ejRAEJoaTinne0Uscx/R/t1Y9M6LCcBlHDYTI2k3x4MaM06FU2enyrB7FBpPa6r3QFuAcccvq/58oYUO5WkOVCi4JKFknlT9KwiehEatib3RqJr0XJ4g6wKBgGugHZY/YI9AwlwZQQL1cZe2GqVe+tcSKnm0Sq8Nt3dLg5brNUZpHq/NUeYOIM7/NywJz67ogqO+lXf5QPYczq1m9hZnelOmMb8PM/y0/0uVKOB7+05mXvSLwVHGXYFGSE2cvb4ehR3A7ttkq4DNYc0uTxc0w7LNPo9E70ABCMzRAoGBAKwtXBhvGQ8uOlEreLncHKDQKcOVniiSWrLfv2bIIelabElqW4yxsU7ietpp71HBcJPKkJxl0Bt66yGhzpcyNhLC5zXlxtCIZZ0w1xlrNz7m2sKc42zqIkbNsDBwTdiNowCms/a3GBTKWDb2VQNXa4YGY1YizP/60SZ6PJaNBNaZAoGAPMkhopT/c3+1PxEu6a6Vpv5ecsn3qAFjSe62aE3D+Iaqh5LYRK+Yidp8XYe+ZkdEr+kitezveiWWaFvWwC5peLwqKP3RITG0xJS199l+42OD/W/P24laOe1+iKD/k3JNYgllgz6CWmm5Z67VzVMWKOHB24Ou+srMGV5SgGjUweY='),
('core.daemon.JUNITAppDaemonServiceTest.onStartUp','false'),
('core.plugins.status.junitplugin.installed','false'),
('core.daemon.JUNIT.onStartUp','false'),
('core.plugins.status.linksIncludeTestPlugin.installed','false'),
('core.daemon.OTHERJUNITAppDaemonServiceConcurrentTest.onStartUp','false'),
('core.plugins.status.mylutece.pool','portal'),
('core.plugins.status.mylutece.installed','true');
/*!40000 ALTER TABLE `core_datastore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_feature_group`
--

DROP TABLE IF EXISTS `core_feature_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_feature_group` (
  `id_feature_group` varchar(50) NOT NULL DEFAULT '',
  `feature_group_description` varchar(255) DEFAULT NULL,
  `feature_group_label` varchar(100) DEFAULT NULL,
  `feature_group_order` int(11) DEFAULT NULL,
  `feature_group_icon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_feature_group`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_feature_group`
--

LOCK TABLES `core_feature_group` WRITE;
/*!40000 ALTER TABLE `core_feature_group` DISABLE KEYS */;
INSERT INTO `core_feature_group` VALUES
('CONTENT','portal.features.group.content.description','portal.features.group.content.label',1,'ti ti-files'),
('APPLICATIONS','portal.features.group.applications.description','portal.features.group.applications.label',3,'ti ti-apps'),
('SYSTEM','portal.features.group.system.description','portal.features.group.system.label',7,'ti ti-shield-lock '),
('SITE','portal.features.group.site.description','portal.features.group.site.label',2,'ti ti-world'),
('STYLE','portal.features.group.charter.description','portal.features.group.charter.label',6,'ti ti-brush'),
('USERS','portal.features.group.users.description','portal.features.group.users.label',4,'ti ti-users'),
('MANAGERS','portal.features.group.managers.description','portal.features.group.managers.label',5,'ti ti-user-shield');
/*!40000 ALTER TABLE `core_feature_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_file`
--

DROP TABLE IF EXISTS `core_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_file` (
  `id_file` int(11) NOT NULL AUTO_INCREMENT,
  `title` mediumtext DEFAULT NULL,
  `id_physical_file` int(11) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT NULL,
  `origin` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_file`)
) ENGINE=MyISAM AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_file`
--

LOCK TABLES `core_file` WRITE;
/*!40000 ALTER TABLE `core_file` DISABLE KEYS */;
INSERT INTO `core_file` VALUES
(125,'export_users_csv.xml',125,2523,'application/xml','2005-10-10 08:10:10','INIT_CORE'),
(126,'export_users_xml.xml',126,259,'application/xml','2005-10-10 08:10:10','INIT_CORE'),
(128,'/tmp/test16572355207574560720txt',128,12,'text/plain','2024-10-07 13:34:42','defaultDatabaseFileStoreProvider'),
(129,'test',129,12,'text/plain','2024-10-07 13:34:42','defaultDatabaseFileStoreProvider'),
(130,'test',130,12,'text/plain','2024-10-07 13:34:42','defaultDatabaseFileStoreProvider'),
(131,NULL,131,0,NULL,'2024-10-07 13:34:42','defaultDatabaseFileStoreProvider'),
(147,'/tmp/test6317320131225896281txt',147,12,'text/plain','2024-10-07 14:19:51','defaultDatabaseFileStoreProvider'),
(141,'xsl',141,25,'application/octet-stream','2024-10-07 13:34:58',NULL),
(148,'test',148,12,'text/plain','2024-10-07 14:19:51','defaultDatabaseFileStoreProvider'),
(149,'test',149,12,'text/plain','2024-10-07 14:19:51','defaultDatabaseFileStoreProvider'),
(150,NULL,150,0,NULL,'2024-10-07 14:19:51','defaultDatabaseFileStoreProvider'),
(166,'/tmp/test10004997438790417239txt',166,12,'text/plain','2024-10-10 09:41:21','defaultDatabaseFileStoreProvider'),
(160,'xsl',160,25,'application/octet-stream','2024-10-07 14:20:09',NULL),
(167,'test',167,12,'text/plain','2024-10-10 09:41:21','defaultDatabaseFileStoreProvider'),
(168,'test',168,12,'text/plain','2024-10-10 09:41:21','defaultDatabaseFileStoreProvider'),
(169,NULL,169,0,NULL,'2024-10-10 09:41:21','defaultDatabaseFileStoreProvider'),
(179,'xsl',179,25,'application/octet-stream','2024-10-10 09:41:40',NULL);
/*!40000 ALTER TABLE `core_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_id_generator`
--

DROP TABLE IF EXISTS `core_id_generator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_id_generator` (
  `class_name` varchar(250) NOT NULL DEFAULT '',
  `current_value` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`class_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_id_generator`
--

LOCK TABLES `core_id_generator` WRITE;
/*!40000 ALTER TABLE `core_id_generator` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_id_generator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_indexer_action`
--

DROP TABLE IF EXISTS `core_indexer_action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_indexer_action` (
  `id_action` int(11) NOT NULL AUTO_INCREMENT,
  `id_document` varchar(255) NOT NULL,
  `id_task` int(11) NOT NULL DEFAULT 0,
  `indexer_name` varchar(255) NOT NULL,
  `id_portlet` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_action`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_indexer_action`
--

LOCK TABLES `core_indexer_action` WRITE;
/*!40000 ALTER TABLE `core_indexer_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_indexer_action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_level_right`
--

DROP TABLE IF EXISTS `core_level_right`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_level_right` (
  `id_level` smallint(6) NOT NULL DEFAULT 0,
  `name` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id_level`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_level_right`
--

LOCK TABLES `core_level_right` WRITE;
/*!40000 ALTER TABLE `core_level_right` DISABLE KEYS */;
INSERT INTO `core_level_right` VALUES
(0,'Level 0 - Technical administrator'),
(1,'Level 1 - Fonctionnal administrator'),
(2,'Level 2 - Site Manager - Webmaster'),
(3,'Level 3 - Contributor');
/*!40000 ALTER TABLE `core_level_right` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_mail_item`
--

DROP TABLE IF EXISTS `core_mail_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_mail_item` (
  `id_mail_queue` int(11) NOT NULL DEFAULT 0,
  `mail_item` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id_mail_queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_mail_item`
--

LOCK TABLES `core_mail_item` WRITE;
/*!40000 ALTER TABLE `core_mail_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_mail_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_mail_queue`
--

DROP TABLE IF EXISTS `core_mail_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_mail_queue` (
  `id_mail_queue` int(11) NOT NULL AUTO_INCREMENT,
  `is_locked` smallint(6) DEFAULT 0,
  PRIMARY KEY (`id_mail_queue`),
  KEY `is_locked_core_mail_queue` (`is_locked`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_mail_queue`
--

LOCK TABLES `core_mail_queue` WRITE;
/*!40000 ALTER TABLE `core_mail_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_mail_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_mode`
--

DROP TABLE IF EXISTS `core_mode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_mode` (
  `id_mode` int(11) NOT NULL DEFAULT 0,
  `description_mode` varchar(255) DEFAULT NULL,
  `path` varchar(50) NOT NULL DEFAULT '',
  `output_xsl_method` varchar(50) DEFAULT NULL,
  `output_xsl_version` varchar(50) DEFAULT NULL,
  `output_xsl_media_type` varchar(50) DEFAULT NULL,
  `output_xsl_encoding` varchar(50) DEFAULT NULL,
  `output_xsl_indent` varchar(50) DEFAULT NULL,
  `output_xsl_omit_xml_dec` varchar(50) DEFAULT NULL,
  `output_xsl_standalone` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_mode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_mode`
--

LOCK TABLES `core_mode` WRITE;
/*!40000 ALTER TABLE `core_mode` DISABLE KEYS */;
INSERT INTO `core_mode` VALUES
(0,'Normal','normal/','xml','1.0','text/xml','UTF-8','yes','yes',NULL),
(1,'Administration','admin/','xml','1.0','text/xml','UTF-8','yes','yes',NULL),
(2,'Wap','wml/','xml','1.0','text/xml','UTF-8','yes','yes',NULL);
/*!40000 ALTER TABLE `core_mode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_page`
--

DROP TABLE IF EXISTS `core_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_page` (
  `id_page` int(11) NOT NULL AUTO_INCREMENT,
  `id_parent` int(11) DEFAULT 0,
  `name` varchar(50) NOT NULL DEFAULT '',
  `description` mediumtext DEFAULT NULL,
  `date_update` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` smallint(6) DEFAULT NULL,
  `page_order` int(11) DEFAULT 0,
  `id_template` int(11) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `code_theme` varchar(80) DEFAULT NULL,
  `node_status` smallint(6) NOT NULL DEFAULT 1,
  `image_content` mediumblob DEFAULT NULL,
  `mime_type` varchar(255) DEFAULT 'NULL',
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `id_authorization_node` int(11) DEFAULT NULL,
  `display_date_update` smallint(6) NOT NULL DEFAULT 0,
  `is_manual_date_update` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_page`),
  KEY `index_page` (`id_template`,`id_parent`),
  KEY `index_childpage` (`id_parent`,`page_order`)
) ENGINE=MyISAM AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_page`
--

LOCK TABLES `core_page` WRITE;
/*!40000 ALTER TABLE `core_page` DISABLE KEYS */;
INSERT INTO `core_page` VALUES
(1,0,'Home','Home Page','2023-11-06 09:23:28',1,1,1,'2023-11-06 09:23:28','none','default',0,'','application/octet-stream',NULL,NULL,1,0,0),
(2,1,'Page 1','A child page','2023-11-06 09:23:28',0,1,2,'2023-11-06 09:23:28','none','default',1,NULL,'application/octet-stream',NULL,NULL,1,0,0);
/*!40000 ALTER TABLE `core_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_page_template`
--

DROP TABLE IF EXISTS `core_page_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_page_template` (
  `id_template` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(50) DEFAULT NULL,
  `file_name` varchar(100) DEFAULT NULL,
  `picture` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_template`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_page_template`
--

LOCK TABLES `core_page_template` WRITE;
/*!40000 ALTER TABLE `core_page_template` DISABLE KEYS */;
INSERT INTO `core_page_template` VALUES
(1,'Home page','skin/site/page_home_demo.html','layout-home.svg'),
(2,'One column','skin/site/page_template1.html','layout-one.svg'),
(3,'Two columns','skin/site/page_template2.html','layout-two.svg'),
(4,'1 + 2 columns','skin/site/page_template4.html','layout-three.svg'),
(5,'Two equal columns','skin/site/page_template5.html','layout-four.svg');
/*!40000 ALTER TABLE `core_page_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_physical_file`
--

DROP TABLE IF EXISTS `core_physical_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_physical_file` (
  `id_physical_file` int(11) NOT NULL AUTO_INCREMENT,
  `file_value` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id_physical_file`)
) ENGINE=MyISAM AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_physical_file`
--

LOCK TABLES `core_physical_file` WRITE;
/*!40000 ALTER TABLE `core_physical_file` DISABLE KEYS */;
INSERT INTO `core_physical_file` VALUES
(125,'<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n	<xsl:output method=\"text\"/>\r\n	\r\n	<xsl:template match=\"users\">\r\n		<xsl:apply-templates select=\"user\" />\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"user\">\r\n		<xsl:text>\"</xsl:text>\r\n		<xsl:value-of select=\"access_code\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"last_name\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"first_name\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"email\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"status\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"locale\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"level\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"must_change_password\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"accessibility_mode\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"password_max_valid_date\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"account_max_valid_date\" />\r\n		<xsl:text>\";\"</xsl:text>\r\n		<xsl:value-of select=\"date_last_login\" />\r\n		<xsl:text>\"</xsl:text>\r\n		<xsl:apply-templates select=\"roles\" />\r\n		<xsl:apply-templates select=\"rights\" />\r\n		<xsl:apply-templates select=\"workgroups\" />\r\n		<xsl:apply-templates select=\"attributes\" />\r\n		<xsl:text>&#10;</xsl:text>\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"roles\">\r\n		<xsl:apply-templates select=\"role\" />\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"role\">\r\n		<xsl:text>;\"role:</xsl:text>\r\n		<xsl:value-of select=\"current()\" />\r\n		<xsl:text>\"</xsl:text>\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"rights\">\r\n		<xsl:apply-templates select=\"right\" />\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"right\">\r\n		<xsl:text>;\"right:</xsl:text>\r\n		<xsl:value-of select=\"current()\" />\r\n		<xsl:text>\"</xsl:text>\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"workgroups\">\r\n		<xsl:apply-templates select=\"workgroup\" />\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"workgroup\">\r\n		<xsl:text>;\"workgroup:</xsl:text>\r\n		<xsl:value-of select=\"current()\" />\r\n		<xsl:text>\"</xsl:text>\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"attributes\">\r\n		<xsl:apply-templates select=\"attribute\" />\r\n	</xsl:template>\r\n	\r\n	<xsl:template match=\"attribute\">\r\n		<xsl:text>;\"</xsl:text>\r\n		<xsl:value-of select=\"attribute-id\" />\r\n		<xsl:text>:</xsl:text>\r\n		<xsl:value-of select=\"attribute-field-id\" />\r\n		<xsl:text>:</xsl:text>\r\n		<xsl:value-of select=\"attribute-value\" />\r\n		<xsl:text>\"</xsl:text>\r\n	</xsl:template>\r\n	\r\n</xsl:stylesheet>'),
(126,'<?xml version=\"1.0\" ?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n	<xsl:template match=\"/ | @* | node()\">\r\n		<xsl:copy>\r\n			<xsl:apply-templates select=\"@* | node()\" />\r\n		</xsl:copy>\r\n	</xsl:template>\r\n</xsl:stylesheet>'),
(128,'some content'),
(129,'some content'),
(130,'some content'),
(131,'some content'),
(141,'<?xml version=\'1.0\'?><a/>'),
(147,'some content'),
(148,'some content'),
(149,'some content'),
(150,'some content'),
(160,'<?xml version=\'1.0\'?><a/>'),
(166,'some content'),
(167,'some content'),
(168,'some content'),
(169,'some content'),
(179,'<?xml version=\'1.0\'?><a/>');
/*!40000 ALTER TABLE `core_physical_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_portal_component`
--

DROP TABLE IF EXISTS `core_portal_component`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_portal_component` (
  `id_portal_component` int(11) NOT NULL DEFAULT 0,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_portal_component`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_portal_component`
--

LOCK TABLES `core_portal_component` WRITE;
/*!40000 ALTER TABLE `core_portal_component` DISABLE KEYS */;
INSERT INTO `core_portal_component` VALUES
(0,'Portlet'),
(1,'Article'),
(2,'Article List Portlet'),
(3,'Menu Init'),
(4,'Main Menu'),
(5,'Breadcrum'),
(6,'Site Map'),
(7,'Tree View'),
(8,'Site Map (Admin mode)');
/*!40000 ALTER TABLE `core_portal_component` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_portlet`
--

DROP TABLE IF EXISTS `core_portlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_portlet` (
  `id_portlet` int(11) NOT NULL AUTO_INCREMENT,
  `id_portlet_type` varchar(50) DEFAULT NULL,
  `id_page` int(11) DEFAULT NULL,
  `name` varchar(70) DEFAULT NULL,
  `date_update` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` smallint(6) NOT NULL DEFAULT 0,
  `portlet_order` int(11) DEFAULT NULL,
  `column_no` int(11) DEFAULT NULL,
  `id_style` int(11) DEFAULT NULL,
  `accept_alias` smallint(6) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT NULL,
  `display_portlet_title` int(11) NOT NULL DEFAULT 0,
  `role` varchar(50) DEFAULT NULL,
  `device_display_flags` int(11) NOT NULL DEFAULT 15,
  PRIMARY KEY (`id_portlet`),
  KEY `index_portlet` (`id_page`,`id_portlet_type`,`id_style`)
) ENGINE=MyISAM AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_portlet`
--

LOCK TABLES `core_portlet` WRITE;
/*!40000 ALTER TABLE `core_portlet` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_portlet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_portlet_alias`
--

DROP TABLE IF EXISTS `core_portlet_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_portlet_alias` (
  `id_portlet` int(11) NOT NULL DEFAULT 0,
  `id_alias` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_portlet`,`id_alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_portlet_alias`
--

LOCK TABLES `core_portlet_alias` WRITE;
/*!40000 ALTER TABLE `core_portlet_alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `core_portlet_alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_portlet_type`
--

DROP TABLE IF EXISTS `core_portlet_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_portlet_type` (
  `id_portlet_type` varchar(50) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `url_creation` varchar(255) DEFAULT NULL,
  `url_update` varchar(255) DEFAULT NULL,
  `home_class` varchar(255) DEFAULT NULL,
  `plugin_name` varchar(50) DEFAULT NULL,
  `url_docreate` varchar(255) DEFAULT NULL,
  `create_script` varchar(255) DEFAULT NULL,
  `create_specific` varchar(255) DEFAULT NULL,
  `create_specific_form` varchar(255) DEFAULT NULL,
  `url_domodify` varchar(255) DEFAULT NULL,
  `modify_script` varchar(255) DEFAULT NULL,
  `modify_specific` varchar(255) DEFAULT NULL,
  `modify_specific_form` varchar(255) DEFAULT NULL,
  `icon_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_portlet_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_portlet_type`
--

LOCK TABLES `core_portlet_type` WRITE;
/*!40000 ALTER TABLE `core_portlet_type` DISABLE KEYS */;
INSERT INTO `core_portlet_type` VALUES
('ALIAS_PORTLET','portal.site.portletAlias.name','plugins/alias/CreatePortletAlias.jsp','plugins/alias/ModifyPortletAlias.jsp','fr.paris.lutece.portal.business.portlet.AliasPortletHome','alias','plugins/alias/DoCreatePortletAlias.jsp','/admin/portlet/script_create_portlet.html','/admin/portlet/alias/create_portlet_alias.html','','plugins/alias/DoModifyPortletAlias.jsp','/admin/portlet/script_modify_portlet.html','/admin/portlet/alias/modify_portlet_alias.html','','circles-relation'),
('TEST_rsdtgnfi',NULL,NULL,NULL,'fr.paris.lutece.portal.web.admin.AdminPagePortletJspBeanTest$TestPortletHome',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('TEST_9ri4iirj',NULL,NULL,NULL,'fr.paris.lutece.portal.web.admin.AdminPagePortletJspBeanTest$TestPortletHome',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
('MYLUTECE_PORTLET','mylutece.portlet.name','plugins/mylutece/CreatePortletMyLutece.jsp','plugins/mylutece/ModifyPortletMyLutece.jsp','fr.paris.lutece.plugins.mylutece.business.portlet.MyLutecePortletHome','mylutece','plugins/mylutece/DoCreatePortletMyLutece.jsp','/admin/portlet/script_create_portlet.html','','','plugins/mylutece/DoModifyPortletMyLutece.jsp','/admin/portlet/script_modify_portlet.html','','',NULL);
/*!40000 ALTER TABLE `core_portlet_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_role`
--

DROP TABLE IF EXISTS `core_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_role` (
  `role` varchar(50) NOT NULL DEFAULT '',
  `role_description` varchar(255) DEFAULT NULL,
  `workgroup_key` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_role`
--

LOCK TABLES `core_role` WRITE;
/*!40000 ALTER TABLE `core_role` DISABLE KEYS */;
INSERT INTO `core_role` VALUES
('fff','fff','all');
/*!40000 ALTER TABLE `core_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_search_parameter`
--

DROP TABLE IF EXISTS `core_search_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_search_parameter` (
  `parameter_key` varchar(100) NOT NULL,
  `parameter_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`parameter_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_search_parameter`
--

LOCK TABLES `core_search_parameter` WRITE;
/*!40000 ALTER TABLE `core_search_parameter` DISABLE KEYS */;
INSERT INTO `core_search_parameter` VALUES
('type_filter','none'),
('default_operator','OR'),
('help_message','Message d aide pour la recherche'),
('date_filter','0'),
('tag_filter','0'),
('taglist',NULL);
/*!40000 ALTER TABLE `core_search_parameter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_style`
--

DROP TABLE IF EXISTS `core_style`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_style` (
  `id_style` int(11) NOT NULL DEFAULT 0,
  `description_style` varchar(100) NOT NULL DEFAULT '',
  `id_portlet_type` varchar(50) DEFAULT NULL,
  `id_portal_component` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_style`),
  KEY `index_style` (`id_portlet_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_style`
--

LOCK TABLES `core_style` WRITE;
/*!40000 ALTER TABLE `core_style` DISABLE KEYS */;
INSERT INTO `core_style` VALUES
(3,'Menu Init','',3),
(4,'Main Menu','',4),
(5,'Breadcrumb','',5),
(6,'Site Map','',6),
(7,'Tree View Menu','',7),
(8,'Site Map (Admin mode)',NULL,8);
/*!40000 ALTER TABLE `core_style` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_style_mode_stylesheet`
--

DROP TABLE IF EXISTS `core_style_mode_stylesheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_style_mode_stylesheet` (
  `id_style` int(11) NOT NULL DEFAULT 0,
  `id_mode` int(11) NOT NULL DEFAULT 0,
  `id_stylesheet` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_style`,`id_mode`,`id_stylesheet`),
  KEY `index_style_mode_stylesheet` (`id_stylesheet`,`id_mode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_style_mode_stylesheet`
--

LOCK TABLES `core_style_mode_stylesheet` WRITE;
/*!40000 ALTER TABLE `core_style_mode_stylesheet` DISABLE KEYS */;
INSERT INTO `core_style_mode_stylesheet` VALUES
(3,0,211),
(4,0,213),
(5,0,215),
(6,0,217),
(7,0,253),
(8,1,279);
/*!40000 ALTER TABLE `core_style_mode_stylesheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_stylesheet`
--

DROP TABLE IF EXISTS `core_stylesheet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_stylesheet` (
  `id_stylesheet` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `source` mediumblob DEFAULT NULL,
  PRIMARY KEY (`id_stylesheet`)
) ENGINE=MyISAM AUTO_INCREMENT=330 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_stylesheet`
--

LOCK TABLES `core_stylesheet` WRITE;
/*!40000 ALTER TABLE `core_stylesheet` DISABLE KEYS */;
INSERT INTO `core_stylesheet` VALUES
(211,'Menu Init','menu_init.xsl','<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n\r\n<xsl:param name=\"site-path\" select=\"site-path\" />\r\n\r\n<xsl:template match=\"menu-list\">\r\n<br /><br />\r\n	<div id=\"menu-init\">\r\n		<div id=\"menu-init-content\">\r\n            <ul id=\"menu-verti\">\r\n                <xsl:apply-templates select=\"menu\" />\r\n            </ul>\r\n        </div>\r\n     </div>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"menu\">\r\n    <xsl:variable name=\"index\">\r\n    	<xsl:number level=\"single\" value=\"position()\" />\r\n    </xsl:variable>\r\n\r\n    <xsl:if test=\"$index &gt; 7\">\r\n        <li class=\"first-verti\">\r\n        	<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n          		<xsl:value-of select=\"page-name\" />\r\n	        </a>\r\n    	    <xsl:apply-templates select=\"sublevel-menu-list\" />\r\n        </li>\r\n   </xsl:if>\r\n</xsl:template>\r\n\r\n<xsl:template match=\"sublevel-menu-list\" >\r\n	<ul>\r\n    	<li class=\"last-verti\">\r\n		 	<xsl:apply-templates select=\"sublevel-menu\" />\r\n 	    </li>\r\n    </ul>\r\n</xsl:template>\r\n\r\n<xsl:template match=\"sublevel-menu\">\r\n   <xsl:variable name=\"index_sous_menu\">\r\n         <xsl:number level=\"single\" value=\"position()\" />\r\n   </xsl:variable>\r\n\r\n   <a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n		<span><xsl:value-of select=\"page-name\" /></span>\r\n   </a>\r\n</xsl:template>\r\n\r\n</xsl:stylesheet>\r\n'),
(213,'Main Menu','menu_main.xsl','<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n    <xsl:param name=\"site-path\" select=\"site-path\" />\r\n    <xsl:template match=\"menu-list\">\r\n        <xsl:apply-templates select=\"menu\" />\r\n    </xsl:template>\r\n    <xsl:template match=\"menu\">\r\n        <li class=\"nav-item\">\r\n            <a href=\"{$site-path}?page_id={page-id}\" class=\"nav-link\" target=\"_top\">\r\n                <xsl:value-of select=\"page-name\" />\r\n            </a>\r\n        </li>\r\n    </xsl:template>\r\n</xsl:stylesheet>'),
(215,'Breadcrumb','page_path.xsl','<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n\r\n<xsl:param name=\"site-path\" select=\"site-path\" />\r\n\r\n\r\n<xsl:template match=\"page\">\r\n		<xsl:if test=\"position()!=last()-1\">\r\n			<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\"><xsl:value-of select=\"page-name\" /></a> >\r\n		</xsl:if>\r\n		<xsl:if test=\"position()=last()-1\">\r\n			<xsl:value-of select=\"page-name\" />\r\n		</xsl:if>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page_link\">\r\n		<xsl:if test=\"position()!=last()-1\">\r\n			<a href=\"{$site-path}?{page-url}\" target=\"_top\"><xsl:value-of select=\"page-name\" /></a> >\r\n		</xsl:if>\r\n		<xsl:if test=\"position()=last()-1\">\r\n			<xsl:value-of select=\"page-name\" />\r\n		</xsl:if>\r\n</xsl:template>\r\n\r\n\r\n</xsl:stylesheet>'),
(217,'Site Map','site_map.xsl','<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n\r\n<xsl:param name=\"site-path\" select=\"site-path\" />\r\n\r\n\r\n<xsl:template match=\"page[page-level=0]\">\r\n	<div class=\"span-15 prepend-1 append-1 append-bottom\">\r\n		<div class=\"portlet -lutece-border-radius\">\r\n			<xsl:apply-templates select=\"child-pages-list\" />\r\n		</div>\r\n	</div>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page[page-level=1]\" >\r\n<ul class=\"site-map-level-one\">\r\n	<li>\r\n		<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n			<xsl:value-of select=\"page-name\" />\r\n		</a>\r\n		<xsl:apply-templates select=\"page-description\" />\r\n		<xsl:apply-templates select=\"page-image\" />\r\n		<xsl:apply-templates select=\"child-pages-list\" />\r\n	    <xsl:text disable-output-escaping=\"yes\">\r\n		    <![CDATA[<div class=\"clear\">&#160;</div>]]>\r\n	    </xsl:text>\r\n	</li>\r\n</ul>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page[page-level=2]\" >\r\n<ul class=\"site-map-level-two\">\r\n	<li>\r\n		<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n			<xsl:value-of select=\"page-name\" />\r\n		</a>\r\n		<xsl:apply-templates select=\"page-description\" />\r\n		<xsl:apply-templates select=\"child-pages-list\" />\r\n	</li>\r\n</ul>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page[page-level>2]\" >\r\n<ul class=\"site-map-level-highest\">\r\n	<li>\r\n		<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n			<xsl:value-of select=\"page-name\" />\r\n		</a>\r\n		<xsl:apply-templates select=\"page-description\" />\r\n		<xsl:apply-templates select=\"child-pages-list\" />\r\n	</li>\r\n</ul>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page-description\">\r\n	<br /><xsl:value-of select=\".\" />\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"child-pages-list[page-level=0]\">\r\n	<xsl:if test=\"count(page)>0\" >\r\n		<xsl:apply-templates select=\"page\" />\r\n    </xsl:if>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"child-pages-list[page-level=1]\">\r\n	<xsl:if test=\"count(page)>0\" >\r\n		<xsl:apply-templates select=\"page\" />\r\n    </xsl:if>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"child-pages-list[page-level=2]\">\r\n	<xsl:if test=\"count(page)>0\" >\r\n		<xsl:apply-templates select=\"page\" />\r\n    </xsl:if>\r\n</xsl:template>\r\n\r\n<xsl:template match=\"child-pages-list[page-level>2]\">\r\n	<xsl:if test=\"count(page)>0\" >\r\n		<xsl:apply-templates select=\"page\" />\r\n    </xsl:if>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"page-image\">\r\n	<div class=\"level-one-image\">\r\n    	<div class=\"polaroid\">\r\n		<img  border=\"0\" width=\"80\" height=\"80\" src=\"images/local/data/pages/{.}\" alt=\"\" />\r\n         </div>\r\n	</div >\r\n</xsl:template>\r\n\r\n\r\n</xsl:stylesheet>\r\n'),
(253,'Tree View Menu','menu_tree.xsl','<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n\r\n<xsl:param name=\"site-path\" select=\"site-path\" />\r\n\r\n<xsl:template match=\"menu-list\">\r\n	<xsl:variable name=\"menu-list\" select=\"menu\" />\r\n\r\n	<script type=\"text/javascript\">\r\n		$(document).ready(function(){\r\n			$(\"#tree\").treeview({\r\n				animated: \"fast\",\r\n				collapsed: false,\r\n				unique: true,\r\n				persist: \"cookie\"\r\n			});\r\n		\r\n		});\r\n	</script>    \r\n	\r\n	<xsl:if test=\"not(string(menu)=\'\')\">\r\n	    <xsl:text disable-output-escaping=\"yes\">		    \r\n            <div class=\"tree4\">		\r\n			<h2>&#160;</h2>\r\n			<ul id=\"tree\" class=\"tree4\">\r\n                <xsl:apply-templates select=\"menu\" />        \r\n			</ul>	\r\n			</div>\r\n		 	 <br />\r\n		</xsl:text> \r\n	</xsl:if>\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"menu\">\r\n    <xsl:variable name=\"index\">\r\n    	<xsl:number level=\"single\" value=\"position()\" />\r\n    </xsl:variable>\r\n		<li>\r\n          <a href=\"{$site-path}?page_id={page-id}\" target=\"_top\" >\r\n               <xsl:value-of select=\"page-name\" />\r\n           </a>	   \r\n		   <br />\r\n		   <xsl:value-of select=\"page-description\" />\r\n			<xsl:apply-templates select=\"sublevel-menu-list\" /> \r\n			\r\n		</li> 	\r\n		\r\n</xsl:template>\r\n\r\n<xsl:template match=\"sublevel-menu-list\" > \r\n	\r\n	<xsl:apply-templates select=\"sublevel-menu\" /> 	    	\r\n\r\n</xsl:template>\r\n\r\n\r\n<xsl:template match=\"sublevel-menu\">\r\n   <xsl:variable name=\"index_sous_menu\">\r\n         <xsl:number level=\"single\" value=\"position()\" />\r\n   </xsl:variable>\r\n		 <ul >\r\n			<li>\r\n				<a href=\"{$site-path}?page_id={page-id}\" target=\"_top\">\r\n					<xsl:value-of select=\"page-name\" />\r\n				</a>\r\n			</li>			\r\n		</ul>\r\n		\r\n   \r\n</xsl:template>\r\n\r\n</xsl:stylesheet>\r\n'),
(279,'Site Map (Admin mode)','admin_site_map_admin.xsl','<?xml version=\"1.0\"?>\r\n<xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\">\r\n    <xsl:param name=\"site-path\" select=\"site-path\" />\r\n    <xsl:variable name=\"current-page-id\" select=\"current-page-id\" />\r\n    <xsl:template match=\"page[page-level=0]\">\r\n        <div id=\"lutece-map-tree\" class=\"lutece-tree\">\r\n            <ul>\r\n                <li class=\"lutece-tree-node\" data-tree-icon=\"home\">\r\n                    <xsl:value-of select=\"page-name\" />\r\n                    <xsl:if test=\"not(string(page-role)=\'none\')\">\r\n                        <strong>\r\n                            <xsl:text disable-output-escaping=\"yes\">- #i18n{portal.site.admin_page.tabAdminMapRoleReserved}</xsl:text>\r\n                            <xsl:value-of select=\"page-role\" />\r\n                        </strong>\r\n                    </xsl:if>\r\n                    <a href=\"{$site-path}?page_id={page-id}\" title=\"{page-description}\"><span class=\"ti ti-link\"></span></a>\r\n                    <ul>\r\n                        <xsl:apply-templates select=\"child-pages-list\" />\r\n                    </ul>\r\n                </li>\r\n            </ul>\r\n        </div>\r\n    </xsl:template>\r\n    <xsl:template match=\"page[page-level>0]\">\r\n        <xsl:variable name=\"index\" select=\"page-id\" />\r\n        <xsl:variable name=\"description\" select=\"page-description\" />\r\n        <xsl:choose>\r\n            <xsl:when test=\"count(child-pages-list/*)>0\">\r\n            <li id=\"node-{$index}\" class=\"lutece-tree-node\" data-tree-icon=\"folder\">\r\n                <xsl:value-of select=\"page-name\" />\r\n                <xsl:if test=\"not(string(page-role)=\'none\')\">\r\n                    <strong>\r\n                        <xsl:text disable-output-escaping=\"yes\">#i18n{portal.site.admin_page.tabAdminMapRoleReserved}</xsl:text>\r\n                        <xsl:value-of select=\"page-role\" />\r\n                    </strong>\r\n                </xsl:if>\r\n                <a href=\"{$site-path}?page_id={page-id}\" title=\"{$description}\"><span class=\"ti ti-link\"></span></a>\r\n                <ul>\r\n                    <xsl:apply-templates select=\"child-pages-list\" />\r\n                </ul>\r\n                </li>   \r\n            </xsl:when>\r\n            <xsl:otherwise>\r\n            <li id=\"node-{$index}\" class=\"lutece-tree-item\" data-tree-icon=\"file\">\r\n                <xsl:value-of select=\"page-name\" />\r\n                <xsl:if test=\"not(string(page-role)=\'none\')\">\r\n                    <strong>\r\n                        <xsl:text disable-output-escaping=\"yes\">#i18n{portal.site.admin_page.tabAdminMapRoleReserved}</xsl:text>\r\n                        <xsl:value-of select=\"page-role\" />\r\n                    </strong>\r\n                </xsl:if>\r\n                <a href=\"{$site-path}?page_id={page-id}\" title=\"{$description}\"><span class=\"ti ti-link\"></span></a>\r\n                <xsl:apply-templates select=\"child-pages-list\" />\r\n            </li>    \r\n            </xsl:otherwise>\r\n        </xsl:choose>\r\n    </xsl:template>\r\n    <xsl:template match=\"child-pages-list\">\r\n        <xsl:apply-templates select=\"page\" />\r\n    </xsl:template>\r\n</xsl:stylesheet>');
/*!40000 ALTER TABLE `core_stylesheet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_template`
--

DROP TABLE IF EXISTS `core_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_template` (
  `template_name` varchar(100) NOT NULL,
  `template_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`template_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_template`
--

LOCK TABLES `core_template` WRITE;
/*!40000 ALTER TABLE `core_template` DISABLE KEYS */;
INSERT INTO `core_template` VALUES
('core_first_alert_mail','Bonjour ${first_name} ! Votre compte utilisateur arrive ├á expiration. Pour prolonger sa validit├⌐, veuillez <a href=\"${url}\">cliquer ici</a>.</br>Si vous ne le faites pas avant le ${date_valid}, il sera d├⌐sactiv├⌐.'),
('core_expiration_mail','Bonjour ${first_name} ! Votre compte a expir├⌐. Vous ne pourrez plus vous connecter avec, et les donn├⌐es vous concernant ont ├⌐t├⌐ anonymis├⌐es'),
('core_other_alert_mail','Bonjour ${first_name} ! Votre compte utilisateur arrive ├á expiration. Pour prolonger sa validit├⌐, veuillez <a href=\"${url}\">cliquer ici</a>.</br>Si vous ne le faites pas avant le ${date_valid}, il sera d├⌐sactiv├⌐.'),
('core_account_reactivated_mail','Bonjour ${first_name} ! Votre compte utilisateur a bien ├⌐t├⌐ r├⌐activ├⌐. Il est d├⌐sormais valable jusqu\'au ${date_valid}.'),
('core_password_expired','Bonjour ! Votre mot de passe a expir├⌐. Lors de votre prochaine connexion, vous pourrez le changer.');
/*!40000 ALTER TABLE `core_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_text_editor`
--

DROP TABLE IF EXISTS `core_text_editor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_text_editor` (
  `editor_name` varchar(255) NOT NULL,
  `editor_description` varchar(255) NOT NULL,
  `backOffice` smallint(6) NOT NULL,
  PRIMARY KEY (`editor_name`,`backOffice`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_text_editor`
--

LOCK TABLES `core_text_editor` WRITE;
/*!40000 ALTER TABLE `core_text_editor` DISABLE KEYS */;
INSERT INTO `core_text_editor` VALUES
('tinymce','portal.admindashboard.editors.labelBackTinyMCE',1),
('tinymce5','portal.admindashboard.editors.labelBackTinyMCE5',1),
('','portal.admindashboard.editors.labelBackNoEditor',1),
('','portal.admindashboard.editors.labelFrontNoEditor',0),
('sceeditor','portal.admindashboard.editors.labelFrontSceEditor',0);
/*!40000 ALTER TABLE `core_text_editor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_password_history`
--

DROP TABLE IF EXISTS `core_user_password_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_password_history` (
  `id_user` int(11) NOT NULL,
  `password` mediumtext NOT NULL,
  `date_password_change` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_user`,`date_password_change`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_password_history`
--

LOCK TABLES `core_user_password_history` WRITE;
/*!40000 ALTER TABLE `core_user_password_history` DISABLE KEYS */;
INSERT INTO `core_user_password_history` VALUES
(1,'PBKDF2WITHHMACSHA512:40000:7e3922a368cbe0cc725dcc01362579a5:754ac4c3e08caa01763af1f8f96dd3b686a050e26e0cc93e9d722d9b0721063642a02846e6eb9250ec9d4d977ba411a9ffca1654be8b5ee9631062d3595f2753b66b937f51f79cd6cb37378c4753bdfb24d80ea84ce39f8839f98020b6a67b7e4a4c948a54ec8a4a31bb2848f422be331e7783a2d112ce4e115b2b11e7a2591e','2023-11-06 10:31:25'),
(1,'PBKDF2WITHHMACSHA512:40000:a0ce7c3b67e9af8c89d92febf55a9330:0e3dea5568e8c9c3bbefd0a29b921045fdc788dd2c154c2aa9da2bacf1492cda450df3c41d126876018b8991b0f0e14c2e5ac708bcfcf17a6511f342749d97038cc47a82f5e7d166e3de8a85f663312f5dbceed5849ffb16c1ae32ce58bc4e8b7cbd748780d20afdbaf542d5e4c0893a05cb11d50680c10d3a7cfd4dd7d808c8','2024-03-06 16:49:08'),
(1,'PBKDF2WITHHMACSHA512:40000:52e41d58a5f8a86667b5785340a45903:a5f8bdea1d27d8f1cea0f68c44df9098aa2f382416e3a9f6a3957e847cff2abd50ca0b8b6999635db228f39aa38d72afd07014ca35a9213af95e3533a50132a43cf24cd62f401247522dfadb69fe244e38ad3deb8e5fa7e525ef0ad4faea2c6b4e7142285f1658283d12126c27ea3644d65a3ed9161fe5be278c7e6a4ee2b81f','2024-07-16 12:37:27');
/*!40000 ALTER TABLE `core_user_password_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_preferences`
--

DROP TABLE IF EXISTS `core_user_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_preferences` (
  `id_user` varchar(100) NOT NULL,
  `pref_key` varchar(100) NOT NULL,
  `pref_value` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id_user`,`pref_key`),
  KEY `index_user_preferences` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_preferences`
--

LOCK TABLES `core_user_preferences` WRITE;
/*!40000 ALTER TABLE `core_user_preferences` DISABLE KEYS */;
INSERT INTO `core_user_preferences` VALUES
('1','KEY1','Value 1');
/*!40000 ALTER TABLE `core_user_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_right`
--

DROP TABLE IF EXISTS `core_user_right`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_right` (
  `id_right` varchar(255) NOT NULL DEFAULT '',
  `id_user` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_right`,`id_user`),
  KEY `index_user_right` (`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_right`
--

LOCK TABLES `core_user_right` WRITE;
/*!40000 ALTER TABLE `core_user_right` DISABLE KEYS */;
INSERT INTO `core_user_right` VALUES
('CORE_ADMIN_SITE',1),
('CORE_ADMIN_SITE',2),
('CORE_ADMINDASHBOARD_MANAGEMENT',1),
('CORE_CACHE_MANAGEMENT',1),
('CORE_DAEMONS_MANAGEMENT',1),
('CORE_DASHBOARD_MANAGEMENT',1),
('CORE_EDITORS_MANAGEMENT',1),
('CORE_FEATURES_MANAGEMENT',1),
('CORE_LEVEL_RIGHT_MANAGEMENT',1),
('CORE_LINK_SERVICE_MANAGEMENT',1),
('CORE_LINK_SERVICE_MANAGEMENT',2),
('CORE_LOGS_VISUALISATION',1),
('CORE_MAILINGLISTS_MANAGEMENT',1),
('CORE_MODES_MANAGEMENT',1),
('CORE_PAGE_TEMPLATE_MANAGEMENT',1),
('CORE_PAGE_TEMPLATE_MANAGEMENT',2),
('CORE_PLUGINS_MANAGEMENT',1),
('CORE_PROPERTIES_MANAGEMENT',1),
('CORE_PROPERTIES_MANAGEMENT',2),
('CORE_RBAC_MANAGEMENT',1),
('CORE_RIGHT_MANAGEMENT',1),
('CORE_ROLES_MANAGEMENT',1),
('CORE_ROLES_MANAGEMENT',2),
('CORE_SEARCH_INDEXATION',1),
('CORE_SEARCH_INDEXATION',2),
('CORE_SEARCH_MANAGEMENT',1),
('CORE_SEARCH_MANAGEMENT',2),
('CORE_SECURITY_HEADER_MANAGEMENT',1),
('CORE_STYLES_MANAGEMENT',1),
('CORE_STYLESHEET_MANAGEMENT',1),
('CORE_TEMPLATES_AUTO_INCLUDES_MANAGEMENT',1),
('CORE_USERS_MANAGEMENT',1),
('CORE_USERS_MANAGEMENT',2),
('CORE_WORKGROUPS_MANAGEMENT',1),
('CORE_WORKGROUPS_MANAGEMENT',2),
('CORE_XSL_EXPORT_MANAGEMENT',1);
/*!40000 ALTER TABLE `core_user_right` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_user_role`
--

DROP TABLE IF EXISTS `core_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_user_role` (
  `role_key` varchar(50) NOT NULL DEFAULT '',
  `id_user` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`role_key`,`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_user_role`
--

LOCK TABLES `core_user_role` WRITE;
/*!40000 ALTER TABLE `core_user_role` DISABLE KEYS */;
INSERT INTO `core_user_role` VALUES
('all_site_manager',1),
('all_site_manager',2),
('super_admin',1),
('super_admin',2);
/*!40000 ALTER TABLE `core_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_xsl_export`
--

DROP TABLE IF EXISTS `core_xsl_export`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `core_xsl_export` (
  `id_xsl_export` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `extension` varchar(255) DEFAULT NULL,
  `id_file` int(11) DEFAULT NULL,
  `plugin` varchar(255) DEFAULT '',
  PRIMARY KEY (`id_xsl_export`)
) ENGINE=MyISAM AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_xsl_export`
--

LOCK TABLES `core_xsl_export` WRITE;
/*!40000 ALTER TABLE `core_xsl_export` DISABLE KEYS */;
INSERT INTO `core_xsl_export` VALUES
(125,'Core - Export users to a CSV file','Export back office users to a CSV file','csv',125,'core'),
(126,'Core - Export users to a XML file','Export back office users to a XML file','xml',126,'core');
/*!40000 ALTER TABLE `core_xsl_export` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `ID` varchar(128) NOT NULL,
  `PROPID` varchar(128) NOT NULL,
  `APPNAME` varchar(128) NOT NULL,
  `LISTENERCNT` smallint(6) DEFAULT NULL,
  `LASTACCESS` bigint(20) DEFAULT NULL,
  `CREATIONTIME` bigint(20) DEFAULT NULL,
  `MAXINACTIVETIME` int(11) DEFAULT NULL,
  `USERNAME` varchar(255) DEFAULT NULL,
  `SMALL` blob DEFAULT NULL,
  `MEDIUM` mediumblob DEFAULT NULL,
  `LARGE` longblob DEFAULT NULL,
  PRIMARY KEY (`ID`,`PROPID`,`APPNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_transaction`
--

DROP TABLE IF EXISTS `test_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test_transaction` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_transaction`
--

LOCK TABLES `test_transaction` WRITE;
/*!40000 ALTER TABLE `test_transaction` DISABLE KEYS */;
INSERT INTO `test_transaction` VALUES
(0),
(1),
(2);
/*!40000 ALTER TABLE `test_transaction` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-31 12:12:54
