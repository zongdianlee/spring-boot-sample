pipeline {
  agent any
  stages {
    stage('checkout project') {
      steps {
        checkout scm
      }
    }
    stage('check env') {
      parallel {
        stage('check mvn') {
          steps {
            sh 'mvn -v'
          }
        }
        stage('check java') {
          steps {
            sh 'java -version'
          }
        }
      }
    }

    stage('test') {
      steps {
        sh 'mvn test cobertura:cobertura'
      }
    }      
    stage('report') {
      parallel {
        stage('junit') {
          steps {
            junit '**/target/surefire-reports/TEST-*.xml'
          }
        }
        stage('coverage') {
          steps {
            cobertura(coberturaReportFile: 'target/site/cobertura/coverage.xml')
          }
        }
      }
    }
    stage('package') {
      steps {
        sh 'mvn package'
      }
    }    
    stage('Artifact') {
      steps {
        archiveArtifacts(artifacts: '**/target/*.jar', fingerprint: true)
      }
    }
    stage('deploy') {
      steps {
        sh 'make deploy-default'
      }
    }
  }
}