import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'movie_list.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signup', // Set the initial route to '/signup'
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/movieList': (context) => MovieListPage(),
      },
    );
  }
}

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _profession;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('password', _passwordController.text);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _profession,
                hint: Text('Profession'),
                items: ['Teacher', 'Engineer', 'Doctor', 'Other']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _profession = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select your profession';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () => _registerUser(),
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedName = prefs.getString('name');
      String? savedPassword = prefs.getString('password');
      String enteredName = _nameController.text;
      String enteredPassword = _passwordController.text;

      if (enteredName == savedName && enteredPassword == savedPassword) {
        Navigator.pushReplacementNamed(context, '/movieList');
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Please enter valid username and password.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }

    }
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _loginUser,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
