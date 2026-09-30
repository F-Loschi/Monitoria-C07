DROP DATABASE IF EXISTS av1;
CREATE DATABASE IF NOT EXISTS av1;
USE av1;
SET SQL_SAFE_UPDATES = 0;
# Parte 1:
#Questão 1:
CREATE TABLE IF NOT EXISTS Chef(
	id_chef INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cpf CHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK(email LIKE "%@masterchef.br"),
    especialidade VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Aluno(
	id_aluno INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK(email LIKE "%@gmail.com"),
    data_cadastro DATE NOT NULL,
    horas_cursadas INT CHECK(horas_cursadas>=0)
);

CREATE TABLE IF NOT EXISTS Workshop(
	id_workshop INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT,
    id_chef INT,
    prato_principal VARCHAR(100) NOT NULL,
    semestre VARCHAR(10) NOT NULL,
    status_workshop ENUM("INSCRITO", "CONFIRMADO", "CONCLUIDO",
    "CANCELADO") DEFAULT("INSCRITO") NOT NULL,
    FOREIGN KEY(id_aluno) REFERENCES Aluno(id_aluno),
    FOREIGN KEY(id_chef) REFERENCES Chef(id_chef)
);

#Questão 2:
#a)
ALTER TABLE Aluno ADD nivel_experiencia CHAR(3);
#b)
ALTER TABLE Chef MODIFY especialidade VARCHAR(80);
#c)
SHOW TABLES;
#d)
#TRUNCATE TABLE Workshop;
#e)
# DROP DATABASE IF EXISTS masterchef_teste;

# Parte 2:
INSERT INTO Chef(cpf, nome, email, especialidade) VALUES
("123.456.789-10", "Edna Souza","edna@masterchef.br",
"Cozinha Francesa"),
("234.567.891-01","Diego Dias", "diego@masterchef.br",
"Cozinha Francesa"),
("345.678.910-11","Yasmin Barbosa","yasmin@masterchef.br",
"Cozinha Italiana");

INSERT INTO Aluno(nome, email, data_cadastro, horas_cursadas,
nivel_experiencia) VALUES ("Amanda Loyola",
"amanda@gmail.com", "2021-02-01", 40, "INT"),
("Danilo Almeida","danilo@gmail.com","2021-02-01", 20, "INI"),
("Jorge Augusto", "jorge@gmail.com", "2022-02-01", 60, "AVA"),
("Paula Carvalho","paula@gmail.com", "2023-02-01", 10, "INI");

INSERT INTO Workshop(id_aluno, id_chef, prato_principal, semestre, 
status_workshop) VALUES (1, 1, "Soufflé de Queijo", "2024-1",
"INSCRITO"),
(1, 2, "Soufflé de Queijo", "2024-1", "INSCRITO"),
(2, 3, "Massa Artesanal", "2024-1", "CONCLUIDO"),
(4, 3, "Macarons", "2024-1", "CONFIRMADO"),
(1, 2, "Massa Artesanal","2024-2", "CANCELADO");

# Questão 4
#a)
UPDATE Workshop SET status_workshop = "INSCRITO"
WHERE id_workshop = 4;

#b)
UPDATE Workshop SET status_workshop = "CONCLUIDO"
WHERE semestre ="2024-1";

#c)
UPDATE Aluno 
SET email="jorge.augusto@gmail.com", nivel_experiencia = "INT" 
WHERE id_aluno = 3;

# Questão 5
#a)
DELETE FROM Workshop
WHERE id_workshop = 4;
#b)
#DELETE FROM Aluno 
#WHERE id_aluno = 1;
# Na criação da Table workshop deveria ser cascateado a deletação
#para que, ao deletar um aluno, seus workshops também sejam deletados

# Questão 6
#a)
SELECT nome, email FROM Aluno WHERE data_cadastro >= "2022-01-01"
ORDER BY nome;

#b)
SELECT id_aluno, COUNT(id_workshop) AS qtd_total, MIN(semestre)
AS semestreAntigo, MAX(semestre) AS semestreRecente 
FROM Workshop 
GROUP BY id_aluno
ORDER BY qtd_total DESC;

#c)
SELECT prato_principal, COUNT(prato_principal) AS qtd_total
FROM Workshop
GROUP BY prato_principal
HAVING qtd_total > 1;

# Parte 3
# Questão 7
SELECT id_aluno, COUNT(id_workshop) AS qtd_workshop FROM Workshop
WHERE status_workshop IN("CONFIRMADO", "CONCLUIDO")
AND id_chef IN(SELECT id_chef FROM Chef WHERE especialidade = "Cozinha Francesa")
GROUP BY id_aluno
HAVING qtd_workshop > 1
ORDER BY COUNT(id_workshop) DESC;