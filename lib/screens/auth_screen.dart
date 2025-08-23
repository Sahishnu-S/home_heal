import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget{
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLogin = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void authenticate() async {
    if (!_formKey.currentState!.validate()){
      return;
    }
    _isLoading = true;
    try {
      if (_isLogin){
        final AuthResponse res = await supabase.auth.signInWithPassword(
          email: emailController.text,
          password: passwordController.text
        );
        if (res.session == null){
          if (context.mounted) {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't log in. Please check your password and email and try again")));}
          _isLoading = false;
          return;
        }
      }
      else{
        await supabase.auth.signUp(
          email: emailController.text,
          password: passwordController.text,
          data: {
            'username' : usernameController.text,
          }
        );  
      }
    } on AuthException catch (e) {
      if (context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } 
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 300,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Image.asset('lib\\assets\\images\\App_Icon.png'),
              ),
              Text(
                _isLogin? "Log in": "Sign up",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text("Email address")
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 7 || !value.contains('@')){
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          label: Text("Password")
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null){
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      !_isLogin? TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          label: Text("Name")
                        ),
                        validator: (value) {
                          if ((value == null || value.trim().isEmpty) && !_isLogin){
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ):SizedBox(),
                      SizedBox(height: 30,),
                      ElevatedButton(
                        onPressed: authenticate,
                        child: !_isLoading ? Text(_isLogin? "Log in": "Sign Up") : CircularProgressIndicator()
                      ),
                      OutlinedButton(
                        onPressed: (){
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin? "I don't have an account" : "I already have an account")
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}