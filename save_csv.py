import pymysql
import os
from datetime import datetime
import pandas as pd


# 셀렉트 쿼리
sql = "SELECT * FROM (SELECT * FROM charging_station WHERE objt_id IN (SELECT min(c1.objt_id) FROM charging_station c1 INNER JOIN charging_station c2 USING(x,y) group by x, y)) as c3 JOIN (SELECT parkinglot_id, count(objt_id) as 'charger_count' FROM elecar_parking.charging_station GROUP BY parkinglot_id) as c4 USING(parkinglot_id)" 
with pymysql.connect(host="192.168.0.37", port=3306, user='project1', password='1111', db='elecar_parking') as conn:
    with conn.cursor() as cursor:
        result = cursor.execute(sql)
        print("조회행수:", result)
        resultset = cursor.fetchall()

# csv 저장
if __name__ == "__main__":
    result = resultset
    # print(result)

    # 저장할 디렉토리를 생성
    save_dir = "daum_news_list"
    os.makedirs(save_dir, exist_ok=True)  # dir 생성

    # # 저장할 파일명 - 특정 기간마다 크롤링 수행할 경우 실행 날짜/시간을 이용해서 만들어 준다.
    d = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
    # print(d)
    file_path = f"{save_dir}/{d}.csv"
    # # DataFrame 생성
    result_df = pd.DataFrame(result, columns=['parkinglot_id', 'OBJT_ID', 'CHGER_ID', 'STAT_NM', 'CHGER_TY', 'USE_TM', 'ADRES', 'RN_ADRES', 'CTPRVN_CD', 'SGG_CD', 'EMD_CD', 'BUSI_NM', 'TELNO', 'X', 'Y', 'charger_count'])
    # # csv 파일로 저장.
    result_df.to_csv(file_path, index=False)
    print(file_path);