from django.db.models import Q
from rest_framework import generics, permissions, response, viewsets
from .models import UserQuestionHistory
from .models import Player
from .models import Question
from .models import Answer
from .models import Result
from .serializers import QuestionListSerializer
from .serializers import AnswerListSerializer
from .serializers import PlayerListSerializer
from rest_framework.response import Response


class QuestionView(viewsets.ModelViewSet):
	"""
	A simple ViewSet for view, edit and delete Transactions.
	"""
	queryset = Question.objects.all()
	serializer_class = QuestionListSerializer
	# permission_classes = [permissions.IsAuthenticated] #this permission we need to be sure that only permited user can use this url


class AnswerView(generics.GenericAPIView):
	"""
	A simple ViewSet for view, edit and delete Transactions.
	"""
#	queryset = Answer.objects.all()
	serializer_class = AnswerListSerializer
	permission_classes = [permissions.IsAuthenticated] #this permission we need to be sure that only permited user can use this url

	def post(self, request, *args, **kwargs):
		"""
		1- we have to serilaizer the request 
		2- get question correct answer by request.question_id
		"""
		# we have to serilaizer the request
		serializer = self.get_serializer(data=request.data)
		serializer.is_valid(raise_exception=True)

		# get question correct answer by request.question_id
		question_id = request.POST['questionid']
		obj_question = Question.objects.get(pk=question_id)
		answer = serializer.save()  # save data in db

		# we will update the is_correct field if 'user answer' is same / correct "question answer"
		if request.POST['answer_text'] == obj_question.correct_answer:
			answer.is_correct = True
			answer.save()  # To save the answer in db
			username = self.request.user
		
			#PlayerView.as_view()(serializer, username, *args, **kwargs )
			#p.post(self, request, username) 
			# getting current user
			#username = request.POST['username']
			obj_player = Player.objects.get_or_create(user=username)
			print("ttttttttttttttttttttttttttttt")
			print(obj_player)
			obj_player.score += 1
			obj_player.save()

		return Response({
			"answer" : AnswerListSerializer(answer, context=self.get_serializer_context()).data,
		})
			
		 		 
class PlayerView(generics.GenericAPIView):
	"""
	A simple ViewSet for view, edit and delete Transactions.
	"""
	#queryset = Player.objects.all()
	serializer_class = PlayerListSerializer
	permission_classes = [permissions.IsAuthenticated]
	print("test")

	def post(self, request, *args, **kwargs):
		print("psostddddddddddddddddd")
		
		# we have to serilaizer the request
		serializer = self.get_serializer(data=request.data)
		serializer.is_valid(raise_exception=True)
		#print(player)
		#print(username)
		#obj_player = Player.objects.get_or_create(user=username)
		question_id = request.POST['questionid']
		obj_question = Question.objects.get(pk=question_id)
		answer = serializer.save()  # save data in db

		# we will update the is_correct field if 'user answer' is same / correct "question answer"
		if request.POST['answer_text'] == obj_question.correct_answer:
			print("hello")
			answer.is_correct = True
			answer.save()
			username = request.POST['username']
			obj_player = Player.objects.get_or_create(user=username)
			obj_player.score += 1
			obj_player.save()
		
		return Response({
			"answer" : AnswerListSerializer(answer, context=self.get_serializer_context()).data,
		})
		