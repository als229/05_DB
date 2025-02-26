/* DB
 * - 공용으로 사용할 데잉터를 중복을 최소화하여 구조적으로 모으는 곳
 * 
 * DMBS(DataBase Management System)
 * - DB 데이터를 추출, 조작, 정의, 제어할 수 있는 프로그램
 * 
 * SQL(Structured Query Language, 구조적 질의 언어)
 * - 데이터를 조회, 조작, 관리하기 위해 사용하는 언어
 * 
 * DQL(Data Query Language) : 데이터 질의언어
 * - 테이블에서 데이터 조회하는 역할
 * - SELECT
 * 
 * DML(Data Manipulation Language) : 데이터 조작 언어
 * - 테이블의 값을 조작(삽입, 수정, 삭제)하는 구문
 * - INSERT, UPDATE, DELETE, MERGE
 * 
 * TCL(Transaction Control Language)
 * - 트랜잭션 제어 언어
 * - Transction : 데이터 변경사항(DML)을 묶어 관리하는 DB의 논리적 연산 단위
 * 
 */
--------------------------------------------------------------------------
/* [SELECT 작성법]
 * 
 * 5) SELECT 컬럼명 | 함수 | 리터럴 | 서브쿼리(스칼라) [AS "별칭"]
 * 1) FROM 테이블명 | 서브쿼리(인라인뷰) + JOIN
 * 2) WHERE 조건식
 * 3) GROUP BY 컬럼명 | 함수식
 * 4) HAVING   컬럼명 | 그룹함수를 이용한 조건식
 * 6) ORDER BY 컬렴명 | 컬럼순서 | 별칭 [ASC, DESC] [NULLS FIRST | NULLS LAST]
 * 
 * [INSERT 작성법]
 * 
 * INSERT INTO 테이블명 (컬럼명...) VALUES(값...);
 * => 지정한 컬럼에만 값을 대입하여 테이블에 행 삽입
 * => 언급되지 않은 컬럼은 NULL 또는 DEFAULT
 * 
 * INSERT INTO 테이블명 VALUES(값...);
 * => 테이블에 행 삽입
 * => VALUES() 에는 테이블의 모든 컬럼 값 순서대로 작성
 * 
 * [UPDATE 작성법]
 * 
 * UPDATE 테이블명 SET
 * 컬럼명 = 값;
 * 컬럼명 = 값;
 * ...
 * WHERE 조건식; -- 어떤 행만 수정할지 지정
 *  
 * [DELETE]
 * DELETE
 * FROM 테이블명
 * WHERE 조건식;
 * 
 * ------------------------------------------------------------------
 * 
 * [TCL 구문]
 * 
 * COMMIT : 트랜잭션에 저장된 변경 사항을 DB에 반영
 * 
 * ROLLBACK : 트랜잭션을 삭제
 * 						=> 마지막 COMMIT 상태로 돌아감
 * 
 * SAVEPOINT : 트랜잭션에 저장 지점을 설정하여 원하는 위치 까지만 ROLLBACK
 */

