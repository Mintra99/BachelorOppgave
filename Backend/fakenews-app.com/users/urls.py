from django.conf.urls import url
from django.urls import path, include
from .api import RegisterApi, UserLogoutAll, CustomTokenObtainPairView
from rest_framework_simplejwt import views as jwt_views


urlpatterns = [
    path('register', RegisterApi.as_view()),
    # path('login/', jwt_views.TokenObtainPairView.as_view(), name='api_login'),
    # Custom login
    path('login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', jwt_views.TokenRefreshView.as_view(), name='token_refresh'),
    path('logout/', UserLogoutAll.as_view(), name='logout'),
]
