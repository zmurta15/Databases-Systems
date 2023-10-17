select * from borders 
where length>200 and length>300; --o length>300 e redundante

select population from city where name='Lisbon';

select /*+ no_index(city citykey)*/ population from city where name='Lisbon';

--exercise4
select * from is_member m inner join organization o
on m.organization = o.abbreviation;

alter table is_member add constraint FKey foreign key (organization) references organization(abbreviation); --MISTERIO???

--exercise 5
select c.name, o.name from country c 
inner join is_member m on (c.code = m.country)
inner join organization o on (m.organization = o.abbreviation);

--exercise 6
/*+ leading(c m org) --specify join order (t1 t2 t3 ..)
    use_nl(c m) -- us enested loop on tables (t1 t2 ..) equal to use_nl(c) use nl(m)
    use_nl_with_index(c idx) -- use nested llop with index on table index (t1 idx ..)
    no_index() --dont use indexes(t1 idx1 idx2 ...)
    index() --use indexes
    use_merge(c m org) -- merge join on tables (t1 t2 ..)
    use_hash() -- hash join o  tables (t1 t2 ..)
*/

select /*+ leading(c o m) use_nl(o c m) */ c.name, o.name from country c 
inner join is_member m on (c.code = m.country)
inner join organization o on (m.organization = o.abbreviation);

--exercise7 Este podera ser melhor com um merge join
select /*+ use_nl(c1 c2 d)*/ * from
city c1, city c2, distances d
where c1.name = d.city1 and c2.name = d.city2
order by c1.name;

select * from
city c1, city c2, distances d
where c1.name = d.city1 and c2.name = d.city2
order by c1.name;

analyze table distances compute statistics;

--exrercise 10 e 11
alter session enable parallel query; --use paralellization in te session

alter table distances parallel; --allow paralellization on table
alter table distances noparallel; 
alter table table_name parallel 2; --quando se quer identificar o numero de processadores a usar

select * from distances where city1= 'Lisbon' or city2 = 'Lisbon';


