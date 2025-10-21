--TCP server using sockets
import socket as s

serversocket = s.socket(s.AF_INET, s.SOCK_STREAM)
host = s.gethostname()
ip = s.gethostbyname(host)
port = 444

serversocket.bind((ip, port))
serversocket.listen(3)
print(f"Server started on {ip}:{port}")

while True:
    clientsocket, address = serversocket.accept()
    print("Received connection from", address)
    message = "Hello, thank you for connecting to the server"
    clientsocket.send(message.encode())
    clientsocket.close()
