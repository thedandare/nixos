{ config, pkgs, lib, ... }:{
systemd.services.turbovnc = {
  description = "TurboVNC Server para o Leo";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "simple";
    User = "leo";
    # 1. Limpa travas antigas antes de iniciar
    ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/rm -f /tmp/.X1-lock /tmp/.X11-unix/X1'";
    
    # 2. Inicia o servidor cru do TurboVNC na tela :1
    ExecStart = "${pkgs.turbovnc}/bin/Xvnc :1 -auth /home/leo/.Xauthority -geometry 1920x1080 -depth 24 -rfbauth /home/leo/.vnc/passwd -securitytypes plain";
    
    # 3. Logo após iniciar o Xvnc, injeta o XFCE dentro da tela :1
    ExecStartPost = "${pkgs.bash}/bin/bash -c 'sleep 2; DISPLAY=:1 ${pkgs.xfce4-session}/bin/xfce4-session &'";
    
    Restart = "always";
    RestartSec = "5s";
  };
};
}