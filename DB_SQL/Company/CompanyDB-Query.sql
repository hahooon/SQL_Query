/********************************
*	Title		:	CompanyDB	*
*					  Query		*
*	Subject		:	DataBase	*
*	Professor	:	김혁만 교수님	*
*	Student ID	:	20171697	*
*	Name		:	전하훈		*
********************************/

USE COMPANY;

select *
from employee;

-------------------------------------------------
-- Q1.	이름이 'John B. Smith'인 사원의				-
-- 		생년월일과 주소를 검색하시오.					-
-------------------------------------------------

SELECT	BDATE 생년월일, ADDRESS 주소
FROM	EMPLOYEE
WHERE	FNAME = 'John' AND MINIT = 'B' AND LNAME = 'Smith';


-------------------------------------------------
-- Q2.	부서번호가 5인 부서에 근무하는					-
-- 		모든 사원의 모든 컬럼을 검색하시오.				-
-------------------------------------------------

SELECT	*
FROM	EMPLOYEE
WHERE	DNO = 5;


-------------------------------------------------
-- Q3.	'Research' 부서에 근무하는 모든 사원의 이름		-
-- 		그리고 주소를 검색하시오.						-
-------------------------------------------------

SELECT	CONCAT(FNAME,' ', MINIT, '. ', LNAME) 이름, ADDRESS 주소
FROM	DEPARTMENT D JOIN EMPLOYEE E ON D.DNUMBER = E.DNO
WHERE	D.DNAME = 'Research';


---------------------------------------------------------
-- Q4.	'Stafford'에 위치한 모든 프로젝트에 대해서,				-
-- 		프로젝트 번호, 담당부서 번호, 부서관리자의 이름을 검색하시오.	-
---------------------------------------------------------

SELECT	P.PNUMBER '프로젝트 번호', D.DNUMBER '담당부서 번호', 
		CONCAT(E.FNAME, ' ', E.MINIT, '. ', E.LNAME) AS '부서 관리자 이름'
FROM	DEPT_LOCATIONS DL JOIN DEPARTMENT D USING (DNUMBER)
		JOIN PROJECT P ON P.DNUM = D.DNUMBER
		JOIN EMPLOYEE E ON E.SSN = D.MGR_SSN
WHERE	DL.DLOCATION = 'Stafford';


---------------------------------------------------------
-- Q5.	각 사원에 대해 사원의 이름과 성별, 그리고					-
-- 		직속 상사의 이름과 성별을 검색하시오. 출력 컬럼은 			-
-- 		사원의 이름과 성별, 그리고 직속 상사의 이름과 성별 순으로		-
-- 		하며, 테이블 데이터는 사원 이름 중 FNAME의 오름차순으로 	-
-- 		나타내시오.										-
---------------------------------------------------------

SELECT	CONCAT(SUBE.FNAME, ' ', SUBE.MINIT, '. ', SUBE.LNAME) 이름, SUBE.SEX 성별, 
		CONCAT(SUPE.FNAME, ' ', SUPE.MINIT, '. ', SUPE.LNAME) '직속 상사의 이름', SUPE.SEX '직속 상사 성별'
FROM	EMPLOYEE SUBE JOIN EMPLOYEE	SUPE ON SUBE.SUPER_SSN = SUPE.SSN
ORDER	BY SUBE.FNAME;


---------------------------------------------------------
-- Q6.	사원 'Franklin T. Wong'이 직접 관리하는 사원의 		-
-- 		이름을 검색하시오. 테이블 데이터는 사원 이름 중 			-
-- 		Fname의 오름차순으로 나타내시오						-
---------------------------------------------------------

SELECT	CONCAT(FNAME, ' ', MINIT, '. ', LNAME) 이름
FROM	EMPLOYEE
WHERE	SUPER_SSN in (SELECT Ssn
					 FROM	EMPLOYEE
					 WHERE	FNAME = 'Franklin' and Minit = 'T' and
							Lname = 'Wong')
ORDER	BY FNAME;


