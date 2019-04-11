#!/usr/bin/env groovy

pipeline {
    environment{
        REGISTRY=sh returnStdout: true, script: 'echo -n "${REGISTRY:=local/py}"'
        GIT_DEPLOY=sh returnStdout: true, script: 'echo -n "${GIT_DEPLOY=https://github.com/froggy777/py-deploy.git}"'
        GIT_CODE=sh returnStdout: true, script: 'echo -n "${GIT_CODE=https://github.com/froggy777/py.git}"'
        IMAGE_TAG = "${RELEASE_NAME}-${BUILD_ID}"
        KUBE_CONFIG=sh returnStdout: true, script: 'echo -n "${KUBE_CONFIG=~/.kube/config-test-192.168.65.176}"'
        ENV_VALUE_FILE=sh returnStdout: true, script: 'echo -n "${ENV_VALUE_FILE=dev-values.yaml}"'
        RELEASE_NAME=sh returnStdout: true, script: 'echo -n "${RELEASE_NAME=dev-py}"'
        REGISTRY_CRED=sh returnStdout: true, script: 'echo -n "${REGISTRY_CRED=ecr:eu-central-1:registry}"'
        AWS_ECR_CRED_ID=sh returnStdout: true, script: 'echo -n "${AWS_ECR_CRED_ID=aws-ecr-id}"'
        REPO_CRED=sh returnStdout: true, script: 'echo -n "${REPO_CRED=repo-cred-id}"'
    }
    agent {
        node {
            label 'master'
        }
    }
    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }
    parameters {
        gitParameter branchFilter: 'origin.*/(.*)', defaultValue: 'master', name: 'BRANCH_DEPLOY', type: 'PT_BRANCH', useRepository: env.GIT_DEPLOY
        gitParameter branchFilter: 'origin.*/(.*)', defaultValue: 'master', name: 'BRANCH_PY', type: 'PT_BRANCH', useRepository: env.GIT_CODE
    }
    stages {
        stage('SCMs checkout') {
            parallel {
                stage('deploy') {
                    steps {
                        git branch: '$BRANCH_DEPLOY', url: env.GIT_DEPLOY, credentialsId: env.REPO_CRED
                    }
                }
                stage('py') {
                    steps {
                        dir ('src/') {
                            git branch: '$BRANCH_PY', url: env.GIT_CODE, credentialsId: env.REPO_CRED
                        }
                    }
                }
            }
        }
        stage('BUILD') {
            parallel {
                stage('build and push py') {
                    steps {
                        script {
                            sh "env"
                            docker.withRegistry('https://' + env.REGISTRY, env.REGISTRY_CRED) {
                                def DockerImagePy = docker.build("${REGISTRY}:${IMAGE_TAG}", "-f Dockerfile .")
                                DockerImagePy.push()
                            }
                        }
                    }
                }
            }
        }
        stage('Deploy'){
            steps {
                dir('helm'){
                    script {
                            sh "envsubst < ${ENV_VALUE_FILE} | helm --kubeconfig ${KUBE_CONFIG} upgrade ${RELEASE_NAME} . --install --reset-values --wait --timeout 900 -f - --namespace default"
                    }
                }
            }
        }
    }
}
