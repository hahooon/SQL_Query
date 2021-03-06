-- Queries for kleague Sample Database
-- Version 1.0

USE kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE STADIUM;
DESCRIBE SCHEDULE;


-------------------------------------------
-- 1. DML : UPDATE 문
-------------------------------------------

-------------------------------------------
-- 1.1 INSERT 문
-------------------------------------------

SELECT	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '박%'
ORDER 	BY PLAYER_NAME;

INSERT 	INTO PLAYER (PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, HEIGHT, WEIGHT, BACK_NO) 
VALUES 	('2002007', '박지성', 'K07', 'MF', 178, 73, 7);

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '박%'
ORDER 	BY PLAYER_NAME;

------------------------------

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '이%'
ORDER 	BY PLAYER_NAME;

INSERT 	INTO PLAYER 
VALUES 	('2002010','이청용','K07','','BlueDragon','2002','MF','17',NULL, NULL,'1',180,69);

SELECT 	*
FROM 	PLAYER
WHERE 	PLAYER_NAME LIKE '이%'
ORDER 	BY PLAYER_NAME;


-------------------------------------------
-- 1.2 DELETE 문
-------------------------------------------

DELETE 	FROM PLAYER
WHERE 	PLAYER_ID = '2002007';

DELETE 	FROM PLAYER
WHERE 	PLAYER_ID = '2002010';

------------------------------

DELETE 	FROM PLAYER;		/* Turn off 'Safe Update Mode', and reconnect */
							/* 메뉴의 Edit - Preferences - SQL Editor - Other 수정 */
SELECT	*
FROM	PLAYER;


-------------------------------------------
-- 1.3 UPDATE 문
-------------------------------------------

SELECT	*
FROM	PLAYER;

UPDATE	PLAYER
SET	BACK_NO = 99
WHERE	PLAYER_ID = '2000001';

SELECT	*
FROM	PLAYER;

-----------------------------

UPDATE	PLAYER
SET	BACK_NO = 99;

SELECT	*
FROM	PLAYER;


-------------------------------------------
-- 2. SELECT 문
-------------------------------------------

-- Q1: SELECT 절

SELECT	PLAYER_ID, PLAYER_NAME, TEAM_ID, POSITION, BACK_NO, HEIGHT,	WEIGHT 
FROM 	PLAYER;

SELECT	* 
FROM	PLAYER;

-----------------------------

SELECT	DISTINCT POSITION 
FROM	PLAYER; 

SELECT	ALL POSITION 
FROM	PLAYER; 

SELECT	POSITION 
FROM	PLAYER; 


-- Q2: AS 절

SELECT	PLAYER_NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게 
FROM 	PLAYER;  

SELECT	PLAYER_NAME 선수명, POSITION 위치, HEIGHT 키, WEIGHT 몸무게 
FROM 	PLAYER;  

SELECT	PLAYER_NAME '선수 이름', POSITION '그라운드 포지션', HEIGHT 키, WEIGHT 몸무게 
FROM 	PLAYER;

-----------------------------

SELECT	PLAYER_NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게 
FROM 	PLAYER
WHERE	PLAYER_NAME = '김태호';

SELECT	PLAYER_NAME AS 선수명, POSITION AS 위치, HEIGHT AS 키, WEIGHT AS 몸무게 
FROM 	PLAYER
WHERE	선수명 = '김태호';						/* 에러 */


-- Q3: 산술연산자

SELECT 	PLAYER_NAME 이름, ROUND(WEIGHT/((HEIGHT/100)*(HEIGHT/100)),2) 'BMI 비만지수' 
FROM 	PLAYER;


-- Q4: 스트링 합성연산자

SELECT 	CONCAT(PLAYER_NAME, '선수,', HEIGHT, 'cm,', WEIGHT, 'kg') AS 체격정보 
FROM 	PLAYER;

SELECT	'MySQL' 'String' 'Concatenation';  /* 'MySQL String Concat' */

SELECT	'MySQL' PLAYER_NAME 'String' 'Concatenation';  /* 에러 */

-------------------------------------------
-- 3. SELECT 문 : WHERE 절
-------------------------------------------

-- Q5: 비교연산자

SELECT 	TEAM_ID, PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND 
		POSITION = 'MF' AND 
		HEIGHT >= 170 AND HEIGHT <= 180;
        