/* [테이블 생성 SQL]
 * CREATE TABLE 테이블명(
 * 
 * 		컬럼명 자료형(크기),
 * 		컬렴명 자료형(크기) [컬럼 레벨 제약 조건]
 * 
 * 		[테이블 레벨 제약 조건]
 * );
 * 
 * [DB 자료형]
 * NUMBER 					: 숫자(정수, 실수)
 * DATE 						: 날짜 (TIMESTAMP : DATE + MS(밀리세컨드단위) + 지역 + UTC)
 * CHAR							: 문자열, 고정 크기, 최대 2000BYTE 
 * VARCHAR2 				: 문자열, 가변 크기, 최대 4000BYTE
 * BLOB(비롭,블롭)	: 이진 데이터 저장(최대 4GB)
 * CLOB(씨롭)				: 문자 데이터 저장(최대 4GB)
 * 
 * 
 * [제약 조건]
 * - 정의 : 조건에 맞는 데이터만 유지하기 위해 컬럼에 설정하는 조건 => 데이터 무결성 확보(중복 X, NULL X, 신뢰할 수 있는 데이터)
 * 
 * [NOT NULL 제약 조건]
 * - 컬럼에 반드시 값을 기록해야 된다는 제약 조건
 * - 무조건 컬럼 레벨로만 설정 가능!!
 * 
 * [UNIQUE 제약 조건]
 * - 같은 컬럼에 중복되는 값을 제한하는 제약 조건 (중복 X)
 * - 컬럼/테이블 레벨 모두 설정 가능
 * - 복합키 설정 가능
 * - NULL 삽입 가능, NULL 중복 가능
 * 
 * [PRIMARY KEY 제약 조건] 
 * - 테이블에서 한 행의 정보를 찾기 위해 사용하는 컬럼
 * --> 식별자 역할
 * - 중복 X, NULL 허용 X => NOT NULL 과 UNIQUE의 특징을 가지고 있음
 * - 테이블당 1개만 설정 가능
 * - 컬럼/테이블 레벨 모두 설정 가능
 * - 복합키 설정 가능
 * 
 * [FOREIGN KEY]
 * - 참조된 다른 테이블의 컬럼에서 제공하는 값만 사용할 수 있게 하는 제약 조건
 *   부모 <-(참조)- 자식
 * 
 * - 테이블간의 관계(Relationship)가 형성됨
 * => 테이블간의 JOIN 가능한 컬럼이 특정지어짐
 * 
 * - 컬럼/테이블 레벨 모두 설정 가능
 * 
 * - 삭제 옵션
 * 	1) ON DELETE SET NULL
 * 		- 참조하던 부모 컬럼 값이 삭제되면 자식 컬럼 값을 NULL로 세팅하겠다.
 * 
 * 	2) ON DELETE CASCADE
 * 		- 참조하던 부모 컬럼 값이 삭제되면 자식 행도 삭제
 * 
 * [CHECK 제약 조건]
 * - 컬럼에 기록되는 값에 조건을 설정하는 제약 조건
 * - 조건에 사용되는 비교값은 '리터럴'만 작성 가능
 * - 컬럼/테이블 레벨 모두 설정 가능
 * 
 * ------------------------------------------------------------------------------------------------------------------
 * 
 * [ALTER] : 객체의 구조를 변경하는 구문
 * 
 * [ALTER TABLE 구문]
 * - 컬럼 (추가/수정/삭제)
 * - 제약조건(추가/삭제)
 * - 이름변경(테이블, 컬럼, 제약조건)
 * 
 * ------------------------------------------------------------------------------------------------------------------
 * 
 * [DROP] : 객체를 삭제하는 구문
 * 
 * [DROP TABLE 테이블명 CASCADE CONSTRAINTS]
 * - 삭제되는 테이블과 관계를 맺기 위한 제약조건(FK)도 모두 삭제
 */


-------------------------------------------------------------------------------------------
/* SELECT
 * 
 * - 지정된 테이블에서 원하는 데이터가 존재하는 행, 열을 선택해서 조회하는 SQL(구조적 질의 언어)
 * 
 * - 선택된 데이터 == 조회 결과 묶음 == RESULT SET
 * 
 * - 조회 결과는 0행 이상 (조건에 맞는 행이 없을 수 있다!)
 */

/* [SELECT 작성법 - 1]
 * 
 *  2) SELECT
 *  1) FROM 테이블명;
 * 
 *  - 지정된 테이블의 모든 행에서 특정 열(컬럼)만 조회하기
 */

-- EMPLOYEE 테이블에서 모든 행의 이름(EMP_NAME), 급여(SALARY) 컬럼 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE ;


-- EMPLOYEE 테이블에서
-- 모든 행(== 모든 사원)의 사번, 이름, 급여, 입사일 조회
SELECT EMP_ID, EMP_NAME, SALARY,  HIRE_DATE
FROM EMPLOYEE;

-- EMPLOYEE 테이블의 
-- 모든행, 모든 열(컬럼) 조회
-- =>*(asterisk) : "모든", "포함"을 나타내는 기호
SELECT *
FROM EMPLOYEE;

-- DEPARTMENT 테이블에서 
-- 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT;

-- EMPLOYEE 테이블에서
-- 이름, 이메일, 전화번호 조회
SELECT EMP_NAME ,EMAIL ,PHONE
FROM EMPLOYEE; 


----------------------------------------------------------------------------------------------------------

/* 컬럼 값 산술 연산 */

/* 컬럼 값 : 행과 열이 교차되는 한 칸에 작성된 값
 * 
 * - SELECT문 작성 시
 *  SELECT 절 컬럼명에 산술 연산을 작성하면 조회 결과(RESULT SET)에서 모든 행에 산술 연산이 적용된
 *  컬럼값이 조회된다.
 */
