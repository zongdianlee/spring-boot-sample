start-docker-registry:
	- docker run -d -p 5000:5000 --name registry registry:2


build-docker-env:
	docker build -t localhost:5000/maven dockers/maven

build-docker-prod-image:
	docker build -t localhost:5000/java_sample_prod .

deploy-production-local:
	docker run -d --name java_sample_prod -p 8800:8000 localhost:5000/java_sample_prod


deploy-production-ssh:
	- ssh jenkins@localhost docker rm -f java_sample_prod
	ssh jenkins@localhost docker run -d --name java_sample_prod -p 8800:8000 localhost:5000/java_sample_prod

deploy-default:
	ssh jenkins@localhost mkdir -p deploy/release
	scp target/spring-boot-sample-data-rest-0.1.0.jar jenkins@localhost:deploy/release
	- ssh jenkins@localhost 'kill `cat deploy/release/run.pid`'
	ssh jenkins@localhost 'java -jar deploy/release/spring-boot-sample-data-rest-0.1.0.jar > /dev/null 2>&1 & echo $$! > "deploy/release/run.pid"'
