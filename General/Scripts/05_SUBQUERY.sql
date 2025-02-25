/*
    * SUBQUERY (서브쿼리)
    - 하나의 SQL문 안에 포함된 또다른 SQL문
    - 메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문
    -- SELECT, FROM, WHERE, HAVGIN 절에서 사용가능

		-- Main Query = SELECT, INSERT, UPDATE, DELETE, CREATE, FUNCTION ...
		-- Sub Query  = SELECT 절만 사용 가능
*/  

-- 서브쿼리 예시 1.
-- 부서코드가 노옹철사원과 같은 소속의 직원의 
-- 이름, 부서코드 조회하기

-- 1) 사원명이 노옹철인 사람의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE 
WHERE EMP_NAME = '노옹철';


-- 2) 부서코드가 D9인 직원을 조회
SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철사원과 같은 소속의 직원 명단 조회   
--> 위의 2개의 단계를 하나의 쿼리로!!! --> 1) 쿼리문을 서브쿼리로!!

SELECT EMP_NAME , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = (
	SELECT 
		DEPT_CODE 
	FROM 
		EMPLOYEE 
	WHERE EMP_NAME = '노옹철'
);
                   
-- 서브쿼리 예시 2.
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회하기
SELECT FLOOR(AVG(SALARY))
FROM EMPLOYEE ;

-- 2) 직원들중 급여가 4091140원 이상인 사원들의 사번, 이름, 직급코드, 급여 조회
SELECT 
	EMP_ID
	, EMP_NAME
	, JOB_CODE
	, SALARY
FROM 
	EMPLOYEE ;

-- 3) 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원 조회
--> 위의 2단계를 하나의 쿼리로 가능하다!! --> 1) 쿼리문을 서브쿼리로!!

SELECT             
		EMP_ID
	, EMP_NAME
	, JOB_CODE
	, SALARY
FROM EMPLOYEE 
WHERE SALARY >= (
	SELECT FLOOR(AVG(SALARY))FROM EMPLOYEE
);

-------------------------------------------------------------------

/*  서브쿼리 유형

    - 단일행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때 
    	(1행 1열)
    	WHERE 절 사용 시 단일행 서브쿼리 앞에는 비교 연산자 사용
   		<, >, <=, >=, =, !=/^=/<>

    	
    - 다중행 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
    	(N행 1열, WHERE절 사용 시 IN, NOT IN, > ANY, > ALL 등 사용)
    
    - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 자열된 항목수가 여러개 일 때
    	(1행 N열, WHERE절 사용 시 비교하려는 컬럼을 (A,B) 묶어 지정)
    
    - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때 
    	(N행 N열, IN 같은 연산자 + 컬럼을 (A, B) 묶어 사용)
    
    - 상관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인 쿼리가 비교 연산할 때 
                     메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
                     
    
    - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
    
   * 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다름
    
*/


-- 1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY) == 단일행 단일열
--    서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리
--    단일행 서브쿼리 앞에는 비교 연산자 사용
--    <, >, <=, >=, =, !=/^=/<>


-- 전 직원의 급여 평균보다 많은 급여를 받는 직원의 
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY 
FROM EMPLOYEE E
LEFT OUTER JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SALARY > (
--	SELECT FLOOR(AVG(SALARY))
--	FROM EMPLOYEE
	3000000
)
ORDER BY E.JOB_CODE ; 

-- 가장 적은 급여를 받는 직원의
-- 사번, 이름, 직급명, 부서코드, 급여, 입사일을 조회

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	, J.JOB_NAME 
	, E.DEPT_CODE 
	,E.SALARY 
	,E.HIRE_DATE 
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE SALARY = (
	SELECT 
		MIN(SALARY) 
	FROM EMPLOYEE);
                 
-- 노옹철 사원의 급여보다 많이 받는 직원의 
-- 사번, 이름, 부서명, 직급명, 급여를 조회
SELECT 
	EMP_ID 
	, EMP_NAME 
	, DEPT_TITLE
	, JOB_NAME
	, SALARY 
