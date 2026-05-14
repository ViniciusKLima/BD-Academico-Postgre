
-- ==========================================
-- CRIAÇÃO DO SCHEMA
-- ==========================================
CREATE SCHEMA banco_escolar AUTHORIZATION postgres;


-- ==========================================
-- TABELA: CURSOS
-- Armazena informações dos cursos da instituição
-- ==========================================
CREATE TABLE banco_escolar.cursos (
	id_curso serial4 NOT NULL, -- ID único do curso
	nome varchar(100) NOT NULL, -- nome do curso
	nivel varchar(50) NULL, -- nível (bacharelado, tecnólogo etc)
	carga_horaria_total int4 NULL, -- carga horária total do curso
	id_departamento int4 NULL, -- departamento responsável
	modalidade varchar(50) NULL, -- presencial ou EAD
	CONSTRAINT cursos_pkey PRIMARY KEY (id_curso)
);


-- ==========================================
-- TABELA: PROFESSORES
-- Armazena dados dos professores
-- ==========================================
CREATE TABLE banco_escolar.professores (
	id_professor serial4 NOT NULL, -- ID do professor
	nome varchar(100) NOT NULL, -- nome
	email varchar(100) NULL, -- email
	titulacao varchar(100) NULL, -- mestre, doutor etc
	id_departamento int4 NULL, -- departamento
	regime_trabalho varchar(50) NULL, -- carga horária de trabalho
	CONSTRAINT professores_email_key UNIQUE (email),
	CONSTRAINT professores_pkey PRIMARY KEY (id_professor)
);


-- ==========================================
-- TABELA: ALUNOS
-- Armazena dados dos alunos
-- ==========================================
CREATE TABLE banco_escolar.alunos (
	id_aluno serial4 NOT NULL, -- ID do aluno
	nome varchar(100) NOT NULL, -- nome completo
	data_nascimento date NULL, -- data de nascimento
	cpf varchar(14) NULL, -- CPF único
	email varchar(100) NULL, -- email único
	telefone varchar(20) NULL, -- telefone
	id_curso int4 NULL, -- curso que o aluno pertence
	data_ingresso date NULL, -- data de entrada
	status varchar(30) NULL, -- ativo, inativo, trancado

	CONSTRAINT alunos_cpf_key UNIQUE (cpf),
	CONSTRAINT alunos_email_key UNIQUE (email),
	CONSTRAINT alunos_pkey PRIMARY KEY (id_aluno),

	-- relacionamento com cursos
	CONSTRAINT alunos_id_curso_fkey FOREIGN KEY (id_curso)
	REFERENCES banco_escolar.cursos(id_curso)
);


-- ==========================================
-- TABELA: DISCIPLINAS
-- Armazena disciplinas dos cursos
-- ==========================================
CREATE TABLE banco_escolar.disciplinas (
	id_disciplina serial4 NOT NULL, -- ID disciplina
	codigo varchar(20) NOT NULL, -- código da disciplina
	nome varchar(100) NOT NULL, -- nome
	carga_horaria int4 NULL, -- carga horária
	id_curso int4 NULL, -- curso relacionado
	id_departamento int4 NULL, -- departamento
	creditos int4 NULL, -- créditos da disciplina

	CONSTRAINT disciplinas_codigo_key UNIQUE (codigo),
	CONSTRAINT disciplinas_pkey PRIMARY KEY (id_disciplina),

	-- relacionamento com cursos
	CONSTRAINT disciplinas_id_curso_fkey FOREIGN KEY (id_curso)
	REFERENCES banco_escolar.cursos(id_curso)
);


-- ==========================================
-- TABELA: TURMAS
-- Representa turmas de disciplinas com professor
-- ==========================================
CREATE TABLE banco_escolar.turmas (
	id_turma serial4 NOT NULL, -- ID da turma
	id_disciplina int4 NULL, -- disciplina
	id_professor int4 NULL, -- professor responsável
	id_periodo_letivo int4 NULL, -- período/semestre
	id_sala int4 NULL, -- sala
	codigo_turma varchar(20) NOT NULL, -- código da turma
	vagas int4 NULL, -- quantidade de vagas

	CONSTRAINT turmas_codigo_turma_key UNIQUE (codigo_turma),
	CONSTRAINT turmas_pkey PRIMARY KEY (id_turma),

	-- relacionamento com disciplina
	CONSTRAINT turmas_id_disciplina_fkey FOREIGN KEY (id_disciplina)
	REFERENCES banco_escolar.disciplinas(id_disciplina),

	-- relacionamento com professor
	CONSTRAINT turmas_id_professor_fkey FOREIGN KEY (id_professor)
	REFERENCES banco_escolar.professores(id_professor)
);


