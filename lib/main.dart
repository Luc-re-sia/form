import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBpstRf2KHPLRf1cIIxoKcMn0SPeX2pBeE",
  authDomain: "zionapp-db7c3.firebaseapp.com",
  projectId: "zionapp-db7c3",
  storageBucket: "zionapp-db7c3.appspot.com",
  messagingSenderId: "188359420817",
  appId: "1:188359420817:web:9980eae95cd64230450830",
  measurementId: "G-TCSBRWEVJD"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/dashboard': (context) => Dashboard(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
   TextEditingController _errors = TextEditingController();

    Future<void> _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      // Sign in success, mo balhin sa dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      _errors.text = '$e';
    } catch (e) {
      _errors.text = '$e';
    }
  }
    Future<void> _signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
            _errors.text = 'registered';
  
    } on FirebaseAuthException catch (e) {
      _errors.text = '$e';
    } catch (e) {
      _errors.text = '$e';
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        color: Color.fromARGB(255, 238, 167, 208),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20.0),
            width: 450.0,
            height: 450.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                            //errors
            SizedBox(height: 8.0),
            TextField(
              controller: _errors,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Error',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.red),
            ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                //login button
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                   _signIn();
                  },
                  child: Text('Login'),
                ),
                //signup button
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _signUp() ;
                  },
                  child: Text('Sign Up'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.signOut,
              size: 40.10,
              color: Colors.red,
            ),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Dashboard!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Logged in as:',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              user != null ? user.email ?? '' : '',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}