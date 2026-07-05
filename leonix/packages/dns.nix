{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   🧭  Core Clients / Diagnostics                       ▌
    #▐ Basic DNS clients, resolver tooling and day-to-day debugging. ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    bind # Essential: dig, host, nslookup
    # ldns # drill + DNSSEC utilities
    # doggo # Modern human-friendly DNS client
    # adns # Async DNS resolver library / tools
    # dnsdiag # DNS latency, tracing and troubleshooting suite
    # dnsviz # DNSSEC validation and visualization
    # dnsperf # Benchmark authoritative/recursive DNS performance
    # dnsvalidator # Maintain/test lists of public DNS resolvers

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   🔍  Recon / Enumeration                              ▌
    #▐ Use only on owned systems or authorized assessments.          ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # dnsx # Fast DNS toolkit; good for pipelines and probes
    # aiodnsbrute # Async DNS bruteforce / subdomain enumeration
    # dnsenum # Classic DNS enumeration workflow
    # fierce # Finds related non-contiguous IP ranges via DNS
    # amass # Heavyweight OSINT + DNS enumeration mapper
    # gobuster # DNS/vhost/URI bruteforce; useful quick checks
    # massdns # High-volume DNS resolver for large wordlists
    # scilla # DNS + ports + info gathering
    # baddns # Finds dangling DNS and takeover candidates
    # dnstake # Checks abandoned/missing hosted DNS zones
    # adidnsdump # Dumps AD-integrated DNS zones with valid AD creds

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   🛠  Zone / Provider Operations                         ▌
    #▐ Managing records, providers, zone generation and cloud DNS.   ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # octodns # Multi-provider DNS-as-code; best for real ops
    # cli53 # Amazon Route53 command line utility
    # dli # CLI DNS record manager
    # exoscale-cli # Exoscale CLI; includes DNS operations
    # gen6dns # Generate AAAA/PTR records for SLAAC networks
    # hash-slinger # Generate special DNS records: SSHFP, TLSA, etc.
    # djbdns # Classic DNS toolkit; historical but still useful
    # dq # Recursive DNS / DNSCurve server and CLI
    # knot-dns # Authoritative DNS server + kdig/khost tooling

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   🌍  Dynamic DNS / Sync                                ▌
    #▐ For homeservers, WireGuard endpoints and changing IPs.        ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # godns # Dynamic DNS client; many providers
    # wg-ddns # Lightweight DDNS helper for WireGuard
    # dness # Dynamic DNS updater
    # d2hs # Sync DNS records into hosts-style files
    # gnomeExtensions.sanad
    #                 # GNOME DNS changer extension

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   📡  Monitoring / Passive DNS                          ▌
    #▐ Capturing, observing and storing DNS traffic or resolver data.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # dnsmon-go # Collect DNS traffic
    # dnsmonster # Passive DNS capture and monitoring toolkit
    # compactor # Store DNS traffic as C-DNS files
    # dnsight # DNS/email/web hygiene checks
    # ttfb # Not DNS-specific, but useful after DNS changes
    # rkik # NTP offset checks; useful infra sanity tool

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🄳🄽🅂   🔐  Privacy / Tunnels / Edge Cases                    ▌
    #▐ Use tunnels only in controlled labs or authorized networks.   ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # dnscrypt-proxy # Secure encrypted DNS proxy
    # dns2tcp # TCP-over-DNS tunnel
    # iodine # IPv4-over-DNS tunnel
    # minio-certgen # Generates certs with DNS/IP SAN entries
    # decode-spam-headers
    #                 # Email deliverability diagnostics: SPF/DKIM/DMARC
    # dsniff # Network auditing toolkit; not DNS-specific

  ];
}
