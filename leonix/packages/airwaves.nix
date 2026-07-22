{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📻 SDR  RTL2832U / RF Laboratory                             ▌
    #▐ Two RTL-SDR receivers available.                             ▌
    #▐ General RF analysis, ADS-B, AIS, weather, amateur radio.     ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📻 SDR Core / Receivers                                      ▌
    #▐ Base SDR stack, RTL2832U support, graphical SDR receivers.   ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    rtl-sdr
    rtl-sdr-librtlsdr # librtlsdr tools/library split; useful when another package expects the library package name.
    soapyrtlsdr # SoapySDR module for RTL-SDR devices.
    soapysdr-with-plugins # SoapySDR runtime with plugin discovery; useful when mixing RTL-SDR, SDRplay, etc.
    soapysdrplay # SoapySDR module for SDRplay receivers.
    sdrplay # SDRplay API/userspace support; only useful with SDRplay hardware.
    sdrpp # SDR++: modern lightweight SDR receiver UI.
    cubicsdr
    gqrx
    sdrangel
    sdr-j-fm
    qradiolink

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🧱 GNU Radio / SDR Frameworks                               ▌
    #▐ Flowgraph-based DSP and Osmocom/RTL source blocks.          ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    gnuradio
    gnuradioPackages.osmosdr # Osmocom SDR source/sink blocks for GNU Radio.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🎯 Recommended RTL2832U Toolkit                             ▌
    #▐ Kept as a checklist only; packages are installed above.     ▌
    #▐ Uncomment here only if you intentionally move them back.     ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # rtl-sdr
    # rtl-sdr-librtlsdr
    # soapyrtlsdr
    # soapysdr-with-plugins
    # qradiolink
    # gnuradio
    # gnuradioPackages.osmosdr
    # gqrx
    # satdump
    # rtl_433
    # dump1090-fa
    sdrpp

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ ✈️ ADS-B / Aviation                                          ▌
    #▐ Aircraft tracking and 1090 MHz monitoring.                  ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    # dump1090-fa
    readsb
    # tar1090

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🚢 AIS Maritime                                             ▌
    #▐ Vessel tracking on AIS frequencies.                         ▌
    #▐ Useful for coastal monitoring around Florianópolis.         ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    rtl-ais

    # aisdecoder

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🛰️ Weather Satellites / Orbital Tracking                    ▌
    #▐ NOAA, METEOR, GNSS, image reception and pass prediction.    ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    satellite # Desktop satellite tracking application: https://codeberg.org/tpikonen/satellite
    satdump # Main modern decoder for weather-satellite downlinks, including NOAA/METEOR workflows.
    noaa-apt
    aptdec # NOAA APT satellite imagery decoding library.
    gnss-sdr # GNSS receiver stack; belongs here because it is satellite/RF, not weather imaging specifically.
    arftracksat # Satellite tracking software for Linux.
    gpredict # Real-time satellite tracking and orbit prediction.
    orbvis # View and propagate the full CelesTrak satellite catalog in realtime.

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📡 RF Monitoring / Signal Intelligence                      ▌
    #▐ Capture, inspect and archive radio activity.                ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    rtl_433 # Decode common 433/868/915 MHz ISM devices: sensors, remotes, weather stations, meters.
    trunk-ng # Trunked radio monitoring/decoding.

    sigrok-cli
    # multimon-ng

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📞 Digital Radio / Amateur Radio                            ▌
    #▐ Amateur radio digital modes, packet systems and QSO tools.  ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    wsjtx
    fldigi
    direwolf # AX.25 packet/TNC software; useful with APRS and packet radio.
    qsstv # Qt-based slow-scan TV and fax.
    adif-multitool # Manipulate and convert ADIF logbooks; useful for amateur-radio QSO archives.

    # dsd
    # minimodem
    # chirp

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🎯 DMR Radios                                               ▌
    #▐ Codeplug and configuration tools for DMR handhelds/radios.  ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    qdmr # Codeplug editor/programmer for several DMR radios: https://dm3mat.darc.de/qdmr/
    dmrconfig # CLI configuration tool for selected DMR radios: https://github.com/sergev/dmrconfig

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🔬 Wireless Research / Reverse Engineering                  ▌
    #▐ Protocol analysis, demodulation and RF experimentation.     ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    urh
    inspectrum # Inspect captured IQ files visually; very useful after recording unknown signals.
    digiham # Digital ham decoding tools.
    #▐      Programs provided:
    #▐      dc_block digitalvoice_filter dmr_decoder dstar_decoder fsk_demodulator gfsk_demodulator
    #▐      mbe_synthesizer nxdn_decoder pocsag_decoder rrc_filter ysf_decoder
    #▐      https://github.com/jketterl/digiham

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 📺 DVB / V4L / TV Receiver Utilities                        ▌
    #▐ DVB scan tables, channel scanning and Linux media tools.    ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    dtv-scan-tables # Initial DVB transponder/channel tables used by scanners such as dvbv5-scan.
    w_scan2 # Generates ATSC, DVB-C, DVB-S/S2 and DVB-T/T2 channels.conf files.
    dvb-apps # Legacy DVB command-line utilities.
    #▐      Programs provided:
    #▐      atsc_epg av7110_loadkeys azap czap dib3000-watch dst_test dvbdate dvbnet dvbscan
    #▐      dvbtraffic femon gnutv gotox lsdvb scan szap tzap zap

    v4l-utils # Video4Linux/media-controller tools; also useful for SDR-adjacent USB receiver diagnostics.
    #▐      Programs provided:
    #▐      cec-compliance cec-ctl cec-follower cx18-ctl decode_tm6000 dvb-fe-tool
    #▐      dvb-format-convert dvbv5-daemon dvbv5-scan dvbv5-zap edid-decode
    #▐      ir-ctl ir-keytable ivtv-ctl media-ctl qv4l2 qvidcap rds-ctl
    #▐      v4l2-compliance v4l2-ctl v4l2-dbg v4l2-sysfs-path v4l2-tracer

    #▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    #▐ 🧰 Audio / TUINIX Helpers                                   ▌
    #▐ Small support tools used by local scripts and RF workflows. ▌
    #▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

    sox # Swiss-army knife for audio conversion/resampling; useful in decoder pipelines and TUINIX scripts.
  ];
}
