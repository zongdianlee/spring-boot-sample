pipeline {
    agent any
    stages {
        stage('checkout project') {
            steps {
                //git url: 'https://github.com/agileworks-tw/spring-boot-sample.git'
                checkout scm
            }
        }
        stage('check docker install and build env') {
            steps {
                sh "docker -v"
                sh "docker-compose -v"
                sh "docker ps"
            	sh "make start-docker-registry"
                sh "make build-docker-env"
            }
        }
        stage('test project and serve') {
            steps {
                sh "docker-compose run --rm test"
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar', fingerprint: true])
                sh "docker-compose up -d server"
            }
        }
        stage('wait for confirm') {
            input {
                message "Does staging at http://localhost:8000 look good?"
                ok "Deploy to production"
                submitter "admin"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }
            steps {
                echo "Hello, ${PERSON}, nice to meet you."

            }
            post { 
                always { 
                    sh "docker-compose stop server"
                }
            }
        }
        stage('deploy project') {
            when {
                branch 'master'
            }
            steps {
                sh "docker-compose run --rm package"
                sh "make build-docker-prod-image"
                sh "docker push localhost:5000/java_sample_prod"
                sh "make deploy-production-local"
            }
            
        }        
    }
}