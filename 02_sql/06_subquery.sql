
/* **************************************************************************
서브쿼리(Sub Query)
- 쿼리안에서 select 쿼리를 사용하는 것.
- 메인 쿼리 - 서브쿼리

서브쿼리가 사용되는 구
 - select절, from절, where절, having절

서브쿼리의 종류
- 어느 구절에 사용되었는지에 따른 구분
    - 스칼라 서브쿼리 - select 절에 사용. 반드시 서브쿼리 결과가 1행 1열(값 하나-스칼라) 0행이 조회되면 null을 반환
    - 인라인 뷰 - from 절에 사용되어 테이블의 역할을 한다.
- 서브쿼리 조회결과 행수에 따른 구분
    - 단일행 서브쿼리 - 서브쿼리의 조회결과 행이 한행인 것.
    - 다중행 서브쿼리 - 서브쿼리의 조회결과 행이 여러행인 것.
- 동작 방식에 따른 구분
    - 비상관 서브쿼리 - 서브쿼리에 메인쿼리의 컬럼이 사용되지 않는다.
                메인쿼리에 사용할 값을 서브쿼리가 제공하는 역할을 한다.
    - 상관 서브쿼리 - 서브쿼리에서 메인쿼리의 컬럼을 사용한다. 
                            메인쿼리가 먼저 수행되어 읽혀진 데이터를 서브쿼리에서 조건이 맞는지 확인하고자 할때 주로 사용한다.

- 서브쿼리는 반드시 ( ) 로 묶어줘야 한다.
************************************************************************** */
-- 직원_ID(emp.emp_id)가 120번인 직원과 같은 업무(emp.job_id)를 하는 직원의 id(emp_id),이름(emp.emp_name), 업무(emp.job_id), 급여(emp.salary) 조회
SELECT emp_id, emp_name, job_id, salary
	FROM emp
    WHERE job_id = (SELECT job_id FROM emp WHERE emp_id = 120);

-- 직원_id(emp.emp_id)가 115번인 직원과 같은 업무(emp.job_id)를 하고 같은 부서(emp.dept_id)에 속한 직원들을 조회하시오.
-- 서브쿼리에 두 개의 컬럼으로 묶을 수 있음
SELECT emp_id, job_id, dept_id FROM EMP WHERE (job_id, dept_id) = (SELECT job_id, dept_id FROM emp WHERE emp_id=115);

SELECT emp_id, job_id, dept_id FROM EMP WHERE job_id = 'PU_MAN';

-- 직원의 ID(emp.emp_id)가 150인 직원과 업무(emp.job_id)와 상사(emp.mgr_id)가 같은 직원들의 
-- id(emp.emp_id), 이름(emp.emp_name), 업무(emp.job_id), 상사(emp.mgr_id) 를 조회
SELECT e.emp_id, e.emp_name, e.job_id, e.mgr_id
	FROM emp e
    WHERE (e.job_id,e.mgr_id) = 
		(SELECT job_id, mgr_id FROM emp WHERE emp_id=150);
    


-- 직원들 중 급여(emp.salary)가 전체 직원의 평균 급여보다 적은 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 조회. 
SELECT avg(salary) FROM emp;
SELECT emp_id, emp_name, salary
	FROM emp
    WHERE salary < (SELECT avg(salary) FROM emp);

-- 개어렵
-- 부서직원들의 평균이 전체 직원의 평균(emp.salary) 이상인 부서의 이름(dept.dept_name), 평균 급여(emp.salary) 조회.
-- 평균급여는 소숫점 2자리까지 나오고 통화표시($)와 단위 구분자 출력
SELECT d.dept_name "부서 이름",  avg(salary) "평균 급여"
	FROM emp e
    JOIN dept d ON e.dept_id = d.dept_id
    GROUP BY d.dept_id, d.dept_name
    HAVING avg(salary) > (select avg(salary) from emp)
    ORDER BY 2 desc;

-- FROM 안에 서브쿼리문에서 alias 명에 띄어쓰기를 하면, 밖에 컬럼명에서 띄어쓰기한 컬럼을 인식하지 못한다.    
SELECT dept_name, concat('$',format(평균급여,2)) "평균급여"
	FROM
    (
		SELECT d.dept_name,  avg(salary) "평균급여"
		FROM emp e
		JOIN dept d ON e.dept_id = d.dept_id
		GROUP BY d.dept_id, d.dept_name
		HAVING avg(salary) > (select avg(salary) from emp)
		ORDER BY 2 desc
    ) tb;
    
-- 에러코드
SELECT dept_name, concat('$',format(평균 급여,2)) "평균급여"
	FROM
    (
		SELECT d.dept_name,  avg(salary) "평균 급여"
		FROM emp e
		JOIN dept d ON e.dept_id = d.dept_id
		GROUP BY d.dept_id, d.dept_name
		HAVING avg(salary) > (select avg(salary) from emp)
		ORDER BY 2 desc
    ) tb;


