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
FROM	EMPLOYEE SUBE LEFT JOIN EMPLOYEE	SUPE ON SUBE.SUPER_SSN = SUPE.SSN
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

SELECT	CONCAT(E.FNAME, ' ', E.MINIT, '. ', E.LNAME) 사원이름, ROUND(E.SALARY*1.1) 급여
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
		JOIN WORKS_ON W ON E.SSN = W.ESSN
        JOIN PROJECT P ON P.PNUMBER = W.PNO
ORDER	BY D.DNAME DESC, 사원_이름 ASC, P.PNAME ASC;

-----------------------------------------------------------------
-- Q12. 5번 부서에 근무하는 사원 중에서, ProductX 프로젝트에 주당			-
-- 		10시간 이상 일하는 사원의 이름과 주당 근무시간을 검색하시오.			-
-----------------------------------------------------------------

SELECT	distinct E.FNAME, E.MINIT, E.LNAME, W.HOURS, W.PNO
FROM	EMPLOYEE E JOIN WORKS_ON W ON E.SSN = W.ESSN
		JOIN PROJECT P ON W.PNO = (
        SELECT	PNUMBER
        FROM	PROJECT
        WHERE	PNAME = "ProductX")
WHERE	E.DNO = 5 AND W.HOURS >= 10;

---------------------------------------------
-- Q13. 	배우자가 있는 사원 수를 검색하시오. 		-
---------------------------------------------

SELECT COUNT(DISTINCT ESSN)
FROM DEPENDENT;

-------------------------------------------------------------
-- Q14.	부양가족이 있는 사원에 대해, 부양가족 수를 구하시오. 출력으로 		-
-- 		사원의 이름과 부양가족 수(컬럼 이름은 NumOfDependents로 할것)를	-
-- 		나열하시오.											-
-------------------------------------------------------------

SELECT	E.FNAME, E.MINIT, E.LNAME, COUNT(*) NumOfDependents
FROM	EMPLOYEE E JOIN DEPENDENT D ON E.SSN = D.ESSN
GROUP	BY E.SSN
ORDER	BY E.FNAME;

-------------------------------------------------------------
-- Q15. 모든 사원에 대해, 부양가족의 이름과 관계를 구하시오, 이 때  	-
-- 		부양가족이 없는 사원도 포함합니다. 출력 칼럼은 사원의 이름, 부양가족	-
-- 		의 이름 순으로 나열하시오. 실행 결과는 사원 이름 중 FNAME, MINIT-
-- 		의 오름차순으로 나타내시오.								-
-------------------------------------------------------------

SELECT	E.FNAME,E.MINIT,E.LNAME, RELATIONSHIP, DEPENDENT_NAME
FROM	EMPLOYEE E LEFT JOIN DEPENDENT D ON E.SSN = D.ESSN
ORDER 	BY E.FNAME ASC ,E.MINIT ASC, E.LNAME ASC;

-------------------------------------------------------------------------
-- Q16.	모든 사원에 대해, 부양가족 수를 구하고, 이때 부양가족이 없는 사원은 부양가족수를	-
-- 		0으로 표시하시오. 출력 컬럼은 사원의 이름과 부양가족 수(NumOfDependents)		-
-- 		순으로 나열하시오. 실행 결과는 부양가족수의 내림차순, 이름중 Fname의 오름차순		-
-- 		으로 나타내시오.													-
-------------------------------------------------------------------------

SELECT	E.FNAME, E.MINIT, E.LNAME, COUNT(D.ESSN) NumOfDependents
FROM	EMPLOYEE E LEFT JOIN DEPENDENT D ON E.SSN = D.ESSN
GROUP	BY E.SSN
ORDER 	BY 4 DESC, E.FNAME;

-----------------------------------------------------------------
-- Q17. 부양가족이 없는 사원의 이름을 구하시오. 실행 결과는 이름 중 FNAME의	-
-- 		오름차순으로 나타내시오.										-
-----------------------------------------------------------------

SELECT  E.FNAME, E.MINIT, E.LNAME
FROM    K_EMPLOYEE E LEFT JOIN K_DEPENDENT D ON E.SSN = D.ESSN
WHERE   ISNULL(D.ESSN)
ORDER   BY E.FNAME;

-------------------------------------------------------------------------
-- Q18. 자녀가 있는 사원에 대해, 부양가족 수를 구하시오. 출력 컬럼은 사원의 이름과		-
-- 		부양가족수(NumOfDependents) 순으로 나열하시오. 실행 결과는 이름 중 Fname의	-
-- 		오름차순으로 나타내시오.												-
-------------------------------------------------------------------------

SELECT  E.FNAME, E.MINIT, E.LNAME, COUNT(E.SSN)
FROM    EMPLOYEE E JOIN DEPENDENT D ON E.SSN = D.ESSN
WHERE   E.SSN IN (SELECT    ESSN
                  FROM      DEPENDENT
                  WHERE     RELATIONSHIP = "Daughter" or RELATIONSHIP = "Son")
GROUP	BY E.SSN
ORDER	BY E.FNAME;

-- ----------------------------------------------------------------------
-- Q19. 각 부서에 대해, 부서의 위치와 같은 곳에서 진행되는 프로젝트를 검색하시오.			-
-- 		출력 컬럼은 부서 명칭, 부서 위치. 프로젝트 명칭, 프로젝트 위치 순으로 나열하며	-
-- 		실행 결과는 부서 명칭과 프로젝트 명칭의 오름차순으로 나타내시오.				-
-- ----------------------------------------------------------------------

SELECT	D.DNAME, L.DLOCATION, P.PNAME, P.PLOCATION
FROM	DEPARTMENT D JOIN DEPT_LOCATIONS L ON D.DNUMBER = L.DNUMBER
		JOIN PROJECT P ON P.DNUM = D.DNUMBER AND P.PLOCATION = DLOCATION
ORDER 	BY D.DNAME, P.PNAME;