SELECT 	TEAM_ID, PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND 
		POSITION <> 'MF' AND 
		HEIGHT >= 170 AND HEIGHT <= 180;


-- Q6: IN 연산자 

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K02','K07'); 

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER 
WHERE 	(POSITION, NATION) IN (('MF','브라질'), ('FW', '러시아')); 

SELECT 	PLAYER_NAME, TEAM_ID, POSITION, NATION
FROM 	PLAYER 
WHERE 	POSITION IN ('MF', 'FW') AND NATION IN ('브라질', '러시아');


-- Q7: LIKE 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	POSITION LIKE 'MF';

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	PLAYER_NAME LIKE '장%';


-- Q8: BETWEEN a AND b 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	HEIGHT BETWEEN 170 AND 180;


-- Q9: NULL 연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, TEAM_ID 
FROM 	PLAYER 
WHERE 	POSITION = NULL;		/* 'POSITION = NULL'은 항상 FALSE를 리턴함 */ 

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, TEAM_ID 
FROM 	PLAYER 
WHERE 	POSITION IS NULL;


-- Q10: 논리연산자

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	(TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND
		POSITION = 'MF' AND 
		HEIGHT >= 170 AND HEIGHT <= 180;  

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K02','K07') AND
		POSITION = 'MF' AND 
		HEIGHT BETWEEN 170 AND 180;  


-- Q11: LIMIT 절 (MySQL만의 기능임)

SELECT 	PLAYER_NAME 
FROM 	PLAYER
LIMIT   5;


-------------------------------------------
-- 4. SELECT 문 : SQL 단일행 내장함수
-------------------------------------------

-------------------------------------------
-- 4.1 문자형, 숫자형, 날짜형, 변화형 함수
-------------------------------------------

-- Q12: 문자형 함수

SELECT 	LENGTH('SQL Expert') AS ColumnLength; 

SELECT 	PLAYER_ID, CONCAT(PLAYER_NAME, ' 축구선수') AS 선수명 
FROM 	PLAYER;


-- Q13: 숫자형 함수

SELECT 	ROUND(SUM(HEIGHT)/COUNT(*),1) AS '평균키(소수 둘째자리 올림)', 
		TRUNCATE(SUM(HEIGHT)/COUNT(*),1) AS '평균키(소수 둘째자리 버림)'
FROM 	PLAYER;


-- Q14: 날짜형 함수

SELECT 	SYSDATE() AS CurrentTime;

SELECT 	NOW() AS CurrentTime;

select sysdate() As sys, Now() as now;

-----------------------------

SELECT 	TIMESTAMP(NOW()) AS CurrentTimestamp,
		DATE(NOW()) AS CurrentDate,
		YEAR(NOW()) AS Year, 
		MONTH(NOW()) AS Month, 
        DAY(NOW()) AS Day,
        MONTHNAME(NOW()) AS MonthName,
        DAYNAME(NOW()) AS DayName,
        WEEKDAY(NOW()) AS Week,
		TIME(NOW()) AS CurrentTime,
        HOUR(NOW()) AS Hour,
        MINUTE(NOW()) AS Minute,
        SECOND(NOW()) AS Second;

SELECT	PLAYER_NAME, 
		YEAR(BIRTH_DATE) 출생년도, 
		MONTH(BIRTH_DATE) 출생월, 
        DAY(BIRTH_DATE) 출생일 
FROM	PLAYER;

SELECT	PLAYER_NAME, 
		EXTRACT(YEAR FROM BIRTH_DATE) 출생년도, 
		EXTRACT(MONTH FROM BIRTH_DATE) 출생월, 
        EXTRACT(DAY FROM BIRTH_DATE) 출생일
FROM	PLAYER;

-----------------------------

SELECT	PLAYER_NAME, 
		DATE_FORMAT(BIRTH_DATE, '%W %M %Y') as Date, 
		DATE_FORMAT(BIRTH_DATE, '%D %M %Y %H:%i:%S') as DateTime
FROM	PLAYER;

-----------------------------

SELECT	PLAYER_NAME, BIRTH_DATE
FROM	PLAYER
WHERE	BIRTH_DATE < SUBDATE(NOW(), INTERVAL 45 YEAR);

-----------------------------

SELECT 	ADDDATE('2019-03-29', INTERVAL 5 DAY), SUBDATE('2019-03-29', INTERVAL 5 DAY);

SELECT 	ADDTIME('12:00:00', '00:25:03'), SUBTIME('12:00:00', '00:25:03');

SELECT	TIMEDIFF('2019-03-29 14:20:00', '2019-03-01 12:00:00');	/* returned in TIME format */

SELECT	TIMESTAMPDIFF(DAY, '2019-01-01 00:00:00', '2019-03-01 12:00:00'); /* First parameter is a unit */


-- Q15: 변환형 함수

SELECT 	TEAM_ID, ZIP_CODE1, ZIP_CODE2, 
		CAST(ZIP_CODE1 AS UNSIGNED) + CAST(ZIP_CODE2 AS UNSIGNED) 우편번호합 
FROM 	TEAM;


-------------------------------------------
-- 4.2 CASE 문
-------------------------------------------

-- Q16: Simple case expression과 searched case expression

SELECT	PLAYER_NAME,
		CASE	POSITION
				WHEN 'FW'	THEN 'Forward'
                WHEN 'DF'	THEN 'Defense'
                WHEN 'MF'	THEN 'Mid-field'
                WHEN 'GK'	THEN 'Goal keeper'
                ELSE 'Undefined'
		END AS 포지션
FROM 	PLAYER;

SELECT	PLAYER_NAME,
		CASE	
				WHEN POSITION = 'FW'	THEN 'Forward'
                WHEN POSITION = 'DF'	THEN 'Defense'
                WHEN POSITION = 'MF'	THEN 'Mid-field'
                WHEN POSITION = 'GK'	THEN 'Goal keeper'
                ELSE '***********'
		END AS 포지션
FROM 	PLAYER;


-- Q17: 

SELECT	PLAYER_NAME,
		CASE	
				WHEN HEIGHT >= 185		THEN 'A'
				ELSE 	(
						CASE
								WHEN HEIGHT >= 175		THEN 'B'
                                ELSE 'C'
						END)
		END AS 그룹
FROM	PLAYER;


-------------------------------------------
-- 4.3 NULL 관련 함수
-------------------------------------------

-- Q18: COALESCE() 함수

SELECT	COALESCE(NULL, 1);

SELECT	COALESCE(NULL, NULL, NULL);

SELECT	PLAYER_NAME, 
		COALESCE(POSITION, '*****') AS POSITION, 
		COALESCE(HEIGHT, 0) AS HEIGHT
FROM	PLAYER
WHERE	TEAM_ID = 'K08';

-----------------------------

SELECT	PLAYER_NAME, E_PLAYER_NAME, NICKNAME, 
		COALESCE(E_PLAYER_NAME, NICKNAME) AS 별칭
FROM	PLAYER;

SELECT	PLAYER_NAME, E_PLAYER_NAME, NICKNAME,
		CASE	
				WHEN E_PLAYER_NAME IS NOT NULL 	THEN E_PLAYER_NAME
                ELSE	(
						CASE	
								WHEN NICKNAME IS NOT NULL	THEN NICKNAME
								ELSE NULL
						END) 
		END AS 별칭
FROM	PLAYER;


-- Q19: NULLIF() 함수

SELECT	TEAM_NAME, ORIG_YYYY, NuLLIF(ORIG_YYYY, 1983) AS NULLIF_1983
FROM	TEAM;

SELECT	TEAM_NAME, ORIG_YYYY, 
		CASE	
				WHEN ORIG_YYYY = '1983'		THEN NULL
                ELSE ORIG_YYYY
		END AS NULLIF_1983
FROM	TEAM;


-- Q20: IFNULL() 함수

SELECT	PLAYER_NAME, 
		IFNULL(POSITION, '*****') AS POSITION, 
		IFNULL(HEIGHT, 0) AS HEIGHT
FROM	PLAYER
WHERE	TEAM_ID = 'K08';


-- Q21: NULL 관련 함수: ISNULL()

SELECT 	PLAYER_NAME 선수명, POSITION, 
		CASE 	
				WHEN POSITION IS NULL	THEN '없음' 
				ELSE POSITION 
		END AS 포지션 
FROM 	PLAYER 
WHERE 	TEAM_ID = 'K08';

SELECT 	PLAYER_NAME 선수명, POSITION, 
		CASE 	
				WHEN ISNULL(POSITION)	THEN '없음' 
				ELSE POSITION 
		END AS 포지션 
FROM 	PLAYER 
WHERE 	TEAM_ID = 'K08';


-------------------------------------------
-- 5. SELECT 문 : GROUP BY, HAVING 절
-------------------------------------------

-- Q22: GROUP BY

SELECT 	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키 
FROM 	PLAYER 
GROUP 	BY POSITION
ORDER	BY 평균키 DESC;

SELECT 	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키, TEAM_ID
FROM 	PLAYER 
GROUP 	BY POSITION;			/* 이  문장은 MySQL에서는 에러가 아님. */

-- WHERE절을 이용한 GROUP BY 연산 --

SELECT	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키
From	Player
WHERE	POSITION = "GK" OR POSITION = "FW"
group 	by Position;

-- GROUP BY와 HAVING을 이용한 연산 --

SELECT	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키
From	Player
group 	by Position HAVING POSITION = "GK" OR 포지션 = "FW";

-- WHERE연산과 IN () 연산을 이용한 GROUP BY연산 --

SELECT	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키
From	Player
WHERE	POSITION IN ("FW", "GK")
group 	by Position;

-- GROUP BY 연산과 HAVING 과 IN() 연산을 이용 *HAVING 절 안에 그룹 조건식에는 별명이 사용가능하다. --

SELECT	POSITION 포지션, COUNT(*) 인원수, COUNT(HEIGHT) 키대상,
		MAX(HEIGHT) 최대키, MIN(HEIGHT) 최소키,
		ROUND(AVG(HEIGHT),2) 평균키
From	Player
group 	by Position HAVING 포지션 IN ("FW", "GK");



-- Q23: HAVING

SELECT	POSITION 포지션, ROUND(AVG(HEIGHT),2) 평균키 
FROM 	PLAYER 
GROUP 	BY POSITION   HAVING AVG(HEIGHT) >= 180;

-----------------------------

SELECT	COUNT(PLAYER_NAME) AS '동명이인의 인원수', PLAYER_NAME AS '선수 이름'
FROM	PLAYER
GROUP 	BY PLAYER_NAME
HAVING	COUNT(PLAYER_NAME) >= 2;

-----------------------------

SELECT 	TEAM_ID 팀아이디, COUNT(*) 인원수 
FROM 	PLAYER 
GROUP 	BY TEAM_ID  HAVING TEAM_ID IN ('K09', 'K02');

SELECT 	TEAM_ID 팀ID, COUNT(*) 인원수 
FROM 	PLAYER 
WHERE 	TEAM_ID IN ('K09', 'K02') 
GROUP 	BY TEAM_ID;


-- Q24: CASE 뮨과 GROUP BY의 활용 1 (팀별로 월별 선수들의 평균 키를 구하라.)

SELECT	PLAYER_NAME, TEAM_ID, MONTH(BIRTH_DATE) AS MONTH, HEIGHT	/* 1단계 */
FROM	PLAYER;

SELECT	PLAYER_NAME, TEAM_ID,										/* 2단계 */
		CASE MONTH(BIRTH_DATE) WHEN 1 THEN HEIGHT END M01,
        CASE MONTH(BIRTH_DATE) WHEN 2 THEN HEIGHT END M02,
		CASE MONTH(BIRTH_DATE) WHEN 3 THEN HEIGHT END M03,
        CASE MONTH(BIRTH_DATE) WHEN 4 THEN HEIGHT END M04,
        CASE MONTH(BIRTH_DATE) WHEN 5 THEN HEIGHT END M05,
        CASE MONTH(BIRTH_DATE) WHEN 6 THEN HEIGHT END M06,
        CASE MONTH(BIRTH_DATE) WHEN 7 THEN HEIGHT END M07,
        CASE MONTH(BIRTH_DATE) WHEN 8 THEN HEIGHT END M08,
        CASE MONTH(BIRTH_DATE) WHEN 9 THEN HEIGHT END M09,
        CASE MONTH(BIRTH_DATE) WHEN 10 THEN HEIGHT END M10,
        CASE MONTH(BIRTH_DATE) WHEN 11 THEN HEIGHT END M11,
        CASE MONTH(BIRTH_DATE) WHEN 12 THEN HEIGHT END M12,
        CASE MONTH(BIRTH_DATE) WHEN 'NULL' THEN HEIGHT END 생일모름
FROM	PLAYER;        

SELECT	TEAM_ID,													/* 3단계 */
		ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 1 THEN HEIGHT END),2) M01,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 2 THEN HEIGHT END),2) M02,
		ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 3 THEN HEIGHT END),2) M03,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 4 THEN HEIGHT END),2) M04,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 5 THEN HEIGHT END),2) M05,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 6 THEN HEIGHT END),2) M06,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 7 THEN HEIGHT END),2) M07,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 8 THEN HEIGHT END),2) M08,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 9 THEN HEIGHT END),2) M09,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 10 THEN HEIGHT END),2) M10,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 11 THEN HEIGHT END),2) M11,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 12 THEN HEIGHT END),2) M12,
        ROUND(AVG(CASE MONTH(BIRTH_DATE) WHEN 'NULL' THEN HEIGHT END),2) 생일모름
