SELECT a.nome, d.nome as curso, c.carga_horaria_total , p.nome as professor, t.codigo_turma, a.cpf
FROM matriculas m
JOIN alunos a ON a.id_aluno = m.id_aluno
JOIN cursos c ON c.id_curso = a.id_curso
JOIN turmas t ON t.id_turma = m.id_turma
JOIN disciplinas d ON d.id_disciplina = t.id_disciplina
JOIN professores p ON p.id_professor = t.id_professor;