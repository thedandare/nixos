



incus exec leonk8s -- bash -c '
ip addr add 10.10.10.2/24 dev eth0 2>/dev/null || true
ip route add default via 10.10.10.1 2>/dev/null || true
ip route show
ping -c2 8.8.8.8
'