SELECT EMP_NAME , SALARY , SALARY + 1000000
FROM EMPLOYEE ;

-- 모든 사원의 이름, 급여(1개월), 연봉(급여 * 12)조회
SELECT EMP_NAME, SALARY, SALARY*12 
FROM EMPLOYEE ;

----------------------------------------------------------------------------------------------------------

/* SYSDATE / CURRENT_DATE
 * SYSTIMESTAMP / CURRENT_TIMESTAMP
 */

/* * DB는 날짜 / 시간 관련 데이터를 다룰 수 있도록 하는 자료형 제공
 * 
 * - DATE 타입 : 년, 월, 일, 시, 분, 초, 요일 저장
 * - TIMESTAMP 타입 : 년, 월, 일, 시, 분, 초, 요일, ms, 지역 저장
 * 
 * 
 * - SYS (시스템) : 시스템에 설정된 시간 기반
 * - CURRENT : 현재 접속한 세션 (사용자)의 시간 기반
 * 
 * - SYSDATE : 현재 시스템 시간 얻어오기
 * - CURRENT_DATE : 현재 사용자 계정 기반 시간 얻어오기
 * 
 * * DATE -> TIMESTAMP 바꾸면 ms단위 + 지역 정보를 추가로 얻어옴 
 */

SELECT SYSDATE, CURRENT_DATE 
FROM DUAL;

SELECT SYSTIMESTAMP , CURRENT_TIMESTAMP 
FROM DUAL;

/* DUAL(DUmmy tAbLe) 테이블
 * - 가짜 테이블(임시 테이블)
 * - 조회하려는 데이터가 실제 테이블에 저장된 데이터가 아닌 경우
 *   사용하는 임시 테이블
 */

/* 날짜 데이터 연산하기 (+, -만 가능!!) */

-- 날짜 + 정수 : 정수 만큼 "일" 수 증가 
-- 날짜 - 정수 : 정수 만큼 "일" 수 감소

-- 어제, 오늘, 내일, 모레 조회

SELECT CURRENT_DATE -1 AS 어제, CURRENT_DATE +1 AS 내일, CURRENT_DATE +2 AS 모레
FROM DUAL;

/* 시간 연산 응용(알아두면 도움 많이 됨!!) */

SELECT 
	CURRENT_DATE AS 오늘
	, CURRENT_DATE + 1/24 -- + 1시간
	, CURRENT_DATE + 1/24/60 -- + 1분
	, CURRENT_DATE + 1/24/60/60 -- + 1초
	, CURRENT_DATE + 1/24/60/60 *30 -- + 30초
FROM DUAL;


/* 날짜 끼리 연산
 * 
 * 날짜 - 날짜 = 두 날짜 사이의 차이나는 일 수
 * 
 * * TO_DATE('날짜 모양 문자열', '인식 패턴')
 *  => '날짜 모양 문자열'을 '인식 패턴'을 이용해 해석하여 DATE 타입으로 변환
 */

SELECT 
	TO_DATE('2025-02-19', 'YYYY-MM-DD')
	, '2025-02-19'
FROM 
	DUAL;
	
-- 오늘 (2/19) 부터 2/28까지 남은 일 수
SELECT 
	TO_DATE('2025-02-28', 'YYYY-MM-DD')
	- TO_DATE('2025-02-19', 'YYYY-MM-DD')
FROM 
	DUAL;

-- 오늘 (2/19) 부터 종강까지 남은 일 수
SELECT 
	TO_DATE('2025-07-17', 'YYYY-MM-DD')
	- TO_DATE('2025-02-19', 'YYYY-MM-DD')
FROM 
	DUAL;

-- 퇴근 시간 까지 남은 시간
SELECT 
	(TO_DATE('2025-02-19 17:50:00', 'YYYY-MM-DD HH24:MI:SS')
	- CURRENT_DATE) *24*60
FROM
	DUAL;

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재까지 근무 일수, 연차 조회
SELECT 
	EMP_ID ,
	EMP_NAME , 
	HIRE_DATE , 
	FLOOR((CURRENT_DATE - HIRE_DATE )) AS 근무일수 , -- 내림 처리 FLOOR 
	CEIL((CURRENT_DATE - HIRE_DATE )/365) AS 연차    -- 올림 처리 CEIL
