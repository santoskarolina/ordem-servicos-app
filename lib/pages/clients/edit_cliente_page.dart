import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/client_model.dart';

import '../../api/cliente_api.dart';
import '../initial/home_page.dart';

class EditClient extends StatefulWidget {
  final int? clienteId;
  const EditClient({
    Key? key,
    required this.clienteId,
  }) : super(key: key);

  @override
  State<EditClient> createState() => _EditClient();
}

class _EditClient extends State<EditClient> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  Future<IRespCliente?>? _cliente;


  var cli;

  void getClienteById() {
    if (widget.clienteId != null) {
      cli = widget.clienteId;
      setState(() {
        _cliente = ClienteService.getClientById(cli!);
      });
    } else {
      print('not ok');
    }
  }
  

  @override
  void initState() {
    super.initState();
    getClienteById();
  }

  bool isLoading = false;

  void save(nome, phone, cpf) async {
    setState(() {
      isLoading = true;
    });

    IRespCliente newCliente = IRespCliente(name: nome, cell_phone: phone, cpf: cpf);

    var response = await ClienteService.updateCliente(cli, newCliente);
    if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      _showDialog('Cpf já registrado', false, false);
    } else  if(response.statusCode == 200){
      setState(() {
        isLoading = false;
      });
      _showDialog('Cliente atualizado com sucesso', true, true);
    }else{
      setState(() {
        isLoading = false;
      });
      _showDialog('Não foi possível atualizar este cliente', false, false);
    }
  }

  void _showDialog(String text, bool sucesso, bool goHome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(sucesso ? 'Sucesso' : 'oppss'),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goHome
                    ? Navigator.pop(context)
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage(
                                  title: 'Meus serviços',
                                )),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar cliente",
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(42,68,171, 1),
        ),
        body: SingleChildScrollView(
          child: Container(
          alignment: Alignment.center,
          child: FutureBuilder<IRespCliente?>(
            future: _cliente,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              IRespCliente response = snapshot.data!;
              nomeController.text = response.name!;
              cpfController.text = response.cpf!;
              telefoneController.text = response.cell_phone!;
                return Stack(
                   alignment: Alignment.center,
                  children: [
                    _showForm(response),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ))
      );
  }

  Widget showNameinput(response) {
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

  Widget showCpfinput(response) {
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

  Widget showPhoneInput(response) {
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

  Widget showPrimaryButton(response) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              save(nomeController.text, telefoneController.text, cpfController.text);
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

  Widget _showForm(response) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              showNameinput(response),
              showCpfinput(response),
              showPhoneInput(response),
              showPrimaryButton(response),
              showCancelButton(),
            ],
          ),
        ));
  }
}
