from django.urls import path, include
from . import api
from rest_framework import routers


router = routers.DefaultRouter()
router.register('question', api.QuestionView)


urlpatterns = [
    path('', include(router.urls)),
    path('answer/', api.AnswerView.as_view()),
    path('player/', api.PlayerView.as_view()),
   #  path('question/',include(router.urls)),
	# path("transaction/list/", TransactionListAPI.as_view()),
]