FROM EMPLOYEE E 
JOIN DEPARTMENT D ON(DEPT_ID = DEPT_CODE)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SALARY > (
	SELECT SALARY 
	FROM EMPLOYEE 
	WHERE EMP_NAME = '노옹철'
);
        
 
-- 부서별(부서가 없는 사람 포함) 급여의 합계 중 가장 큰 부서의
-- 부서명, 급여 합계를 조회 

-- 1) 부서별 급여 합 중 가장 큰값 조회
SELECT MAX(SUM(SALARY)) 
FROM EMPLOYEE 
GROUP BY DEPT_CODE ;


-- 2) 부서별 급여합이 21760000원 부서의 부서명과 급여 합 조회
SELECT DEPT_TITLE, SUM(SALARY) 
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE 
HAVING SUM(SALARY) = 21760000;

-- WHERE => FROM 절 테이블에서 조회를 원하는 행에 조건
-- HAVING => GROUP BY 절에 의해 만들어진 그룹 중 조회를 원한느 그룹에 대한 조건

-- 3) >> 위의 두 서브쿼리 합쳐 부서별 급여 합이 큰 부서의 부서명, 급여 합 조회

SELECT 
	DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE 
	GROUP BY DEPT_CODE 
HAVING 
	SUM(SALARY) = (
		SELECT MAX(SUM(SALARY)) 
		FROM EMPLOYEE 
		GROUP BY DEPT_CODE 
	);

-- 부서별 인원 수가 3명 이상인 부서의 부서명, 인원 수 조회

SELECT DEPT_TITLE, COUNT(*)
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE 
HAVING COUNT(*) >= 3;
                    
/* GROUP BY가 사용된 SELECT 문의 SELECT절에는 
 * 그룹 함수 또는 GROUP BY에 사용된 컬럼명만 작성 가능하다!
 * */

-- 부서별 인원 수가 가장 적은 부서의
-- 부서명, 인원 수 조회
SELECT NVL(DEPT_TITLE, '없음'), COUNT(*)
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE 
HAVING COUNT(*) = (
	SELECT MIN(COUNT(*))
	FROM EMPLOYEE 
	GROUP BY DEPT_CODE
);

-------------------------------------------------------------------------

-- 2. 다중행 서브쿼리 (MULTI ROW SUBQUERY)
--    서브쿼리의 조회 결과 값의 개수가 여러행일 때 

/*
    >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 x
    
    - IN / NOT IN : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면
                    혹은 없다면 이라는 의미(가장 많이 사용!)
    - > ANY, < ANY : 여러개의 결과값 중에서 한개라도 큰 / 작은 경우
                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?
    - > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
                     가장 큰 값 보다 큰가? / 가장 작은 값 보다 작은가?
    - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
    
*/

-- 부서별 최고 급여를 받는 직원의 
-- 이름, 직급, 부서, 급여를 부서 순으로 정렬하여 조회

-- 1) 부서별 최고 급여를 받는 부서는 어디인가
SELECT DEPT_TITLE , MAX(SALARY)
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)
GROUP BY DEPT_TITLE ;

-- 2) 부서별 최고 급여를 받는 직원 조회

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY IN (
	SELECT MAX(SALARY)
	FROM EMPLOYEE 
	GROUP BY DEPT_CODE
);

-- 사수에 해당하는 직원에 대해 조회 
--  사번, 이름, 부서명, 직급명, 구분(사수 / 직원)

-- 1) 사수에 해당하는 사원 번호 조회

SELECT DISTINCT EMP.MANAGER_ID 
FROM EMPLOYEE EMP
WHERE MANAGER_ID IS NOT NULL ;

-- 2) 직원의 사번, 이름, 부서명, 직급 조회

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회 (이때, 구분은 '사수'로)

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
	,'사수' AS "구분"
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_ID IN (
	SELECT 
		DISTINCT MANAGER_ID 
	FROM 
		EMPLOYEE 
	WHERE MANAGER_ID IS NOT NULL 
);

