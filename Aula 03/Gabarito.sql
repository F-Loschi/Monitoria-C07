-- 1. Banco de Dados
DROP DATABASE IF EXISTS agencia_db;
CREATE DATABASE agencia_db;
USE agencia_db;

-- 2. Tabela
CREATE TABLE agente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codinome VARCHAR(20),
    nome_real VARCHAR(100),
    especialidade VARCHAR(40),
    pais_alocacao VARCHAR(50),
    ano_recrutamento INT NOT NULL,
    data_ultima_missao DATE,
    orcamento_missao DECIMAL(10, 2),
    em_servico_ativo BOOLEAN DEFAULT TRUE
);

-- 3. Manutencao de Estrutura
ALTER TABLE agente ADD nivel_acesso INT;
ALTER TABLE agente ADD contato_emergencia VARCHAR(80);
ALTER TABLE agente MODIFY COLUMN codinome VARCHAR(60);
ALTER TABLE agente MODIFY COLUMN pais_alocacao VARCHAR(80);
ALTER TABLE agente DROP COLUMN nome_real;