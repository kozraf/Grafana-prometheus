
# Prometheus & Grafana Deployment on Kubernetes

This repository provides scripts and configuration files to set up Prometheus and Grafana on a Kubernetes cluster using NFS storage.

## Introduction

Prometheus, an open-source systems monitoring and alerting toolkit, together with Grafana, a platform for monitoring and observability, are combined in this deployment to offer a robust monitoring solution on Kubernetes. Utilizing NFS storage, this deployment ensures persistent storage for metrics and dashboards, enhancing the resilience and reliability of the monitoring infrastructure.

## Versions 1.0
### v1.0
- Initial setup with NFS storage configurations.
- Added Persistent Volumes and Persistent Volume Claims for Grafana and Prometheus components.

## Features

- **NFS Integration**: Ensures data persistency across pod restarts.
- **Scalable Architecture**: Separate Persistent Volumes for Grafana, Prometheus Alertmanager, and Prometheus Server.
- **Automated Setup**: The included shell script automates the setup of necessary directories and permissions.

## Requirements 

- **K8 cluster**
- **Helm**
- **NFS storage**

Dont forget to check my https://github.com/kozraf/RafK8clstr - deploying:
- K8 with NFS storage
- K8 Dashboard
- Helm
- K8 metric-server
- Jenkins-with-TF
- ArgoCD
- Grafana & Prometheus
#### with few clicks! ;)

## Installation

### 1. Deploy Persistent Volumes and Persistent Volume Claims

Apply the PV and PVC configurations using `kubectl`:

```bash
$ kubectl apply -f grafana-pv-pvc.yml
$ kubectl apply -f prometheus-pv-pvc.yml
```

### 2. Set Up NFS Directories and deploy both Grafana & Prometheus using helm charts 

Run the `grafana-prometheus_install.sh` script to:
- Create NFS directories for Grafana, Prometheus, Prometheus Alertmanager, and Prometheus Server.
- Set the appropriate owner and permissions for these directories.
- Deploy deplou both Grafana & Prometheus

```bash
$ chmod +x grafana-prometheus_install.sh
$ ./grafana-prometheus_install.sh
```

## How to test it

1. Ensure Prometheus is Running and Accessible:

Make sure the Prometheus pod is running and that its service is exposed so that Grafana can reach it. Given your current configuration, you've set up Prometheus to be accessible via a NodePort service. This means it should be accessible within the cluster and from outside, assuming you know the node's IP and the port.
Add Prometheus as a Data Source in Grafana:

2. Access the Grafana UI - it should be available at http://nodeip:31111.

3. Log in to Grafana. The default username is admin. You can retrieve the password using the command provided in your script:

```bash
kubectl get secret --namespace grafana-prometheus grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
4. Once logged in, click on the gear icon (⚙️) on the left sidebar to open the "Configuration" menu.
5. Click on "Data Sources" and then on the "Add data source" button.
6. Choose "Prometheus" from the list of available data sources.
7. In the HTTP section, set the URL to the internal service name of Prometheus, which would typically be something like http://prometheus-server.grafana-prometheus.svc.cluster.local:80. 
Kubernetes DNS will resolve this to the actual IP of the service.
Click "Save & Test" to ensure Grafana can reach Prometheus.

8. Set Up Dashboards:

Once Prometheus is added as a data source, you can start creating dashboards in Grafana or import pre-made dashboards from Grafana's community dashboard site.
For Kubernetes monitoring, there are many pre-made dashboards available that utilize Prometheus metrics.

9. Alerting (Optional):

If you want to set up alerts, Grafana can use Prometheus as a backend for this. You can create alert rules in Grafana based on Prometheus metrics and have Grafana send notifications when those rules are triggered.

#### Remember - make sure you'll change default password change it once you will login!

## Notes

- Ensure the NFS server is accessible from your Kubernetes nodes.
- Adjust the NFS paths and server IP as needed based on your environment.

## Contributing

Contributions are welcome! Please read the contributing guidelines to get started.

## License

The scripts, configurations, and documentation in this project are licensed under the MIT License. This license applies only to the scripts, configurations, and documentation contained in this repository (Grafana & Prometheus) and not to the software they interact with. 