@startuml
title Processo de Parada de Unidades do Systemd

box "Serviços do Sistema e Hardware" #LightBlue
    participant "accounts-daemon.service" as accounts
    participant "colord.service" as colord
    participant "fwupd.service" as fwupd
    participant "power-profiles-daemon.service" as power
    participant "rtkit-daemon.service" as rtkit
    participant "udisks2.service" as udisks
    participant "upower.service" as upower
end box

box "Serviços de Rede e Tempo" #LightGreen
    participant "NetworkManager.service" as nm
    participant "NetworkManager-wait-online.service" as nm_wait
    participant "systemd-timesyncd.service" as sync
end box

box "Ecossistema Hydra & Usuário" #LightYellow
    participant "home-manager-leo.service" as hm_leo
    participant "hydra-evaluator.service" as h_eval
    participant "hydra-init.service" as h_init
    participant "hydra-notify.service" as h_notify
    participant "hydra-queue-runner.service" as h_queue
    participant "hydra-send-stats.service" as h_stats
    participant "hydra-server.service" as h_server
end box

box "Máquinas Virtuais" #LightPink
    participant "ubuntu-vm.service" as ubuntu
    participant "windows-server.service" as windows
end box

box "Manutenção do Sistema" #LightGray
    participant "logrotate-checkconf.service" as logrotate
    participant "systemd-tmpfiles-resetup.service" as tmpfiles
end box

[-> accounts : stop
[-> colord : stop
[-> fwupd : stop
[-> power : stop
[-> rtkit : stop
[-> udisks : stop
[-> upower : stop

[-> nm_wait : stop
[-> nm : stop
[-> sync : stop

[-> hm_leo : stop
[-> h_eval : stop
[-> h_init : stop
[-> h_notify : stop
[-> h_queue : stop
[-> h_stats : stop
[-> h_server : stop

[-> ubuntu : stop
[-> windows : stop

[-> logrotate : stop
[-> tmpfiles : stop

@enduml
