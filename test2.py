import pymysql
import streamlit as st
from streamlit_folium import folium_static
import folium
from folium.plugins import MarkerCluster
import pandas as pd
from datetime import datetime

sql = "SELECT STAT_NM, ADRES, if(is_24h = 1, 'O', 'X') as '24시간여부', latitude, longitude, COUNT(*) as row_count FROM charging_station WHERE ADRES LIKE '서울시_금천구%' GROUP BY STAT_NM, ADRES, is_24h, latitude, longitude" 
with pymysql.connect(host="192.168.0.37", port=3306, user='project1', password='1111', db='elecar_parking') as conn:
    with conn.cursor() as cursor:

        result = cursor.execute(sql)
        print("조회행수:", result)
        resultset = cursor.fetchall()
        for index, i in enumerate(resultset, start=1):
            print("result:", index, i)

# states = gpd.read_file(file_path)
# states.head()
st.title("아 이제 추워요")
# save_dir = "daum_news_list"
# d = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
# file_path = "daum_news_list/2025-10-23-12-20-46.csv"

df = resultset

st.dataframe(df, height=200)

df[["lat","lon"]] = df[["X","Y"]]

m = folium.Map(location=[37.4562557, 126.7052062], zoom_start=13)

marker_cluster = MarkerCluster().add_to(m)

a = 0;
b = 0;

for idx, row in df.iterrows():
    # popup_text = f"<b>{row['STAT_NM']}</b><br>{row['OBJT_ID']}"
    folium.Marker(
        location=[row["lat"], row["lon"]],
        popup=folium.Popup(popup_text, max_width=200)
    ).add_to(marker_cluster)

folium_static(m)

