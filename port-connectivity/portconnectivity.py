import csv
import socket
import os
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-inputfile", "--InputFile", help = "Path of Scan Input File")
parser.add_argument("-checktype", "--checktype", help = "Add checktype; Pre_Source/Pre_Target/Post ")
# Read arguments from command line
args = parser.parse_args()
# assign header columns
InputFile=args.InputFile
headerList = ['SourceHostname','SourceIP','Process','DestinationIP', 'RemotePort', 'PortStatus','PingStatus']
hostname = socket.gethostname()
Servername=InputFile.split("_")[0]
if(args.checktype=="Pre_Source"):
    MachineType="Source"
    Check="Pre"
elif(args.checktype=="Pre_Target"):
    MachineType="Target"
    Check="Pre"
else:
    MachineType="Target"
    Check="Post"
#Drafting Output CSV File
OutputCSVFile=Servername+'_'+Check+'_PortTest_'+MachineType+'.CSV'
#remove the file if exists
file = OutputCSVFile
if(os.path.exists(file) and os.path.isfile(file)):
  os.remove(file)
  print("Old File deleted!")
# open CSV file and assign header
with open(OutputCSVFile, 'w') as file:
    dw = csv.DictWriter(file, delimiter=',', fieldnames=headerList)
    dw.writeheader()
def is_port_open(ip_address, port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(1)
    try:
        s.connect((ip_address,int(port)))
        s.shutdown(2)
        return True
    except:
        return False
    s.close()
def check_ping(hostname, attempts = 1, silent = False):
    response = os.system('ping -c 1 -W 1 ' + hostname)
    if response == 0:
        return True
    else:
        return False
with open(InputFile, 'r' ) as input_file:
    reader = csv.DictReader(input_file)
    with open(OutputCSVFile,'a') as Output_file:
        local_ip = socket.gethostbyname(hostname)
        dictwriter_object = csv.DictWriter(Output_file, fieldnames=headerList)
        for Col in reader:
            dictwriter_object.writerow({'SourceHostname':hostname,'SourceIP':local_ip,'Process':Col['ProcessName'],'DestinationIP':Col['RemoteIp'],'RemotePort':Col['DestinationPort'],'PortStatus':is_port_open(Col['RemoteIp'],Col['DestinationPort']),'PingStatus':check_ping(Col['RemoteIp'])})
        Output_file.close()
