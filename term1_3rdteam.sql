SELECT * FROM elecar_parking.charging_station WHERE ADRES LIKE ('세종%');
SELECT * FROM elecar_parking.charging_station WHERE ADRES LIKE ('%수원시%');

SELECT *
   FROM 
   (SELECT * 
      FROM charging_station
      WHERE objt_id IN (
         SELECT min(c1.objt_id)
         FROM charging_station c1
         INNER JOIN charging_station c2 USING(x,y) 
         group by x, y)
   ) as c3
   JOIN (SELECT objt_id, count(objt_id) as "주차장별_충전소_갯수" FROM elecar_parking.charging_station GROUP BY STAT_ID) as c4 
    USING(STAT_ID);

SELECT OBJT_ID, STAT_NM, ADRES, '주차장별_충전소_갯수',　STAT_NM, 
   FROM 
   (SELECT * 
      FROM charging_station
      WHERE objt_id IN (
         SELECT min(c1.objt_id)
         FROM charging_station c1
         INNER JOIN charging_station c2 USING(x,y) 
         group by x, y)
   ) as c3
   JOIN (SELECT parkinglot_id, count(objt_id) as "주차장별_충전소_갯수" FROM elecar_parking.charging_station GROUP BY parkinglot_id) as c4 
    USING(parkinglot_id);
    
SELECT * FROM charging_station;    
    
SELECT * FROM charging_station WHERE STAT_NM = '종로구보건소';
SELECT STAT_NM, COUNT(*) as row_count FROM charging_station GROUP BY STAT_NM;

SELECT STAT_NM, ADRES, COUNT(*) as row_count FROM charging_station GROUP BY STAT_ID;

SELECT STAT_NM, ADRES, is_24h, COUNT(*) as row_count FROM charging_station GROUP BY STAT_NM;

Select * FROM charging_station WHERE latitude > 100000.000;

SELECT COUNT(t.row_count)
	FROM (SELECT COUNT(*) as 'row_count' 
	FROM charging_station 
    -- WHERE ADRES LIKE '입력한주소문자열'
    GROUP BY STAT_NM) as t;
    
-- 기본
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    -- WHERE ADRES LIKE '입력한주소문자열'
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;

-- 1. 24시간 여부 X, 공영주차장 여부 X
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 0 AND STAT_NM NOT LIKE '%공영주차장' AND ADRES LIKE '입력한주소문자열' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;
    
-- 예
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 0 AND STAT_NM NOT LIKE '%공영주차장' AND ADRES LIKE '경기%수원%' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;

-- 2. 24시간 여부 X, 공영주차장 여부 O
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 0 AND STAT_NM LIKE '%공영주차장' AND ADRES LIKE '입력한주소문자열' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;
    
-- 예
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 0 AND STAT_NM LIKE '%공영주차장' AND ADRES LIKE '경기%수원%' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;
    
-- 3. 24시간 여부 O, 공영주차장 여부 X
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 1 AND STAT_NM NOT LIKE '%공영주차장' AND ADRES LIKE '입력한주소문자열' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;
    
-- 예
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 1 AND STAT_NM NOT LIKE '%공영주차장' AND ADRES LIKE '경기%수원%' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, y;
    
-- 4. 24시간 여부 O, 공영주차장 여부 O
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 1 AND STAT_NM LIKE '%공영주차장' AND ADRES LIKE '입력한주소문자열' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;
    
-- 예
SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count 
	FROM charging_station 
    WHERE is_24h = 1 AND STAT_NM LIKE '%공영주차장' AND ADRES LIKE '경기%수원%' 
    GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude;