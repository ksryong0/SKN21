SELECT round(
	avg(
		CASE 
			WHEN length <= 10 THEN length = 10
            WHEN length > 10 THEN length = length
		END
	),
    3) AVERAGE_LENGTH
    FROM FISH_INFO;
    
SELECT round(avg(if(length<=10, 10, length)),2) AVERAGE_LENGTH
    FROM FISH_INFO;
    
SELECT round(avg(if(length>10, length, 10)), 2) AVERAGE_LENGTH
    FROM FISH_INFO;

SELECT avg(if(length>10, length, 10)) FROM FISH_INFO; -- if 조건에서 거짓이면 값이 null인 경우도 포함
SELECT if(length<=10, 10, length) FROM FISH_INFO; -- if 조건에서 참인 경우에는 null은 미포함. 참 거짓 둘다 NULL은 미포함