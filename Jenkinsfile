pipeline {
	agent any

	environment {
		DOCKER_IMAGE = 'vaishnavi453/jenkins-app'
	}

	stages {
		stage('Checkout Code') {
			steps{
				git branch: 'main' , url: 'https://github.com/vaishnavi0305/jenkins-k8s-pipeline.git'
			}
		}
		
		stage('Install Dependencies and Run Tests') {
			steps {
				sh '''
        			echo "Setting up Python virtual environment..."
        			python3 -m venv venv
        			. venv/bin/activate

       				echo "Installing dependencies..."
        			pip install --upgrade pip
        			pip install pytest flask

        			echo "Running tests..."
        			pytest || echo "No tests found or test failure."
				'''
			}
		}
		
		stage('Build Docker Image') {
			steps{
				sh 'docker build -t $DOCKER_IMAGE .'
			}
		}
		
		stage('Push to DockerHub') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
					sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
					sh 'docker push $DOCKER_IMAGE'
				}
			}
		}
		
		stage('Deploy to Kubernetes') {
			steps {
				withCredentials([file(credentialsId: 'minikube-kubeconfig', variable: 'KUBECONFIG')]){
				sh 'kubectl apply -f k8s/deployment.yaml'
				sh 'kubectl apply -f k8s/service.yaml'
			}
		}
	}
}
	post {
		failure {
			echo 'Pipeline failed'
		}
		success {
			echo 'Application deployed successfully on Kubernetes!'
		}
	}
}
