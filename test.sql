ALTER TABLE charging_station ADD COLUMN  parkinglot_id int NOT NULL AFTER OBJT_ID;

SELECT * FROM elecar_parking.charging_station;

SELECT * 
   FROM charging_station
    WHERE objt_id IN (
      SELECT min(c1.objt_id)
         FROM charging_station c1
         INNER JOIN charging_station c2 USING(x,y) 
         group by x, y);
         
SELECT parkinglot_id, count(objt_id) FROM elecar_parking.charging_station GROUP BY parkinglot_id;

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
	JOIN (SELECT parkinglot_id, count(objt_id) as "주차장별_충전소_갯수" FROM elecar_parking.charging_station GROUP BY parkinglot_id) as c4 
    USING(parkinglot_id);

SELECT *
   FROM charging_station
    WHERE objt_id IN (
      SELECT min(c1.objt_id)
         FROM charging_station c1
         INNER JOIN charging_station c2 USING(x,y) 
         group by x, y);
         
-- 이게 맞나...쿼리가 너무 길어지는데...줄여주세요...
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
	JOIN (SELECT parkinglot_id, count(objt_id) as 'charger_count' FROM elecar_parking.charging_station GROUP BY parkinglot_id) as c4 
    USING(parkinglot_id);