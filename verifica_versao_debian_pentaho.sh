#!/bin/bash

# Função para identificar a versão do Debian
get_debian_version() {
    # Verifica se o arquivo /etc/os-release existe
    if [ -e /etc/os-release ]; then
        # Lê o conteúdo do arquivo
        source /etc/os-release

        # Extrai a versão do Debian, se disponível
        if [ "$ID" == "debian" ]; then
            echo "$VERSION_ID"
        fi
    fi
}

# Obtém a versão do Debian
debian_version=$(get_debian_version)

# Exibe a versão do Debian
if [ -n "$debian_version" ]; then
    echo "Versão do Debian: $debian_version"

    # Se a versão for Debian 10, configure o crontab e execute o script Pentaho
    if [ "$debian_version" == "10" ]; then
        # Cria a pasta /home/teste_pentaho/ se não existir
        mkdir -p /home/teste_pentaho/

        # Cria o arquivo /home/teste_pentaho/pentaho_test.py
        cat > /home/teste_pentaho/pentaho_test.py <<EOF
import requests
import subprocess
import time
import logging
import socket

# Configuração do logging
logging.basicConfig(filename='/home/teste_pentaho/logfile.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s: %(message)s')

# Função para matar os processos do Pentaho
def kill_pentaho_processes():
    logging.info("Matando os processos do Pentaho...")
    try:
        # Execute o comando ps para listar os processos do Pentaho
        ps_output = subprocess.check_output("ps -ef | grep pentaho-8 | grep -v grep | cut -b10-15", shell=True)
        process_ids = ps_output.decode("utf-8").splitlines()

        # Mate cada processo do Pentaho usando kill -9
        for process_id in process_ids:
            subprocess.run(["kill", "-9", process_id])

        logging.info("Processos do Pentaho mortos com sucesso.")
    except subprocess.CalledProcessError:
        logging.error("Erro ao matar os processos do Pentaho.")

# Função para reiniciar o serviço Pentaho
def restart_pentaho():
    logging.info("Reiniciando o serviço Pentaho...")
    subprocess.run(["/home/pentaho/pentaho-8/pentaho-server/stop-pentaho.sh"])
    time.sleep(5)  # Espere um tempo para garantir que o serviço seja parado completamente
    subprocess.run(["/home/pentaho/pentaho-8/pentaho-server/start-pentaho.sh"])
    logging.info("Serviço Pentaho reiniciado com sucesso.")

# URL da aplicação web
url = "http://{ip}:8080"

try:
    # Tente fazer uma solicitação GET para a URL
    response = requests.get(url, timeout=30)  # Defina um timeout de 10 segundos

    # Verifique o código de resposta HTTP
    if response.status_code == 200:
        logging.info(f"A aplicação em {url} está UP.")
    else:
        logging.warning(f"A aplicação em {url} está UP, mas retornou um código de resposta HTTP {response.status_code}.")
except requests.ConnectionError:
    logging.error(f"A aplicação em {url} está DOWN. Não foi possível estabelecer uma conexão.")
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
except requests.Timeout:
    logging.error(f"A aplicação em {url} está DOWN. A solicitação atingiu o tempo limite.")
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
except requests.RequestException:
    logging.error(f"A aplicação em {url} está DOWN. Ocorreu um erro ao fazer a solicitação.")
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
EOF

        # Obtém o endereço IP do servidor
        server_ip=$(hostname -I | cut -d ' ' -f1)

        # Substitui o IP no arquivo pentaho_test.py
        sed -i "s/{ip}/$server_ip/g" /home/teste_pentaho/pentaho_test.py

        # Adiciona o comando ao crontab
        crontab -l | { cat; echo "*/5 * * * * /usr/bin/python3.7 /home/teste_pentaho/pentaho_test.py >> /home/teste_pentaho/logfile.log"; } | crontab -

        echo "Configuração concluída com sucesso."

    # Se a versão não for Debian 10, configure o crontab e execute o script Pentaho alternativo
    else
        # Cria o arquivo /home/teste_pentaho/pentaho_test.py
        cat > /home/teste_pentaho/pentaho_test.py <<EOF
import requests
import subprocess
import time
import logging
import socket

# Configuração do logging
logging.basicConfig(filename='/home/teste_pentaho/logfile.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s: %(message)s')

# Função para matar os processos do Pentaho
def kill_pentaho_processes():
    logging.info("Matando os processos do Pentaho...")
    try:
        # Execute o comando ps para listar os processos do biserver-4
        ps_output = subprocess.check_output("ps -ef | grep biserver-4 | grep -v grep | cut -b10-15", shell=True)
        process_ids = ps_output.decode("utf-8").splitlines()

        # Mate cada processo do Pentaho usando kill -9
        for process_id in process_ids:
            subprocess.run(["kill", "-9", process_id])

        logging.info("Processos do Pentaho mortos com sucesso.")
    except subprocess.CalledProcessError:
        logging.error("Erro ao matar os processos do Pentaho.")

# Função para reiniciar o serviço Pentaho
def restart_pentaho():
    logging.info("Reiniciando o serviço Pentaho...")
    subprocess.run(["/home/pentaho/biserver-4/biserver-ce/stop-pentaho.sh"])
    time.sleep(5)  # Espere um tempo para garantir que o serviço seja parado completamente
    subprocess.run(["/home/pentaho/biserver-4/biserver-ce/start-pentaho.sh"])
    logging.info("Serviço Pentaho reiniciado com sucesso.")

# URL da aplicação web
url = "http://{ip}::8080"

try:
    # Tente fazer uma solicitação GET para a URL
    response = requests.get(url, timeout=30)  # Defina um timeout de 10 segundos

    # Verifique o código de resposta HTTP
    if response.status_code == 200:
        logging.info("A aplicação em {} está UP.".format(url))
    else:
        logging.warning("A aplicação em {} está UP, mas retornou um código de resposta HTTP {response.status_code}.".format(url))

except requests.ConnectionError:
    logging.error("A aplicação em {} está DOWN. Não foi possível estabelecer uma conexão.".format(url))
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
except requests.Timeout:
    logging.error("A aplicação em {} está DOWN. A solicitação atingiu o tempo limite.".format(url))
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
except requests.RequestException:
    logging.error("A aplicação em {} está DOWN. Ocorreu um erro ao fazer a solicitação.".format(url))
    # Matar os processos do Pentaho
    kill_pentaho_processes()
    # Iniciar o Pentaho
    restart_pentaho()
EOF

        # Obtém o endereço IP do servidor
        server_ip=$(hostname -I | cut -d ' ' -f1)

        # Substitui o IP no arquivo pentaho_test.py
        sed -i "s/{ip}/$server_ip/g" /home/teste_pentaho/pentaho_test.py

        # Adiciona o comando ao crontab
        crontab -l | { cat; echo "*/5 * * * * /usr/bin/python3.4 /home/teste_pentaho/pentaho_test.py >> /home/teste_pentaho/logfile.log"; } | crontab -

        echo "Configuração concluída com sucesso."
    fi
else
    echo "Não foi possível identificar a versão do Debian."
fi

