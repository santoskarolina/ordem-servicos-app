import 'package:flutter/material.dart';
import '../../api/cliente_api.dart';
import '../initial/home_page.dart';

class CreateClient extends StatefulWidget {
  const CreateClient({Key? key}) : super(key: key);

  @override
  State<CreateClient> createState() => _CreateClient();
}

class _CreateClient extends State<CreateClient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool isLoading = false;

  void save() async {
    setState(() {
      isLoading = true;
    });

    var response = await ClienteService.createCliente(nomeController.text, cpfController.text, telefoneController.text);
    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      _showDialog();
    } else if(response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      _showDialogCPF();
    }else{
      setState(() {
        isLoading = false;
      });
      _showDialogFail();
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Sucesso!'),
          content: const Text(
            "Cliente cadastrado com sucesso!",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(title: 'Services ON',)),
                );
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

  void _showDialogFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Falha!'),
          content: const Text(
            "Não foi possível salvar este cliente",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
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

  void _showDialogCPF() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Aviso!'),
          content: const Text(
            "CPF já registrado.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
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
          title: const Text( 'Cadastrar cliente',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor:const Color.fromRGBO(42,68,171, 1),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _showForm(),
            ],
          ),
        ));
  }

  Widget showNameinput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
  }

  Widget showCpfinput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: cpfController,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'CPF',
            icon: Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o CPF' : null,
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: telefoneController,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Telefone',
            icon: Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                save();
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(42,68,171, 1),
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : const Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
          ),
        ));
  }

  Widget showCancelButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.red[700],
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget _showForm() {
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showNameinput(),
              showCpfinput(),
              showPhoneInput(),
              showPrimaryButton(),
              showCancelButton(),
            ],
          ),
        ));
  }
}
