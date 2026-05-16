use market_db;
create table hongong4 (
	tinyint_col tinyint,
    smallint_col smallint,
    int_col int,
    bigint_col bigint);
    
insert into hongong4 values (127, 32767, 1234567890, 9000000000000000000);

# TIHYINT UNSIGNED 
-- tinyint는 원래 범위가 -128~127인데 unsigned를 써주면 범위가 0부터 시작하여 0~255

# 문자형
-- CHAR: 고정길이 문자형, 최대 255자까지/ VARCHAR보다 속도 빠름 - 글자의 개수가 고정된 경우 사용하기 좋음
-- VARCHAR: 가변길이 문자형, 최대 16383자까지/ CHAR보다 공간 효율적으로 운영 가능 - 글자의 개수가 변동될 경우 사용하기 좋음

-- > 숫자로서 의미를 가지려면 더하기/빼기 등의 연산 or 크다/작다/순서에 의미가 있어야 함
-- > but, 전화번호 같은 경우는 이런 숫자로서 의미가 없기 때문에 CHAR로 지정한 것

-- TEXT, BLOB: 최대 65535자까지
-- LONGTEXT, LONGBLOB: 최대 약 42억자까지 
-- > 소설이나 영화 대본 같은 내용 저장시 필요한 형식
create database netflix_db;
use netflix_db;
create table movie
	(movie_id int,
    movie_title varchar(30),
    movie_director varchar(20),
    movie_star varchar(20),
    movie_script longtext,
    movie_film longblob
    )

# 실수형 
-- FLOAT: 소수점 아래 7자리까지
-- DOUBLE: 소수점 아래 15자리까지
    
# 날짜형
-- DATE: 날짜만 저장/ YYYY-MM-DD
-- TIME: 시간만 저장/ HH:MM:SS
-- DATETIME: 날짜 및 시간 저장/ YYYY-MM-DD HH:MM:SS

# 변수 
-- SET @변수이름 = 변수의 값 ; - 변수의 선언 및 값 대입
-- SELECT @변수이름 ; - 변수의 값 출력
-- > 변수는 현재만 사용하는 임시 값(영구저장 X)
set @myVar1 = 5 ;
set @myVar2 = 4.25 ;
select @myVar1 ;
select @myVar1 + @myVar2 ;

set @txt = '가수 이름==> ';
set @height = 166;
select @txt, mem_name from member where height > @height;

use market_db;
set @count = 3;
prepare mySQL from 'SELECT mem_name, height FROM member ORDER BY height LIMIT ?';
execute mySQL using @count;

# 데이터 형 변화
-- CAST (값 AS 데이터_형식 [(길이)])
-- CONVERT (값, 데이터_형식 [(길이)])
select avg(price) '평균 가격' from buy;
select cast(avg(price) as signed) '평균 가격' -- signed: signed int라는 뜻으로 부호가 있는 정수형
	from buy; 
-- or
select convert(avg(price), signed) '평균 가격' from buy;

select cast('2026$04$26' as date); -- 문자를 날짜로 바꿔줌

select num, concat(cast(price as char), 'X', cast(amount as char), '=') '가격X수량',
    price * amount '구매액' -- concat: 여러 개의 문자열을 하나로 합칠 때 사용
    from buy;
    
select '100' + '200'; -- 문자와 문자를 더함(정수로 변환되어 연산됨)
select concat('100','200'); -- 문자와 문자를 연결(문자로 처리됨)
select concat(100, '200'); -- 정수와 문자를 연결(정수가 문자로 변환됨)
   

