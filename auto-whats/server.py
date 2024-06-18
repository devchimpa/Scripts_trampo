import os
import socket
import json
import threading
import pywhatkit
import selenium
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import pyautogui

"""
Interface grafica
"""


HOST = '0.0.0.0'
PORT = 65431


def start_wpp(message):

    phone_number = "+5561999999999"

    pywhatkit.sendwhatmsg_instantly( phone_number , str(message) )

    time.sleep(30)

    pyautogui.press("enter")


    #print("--" * 20)
    #print (message)
    #print("--" * 20)


def handle_client(conn, addr):
    print(f"Conectado por {addr}")
    try:
        while True:
            data = conn.recv(1024)
            if not data:
                break

            message = json.loads(data.decode('utf-8'))
            start_wpp(message)

    except Exception as e:
        print(f"Erro ao lidar com o cliente {addr}: {e}")
    finally:
        print(f"Conexão com {addr} encerrada")
        conn.close()


def main():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        server_socket.bind((HOST, PORT))
        server_socket.listen()
        print(f"Servidor escutando em {HOST}:{PORT}")

        while True:
            conn, addr = server_socket.accept()
            client_thread = threading.Thread(target=handle_client, args=(conn, addr))
            client_thread.daemon = True
            client_thread.start()


if __name__ == "__main__":
    main()

