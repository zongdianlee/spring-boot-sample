build-docker-env:
	docker build -t agileworks/maven dockers/maven

build-docker-prod-image:
	docker build -t agileworks/java_sample_prod .

deploy-production:
	- ssh jenkins@localhost docker rm -f java_sample_prod
	ssh jenkins@localhost docker run -d --name java_sample_prod -p 8800:8000 agileworks/java_sample_prod
