import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final keyController = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Kayıt Ol'),
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
                    final password = passwordController.text;
                    kayitOl(email, password, scaffoldKey);
                  }
                },
                child: Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> kayitOl(String email, String password, GlobalKey<ScaffoldState> scaffoldKey) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential != null) {
        final snacBar = SnackBar(
          content: Text('Kayıt Başarılı'),
        );
        return scaffoldKey.currentState.showSnackBar(snacBar);
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          final snackBar = SnackBar(
            content: Text('Girilen şifre zayıf.'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          break;
        case 'emaıl-already-ın-use':
          final snackBar = SnackBar(
            content: Text('Bu e-posta için hesap zaten var.'),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          break;
      }
    } catch (e) {
      print('HATA ===>> $e');
    }
  }


}
