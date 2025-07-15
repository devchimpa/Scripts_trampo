#!/usr/bin/python3
import os

######## counters is just a space to keep the values while the
# script is workin

response_error=0
response_success=0
response_critical=0
response=0

########
# here is the directory where the logs are
logs_directory="/home2/backups/caderno/estudos/python/logs"

# here the script is reading the logs
for archive in os.listdir(logs_directory):
    path_logs= os.path.join(logs_directory, archive)
#    print(path_logs)
# the errors and successful requests are being counted
    with open (path_logs, 'r') as log_lines:
        for linha in log_lines:
                
                if "error" in linha.lower():
                    response_error  += 1
                elif "critical" in linha.lower():
                     response_critical += 1
                elif "success" in linha.lower():
                     response_success += 1
            
response= response_error + response_critical + response_success
# Now, the script is processing the information collected from logs
# and is deciding which message will be shown
percent_success = ( response_success / response ) * 100
percent_critical = ( response_critical / response ) * 100
percent_error = ( response_error / response ) * 100

print("#"*50)
print( f'Total of requests: {response}')
print( f'Total of successful: {response_success}')
print( f'Total of errors: {response_error} ')
print( f'Total of critical: {response_critical}')
print("#"*50)
###############################################
print("Values of percents:")
print( f'Sucessful = {percent_success:.2f}%' )
print( f'Errors = {percent_error:.2f}%' )
print( f'Critical = {percent_critical:.2f}%' )
print("#"*50)

if int(percent_error) > 30 and int(percent_critical) > 10:
     print("The equipment is not operating properly and must be checked immediately")
elif int(percent_error) > 30 and int(percent_critical) < 10:
     print("The equipment needs the attention of the IT administrator.")
elif int(percent_error) < 30 and int(percent_critical) > 10:
     print("The equipment needs the attention of the IT administrator.")
else:
     print("The equipment is operating properly.")

print("#"*50)
