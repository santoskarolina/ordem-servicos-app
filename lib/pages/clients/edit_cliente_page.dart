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
  bool _diseableButton = false;

  void save(nome, phone, cpf) async {
    setState(() {
      _diseableButton = true;
      isLoading = true;
    });

    IRespCliente newCliente =
        IRespCliente(name: nome, cell_phone: phone, cpf: cpf);

    var response = await ClienteService.updateCliente(cli, newCliente);
    if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      _showDialog('CPF já registrado', 'Use outro cpf', false);
    } else if (response.statusCode == 200) {
      setState(() {
        _diseableButton = true;
        isLoading = false;
      });
      _showDialog(
          'Cliente atualizado com sucesso', 'Volte para tela inicial', true);
      setState(() {
        _diseableButton = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      _showDialog('Não foi possível atualizar este cliente',
          'Tente novamente mais tarde', false);
    }
  }

  void callFunction(String message, String subtitle, bool action) {
    setState(() {
      _diseableButton = true;
      isLoading = false;
    });
    _showDialog(message, subtitle, action);
    setState(() {
      _diseableButton = false;
      isLoading = false;
    });
  }

  void _showDialog(String title, String subtitle, bool goHome) {
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
                    genericButton(context, goHome),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget genericButton(context, goHome) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              goHome
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage(
                                title: 'Services ON',
                              )),
                    )
                  : Navigator.pop(context);
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

  Widget _loadingDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 16,
      backgroundColor: Colors.white,
      child: Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Text('Carregando...')
          ],
        ),
      ),
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
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
      ),
      body: Container(
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
            return _loadingDialog();
          },
        ),
      ),
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
            hintText: 'Nome',
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
      ),
    );
  }

  Widget showCpfinput(response) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: cpfController,
        keyboardType: TextInputType.number,
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
            hintText: 'CPF',
            prefixIcon: const Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o CPF' : null,
      ),
    );
  }

  Widget showPhoneInput(response) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: telefoneController,
        keyboardType: TextInputType.number,
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
            hintText: 'Telefone',
            prefixIcon: const Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o telefone' : null,
      ),
    );
  }

  Widget confirmButton(response) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              if (_diseableButton) {
                null;
              } else if (_formKey.currentState!.validate() &&
                  !_diseableButton) {
                (save(nomeController.text, telefoneController.text,
                    cpfController.text));
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue[500],
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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

  Widget cancelButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () => {
              _diseableButton ? null : Navigator.pop(context),
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.red[500],
                fixedSize: const Size(390, 100),
                primary: Colors.red[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
        padding: const EdgeInsets.all(8.0),
        child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.1, 10.0, 10.0, 10.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    showNameinput(response),
                    showCpfinput(response),
                    showPhoneInput(response),
                    confirmButton(response),
                    cancelButton(),
                  ],
                ),
              ),
            )));
  }
}