-- 4) 일반 직원에 해당하는 사원들 정보 조회 (이때, 구분은 '사원'으로)

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
	,'사원' AS "구분"
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_ID NOT IN (
	SELECT 
		DISTINCT MANAGER_ID 
	FROM 
		EMPLOYEE 
	WHERE MANAGER_ID IS NOT NULL 
);
            

-- 5) 3, 4의 조회 결과를 하나로 합침 -> SELECT절 SUBQUERY
-- * SELECT 절에도 서브쿼리 사용할 수 있음

-- 1) UNION 
SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
	,'사수' AS "구분"
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_ID IN (
	SELECT 
		DISTINCT MANAGER_ID 
	FROM 
		EMPLOYEE 
	WHERE MANAGER_ID IS NOT NULL 
)

UNION

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
	,'사원' AS "구분"
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE E.EMP_ID NOT IN (
	SELECT 
		DISTINCT MANAGER_ID 
	FROM 
		EMPLOYEE 
	WHERE MANAGER_ID IS NOT NULL 
)
ORDER BY 구분;

/* SELECT 절에 서브쿼리를 작성해서 길이 줄이기 */

SELECT 
	E.EMP_ID 
	, E.EMP_NAME 
	,NVL(D.DEPT_TITLE,'없음') AS DEPT_TITLE
	, J.JOB_NAME
	,CASE 
		-- 현재 행의 EMP_ID와 일치하는 값이 
		-- 서브쿼리 결과에 있으면 '사수' 없으면 '사원'
		WHEN E.EMP_ID IN(
			SELECT DISTINCT MANAGER_ID
			FROM EMPLOYEE 
			WHERE MANAGER_ID IS NOT NULL
		)  
		THEN '사수'
		
		ELSE '사원'
	END AS "구분"
FROM EMPLOYEE E
LEFT JOIN
	DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN 
	JOB J ON (E.JOB_CODE = J.JOB_CODE)
ORDER BY 구분;



-- 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ANY 혹은 < ANY 연산자를 사용하세요

-- > ANY, < ANY : 여러개의 결과값 중에서 하나라도 큰 / 작은 경우
--                     가장 작은 값보다 큰가? / 가장 큰 값 보다 작은가?

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급명, 급여 조회
SELECT EMP_ID, EMP_NAME ,JOB_NAME, SALARY 
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리' ;

-- 2) 직급이 과장인 직원들 급여 조회
SELECT EMP_ID, EMP_NAME ,JOB_NAME, SALARY 
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장' ;

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원
-- 3-1) MIN을 이용하여 단일행 서브쿼리를 만듦.

SELECT EMP_ID, EMP_NAME ,JOB_NAME, SALARY 
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리' 
AND E.SALARY > ( -- 과장 최소 급여(320만)보다 많이 받는 대리 조회
	SELECT MIN(SALARY) 
	FROM EMPLOYEE E 
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE J.JOB_NAME = '과장' 
);

-- 3-2) ANY를 이용하여 과장 중 가장 급여가 적은 직원 초과하는 대리를 조회

SELECT EMP_ID, EMP_NAME ,JOB_NAME, SALARY 
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '대리' 
AND E.SALARY > ANY( 
	SELECT E.SALARY -- 476만, 320만, 350만
	FROM EMPLOYEE E 
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE J.JOB_NAME = '과장' 
);


-- 차장 직급의 급여의 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, > ALL 혹은 < ALL 연산자를 사용하세요

-- > ALL, < ALL : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
--                     가장 큰 값 보다 크냐? / 가장 작은 값 보다 작냐?

-- 1) MAX 사용

SELECT E.EMP_ID , E.EMP_NAME , J.JOB_NAME ,E.SALARY 
FROM  EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장'
AND SALARY > (
	SELECT MAX(SALARY)
	FROM EMPLOYEE E
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE JOB_NAME = '차장'
);

-- 2) > ALL 이용

