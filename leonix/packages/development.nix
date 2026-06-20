{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 👩‍💻 Development
    ## IDEs
    antigravity
    windsurf
    jetbrains.idea
    jetbrains.pycharm
    ## Runbooks
    atuin-desktop
    ## SDKs / envs
    dart
    flutter341
    uv
    nodejs_24
    plantuml-server

    # Google
    androidsdk
    google-cloud-sdk
    google-cloud-sdk-gce
    google-compute-engine

    # Hypervisors
    photoprism
    virt-manager
    socat # http://www.dest-unreach.org/socat/ Utility for bidirectional data transfer between two independent data channels
    websocat # https://github.com/vi/websocat
    qemu
    quickemu
    qemu-utils
    uefi-run
    virt-viewer
    spice-gtk
    spice
    vhost-device-sound

    # 🎱 Kubernets
    kubectl
    kubectl-ai
    kompose
    opentofu
    stern # Multi pod and container log tailing for Kubernetes Usage stern pod-query [flags] https://github.com/stern/stern
    k9s

    agneyastra # A firebase Misconfiguration Detection Toolkit [https://github.com/JA3G3R/agneyastra]
  ];
}
