// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/api/user_api.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'home_page.dart';

class Loginpage extends StatefulWidget {
  final bool loginConfirm;
  const Loginpage({Key? key, required this.loginConfirm}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  String _mySelection = "";
  bool _diseableButton = false;


  UserService userService = UserService();
  bool _isLoginForm = true;
  bool _isLoading = false;

final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  void getLoing() {
    if (widget.loginConfirm) {
      _isLoginForm = true;
    } else {
      _isLoginForm = false;
    }
  }
  
  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void resetForm() {
    setState(() {
      nomeController.text = '';
      emailController.text = '';
      senhaController.text = '';
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    getLoing();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
}
    

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
         _diseableButton = false;
        setState(() => print(result.toString()));
        break;
      case ConnectivityResult.mobile:
         _diseableButton = false;
      setState(() => print(result.toString()));
        break;
      case ConnectivityResult.none:
         _diseableButton = true;
        _showDialogConnection();
        break;
      default:
        _showDialogConnection();
        break;
    }
  }

@override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  void login() async {
    setState(() {
      _isLoading = true;
      _diseableButton = true;
    });
    UserRequest userRequest = UserRequest();

    userRequest.email = emailController.text;
    userRequest.password = senhaController.text;

    var response = await UserService.login(userRequest);
    if (response) {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage(title: 'Services ON',)),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      _showDialog('Usuário e/ou senha incorretos', false, true);
    }
  }

  void createAccount() async {
    setState(() {
      _isLoading = true;
      _diseableButton = true;
    });
    UserCreateAccount account = UserCreateAccount(photo: '');
    account.email = emailController.text;
    account.password = senhaController.text;
    account.user_name = nomeController.text;
    var response = await UserService.createAccount(account);

    if (response.statusCode == 201) {
      resetForm();

      setState(() {
        _isLoading = false;
      _diseableButton = false;
        _isLoginForm = true;
      });

      _showDialog('Usuário criado com sucesso!', true, true);
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });

      _showDialog('Email já cadastrado', false, false);
    }
  }

  void _showDialogConnection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: const Text('Ops...'),
          content: const Text('Voê está sem conexão com a internet'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fechar',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String text, bool success, bool doLogin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Sucesso!' : 'Ooppss'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  doLogin ? _isLoginForm = true : _isLoginForm = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fechar',
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Services ON',
          textAlign: TextAlign.center,
        ),
        // automaticallyImplyLeading: false,
        actions: null,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
      ),
      body: Stack(
        children: [
          _showForm(),
        ],
      ),
    );
  }

  Widget circleImage() {
    return Center(
      child: Container(
        width: 310.0,
        height: 200.0,
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.contain,
                image: _isLoginForm
                    ? const AssetImage(
                        'assets/login.png',
                      )
                    : const AssetImage(
                        'assets/account.png',
                      ))),
      ),
    );
  }

  Widget showUserNameInput() {
    if (!_isLoginForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: TextFormField(
          maxLines: 1,
          controller: nomeController,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: const InputDecoration(
              hintText: 'Nome',
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
        ),
      );
    } else {
      return const SizedBox(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Email',
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o email' : null,
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: senhaController,
        obscureText: true,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Senha',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe a senha' : null,
      ),
    );
  }

  Widget showPrimaryButton() {
    if (!_isLoginForm) {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    } else {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          child: SizedBox(
            height: 55.0,
            child: TextButton(
              onPressed: () {
                if(_diseableButton){
                  null;
                }
                else if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
                  fixedSize: const Size(290, 100),
                  primary: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  )),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : const Text(
                      'Entrar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
            ),
          ));
    }
  }

  Widget showButtonCreateAccount() {
    if (!_isLoginForm) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          child: SizedBox(
            height: 55.0,
            child: TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  createAccount();
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
                  fixedSize: const Size(290, 100),
                  primary: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  )),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : const Text(
                      'Criar conta',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
            ),
          )
        );
    } else {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  Widget showSecondaryButton() {
    return TextButton(
        child: Text(_isLoginForm ? 'Criar conta' : 'Fazer login',  style:const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode
      );
  }

  Widget _showForm() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              circleImage(),
              showUserNameInput(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showButtonCreateAccount(),
              showSecondaryButton(),
            ],
          ),
    ));
  }
}