SELECT EMP_ID, EMP_NAME ,JOB_NAME, SALARY 
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_NAME = '과장' 
AND E.SALARY > ALL( 
	SELECT E.SALARY -- 476만, 320만, 350만
	FROM EMPLOYEE E 
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE J.JOB_NAME = '차장' 
);

-- 서브쿼리 중첩 사용(응용편!)


-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우의 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가 
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.

-- 1) LOCATION 테이블을 통해 NATIONAL_CODE가 KO인 LOCAL_CODE 조회

SELECT LOCAL_CODE
FROM LOCATION 
WHERE NATIONAL_CODE = 'KO'; -- L1 -- 단일행

-- 2)DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고 있는 DEPT_ID를 조회

SELECT DEPT_ID
FROM DEPARTMENT 
WHERE LOCATION_ID = (
	SELECT LOCAL_CODE
	FROM LOCATION 
	WHERE NATIONAL_CODE = 'KO'
);
-- D1, D2, D3, D4, D9 -- 다중 행

-- 3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가지는 사원을 조회

SELECT EMP_NAME, DEPT_CODE -- 3)
FROM EMPLOYEE 
WHERE DEPT_CODE IN (
	SELECT DEPT_ID -- 2) 
	FROM DEPARTMENT 
	WHERE LOCATION_ID = (
		SELECT LOCAL_CODE -- 1)
		FROM LOCATION 
		WHERE NATIONAL_CODE = 'KO'
	)
);
                      
-- 1, 2, 3순서로 해석됨


-----------------------------------------------------------------------

-- 3. 다중열 서브쿼리 (단일행 = 결과값은 한 행)
--    서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개 일 때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
-- 사원의 이름, 직급, 부서, 입사일을 조회        

-- 1) 퇴사한 여직원 조회
SELECT 
	EMP_NAME 
	, DEPT_CODE
	, JOB_CODE 
	, HIRE_DATE 
FROM EMPLOYEE 
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) IN (2,4);

-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 (다중 열 서브쿼리)

SELECT 
	EMP_NAME 
	, DEPT_CODE
	, JOB_CODE 
	, HIRE_DATE 
FROM EMPLOYEE 
WHERE DEPT_CODE = (
	SELECT 
		DEPT_CODE
	FROM EMPLOYEE 
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) IN (2,4)
)
AND JOB_CODE = (
SELECT 
		JOB_CODE 
	FROM EMPLOYEE 
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) IN (2,4)
);
                          
/* 다중열 서브쿼리 사용!! */     
SELECT 
	EMP_NAME 
	, DEPT_CODE
	, JOB_CODE 
	, HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT 
		DEPT_CODE
		,JOB_CODE 
	FROM EMPLOYEE 
	WHERE ENT_YN = 'Y'
	AND SUBSTR(EMP_NO, 8, 1) IN (2,4)
);

-- 비교하려는 컬럼을 ()로 묶어서 
-- 여러 컬럼을 한 번에 비교

-------------------------- 연습문제 -------------------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT 
	E.EMP_ID
	, E.EMP_NAME
	, E.DEPT_CODE 
	, E.JOB_CODE 
	, D.DEPT_TITLE
	, J.JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE (E.DEPT_CODE, J.JOB_CODE) IN (
	SELECT E.DEPT_CODE, J.JOB_CODE
	FROM EMPLOYEE E
	JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE E.EMP_NAME = '노옹철'
)
AND E.EMP_NAME <> '노옹철'
;

-- 2. 2010년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT 
	E.EMP_ID
	, E.EMP_NAME
	, E.DEPT_CODE
	, E.JOB_CODE
	, E.HIRE_DATE 
FROM EMPLOYEE E
WHERE (DEPT_CODE, JOB_CODE) IN (
	SELECT DEPT_CODE ,JOB_CODE 
	FROM EMPLOYEE 
	WHERE EXTRACT (YEAR FROM HIRE_DATE) = 2010
)
;

-- 3. 87년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일     

SELECT 
	E.EMP_ID
	, E.EMP_NAME
	, E.DEPT_CODE
	, E.MANAGER_ID
	, E.EMP_NO
	, E.HIRE_DATE