-- ==========================================
-- TABELA: MATRÍCULAS
-- Relaciona alunos com turmas
-- ==========================================
CREATE TABLE banco_escolar.matriculas (
	id_matricula serial4 NOT NULL, -- ID matrícula
	id_aluno int4 NULL, -- aluno
	id_turma int4 NULL, -- turma
	data_matricula date NULL, -- data da matrícula
	situacao varchar(30) NULL, -- status da matrícula
	nota_final numeric(5, 2) NULL, -- nota final
	frequencia int4 NULL, -- frequência

	CONSTRAINT matriculas_pkey PRIMARY KEY (id_matricula),

	-- relacionamento com aluno
	CONSTRAINT matriculas_id_aluno_fkey FOREIGN KEY (id_aluno)
	REFERENCES banco_escolar.alunos(id_aluno),

	-- relacionamento com turma
	CONSTRAINT matriculas_id_turma_fkey FOREIGN KEY (id_turma)
	REFERENCES banco_escolar.turmas(id_turma)
);

-- ==========================================
-- INSERÇÃO DE DADOS
-- Schema: banco_escolar
-- ==========================================

-- ==========================================
-- CURSOS (3 registros)
-- ==========================================
INSERT INTO banco_escolar.cursos
(nome, nivel, carga_horaria_total, id_departamento, modalidade)
VALUES
('Ciência da Computação', 'Bacharelado', 3200, 1, 'Presencial'),
('Análise e Desenvolvimento de Sistemas', 'Tecnólogo', 2400, 1, 'Presencial'),
('Sistemas de Informação', 'Bacharelado', 3000, 1, 'Presencial');

-- ==========================================
-- PROFESSORES (5 registros)
-- ==========================================
INSERT INTO banco_escolar.professores
(nome, email, titulacao, id_departamento, regime_trabalho)
VALUES
('João Silva', 'joao.silva@faculdade.edu.br', 'Mestre', 1, 'Dedicação Exclusiva'),
('Maria Oliveira', 'maria.oliveira@faculdade.edu.br', 'Doutora', 1, 'Dedicação Exclusiva'),
('Carlos Souza', 'carlos.souza@faculdade.edu.br', 'Mestre', 1, '40 Horas'),
('Ana Costa', 'ana.costa@faculdade.edu.br', 'Doutora', 1, '20 Horas'),
('Pedro Santos', 'pedro.santos@faculdade.edu.br', 'Especialista', 1, '40 Horas');

-- ==========================================
-- ALUNOS (60 registros automáticos)
-- ==========================================
INSERT INTO banco_escolar.alunos
(nome, data_nascimento, cpf, email, telefone, id_curso, data_ingresso, status)
VALUES
('Mariana Souza Lima', '2001-07-22', '222.333.444-56', 'mariana.lima@gmail.com', '81990010002', 2, '2024-02-01', 'Ativo'),
('Lucas Ferreira Nascimento', '2002-03-14', '111.222.333-45', 'lucas.nascimento@gmail.com', '81990010001', 1, '2024-02-01', 'Ativo'),
('Rafael Henrique Alves', '2003-01-09', '333.444.555-67', 'rafael.alves@gmail.com', '81990010003', 3, '2024-02-01', 'Inativo'),
('Beatriz Oliveira Santos', '2002-10-30', '444.555.666-78', 'beatriz.santos@gmail.com', '81990010004', 1, '2024-02-01', 'Ativo'),
('Gustavo Pereira Costa', '2001-05-18', '555.666.777-89', 'gustavo.costa@gmail.com', '81990010005', 2, '2024-02-01', 'Trancado'),
('Camila Rocha Lima', '2003-09-12', '666.777.888-90', 'camila.lima@gmail.com', '81990010006', 3, '2024-02-01', 'Ativo'),
('André Santos Silva', '2002-12-01', '777.888.999-01', 'andre.silva@gmail.com', '81990010007', 1, '2024-02-01', 'Ativo'),
('Juliana Almeida Costa', '2001-02-27', '888.999.000-12', 'juliana.costa@gmail.com', '81990010008', 2, '2024-02-01', 'Inativo'),
('Pedro Lucas Ribeiro', '2003-06-15', '999.000.111-23', 'pedro.ribeiro@gmail.com', '81990010009', 3, '2024-02-01', 'Ativo'),
('Larissa Mendes Souza', '2002-08-19', '000.111.222-34', 'larissa.souza@gmail.com', '81990010010', 1, '2024-02-01', 'Ativo'),

