from .models import UserQuestionHistory
from .models import Player
from .models import Question
from .models import Answer
from .models import Result
from rest_framework import serializers


class PlayerListSerializer(serializers.ModelSerializer):
	class Meta:
		model = Player
		fields = "__all__"


class QuestionListSerializer(serializers.ModelSerializer):
	class Meta:
		model = Question
		fields = "__all__"


class AnswerListSerializer(serializers.ModelSerializer):
	class Meta:
		model = Answer
		fields = "__all__"


class ResultListSerializer(serializers.ModelSerializer):
	class Meta:
		model = Result
		fields = "__all__"


class UserQuestionHistoryListSerializer(serializers.ModelSerializer):
	class Meta:
		model = UserQuestionHistory
		fields = "__all__"