FROM EMPLOYEE E
WHERE (DEPT_CODE, MANAGER_ID) IN (
	SELECT DEPT_CODE , MANAGER_ID 
	FROM EMPLOYEE 
	WHERE SUBSTR(EMP_NO, 1,2) = 87
	AND SUBSTR(EMP_NO, 8,1) = 2 
)
;

----------------------------------------------------------------------

-- 다중행 서브쿼리 => IN, ANY, ALL 연산자 사용
-- 다중열 서브쿼리 => WHERE 절 컬럼을 (A, B) 묶음

-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개 일 때

-- 본인 직급의 평균 급여를 받고 있는 직원의
-- 사번, 이름, 직급, 급여를 조회하세요
-- 단, 급여와 급여 평균은 만원단위로 계산하세요 TRUNC(컬럼명, -4)    

-- 1) 급여를 300, 700만 받는 직원 (300만, 700만이 평균급여라 생각 할 경우)
SELECT 
	EMP_ID
	, EMP_NAME 
	, JOB_CODE 
	, SALARY 
FROM EMPLOYEE
WHERE SALARY IN (3000000, 7000000);


-- 2) 직급별 평균 급여

SELECT JOB_CODE, TRUNC(AVG(SALARY), -4) 
FROM EMPLOYEE 
GROUP BY JOB_CODE ;

-- 3) 본인 직급의 평균 급여를 받고 있는 직원

SELECT 
	EMP_ID
	, EMP_NAME 
	, JOB_CODE 
	, SALARY 
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (
	SELECT 
		JOB_CODE 
		, TRUNC(AVG(SALARY), -4) 
	FROM EMPLOYEE
	GROUP BY JOB_CODE 
);
                  
                

-------------------------------------------------------------------------------

-- 5. 상[호연]관 서브쿼리
-- 상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조임

-- 상관쿼리는 먼저 메인쿼리 한 행을 조회하고
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함

/* EXISTS(서브쿼리)
 * - 서브쿼리 조회 결과가 1행 이상 존재하면 TRUE => MAIN QUERY 결과 포함 O 
 * 						조회 결과가 0행이면 FALSE 반환     => MAIN QUERY 결과 포함 X
 *  */

-- 사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회
SELECT MAIN.EMP_ID , MAIN.EMP_NAME , D.DEPT_TITLE, MAIN.MANAGER_ID 
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT D ON (MAIN.DEPT_CODE = D.DEPT_ID)
WHERE 
	EXISTS (
		SELECT 
			'사수 있음'
		FROM EMPLOYEE SUB
		WHERE 
			SUB.EMP_ID = MAIN.MANAGER_ID 
									/* MAIN의 MANAGER_ID */
	);

/* [상호연관 서브쿼리 해석 순서]
 * 
 * 1) 메인 쿼리 1줄을 해석
 * 2) 해석된 행의 컬럼 값을 서브쿼리에서 사용
 * 
 * 3) (메인 쿼리 WHERE절 사용 시)
 * 	 서브쿼리의 결과가 먼저 해석된 메인 쿼리 1행에 영향을 줌
 * 		=> 최종 결과(RESULT SET)에 포함 될지 안될지를 지정
 */

-- 직급별 급여 평균보다 급여를 많이 받는 직원의 
-- 이름, 직급코드, 급여 조회
SELECT MAIN.EMP_NAME , MAIN.JOB_CODE , MAIN.SALARY 
FROM EMPLOYEE MAIN
WHERE 
	MAIN.SALARY > (
		SELECT AVG(SUB.SALARY)
		FROM EMPLOYEE SUB
		WHERE 
			SUB.JOB_CODE =	MAIN.JOB_CODE 
										/* MAIN에서 해석된 1행의 JOB_CODE */								
	);

-- 부서별 입사일이 가장 빠른 사원의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순으로 조회하세요
-- 단, 퇴사한 직원은 제외하고 조회하세요

