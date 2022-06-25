// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'package:flutter_application_1/pages/utils/constantes.dart';
import 'package:select_dialog/select_dialog.dart';

import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_application_1/api/user_api.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'home_page.dart';
import 'package:badges/badges.dart';

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
  bool userHasSelectPhoto = false;

  List<UserAvatar> items = [
    UserAvatar(
        id: '1',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-01.png',
        photoName: 'Avatar 01'),
    UserAvatar(
        id: '2',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-02.png',
        photoName: 'Avatar 02'),
    UserAvatar(
        id: '3',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-03.png',
        photoName: 'Avatar 03'),
    UserAvatar(
        id: '4',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-04.png',
        photoName: 'Avatar 04'),
    UserAvatar(
        id: '5',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-05.png',
        photoName: 'Avatar 05'),
    UserAvatar(
        id: '6',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-06.png',
        photoName: 'Avatar 06'),
    UserAvatar(
        id: '7',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-07.png',
        photoName: 'Avatar 07'),
    UserAvatar(
        id: '8',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-08.png',
        photoName: 'Avatar 08'),
    UserAvatar(
        id: '9',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-09.png',
        photoName: 'Avatar 09'),
    UserAvatar(
        id: '10',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-10.png',
        photoName: 'Avatar 10'),
    UserAvatar(
        id: '11',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-11.png',
        photoName: 'Avatar 11'),
    UserAvatar(
        id: '12',
        photoUrl: 'https://services-on.netlify.app/assets/avatar-12.png',
        photoName: 'Avatar 12'),
  ];

  UserService userService = UserService();
  UserAvatar? ex1;

  dynamic userPhoto = "https://services-on.netlify.app/assets/user-default.png";

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
          'Informe os dados corretamente', false);
    } else {
      setState(() {
        _isLoading = false;
        _diseableButton = false;
      });
      _showDialog('Não foi possível fazer o login',
          'Tente novamente mais tarde', false);
    }
  }

  void createAccount() async {
    setState(() {
      _isLoading = true;
      _diseableButton = true;
    });

    UserCreateAccount account = UserCreateAccount();
    if (userPhoto != null) {
      dynamic photo = userPhoto;
      account.photo = photo;
    } else {
      account.photo = '';
    }
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
          'Faça login para acessar o sistema', true);
    } else if (response.statusCode == 400) {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });

      _showDialog('Email já cadastrado', 'Utilize outro email', false);
    } else {
      setState(() {
        _diseableButton = false;
        _isLoading = false;
      });
      _showDialog('Não foi possível criar sua conta',
          'Tente novamente mais tarde', false);
    }
  }

  void _showDialogConnection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ops...'),
          content: const Text('Você está sem conexão com a internet'),
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

  void _showDialog(String title, String subtitle, bool success) {
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
        elevation: 6,
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
    if (!_isLoginForm) {
      return const SizedBox(
        height: 0.0,
        width: 0.0,
      );
    } else {
      return Center(
        child: Container(
          width: 310.0,
          height: 200.0,
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    'assets/login.png',
                  ))),
        ),
      );
    }
  }

  Widget circleImageNewUser() {
    return Center(
      child: Container(
        width: 310.0,
        height: 200.0,
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(
                  userPhoto,
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

  Widget buttonPickAvatar() {
    if (_isLoginForm) {
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    } else {
      return Container(
          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 9.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<dynamic>(
                      context,
                      label: "Escolha seu avatar",
                      items: items,
                      selectedValue: ex1,
                      itemBuilder: (context, dynamic item, bool isSelected) {
                        return Container(
                          decoration: !isSelected
                              ? null
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor),
                                ),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: item.photoUrl == null
                                    ? null
                                    : NetworkImage(item.photoUrl)),
                            selected: isSelected,
                            title: Text(item.photoName),
                            // subtitle: Text(item.photoName.toString()),
                          ),
                        );
                      },
                      onChange: (selected) async {
                        UserAvatar user = selected;
                        setState(() {
                          userHasSelectPhoto = true;
                          userPhoto = user.photoUrl;
                          ex1 = user;
                        });
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: MyCustomColors.hexColorCircleAvatar,
                    child: ClipOval(
                      child: Image.network(
                        userPhoto,
                      ),
                    ),
                  )),
              Positioned(
                top: 2,
                right: 110,
                child: Badge(
                  badgeColor: Colors.white,
                  badgeContent: userHasSelectPhoto
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const Icon(Icons.question_mark, color: Colors.red),
                ),
              ),
            ],
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
              onPressed: () async {
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
              buttonPickAvatar(),
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
