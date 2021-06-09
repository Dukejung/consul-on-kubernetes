# Running Consul on Kubernetes

This tutorial will walk you through deploying a three (3) node [Consul](https://www.consul.io) cluster on Kubernetes.

## Overview

* Three (3) node Consul cluster using a [StatefulSet](http://kubernetes.io/docs/concepts/abstractions/controllers/statefulsets)


## Usage

Clone this repo:

```
git clone https://github.com/Dukejung/consul-on-kubernetes.git
```

Change into the `consul-on-kubernetes` directory:

```
cd consul-on-kubernetes
```

### Create Consul Acl Token
Create acl token and configuration files using script.

```
./createAclToken.sh
```
Above script will create bootstrap token using [uuidgen](https://man7.org/linux/man-pages/man1/uuidgen.1.html) and save at aclToken.txt. 

Consul configuration files using bootstrap token will be created as configs/server-acl-config.json and configs/client-acl-config.json.


### Create the Consul Secret and Configmap

The Consul cluster will be configured using a combination of CLI flags and configuration files, which reference Kubernetes configmaps and secrets.

Create a Secret that stores the gossip encryption key and part of server configuration files with acl token using script:

```
./createSecret.sh
```

Create a ConfigMap that stores the Consul server configuration using script:

```
./createConfigMap.sh
```


### Create the Consul Service

Create a headless service to expose each Consul member internally to the cluster:

```
kubectl create -f services/consul.yaml
```

Create a load balance service that exposes 8500 port:

```
kubectl create -f services/consul-ui.yaml
```

### Create the Consul Service Account

```
kubectl apply -f serviceaccounts/consul.yaml
```

```
kubectl apply -f roles/consul.yaml
```

### Create the Consul StatefulSet

Deploy a three (3) node Consul cluster using a StatefulSet:

```
kubectl create -f statefulsets/consul.yaml
```

Each Consul member will be created one by one. Verify each member is `Running` before moving to the next step.

```
kubectl get pods
```
```
NAME       READY     STATUS    RESTARTS   AGE
consul-0   1/1       Running   0          20s
consul-1   1/1       Running   0          20s
consul-2   1/1       Running   0          20s
```

### Verification

At this point the Consul cluster has been bootstrapped and is ready for operation. To verify things are working correctly, review the logs for one of the cluster members.

```
kubectl logs consul-0
```

The consul CLI can also be used to check the health of the cluster. In a new terminal start a port-forward to the `consul-0` pod.

```
kubectl port-forward consul-0 8500:8500
```
```
Forwarding from 127.0.0.1:8500 -> 8500
Forwarding from [::1]:8500 -> 8500
```

Run the `consul members` command to view the status of each cluster member.

```
consul members
```
```
Node      Address          Status  Type    Build     Protocol  DC   Segment
consul-0  10.32.2.8:8301   alive   server  1.4.0rc1  2         dc1  <all>
consul-1  10.32.1.7:8301   alive   server  1.4.0rc1  2         dc1  <all>
consul-2  10.32.0.13:8301  alive   server  1.4.0rc1  2         dc1  <all>
```

### Accessing the Web UI

There are two ways to access the web UI.

a. Using kubectl port-forward
Start a port-forward session to the `consul-0` Pod in a new terminal.

```
kubectl port-forward consul-0 8500:8500
```

Visit http://127.0.0.1:8500 in your web browser.

b. Using exposed ip.

Get EXTERNAL-IP assigned to the load balancer service named _consul-ui_.
```
kubectl get svc
```
Visit http://[EXTERNAL-IP]:8500 in your web browser.

![Image of Consul UI](images/consul-ui.png)

## Cleanup

Run the `cleanup` script to remove the Kubernetes resources created during this tutorial:

```
bash cleanup
```