--  급여(emp.salary)가장 많이 받는 직원이 속한 부서의 이름(dept.dept_name), 위치(dept.loc)를 조회.
SELECT dept_id, dept_name, dept.loc
	FROM dept
    WHERE dept_id = (SELECT dept_id FROM emp WHERE salary = (SELECT MAX(salary) FROM emp));


-- Sales 부서(dept.dept_name) 의 평균 급여(emp.salary)보다 급여가 많은 직원들의 모든 정보를 조회.

-- Sales 부서의 평균 급여
SELECT avg(salary)
	FROM emp
    WHERE dept_id = (SELECT dept_id FROM dept WHERE dept_name = 'Sales');

-- 위 값을 WHERE절에 서브쿼리로 사용
SELECT * 
	FROM emp
    WHERE salary > 
		(SELECT avg(salary)
			FROM emp
			WHERE dept_id = 
            (SELECT dept_id 
				FROM dept 
                WHERE dept_name = 'Sales'
			)
		);

-- 전체 직원들 중 담당 업무 ID(emp.job_id) 가 'ST_CLERK'인 직원들의 평균 급여보다 적은 급여를 받는 직원들의 모든 정보를 조회. 
-- 단 업무 ID가 'ST_CLERK'이 아닌 직원들만 조회. 
SELECT avg(salary) FROM emp WHERE job_id = 'ST_CLERK';


SELECT * 
	FROM emp
    WHERE salary < (SELECT avg(salary) FROM emp WHERE job_id = 'ST_CLERK')
		AND (job_id != 'ST_CLERK' or job_id IS NULL) -- job_id != 'ST_CLERK'로 하면 jod_id가 NULL인 애들도 제외됨.
    ORDER BY salary desc;

-- 업무(emp.job_id)가 'IT_PROG' 인 직원들 중 가장 많은 급여를 받는 직원보다 더 많은 급여를 받는 
-- 직원들의 id(emp.emp_id), 이름(emp.emp_name), 급여(emp.salary)를 급여 내림차순으로 조회.
SELECT max(salary) FROM emp WHERE job_id = 'IT_PROG';
SELECT emp_id, emp_name, salary
	FROM emp
    WHERE salary > (SELECT max(salary) FROM emp WHERE job_id = 'IT_PROG')
    ORDER BY salary DESC;

/* ----------------------------------------------
 다중행 서브쿼리
 - 서브쿼리의 조회 결과가 여러행인 경우
 - where절 에서의 연산자
	- in
	- 비교연산자 any : 조회된 값들 중 하나만 참이면 참 (where 컬럼 > any(서브쿼리) )
	- 비교연산자 all : 조회된 값들 모두와 참이면 참 (where 컬럼 > all(서브쿼리) )
------------------------------------------------*/
-- 'Alexander' 란 이름(emp.emp_name)을 가진 관리자(emp.mgr_id)의 부하 직원들의 ID(emp_id), 이름(emp_name), 업무(job_id), 입사년도(hire_date-년도만출력), 급여(salary)를 조회
SELECT * 
	FROM emp
    WHERE mgr_id IN
		(SELECT emp_id FROM emp where emp_name = 'Alexander');
    
SELECT * FROM emp where emp_name = 'Alexander';

--  부서 위치(dept.loc) 가 'New York'인 부서에 소속된 직원의 ID(emp.emp_id), 이름(emp.emp_name), 부서_id(emp.dept_id) 를 sub query를 이용해 조회.
SELECT * FROM dept where loc = 'New York';

SELECT * FROM emp WHERE dept_id in (SELECT dept_id FROM dept where loc = 'New York');
-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 보다 급여(emp.salary)를 많이 받는 직원의 모든 정보를 조회.
select salary from emp where emp_id in (101,102,103);

SELECT * FROM emp WHERE salary > ALL(select salary from emp where emp_id in (101,102,103));
SELECT * FROM emp WHERE salary > (select max(salary) from emp where emp_id in (101,102,103));

-- 직원 ID(emp.emp_id)가 101, 102, 103 인 직원들 중 급여가 가장 적은 직원보다 급여를 많이 받는 직원의 모든 정보를 조회.
SELECT * FROM emp WHERE salary > (select min(salary) from emp where emp_id in (101,102,103)) ORDER BY salary desc;
SELECT * FROM emp WHERE salary > ANY(select salary from emp where emp_id in (101,102,103)) ORDER BY salary desc;
-- 최대 급여(job.max_salary)가 6000이하인 업무를 담당하는  직원(emp)의 모든 정보를 sub query를 이용해 조회.
SELECT job_id FROM job WHERE max_salary <= 6000;
SELECT *
	FROM emp
    WHERE job_id IN (SELECT job_id FROM job WHERE max_salary <= 6000);

-- 전체 직원들중 부서_ID(emp.dept_id)가 20인 부서의 모든 직원들 보다 급여(emp.salary)를 많이 받는 직원들의 정보를 sub query를 이용해 조회.
SELECT salary FROM emp
	WHERE dept_id = 20 ORDER BY salary DESC;
    
SELECT *
	FROM emp
    WHERE salary > 
		ALL(
			SELECT salary 
            FROM emp
			WHERE dept_id = 20 ORDER BY salary DESC
            )
	ORDER BY salary desc;




