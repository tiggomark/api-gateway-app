#!groovy

PROJECT_NAME = "api-gateway-app"
PROJECT_KEY = "tiggomark"
SCM = "GITHUB"

def repositoryUrl = 'thomazaudio'

node {

   // def javaHome = tool 'java11'
    //env.PATH = "${javaHome}/bin:${env.PATH}"
   // env.JAVA_HOME = "${javaHome}"

    def branch = "master"
    def environment = "prod"
    def tagVersion = "dev"

    stage(name: 'Checkout from SCM') {
        echo 'Checking out from scm'
        checkout scm
    }

    stage(name: 'Gradle build') {
        echo 'Testing project'
        sh 'chmod +x gradlew'
        sh "./gradlew clean build --stacktrace"
    }

    stage(name: 'Build docker image') {
        echo 'Build docker image and push to registry'
            sh "docker login -u thomazaudio -p leghacy123"
            pomVersion = getVersion()
            if(environment == "qa") {
                sh "docker build -f ./Dockerfile --build-arg VERSION=$pomVersion --build-arg APP=$PROJECT_NAME -t ${repositoryUrl}/$PROJECT_NAME:$tagVersion ."
                echo "Build complete for version $pomVersion develop release...Upload image to Harbor"
                sh "docker push ${repositoryUrl}/$PROJECT_NAME:$tagVersion"
            } else {
                tagVersion = getVersion()
                echo "Initializing build release ${tagVersion}"
                sh "docker build -f ./Dockerfile --build-arg VERSION=$pomVersion --build-arg APP=$PROJECT_NAME -t ${repositoryUrl}/$PROJECT_NAME:$tagVersion -t ${repositoryUrl}/$PROJECT_NAME:latest ."
                echo "Build complete for version ${tagVersion} and latest release...Upload image to Harbor"
                sh "docker push ${repositoryUrl}/$PROJECT_NAME:$tagVersion && docker push ${repositoryUrl}/$PROJECT_NAME:$tagVersion"
            }

    }

    stage(name: 'Deploy to Docker Container') {
        echo 'Deploying images to docker container'
        //docker run --network cluster-network -p 8484:8484 --name customer-app -d customer-app:1.0.0
        sh "docker run --network cluster-network -p 8081:8081  -d  ${repositoryUrl}/$PROJECT_NAME:$tagVersion"
        echo "Deploy de ${PROJECT_NAME} para o ambiente ${environment} finalizado com sucesso"
        //sendMsgToSlack("Deploy de ${PROJECT_NAME} para o ambiente ${environment} finalizado com sucesso")
        //currentBuild.result = "SUCCESS"
    }

}



def sendMsgToSlack(text) {

/*
    try {
        build(job: "send-slack-message",
                parameters: [
                        string(name: "TITLE", value: "[${PROJECT_NAME}][${branch}]"),
                        string(name: "TITLELINK", value: env.BUILD_URL),
                        string(name: "TEXT", value: text),
                        string(name: "CHANNEL", value: "#podolsk-alerts")
                ]
        )
    } catch (all) {
        echo "Não foi possível enviar a mensagem para o canal #podolsk-alerts"
        echo "Error: ${all.message}"
    }
    */
}

def getVersion() {
    def lines = readFile("${env.WORKSPACE}/gradle.properties").split("\n")

    return lines.find { it.contains("version") }
            .split("=")[1]
            .trim()
}