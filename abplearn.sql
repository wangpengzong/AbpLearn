/*
Navicat MySQL Data Transfer

Source Server         : 122.51.149.238
Source Server Version : 80020
Source Host           : 122.51.149.238:3306
Source Database       : abplearn

Target Server Type    : MYSQL
Target Server Version : 80020
File Encoding         : 65001

Date: 2020-06-13 17:56:44
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for __EFMigrationsHistory
-- ----------------------------
DROP TABLE IF EXISTS `__EFMigrationsHistory`;
CREATE TABLE `__EFMigrationsHistory` (
  `MigrationId` varchar(95) NOT NULL,
  `ProductVersion` varchar(32) NOT NULL,
  PRIMARY KEY (`MigrationId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpAuditLogs
-- ----------------------------
DROP TABLE IF EXISTS `AbpAuditLogs`;
CREATE TABLE `AbpAuditLogs` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  `ServiceName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `MethodName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Parameters` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ReturnValue` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ExecutionTime` datetime(6) NOT NULL,
  `ExecutionDuration` int NOT NULL,
  `ClientIpAddress` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClientName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BrowserInfo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Exception` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ImpersonatorUserId` bigint DEFAULT NULL,
  `ImpersonatorTenantId` int DEFAULT NULL,
  `CustomData` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpAuditLogs_TenantId_ExecutionDuration` (`TenantId`,`ExecutionDuration`),
  KEY `IX_AbpAuditLogs_TenantId_ExecutionTime` (`TenantId`,`ExecutionTime`),
  KEY `IX_AbpAuditLogs_TenantId_UserId` (`TenantId`,`UserId`)
) ENGINE=InnoDB AUTO_INCREMENT=436 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpBackgroundJobs
-- ----------------------------
DROP TABLE IF EXISTS `AbpBackgroundJobs`;
CREATE TABLE `AbpBackgroundJobs` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `JobType` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `JobArgs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TryCount` smallint NOT NULL,
  `NextTryTime` datetime(6) NOT NULL,
  `LastTryTime` datetime(6) DEFAULT NULL,
  `IsAbandoned` tinyint(1) NOT NULL,
  `Priority` tinyint unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpBackgroundJobs_IsAbandoned_NextTryTime` (`IsAbandoned`,`NextTryTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpDynamicParameters
-- ----------------------------
DROP TABLE IF EXISTS `AbpDynamicParameters`;
CREATE TABLE `AbpDynamicParameters` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `ParameterName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `InputType` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Permission` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_AbpDynamicParameters_ParameterName_TenantId` (`ParameterName`,`TenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpDynamicParameterValues
-- ----------------------------
DROP TABLE IF EXISTS `AbpDynamicParameterValues`;
CREATE TABLE `AbpDynamicParameterValues` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TenantId` int DEFAULT NULL,
  `DynamicParameterId` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpDynamicParameterValues_DynamicParameterId` (`DynamicParameterId`),
  CONSTRAINT `FK_AbpDynamicParameterValues_AbpDynamicParameters_DynamicParame~` FOREIGN KEY (`DynamicParameterId`) REFERENCES `AbpDynamicParameters` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEditions
-- ----------------------------
DROP TABLE IF EXISTS `AbpEditions`;
CREATE TABLE `AbpEditions` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `Name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DisplayName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEntityChanges
-- ----------------------------
DROP TABLE IF EXISTS `AbpEntityChanges`;
CREATE TABLE `AbpEntityChanges` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `ChangeTime` datetime(6) NOT NULL,
  `ChangeType` tinyint unsigned NOT NULL,
  `EntityChangeSetId` bigint NOT NULL,
  `EntityId` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeFullName` varchar(192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpEntityChanges_EntityChangeSetId` (`EntityChangeSetId`),
  KEY `IX_AbpEntityChanges_EntityTypeFullName_EntityId` (`EntityTypeFullName`,`EntityId`),
  CONSTRAINT `FK_AbpEntityChanges_AbpEntityChangeSets_EntityChangeSetId` FOREIGN KEY (`EntityChangeSetId`) REFERENCES `AbpEntityChangeSets` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEntityChangeSets
-- ----------------------------
DROP TABLE IF EXISTS `AbpEntityChangeSets`;
CREATE TABLE `AbpEntityChangeSets` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `BrowserInfo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClientIpAddress` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClientName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `ExtensionData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ImpersonatorTenantId` int DEFAULT NULL,
  `ImpersonatorUserId` bigint DEFAULT NULL,
  `Reason` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpEntityChangeSets_TenantId_CreationTime` (`TenantId`,`CreationTime`),
  KEY `IX_AbpEntityChangeSets_TenantId_Reason` (`TenantId`,`Reason`),
  KEY `IX_AbpEntityChangeSets_TenantId_UserId` (`TenantId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEntityDynamicParameters
-- ----------------------------
DROP TABLE IF EXISTS `AbpEntityDynamicParameters`;
CREATE TABLE `AbpEntityDynamicParameters` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `EntityFullName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `DynamicParameterId` int NOT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_AbpEntityDynamicParameters_EntityFullName_DynamicParameterId~` (`EntityFullName`,`DynamicParameterId`,`TenantId`),
  KEY `IX_AbpEntityDynamicParameters_DynamicParameterId` (`DynamicParameterId`),
  CONSTRAINT `FK_AbpEntityDynamicParameters_AbpDynamicParameters_DynamicParam~` FOREIGN KEY (`DynamicParameterId`) REFERENCES `AbpDynamicParameters` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEntityDynamicParameterValues
-- ----------------------------
DROP TABLE IF EXISTS `AbpEntityDynamicParameterValues`;
CREATE TABLE `AbpEntityDynamicParameterValues` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `EntityId` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `EntityDynamicParameterId` int NOT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpEntityDynamicParameterValues_EntityDynamicParameterId` (`EntityDynamicParameterId`),
  CONSTRAINT `FK_AbpEntityDynamicParameterValues_AbpEntityDynamicParameters_E~` FOREIGN KEY (`EntityDynamicParameterId`) REFERENCES `AbpEntityDynamicParameters` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpEntityPropertyChanges
-- ----------------------------
DROP TABLE IF EXISTS `AbpEntityPropertyChanges`;
CREATE TABLE `AbpEntityPropertyChanges` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `EntityChangeId` bigint NOT NULL,
  `NewValue` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `OriginalValue` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `PropertyName` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `PropertyTypeFullName` varchar(192) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpEntityPropertyChanges_EntityChangeId` (`EntityChangeId`),
  CONSTRAINT `FK_AbpEntityPropertyChanges_AbpEntityChanges_EntityChangeId` FOREIGN KEY (`EntityChangeId`) REFERENCES `AbpEntityChanges` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpFeatures
-- ----------------------------
DROP TABLE IF EXISTS `AbpFeatures`;
CREATE TABLE `AbpFeatures` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `Name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Value` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Discriminator` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `EditionId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpFeatures_EditionId_Name` (`EditionId`,`Name`),
  KEY `IX_AbpFeatures_TenantId_Name` (`TenantId`,`Name`),
  CONSTRAINT `FK_AbpFeatures_AbpEditions_EditionId` FOREIGN KEY (`EditionId`) REFERENCES `AbpEditions` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpLanguages
-- ----------------------------
DROP TABLE IF EXISTS `AbpLanguages`;
CREATE TABLE `AbpLanguages` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `Name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DisplayName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Icon` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `IsDisabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpLanguages_TenantId_Name` (`TenantId`,`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpLanguageTexts
-- ----------------------------
DROP TABLE IF EXISTS `AbpLanguageTexts`;
CREATE TABLE `AbpLanguageTexts` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `LanguageName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Source` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Key` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpLanguageTexts_TenantId_Source_LanguageName_Key` (`TenantId`,`Source`,`LanguageName`,`Key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpMenus
-- ----------------------------
DROP TABLE IF EXISTS `AbpMenus`;
CREATE TABLE `AbpMenus` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `MenuName` varchar(50) DEFAULT NULL,
  `PageName` varchar(50) DEFAULT NULL,
  `LName` varchar(50) DEFAULT NULL,
  `Url` varchar(50) DEFAULT NULL,
  `Icon` varchar(20) DEFAULT NULL,
  `ParentId` int DEFAULT NULL,
  `IsActive` bit(1) NOT NULL DEFAULT b'0',
  `Orders` int DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=1409 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpNotifications
-- ----------------------------
DROP TABLE IF EXISTS `AbpNotifications`;
CREATE TABLE `AbpNotifications` (
  `Id` char(36) NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `NotificationName` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `DataTypeName` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeName` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeAssemblyQualifiedName` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityId` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Severity` tinyint unsigned NOT NULL,
  `UserIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ExcludedUserIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `TenantIds` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpNotificationSubscriptions
-- ----------------------------
DROP TABLE IF EXISTS `AbpNotificationSubscriptions`;
CREATE TABLE `AbpNotificationSubscriptions` (
  `Id` char(36) NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `NotificationName` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeName` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeAssemblyQualifiedName` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityId` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpNotificationSubscriptions_NotificationName_EntityTypeName~` (`NotificationName`,`EntityTypeName`,`EntityId`,`UserId`),
  KEY `IX_AbpNotificationSubscriptions_TenantId_NotificationName_Entit~` (`TenantId`,`NotificationName`,`EntityTypeName`,`EntityId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpOrganizationUnitRoles
-- ----------------------------
DROP TABLE IF EXISTS `AbpOrganizationUnitRoles`;
CREATE TABLE `AbpOrganizationUnitRoles` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `RoleId` int NOT NULL,
  `OrganizationUnitId` bigint NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpOrganizationUnitRoles_TenantId_OrganizationUnitId` (`TenantId`,`OrganizationUnitId`),
  KEY `IX_AbpOrganizationUnitRoles_TenantId_RoleId` (`TenantId`,`RoleId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpOrganizationUnits
-- ----------------------------
DROP TABLE IF EXISTS `AbpOrganizationUnits`;
CREATE TABLE `AbpOrganizationUnits` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `ParentId` bigint DEFAULT NULL,
  `Code` varchar(95) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DisplayName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpOrganizationUnits_ParentId` (`ParentId`),
  KEY `IX_AbpOrganizationUnits_TenantId_Code` (`TenantId`,`Code`),
  CONSTRAINT `FK_AbpOrganizationUnits_AbpOrganizationUnits_ParentId` FOREIGN KEY (`ParentId`) REFERENCES `AbpOrganizationUnits` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpPermissions
-- ----------------------------
DROP TABLE IF EXISTS `AbpPermissions`;
CREATE TABLE `AbpPermissions` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `Name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IsGranted` tinyint(1) NOT NULL,
  `Discriminator` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `RoleId` int DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpPermissions_TenantId_Name` (`TenantId`,`Name`),
  KEY `IX_AbpPermissions_RoleId` (`RoleId`),
  KEY `IX_AbpPermissions_UserId` (`UserId`),
  CONSTRAINT `FK_AbpPermissions_AbpRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AbpRoles` (`Id`) ON DELETE CASCADE,
  CONSTRAINT `FK_AbpPermissions_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpRoleClaims
-- ----------------------------
DROP TABLE IF EXISTS `AbpRoleClaims`;
CREATE TABLE `AbpRoleClaims` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `RoleId` int NOT NULL,
  `ClaimType` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClaimValue` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpRoleClaims_RoleId` (`RoleId`),
  KEY `IX_AbpRoleClaims_TenantId_ClaimType` (`TenantId`,`ClaimType`),
  CONSTRAINT `FK_AbpRoleClaims_AbpRoles_RoleId` FOREIGN KEY (`RoleId`) REFERENCES `AbpRoles` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpRoles
-- ----------------------------
DROP TABLE IF EXISTS `AbpRoles`;
CREATE TABLE `AbpRoles` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `Name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DisplayName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IsStatic` tinyint(1) NOT NULL,
  `IsDefault` tinyint(1) NOT NULL,
  `NormalizedName` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ConcurrencyStamp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpRoles_CreatorUserId` (`CreatorUserId`),
  KEY `IX_AbpRoles_DeleterUserId` (`DeleterUserId`),
  KEY `IX_AbpRoles_LastModifierUserId` (`LastModifierUserId`),
  KEY `IX_AbpRoles_TenantId_NormalizedName` (`TenantId`,`NormalizedName`),
  CONSTRAINT `FK_AbpRoles_AbpUsers_CreatorUserId` FOREIGN KEY (`CreatorUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpRoles_AbpUsers_DeleterUserId` FOREIGN KEY (`DeleterUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpRoles_AbpUsers_LastModifierUserId` FOREIGN KEY (`LastModifierUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpSettings
-- ----------------------------
DROP TABLE IF EXISTS `AbpSettings`;
CREATE TABLE `AbpSettings` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  `Name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `IX_AbpSettings_TenantId_Name_UserId` (`TenantId`,`Name`,`UserId`),
  KEY `IX_AbpSettings_UserId` (`UserId`),
  CONSTRAINT `FK_AbpSettings_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpTenantNotifications
-- ----------------------------
DROP TABLE IF EXISTS `AbpTenantNotifications`;
CREATE TABLE `AbpTenantNotifications` (
  `Id` char(36) NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `NotificationName` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `DataTypeName` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeName` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityTypeAssemblyQualifiedName` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EntityId` varchar(96) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Severity` tinyint unsigned NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpTenantNotifications_TenantId` (`TenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpTenants
-- ----------------------------
DROP TABLE IF EXISTS `AbpTenants`;
CREATE TABLE `AbpTenants` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `TenancyName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ConnectionString` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `EditionId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpTenants_CreatorUserId` (`CreatorUserId`),
  KEY `IX_AbpTenants_DeleterUserId` (`DeleterUserId`),
  KEY `IX_AbpTenants_EditionId` (`EditionId`),
  KEY `IX_AbpTenants_LastModifierUserId` (`LastModifierUserId`),
  KEY `IX_AbpTenants_TenancyName` (`TenancyName`),
  CONSTRAINT `FK_AbpTenants_AbpEditions_EditionId` FOREIGN KEY (`EditionId`) REFERENCES `AbpEditions` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpTenants_AbpUsers_CreatorUserId` FOREIGN KEY (`CreatorUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpTenants_AbpUsers_DeleterUserId` FOREIGN KEY (`DeleterUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpTenants_AbpUsers_LastModifierUserId` FOREIGN KEY (`LastModifierUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserAccounts
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserAccounts`;
CREATE TABLE `AbpUserAccounts` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `UserLinkId` bigint DEFAULT NULL,
  `UserName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `EmailAddress` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserAccounts_EmailAddress` (`EmailAddress`),
  KEY `IX_AbpUserAccounts_UserName` (`UserName`),
  KEY `IX_AbpUserAccounts_TenantId_EmailAddress` (`TenantId`,`EmailAddress`),
  KEY `IX_AbpUserAccounts_TenantId_UserId` (`TenantId`,`UserId`),
  KEY `IX_AbpUserAccounts_TenantId_UserName` (`TenantId`,`UserName`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserClaims
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserClaims`;
CREATE TABLE `AbpUserClaims` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `ClaimType` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClaimValue` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserClaims_UserId` (`UserId`),
  KEY `IX_AbpUserClaims_TenantId_ClaimType` (`TenantId`,`ClaimType`),
  CONSTRAINT `FK_AbpUserClaims_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserLoginAttempts
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserLoginAttempts`;
CREATE TABLE `AbpUserLoginAttempts` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `TenantId` int DEFAULT NULL,
  `TenancyName` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `UserId` bigint DEFAULT NULL,
  `UserNameOrEmailAddress` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClientIpAddress` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ClientName` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `BrowserInfo` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Result` tinyint unsigned NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserLoginAttempts_UserId_TenantId` (`UserId`,`TenantId`),
  KEY `IX_AbpUserLoginAttempts_TenancyName_UserNameOrEmailAddress_Resu~` (`TenancyName`,`UserNameOrEmailAddress`,`Result`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserLogins
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserLogins`;
CREATE TABLE `AbpUserLogins` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `LoginProvider` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ProviderKey` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserLogins_UserId` (`UserId`),
  KEY `IX_AbpUserLogins_TenantId_UserId` (`TenantId`,`UserId`),
  KEY `IX_AbpUserLogins_TenantId_LoginProvider_ProviderKey` (`TenantId`,`LoginProvider`,`ProviderKey`),
  CONSTRAINT `FK_AbpUserLogins_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserNotifications
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserNotifications`;
CREATE TABLE `AbpUserNotifications` (
  `Id` char(36) NOT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `TenantNotificationId` char(36) NOT NULL,
  `State` int NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserNotifications_UserId_State_CreationTime` (`UserId`,`State`,`CreationTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserOrganizationUnits
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserOrganizationUnits`;
CREATE TABLE `AbpUserOrganizationUnits` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `OrganizationUnitId` bigint NOT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserOrganizationUnits_TenantId_OrganizationUnitId` (`TenantId`,`OrganizationUnitId`),
  KEY `IX_AbpUserOrganizationUnits_TenantId_UserId` (`TenantId`,`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserRoles
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserRoles`;
CREATE TABLE `AbpUserRoles` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `RoleId` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserRoles_UserId` (`UserId`),
  KEY `IX_AbpUserRoles_TenantId_RoleId` (`TenantId`,`RoleId`),
  KEY `IX_AbpUserRoles_TenantId_UserId` (`TenantId`,`UserId`),
  CONSTRAINT `FK_AbpUserRoles_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUsers
-- ----------------------------
DROP TABLE IF EXISTS `AbpUsers`;
CREATE TABLE `AbpUsers` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `LastModifierUserId` bigint DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeleterUserId` bigint DEFAULT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  `AuthenticationSource` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `UserName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `TenantId` int DEFAULT NULL,
  `EmailAddress` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Surname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `EmailConfirmationCode` varchar(328) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `PasswordResetCode` varchar(328) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `LockoutEndDateUtc` datetime(6) DEFAULT NULL,
  `AccessFailedCount` int NOT NULL,
  `IsLockoutEnabled` tinyint(1) NOT NULL,
  `PhoneNumber` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `IsPhoneNumberConfirmed` tinyint(1) NOT NULL,
  `SecurityStamp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `IsTwoFactorEnabled` tinyint(1) NOT NULL,
  `IsEmailConfirmed` tinyint(1) NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `NormalizedUserName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `NormalizedEmailAddress` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `ConcurrencyStamp` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUsers_CreatorUserId` (`CreatorUserId`),
  KEY `IX_AbpUsers_DeleterUserId` (`DeleterUserId`),
  KEY `IX_AbpUsers_LastModifierUserId` (`LastModifierUserId`),
  KEY `IX_AbpUsers_TenantId_NormalizedEmailAddress` (`TenantId`,`NormalizedEmailAddress`),
  KEY `IX_AbpUsers_TenantId_NormalizedUserName` (`TenantId`,`NormalizedUserName`),
  CONSTRAINT `FK_AbpUsers_AbpUsers_CreatorUserId` FOREIGN KEY (`CreatorUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpUsers_AbpUsers_DeleterUserId` FOREIGN KEY (`DeleterUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT,
  CONSTRAINT `FK_AbpUsers_AbpUsers_LastModifierUserId` FOREIGN KEY (`LastModifierUserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpUserTokens
-- ----------------------------
DROP TABLE IF EXISTS `AbpUserTokens`;
CREATE TABLE `AbpUserTokens` (
  `Id` bigint NOT NULL AUTO_INCREMENT,
  `TenantId` int DEFAULT NULL,
  `UserId` bigint NOT NULL,
  `LoginProvider` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `Value` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `ExpireDate` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpUserTokens_UserId` (`UserId`),
  KEY `IX_AbpUserTokens_TenantId_UserId` (`TenantId`,`UserId`),
  CONSTRAINT `FK_AbpUserTokens_AbpUsers_UserId` FOREIGN KEY (`UserId`) REFERENCES `AbpUsers` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpWebhookEvents
-- ----------------------------
DROP TABLE IF EXISTS `AbpWebhookEvents`;
CREATE TABLE `AbpWebhookEvents` (
  `Id` char(36) NOT NULL,
  `WebhookName` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `CreationTime` datetime(6) NOT NULL,
  `TenantId` int DEFAULT NULL,
  `IsDeleted` tinyint(1) NOT NULL,
  `DeletionTime` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpWebhookSendAttempts
-- ----------------------------
DROP TABLE IF EXISTS `AbpWebhookSendAttempts`;
CREATE TABLE `AbpWebhookSendAttempts` (
  `Id` char(36) NOT NULL,
  `WebhookEventId` char(36) NOT NULL,
  `WebhookSubscriptionId` char(36) NOT NULL,
  `Response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `ResponseStatusCode` int DEFAULT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `LastModificationTime` datetime(6) DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `IX_AbpWebhookSendAttempts_WebhookEventId` (`WebhookEventId`),
  CONSTRAINT `FK_AbpWebhookSendAttempts_AbpWebhookEvents_WebhookEventId` FOREIGN KEY (`WebhookEventId`) REFERENCES `AbpWebhookEvents` (`Id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for AbpWebhookSubscriptions
-- ----------------------------
DROP TABLE IF EXISTS `AbpWebhookSubscriptions`;
CREATE TABLE `AbpWebhookSubscriptions` (
  `Id` char(36) NOT NULL,
  `CreationTime` datetime(6) NOT NULL,
  `CreatorUserId` bigint DEFAULT NULL,
  `TenantId` int DEFAULT NULL,
  `WebhookUri` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Secret` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `Webhooks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `Headers` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
