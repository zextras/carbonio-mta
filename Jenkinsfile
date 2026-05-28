library(
    identifier: 'jenkins-lib-common@v2.8.8',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        credentialsId: 'jenkins-integration-with-github-account',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
    ])
)

properties(defaultPipelineProperties())

pipeline {
    agent {
        node {
            label 'zextras-v1'
        }
    }

    environment {
        ARTIFACTORY_ACCESS=credentials('artifactory-jenkins-gradle-properties-splitted')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        skipDefaultCheckout()
        timeout(time: 3, unit: 'HOURS')
    }



    stages {
        stage('Setup') {
            steps {
                checkout scm
                script {
                    gitMetadata()
                }
                stash includes: '**', name: 'staging'
            }
        }

        stage('Publish docker images') {
            steps {
                dockerStage([
                    dockerfile: 'docker/mta/Dockerfile',
                    imageName: 'carbonio-mta',
                    ocLabels: [
                        title: 'Carbonio MTA',
                        descriptionFile: 'docker/mta/description.md',
                    ],
                    platforms: ['linux/amd64'] as Set,
                ])
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo 'Building deb/rpm packages'
                buildStage([
                    buildFlags: ' -ds '
                ])
            }
        }

        stage('Upload artifacts') {
            tools {
                jfrog 'jfrog-cli'
            }
            steps {
                uploadStage()
            }
        }
    }
}
