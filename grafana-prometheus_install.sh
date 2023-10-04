# Create NFS directories
sudo mkdir -p /srv/nfs/k8s/grafana-prometheus-pv/grafana
sudo chown nobody:nogroup /srv/nfs/k8s/grafana-prometheus-pv/grafana
sudo chmod 777 /srv/nfs/k8s/grafana-prometheus-pv/grafana
sudo mkdir -p /srv/nfs/k8s/grafana-prometheus-pv/prometheus
sudo chown nobody:nogroup /srv/nfs/k8s/grafana-prometheus-pv/prometheus
sudo chmod 777 /srv/nfs/k8s/grafana-prometheus-pv/prometheus


kubectl create namespace grafana-prometheus

kubectl apply -f grafana-pv-pvc.yml
kubectl apply -f prometheus-pv-pvc.yml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install grafana grafana/grafana --namespace grafana-prometheus --set persistence.enabled=true --set persistence.existingClaim=grafana-pvc --set service.type=NodePort --set service.nodePort=31111
helm install prometheus prometheus-community/prometheus --namespace grafana-prometheus --set server.persistence.enabled=true --set server.persistence.existingClaim=prometheus-pvc --set server.service.type=NodePort --set server.service.nodePort=31112

# Wait for all pods in all namespaces to be running
while true; do
  for ns in $(kubectl get namespaces -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'); do
    for pod in $(kubectl get pods -n $ns -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'); do
      total=$(kubectl get pod $pod -n $ns -o=jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' | wc -l)
      running=$(kubectl get pod $pod -n $ns -o=jsonpath='{range .status.containerStatuses[*]}{.state.running}{end}' | grep -c true)
      if [[ $total -ne $running ]]; then
        for i in $(seq 0 3); do
          echo -ne "\r[${animation:$i:1}]"
          sleep 0.1
          done
        echo -e "\033[33m---\033[0m"
        echo -e "\033[33mWaiting for all containers to be running in pod $pod in namespace $ns \033[0m"
        sleep 1
      fi
    done
  done
  sleep 10
  echo -e "\e[32mAll pods are ready!\e[0m"
  break
done

kubectl get svc grafana
kubectl get svc prometheus-server

kubectl get secret --namespace grafana-prometheus grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo