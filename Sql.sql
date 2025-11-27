-- Cria o banco
CREATE DATABASE IF NOT EXISTS hexacore;
USE hexacore;

-- =========================================
-- TABELA: Usuario
-- =========================================
CREATE TABLE IF NOT EXISTS `Usuario` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do usuário',
  `nm_razao_social` VARCHAR(45) NOT NULL COMMENT 'Razão social do usuário',
  `nm_fantasia` VARCHAR(45) NOT NULL COMMENT 'Nome fantasia',
  `cd_cnpj` CHAR(14) NOT NULL COMMENT 'CNPJ formatado sem pontuação',
  `dt_cadastro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora do cadastro',
  `ds_email` VARCHAR(45) NOT NULL COMMENT 'Email de contato',
  `ds_senha` VARCHAR(30) NOT NULL COMMENT 'Senha de acesso',
  `cd_telefone` CHAR(11) NOT NULL COMMENT 'Telefone de contato',
  PRIMARY KEY (`id_usuario`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: Endereco
-- =========================================
CREATE TABLE IF NOT EXISTS `Endereco` (
  `id_endereco` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador único do endereço',
  `ds_tipo_logradouro` VARCHAR(45) NOT NULL COMMENT 'Tipo de logradouro (Rua, Av, etc.)',
  `nm_logradouro` VARCHAR(45) NOT NULL COMMENT 'Nome do logradouro',
  `nr_logradouro` INT NOT NULL COMMENT 'Número do logradouro',
  `nm_bairro` VARCHAR(45) NOT NULL COMMENT 'Nome do bairro',
  `nm_cidade` VARCHAR(45) NOT NULL COMMENT 'Cidade',
  `sg_uf` CHAR(2) NOT NULL COMMENT 'Unidade federativa (UF)',
  `cd_cep` CHAR(8) NOT NULL COMMENT 'CEP sem formatação',
  `fk_usuario` INT NOT NULL COMMENT 'Chave estrangeira para Usuario',
  PRIMARY KEY (`id_endereco`),
  INDEX `fk_Endereco_Usuario` (`fk_usuario` ASC),
  CONSTRAINT `fk_Endereco_Usuario`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `Usuario` (`id_usuario`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: SpotifyTopRaw
-- (ajuste: id_spotify_top NOT NULL + AUTO_INCREMENT)
-- =========================================
CREATE TABLE IF NOT EXISTS `SpotifyTopRaw` (
  `id_spotify_top` INT NOT NULL AUTO_INCREMENT,
  `nm_titulo` VARCHAR(150) NOT NULL,
  `cd_rank` INT NULL DEFAULT NULL,
  `dt_rank` DATETIME NULL DEFAULT NULL,
  `nm_artista` VARCHAR(100) NULL DEFAULT NULL,
  `nm_pais` VARCHAR(100) NULL DEFAULT NULL,
  `ds_chart` VARCHAR(100) NULL DEFAULT NULL,
  `ds_trend` VARCHAR(100) NULL DEFAULT NULL,
  `qt_stream` INT NULL DEFAULT NULL,
  `ds_genero` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id_spotify_top`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: SpotifyYoutubeRaw
