import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import font_manager, rc

font_name = font_manager.FontProperties(fname="c:/Windows/Fonts/malgun.ttf").get_name()
rc('font', family=font_name)

df5 = pd.read_csv("C:\\Users\\Playdata\\Downloads\\parking.csv", encoding = 'euckr')
df6 = df5[['년도', '치킨집','커피음료','한식음식점']]
df6.set_index(['년도'], inplace = True)

plt.style.use('fivethirtyeight')
df6.plot.bar(figsize=(10,5), width = 0.5, fontsize = 15)
plt.title('년도별  폐업 건수', size = 20)
plt.show()