FROM	PLAYER
GROUP	BY TEAM_ID;
 
-- Q25: CASE 뮨과 GROUP BY의 활용 2 (팀별로 포지션별 인원수, 그리고 팀의 전체 인원수를 구하라.) 

SELECT	PLAYER_NAME, TEAM_ID, 
		CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END FW, 
		CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END MF,
		CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END DF,
		CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END GK,
        CASE WHEN POSITION IS NULL THEN 1 ELSE 0 END UNDECIDED
FROM 	PLAYER
ORDER   BY TEAM_ID;

SELECT	TEAM_ID, 
		SUM(CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END) FW, 
		SUM(CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END) MF,
		SUM(CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END) DF,
		SUM(CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END) GK,
        SUM(CASE WHEN POSITION IS NULL THEN 1 ELSE 0 END) UNDECIDED,	/* K08 팀을 확인할 것 */
        COUNT(*) SUM
FROM 	PLAYER
GROUP	BY TEAM_ID;

-----------------------------

SELECT	TEAM_ID, 
		SUM(CASE POSITION WHEN 'FW' THEN 1 ELSE 0 END) FW, 
		SUM(CASE POSITION WHEN 'MF' THEN 1 ELSE 0 END) MF,
		SUM(CASE POSITION WHEN 'DF' THEN 1 ELSE 0 END) DF,
		SUM(CASE POSITION WHEN 'GK' THEN 1 ELSE 0 END) GK,
        SUM(CASE POSITION WHEN 'NULL' THEN 1 ELSE 0 END) UNDECIDED,		/* POSITION = 'NULL' 은 항상 false */
        COUNT(*) SUM
