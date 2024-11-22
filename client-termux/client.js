const readline = require('readline'); // Pour saisir des entrées via la ligne de commande
const PROTO_PATH =  'C:/Users/rihem/Desktop/rihem_fichier/mon-travaill/hello-world-grpc/helloworld.proto'; // Chemin du fichier .proto
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

// Charger le fichier .proto
const packageDefinition = protoLoader.loadSync(PROTO_PATH, {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
});
const hello_proto = grpc.loadPackageDefinition(packageDefinition).helloworld;

// Créer une interface de lecture (pour saisir les entrées utilisateur)
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Demander le nom de l'utilisateur
rl.question('Quel est votre nom ? ', (name) => {
  // Demander la langue de l'utilisateur
  rl.question('Choisissez votre langue (fr, en, ar) : ', (language) => {
    // Vérification si la langue est valide
    if (!['fr', 'en', 'ar'].includes(language)) {
      console.log('Langue invalide, choisissez parmi "fr", "en" ou "ar"');
      rl.close();
      return;
    }

    // Adresse du serveur gRPC
    const SERVER_ADDRESS = '192.168.1.187:50051'; // Remplacez par l'adresse IP de votre serveur

    // Créer un client gRPC
    const client = new hello_proto.HelloWorld(
      SERVER_ADDRESS,
      grpc.credentials.createInsecure()
    );

    // Appeler la méthode SayHello avec les entrées de l'utilisateur
    client.SayHello({ name, language }, (error, response) => {
      if (error) {
        console.error('Erreur lors de l’appel gRPC :', error.message);
      } else {
        console.log('Réponse du serveur :', response.message);
      }
      rl.close(); // Fermer l'interface de lecture
    });
  });
});
