CREATE DATABASE if not exists hexacore;
USE hexacore;

CREATE TABLE IF NOT EXISTS Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único do usuário',
  nm_razao_social VARCHAR(45) NOT NULL COMMENT 'Razão social do usuário',
  nm_fantasia VARCHAR(45) NOT NULL COMMENT 'Nome fantasia',
  cd_cnpj CHAR(14) NOT NULL COMMENT 'CNPJ formatado sem pontuação',
  dt_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Data e hora do cadastro',
  ds_email VARCHAR(45) NOT NULL COMMENT 'Email de contato',
  ds_senha VARCHAR(30) NOT NULL COMMENT 'Senha de acesso',
  cd_telefone CHAR(11) NOT NULL COMMENT 'Telefone de contato'
);
CREATE TABLE IF NOT EXISTS Endereco (
  id_endereco INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Identificador único do endereço',
  ds_tipo_logradouro VARCHAR(45) NOT NULL COMMENT 'Tipo de logradouro (Rua, Av, etc.)',
  nm_logradouro VARCHAR(45) DEFAULT NULL COMMENT 'Nome do logradouro',
  nr_logradouro INT NOT NULL COMMENT 'Número do logradouro',
  nm_bairro VARCHAR(45) NOT NULL COMMENT 'Nome do bairro',
  nm_cidade VARCHAR(45) NOT NULL COMMENT 'Cidade',
  sg_uf CHAR(2) NOT NULL COMMENT 'Unidade federativa (UF)',
  cd_cep CHAR(8) NOT NULL COMMENT 'CEP sem formatação',
  fk_usuario INT DEFAULT NULL COMMENT 'Chave estrangeira para Usuario',
  CONSTRAINT fk_Endereco_Usuario FOREIGN KEY (fk_usuario)
    REFERENCES Usuario (id_usuario)
);
CREATE TABLE IF NOT EXISTS SpotifyTop (
    id_spotify_top INT AUTO_INCREMENT PRIMARY KEY,
    nm_titulo VARCHAR(150) NOT NULL,
    cd_rank INT NULL,
    dt_rank DATETIME NULL,
    nm_artista VARCHAR(100) NULL,
    nm_pais VARCHAR(100) NULL,
    ds_chart VARCHAR(100) NULL,
    ds_trend VARCHAR(100) NULL,
    qt_stream INT NULL,
    ds_genero VARCHAR(45) NULL
);
CREATE TABLE IF NOT EXISTS SpotifyYoutube (
    id_spotify_youtube INT AUTO_INCREMENT PRIMARY KEY,
    nm_track VARCHAR(100) NULL,
    nm_album VARCHAR(100) NULL,
    tp_album VARCHAR(45) NULL,
    nm_artista VARCHAR(100) NULL,
    nm_title VARCHAR(100) NULL,
    qt_stream INT NULL
);
CREATE TABLE IF NOT EXISTS DadosTratados (
  fk_spotify_top INT NOT NULL,
  fk_spotify_youtube INT NOT NULL,
  nm_artista VARCHAR(100) NULL,
  nm_track VARCHAR(100) NULL,
  tp_album VARCHAR(45) NULL,
  nm_titulo VARCHAR(150) NULL,
  qt_stream INT NULL,
  nm_album VARCHAR(100) NULL,
  cd_rank INT NULL,
  dt_rank DATETIME NULL,
  nm_pais VARCHAR(45) NULL,
  ds_chart VARCHAR(45) NULL,
  ds_trend VARCHAR(45) NULL,
  ds_genero  VARCHAR(45) NULL,
  PRIMARY KEY (fk_spotify_top, fk_spotify_youtube),
  CONSTRAINT fk_DadosTratados_SpotifyTop FOREIGN KEY (fk_spotify_top)
    REFERENCES SpotifyTop (id_spotify_top),
  CONSTRAINT fk_DadosTratados_SpotifyYoutube FOREIGN KEY (fk_spotify_youtube)
    REFERENCES SpotifyYoutube (id_spotify_youtube)
);
CREATE TABLE IF NOT EXISTS Artista (
  id_artista INT AUTO_INCREMENT PRIMARY KEY,
  nm_artista VARCHAR(100) NOT NULL,
  ds_genero_musical VARCHAR(45) DEFAULT NULL,
  fk_usuario INT DEFAULT NULL,
  fk_dados_spotify_top INT NOT NULL,
  fk_dados_spotify_youtube INT NOT NULL,
  CONSTRAINT fk_Artista_Usuario FOREIGN KEY (fk_usuario)
    REFERENCES Usuario (id_usuario),
  CONSTRAINT fk_Artista_DadosTratados FOREIGN KEY (fk_dados_spotify_top, fk_dados_spotify_youtube)
    REFERENCES DadosTratados (fk_spotify_top, fk_spotify_youtube)
);
CREATE TABLE IF NOT EXISTS Musica (
  id_musica INT AUTO_INCREMENT PRIMARY KEY,
  nm_track VARCHAR(150) DEFAULT NULL,
  nm_musica VARCHAR(100) NOT NULL,
  tp_album VARCHAR(150) NOT NULL,
  nm_album VARCHAR(150) NOT NULL,
  rank_pais INT NOT NULL,
  nm_pais VARCHAR(150) NOT NULL,
  qt_stream INT not NULL,
  fk_artista INT NOT NULL,
  fk_dados_spotify_top INT NOT NULL,
  fk_dados_spotify_youtube INT NOT NULL,
  CONSTRAINT fk_Musica_Artista FOREIGN KEY (fk_artista)
    REFERENCES Artista (id_artista),
  CONSTRAINT fk_Musica_DadosTratados FOREIGN KEY (fk_dados_spotify_top, fk_dados_spotify_youtube)
    REFERENCES DadosTratados (fk_spotify_top, fk_spotify_youtube)
);
CREATE TABLE IF NOT EXISTS LogImportacao (

    idLog INT AUTO_INCREMENT PRIMARY KEY,
    tabelaAlvo VARCHAR(50) NOT NULL, 
    statusLog VARCHAR(20) NOT NULL,  
    dtHoraLog TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    registrosInseridos INT DEFAULT 0, 
    mensagem TEXT NULL               
);

INSERT INTO Usuario (
  nm_razao_social,
  nm_fantasia,
  cd_cnpj,
  ds_email,
  ds_senha,
  cd_telefone
)
VALUES (
  'SomPrime Produções Musicais LTDA',
  'SomPrime Records',
  '12345678000199',
  'contato@somprime.com.br',
  'sp2025music',
  '11987654321'
);

INSERT INTO Endereco (
  ds_tipo_logradouro,
  nm_logradouro,
  nr_logradouro,
  nm_bairro,
  nm_cidade,
  sg_uf,
  cd_cep,
  fk_usuario
)
VALUES (
  'Avenida',
  'Paulista',
  1578,
  'Bela Vista',
  'São Paulo',
  'SP',
  '01310100',
  1
);