('Bruno Henrique Lima', '2001-04-11', '101.202.303-45', 'bruno.lima@gmail.com', '81990010011', 2, '2024-02-01', 'Ativo'),
('Fernanda Carvalho Santos', '2003-07-08', '202.303.404-56', 'fernanda.santos@gmail.com', '81990010012', 3, '2024-02-01', 'Trancado'),
('Diego Martins Oliveira', '2002-11-23', '303.404.505-67', 'diego.oliveira@gmail.com', '81990010013', 1, '2024-02-01', 'Ativo'),
('Patrícia Lima Ribeiro', '2001-09-05', '404.505.606-78', 'patricia.ribeiro@gmail.com', '81990010014', 2, '2024-02-01', 'Ativo'),
('Felipe Augusto Souza', '2003-12-20', '505.606.707-89', 'felipe.souza@gmail.com', '81990010015', 3, '2024-02-01', 'Inativo'),
('Amanda Rocha Costa', '2002-01-16', '606.707.808-90', 'amanda.costa@gmail.com', '81990010016', 1, '2024-02-01', 'Ativo'),
('Thiago Ferreira Lima', '2001-06-09', '707.808.909-01', 'thiago.lima@gmail.com', '81990010017', 2, '2024-02-01', 'Ativo'),
('Sabrina Alves Santos', '2003-10-03', '808.909.010-12', 'sabrina.santos@gmail.com', '81990010018', 3, '2024-02-01', 'Ativo'),
('Vinícius Cardoso Silva', '2002-05-25', '909.010.121-23', 'vinicius.silva@gmail.com', '81990010019', 1, '2024-02-01', 'Trancado'),
('Isadora Mendes Lima', '2001-03-02', '010.121.232-34', 'isadora.lima@gmail.com', '81990010020', 2, '2024-02-01', 'Ativo'),

('João Pedro Alves', '2003-07-25', '012.345.678-90', 'joao.alves@gmail.com', '81990010021', 1, '2024-02-01', 'Ativo'),
('Ana Clara Souza', '2003-04-12', '123.456.789-01', 'ana.souza@gmail.com', '81990010022', 2, '2024-02-01', 'Ativo'),
('Carla Mendes Oliveira', '2001-11-05', '345.678.901-23', 'carla.oliveira@gmail.com', '81990010023', 3, '2024-02-01', 'Ativo'),
('Daniel Rocha Santos', '2003-01-17', '456.789.012-34', 'daniel.rocha@gmail.com', '81990010024', 1, '2024-02-01', 'Inativo'),
('Eduarda Almeida Costa', '2002-06-30', '567.890.123-45', 'eduarda.costa@gmail.com', '81990010025', 2, '2024-02-01', 'Ativo'),
('Felipe Nascimento Silva', '2001-03-22', '678.901.234-56', 'felipe.silva@gmail.com', '81990010026', 3, '2024-02-01', 'Ativo'),
('Gabriela Ferreira Lima', '2003-08-14', '789.012.345-67', 'gabriela.lima@gmail.com', '81990010027', 1, '2024-02-01', 'Ativo'),
('Henrique Barros Souza', '2002-12-09', '890.123.456-78', 'henrique.souza@gmail.com', '81990010028', 2, '2024-02-01', 'Inativo'),
('Isabela Martins Costa', '2001-05-18', '901.234.567-89', 'isabela.costa@gmail.com', '81990010029', 3, '2024-02-01', 'Ativo'),
('Larissa Gomes Ribeiro', '2002-02-14', '111.222.333-44', 'larissa.ribeiro@gmail.com', '81990010030', 1, '2024-02-01', 'Ativo'),