FROM 
	EMPLOYEE;
	

------------------------------------------------------------------------------------------

/* 컬럼명 별칭(Alias) 지정하기 
 * 
 * [지정 방법]
 * 1) 컬럼명 AS 별칭 : 문자 O, 띄어쓰기 X, 특수문자 X
 * 
 * 2) 컬럼명 AS "별칭" : 문자 O, 띄어쓰기 O, 특수문자 O
 * 
 * * AS 구문은 생략 가능!!
 * 
 * * ORACLE에서 ""의 의미
 * - "" 내부에 작성된 글자 모양 그대로를 인식해라!!
 * 
 * ex) 문자열          오라클 인식 
 * 		  abc 			=>   ABC, abc(대소문자 구분 X)
 * 		 "abc"      =>       abc("" 내부 작성된 모양 으로만 인식)
 * */
-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 입사일, 현재까지 근무 일수, 연차 조회
SELECT 
	EMP_ID 사번,
	EMP_NAME "이름", 
	HIRE_DATE AS "입사한 날짜", 
	FLOOR((CURRENT_DATE - HIRE_DATE )) AS "근무 일수" , 
	CEIL((CURRENT_DATE - HIRE_DATE )/365) AS 연차    
FROM 
	EMPLOYEE;

-- EMPLOYEE 테이블에서
-- 모든 사원의 사번, 이름, 급여(원), 연봉(급여*12) 조회
-- 단, 컬럼명은 모두 별칭 적용
SELECT 
	EMP_ID AS 사번,
	EMP_NAME AS "이름",
	SALARY "급여(원)",
	(SALARY *12) "연봉(급여 * 12)"
FROM 
	EMPLOYEE;


-----------------------------------------------------------------------------------------------

/* 연결 연산자(||) 
 * - 두 컬럼값 또는 리터럴을 하나의 문자열로 연결할 때 사용
 * */
SELECT 
	EMP_ID,
	EMP_NAME,
	EMP_ID || EMP_NAME 사번이름
FROM
	EMPLOYEE ;

-----------------------------------------------------------------------------------------------
/* 리터럴 : 값(DATA)을 표기하는 방식(문법)
 * - NUMBER 타입 : 20, 1.12, -44 (정수, 실수 표기)
 * - CHAR, VARCHAR2 타입(문자열) : 'AB', '가나다' ('' 홑따옴표)
 * 
 * * SELECT 절에 리터럴을 작성하면 조회 결과(RESULT SET) 모든 행에 리터럴이 추가된다!
 */
	
SELECT
	SALARY ,
	'원',
	SALARY || '원' AS 급여
FROM 
	EMPLOYEE ;

---------------------------------------------------------------------------------------------------

/* DISTINCT(별개의, 전혀 다른)
 * 
 * - 조회 결과 집합(RESULT SET)에서 DISTINCT가 지정된 컬럼에 중복된 값이 존재할 경우
 * 	 중복을 제거하고 한 번만 표시할 때 사용
 * 
 *   (중복된 데이터를 가진 행을 제거)
 */

-- EMPLOYEE 테이블에서
-- 모든 사원의 부서 코드(DEPT_CODE) 조회
SELECT 
	DIDEPT_CODE
FROM 
	EMPLOYEE ; --23행 조회

-- 사원들이 속한 부서 코드 조회
-- => 사원이 있는 부서만 조회
SELECT 
	DISTINCT DEPT_CODE
FROM 
	EMPLOYEE ; -- 7행 조회(중복 X)
	
	
-------------------------------------------------------------------------------------------------
	
/* [SELECT 작성법 - 2]
 * 
 * 3) SELECT 컬럼명 || 리터럴, ... -- 열선택
 * 1) FROM 테이블명 -- 테이블 선택
 * 2) WHERE 조건식; -- 행 선택 
 */

/* *** WHERE 절 ***
 * 
 * - 테이블에서 조건을 충족하는 행을 조회할 때 사용
 * 
 * - WHERE 절에는 조건식(결과가 T/F)만 작성 가능
 * 
 * - 비교 연산자 : >, <, >=, <= , =(같다), !=, <>(같지 않다)
 * - 논리 연산자 : AND, OR, NOT
 */
	
