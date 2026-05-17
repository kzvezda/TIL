# 조인: 두 테이블을 묶어서 하나의 결과를 만들어 내는 것
# 내부 조인: 두 테이블 연결 시 가장 많이 사용되는 것. 그냥 조인이라고 하면 내부조인을 의미
-- 일대다 관계: 한쪽 테이블에는 하나의 값만 존재, 연결된 다른 테이블에는 여러 개의 값이 존재할 수 있는 관계 
-- > 주로 기본키(PK)와 외래키(FK) 관계

-- SELECT <열 목록>
-- FROM <첫번째 테이블> 
-- INNER JOIN <두번째 테이블> 
-- ON <조인될 조건>
-- [WHERE 검색 조건]

use market_db;
select *
	from buy
		inner join member
        on buy.mem_id = member.mem_id
	where buy.mem_id = 'GRL'; 
    
select buy.mem_id, mem_name, prod_name, addr, concat(phone1, phone2) as '연락처'
	from buy 
		inner join member
        on buy.mem_id = member.mem_id;
        
select B.mem_id, M.mem_name, B.prod_name, M.addr, concat(M.phone1, M.phone2) as '연락처'
	from buy B -- 이런식으로 별명을 지어줄 수 있음
		inner join member M
        on B.mem_id = M.mem_id;
        
# 외부 조인: 두 테이블을 조인할 때 필요한 내용이 한쪽 테이블에만 있어도 결과 추출할 수 있음
-- 내부 조인은 두 테이블에 모두 데이터가 있어야만 결과가 나옴 

-- SELECT <열 목록>
-- FROM <첫번째 테이블(LEFT 테이블)>
-- <LEFT : RIGHT : FULL> OUTER JOIN <두번째 테이블(RIGHT 테이블)>
-- ON <조인될 조건>
-- [WHERE 검색 조건] ;

select M.mem_id, M.mem_name, B.prod_name, M.addr
	from member M
		left outer join buy B -- left :왼쪽 테이블(member 테이블) 값 다 출력한다는 의미
        on M.mem_id = B.mem_id
	order by M.mem_id;
-- 내부조인 때는 구매안한 mem의 값은 안나왔는데 외부조인 때는 전부 출력됨

select M.mem_id, M.mem_name, B.prod_name, M.addr
	from buy B
		right outer join member M
        on M.mem_id = B.mem_id
	order by M.mem_id;

# 상호 조인: 한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인시키는 기능 
-- 랜덤으로 조인하므로 결과의 내용은 의미 없음 
-- 주 용도는 테스트를 위한 대용량의 데이터 생성
-- SELECT * FROM buy CROSS JOIN member;
SELECT * 
	FROM buy
		CROSS JOIN member;

# 자체 조인: 자신이 자신과 조인
-- SELECT <열 목록>
-- FROM <테이블> 별칭A 
-- INNER JOIN <테이블> 별칭B
-- ON <조인될 조건>
-- [WHERE 검색 조건]
