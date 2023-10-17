set serveroutput on;

CREATE OR REPLACE PROCEDURE helloworld
IS
/*variables*/
BEGIN
    /*executed sql queries and logics*/
    dbms_output.put_line('Hello World');
END;

exec helloworld;


CREATE OR REPLACE PROCEDURE enroll_student(student alunos.nome%TYPE, subject cadeiras.nome%TYPE)
IS
    n_student alunos.num_aluno%TYPE;
    cod_program alunos.cod_curso%TYPE;
    cod_subject cadeiras.cod_cadeira%TYPE;
BEGIN
    select num_aluno, cod_curso into n_student, cod_program from alunos where nome = student;
    select cod_cadeira into cod_subject from cadeiras where nome = subject;

    INSERT INTO INSCRICOES VALUES(n_student, cod_program, cod_subject, current_date, null, null);
END;

exec enroll_student('Joaquim Pires Lopes', 'Bases de Dados');


CREATE OR REPLACE PROCEDURE new_student(name alunos.nome%TYPE, gender alunos.sexo%TYPE, programme cursos.nome%TYPE)
IS
    codigo_curso cursos.cod_curso%TYPE;
    /*talvez meter local e data_nsc*/
BEGIN
    SELECT cod_curso into codigo_curso from cursos where nome = programme;
    INSERT INTO alunos VALUES(SEQ_ALUNO.nextval, name, null, null, gender, codigo_curso);
END;

create or replace procedure test_cursor
Is
cursor cur_aluno is select * from alunos;
v_aluno alunos%ROWTYPE; /*variavel do tipo alunos*/
begin
    open cur_aluno;
    loop
        fetch cur_aluno into v_aluno;
        exit when cur_aluno%NOTFOUND;
        dbms_output.put_line(v_aluno.num_aluno || ' ' || v_aluno.nome);
    end loop;
    close cur_aluno;
end;


exec test_cursor;

create or replace procedure exercise3
IS
cursor cur_result is select alunos.nome nome_aluno, cadeiras.nome nome_cadeira
                from alunos
                inner join inscricoes on alunos.num_aluno = inscricoes.num_aluno
                inner join cadeiras on cadeiras.cod_cadeira = inscricoes.cod_cadeira;
v_result cur_result%ROWTYPE;
BEGIN
    FOR v IN cur_result LOOP
    dbms_output.put_line(v.nome_aluno || ' ' || v.nome_cadeira);
    END LOOP;
END;

exec exercise3;


create or replace procedure exercise31
IS
cursor cur_result is select alunos.nome nome_aluno, cursos.nome nome_curso, alunos.sexo sexo
                from alunos
                inner join cursos on alunos.cod_curso = cursos.cod_curso;
v_result cur_result%ROWTYPE;
BEGIN
    FOR v IN cur_result LOOP
    IF v.sexo = 'F' then dbms_output.put_line(v.nome_aluno || ' está inscrita em ' || v.nome_curso);
    ELSE  dbms_output.put_line(v.nome_aluno || ' está inscrito em ' || v.nome_curso);
    END IF;
    END LOOP;
END;

set serveroutput on;

exec exercise31;

create or replace procedure exercise41
IS
cursor cur_aluno(sx alunos.sexo%type) is select * from alunos where sx = sexo;
v_aluno cur_aluno%ROWTYPE;
BEGIN
    open cur_aluno('M');
    loop
        fetch cur_aluno into v_aluno;
        exit when cur_aluno%NOTFOUND;
        dbms_output.put_line(v_aluno.num_aluno || ' ' || v_aluno.nome);
    end loop;
END;

set serveroutput on;

exec exercise41;

create or replace procedure exercise42
IS
cursor cur_aluno(N alunos.num_aluno%TYPE)
