-- Base du site pour un serveur MariaDB local (mvn liberty:run). Les tables sont créées par Liquibase au démarrage
-- de Lutece. En Kubernetes, la base est créée par l'image MariaDB (deploy/k8s/mariadb-manifest.yaml).
CREATE DATABASE IF NOT EXISTS core CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
