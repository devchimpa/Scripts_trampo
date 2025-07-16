#!/usr/bin/python3
import os


logs_directory="/home2/backups/caderno/estudos/python/logs/"

def read_logs():
    
    total_response= 0
    total_response= 0
    total_error= 0
    total_success= 0
    total_critical= 0

    print('#'*31, "RESULTS", '#'*30)  
    
    log_results={}

    for archive in os.listdir(logs_directory):
        path_logs = logs_directory + archive
   
        with open(path_logs, 'r') as content_log:
            results_logs=content_log.read()
            log_name=archive[4:14:]
            response_log=results_logs.count("RESPONSE")
            response_error=results_logs.count("ERROR")
            response_success=results_logs.count("Success")
            response_critical=results_logs.count("CRITICAL")  
            #print(response_critical)
            print(f'{log_name}: Responses: {response_log} Successful: {response_success} Errors: {response_error} Critical: {response_critical} ' )
                
            total_response += response_log
            total_error += response_error
            total_success += response_success
            total_critical += response_critical

            log_results[log_name]={
                'responses':response_log,
                'errors':response_error,
                'success':response_success,
                'critical':response_critical
                }
            
    print('#'*70)        
    percent_success=( total_success / total_response * 100 )
    percent_error=( total_error / total_response * 100 )
    percent_critical=( total_critical / total_response * 100 )
    print(f'Total: Succesful: {percent_success:.2f}% Errors: {percent_error:.2f}% Critical: {percent_critical:.2f}%')
    print('#'*70)  

    for item in log_results.keys():
        #time.sleep(1)
        response_item=(log_results[item]['responses'])
        error_item=(( log_results[item]['errors']) / response_item * 100)
        critical_item=((log_results[item]['critical']) / response_item * 100)
        if error_item >= 30 and critical_item >= 10:
            print(f'The {item.capitalize()} is not operating properly and must be checked immediately.')
        elif error_item >= 30 and critical_item <= 10:
            print(f'The {item.capitalize()} needs the attention of the IT administrator.')
        elif error_item <= 30 and critical_item >= 10:
            print(f'The {item.capitalize()} needs the attention of the IT administrator.')
        else:
            print(f'The {item.capitalize()} is operating properly.')
        

read_logs()