SELECT MAIN.EMP_ID , MAIN.EMP_NAME , NVL(D.DEPT_TITLE, '소속 없음'), J.JOB_NAME, MAIN.HIRE_DATE 
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT  D ON (MAIN.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (MAIN.JOB_CODE = J.JOB_CODE)
WHERE MAIN.HIRE_DATE = (
	SELECT MIN(SUB.HIRE_DATE)
	FROM EMPLOYEE SUB 
	WHERE NVL(SUB.DEPT_CODE, '소속 없음') = NVL(MAIN.DEPT_CODE, '소속 없음') 
	AND ENT_YN != 'Y'
)
ORDER BY MAIN.HIRE_DATE ASC;

-- 'D5' 부서에서 입사일이 가장 빠른 사람
SELECT MIN(HIRE_DATE) 
FROM EMPLOYEE 
WHERE 
	DEPT_CODE = 'D5'
AND ENT_YN != 'Y';

----------------------------------------------------------------------------------

-- 6. 스칼라 서브쿼리(==단일행 서브쿼리를 SELECT절에 사용하면 '스칼라')
-- SELECT절에 사용되는 서브쿼리 결과로 1행만 반환
-- SQL에서 단일 값을 가르켜 '스칼라'라고 함

-- 각 직원들이 속한 직급의 급여 평균 조회

-- 1) 'J6' 직급의 급여 평균
SELECT AVG(SALARY)
FROM EMPLOYEE 
WHERE JOB_CODE = 'J6';

SELECT AVG(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE 
HAVING JOB_CODE = 'J6';

SELECT EMP_NAME,JOB_CODE,
	TRIM(BOTH FROM(
	SELECT AVG(SUB.SALARY) 
	FROM EMPLOYEE SUB 
	WHERE SUB.JOB_CODE = MAIN.JOB_CODE)) AS "해당 직급 평균"
FROM EMPLOYEE MAIN
ORDER BY MAIN.EMP_ID ASC;


-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단 관리자가 없는 경우 '없음'으로 표시
-- (스칼라 + 상관 쿼리)

SELECT 
	MAIN.EMP_ID 
	, MAIN.EMP_NAME
	, MAIN.MANAGER_ID 
	, NVL(
		(SELECT SUB.EMP_NAME 
		FROM EMPLOYEE SUB
		WHERE SUB.EMP_ID = MAIN.MANAGER_ID)
	, '없음') AS "관리자명"
FROM EMPLOYEE MAIN
ORDER BY MAIN.EMP_ID ASC;

-----------------------------------------------------------------------


-- 7. 인라인 뷰(INLINE-VIEW)
-- FROM 절에서 서브쿼리를 사용하는 경우로
-- 서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신에 사용한다.

-- 인라인뷰를 활용한 TOP-N분석
-- 전 직원 중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회

-- 1) 전 직원의 급여를 내침차순으로 조회
SELECT EMP_NAME ,SALARY 
FROM EMPLOYEE 
ORDER BY SALARY DESC;

-- 2) ROWNUM : 행 번호를 나타내는 가상 컬럼
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE ;

-- 3) ROWNUM을 이용해서 상위 5개 행만 조회
SELECT ROWNUM, EMP_NAME
FROM EMPLOYEE 
WHERE 
	ROWNUM <= 5;

-- 4) 급여 내림차순으로 정렬 후 ROWNUM <= 5 이하만 조회
SELECT ROWNUM, EMP_NAME ,SALARY
FROM EMPLOYEE 
WHERE 
	ROWNUM <= 5
ORDER BY SALARY DESC ;
-- ORDER BY가 나중에 되기 때문에 내가 원하는 값을 뽑을 수 없음.

--> [해결 방법] : 인라인뷰 사용!!

SELECT ROWNUM, EMP_NAME, SALARY 
FROM (
		SELECT EMP_NAME, SALARY
		FROM EMPLOYEE 
		ORDER BY SALARY DESC
)
WHERE ROWNUM <= 5;
	


-- 급여 평균이 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회

