# account/urls.py -> account app용 url conf

from django.urls import path
from . import views # 상대 경로로 import. `.` : 현재 모듈이 있는 패키지

app_name = "account" # 전체 설정에 대한 prefix(namespace). 
                   # 설정 name에 공통적으로 앞에 붙일 이름("app_name:name")
urlpatterns = [
    path("create", views.create, name="create"),
    path("detail", views.detail, name='detail'),
    path("login", views.user_login, name='login'),
    path("logout", views.user_logout, name='logout'),
    path("update", views.update, name='update'),
    path("password_change", views.password_change, name='password_change'),
]