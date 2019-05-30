-- DDL Test for kleague Sample Database
-- Version 1.0

USE kleague;

DESCRIBE PLAYER;
DESCRIBE TEAM;
DESCRIBE STADIUM;
DESCRIBE SCHEDULE;

SELECT 	SQL_MODE
FROM 	INFORMATION_SCHEMA.ROUTINEs;

-------------------------------------------
-- 1. CREATE TABLE - PK Constraint
-------------------------------------------

-- Q1: 키 값의 수정

SELECT 	* FROM TEAM;

UPDATE 	TEAM
SET		TEAM_ID = '***'
WHERE	TEAM_ID = 'K02';

SELECT 	* FROM TEAM;

-- Q2: PK constraint (Entity integrity constraint)

/* PK 제약조건 위반으로 실행이 거부됨 */
INSERT 	INTO TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES 	(NULL,'서울','국민대학교','KMU');

/* PK 제약조건 위반으로 실행이 거부됨 */
INSERT 	INTO TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES 	('K01','서울','국민대학교','KMU');


-------------------------------------------
-- 2.1 CREATE TABLE - FK Constraint : 자식 테이블에 FK 삽입/수정
-------------------------------------------

-- Q3: 존재하지 않는 FK 값 'KMU'을 자식 테이블에 insert/update할 때

/* FK 제약조건 위반으로 실행이 거부됨 */
INSERT 	INTO TEAM (TEAM_ID, REGION_NAME, TEAM_NAME, STADIUM_ID) 
VALUES 	('K20','서울','국민대학교','KMU');

/* FK 제약조건 위반으로 실행이 거부됨 */
UPDATE 	TEAM
SET		STADIUM_ID = 'KMU'
WHERE	TEAM_ID = 'K03';


-------------------------------------------
-- 2.2 CREATE TABLE - FK Constraint - 부모 테이블에서 FK 삭제/수정 (RESTRICT인 경우)
-------------------------------------------

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, 
		REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM 	INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE	CONSTRAINT_SCHEMA = 'kleague'
ORDER   BY CONSTRAINT_NAME DESC;

-- 현재의 Referential option의 조합을 확인

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE	CONSTRAINT_SCHEMA = 'kleague';

-- Q4: 부모 테이블에서 PK 값을 delete할 때, RESTRICT 옵션에서는 부모 테이블에서 delete가 거부됨.

/* 부모 테이블 확인 */
SELECT 	* FROM STADIUM;

/* FK 제약조건 위반으로 실행이 거부됨 */
DELETE 	FROM STADIUM
WHERE 	STADIUM_ID = 'B05';

/* 자식 테이블인 TEAM에서 K09 팀의 전용구장이 B05임 */
SELECT 	* FROM TEAM;


-------------------------------------------
-- 2.3 CREATE TABLE - FK Constraint - 부모 테이블에서 FK 삭제/수정 (CASCADE인 경우)
-------------------------------------------

-- 아래 ALTER TABLE 할 때마다, 현재의 Referential option의 조합을 확인

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE	CONSTRAINT_SCHEMA = 'kleague';

-- Referential option의 조합을 변경함.

ALTER 	TABLE TEAM
DROP 	FOREIGN KEY FK_STADIUM_TEAM;

ALTER 	TABLE TEAM
ADD     CONSTRAINT 	FK_STADIUM_TEAM_NEW	FOREIGN KEY (STADIUM_ID) REFERENCES STADIUM(STADIUM_ID)
											ON DELETE CASCADE
											ON UPDATE CASCADE;

-- FK 제약조건에 따라, TEAM에서도 연속적으로 삭제가 실행되어야 하나, 실행이 거부됨. (Why ?)
DELETE	FROM STADIUM
WHERE 	STADIUM_ID = 'B05';

------------------------------

-- STADIUM과 연결된 모든 FK Constraint를 CASCADE로 변경함.

ALTER 	TABLE SCHEDULE
DROP 	FOREIGN KEY FK_STADIUM_SCHEDULE,
DROP 	FOREIGN KEY FK_HOMETEAM_SCHEDULE,
DROP 	FOREIGN KEY FK_AWAYTEAM_SCHEDULE;

ALTER 	TABLE PLAYER
DROP 	FOREIGN KEY FK_TEAM_PLAYER;

