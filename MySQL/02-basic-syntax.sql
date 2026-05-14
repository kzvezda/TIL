use market_db;
select mem_id, mem_name, debut_date from member
	order by debut_date;
    
select mem_id, mem_name, debut_date, height
	from member
    where height >= 164
	order by debut_date desc; # desc:오름차순
    #꼭 이런 순사로 적어야함 select - from - where - order by
    
select mem_name, debut_date, height
	from member
    where height >= 164
    order by height desc, debut_date asc;
    
select * from member limit 3;
select mem_name, debut_date
	from member
    order by debut_date
    limit 3;
select mem_name, debut_date
	from member
    order by debut_date
    limit 3,2; # 세번째부터 두개 행만
    
select distinct addr from member;  -- distinct: 중복값 한번만 보여줌

# 순서
-- select 열_이름
-- from 테이블_이름
-- where 조건식
-- group by 열_이름
-- having 조건식
-- order by 열_이름
-- limit 숫자

select mem_id, amount from buy order by mem_id;
select mem_id, sum(amount) from buy group by mem_id;

select mem_id "회원 아이디", sum(amount) "총 구매 개수"
	from buy group by mem_id;
    
select mem_id "회원 아이디", sum(price*amount) "총 구매 금액"
	from buy group by mem_id;
    
select avg(amount) '평균 구매 개수' from buy;

select mem_id, avg(amount) '평균 구매 개수'
	from buy group by mem_id;
    
select count(*) from member; -- count: 행의 개수를 알려줌
select count(phone1) "연락처가 있는 회원" from member;

# group by에서 조건문을 쓰려면 where이 아닌 having을 써야함
select mem_id '회원 아이디', sum(price*amount) '총 구매 금액'
	from buy 
    group by mem_id
    having sum(price*amount) > 1000
    order by sum(price*amount) desc;
    
