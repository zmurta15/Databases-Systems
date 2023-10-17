select * from uscensus where id=9000;

explain plan set statement_id='q1' into plan_table for
    select * from uscensus where id=9000;

select * from plan_table;

select count(*) from uscensus;

--Ex1
select * from uscensus where id=9000; --cost 145, depois do index ficou 2
select id from uscensus where id = 1; --cost 145, depois ficou 1
select count(*) from uscensus where id>8000 and id<9000; --cost 145, depois ficou 4

--para ver tempo de execucao
select sql_text, elapsed_time
from V$SQLAREA
where sql_text like 'select count(*) from uscensus where id>8000 and id<9000';

select sum(capitalgain) as gain, sum(capitalloss) as loss, income from uscensus group by income; --cost 149
-- este nao desce porque nao e feito com o id que e a search key do index

--Ex2
alter table uscensus add constraint pk_uscensus primary key (id);

select * from uscensus where id>8000 and id<9000; --usas o index
select * from uscensus where id>8000 or id<9000; -- nao se usa o index porque e mais facil percorrer tudo por causa do OR
select /*+ INDEX (USCENSUS PK_USCENSUS) */ * from uscensus where id>8000 or id<9000; -- forcar o index custa mais que sem index, provavelmente faz mais seeks pois pode estar em zonas diferentes do disco
select /*+ NO_INDEX (USCENSUS PK_USCENSUS) */ * from uscensus where id>8000 and id<9000; --mais lento

--ex3
create index age_uscensus on uscensus (age);
select /*+ INDEX (USCENSUS AGE_USCENSUS) */* from uscensus where age=20;
drop index AGE_USCENSUS;

--EX4
select education, count(education) from uscensus group by education; --so tem 51 tuplos

create index edu_btree on uscensus (education);
analyze index edu_btree compute statistics;
drop index edu_btree;

create index edu_btree on uscensus (education,age);

select avg(age) from uscensus where education = 'Preschool'; --como a cardinality e 2035 e so eistem 51 tuplos nao faz sentido fazer um index, se metermos o age no index ja faz sentido 
select /*+ INDEX (USCENSUS EDU_BTREE) */ avg(age) from uscensus where education = 'Preschool';
select avg(age) from uscensus where fnlwgt=87510;

--ext 5 e 6
drop index edu_btree;
create bitmap index edu_bitmap on uscensus (education);

select count(*) from uscensus where education = 'Preschool';
select /*+ INDEX (USCENSUS EDU_BITMAP) */ count(*) from uscensus where education = 'Preschool';

--EX 7


