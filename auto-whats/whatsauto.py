import pywhatkit
import selenium
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import pyautogui


phone_number = "+5599999999999"


message = " Teste de mensagem! "

pywhatkit.sendwhatmsg_instantly( phone_number , message )

time.sleep(10)

pyautogui.press("enter")

