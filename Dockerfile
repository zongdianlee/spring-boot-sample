FROM agileworks/java7_maven_dockerfile
COPY ./ /app
COPY ~/.m2 /root/.m2
EXPOSE 8000

WORKDIR /app
CMD /bin/bash -c 'cd data-rest && mvn spring-boot:run'
