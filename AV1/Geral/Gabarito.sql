DROP DATABASE IF EXISTS AV1;
CREATE DATABASE IF NOT EXISTS AV1;
USE AV1;

SET SQL_SAFE_UPDATES = 0;

CREATE TABLE IF NOT EXISTS Tatuador(
	id_tatuador INT NOT NULL auto_increment primary key,
    cpf CHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK(email LIKE "%@inkhouse.br"),
    especialidade VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cliente(
	id_cliente INT NOT NULL auto_increment primary key,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL CHECK(email LIKE "%@gmail.com"),
    data_cadastro DATE NOT NULL,
    qtd_tatuagens INT CHECK(qtd_tatuagens >= 0)
);

CREATE TABLE IF NOT EXISTS Sessao(
	id_sessao INT NOT NULL auto_increment primary key,
    id_cliente INT,
    id_tatuador INT,
    estilo_tatuagem VARCHAR(100) NOT NULL,
    temporada VARCHAR(10) NOT NULL,
    status_sessao ENUM("AGENDADA", "CONFIRMADA", "REALIZADA", "CANCELADA") NOT NULL	 DEFAULT("AGENDADA"),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (id_tatuador) REFERENCES Tatuador(id_tatuador)
);

#Questão 2:
#a)
ALTER TABLE Cliente ADD categoria_cliente CHAR(3);
#b)
ALTER TABLE Tatuador MODIFY especialidade VARCHAR(80);
#c)
SHOW TABLES;
#d)
#TRUNCATE TABLE Sessao;
#e)
# DROP DATABASE IF EXISTS inkhouse_teste;

# Parte 2:
INSERT INTO Tatuador(cpf, nome, email, especialidade) VALUES
("111.222.333-44", "Thiago Rocha", "thiago@inkhouse.br", "Old School"),
("222.333.444-55", "Bianca Alves", "bianca@inkhouse.br", "Old School"),
("333.444.555-66", "Renata Cunha", "renata@inkhouse.br", "Realismo");

INSERT INTO Cliente(nome, email, data_cadastro, qtd_tatuagens, categoria_cliente) VALUES 
("Gustavo Lima", "gustavo@gmail.com", "2021-04-12", 3, "NOV"),
("Sandy Junior", "sandy@gmail.com", "2021-04-12", 1, "NOV"),
("Jorge Vercillo", "jorge@gmail.com", "2022-05-18", 6, "VIP"),
("Sabrina Carpenter", "sabrina@gmail.com", "2023-06-25", 1, "NOV");

INSERT INTO Sessao(id_cliente, id_tatuador, estilo_tatuagem, temporada, status_sessao) VALUES
(1, 1, "Old School", "2024-1","AGENDADA"),
(1, 2, "Old School", "2024-1", "AGENDADA"),
(2, 3, "Realismo", "2024-1", "REALIZADA"),
(4, 3, "Fineline", "2024-1", "CONFIRMADA"),
(1, 2, "Realismo","2024-2", "CANCELADA");

# Questão 4
#a)
UPDATE Sessao 
SET status_sessao = "AGENDADA"
WHERE id_sessao = 4;

#b)
UPDATE Sessao 
SET status_sessao = "REALIZADA"
WHERE temporada ="2024-1";

#c)
UPDATE Cliente 
SET email = "jorge.vercillo@gmail.com", categoria_cliente = "FIE" 
WHERE id_cliente = 3;

# Questão 5
#a)
DELETE FROM Sessao
WHERE id_sessao = 4;
#b)
#DELETE FROM Cliente 
#WHERE id_cliente = 1;
# Na criação da Table Sessao deveria ser cascateado a deletação
#para que, ao deletar um cliente, suas sessões também sejam deletadas

# Questão 6
#a)
SELECT nome, email FROM Cliente WHERE data_cadastro >= "2022-01-01"
ORDER BY nome;

#b)
SELECT id_cliente, COUNT(id_cliente) AS qtd_total, MIN(temporada)
AS temporadaAntigo, MAX(temporada) AS temporadaRecente 
FROM Sessao 
GROUP BY id_cliente
ORDER BY qtd_total DESC;

#c)
SELECT estilo_tatuagem, COUNT(estilo_tatuagem) AS qtd_total
FROM Sessao
GROUP BY estilo_tatuagem
HAVING qtd_total > 1;

# Parte 3
# Questão 7
SELECT id_cliente, COUNT(id_sessao) AS qtd_sessao FROM Sessao
WHERE status_sessao IN("CONFIRMADA", "REALIZADA")
AND id_tatuador IN(SELECT id_tatuador FROM Tatuador WHERE especialidade = "Old School")
GROUP BY id_cliente
HAVING qtd_sessao > 1
ORDER BY COUNT(id_sessao) DESC;