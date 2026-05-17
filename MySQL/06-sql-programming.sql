# 스토어드 프로시저
-- DELIMITER $$
-- CREATE PROCEDURE 스토어드_프로시저_이름()
-- BIGIN 
-- 	  이 부분에 sql 프로그래밍 코딩
-- END $$ 						> 스토어드 프로시저 종료
-- DELIMITER ;  				> 종료문자를 다시 세미콜론으로 변경
-- CALL 스토어드_프로시저_이름();      > 스토어드 프로시저 실행

# IF
-- IF <조건식> THEN
-- 		  sql 문장들
-- END IF;

use market_db;
drop procedure if exists ifProc1; -- 기존에 만든 적이 있다면 삭제
delimiter $$
create procedure ifProc1()
begin
	if 100 = 100 then
		select '100은 100과 같습니다.';
	end if;
end $$
delimiter ;
call ifProc1();

# IF~ELSE
drop procedure if exists ifProc2;
delimiter $$
create procedure ifProc2()
begin
	declare myNum int; -- myNum 변수선언
    set myNum = 200; -- 변수에 값 대입
    if myNum = 100 then
		select '100입니다.';
	else
		select '100이 아닙니다.';
	end if;
end $$
delimiter ;
call ifProc2();

drop procedure if exists ifProc3;
delimiter $$
create procedure ifProc3()
begin
	declare debutDate DATE; -- 데뷔일
    declare curDate DATE; -- 오늘
    declare days int; -- 활동한 일수
    
    select debut_date into debutDate -- debut_date 결과를 debutDate에 대입
		from market_db.member
        where mem_id = 'APN';
	
    set curDATE = current_date(); -- 현재 날짜
    set days = datediff(curDATE, debutDate); -- datediff(): 두 날짜의 차이 알려주는 함수, 일 단위
        
	if (days/365) >= 5 then -- 데뷔한지 5년이 지났다면
		select concat('데뷔한 지 ', days, '일이나 지났습니다. 축하합니다!');
	else 
		select CONCAT('데뷔한 지 ', days, '일밖에 안되었네요. 화이팅!');
	end if;
end $$
delimiter ;
call ifProc3();

# CASE
-- CASE
-- 	 WHEN 조건1 THEN
-- 		SQL문장들1
-- 	 WHEN 조건2 THEN
-- 		SQL문장들2
-- 	 WHEN 조건3 THEN
-- 		SQL문장들3
-- 	 ELSE
-- 		SQL문장들4
-- END CASE;
        
drop procedure if exists caseProc;
delimiter $$
create procedure caseProc()
begin
	declare point int; -- 받은 점수
    declare credit char(1); -- 학점
    set point = 88;
    
    case
		when point >= 90 then
			set credit = 'A';
		when point >= 90 then
			set credit = 'B';
		when point >= 70 then
			set credit = 'C';
		when point >= 60 then
			set credit = 'D';
		else
			set credit = 'F';
	end case;
    select concat('취득점수==>', point), concat('학점==>', credit);
end $$
delimiter ;
call caseProc();


select mem_id, sum(price*amount) "총구매액"
	from buy
    group by mem_id
	order by sum(price*amount) desc;
    
select M.mem_id, M.mem_name, sum(price*amount) "총구매액"
	from buy B
		right outer join member M
        on B.mem_id = M.mem_id
	group by M.mem_id
	order by sum(price*amount) desc;

select M.mem_id, M.mem_name, sum(price*amount) "총구매액",
		case
			when (sum(price*amount) >= 1500) then "최우수고객"
			when (sum(price*amount) >= 1000) then "우수고객"
			when (sum(price*amount) >= 1) then "일반고객"
			else "유령고객"
		end "회원등급"
	from buy B
		right outer join member M
			on B.mem_id = M.mem_id
	group by M.mem_id
	order by sum(price*amount) desc;
    
# WHILE
-- WHILE <조건식> DO
-- 		SQL 문장들
-- END WHILE;
    
drop procedure if exists whileProc;
delimiter $$
create procedure whileProc()
begin
	declare i int; -- 1에서 100까지 증가할 변수
    declare hap int; -- 더한 값을 누적할 변수
    set i = 1;
    set hap = 0;
    
    while (i <= 100) do
		set hap = hap + i;
        set i = i + 1;
	end while;
    
    select '1부터 100까지의 합 ==>', hap;
end $$
delimiter ;
call whileProc();

# ITERATE [레이블]: 지정한 레이블로 가서 계속 진행
# LEAVE [레이블]: 지정한 레이블을 빠져나감. 즉 WHILE문이 종료됨

drop procedure if exists whileProc2;
delimiter $$
create procedure whileProc2()
begin
	declare i int; -- 1에서 100까지 증가할 변수
    declare hap int; -- 더한 값을 누적할 변수
    set i = 1;
    set hap = 0;
    
    myWhile:
    while (i <= 100) do 
		if (i%4 =0) then
			set i = i + 1;
			iterate myWhile; -- 지정한 label문으로 가서 계속 진행
		end if;
		set hap = hap + i;
		if (hap > 1000) then 
			leave myWhile; -- 지정한 label문을 떠남. 즉, While 종료
		end if;
		set i = i + 1;
	end while;
    
    select '1부터 100까지의 합(4의 배수 제외), 1000 넘으면 종료 ==>', hap;
end $$
delimiter ;
call whileProc2();

# PREPARE: SQL문을 실행하지는 않고 미리 준비만 해둠
# EXECURE: 준비된 SQL문을 실행/ 실행 후에는 DEALLOCATE PREPARE로 문장을 해제해주는 것이 바람직

drop table if exists gate_table;
create table gate_table (id int auto_increment primary key, entry_time datetime);

set @curDate = current_timestamp(); -- 현재 날짜와 시간

prepare myQuery from 'insert into gate_table values(NULL, ?)';
execute myQuery using @curDate;
deallocate prepare myQuery;

select * from gate_table;