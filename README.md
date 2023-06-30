# localkubernetes

setup.sh 파일
이 스크립트는 기본 패키지 및 도커(Docker)와 Kubernetes를 설치하는 과정을 자동화하는 스크립트입니다. 주요 내용은 다음과 같습니다:

1. 스크립트를 실행하는 사용자가 root 계정인지 확인합니다.
2. 시스템 패키지를 업데이트하고 필요한 패키지를 설치합니다. openssh-server, net-tools, apt-transport-https, curl, vim 패키지가 설치됩니다.
3. 도커(Docker)를 설치하고 시작하며, 부팅 시 자동으로 시작되도록 설정합니다. 도커의 상태를 확인하고, Cgroup Driver가 systemd로 설정되어 있는지 확인합니다. 만약 그렇지 않다면, 도커 구성 파일인 /etc/docker/daemon.json 파일을 생성하고, systemd를 Cgroup Driver로 설정합니다.
4. 쿠버네티스(Kubernetes)를 설치합니다. 공식적으로 제공되는 apt 저장소를 추가하고, kubelet, kubeadm, kubectl, kubernetes-cni 패키지를 설치합니다. 마지막으로, 이 패키지들의 업그레이드를 막기 위해 apt-mark hold 명령어를 사용합니다.
5. 스크립트에 실행 권한을 부여합니다.
6. 이 스크립트를 실행하면 필요한 패키지가 설치되고 도커와 쿠버네티스가 구성되어 개발 환경을 준비할 수 있습니다.

master.sh 파일
이 스크립트는 Kubernetes 마스터 노드를 초기화하고 워커 노드를 추가하기 위한 작업을 자동화하는 스크립트입니다. 주요 내용은 다음과 같습니다:

1. 스크립트를 실행하는 사용자가 root 계정인지 확인합니다.
2. 마스터 노드의 IP 주소를 입력 받습니다.
3. kubeadm init 명령을 사용하여 Kubernetes 마스터 노드를 초기화합니다. --pod-network-cidr 옵션은 Pod 네트워크의 CIDR을 지정하고, --apiserver-advertise-address 옵션은 마스터 노드의 IP 주소를 지정합니다.
4. Kubernetes 구성 파일인 admin.conf를 복사하여 $HOME/.kube/config 경로에 저장합니다.
5. 클러스터 상태를 확인하기 위해 kubectl get pods --all-namespaces와 kubectl get nodes 명령을 실행합니다.
6. kubeadm join 정보를 추출하여 변수 join_command에 저장합니다.
7. kubeadm join 정보를 출력합니다.
8. worker.sh 파일을 생성하고, 내용으로 kubeadm join 명령어를 포함시킵니다.
9. worker.sh 파일에 실행 권한을 부여합니다.
10. Flannel 네트워크를 배포하기 위해 kubectl apply 명령으로 YAML 파일을 적용합니다.
11. 스크립트에 실행 권한을 부여합니다.
12. 이 스크립트를 실행하면 마스터 노드를 초기화하고 worker.sh 파일이 생성됩니다. worker.sh 파일은 워커 노드에서 실행하여 마스터 노드에 연결하는데 필요한 kubeadm join 명령어가 포함되어 있습니다. 또한, Flannel 네트워크도 배포됩니다.
