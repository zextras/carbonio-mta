library(
    identifier: 'jenkins-packages-build-library@chore/IN-930',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-packages-build-library.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

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
        parallelsAlwaysFailFast()
        skipDefaultCheckout()
        timeout(time: 3, unit: 'HOURS')
    }

    parameters {
        booleanParam defaultValue: false,
            description: 'Whether to upload the packages in playground repositories',
            name: 'PLAYGROUND'
    }

    tools {
        jfrog 'jfrog-cli'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    gitMetadata() 
                }
                stash includes: '**', name: 'staging'
            }
        }
        
        stage('Publish containers - devel') {
            when {
                branch 'devel';
            }
            steps {
                container('dind') {
                    withDockerRegistry(credentialsId: 'private-registry', url: 'https://registry.dev.zextras.com') {
                        script {
                            dockerHelper.buildImage([
                                title: 'Carbonio MTA', 
                                descriptionFile: 'docker/mta/description.md',
                                dockerfile: 'docker/mta/Dockerfile', 
                                imageName: 'registry.dev.zextras.com/dev/carbonio-mta',
                                imageTags: 'latest'
                            ])
                        }
                    }
                }
            }
        }

        stage('Build deb/rpm') {
            steps {
                echo "Building deb/rpm packages"
                buildStage()
            }
        }

        stage('Upload artifacts')
        {
            steps {
               uploadStage(
                    packages: yapHelper.getPackageNames()
                )
            }
        }
    }
}
