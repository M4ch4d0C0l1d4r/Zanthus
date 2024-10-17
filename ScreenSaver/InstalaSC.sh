#!/bin/bash

# Executa atualização do sistema
sudo apt update -y

# Realiza instalação do xscreensaver
sudo apt install xscreensaver -y

# Realiza instalação do mpv
sudo apt install mpv -y

# Faz download do arquivo de configuração do xscreensaver
curl -s -o /home/zanthus/.xscreensaver https://raw.githubusercontent.com/M4ch4d0C0l1d4r/Zanthus/refs/heads/main/ScreenSaver/.xscreensaver

# Verifica se a linha já existe no arquivo
if ! grep -Fxq "export DISPLAY=:0" /etc/profile; then
  # Se não existir, adiciona a linha
  sudo echo "export DISPLAY=:0" >> /etc/profile
  echo "Linha adicionada ao arquivo /etc/profile"
else
  echo "Linha já existe no arquivo /etc/profile"
fi

# Pergunta ao usuário a filial
echo "Não utilize esse script em caixa SelfCheckout!"
echo "Selecione a filial que deseja configurar o screensaver, escolha com cuidado, operação não é reversível."
echo "Caso tenha escolhido a alternativa errada, não adiantará reexecutar o script, atenção!"
echo "1. Centro Colider LJ01 - FL1"
echo "2. Bairro Colider LJ02 - FL3"
echo "3. Matupá LJ03 - FL9"
echo "4. Alta Floresta LJ05 - FL53"
echo "5. Primavera LJ06 - FL52"
echo "6. Confresa LJ07 - FL57"

#Cria um laço de repetição, que seguirá rodando até selecionar uma opção válida do menu.
while true; do
  read -p "Digite a sua opção: " opcao

  case $opcao in
    1)
      # Comandos para a opção 1
      echo "Você escolheu a Filial de Colíder, Loja Centro"
      filial=1
      break ;;
    2)
      # Comandos para a opção 2
      echo "Você escolheu a Filial de Colíder, Loja Bairro"
      filial=3
      break ;;
    3)
      # Comandos para a opção 3
      echo "Você escolheu a Filial de Matupá"
      filial=9
      break ;;
    4)
      echo "Você escolheu a Filial de Alta Floresta"
      filial=53
      break ;;
    5)
      echo "Você escolheu a Filial de Primavera do Leste"
      filial=52
      break ;;
    6)
      echo "Você escolheu a Filial de Confresa"
      filial=57
      break ;;
    *)
      echo "Opção inválida! Por favor, digite uma opção válida." ;;
  esac
done

# Grava os dados de inicialização do PDV
curl -s -o /home/zanthus/atualizaSC$filial.sh https://raw.githubusercontent.com/M4ch4d0C0l1d4r/Zanthus/refs/heads/main/ScreenSaver/atualizaSC$filial.sh
echo "Realizado download do script para filial $filial"

# Força a execução do script de atualização pela primeira vez
chmod +x /home/zanthus/atualizaSC$filial.sh && /home/zanthus/atualizaSC$filial.sh

#Comando que gravará no PDVTouch.sh, buscará se já foi executado, caso sim, não será executado uma segunda vez
if ! grep -Fxq "sudo xhost +local:zanthus" /Zanthus/Zeus/pdvJava/PDVTouch.sh; then
    echo "A linha 'sudo xhost +local:zanthus' não foi encontrada. Adicionando..."
    printf "#! /bin/bash\nsudo xhost +local:zanthus\nsudo -u zanthus xscreensaver -no-splash &\nchmod +x /home/zanthus/atualizaSC$filial.sh && /home/zanthus/atualizaSC$filial.sh\nchmod -x /usr/local/bin/igraficaJava;\nchmod -x /usr/local/bin/dualmonitor_control-PDVJava\nnohup recreate-user-rabbitmq.sh &\n/Zanthus/Zeus/pdvJava/pdvJava2 &\nnohup chromium-browser --disable-pinch --disable-gpu --test-type --no-sandbox --kiosk --no-context-menu --disable-translate file:////Zanthus/Zeus/Interface/index.html" > /Zanthus/Zeus/pdvJava/PDVTouch.sh
    chmod +x /Zanthus/Zeus/pdvJava/PDVTouch.sh
    echo "Linhas adicionadas ao arquivo /Zanthus/Zeus/pdvJava/PDVTouch.sh"
else
    echo "A linha 'sudo xhost +local:zanthus' já existe no arquivo."
fi

echo "Script finalizado, aguarde o fim do contador para que o PDV reinicie"
echo "Script feito por Jurandir Moratelli, aguarde o reinicio e finalize o manual para a correta instalação"
sleep 5
#Contador
for i in {1..10}; do
  echo "Contagem regressiva: $((10 - i))"
  sleep 1
done

# Reinicia o PDV para aplicar configurações
echo "Reiniciando"
sudo reboot