-- EMPLOYEE 테이블에서
-- 급여가 400만원을 초과하는 사원의 
-- 사번, 이름, 급여를 조회
SELECT EMP_ID ,EMP_NAME ,SALARY 
FROM EMPLOYEE 
WHERE SALARY > 4000000;

-- EMPLOYEE 테이블에서
-- 급여가 500만원 이하인 사원의 
-- 사번, 이름, 급여, 부서코드, 직급코드를 조회
SELECT 
	EMP_ID ,
	EMP_NAME ,
	SALARY ,
	DEPT_CODE ,
	JOB_CODE 
FROM 
	EMPLOYEE 
WHERE 
	SALARY <=5000000;

-- EMPLOYEE 테이블에서
-- 연봉이 5천만원 이하인 사원의
-- 이름, 연봉 조회
SELECT 
	EMP_NAME ,
	SALARY*12 AS 연봉
FROM 
	EMPLOYEE 
WHERE 
	SALARY * 12 <= 50000000;

-- 이름이 '노옹철'인 사원의
-- 사번, 이름, 전화번호 조회
SELECT 
	EMP_ID ,
	EMP_NAME ,
	PHONE 
FROM 
	EMPLOYEE 
WHERE 
	EMP_NAME = '노옹철';

-- 부서 코드(DEPT_CODE)가 'D9'이 아닌 사원의
-- 이름, 부서 코드 조회
SELECT 
	EMP_NAME ,
	DEPT_CODE 
FROM 
	EMPLOYEE 
WHERE 
	DEPT_CODE != 'D9'; -- DEPT_CDOE <> 'D9' 이랑 같음

-- 부서 코드(DEPT_CODE)가 'D9'인 사원의
-- 이름, 부서 코드 조회
SELECT 
	EMP_NAME ,
	DEPT_CODE 
FROM 
	EMPLOYEE 
WHERE 
	DEPT_CODE = 'D9'; -- DEPT_CDOE <> 'D9' 이랑 같음

-- 전체 23명인데 위에 코드 두개 치면 21 명 나옴 두명 NULL

/* *** NULL ***
 * 
 * - DB에서 NULL : 빈칸 (저장된 값 없음)
 * 
 * - NULL은 비교 대상이 없기 때문에 
 * 	 =, != 등의 비교 연산 결과가 무조건 FALSE
 */

/* *** NULL 비교 연산 ***
 * 
 * 1) 컬럼명 IS NULL : 해당 컬럼 값이 NULL 이면 TRUE 반환
 * 
 * 2) 컬럼명 IS NOT NULL : 해당 컬럼 값이 NULL이 아니면 TRUE 반환 
 * 												 => 컬럼의 값이 존재하면 TRUE
 * 
 * (컬럼 값의 존재 유무를 비교하는 연산)
 */
	
-- EMPLOYEE 테이블에서
-- 부서코드가 없는 사원의
-- 사번, 이름, 부서코드 조회
SELECT 
	EMP_ID ,
	EMP_NAME ,
	DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IS NULL; --> DEPT_CODE = NULL 은 안됨!! '=' 은 값 비교 NULL은 그냥 빈칸

-- BONUS가 존재하는 사원의
-- 이름, 보너스 조회
SELECT 
	EMP_NAME ,
	BONUS 
FROM 
	EMPLOYEE 
WHERE 
	BONUS IS NOT NULL;

----------------------------------------------------------------------------------------------
/* *** 논리 연산자(AND/OR) ***
 * 
 * - 두 조건식의 결과에 따라 새로운 결과를 만드는 연산
 * 
 * - AND(그리고) 
 *  두 연산자의 결과가 TRUE 일 때만 최종 결과 TRUE
 *  => 두 조건을 모두 만족하는 행만 
 * 		 결과 집합(RESULT SET)에 포함 
 * 
 * - OR(또는)
 *  두 연산자의 결과가 FALSE 일 때만 최종 결과 FALSE
 *  => 두 조건중 하나라도 만족하는 행을
 * 		 결과 집합(RESULT SET)에 포함 
 * 
 * - 우선 순위 : AND > OR 
 */

-- EMPLOYEE 테이블에서
-- 부서코드가 'D6'인 사원 중
-- 급여가 400만원을 초과하는 사원의
-- 사번, 이름, 부서코드, 급여 조회
SELECT 
	EMP_ID ,
	EMP_NAME ,
	DEPT_CODE ,
	SALARY 
