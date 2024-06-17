import pywhatkit
import selenium
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import pyautogui

#phone_number = "+5561996809173"
phone_number = "+5561995804033"
#phone_number = "+5561981714556"
#phone_number = "+5561986048227"

message = " Oi, Rodrigo. Gostoso! "

pywhatkit.sendwhatmsg_instantly( phone_number , message )

time.sleep(10)

pyautogui.press("enter")