-- 1) 조회
SELECT 
	DEPT_CODE "부서 코드"
	, NVL(DEPT_TITLE, '없음') AS "부서명"
	, FLOOR(AVG(SALARY)) AS "급여 평균"
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (D.DEPT_ID = E.DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE
ORDER BY "급여 평균" DESC
;

-- 2) 1번 SELECT 문을 인라인뷰로 사용하여 상위 3개 부서만 조회

SELECT 
	ROWNUM
	, "부서 코드"
	, "부서명"
	, "급여 평균"
FROM (
	SELECT 
		DEPT_CODE "부서 코드"
		, NVL(DEPT_TITLE, '없음') AS "부서명"
		, FLOOR(AVG(SALARY)) AS "급여 평균"
	FROM EMPLOYEE E
	LEFT JOIN DEPARTMENT D ON (D.DEPT_ID = E.DEPT_CODE)
	GROUP BY DEPT_CODE, DEPT_TITLE
	ORDER BY "급여 평균" DESC
)
WHERE ROWNUM <= 3;

------------------------------------------------------------------------

-- 8. WITH
-- 서브쿼리에 이름을 붙여주고 사용시 이름을 사용하게 함
-- 인라인뷰로 사용될 서브쿼리에 주로 사용됨
-- 실행 속도도 빨라진다는 장점이 있다. 

-- 전 직원의 급여 순위 
-- 순위, 이름, 급여 조회
-- 단, 10위까지만

-- 1)
SELECT ROWNUM, EMP_NAME , SALARY 
FROM (
	SELECT EMP_NAME, SALARY
	FROM EMPLOYEE 
	ORDER BY SALARY DESC
)
WHERE ROWNUM <= 10; 

-- 2) WITH를 이용해서 메인쿼리 작성
WITH DESC_SALARY -- 서브쿼리 이름
AS ( -- 서브쿼리 정의
	SELECT 
		EMP_NAME
		, SALARY
	FROM 
		EMPLOYEE 
	ORDER BY SALARY DESC
)

SELECT ROWNUM "순위", EMP_NAME, SALARY
FROM DESC_SALARY
WHERE  ROWNUM <= 10;


--------------------------------------------------------------------------


-- 9. RANK() OVER / DENSE_RANK() OVER

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
--               EX) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위

-- OVER () 괄호 내에 정렬 기준을 작성
--> 정렬이 되면서 순위가 지정됨
---> 인라인뷰, ROWNUM 없이도 순위 지정
SELECT 
	RANK () OVER (ORDER BY SALARY DESC) AS "순위",
	EMP_NAME,
	SALARY 
FROM EMPLOYEE;


-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
--                     EX) 공동 1위가 2명이어도 다음 순위는 2위
SELECT 
	DENSE_RANK () OVER (ORDER BY SALARY DESC) AS "순위",
	EMP_NAME,
	SALARY 
FROM EMPLOYEE;

-------------------------------------------------------------------------------------------------

/* [ROWNUM 사용 시 주의사항] 
 * 
 * ROWNUM이 WHERE 절에 사용되는 경우
 * 항상 1부터 연속적인 범위가 지정되어야 한다.
 * 
 * -> ROWNUM은 RESULT SET 완성 후 부여되는 가상의 컬럼으로
 * 		정해진 규칙(1부터 1씩 증가)을 만족하지 못하면 사용 불가
 * */

-- 급여 순위 상위 3 ~ 7등 조회

SELECT ROWNUM, EMP_NAME, "순위", SALARY
FROM (
	SELECT 
		RANK () OVER (ORDER BY SALARY DESC) AS "순위",
		EMP_NAME,
		SALARY 
	FROM EMPLOYEE
)
-- ROWNUM 이용
WHERE 
	ROWNUM BETWEEN 3 AND 7
;
--> 1부터 시작 안해서 조회 결과가 안나옴