FROM 
	EMPLOYEE 
WHERE 
	DEPT_CODE = 'D6'
	AND SALARY > 4000000;

-- EMPLOYEE 테이블에서
-- 급여가 300만 이상, 500만 미만인 사원의
-- 사번, 이름, 급여 조회
SELECT 
	EMP_ID ,
	EMP_NAME ,
	SALARY 
FROM 
	EMPLOYEE 
WHERE 
	SALARY >= 3000000
	AND SALARY < 5000000;


-- EMPLOYEE 테이블에서
-- 급여가 300만 미만 또는 500만 이상인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID ,EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY < 3000000 OR SALARY >= 5000000;

------------------------------------------------------------------------------------------------------

/* 컬럼명 BETEWEEN (A) AND (B)
 * 
 * - 컬럼 값이 A 이상 B 이하인 경우 TRUE(조회하겠다)
 */

-- EMPLOYEE 테이블에서
-- 급여가 400만 ~ 600만인 사원 조회
-- 이름, 급여
SELECT EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY BETWEEN 4000000 AND 6000000; 

-------------------------------------------------------------------------------------------------------

/* 컬럼명 NOT BETEWEEN (A) AND (B)
 * 
 * - 컬럼 값이 A 이상 B 이하인 경우 FALSE
 *  => (A)미만, (B) 초과인 경우 TRUE
 */
-- EMPLOYEE 테이블에서
-- 급여가 400만 ~ 600만원이 아닌 사원 조회
-- 이름, 급여
SELECT EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY NOT BETWEEN 4000000 AND 6000000; 

/* 날짜 비교에 더 많이 사용!!! */

-- EMPLOYEE 테이블에서
-- 2010년대(20100101 ~ 2019.12.31)
-- 입사한 사원의 이름, 입사일 조회
SELECT EMP_NAME ,HIRE_DATE 
FROM EMPLOYEE 
WHERE HIRE_DATE BETWEEN TO_DATE('2010.01.01','YYYY.MM.DD') AND TO_DATE('2019.12.31','YYYY.MM.DD');

------------------------------------------------------------------------------------------------------

/* 일치하는 값만 조회 */

-- 부서 코드가 'D5', 'D6', 'D9' 인 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D9';

/* 컬럼명 IN (값1, 값2, 값3 ...)
 * 
 * - 컬럼 값이 IN () 안에 존재 한다면 TRUE
 *  == 연속으로 OR 연산을 작성한 것과 같은 효과
 */

-- 부서 코드가 'D5', 'D6', 'D9' 인 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D5', 'D6', 'D9');

/* 컬럼명 NOT IN (값1, 값2, 값3 ...)
 * 
 * - 컬럼 값이 IN () 안에 존재 한다면 FALSE
 *  == 값이 포함되지 않는 행만 조회
 */

-- 부서 코드가 'D5', 'D6', 'D9' 가 아닌 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9');
-- DEPT_CODE가 NULL인 사원은 포함 X

-- 부서 코드가 'D5', 'D6', 'D9'이 아닌 사원 조회
-- + NULL인 사원도 포함
SELECT EMP_ID ,EMP_NAME ,DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE NOT IN ('D5', 'D6', 'D9')
	OR DEPT_CODE IS NULL; 

------------------------------------------------------------------------------------------------------

/* *** LIKE(같은, 비슷한) *** 
 * 
 * - 비교하려는 값이 특정한 패턴을 만족하면 조회하는 연산자
 * 
 * [작성법]
 * WHERE 컬럼명 LIKE '패턴'
 *
 * [패턴에 사용되는 기호(와일드카드)]
 * 
 * 1) '%'(포함)
 * '%A' : A로 끝나는 문자열인 경우 TRUE
 * 			=> 앞 쪽에는 어떤 문자열이든 관계 없음(빈 칸도 가능)
 * 
 * 'A%' : A로 시작하는 문자열인 경우 TRUE
 * 
 * '%A%' : A를 포함한 문자열인 경우  TRUE
 * 
 * 2) '_' (글자 수, _1개당 1글자)
 * 
 * ___ : 문자열이 3글자인 경우 TRUE
 * 
 * A___ : A로 시작하고 뒤에 3글자인 경우 TRUE
 * 				EX) ABCD (TRUE) , ABCDE(FALSE)
 *  
 * ___ A : 앞에 3글자, 마지막은 A로 끝나는 경우 TRUE
 */

