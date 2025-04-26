import socket
import threading
def run_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = ("localhost", 1035)
    server.bind(server_address)
    server.listen(1)
    print("Waiting for a connection...")
    connection, client_address = server.accept()
    print("Connection accepted from:", client_address)
    file_name = "niraj1.txt"
    connection.sendall(file_name.encode())
    # Open the file in binary mode to handle non-ASCII characters or large files
    try:
        with open(file_name, "rb") as file:
            # Read the file data in binary mode and send it
            data = file.read()
            connection.sendall(data)
        print("File sent successfully.")
    except FileNotFoundError:
        print(f"The file '{file_name}' was not found!")
    connection.close()
    server.close()
def run_client():
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = ("localhost", 1035)
    client.connect(server_address)
    # Receive the file name from the server
    file_name = client.recv(1024).decode()
    print(f"File to be received: {file_name}")
    # Open the file in binary mode to receive the file correctly
    with open("received_" + file_name, "wb") as file:
        while True:
            data = client.recv(4096)
            if not data:
                break
            file.write(data)
    client.close()
    print("File received successfully.")
# Run the server and client in the same file
if __name__ == "__main__":
    # Start the server in a separate thread
    server_thread = threading.Thread(target=run_server)
    server_thread.start()
    # Run the client in the main thread
    run_client()
    # Wait for the server thread to finish
    server_thread.join()
