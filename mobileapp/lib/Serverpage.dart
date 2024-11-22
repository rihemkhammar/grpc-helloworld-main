import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:mobileapp/src/generated/helloworld.pbgrpc.dart';
import 'dart:developer' as devLog;

import 'package:protobuf/protobuf.dart';

import 'main.dart';

// Initial default port
int _port = 9999;
String stateServer = "Le serveur gRPC fonctionne en arrière-plan.";
String? Response;

// Implémentation du service HelloWorldService
class HelloWorldService extends HelloWorldServiceBase {
  final Function updateState;

  HelloWorldService(this.updateState);

  @override
  Future<HelloResponse> sayHello(ServiceCall call, HelloRequest request) async {
    print('Request received: ${request.language}');

    final messages = {
      'fr': ' Bonjour tout le monde',
      'en': ' Hello world',
      'ar': '  مرحبا بالعالم',
    };

    final message = messages[request.language] ?? 'Language not supported';

    stateServer = 'Request received: ${request.language}';
    Response = 'Response sent is: $message';
    print("Response : $Response");
    updateState(stateServer, Response);
    return HelloResponse()..message = message;
  }
}

Future<void> startGrpcServer(Function updateState, int port) async {
  final server = Server([HelloWorldService(updateState)]);

  try {
    await server.serve(port: port);
    print('Serveur gRPC en cours d\'exécution sur le port ${server.port}...');
  } catch (e) {
    print('Erreur lors du démarrage du serveur gRPC: $e');
  }
}

void main() {
  runApp(ServerApp());
}

class ServerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gRPC Server in Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _messagerequest = stateServer;
  final TextEditingController _portController = TextEditingController(text: _port.toString());

  @override
  void initState() {
    super.initState();
    startGrpcServer(updateState, _port);
  }

  void updateState(String newState, String resp) {
    setState(() {
      _messagerequest = newState + " \n" + resp;
    });
  }

  void _startServerWithPort() {
    setState(() {
      _port = int.tryParse(_portController.text) ?? 9999;
      startGrpcServer(updateState, _port);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('gRPC Server'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            runApp(MyApp());
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Port Number',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _startServerWithPort();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('gRPC Server is now running on port $_port'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text('Start Server with Port'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _messagerequest,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Footer section
          Container(
            color: Colors.blueGrey[50],
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                'By Rihem Khammar',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
