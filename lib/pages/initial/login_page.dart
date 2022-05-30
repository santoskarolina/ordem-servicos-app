import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/user_api.dart';
import 'package:flutter_application_1/models/user_model.dart';

import 'home_page.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  UserService userService = UserService();
  bool _isLoading  = false;
  bool _isLoginForm  = true;

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void resetForm(){
    setState(() {
    nomeController.text = '';
    emailController.text = '';
    senhaController.text = '';
    });
  }
  

 @override
 void initState(){
   _isLoginForm = true;
   super.initState();
 }

 void login() async {
   setState(() {
      _isLoading = true;
   });
    UserRequest userRequest = UserRequest();
    userRequest.email = emailController.text;
    userRequest.password = senhaController.text;
    var response = await  UserService.login(userRequest);
    if (response) {
      setState(() {
      _isLoading = false;
   });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const HomePage(title: 'Services ON',)),
      );
    }else{
      setState(() {
      _isLoading = false;
      });
      _showDialog();
    }
  }

  void createAccount() async {
    setState(() {
      _isLoading = true;
    });
    UserCreateAccount account = UserCreateAccount();
    account.email = emailController.text;
    account.password = senhaController.text;
    account.user_name = nomeController.text;
    var response = await UserService.createAccount(account);
    if (response.statusCode == 201) {
      resetForm();
      setState(() {
        _isLoading = false;
        _isLoginForm = true;
      });

      _userCreated();
    } else if (response.statusCode == 400) {
      setState(() {
        _isLoading = false;
      });

      email();
    }
  }

   void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          content: const Text(
            "Usuário e/ou senha incorretos",
            style:  TextStyle(fontSize: 25),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  fixedSize: const Size(100, 60),
                  primary: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: const Text(
                'Fechar',
              ),
            ),
          ],
        );
      },
    );
  }

  void _userCreated() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuário criado com sucesso!'),
          content: const Text(
            "Faça o login para acessar o aplicativo",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                _isLoginForm = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Login',
              ),
            ),
          ],
        );
      },
    );
  }


 void email() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Oopsss'),
          content: const Text(
            "Email já registrado",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                _isLoginForm = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
              ),
            ),
          ],
        );
      },
    );
  }

 void _userCreatedFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Falha!'),
          content: const Text(
            "Não foi possível criar a conta",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _isLoginForm = true;
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
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
          automaticallyImplyLeading: false,
          actions: null,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(42,68,171, 1),
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
      child : Container(
      width: 210.0,
      height: 210.0,
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
      decoration: const BoxDecoration(
          // color: Colors.blue,
          shape: BoxShape.circle,
          image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/home.png',)
            )
        ),
     ),
   );
  } 

  Widget showUserNameInput(){
    if(!_isLoginForm){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child:  TextFormField(
        maxLines: 1,
        controller: nomeController,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration:   const InputDecoration(
            hintText: 'Nome',
            icon:  Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
      ),
    );
    }else{
      return const SizedBox(
      height: 0.0,
      width: 0.0,
    );
    }
  }

  Widget showEmailInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child:  TextFormField(
        maxLines: 1,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration:   const InputDecoration(
            hintText: 'Email',
            icon:  Icon(
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
      child:   TextFormField(
        maxLines: 1,
        controller: senhaController,
        obscureText: true,
        autofocus: false,
        decoration:  const InputDecoration(
            hintText: 'Senha',
            icon:  Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe a senha' : null,
      ),
    );
  }

  Widget showPrimaryButton() {
    if(!_isLoginForm){
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }else{
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                login();
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(42,68,171, 1),
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ))
                : const Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        )
    );
    }
  }

  Widget showButtonCreateAccount() {
    if(!_isLoginForm) {
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
                backgroundColor: const Color.fromRGBO(42,68,171, 1),
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ))
                : const Text(
                    'Criar conta',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        )
    );
    }else{
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
  }

Widget showSecondaryButton() {
    return TextButton(
        child: Text(
            _isLoginForm ? 'Criar conta' : 'Fazer login',
            style: const  TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
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