ALTER 	TABLE SCHEDULE
ADD     CONSTRAINT 	FK_STADIUM_SCHEDULE_NEW  FOREIGN KEY (STADIUM_ID) REFERENCES STADIUM(STADIUM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE,
ADD     CONSTRAINT 	FK_HOMETEAM_SCHEDULE_NEW FOREIGN KEY (HOMETEAM_ID) REFERENCES TEAM(TEAM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE,
ADD     CONSTRAINT 	FK_AWAYTEAM_SCHEDULE_NEW FOREIGN KEY (AWAYTEAM_ID) REFERENCES TEAM(TEAM_ID)
												ON DELETE CASCADE
												ON UPDATE CASCADE;

ALTER 	TABLE PLAYER
ADD     CONSTRAINT 	 FK_TEAM_PLAYER_NEW	FOREIGN KEY (TEAM_ID) REFERENCES TEAM(TEAM_ID)
											ON DELETE CASCADE
											ON UPDATE CASCADE;

------------------------------

-- Q5: 부모 테이블에서 PK 값을 delete할 때, CASCADE 옵션에서는 자식 테이블에도 delete가 연속적으로 실행되고, 전파됨.

SELECT 	* FROM STADIUM;
SELECT 	* FROM TEAM;
SELECT	* FROM PLAYER;
SELECT  * FROM SCHEDULE; 

SELECT 	COUNT(*) FROM STADIUM;		/* 20개 */				-- Aggregate function (집단 함수) : average, sum, count ...
SELECT 	COUNT(*) FROM TEAM;			/* 15개 */
SELECT 	COUNT(*) FROM SCHEDULE;		/* 179개 */
SELECT 	COUNT(*) FROM PLAYER;		/* 480명 */
SELECT	COUNT(*) FROM SCHEDULE WHERE STADIUM_ID = 'B05';	/* 서울월드컵경기장, 19개 */
SELECT	COUNT(*) FROM SCHEDULE WHERE HOMETEAM_ID = 'K09' OR AWAYTEAM_ID = 'K09';	/* 서울 FC, 36개 */
SELECT	COUNT(*) FROM PLAYER WHERE TEAM_ID = 'K09';		/* 서울 FC, 49 */

DELETE	FROM STADIUM
WHERE 	STADIUM_ID = 'B05';

SELECT 	COUNT(*) FROM STADIUM;		/* 19개 (1개 삭제됨)*/
SELECT 	COUNT(*) FROM TEAM;			/* 14개 (1개 삭제됨) */
SELECT 	COUNT(*) FROM SCHEDULE;		/* 143개 (179-36개 삭제됨) */
SELECT 	COUNT(*) FROM PLAYER;		/* 431명 (480-49개 삭제됨) */

------------------------------

-- Q6: 부모 테이블에서 PK 값을 update할 때, CASCADE 옵션에서는 자식 테이블에도 update가 연속적으로 실행됨. (전파되지는 않음)

SELECT 	* FROM STADIUM;
SELECT 	* FROM TEAM;

UPDATE	STADIUM
SET		STADIUM_ID = 'KWJ'
WHERE	STADIUM_ID = 'A02';

SELECT 	* FROM STADIUM;
SELECT 	* FROM TEAM;


-------------------------------------------
-- 2.4 CREATE TABLE - SELECT 문 이용 (CTAS)
-------------------------------------------

CREATE 	TABLE TEMP AS
SELECT	*
FROM	SCHEDULE
WHERE	HOMETEAM_ID = 'K08' OR AWAYTEAM_ID = 'K08';

SELECT	* FROM TEMP;

DROP	TABLE TEMP;


-------------------------------------------
-- 3. DROP TABLE
-------------------------------------------

-- MySQL에서 DROP TABLE의 RESTRICT|CASCADE는 아무 역할을 안함. 
-- 다른 DBMS에서의 포팅을 위해서만 사용됨.

DROP	TABLE STADIUM;		/* 디폴트는 RESTRICT임 */

DROP	TABLE STADIUM RESTRICT;

DROP	TABLE STADIUM CASCADE;


-------------------------------------------
-- 4. ALTER TABLE
-------------------------------------------

DESCRIBE PLAYER;

ALTER	TABLE PLAYER
ADD		ADDRESS VARCHAR(80);

DESCRIBE PLAYER;

ALTER	TABLE PLAYER
DROP	ADDRESS;

DESCRIBE PLAYER;


-------------------------------------------
-- 5. RENAME TABLE
-------------------------------------------

RENAME	TABLE STADIUM TO 경기장;

RENAME	TABLE 	TEAM TO 팀,
				SCHEDULE TO 경기,
                PLAYER TO 선수;


-------------------------------------------
-- 6. TRUNCATE TABLE
-------------------------------------------

-- 먼저 kleageDB를 원상태로 복구함.

DELETE	FROM PLAYER;	/* 로그에 기록을 남김 (복구 가능). 아래 메세지에서 '480 row(s) affected' */
SELECT	* FROM PLAYER;

-- 먼저 kleageDB를 원상태로 복구함.

TRUNCATE TABLE PLAYER;	/* 로그에 기록을 안 남김 (복구 불가). 아래 메세지에서 '0 row(s) returned' */
SELECT	* FROM PLAYER;

-- 먼저 kleageDB를 원상태로 복구함.

DROP 	TABLE PLAYER;	/* 테이블도 삭제함. */
SELECT	* FROM PLAYER;


-------------------------------------------
-- 7. INFORMATION_SCHEMA 테이블들
-------------------------------------------

SELECT 	*
FROM 	INFORMATION_SCHEMA.SCHEMATA;

------------------------------

SELECT 	*							-- Project 역할을 한다.
FROM 	INFORMATION_SCHEMA.TABLES;

SELECT 	*
FROM 	INFORMATION_SCHEMA.TABLES
WHERE	TABLE_SCHEMA = 'kleague';	-- Select 역할을 한다.

------------------------------

SELECT 	*
FROM 	INFORMATION_SCHEMA.COLUMNS;

SELECT 	*
FROM 	INFORMATION_SCHEMA.COLUMNS
WHERE	TABLE_SCHEMA = 'kleague' AND TABLE_NAME = 'schedule';

------------------------------

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, 
		REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM 	INFORMATION_SCHEMA.KEY_COLUMN_USAGE								-- 키의 정보를 담고 있는 Information Schemata의 테이블
WHERE	CONSTRAINT_SCHEMA = 'kleague' AND TABLE_NAME = 'schedule'
ORDER   BY CONSTRAINT_NAME DESC;

SELECT 	CONSTRAINT_SCHEMA, CONSTRAINT_NAME, DELETE_RULE, UPDATE_RULE, 
		TABLE_NAME, REFERENCED_TABLE_NAME
FROM 	INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS						-- 참조 제약을 담고있는 Information Schemata의 테이블
WHERE	CONSTRAINT_SCHEMA = 'kleague' AND TABLE_NAME = 'schedule';
