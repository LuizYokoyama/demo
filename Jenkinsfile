pipeline {

  environment {
    dockerimagename = "disconhecido/demotest"
    dockerImage = ""
    gradle = tool 'gradle'
  }

  agent any


  stages {

    stage('Pull Source from git') {
      steps {
        git branch: 'master', url: 'https://github.com/LuizYokoyama/demo.git'
      }
    }

    stage('Flyway MIGRATES') {
      steps {
        flywayrunner commandLineArgs: '', credentialsId: 'postgres', flywayCommand: 'info', installationName: 'flyway-test', locations: 'filesystem:/var/lib/jenkins/workspace/demotest/migrates', url: 'jdbc:postgresql://172.17.0.3:5432/postgres'
      }
    }

    stage('gradle') {
      steps {
        sh "chmod +x gradlew"
        sh "./gradlew bootjar"
      }
    }

    stage('Build image') {
      steps{
        script {
          dockerImage = docker.build dockerimagename
        }
      }
    }



    stage('Pushing Image') {
      environment {
               registryCredential = 'login_DockerHub'
           }
      steps{
        script {
          docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {
            dockerImage.push('lastest')
          }
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
          kubernetesDeploy (configs: 'deploymentservice.yml', kubeconfigId: 'Kubernetes')
      }
    }



  }

}