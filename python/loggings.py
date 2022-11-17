import logging 

# this will create a logger with the name of the module that you are currently in 
logger = logging.getLogger(__name__)

logger.info('hello from helper ')
# logging.basicConfig(level=logging.DEBUG,format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
#                     datefmt="%m/%d/%Y %H:%M:%S")
# # you can log five different log levels 
# logging.debug('This is a debug message')
# logging.info('This is an info message')
# logging.warning('This is a warning message')
# logging.error('This is an error message')
# logging.critical('This is a critical message')

#create handler
stream_h = logging.StreamHandler()
file_h = logging.FileHandler('file.log')

# for each handler set the level and the format
stream_h.setLevel(logging.WARNING)
file_h.setLevel(logging.ERROR)

formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
stream_h.setFormatter(formatter)
file_h.setFormatter(formatter)

# we have to add our handler to the logger
logger.addHandler(stream_h)
logger.addHandler(file_h)

#test it out 
logger.warning('this is a warning')
logger.error('this is an error')









# NOTES
# If you want to log in different modules, its best practice not to use root, but create
# your own logger 
#log handlers - These are responsibe for dispatching the appropriate log message, to the 
# handlers specific destination