SELECT ROWNUM, EMP_NAME, "순위", SALARY
FROM (
	SELECT 
		RANK () OVER (ORDER BY SALARY DESC) AS "순위",
		EMP_NAME,
		SALARY 
	FROM EMPLOYEE
)
-- RANK OVER 이용 -> 실존 컬럼 이용시 조회 잘 됨.(ROWNUM은 가상 컬럼)
WHERE 
	"순위" BETWEEN 3 AND 7
;

----------------------------------------------------------------------------------------

/* 실습 문제 */

-- 1)
SELECT EMP_ID , EMP_NAME , PHONE , HIRE_DATE , DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
WHERE DEPT_CODE = (
	SELECT DEPT_CODE
	FROM EMPLOYEE 
	WHERE EMP_NAME = '전지연'
)
AND EMP_NAME <> '전지연'; 


-- 2)

SELECT EMP_NO, EMP_NAME ,PHONE ,SALARY ,JOB_NAME
FROM (
	SELECT EMP_NO, EMP_NAME ,PHONE ,SALARY ,JOB_NAME
	,RANK () OVER (ORDER BY SALARY DESC) AS "순위"
	FROM EMPLOYEE E 
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE EXTRACT (YEAR FROM HIRE_DATE) > 2010
)
WHERE "순위" = 1;

-- 3)

SELECT E.EMP_ID , E.EMP_NAME , E.DEPT_CODE , E.JOB_CODE , D.DEPT_TITLE, J.JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
JOIN JOB J ON (E.JOB_CODE =J.JOB_CODE)
WHERE (E.DEPT_CODE, E.JOB_CODE) = (
	SELECT SUB.DEPT_CODE, SUB.JOB_CODE
	FROM EMPLOYEE SUB
	WHERE SUB.EMP_NAME = '노옹철'
)
AND EMP_NAME <> '노옹철'
;

-- 4)

SELECT EMP_ID , EMP_NAME , DEPT_CODE , JOB_CODE , HIRE_DATE 
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (
	SELECT DEPT_CODE , JOB_CODE 
	FROM EMPLOYEE 
	WHERE EXTRACT (YEAR FROM HIRE_DATE) = 2010
);

-- 5)
SELECT EMP_ID, EMP_NAME ,DEPT_CODE ,MANAGER_ID ,EMP_NO ,HIRE_DATE 
FROM EMPLOYEE 
WHERE (DEPT_CODE, MANAGER_ID ) = (
	SELECT DEPT_CODE, MANAGER_ID
	FROM EMPLOYEE 
	WHERE SUBSTR(EMP_NO, 1, 2) = 87
	AND SUBSTR(EMP_NO, 8, 1) = 2
);

-- 6)

SELECT EMP_NO, EMP_NAME , NVL(DEPT_TITLE, '없음'), JOB_NAME, HIRE_DATE 
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID) 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE HIRE_DATE = (
	SELECT MIN(HIRE_DATE) 
	FROM EMPLOYEE E2 
	LEFT JOIN DEPARTMENT D2 ON (E2.DEPT_CODE = D2.DEPT_ID) 
	JOIN JOB J2 ON (E2.JOB_CODE = J2.JOB_CODE)
	WHERE NVL(E2.DEPT_CODE, '없음') = NVL(E.DEPT_CODE, '없음') 
	AND ENT_YN = 'N'
)
ORDER BY HIRE_DATE ASC
; 


-- 7)

SELECT 
	EMP_ID 
	, EMP_NAME 
	, JOB_NAME
	, EMP_NO 
	, FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE((19||SUBSTR(E.EMP_NO, 1,6)), 'YYYY.MM.DD')) / 12) AS "만 나이"
	, TO_CHAR((SALARY * (1 + NVL(BONUS,0)))*12, 'L999,999,999') AS 연봉
FROM EMPLOYEE E 
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE TO_NUMBER(SUBSTR(EMP_NO, 1,6)) = (
	SELECT MAX(TO_NUMBER(SUBSTR(EMP_NO, 1,6)))
	FROM EMPLOYEE E2 
	JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
	WHERE E2.JOB_CODE =E.JOB_CODE 
)
ORDER BY "만 나이" DESC;










