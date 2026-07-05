{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🔐 Security / TPM / Recon / Vulnerability Laboratory        ▌
    #▐ TPM/FIDO tooling, network discovery, scanners and audit kit.▌
    #▐ Use only in owned systems, labs or explicitly authorized scopes. ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🔑 Crypto / TLS Base Tools                                  ▌
    #▐ General cryptographic and TLS command-line utilities.       ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    openssl

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🅃🄿🄼 / FIDO / Passkeys                                    ▌
    #▐ TPM2 tooling, pinentry helpers and WebAuthn/U2F management.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    tpm-fido # WebAuthn/U2F token protected by a TPM: https://github.com/psanford/tpm-fido
    tpm2-tools # TPM2 command-line tools: https://github.com/tpm2-software/tpm2-tools
    fido2-manage
    pinentry-all # GnuPG pinentry collection: https://gnupg.org/software/pinentry/index.html

    # passkeyd
    # softu2f

    /*
      tpm2-tools / tss2 reference

      Programs provided:
      tpm2 tpm2_activatecredential tpm2_certify tpm2_certifyX509certutil tpm2_certifycreation
      tpm2_changeauth tpm2_changeeps tpm2_changepps tpm2_checkquote tpm2_clear
      tpm2_clearcontrol tpm2_clockrateadjust tpm2_commit tpm2_create tpm2_createak
      tpm2_createek tpm2_createpolicy tpm2_createprimary tpm2_dictionarylockout
      tpm2_duplicate tpm2_ecdhkeygen tpm2_ecdhzgen tpm2_ecephemeral tpm2_encodeobject
      tpm2_encryptdecrypt tpm2_eventlog tpm2_evictcontrol tpm2_flushcontext tpm2_getcap
      tpm2_getcommandauditdigest tpm2_geteccparameters tpm2_getekcertificate
      tpm2_getpolicydigest tpm2_getrandom tpm2_getsessionauditdigest tpm2_gettestresult
      tpm2_gettime tpm2_hash tpm2_hierarchycontrol tpm2_hmac tpm2_import
      tpm2_incrementalselftest tpm2_loa tpm2_loadexternal tpm2_makecredential
      tpm2_nvcertify tpm2_nvdefine tpm2_nvextend tpm2_nvincrement tpm2_nvread
      tpm2_nvreadlock tpm2_nvreadpublic tpm2_nvsetbits tpm2_nvundefine tpm2_nvwrite
      tpm2_nvwritelock tpm2_pcrallocate tpm2_pcrevent tpm2_pcrextend tpm2_pcrread
      tpm2_pcrreset tpm2_policyauthorize tpm2_policyauthorizenv tpm2_policyauthvalue
      tpm2_policycommandcode tpm2_policycountertimer tpm2_policycphash
      tpm2_policyduplicationselect tpm2_policylocality tpm2_policynamehash
      tpm2_policynv tpm2_policynvwritten tpm2_policyor tpm2_policypassword
      tpm2_policypcr tpm2_policyrestart tpm2_policysecret tpm2_policysigned
      tpm2_policytemplate tpm2_policyticket tpm2_print tpm2_quote tpm2_rc_decode
      tpm2_readclock tpm2_readpublic tpm2_rsadecrypt tpm2_rsaencrypt tpm2_selftest
      tpm2_send tpm2_sessionconfig tpm2_setclock tpm2_setcommandauditstatus
      tpm2_setprimarypolicy tpm2_shutdown tpm2_sign tpm2_startauthsession
      tpm2_startup tpm2_stirrandom tpm2_testparms tpm2_tr_encode tpm2_unseal
      tpm2_verifysignature tpm2_zgen2phase

      tss2 tss2_authorizepolicy tss2_changeauth tss2_createkey tss2_createnv
      tss2_createseal tss2_decrypt tss2_delete tss2_encrypt tss2_exportkey
      tss2_exportpolicy tss2_getappdata tss2_getcertificate tss2_getdescription
      tss2_getinfo tss2_getplatformcertificates tss2_getrandom tss2_gettpm2object
      tss2_gettpmblobs tss2_import tss2_list tss2_nvextend tss2_nvincrement
      tss2_nvread tss2_nvsetbits tss2_nvwrite tss2_pcrextend tss2_pcrread
      tss2_provision tss2_quote tss2_setappdata tss2_setcertificate
      tss2_setdescription tss2_sign tss2_unseal tss2_verifyquote
      tss2_verifysignature tss2_writeauthorizenv

      Usage notes:

      1. Create an NVRAM index, for example index 0x1500000 with 2048 bytes:

         sudo tpm2_nvdefine -T device:/dev/tpmrm0 \
           -s 2048 \
           -a "ownerread|ownerwrite|authread|authwrite" \
           0x1500000

      2. Write a small secret:

         echo -n "Senha171" | sudo tpm2_nvwrite -T device:/dev/tpmrm0 -i - 0x1500000

      3. Read the same number of bytes back:

         sudo tpm2_nvread -T device:/dev/tpmrm0 -s 8 0x1500000
    */

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🧭 LAN Discovery / Local Network Scanning                   ▌
    #▐ Host discovery, NetBIOS, mDNS, SMB and local inventory.     ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    angryipscanner
    netpeek # Modern network scanner for GNOME.
    netscanner # Network scanner with Wi-Fi scanning, packet dump and related features.
    watchyourlan # Lightweight network IP scanner with web GUI.

    nbtscanner # NetBIOS scanner written in Rust.
    nbtscan # Scan networks for NetBIOS information.
    mdns-scanner # Create a list of IPs and hostnames, including mDNS names and aliases.
    erosmb # SMB network scanner.
    smbscan # Enumerate SMB file shares.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📡 Port / Protocol / Internet-Scale Scanning                ▌
    #▐ Fast port scanners, UDP scanning and application-layer grabs.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    sx-go # Very fast scanner inspired by nmap-style workflows: https://github.com/v-byte-cpu/sx
    naabu # Fast SYN/CONNECT port scanner for host lists.
    nray # Distributed port scanner.
    udpx # Single-packet UDP scanner.

    zgrab2 # Application-layer scanner for detailed L7 handshakes; often paired with ZMap.
    sslscan # Tests SSL/TLS services and lists supported protocol/cipher suites.
    braa # Mass SNMP scanner.
    onesixtyone # Fast SNMP scanner.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🌐 Web Recon / Web Application Scanning                     ▌
    #▐ Web fingerprinting, black-box web scans and HTTP checks.    ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    nikto # Web server scanner.
    wapiti # Black-box web application scanner/fuzzer.
    whatweb # Web technology fingerprinting scanner.
    http-scanner # HTTP security vulnerability scanner.
    crlfsuite # CRLF injection / HTTP response splitting scanner.
    raccoon-scanner # Reconnaissance and vulnerability scanning tool.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🔎 Search Engine Dorking / OSINT                            ▌
    #▐ Search-engine assisted discovery and reconnaissance.        ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    go-dork # Fast dork scanner written in Go: https://github.com/dwisiswant0/go-dork
    /*
      #### go-dork reference

      ##_Querying_:

      - go-dork -q "inurl:..."

      Queries can also be provided through stdin:

       - cat dorks.txt | go-dork -p 5

      Defining engine:

       - go-dork -e bing -q ".php?id="

      Available engines include Google, Shodan, Bing, Duck, Yahoo and Ask.
      If -e is not defined, Google is used by default.

      Pagination:

        go-dork -q "intext:'jira'" -p 5

      Custom headers:

        go-dork -q "org:'Target' http.favicon.hash:116323821" \
          --engine shodan \
          -H "Cookie: ..." \
          -H "User-Agent: ..."

      Proxy:

        go-dork -q "intitle:'BigIP'" -p 2 -x http://127.0.0.1:8989

      Chaining with other tools:

        cat dorks.txt | go-dork | pwntools
        go-dork -q "inurl:'/secure' intext:'jira' site:org" -s | nuclei -t workflows/jira-exploitaiton-workflow.yaml

      Supporting material:
      Hazana. Dorking on Steroids, 11 Mar. 2021.
      https://hazanasec.github.io/2021-03-11-Dorking-on-Steriods/
    */

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ ☁️ Cloud / Kubernetes / IaC Security                        ▌
    #▐ Cloud bucket checks, Kubernetes runtime scans and Nix audit.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    cloudhunter # Cloud bucket scanner.
    kubeclarity # Kubernetes runtime scanner.
    vulnix # NixOS vulnerability scanner.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📦 Container / Dependency / Vulnerability Scanning          ▌
    #▐ CVE, package, filesystem, image and dependency scanners.    ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    trivy # Comprehensive vulnerability scanner for containers, filesystems and CI.
    grype # Vulnerability scanner for container images and filesystems.
    osv-scanner # Go-based vulnerability scanner using OSV data: https://osv.dev
    vuls # Agentless vulnerability scanner.
    sploitscan # Provides vulnerability and associated exploit information.
    vunnel # Collects vulnerability data from multiple sources: https://github.com/anchore/vunnel
    terrapin-scanner # Scanner for the SSH Terrapin attack vulnerability.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🕵️ Secrets / Credentials / IOC Scanning                     ▌
    #▐ Token discovery, secret detection and YARA/IOC filesystem scans. ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    deepsecrets # Secrets scanner that understands source code.
    stacs # Static token and credential scanner.
    spyre # YARA-based IOC scanner for searching filesystems for indicators of compromise.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📶 Wireless / RF / Wardriving Security                      ▌
    #▐ Wireless monitoring, WIDS and radio-adjacent security tools.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    kismet # Sniffer, WIDS and wardriving tool for Wi-Fi, Bluetooth, Zigbee, RF and more.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🧨 Security Frameworks / Exploit Research                   ▌
    #▐ Frameworks and GUIs for authorized testing and lab research.▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    metasploit
    armitage

    # https://github.com/vi/websocat
    websocat
  ];
}