('Matheus Andrade Lima', '2001-10-30', '222.333.444-55', 'matheus.lima@gmail.com', '81990010031', 2, '2024-02-01', 'Trancado'),
('Nathalia Costa Pereira', '2003-06-11', '333.444.555-66', 'nathalia.pereira@gmail.com', '81990010032', 3, '2024-02-01', 'Ativo'),
('Otávio Henrique Silva', '2002-08-19', '444.555.666-77', 'otavio.silva@gmail.com', '81990010033', 1, '2024-02-01', 'Ativo'),
('Paula Fernanda Souza', '2001-12-05', '555.666.777-88', 'paula.souza@gmail.com', '81990010034', 2, '2024-02-01', 'Inativo'),
('Rafael Martins Almeida', '2003-03-27', '666.777.888-99', 'rafael.almeida@gmail.com', '81990010035', 3, '2024-02-01', 'Ativo'),
('Sofia Azevedo Lima', '2002-05-09', '777.888.999-00', 'sofia.lima@gmail.com', '81990010036', 1, '2024-02-01', 'Ativo'),
('Thiago Rocha Santos', '2001-07-16', '888.999.000-11', 'thiago.santos@gmail.com', '81990010037', 2, '2024-02-01', 'Ativo'),
('Valentina Carvalho Souza', '2003-09-23', '999.000.111-22', 'valentina.souza@gmail.com', '81990010038', 3, '2024-02-01', 'Trancado'),
('William Ferreira Costa', '2002-11-02', '000.111.222-33', 'william.costa@gmail.com', '81990010039', 1, '2024-02-01', 'Ativo'),
('Amanda Lopes Ribeiro', '2001-01-15', '101.202.303-14', 'amanda.ribeiro@gmail.com', '81990010040', 2, '2024-02-01', 'Ativo'),

('Brenda Souza Lima', '2003-04-18', '202.303.404-25', 'brenda.lima@gmail.com', '81990010041', 3, '2024-02-01', 'Ativo'),
('Caio Henrique Santos', '2002-07-21', '303.404.505-36', 'caio.santos@gmail.com', '81990010042', 1, '2024-02-01', 'Inativo'),
('Davi Oliveira Costa', '2001-09-10', '404.505.606-47', 'davi.costa@gmail.com', '81990010043', 2, '2024-02-01', 'Ativo'),
('Emanuele Rocha Lima', '2003-12-12', '505.606.707-58', 'emanuele.lima@gmail.com', '81990010044', 3, '2024-02-01', 'Ativo'),
('Fernando Almeida Silva', '2002-03-03', '606.707.808-69', 'fernando.silva@gmail.com', '81990010045', 1, '2024-02-01', 'Ativo'),
('Giovana Martins Souza', '2001-06-06', '707.808.909-70', 'giovana.souza@gmail.com', '81990010046', 2, '2024-02-01', 'Trancado'),
('Hugo Pereira Lima', '2003-08-08', '808.909.010-81', 'hugo.lima@gmail.com', '81990010047', 3, '2024-02-01', 'Ativo'),
('Isis Ferreira Costa', '2002-10-10', '909.010.111-92', 'isis.costa@gmail.com', '81990010048', 1, '2024-02-01', 'Ativo'),
('Joana Ribeiro Souza', '2001-11-11', '010.121.232-03', 'joana.souza@gmail.com', '81990010049', 2, '2024-02-01', 'Inativo'),
('Kevin Silva Andrade', '2003-02-02', '121.232.343-15', 'kevin.andrade@gmail.com', '81990010050', 3, '2024-02-01', 'Ativo'),

('Letícia Costa Lima', '2002-04-04', '232.343.454-26', 'leticia.lima@gmail.com', '81990010051', 1, '2024-02-01', 'Ativo'),
('Marcos Vinícius Souza', '2001-05-05', '343.454.565-37', 'marcos.souza@gmail.com', '81990010052', 2, '2024-02-01', 'Trancado'),
('Nicole Almeida Ribeiro', '2003-06-06', '454.565.676-48', 'nicole.ribeiro@gmail.com', '81990010053', 3, '2024-02-01', 'Ativo'),
('Olivia Santos Lima', '2002-07-07', '565.676.787-59', 'olivia.lima@gmail.com', '81990010054', 1, '2024-02-01', 'Ativo'),
('Pedro Henrique Costa', '2001-08-08', '676.787.898-60', 'pedro.costa@gmail.com', '81990010055', 2, '2024-02-01', 'Inativo'),
('Quésia Ferreira Souza', '2003-09-09', '787.898.909-71', 'quesia.souza@gmail.com', '81990010056', 3, '2024-02-01', 'Ativo'),
('Rennan Oliveira Lima', '2002-10-10', '898.909.010-82', 'rennan.lima@gmail.com', '81990010057', 1, '2024-02-01', 'Ativo'),
('Sara Martins Costa', '2001-11-11', '909.010.121-93', 'sara.costa@gmail.com', '81990010058', 2, '2024-02-01', 'Trancado'),
('Tiago Ribeiro Silva', '2003-12-12', '010.121.232-04', 'tiago.silva@gmail.com', '81990010059', 3, '2024-02-01', 'Ativo'),
('Gabriela Sousa Melo', '2002-06-25', '321.654.987-10', 'gabriela.melo@gmail.com', '81990010060', 1, '2024-02-01', 'Ativo');