-- =========================================
CREATE TABLE IF NOT EXISTS `SpotifyYoutubeRaw` (
  `id_spotify_youtube` INT NOT NULL AUTO_INCREMENT,
  `nm_track` VARCHAR(100) NULL,
  `nm_album` VARCHAR(100) NULL,
  `tp_album` VARCHAR(45) NULL,
  `nm_artista` VARCHAR(100) NOT NULL,
  `nm_title` VARCHAR(100) NOT NULL,
  `qt_stream` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_spotify_youtube`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: DadosTratadosTrusted
-- (FK depende de SpotifyTopRaw e SpotifyYoutubeRaw já existirem)
-- =========================================
CREATE TABLE IF NOT EXISTS `DadosTratadosTrusted` (
  `fk_spotify_top` INT NOT NULL,
  `fk_spotify_youtube` INT NOT NULL,
  `nm_artista` VARCHAR(100) NULL DEFAULT NULL,
  `nm_track` VARCHAR(100) NULL DEFAULT NULL,
  `tp_album` VARCHAR(45) NULL DEFAULT NULL,
  `nm_titulo` VARCHAR(150) NULL DEFAULT NULL,
  `qt_stream` INT NULL DEFAULT NULL,
  `nm_album` VARCHAR(100) NULL DEFAULT NULL,
  `cd_rank` INT NULL DEFAULT NULL,
  `dt_rank` DATETIME NULL DEFAULT NULL,
  `nm_pais` VARCHAR(45) NULL DEFAULT NULL,
  `ds_chart` VARCHAR(45) NULL DEFAULT NULL,
  `ds_trend` VARCHAR(45) NULL DEFAULT NULL,
  `ds_genero` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`fk_spotify_top`, `fk_spotify_youtube`),
  INDEX `fk_DadosTratados_SpotifyYoutube` (`fk_spotify_youtube` ASC),
  CONSTRAINT `fk_DadosTratados_SpotifyTop`
    FOREIGN KEY (`fk_spotify_top`)
    REFERENCES `SpotifyTopRaw` (`id_spotify_top`),
  CONSTRAINT `fk_DadosTratados_SpotifyYoutube`
    FOREIGN KEY (`fk_spotify_youtube`)
    REFERENCES `SpotifyYoutubeRaw` (`id_spotify_youtube`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: ArtistaClient
-- (ajuste: id_artista NOT NULL + AUTO_INCREMENT)
-- =========================================
CREATE TABLE IF NOT EXISTS `ArtistaClient` (
  `id_artista` INT NOT NULL AUTO_INCREMENT,
  `nm_artista` VARCHAR(100) NOT NULL,
  `ds_genero_musical` VARCHAR(45) NULL DEFAULT NULL,
  `fk_dados_spotify_top` INT NOT NULL,
  `fk_dados_spotify_youtube` INT NOT NULL,
  PRIMARY KEY (`id_artista`),
  INDEX `fk_Artista_DadosTratados` (`fk_dados_spotify_top` ASC, `fk_dados_spotify_youtube` ASC),
  CONSTRAINT `fk_Artista_DadosTratados`
    FOREIGN KEY (`fk_dados_spotify_top` , `fk_dados_spotify_youtube`)
    REFERENCES `DadosTratadosTrusted` (`fk_spotify_top` , `fk_spotify_youtube`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: MusicaClient
-- (ajuste: id_musica NOT NULL + AUTO_INCREMENT)
-- =========================================
CREATE TABLE IF NOT EXISTS `MusicaClient` (
  `id_musica` INT NOT NULL AUTO_INCREMENT,
  `nm_track` VARCHAR(150) NULL DEFAULT NULL,
  `nm_musica` VARCHAR(100) NOT NULL,
  `tp_album` VARCHAR(150) NOT NULL,
  `nm_album` VARCHAR(150) NOT NULL,
  `rank_pais` INT NOT NULL,
  `nm_pais` VARCHAR(150) NOT NULL,
  `qt_stream` INT NOT NULL,
  `fk_artista` INT NOT NULL,
  `fk_dados_spotify_top` INT NOT NULL,
  `fk_dados_spotify_youtube` INT NOT NULL,
  PRIMARY KEY (`id_musica`),
  INDEX `fk_Musica_Artista` (`fk_artista` ASC),
  INDEX `fk_Musica_DadosTratados` (`fk_dados_spotify_top` ASC, `fk_dados_spotify_youtube` ASC),
  CONSTRAINT `fk_Musica_Artista`
    FOREIGN KEY (`fk_artista`)
    REFERENCES `ArtistaClient` (`id_artista`),
  CONSTRAINT `fk_Musica_DadosTratados`
    FOREIGN KEY (`fk_dados_spotify_top` , `fk_dados_spotify_youtube`)
    REFERENCES `DadosTratadosTrusted` (`fk_spotify_top` , `fk_spotify_youtube`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: Status
-- =========================================
CREATE TABLE IF NOT EXISTS `Status` (
  `id_status` INT NOT NULL,
  `nm_status` VARCHAR(45) NULL,
  `ds_status` VARCHAR(45) NULL,
  PRIMARY KEY (`id_status`)
) ENGINE = InnoDB;

-- =========================================
-- TABELA: LogImportacao
-- (ajuste: idLog NOT NULL + AUTO_INCREMENT)
-- =========================================
CREATE TABLE IF NOT EXISTS `LogImportacao` (
  `idLog` INT NOT NULL AUTO_INCREMENT,
  `tabelaAlvo` VARCHAR(50) NOT NULL,
  `dtHoraLog` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registrosInseridos` INT NULL DEFAULT 0,
  `mensagem` TEXT NULL DEFAULT NULL,
  `id_status` INT NOT NULL,
  PRIMARY KEY (`idLog`, `id_status`),
  INDEX `fk_LogImportacao_Status1_idx` (`id_status` ASC),
  CONSTRAINT `fk_LogImportacao_Status1`
    FOREIGN KEY (`id_status`)
    REFERENCES `Status` (`id_status`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- =========================================
-- TABELA: ArtistaGravadora
-- =========================================
CREATE TABLE IF NOT EXISTS `ArtistaGravadora` (
  `id_artista` INT NOT NULL,
  `nm_artista` VARCHAR(45) NULL,
  `ds_genero_musical` VARCHAR(45) NULL,
  `fk_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_artista`, `fk_id_usuario`),
  INDEX `fk_ArtistaGravadora_Usuario1_idx` (`fk_id_usuario` ASC),
  CONSTRAINT `fk_ArtistaGravadora_Usuario1`
    FOREIGN KEY (`fk_id_usuario`)
    REFERENCES `Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- =========================================
-- TABELA: Artista
-- (ajuste: artista_gravadora_id_artista NOT NULL para permitir PRIMARY KEY)
-- =========================================
CREATE TABLE IF NOT EXISTS `Artista` (
  `id_artista` INT NOT NULL,
  `nm_artista` VARCHAR(45) NULL,
  `ds_genero_musical` VARCHAR(45) NULL,
  `artista_client_id_artista` INT NOT NULL,
  `artista_gravadora_id_artista` INT NOT NULL,
  PRIMARY KEY (`id_artista`, `artista_client_id_artista`, `artista_gravadora_id_artista`),
  INDEX `fk_Artista_ArtistaClient1_idx` (`artista_client_id_artista` ASC),
  INDEX `fk_Artista_ArtistaGravadora1_idx` (`artista_gravadora_id_artista` ASC),
  CONSTRAINT `fk_Artista_ArtistaClient1`
    FOREIGN KEY (`artista_client_id_artista`)
    REFERENCES `ArtistaClient` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Artista_ArtistaGravadora1`
    FOREIGN KEY (`artista_gravadora_id_artista`)
    REFERENCES `ArtistaGravadora` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- =========================================
-- TABELA: SlackAtivo
-- =========================================
CREATE TABLE IF NOT EXISTS `SlackAtivo` (
  `id_slack_ativo` INT NOT NULL,
  `status` TINYINT NULL,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`id_slack_ativo`, `fk_usuario`),
  INDEX `fk_SlackAtivo_Usuario1_idx` (`fk_usuario` ASC),
  CONSTRAINT `fk_SlackAtivo_Usuario1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- =========================================
-- TABELA: SlackNotificacao
-- (depende de LogImportacao e SlackAtivo já criadas)
-- =========================================
CREATE TABLE IF NOT EXISTS `SlackNotificacao` (
  `id_slack_notificacao` INT NOT NULL,
  `canal_slack` VARCHAR(45) NULL,
  `mensagem` VARCHAR(45) NULL,
  `status_envio` VARCHAR(45) NULL,
  `dt_envio` DATETIME NULL,
  `log_importacao_id` INT NOT NULL,
  `log_importacao_id_status` INT NOT NULL,
  `id_status_ativo` INT NOT NULL,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`id_slack_notificacao`, `id_status_ativo`, `fk_usuario`),
  INDEX `fk_SlackNotificacao_LogImportacao1_idx` (`log_importacao_id` ASC, `log_importacao_id_status` ASC),
  INDEX `fk_SlackNotificacao_SlackAtivo1_idx` (`id_status_ativo` ASC, `fk_usuario` ASC),
  CONSTRAINT `fk_SlackNotificacao_LogImportacao1`
    FOREIGN KEY (`log_importacao_id` , `log_importacao_id_status`)
    REFERENCES `LogImportacao` (`idLog` , `id_status`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SlackNotificacao_SlackAtivo1`
    FOREIGN KEY (`id_status_ativo` , `fk_usuario`)
    REFERENCES `SlackAtivo` (`id_slack_ativo` , `fk_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- =========================================
-- TABELA: FiltroDashboard
-- =========================================
CREATE TABLE IF NOT EXISTS `FiltroDashboard` (
  `id_filtro` INT NOT NULL,
  `nm_pais` VARCHAR(45) NULL,
  `ds_genero` VARCHAR(45) NULL,
  `qt_stream` INT NULL,
  `tp_album` VARCHAR(45) NULL,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`id_filtro`, `fk_usuario`),
  INDEX `fk_FiltroDashboard_Usuario1_idx` (`fk_usuario` ASC),
  CONSTRAINT `fk_FiltroDashboard_Usuario1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `Usuario` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;
