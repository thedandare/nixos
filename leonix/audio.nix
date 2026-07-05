# F5 ─────────────────────────────────── ♩ ── ♩ ─
#                              ♩
# D5 ─────────── ♩ ──────────────────────────────
#          ♩              ♩
# B4 ────────────────────────────────────────────
# G4 ────────────────────────────────────────────
# E4 ─── ♩ ────────────────── ♩ ─────────────────
#  ─ ♩ ─

{ ... }:
{
  # 🔊 Sound blasting.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # If you want to use JACK applications
    extraConfig = {
      # 🌟 Configurações Audiófilas para o PipeWire:
      pipewire = {
        "99-audiophile" = {
          "context.properties" = {
            "module.x11.bell" = false; # Disable X11 bell module, which plays a sound on urgency hint

            # Permite que o PipeWire mude a taxa de amostragem do hardware dinamicamente
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
              176400
              192000
              352800
              384000
            ];
            # Define a qualidade máxima de reamostragem caso ela precise acontecer
            "resample.quality" = 10;
            # Um buffer de 64 ou 128 amostras é imperceptível ao ouvido humano e evita estalos
            "default.clock.quantum" = 64;
            "default.clock.min-quantum" = 32; # Permite que apps de áudio profissional peçam 32 se precisarem
            "default.clock.max-quantum" = 1024; # Permite que o sistema aumente o buffer em tarefas leves para poupar energia

          };
        };
        # Quadrophonic DECODER):
        "99-sq-decoder" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "Decodificador Matrix SQ Quadrafônico";
                "media.name" = "Matrix SQ Decoder";
                "node.name" = "sq_decoder";
                "in.channels" = [
                  "FL"
                  "FR"
                ];
                "out.channels" = [
                  "FL"
                  "FR"
                  "RL"
                  "RR"
                ];
                "filter.graph" = {
                  nodes = [
                    {
                      type = "builtin";
                      label = "linear";
                      name = "matrix";
                    }
                  ];
                  settings = {
                    "matrix.dump" = true;
                    "matrix.gain" = 1.0;
                    "matrix.matrix" = [
                      [
                        1.0
                        0.0
                      ] # Frente Esquerda (L)
                      [
                        0.0
                        1.0
                      ] # Frente Direita (R)
                      [
                        (-0.707)
                        0.707
                      ] # Trás Esquerda (-0.707L + 0.707R)
                      [
                        0.707
                        (-0.707)
                      ] # Trás Direita (0.707L - 0.707R)
                    ];
                  };
                };
                "capture.props" = {
                  "node.passive" = true;
                  "audio.position" = [
                    "FL"
                    "FR"
                  ];
                };
                "playback.props" = {
                  "node.name" = "sq_output";
                  "audio.position" = [
                    "FL"
                    "FR"
                    "RL"
                    "RR"
                  ];
                };
              };
            }
          ];
        };
      };

    };
  };
  security.rtkit.enable = false; # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.

  /*
    ▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
    ▐  configuração oficial do NixOS para latência ultrabaixa                      ▌
    ▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌
          "Audio production and rhythm games require lower latency audio than general applications.
          PipeWire can achieve the required latency with much less CPU usage compared to PulseAudio,
          with the appropriate configuration. The minimum period size controls how small a buffer can be.
          The lower it is, the less latency there is. PipeWire has a value of 32/48000 by default,
          which amounts to 0.667ms. It can be brought lower if needed:"
          pipewire."92-low-latency" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 32;
              "default.clock.min-quantum" = 32; (Amarra o sistema para que nenhum aplicativo possa aumentar ou diminuir esse buffer)
              "default.clock.max-quantum" = 32;
            };
          };
       👀 No entanto, há um perigo em usá-lo exatamente assim se você se importa com a qualidade de áudio para música.
       Por que essa configuração pode estragar sua experiência:Estalos e Cliques (Xruns/Underruns): Um buffer de 32 amostras exige muito do processador.
       A menos que você use um kernel de tempo real (pkgs.linuxPackages_latest_rt) e uma interface de áudio excelente,
       o áudio vai começar a estalar, pipocar ou cortar quando o processador sofrer qualquer oscilação de carga.Destrói
       o Bit-Perfect Audiófilo: Ao travar a taxa em 48000 sem declarar a opção allowed-rates, qualquer música em formato
       de CD (44.1kHz) ou arquivos Hi-Res (96kHz, 192kHz) será forçadamente reamostrada digitalmente para 48kHz pelo PipeWire,
       perdendo a pureza original da gravação.

       ▐▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▌
       ▐ Advanced Linux Sound Architecture (ALSA)    ▌
       ▐▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▌

        O ALSA é o driver de nível do kernel. Ele é extremamente rápido e direto, mas tem limitações severas de usabilidade:
        Bloqueio Exclusivo: Por padrão, se um aplicativo (como o player de música) abrir o dispositivo de
        áudio via ALSA puro, nenhum outro som do sistema sairá. O áudio do navegador, notificações ou vídeos do
        YouTube ficarão completamente mudos até você fechar o player.Falta de Interface Visual: Gerenciar taxas de
        amostragem (sample rates), bit depths e roteamento no ALSA exige lidar com arquivos de texto complexos (asound.conf)
        e comandos de terminal de nível mais baixo.
        Enable this option only if you want to use ALSA as your main sound system, not if you’re using a sound server (e.g. PulseAudio or Pipewire).
  */
  hardware.alsa.enable = false;

}
