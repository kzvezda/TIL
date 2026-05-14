USE market_db;
SELECT * FROM market_db.member WHERE mem_name = '블랙핑크';
SELECT addr 주소, height 키, debut_date "데뷔 일자" FROM member;
SELECT * FROM member WHERE mem_number > 4;
SELECT mem_name FROM member WHERE height <= 163;
SELECT mem_name 
	FROM member 
    WHERE height = 165 or mem_number > 6;
select mem_name, height
	from member
    where height between 165 and 168
select mem_name, addr
	from member
    where addr in('경기','전남','경남');
select * from member where mem_name like '우%';
select * from member where mem_name like '__핑크';