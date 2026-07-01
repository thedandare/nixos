{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alerta # Alerta accepts alerts from the standard sources like Syslog, SNMP, Prometheus, Nagios, Zabbix, Sensu and netdata. Any monitoring tool that can trigger a URL request can be integrated easily. Anything that can be scripted can also send alerts using the command-line tool. There is already a Python SDK and other SDKs are in the pipeline. Cool.

  ];
}
