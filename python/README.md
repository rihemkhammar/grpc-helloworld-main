# gRPC HelloWorld Application in Python

This project demonstrates a simple gRPC-based client-server application that sends "Hello World" messages in multiple languages. The server responds with a message in French, English, or Arabic based on the user's input.

## Prerequisites

- **Python 3.x**
- **gRPC and protobuf libraries** (install instructions below)

## Setting Up the Environment

### Step 1: Create a Virtual Environment

Create a virtual environment to isolate the project dependencies:

```bash
python -m venv grpcEnv
```

### Step 2: Activate the Virtual Environment

Activate the environment based on your operating system:

- **Windows**:
  ```bash
  .\grpcEnv\Scripts\activate
  ```
  
- **Linux / macOS**:
  ```bash
  source ./grpcEnv/bin/activate
  ```

### Step 3: Install Dependencies

Install the necessary packages using `pip`. You can either use the `requirements.txt` file or manually install the specific package versions.

- **Option 1:** Install from `requirements.txt`

    ```bash
    pip install -r requirements.txt
    ```

- **Option 2:** Manually Install Dependencies

    ```bash
    pip install grpcio==1.66.1 grpcio-tools==1.66.1 protobuf==5.27.2
    ```

### Step 4: Compile the Protobuf Files


To generate the Python protobuf and gRPC interfaces from the `.proto` file, run the following command:

```bash
python -m grpc_tools.protoc --python_out=. --grpc_python_out=. --proto_path=..\protos helloworld.proto
```

This command will generate the necessary Python code to interact with the `helloworld.proto` definitions.


## Running the gRPC Server

To start the gRPC server, run the following command in a terminal inside this folder:

```bash
python server.py
```

This will start the server on the default port (`9999`).

#### Specifying a Custom Port

If you want to run the server on a different port, you can specify it using the `--port` argument:

```bash
python server.py --port 50051
```

## Running the gRPC Client


The client supports various options to control the number of responses, the delay between them, and how it connects to the server.

### Basic Usage

Specify the language when running the client. Supported languages are:

- `fr` for French
- `en` for English
- `ar` for Arabic

Example:

```bash
python client.py en
```

This sends a request in English to the server running on `127.0.0.1:9999`.

### Custom IP and Port

By default, the client connects to `localhost` on port `9999`. To use a custom IP and port:

```bash
python client.py fr --ip 127.0.0.1 --port 50051
```

### Specify Number of Replies and Delay

The client can request multiple replies from the server using gRPC streams:

- `--count` (default: 1): Specifies how many replies to receive. If `count > 1`, the server will use gRPC streaming to send multiple responses.
- `--intervalMS` (default: 0): Sets the delay in milliseconds between each reply when `count > 1`.

Example:

```bash
python client.py en --count 5 --intervalMS 200 --port 9999 --ip 127.0.0.1
```

This requests 5 replies from the server with a 200 ms delay between each one.

### Random Language Testing

To send requests with a randomly chosen language every second:

```bash
python client.py --random-test
```

You can combine this with the `--count` and `--intervalMS` options to stream multiple replies:

```bash
python client.py --random-test --count 5 --intervalMS 200 --port 9999 --ip 127.0.0.1
```

This sends random requests every second, receiving 5 replies with a 200 ms delay between each.

## Summary

This simple gRPC application demonstrates:

- A server that responds in multiple languages (French, English, Arabic)
- A client that can request a greeting in a specified language
- The ability to connect the client to any IP address and port
- The option to run randomized requests to the server