FROM 	PLAYER
GROUP	BY TEAM_ID;


-------------------------------------------
-- 6. SELECT 문 : ORDER BY 절
-------------------------------------------

-- Q26: ORDER BY

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버 
FROM 	PLAYER 
ORDER 	BY 포지션 DESC; 				/** NULL이 가장 마지막에 위치함. */

SELECT 	PLAYER_NAME 선수이름, POSITION 포지션, BACK_NO 백넘버, HEIGHT 키 
FROM 	PLAYER 
WHERE 	HEIGHT IS NOT NULL 
ORDER 	BY HEIGHT DESC, BACK_NO; 

SELECT 	PLAYER_NAME 선수명, POSITION 포지션, BACK_NO 백넘버
FROM 	PLAYER 
WHERE 	BACK_NO IS NOT NULL 
ORDER 	BY 3 DESC, 2, 1; 


-- Q27: Top-n query

SELECT 	ROW_NUMBER() OVER (ORDER BY SEAT_COUNT DESC) AS ROW_NUM, /* alias로 ROW_NUMBER를 사용할 수 없음 */
		STADIUM_ID, STADIUM_NAME, SEAT_COUNT, 
		RANK() OVER (ORDER BY SEAT_COUNT DESC) AS SEAT_RANK	/* alias로 RANK를 사용할 수 없음 */ 
FROM 	STADIUM; 


-- Q28: LIMIT 절

SELECT	PLAYER_NAME, HEIGHT
FROM	PLAYER
ORDER	BY HEIGHT DESC
LIMIT	3;				/* LIMIT 0, 3; 과 같은 결과*/

SELECT	PLAYER_NAME, HEIGHT
FROM	PLAYER
ORDER	BY HEIGHT DESC
LIMIT	0, 3;			/* 0번째 부터 최대 3개 */

SELECT	PLAYER_NAME, HEIGHT
FROM	PLAYER
ORDER	BY HEIGHT DESC
LIMIT	1, 3;			/* 1번째 부터 최대 3개 */
