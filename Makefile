install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

lint:
	pylint --disable=R,C *.py devopslib
	
test:
	python -m pytest -vv --cov=devopslib test_*.py 

format:
	black *.py devopslib/*.py
	
post-install:
	python -m textblob.download_corpora

deploy:
	#deploy
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 803287462269.dkr.ecr.us-east-1.amazonaws.com
	docker build -t devops-march-2023 .
	docker tag devops-march-2023:latest 803287462269.dkr.ecr.us-east-1.amazonaws.com/devops-march-2023:latest
	docker push 803287462269.dkr.ecr.us-east-1.amazonaws.com/devops-march-2023:latest

all: install post-install lint test format deploy