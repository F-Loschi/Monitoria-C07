-- Exercício: O Caso do Papiro Desaparecido
-- Monitoria de Banco de Dados - Inatel

SET SQL_SAFE_UPDATES = 0;

DROP DATABASE IF EXISTS expedicao_db;
CREATE DATABASE expedicao_db;
USE expedicao_db;

-- PARTE 1: Criação da Tabela (CREATE TABLE)

CREATE TABLE membros_expedicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    anos_experiencia INT,
    funcao VARCHAR(50),
    universidade VARCHAR(60),
    estava_na_tenda_principal BOOLEAN,
    horario_visto TIME,
    testemunha_confirmada BOOLEAN,
    pistas_encontradas INT,
    grau_desconfianca ENUM('BAIXO', 'MEDIO', 'ALTO', 'CRITICO')
);

-- PARTE 2: Inserção de Dados (INSERT)

INSERT INTO membros_expedicao 
(nome, anos_experiencia, funcao, universidade, estava_na_tenda_principal, horario_visto, testemunha_confirmada, pistas_encontradas, grau_desconfianca) 
VALUES
('Arthur Pendelton', 22, 'Arqueologo Chefe', 'Oxford', TRUE, '22:45:00', TRUE, 0, 'BAIXO'),
('Elena Rostova', 12, 'Restauradora', 'Sorbonne', TRUE, '22:45:00', FALSE, 2, 'ALTO'),
('Tariq Al-Mansoor', 8, 'Guia Local', 'Cairo University', FALSE, '21:30:00', TRUE, 0, 'BAIXO'),
('Lucas Silva', 3, 'Assistente de Campo', 'USP', TRUE, '22:50:00', FALSE, 1, 'MEDIO'),
('Beatriz Mendes', 5, 'Epigrafista', 'Coimbra', FALSE, '20:15:00', TRUE, 0, 'BAIXO'),
('Hans Gruber', 18, 'Historiador', 'Heidelberg', TRUE, '22:40:00', FALSE, 3, 'CRITICO'),
('Amira Hassan', 10, 'Fotografa Documentarista', 'Cairo University', FALSE, '23:10:00', TRUE, 0, 'BAIXO'),
('Mateo Benitez', 2, 'Estagiario de Conservacao', 'Madrid', TRUE, '22:35:00', TRUE, 0, 'MEDIO');


-- PARTE 3: Atualizações de Dados (UPDATE)

-- 1. Atualizar o grau de desconfiança do Lucas Silva (ID=4) para 'ALTO'
UPDATE membros_expedicao 
SET grau_desconfianca = 'ALTO' 
WHERE id = 4;

-- 2. Corrigir a universidade do registro da Dra. Elena Rostova para 'Cambridge'
UPDATE membros_expedicao 
SET universidade = 'Cambridge' 
WHERE nome = 'Elena Rostova';

-- 3. Atualizar o grau de desconfiança do Hans Gruber (ID=6) para 'CRITICO'
UPDATE membros_expedicao 
SET grau_desconfianca = 'CRITICO' 
WHERE id = 6;


-- PARTE 4: Remoção de Dados (DELETE)

-- 1. Remover um membro que comprovou inocência
DELETE FROM membros_expedicao 
WHERE testemunha_confirmada = TRUE 
  AND pistas_encontradas = 0 
  AND grau_desconfianca = 'BAIXO' 
LIMIT 1;

-- 2. Remover todos os membros com grau de desconfiança 'BAIXO' restante
DELETE FROM membros_expedicao 
WHERE grau_desconfianca = 'BAIXO';

-- PARTE 5: Consultas Investigativas (SELECT)

-- 1. Liste todos os registros restantes
SELECT * FROM membros_expedicao;

-- 2. Liste apenas nome e função
SELECT nome, funcao FROM membros_expedicao;

-- 3. Mostre os membros ordenados por anos de experiência (ordem decrescente)
SELECT * FROM membros_expedicao 
ORDER BY anos_experiencia DESC;


-- --- Condicional ---
-- 1. Liste quem estava na tenda principal
SELECT * FROM membros_expedicao 
WHERE estava_na_tenda_principal = TRUE;

-- 2. Liste quem possui grau de desconfiança igual a 'ALTO' ou 'CRITICO'
SELECT * FROM membros_expedicao 
WHERE grau_desconfianca = 'ALTO' OR grau_desconfianca = 'CRITICO';

-- 3. Liste membros com anos de experiência entre 5 e 20 anos
SELECT * FROM membros_expedicao 
WHERE anos_experiencia BETWEEN 5 AND 20;


-- --- Filtro de Texto ---
-- 1. Liste membros cujo nome começa com a letra 'A'
SELECT * FROM membros_expedicao 
WHERE nome LIKE 'A%';

-- 2. Liste membros cujo nome termina com 'o'
SELECT * FROM membros_expedicao 
WHERE nome LIKE '%o';

-- 3. Liste membros cuja função contenha a palavra 'Arqueologo' ou 'Assistente'
SELECT * FROM membros_expedicao 
WHERE funcao LIKE '%Arqueologo%' OR funcao LIKE '%Assistente%';


-- --- IN ---
-- 1. Liste membros das universidades: 'Oxford', 'Cambridge' ou 'USP'
SELECT * FROM membros_expedicao 
WHERE universidade IN ('Oxford', 'Cambridge', 'USP');

-- 2. Liste membros cujo grau de desconfiança esteja entre 'MEDIO', 'ALTO' ou 'CRITICO'
SELECT * FROM membros_expedicao 
WHERE grau_desconfianca IN ('MEDIO', 'ALTO', 'CRITICO');


-- --- Funções de Agregação ---
-- 1. Conte o total de membros cadastrados/restantes
SELECT COUNT(*) AS total_membros FROM membros_expedicao;

-- 2. Mostre a soma total de pistas encontradas
SELECT SUM(pistas_encontradas) AS total_pistas FROM membros_expedicao;


-- --- Agrupamento ---
-- 1. Agrupe por universidade e conte quantos membros há em cada uma
SELECT universidade, COUNT(*) AS quantidade 
FROM membros_expedicao 
GROUP BY universidade;

-- 2. Agrupe por grau_desconfianca e conte quantos membros existem em cada categoria
SELECT grau_desconfianca, COUNT(*) AS quantidade 
FROM membros_expedicao 
GROUP BY grau_desconfianca;


-- DESAFIO FINAL: Identificando o Suspeito

SELECT 
    id, 
    nome, 
    funcao, 
    universidade, 
    grau_desconfianca, 
    pistas_encontradas,
    'CULPADO' AS veredito
FROM membros_expedicao 
WHERE estava_na_tenda_principal = TRUE
  AND testemunha_confirmada = FALSE
  AND grau_desconfianca = 'CRITICO'
  AND pistas_encontradas >= 1
  AND (nome LIKE 'E%' OR nome LIKE 'H%');