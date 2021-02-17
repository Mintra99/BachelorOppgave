# app_api

## To run the app on docker:
- Clone the repo to your local
- cd into folder.
- Create .env file ---> You can copy .env.example then rename and edit it.
- Run the following command `docker-compose up --build -d`
- To check the status of the running containers, run the following command `docker ps -a`
- To get inside the "web" docker container using this: `docker exec -u 0 -it Container_ID bash`

- To create super user inside docker `./manage.py createsuperuser`

- Make migrations: `./manage.py makemigrations` 
- Migrate: `./manage.py migrate`

- Run the server like that: `./manage.py runserver` or restart the "api" container.


## Steps I used:
- Create project: `django-admin startproject ProjectName`
- `pip3 install djangorestframework markdown django-filter djangorestframework_simplejwt`
- Generate requirements file: `pip3 freeze > requirements.txt`
- Update settings file with database settings.
- Added users app `./manage.py startapp users`
- Added questionnaire app `./manage.py startapp questionnaire`
