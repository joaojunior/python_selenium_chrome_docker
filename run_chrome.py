from selenium import webdriver
from pyvirtualdisplay import Display


display = Display(visible=0, size=(1980, 1200))
display.start()
webdriver.Chrome()
