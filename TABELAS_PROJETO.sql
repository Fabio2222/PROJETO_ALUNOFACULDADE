create table Disciplina
(
Codigo varchar(20) not null,
Nome varchar(50) not null,
Carga_Horaria int,

Constraint PK_Disciplina Primary Key (Codigo)
);



create table Aluno
(
RA varchar(20) not null,
Nome varchar(50) not null,

Constraint PK_Aluno Primary Key (RA)
);


create table Matricula
(
Nota1 decimal (10,2),
Nota2 decimal (10,2),
Nota_Substitutiva decimal (10,2),
Media_Nota decimal (10,2),
Falta decimal (10,2),
Ano int,
Semestre int,
Situacao varchar(20) not null,
RA_Aluno varchar(20) not null,
Codigo_Disciplina varchar(20) not null,

Constraint PK_Matricula Primary Key (RA_Aluno, Codigo_Disciplina),

Constraint FK_RA_Aluno_Matricula Foreign Key (RA_Aluno)
References Aluno (RA),
Constraint FK_Codigo_Disciplina_Matricula Foreign Key (Codigo_Disciplina)
References Disciplina (Codigo)
);