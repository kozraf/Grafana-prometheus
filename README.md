
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

## Notes

- Ensure the NFS server is accessible from your Kubernetes nodes.
- Adjust the NFS paths and server IP as needed based on your environment.

## Contributing

Contributions are welcome! Please read the contributing guidelines to get started.

## License

The scripts, configurations, and documentation in this project are licensed under the MIT License. This license applies only to the scripts, configurations, and documentation contained in this repository (Grafana & Prometheus) and not to the software they interact with. 