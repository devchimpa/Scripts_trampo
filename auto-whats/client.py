#!/usr/bin/python3
import sys
import os
import socket
import json


"""
Zabbix
"""

mensagem = sys.argv[1]

server = {
    "host": "127.0.0.1",
    "port": 65431,
}


def send_message(server, message ):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client_socket:
        try:
            client_socket.connect((server.get("host"), int(server.get("port"))))
        except Exception as e:
            print(f"ERROR Ge: {e}")
            return False

        message_data = json.dumps(message).encode('utf-8')
        client_socket.sendall(message_data)


def main():
    message = mensagem

    send_message(server, message)


if __name__ == "__main__":
    main()

