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
        stage('check env') {
          steps {
            sh 'mvn -v'
          }
        }
        stage('') {
          steps {
            sh 'java -version'
          }
        }
      }
    }
    stage('test') {
      parallel {
        stage('test') {
          steps {
            sh 'mvn test'
          }
        }
        stage('coverage') {
          steps {
            sh 'mvn cobertura:cobertura'
          }
        }
      }
    }
    stage('report') {
      parallel {
        stage('report') {
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