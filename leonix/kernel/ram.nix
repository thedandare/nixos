{ pkgs, ... }:
{

  # 🚀 72G RAM optimization
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "50%"; # RAM pura e sem compressão para arquivos temporários

  # ⚕️ ZRAM.
  # Mantém apenas o Swap em Zram para segurança do Kernel
  zramSwap.enable = true;
  zramSwap.priority = 7;
  zramSwap.swapDevices = 1; # O padrão 1 já é excelente, mas pode manter 2 se preferir
  # Para entender a disputa técnica entre usar 1 ou mais dispositivos ZRAM em Kernels recentes, precisamos olhar como o subsistema de Swap lida com concorrência.No passado (antigas séries do Kernel), cada dispositivo de swap adicionado ao /proc/swaps possuía uma trava global (swap_lock) para escrita. Se você tivesse uma CPU de 32 núcleos martelando um único dispositivo de swap, os núcleos ficavam esperando uns aos outros devido à contenção dessa trava. Criar múltiplos swapDevices com a mesma prioridade distribuía as páginas no formato round-robin, quebrando a contenção.O que mudou na arquitetura recente:O driver interno do ZRAM foi reengenheirado para suportar fluxos de execução nativos de multi-compressão (várias streams de CPU gravando no mesmo bloco lógico /dev/zram0 sem travarem o barramento síncrono). Além disso, o Kernel otimizou as travas de paginação fina (adotando estruturas baseadas em per-CPU para o ecossistema de alocação de páginas).Criar múltiplos dispositivos ZRAM hoje em um Kernel moderno força o alocador do sistema a quebrar o gerenciamento de memória em árvores lógicas distintas, gerando metadados repetidos na RAM e fragmentação nas tabelas de alocação do driver, sem entregar ganho de vazão de I/O em processadores modernos.
  #   O Zram cria um bloco na memória que compacta os dados (via algorítmos como lz4 ou zstd) para economizar espaço de RAM
  #   ⁉️ n tem como fazer swap na ram sem o zram?
  #   🌐 Tecnicamente, sim, é possível, mas fazer Swap diretamente na RAM sem compactação (sem Zram) cria um paradoxo e não traz nenhuma vantagem prática.Para fazer Swap na RAM sem Zram, você teria que usar um módulo do Linux chamado brd (Ramdisk) para criar um disco virtual na memória bruta e, depois, formatá-lo como Swap.Aqui está o porquê de isso ser uma má ideia e por que o comportamento do sistema fica idêntico ou pior do que simplesmente não ter Swap:O "Paradoxo" do Ramdisk como SwapDesperdício Físico Inútil: O Swap serve para o Kernel mover dados da RAM para um local secundário quando quer liberar espaço. Se o seu local secundário é a própria RAM (sem compactação), você está tirando dados do "bolso esquerdo" da RAM e colocando no "bolso direito".Consumo de Memória Duplicado: Ao criar um Ramdisk de 8GB para Swap, esses 8GB ficam permanentemente trancados e inutilizados para o resto do sistema. Você reduz sua RAM utilizável de 72GB para 64GB imediatamente. No Zram isso não acontece, pois ele só consome memória dinamicamente conforme os dados entram lá e são compactados.

}
