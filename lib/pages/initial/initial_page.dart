import 'package:flutter/material.dart';

import 'login_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 6,
          title: const Text(
            'Services ON',
            textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
          actions: null,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
        ),
        body: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Column contents vertically,,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                _showForm(context),
              ],
            ),
          ],
        ));
  }

  Widget circleImage() {
    return Center(
      child: Container(
        width: 310.0,
        height: 310.0,
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  'assets/initial.png',
                ))),
      ),
    );
  }

  Widget showPrimaryButton(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Loginpage(loginConfirm: true)),
              );
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                fixedSize: const Size(290, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget showPrimaryButtonCreate(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Loginpage(loginConfirm: false)),
              );
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue[500],
                fixedSize: const Size(290, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            child: const Text(
              'Criar conta',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget _showForm(context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            circleImage(), //imagem
            showPrimaryButton(context), //login
            showPrimaryButtonCreate(context) //criar conta
          ],
        ));
  }
}
