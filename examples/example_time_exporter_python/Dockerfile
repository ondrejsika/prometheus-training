FROM python:3.13-slim
RUN pip install pipenv
WORKDIR /app
COPY Pipfile Pipfile.lock ./
RUN pipenv install --deploy --ignore-pipfile
COPY main.py .
CMD ["pipenv", "run", "python", "main.py"]
EXPOSE 8000
