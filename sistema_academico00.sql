-- ==========================================
-- SISTEMA DE GESTÃO ACADÊMICA
-- Disciplina: Banco de Dados
-- SGBD: PostgreSQL
-- ==========================================

-- ==========================================
-- CRIAÇÃO DAS TABELAS
-- ==========================================

-- Tabela de cursos
CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome_curso VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0)
);

-- Tabela de professores
CREATE TABLE professores (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    especialidade VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de alunos
CREATE TABLE alunos (
    id_aluno SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL
);

-- Tabela de disciplinas
CREATE TABLE disciplinas (
    id_disciplina SERIAL PRIMARY KEY,
    nome_disciplina VARCHAR(100) NOT NULL,
    carga_horaria INT NOT NULL CHECK (carga_horaria > 0),
    id_curso INT NOT NULL,
    CONSTRAINT fk_disciplina_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso)
);

-- Tabela de turmas
CREATE TABLE turmas (
    id_turma SERIAL PRIMARY KEY,
    semestre VARCHAR(10) NOT NULL,
    turno VARCHAR(20) NOT NULL,
    id_disciplina INT NOT NULL,
    id_professor INT NOT NULL,
    CONSTRAINT fk_turma_disciplina
        FOREIGN KEY (id_disciplina)
        REFERENCES disciplinas(id_disciplina),
    CONSTRAINT fk_turma_professor
        FOREIGN KEY (id_professor)
        REFERENCES professores(id_professor)
);

-- Tabela de matrículas
CREATE TABLE matriculas (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    data_matricula DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (id_aluno)
        REFERENCES alunos(id_aluno),
    CONSTRAINT fk_matricula_turma
        FOREIGN KEY (id_turma)
        REFERENCES turmas(id_turma)
);

-- ==========================================
-- INSERÇÃO DE DADOS
-- ==========================================

-- Cursos (mínimo exigido: 3)
INSERT INTO cursos (nome_curso, carga_horaria) VALUES
('Ciência da Computação', 3200),
('Análise e Desenvolvimento de Sistemas', 2400),
('Sistemas de Informação', 3000);

-- Professores (mínimo exigido: 5)
INSERT INTO professores (nome, especialidade, email) VALUES
('João Silva', 'Banco de Dados', 'joao.silva@instituicao.edu.br'),
('Maria Oliveira', 'Programação Web', 'maria.oliveira@instituicao.edu.br'),
('Carlos Souza', 'Estruturas de Dados', 'carlos.souza@instituicao.edu.br'),
('Ana Costa', 'Engenharia de Software', 'ana.costa@instituicao.edu.br'),
('Pedro Santos', 'Redes de Computadores', 'pedro.santos@instituicao.edu.br');

-- Alunos (mínimo exigido: 60)
INSERT INTO alunos (nome, cpf, email, data_nascimento)
SELECT
    'Aluno ' || i,
    LPAD(i::TEXT, 11, '0'),
    'aluno' || i || '@email.com',
    DATE '2000-01-01' + (i * 30)
FROM generate_series(1, 60) AS i;