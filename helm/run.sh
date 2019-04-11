#!/bin/bash
#envsubst < ${ENV_VALUE_FILE} | helm upgrade ${RELEASE_NAME} . --install --force --no-hooks --reset-values --wait --timeout 900 --debug -f - --namespace ${NAMESPACE}
helm --kubeconfig /home/sfreydin/.kube/config.65.176  upgrade prod-py . --install --force --no-hooks --reset-values -f prod-values.yaml --namespace default
helm --kubeconfig /home/sfreydin/.kube/config.65.176  upgrade stage-py . --install --force --no-hooks --reset-values -f stage-values.yaml --namespace default
helm --kubeconfig /home/sfreydin/.kube/config.65.176  upgrade dev-py . --install --force --no-hooks --reset-values -f dev-values.yaml --namespace default