-- ==========================================
-- DISCIPLINAS (8 registros)
-- ==========================================
INSERT INTO banco_escolar.disciplinas
(codigo, nome, carga_horaria, id_curso, id_departamento, creditos)
VALUES
('BD001', 'Banco de Dados', 80, 1, 1, 4),
('POO001', 'Programação Orientada a Objetos', 80, 1, 1, 4),
('WEB001', 'Desenvolvimento Web', 60, 1, 1, 3),
('ALG001', 'Algoritmos', 80, 1, 1, 4),
('RED001', 'Redes de Computadores', 60, 1, 1, 3),
('ENG001', 'Engenharia de Software', 80, 1, 1, 4),
('EST001', 'Estruturas de Dados', 80, 1, 1, 4),
('SO001', 'Sistemas Operacionais', 60, 1, 1, 3);

-- ==========================================
-- TURMAS (4 registros)
-- ==========================================
INSERT INTO banco_escolar.turmas
(id_disciplina, id_professor, id_periodo_letivo, id_sala, codigo_turma, vagas)
VALUES
(1, 1, 1, 101, 'BD-2026-1A', 40),
(2, 2, 1, 102, 'POO-2026-1A', 40),
(3, 3, 1, 103, 'WEB-2026-1A', 40),
(4, 4, 1, 104, 'ALG-2026-1A', 40);

-- ==========================================
-- MATRÍCULAS (60 registros automáticos)
-- ==========================================
INSERT INTO banco_escolar.matriculas
(id_aluno, id_turma, data_matricula, situacao, nota_final, frequencia)
SELECT
    i,
    ((i - 1) % 4) + 1,              -- distribui entre as 4 turmas
    DATE '2026-02-10',
    'Ativa',
    ROUND((6 + random() * 4)::numeric, 2), -- notas entre 6.00 e 10.00
    75 + (random() * 25)::int              -- frequência entre 75 e 100
FROM generate_series(1, 60) AS i;


-- ==========================================
-- UPDATE (ATUALIZAÇÃO DE DADOS)
-- ==========================================

-- 1. Atualizar email de um aluno
UPDATE banco_escolar.alunos
SET email = 'novo.email.aluno@gmail.com'
WHERE id_aluno = 1;

-- 2. Atualizar status de matrícula
UPDATE banco_escolar.matriculas
SET situacao = 'Concluída'
WHERE id_matricula = 1;

-- 3. Trocar professor de uma turma
UPDATE banco_escolar.turmas
SET id_professor = 2
WHERE id_turma = 1;


-- ==========================================
-- DELETE (EXCLUSÃO DE DADOS)
-- ==========================================

-- 1. Excluir uma matrícula específica
DELETE FROM banco_escolar.matriculas
WHERE id_matricula = 2;

-- 2. Excluir uma turma sem vínculo (exemplo seguro)
DELETE FROM banco_escolar.turmas
WHERE id_turma = 4;


-- ==========================================
-- CONSULTAS SELECT (SIMPLES)
-- ==========================================

-- Lista todos os registros da tabela alunos
SELECT * FROM banco_escolar.alunos;

-- Lista apenas os nomes das disciplinas, ordenados em ordem alfabética
SELECT nome FROM banco_escolar.disciplinas
ORDER BY nome;

-- Lista apenas os alunos com status "Ativo"
SELECT * FROM banco_escolar.alunos
WHERE status = 'Ativo';


-- ==========================================
-- JOIN (CONSULTAS COM MÚLTIPLAS TABELAS)
-- ==========================================

-- aluno + disciplina + professor + semestre
SELECT a.nome, d.nome, p.nome, t.codigo_turma
FROM banco_escolar.matriculas m
JOIN banco_escolar.alunos a ON a.id_aluno = m.id_aluno
JOIN banco_escolar.turmas t ON t.id_turma = m.id_turma
JOIN banco_escolar.disciplinas d ON d.id_disciplina = t.id_disciplina
JOIN banco_escolar.professores p ON p.id_professor = t.id_professor;

-- alunos por turma
SELECT t.codigo_turma, COUNT(m.id_aluno)
FROM banco_escolar.turmas t
JOIN banco_escolar.matriculas m ON m.id_turma = t.id_turma
GROUP BY t.codigo_turma;

-- cursos e disciplinas
SELECT c.nome, d.nome
FROM banco_escolar.cursos c
JOIN banco_escolar.disciplinas d ON d.id_curso = c.id_curso;