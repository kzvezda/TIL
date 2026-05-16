# INSERT: 테이블에 데이터 삽입 -- insert into 테이블 [(열1, 열2...)] values (값1, 값2...)
use market_db;
create table hongong1 (toy_id int, toy_name char(4), age int);
insert into hongong1 values (1, '우디', 25);

insert into hongong1 (toy_id, toy_name) values (2, '버즈');

# auto_increment: 자동생성 -- primary key(기본키)로 꼭 지정해줘야 함
create table hongong2(
	toy_id int auto_increment primary key,
    toy_name char(4),
    ahe int);
    
insert into hongong2 values(null, '보핍', 25);
insert into hongong2 values(null, '슬링키', 22);
insert into hongong2 values(null, '렉스', 21);
select * from hongong2;

select last_insert_id();  -- 어디까지 입력했는지 확인하기 위함

alter table hongong2 auto_increment=100; -- 100번부터 자동생성하겠다는 뜻
insert into hongong2 values (null, '재남', 35);
select * from hongong2;

create table hongong3 (
	toy_id int auto_increment primary key,
    toy_name char(4),
    age int);
alter table hongong3 auto_increment=1000;
set @@auto_increment_increment=3; -- 3씩 증가

insert into hongong3 values (null, '토마스', 20);
insert into hongong3 values (null, '제임스', 23);
insert into hongong3 values (null, '고든', 22);
select * from hongong3;


select count(*) from world.city;
desc world.city; -- desc: 테이블의 구조를 알려줌
select * from world.city limit 5;

create table city_popul (city_name char(35), population int);
insert into city_popul
	select name, population from world.city;
select * from city_popul


# UPDATE : 기존에 입력되어 있는 값을 수정 
-- update 테이블_이름 set 열1=값1, 열2=값2... where 조건;
use market_db;
update city_popul 
	set city_name = '서울'
    where city_name = 'Seoul'; -- 영문을 한글로 바꾸려는 것
select * from city_popul where city_name='서울';

update city_popul
	set city_name = '뉴욕', population = 0
	where city_name = 'New York'; -- 주의! 만약 where절 안쓰면 모든 값이 바뀜
select * from city_popul where city_name = '뉴욕';


# DELETE : 행 데이터를 삭제 -- delete from 테이블이름 where 조건
delete from city_popul
	where city_name like 'New%';
    
delete from city_popul
	where city_name like 'New%'
    limit 5;
    
