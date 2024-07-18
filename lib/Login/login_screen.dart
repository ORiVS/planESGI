import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = ''; // Initialisation explicite
  String _password = ''; // Initialisation explicite

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
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
                onSaved: (input) => _password = input!, // Utilisation de _password
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: signIn,
                child: Text('Se connecter'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  navigateToRegisterScreen(context);
                },
                child: Text('Pas encore inscrit ? Inscrivez-vous ici'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Utilisez _email et _password pour connecter l'utilisateur
      print('Connecté avec $_email');
    }
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}