---------------------------------------------------------
-- Q7.	사원의 Ssn과 부서의 Dname에 대한 모든 조합을 생성하시오.	-
-- 		출력 컬럼은 Ssn, Dname 순으로 나열하며, 테이블 데이터는	-
-- 		Ssn과 Dname의 오름차순으로 출력하시오.					-
---------------------------------------------------------

SELECT	E.Ssn, D.Dname
FROM	EMPLOYEE E CROSS JOIN DEPARTMENT D
ORDER	BY 1, 2;

---------------------------------------------------------
-- Q8.	성이 'Wong'인 사원이 일하는 프로젝트, 혹은 성이 'Wong'인	-
-- 		사원이 관리하는 부서에서 진행하는 프로젝트의 번호를 검색하시오.	-
-- 		테이블 데이터는 프로젝트 번호의 오름차순으로 나타내시오.		-
---------------------------------------------------------
-- 사원이름, 프로젝트 번호, 관리하는 부서, 

SELECT	P.PNUMBER, P.PNAME
FROM	EMPLOYEE E JOIN WORKS_ON W ON E.SSN = W.ESSN
		JOIN PROJECT P ON P.PNUMBER = W.PNO
WHERE	E.SSN IN
(SELECT	SSN
FROM	EMPLOYEE
WHERE	LNAME = 'Wong')
UNION
SELECT	P.PNUMBER, P.PNAME
FROM	EMPLOYEE E JOIN DEPARTMENT D ON E.DNO = D.DNUMBER
		JOIN PROJECT P ON P.DNUM = D.DNUMBER
WHERE	D.DNUMBER in
(SELECT	DNO
FROM	EMPLOYEE
WHERE	LNAME = 'Wong')
ORDER	BY PNUMBER;



-------------------------------------------------------------
-- Q9.	주소에 'Houston, Tx'이 들어있는 모든 사원의 이름을 검색하시오.	-
-- 		출력 컬럼은 사원의 이름, 주소 순으로 하며, 테이블 데이터는 이름중	-
-- 		Fname의 오름차순으로 나타내시오.							-
-------------------------------------------------------------

SELECT	CONCAT(FNAME, ' ', MINIT, '. ', LNAME) '사원 이름', ADDRESS 주소
FROM	EMPLOYEE
WHERE	ADDRESS LIKE '%Houston, Tx%'
ORDER	BY FNAME;


-------------------------------------------------------------
-- Q10.	'ProductX'프로젝트에 참여하는 모든 사원의 이름, 그리고 그들의	-
-- 		급여를 10% 올린 경우의 급여를 구하시오.						-
-------------------------------------------------------------

SELECT	CONCAT(E.FNAME, ' ', E.MINIT, '. ', E.LNAME) 사원이름, ROUND(E.SALARY*1.1,2) 급여
FROM	EMPLOYEE E JOIN WORKS_ON W ON E.SSN = W.ESSN
WHERE	W.PNO IN 
(SELECT	PNUMBER
FROM	PROJECT
WHERE	PNAME = 'ProductX');


-----------------------------------------------------------------
-- Q11.	모든 부서 이름, 부서에 소속한 사원의 이름, 그리고 각 사원이 진행하는	-
-- 		프로젝트 이름의 리스트를 검색하시오. 테이블 데이터는 부서 이름의		-
-- 		내림차순, 그리고 각 부서 내에서 사원 이름의 오름차순, 프로젝트 이름의	-
-- 		오름차순으로 나타내시오.										-
-----------------------------------------------------------------

SELECT	D.DNAME '부서 이름', CONCAT(E.FNAME, ' ', E.MINIT, '. ', E.LNAME) 사원_이름,
		P.PNAME '프로젝트 이름'
FROM	EMPLOYEE E JOIN DEPARTMENT D ON E.DNO = D.DNUMBER
		JOIN PROJECT P ON D.DNUMBER = P.DNUM
ORDER	BY D.DNAME DESC, 사원_이름 ASC, P.PNAME ASC;

