select a.nome, c.nome as curso, d.nome as diciplina, c.carga_horaria_total from alunos a
join cursos c  on c.id_curso  = a.id_aluno 
join disciplinas d on d.id_disciplina  = c.id_curso
