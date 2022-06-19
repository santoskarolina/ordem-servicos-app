// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
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
  TextEditingController occupationAreaController = TextEditingController();

  bool _diseableButton = false;

  final Color _accentColor = const Color(0xFF272727);

  UserService userService = UserService();
  bool _isLoginForm = true;
  bool _isLoading = false;

  late final String connectionType;

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
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    getLoing();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      setState(() {
        connectionType = e.toString();
      });
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
        setState(() {
          connectionType = result.toString();
        });
        break;
      case ConnectivityResult.mobile:
        _diseableButton = false;
        setState(() {
          connectionType = result.toString();
        });
        break;
      case ConnectivityResult.none:
        _diseableButton = true;
        _showDialogConnection();
        break;
      default:
        _diseableButton = true;
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
    if (response?.statusCode == 201) {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage(
                  title: 'Services ON',
                )),
      );
    } else if (response?.statusCode == 401) {
      setState(() {
        _isLoading = false;
        _diseableButton = false;
      });
      _showDialog('Usuário e/ou senha incorretos',
          'Informe os dados corretamente', false, true);
    } else {
      setState(() {
        _isLoading = false;
        _diseableButton = false;
      });
      _showDialog('Não foi possível fazer o login',
          'Tente novamente mais tarde', false, true);
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
    account.occupation_area = occupationAreaController.text;
    var response = await UserService.createAccount(account);

    if (response.statusCode == 201) {
      resetForm();

      setState(() {
        _isLoading = false;
        _diseableButton = false;
        _isLoginForm = true;
      });

      _showDialog('Usuário criado com sucesso!',
          'Faça login para acessar o sistema', true, true);
    } else if (response.statusCode == 400) {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });

      _showDialog('Email já cadastrado', 'Utilize outro email', false, false);
    } else {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });
      _showDialog('Não foi possível criar sua conta',
          'Tente novamente mais tarde', false, false);
    }
  }

  void _showDialogConnection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  void _showDialog(String title, String subtitle, bool success, bool doLogin) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.2),
                    child: Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black54),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    genericButton(context),
                  ],
                )
              ],
            ),
          );
        });
  }

  // void dialog() {
  //   showDialog(
  //       context: context,
  //       builder: (_) {
  //         return AlertDialog(
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const SizedBox(height: 10.0),
  //               Image.asset("assets/close.png", width: 45.0),
  //               const SizedBox(height: 20.0),
  //               const Text('Oops!',
  //                   style: TextStyle(
  //                       fontSize: 25.0,
  //                       fontWeight: FontWeight.w800,
  //                       color: Color(0xFFE04F5F))),
  //               const SizedBox(height: 20.0),
  //               Text('Usuário e/ou senha incorretos.\nTente novamente.',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: 15.0,
  //                     fontWeight: FontWeight.w400,
  //                     color: _accentColor,
  //                   )),
  //               const SizedBox(height: 30.0),
  //               TextButton(
  //                 style: ButtonStyle(
  //                     backgroundColor:
  //                         MaterialStateProperty.all<Color>(_accentColor),
  //                     padding: MaterialStateProperty.all<EdgeInsets>(
  //                         const EdgeInsets.symmetric(
  //                             horizontal: 50.0, vertical: 15.0)),
  //                     shape: MaterialStateProperty.all<OutlinedBorder>(
  //                         RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5.0),
  //                     ))),
  //                 child: const Text('OK',
  //                     style: TextStyle(
  //                         fontSize: 13.0,
  //                         fontWeight: FontWeight.w800,
  //                         color: Colors.white)),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  Widget genericButton(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(11, 122, 222, 1),
                fixedSize: const Size(150, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Certo',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
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
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: TextFormField(
            maxLines: 1,
            maxLength: 100,
            controller: nomeController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 0.0),
                ),
                hintText: 'Nome',
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe o nome';
              } else if (value.length < 5) {
                return 'Informe um nome válido';
              }
              return null;
            }),
      );
    } else {
      return const SizedBox(
        height: 0.0,
        width: 0.0,
      );
    }
  }

  Widget showOccupationAreaInput() {
    if (!_isLoginForm) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: TextFormField(
            maxLines: 1,
            maxLength: 100,
            controller: occupationAreaController,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide:
                      const BorderSide(color: Colors.black12, width: 0.0),
                ),
                hintText: 'Ex.: Eletricista autonomo',
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.grey,
                )),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe sua area de atuação';
              }
              return null;
            }),
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
          maxLength: 100,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black12, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.black12, width: 0.0),
              ),
              hintText: 'Email',
              prefixIcon: const Icon(
                Icons.email_rounded,
                color: Colors.grey,
              )),
          validator: (value) {
            final bool isValid = EmailValidator.validate(value!);
            // print('Email is valid? ' + (isValid ? 'yes' : 'no'));
            if (value.isEmpty) {
              return 'Informe um email';
            } else if (isValid == false) {
              return 'Informe um email válido';
            }
            return null;
          }),
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
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black12, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(color: Colors.black12, width: 0.0),
              ),
              hintText: 'Senha',
              prefixIcon: const Icon(
                Icons.password,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe uma senha';
            } else if (value.length < 5) {
              return 'Senha deve ter mais de 5 caracteres';
            }
            return null;
          }),
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
          padding: const EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
          child: SizedBox(
            height: 55.0,
            child: TextButton(
              onPressed: () {
                if (_diseableButton) {
                  null;
                } else if (_formKey.currentState!.validate()) {
                  login();
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[500],
                  fixedSize: const Size(290, 100),
                  primary: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
          child: SizedBox(
            height: 55.0,
            child: TextButton(
              onPressed: () {
                if (_diseableButton) {
                  null;
                } else if (_formKey.currentState!.validate()) {
                  createAccount();
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[500],
                  fixedSize: const Size(290, 100),
                  primary: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
          ));
    } else {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  Widget showSecondaryButton() {
    return TextButton(
        child: Text(_isLoginForm ? 'Criar conta' : 'Fazer login',
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.black)),
        onPressed: _diseableButton ? null : toggleFormMode);
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
              showOccupationAreaInput(),
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