-- EMPLOYEE 테이블에서
-- 성이 '전' 씨인 사원 찾기
SELECT *
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '전%';

-- EMPLOYEE 테이블에서
-- 이름이 '수' 로 끝나는 사원 찾기
SELECT *
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%수';

-- 이름에 '하'가 포함된 사원 찾기
SELECT *
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%하%';

-- 전화번호가 010으로 시작하는 사원의
-- 이름, 전화번호 조회
SELECT EMP_NAME , PHONE 
FROM EMPLOYEE 
WHERE PHONE LIKE '010%';
--     ||
SELECT EMP_NAME , PHONE 
FROM EMPLOYEE 
WHERE PHONE LIKE '010________';

-- EMAIL 컬럼에서 @ 앞에 아이디 글자 수가 5글자인 사원의
-- 사번, 이름, 이메일조회
SELECT EMP_ID , EMP_NAME , EMAIL 
FROM EMPLOYEE 
WHERE EMAIL  LIKE '_____@%';

-- EMAIL 아이디 중 '_' 앞 글자 수가 3글자인 사원의
-- 사번, 이름, 이메일 조회
SELECT EMP_ID , EMP_NAME , EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '____%'; -- 전체조회가 됨
--> "EMAIL 이 4글자 이상이면 조회" 라는 의미로 해석

/* 발생한 문제 :
 * "구분자"로 사용하려던 '_'가 LIKE의 와일드카드 '_' 로 해석되면서 문제 발생
 * 
 * [해결 방법]
 * - LIKE ESCAPE OPTION 이용
 * => 지정된 특수 문자 뒤 '딱 한 글자'를 와일드 카드가 아닌 단순 문자열로 인식시키는 옵션
 * 
 * - 작성법
 *  WHERE LIKE '___#_' ESCAPE '#'
 *  # 말고 아무거나 상관 없음
 */
SELECT EMP_ID , EMP_NAME , EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '___#_%' ESCAPE '#'; 

-------------------------------------------------------------------------------------------------

/* [SELECT 작성법 - 3]
 * 
 * 3) SELECT 컬럼명		   -- 열 선택 
 * 1) FROM   테이블명    -- 테이블 선택
 * 2) WHERE  조건식		   -- 행 선택
 * 4) ORDER BY 정렬기준	 -- 조회 결과 정렬
 * 
 * *** ORDER BY 절 ***
 * - SELECT 의 조회 결과 집합(RESULT SET)을
 *   원하는 순서로 정렬할 때 사용하는 구문
 * 
 * - 작성법
 * 
 * ORDER BY 컬럼명 | 별칭 | 컬럼순서 | 함수 | 프로시저
 * 					[ASC / DESC] (오름차순 / 내림차순)
 *          [NULLS FIRST / NULLS LAST] (NULL 데이터 위치 지정) 
 * ** 중요!!! **
 * ORDER BY 절은 해당 SELECT 문 제일 마지막에만 수행!!!
 * 
 * - 오름차순(ASCENDING) : 점점 커지는 순서로 정렬
 * EX) 1 -> 10, A -> Z, 가 -> 하, 과거 -> 미래
 * 
 * - 내림차순(DESCENDING) : 점점 작아지는 순서로 정렬
 * EX) 10 -> 1, Z -> A, 하 -> 가, 미래 -> 과거
 */

-- EMPLOYEE 테이블의 모든 사원을 
-- 이름 오름 차순으로 정렬하여 조회
SELECT EMP_NAME 
FROM EMPLOYEE
ORDER BY EMP_NAME ASC;

-- 급여 내림 차순으로 이름, 급여 조회
SELECT EMP_NAME , SALARY 
FROM EMPLOYEE 
ORDER BY SALARY DESC;

-- + WHERE 절 추가

-- 부서 코드가 'D5', 'D6', 'D9'인 사원의
-- 사번, 이름, 급여, 부서코드
-- 급여 내림 차순으로 조회
SELECT EMP_ID , EMP_NAME , SALARY , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN('D5', 'D6', 'D9')
ORDER BY SALARY DESC;

