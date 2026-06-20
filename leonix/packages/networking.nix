{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # 📡 Networking
    tailscale
    nmap
    zenmap
    whosthere
    net-tools
    tunctl
    lan-mouse
    tshark
    wireshark
    wireshark-cli

    # 🏢 Remote Access
    x2goclient
    gnome-connections
    x2goserver
    remmina
    freerdp
    tigervnc

    # 🌏 Sharing
    rqbit

    # 📻 SDR
    gnuradio
    gnuradioPackages.osmosdr # Programs provided
    rtl-sdr-librtlsdr # Fork of the rtl-sdr library by the Osmocom project.
    sdr-j-fm
  ];
}
