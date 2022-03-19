ALTER TRIGGER TGR_Busca_Alunos_AI
on dbo.Matricula
after insert
AS
BEGIN
	DECLARE
				@Nota1 decimal (10,2),
				@Nota2 decimal (10,2),
				@Nota_Substitutiva decimal (10,2),
				@Media_Nota decimal (10,2),
				@Falta decimal (10,2),
				@Situacao varchar(20),
				@RA_Aluno varchar(20),
				@Codigo_Disciplina varchar(20),
				@MaxQtdFalta int,
				@Calc_CargaHoraria int
	SELECT @Nota1 = Nota1, @Nota2 = Nota2, @Nota_Substitutiva = Nota_Substitutiva, @Falta = Falta, @RA_Aluno = RA_Aluno, @Codigo_Disciplina = Codigo_Disciplina from inserted

		EXECUTE PROC_Busca_Alunos @Nota1, @Nota2, @Nota_Substitutiva, @Falta, @RA_Aluno, @Codigo_Disciplina

end


GO
CREATE PROCEDURE PROC_Busca_Alunos
@Codigo_Disciplina varchar (20), @RA_Aluno varchar(20), @Nota1 decimal (10,2), @Nota2 decimal (10,2), @Nota_Substitutiva decimal (10,2), @Falta decimal (10,2)
as
begin
		DECLARE
				@Carga_Horaria int,
				@Calc_CargaHoraria decimal (10,2),
				@Media_Nota decimal (10,2),
				@Situacao varchar (20),
				@MaxQtdFalta int
		select @Calc_CargaHoraria = Carga_Horaria from Disciplina where @Codigo_Disciplina = Codigo
		set @MaxQtdFalta = cast(@Carga_Horaria * 0.25 as int)
		print(@MaxQtdFalta)
		set @Media_Nota = (@Nota1 + @Nota2) / 2.00
		IF @Falta > @MaxQtdFalta
				begin
						set @Situacao = 'REPROVADO POR FALTA'
				end
		ELSE
				begin
						if @Media_Nota < 5
								begin
										set @Situacao = 'REPROVADO POR NOTA'
								end
						else
								begin
										set @Situacao = 'APROVADO'
								end
				end
		UPDATE dbo.matricula set Media_Nota = @Media_Nota, Situacao = @Situacao where RA_Aluno = @RA_Aluno

end

GO
CREATE PROCEDURE Proc_Busca_Alunos_Disciplina
@Nome_Disciplina VARCHAR (20),
@Ano int 
as
begin
		SELECT
			Nota1, Nota2, Falta, Situacao, D.Nome, A.Nome 'Aluno'
		FROM
			Matricula
		INNER JOIN disciplina D ON Codigo_Disciplina = D.Codigo
		INNER JOIN aluno A ON RA_Aluno = A.RA
      	WHERE Ano = @Ano AND D.Nome = @Nome_Disciplina   
end