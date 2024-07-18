import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = ''; // Initialisation explicite
  String _password = ''; // Initialisation explicite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                validator: (input) {
                  if (input?.isEmpty ?? true) {
                    return 'Veuillez entrer votre e-mail';
                  }
                  return null;
                },
                onSaved: (input) => _email = input!,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextFormField(
                validator: (input) {
                  if (input == null || input.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
                onSaved: (input) => _password = input!,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: Text('S\'inscrire'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  navigateToLoginScreen(context);
                },
                child: Text('Déjà inscrit ? Connectez-vous ici'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        // Utilisation du service d'authentification pour inscrire l'utilisateur
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print('Inscription réussie avec ${userCredential.user?.email}');
        navigateToLoginScreen(context);
      } catch (e) {
        // Gérer spécifiquement les erreurs de FirebaseAuthException
        if (e is FirebaseAuthException) {
          print('Erreur d\'authentification: ${e.message}');
          // Vous pouvez également utiliser e.code pour obtenir le code d'erreur
        } else {
          // Autres erreurs
          print('Erreur: $e');
        }
      }
    }
  }

  void navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