-- 부서 코드가 'D5', 'D6', 'D9'인 사원의
-- 사번, 이름, 급여, 부서코드
-- 부서코드 오름 차순으로 조회
SELECT EMP_ID , EMP_NAME , SALARY , DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN('D5', 'D6', 'D9')
ORDER BY DEPT_CODE ASC;

--------------------------------------------------------------------------------------------

/* 별칭을 이용하여 정렬하기 
 * 
 * - ORDER BY 절은 제일 마지막에 해석된다!!!
 * 
 * - ORDER BY절 보다 먼저 해석되는 SELECT절의 작성된 별칭을 ORDER BY 절에서 인식할 수 있다.
 * 
 *  ?? 그럼 SELECT 절 보다 먼저 해석되는 WHERE 절에서 별칭 사용이 가능할까???
 * 	=> 안됨!!!
 * */
-- 사번, 이름, 연봉 조회
-- 연봉 오름 차순으로 정렬
SELECT EMP_ID AS 사번 , EMP_NAME AS 이름 , SALARY*12 AS 연봉 
FROM EMPLOYEE 
ORDER BY 연봉 ASC; -- 별칭 이용

-- 연봉을 5천만원 이상 받는 사원의
-- 사번, 이름, 연봉 조회
-- 연봉 오름 차순으로 정렬
SELECT EMP_ID AS 사번 , EMP_NAME AS 이름 , SALARY*12 AS 연봉 
FROM EMPLOYEE 
--WHERE 연봉 > 50000000 -- 오류 발생! -> 아직 별칭 인식 전
WHERE SALARY * 12 > 50000000 
ORDER BY 연봉 ASC; -- 별칭 이용

---------------------------------------------------------------------------------------------

/* 컬럼 순서를 이용하여 정렬하기 
 * 
 * - SELECT 절이 해석되면 조회하려는 컬럼이 지정되면서 컬럼의 순서도 같이 지정된다.(가능O, 권장X)
 * */

-- 급여가 400만 이상, 600만 이하인 사원의
-- 사번, 이름, 급여를
-- 급여 내림차순으로 조회
SELECT EMP_ID , EMP_NAME , SALARY 
FROM EMPLOYEE 
WHERE SALARY BETWEEN 4000000 AND 6000000
ORDER BY 3 DESC; -- 3번째 값인 SALARY 로 조회가 됨 신기방귀

---------------------------------------------------------------------------------------------

/* SELECT 절에 작성되지 않은 컬럼을 이용해 정렬하기 */

-- 모든 사원의 사번, 이름을
-- 부서코드 오름차순으로 조회
SELECT EMP_ID , EMP_NAME 
FROM EMPLOYEE 
ORDER BY DEPT_CODE ASC;
-- ORDER BY 절 해석 전
-- SELECT, FROM 절 모두 해석되어있기 때문에
-- SELECT 절에 없는 컬럼을 작성해도 정렬이 가능.

-----------------------------------------------------------------------------------------------

/* NULLS FRIST, NULLS LAST 확인 */

SELECT EMP_NAME , BONUS 
FROM EMPLOYEE 
ORDER BY BONUS ASC; -- 기본값이 NULLS LAST
-- 오름차순 기본값 : NULLS LAST

SELECT EMP_NAME , BONUS 
FROM EMPLOYEE 
ORDER BY BONUS DESC; -- 기본값이 NULLS FIRST
-- 내림차순 기본값 : NULLS FIRST


-----------------------------------------------------------------------------------------------

/* 정렬 기준 "중첩" 작성 
 * 
 * - 먼저 작성된 정렬을 적용하고 그 안에서 형성된 그룹별로 정렬 진행
 * 
 * - 형성되는 그룹 == 같은 컬럼 값을 가지는 행
 * */

-- EMPLOYEE 테이블에서
-- 이름, 부서코드, 급여를
-- 부서코드 오름차순, 급여 내림차순으로 정렬해서 조회
SELECT EMP_NAME , DEPT_CODE , SALARY 
FROM EMPLOYEE 
ORDER BY DEPT_CODE ASC, SALARY DESC;

-- EMPLOYEE 테이블에서
-- 이름, 부서코드, 직급코드를 조회
-- 부서코드 오름차순, 직급코드 내림차순, 이름 오름차순
SELECT EMP_NAME 이름, DEPT_CODE 부서코드, JOB_CODE 직급코드
FROM EMPLOYEE 
ORDER BY 부서코드 ASC, 직급코드 DESC, 이름 ASC;