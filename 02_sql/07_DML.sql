/* *********************************************************************
UPDATE : 테이블의 컬럼의 값을 수정
UPDATE 테이블명
SET    변경할 컬럼 = 변경할 값  [, 변경할 컬럼 = 변경할 값]
[WHERE 제약조건]

 - UPDATE: 변경할 테이블 지정
 - SET: 변경할 컬럼과 값을 지정
 - WHERE: 변경할 행을 선택. 
************************************************************************ */
-- 직원 ID가 200인 직원의 급여를 5000으로 변경
UPDATE emp SET salary = 5000 WHERE emp_id = 200;


-- 직원 ID가 200인 직원의 급여를 10% 인상한 값으로 변경.
UPDATE emp SET salary = (1.1*salary) WHERE emp_id = 200;
SELECT * FROM emp WHERE emp_id=200;

-- 부서 ID가 100인 직원의 커미션 비율을 null 로 변경.
SELECT * FROM emp WHERE dept_id=100;
UPDATE emp SET comm_pct = NULL WHERE dept_id = 100; -- WHERE 절에서 비교할떄는 IS NULL 이었지만 값을 대입할 때는 = NULL 로 씀
-- 부서 ID가 100인 직원의 커미션 비율을 0.2로 salary는 3000 인상한 값으로 변경.
UPDATE emp SET comm_pct = 0.2, salary = salary + 3000 WHERE dept_id = 100;

/* *********************************************************************
DELETE : 테이블의 행을 삭제
구문 
 - DELETE FROM 테이블명 [WHERE 제약조건]
   - WHERE: 삭제할 행을 선택
************************************************************************ */

-- 부서테이블에서 부서_ID가 200인 부서 삭제
select * from dept where dept_id = 200;
DELETE FROM dept WHERE dept_id = 200;

-- 부서 ID가 없는 직원들을 삭제
SELECT * FROM emp where dept_id is null;
DELETE  FROM emp where dept_id is null;
-- 담당 업무(emp.job_id)가 'SA_MAN'이고 급여(emp.salary) 가 12000 미만인 직원들을 삭제.
DELETE FROM emp
	WHERE job_id = 'SA_MAN' AND salary < 12000;
SELECT * FROM emp
	WHERE job_id = 'SA_MAN' AND salary < 12000;  

-- comm_pct 가 null이고 job_id 가 IT_PROG인 직원들을 삭제
SELECT * FROM emp
	WHERE comm_pct IS NULL AND job_id = 'IT_PROG';
DELETE FROM emp
	WHERE comm_pct IS NULL AND job_id = 'IT_PROG';
SELECT * FROM emp
	WHERE comm_pct IS NULL AND job_id = 'IT_PROG';

