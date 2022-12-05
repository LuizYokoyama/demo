pipeline {

  environment {
    dockerimagename = "disconhecido/demotest"
    dockerImage = ""
    gradle = tool 'gradle'
  }

  agent any


  stages {

    stage('Checkout Source') {
      steps {
        git branch: 'master', url: 'https://github.com/LuizYokoyama/demo.git'
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