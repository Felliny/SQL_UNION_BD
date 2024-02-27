
drop database PalestraFacul

create database PalestraFacul


use PalestraFacul

create table Curso(
                      codigo_curso	int				not null,
                      nome			varchar(70)		not null,
                      sigla			varchar(10)		not null
                          primary key (codigo_curso)
)

create table Aluno(
                      ra				char(7)			not null,
                      nome			varchar(250)	not null,
                      codigo_curso	int				not null
                          primary key (ra)
                          foreign key (codigo_curso) references Curso(codigo_curso)
)

create table Palestrante(
                            codigo_palestrante		int				not null	identity(1, 1),
                            nome					varchar(250)	not null,
                            empresa					varchar(100)	not null
                                primary key (codigo_palestrante)
)

create table Palestra(
                         codigo_palestra			int				not null	identity(1, 1),
                         titulo					varchar(200)	not null,
                         carga_horaria			int				null,
                         dataa					datetime		not null,
                         codigo_palestrante		int				not null
                             primary key	(codigo_palestra)
                             foreign key (codigo_palestrante) references Palestrante(codigo_palestrante)
)

create table Alunos_Inscritos(
                                 ra					char(7)		not null,
                                 codigo_palestra		int			not null
                                     primary key (ra, codigo_palestra)
                                     foreign key (ra) references Aluno(ra),
                                 foreign key (codigo_palestra) references Palestra(codigo_palestra)
)

create table Nao_Aluno(
                          rg			varchar(9)		not null,
                          orgao_exp	char(5)			not null,
                          nome		varchar(250)	not null
                              primary key (rg, orgao_exp)
)

create table Nao_Alunos_Inscritos(
                                     codigo_palestra			int			not null,
                                     rg						varchar(9)	not null,
                                     orgao_exp				char(5)		not null
                                         foreign key (rg, orgao_exp) references Nao_ALuno,
                                     foreign key (codigo_palestra) references Palestra,
                                     primary key (codigo_palestra, rg, orgao_exp)
)


-- Inserir dados na tabela curso
INSERT INTO curso (codigo_curso, nome, sigla)
VALUES
    (1, 'Engenharia Elétrica', 'EE'),
    (2, 'Ciência da Computação', 'CC'),
    (3, 'Administração', 'ADM');
-- Inserir dados na tabela aluno
go
INSERT INTO aluno (ra, nome, codigo_curso)
VALUES
    ('1234567', 'João Silva', 1),
    ('2345678', 'Maria Souza', 2),
    ('3456789', 'Pedro Santos', 1);
-- Inserir dados na tabela nao_alunos
go
INSERT INTO Nao_Aluno (rg, orgao_exp, nome)
VALUES
    ('123456789', 'SSP', 'José Oliveira'),
    ('234567890', 'SSP', 'Ana Pereira');
-- Inserir dados na tabela palestrante
go
INSERT INTO palestrante (nome, empresa)
VALUES
    ('Carlos Oliveira', 'Tech Solutions'),
    ('Ana Santos', 'Data Analysis Co.');
-- Inserir dados na tabela palestra
go
INSERT INTO palestra (titulo, carga_horaria, dataa, codigo_palestrante)
VALUES
    ('Introdução à Inteligência', 2, '2022-02-02 10:00:00', 1),
    ('Gestão de Projetos Ágeis', 1, '2002-03-15 14:00:00', 2);
-- Inserir dados na tabela nao_alunos_inscritos
go
INSERT INTO nao_alunos_inscritos (codigo_palestra, rg, orgao_exp)
VALUES
    (1, '123456789', 'SSP'),
    (2, '234567890', 'SSP');
-- Inserir dados na tabela alunos_inscritos
go
INSERT INTO alunos_inscritos (ra, codigo_palestra)
VALUES
    ('1234567', 1),
    ('2345678', 2);


select *
from Palestrante


-- O problema está no momento de gerar a lista de presença. A lista de presença deverá vir de uma
-- consulta que retorna (Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante,
-- Carga_Horária e Data). A lista deverá ser uma só, por palestra (A condição da consulta é o código
-- da palestra) e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para
-- alunos e RG + Orgao_Exp para não alunos) e estar ordenada pelo Nome_Pessoa

create view lista_presença
as
select p.codigo_palestra,
       a.ra,
       a.nome as Nome_Pessoa,
       p.titulo,
       pa.nome,
       p.dataa
from Aluno a, Palestra p, Palestrante pa, Alunos_Inscritos al
where p.codigo_palestrante = pa.codigo_palestrante
    and a.ra = al.ra and p.codigo_palestra = al.codigo_palestra
union
select p.codigo_palestra,
       n.rg +'-'+ n.orgao_exp,
       n.nome as Nome_Pessoa,
       p.titulo,
       pa.nome,
       p.dataa
from Nao_Aluno n, Palestra p, Palestrante pa, Nao_Alunos_Inscritos na
where p.codigo_palestrante = pa.codigo_palestrante
    and n.rg = na.rg and n.orgao_exp = na.orgao_exp
    and na.codigo_palestra = p.codigo_palestra

select * from lista_presença
order by Nome_Pessoa

