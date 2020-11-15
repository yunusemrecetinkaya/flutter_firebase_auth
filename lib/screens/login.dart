import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/anasayfa.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final keyController = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Giriş Yap'),
        centerTitle: true,
      ),
      body: Form(
        key: keyController,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email adresi giriniz';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Password adresi giriniz';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: () {
                  if (keyController.currentState.validate()) {
                    final email = emailController.text;
                    final sifre = passwordController.text;
                    girisYap(email, sifre,scaffoldKey);
                  }
                },
                child: Text('Giris Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> girisYap(String email,String sifre, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: sifre);
      if (userCredential != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Anasayfa()));
      }
    } on FirebaseAuthException catch (e) {
      switch(e.code){
        case 'user-not-found':
          final snackBar = SnackBar(
            content: Text('Bu e-posta için kullanıcı bulunamadı.'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          break;
        case'wrong-password':
          final snackBar = SnackBar(
            content: Text('Yanlış şifre girildi.'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          break;
      }
    } catch (e) {
      print('HATA ===>> $e');
    }
  }
}
