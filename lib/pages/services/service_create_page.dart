import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/client_model.dart';
import '../../api/cliente_api.dart';
import '../initial/home_page.dart';

class CreateService extends StatefulWidget {
  const CreateService({Key? key}) : super(key: key);

  @override
  State<CreateService> createState() => _CreateService();
}

class _CreateService extends State<CreateService> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController cliController = TextEditingController();

  final ClienteService _clienteService = ClienteService();
  late Future<List<RespCliente>> _clientes;
  bool isLoading = false;

  getClientes() async {
    _clientes = _clienteService.get();
  }

  @override
  void initState() {
    super.initState();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Sucesso!'),
          content: const Text(
            "Serviço cadastrado com sucesso!",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
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

  void _showDialogFail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Falha!'),
          content: const Text(
            "Não foi possível salvar este serviço",
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
          title: const Text(
            'Cadastrar serviço',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: Colors.blue[700],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _showForm(),
            ],
          ),
        ));
  }

  Widget showDescriptioninput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: descController,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Descrição',
            icon: Icon(
              Icons.description,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
      ),
    );
  }

  Widget showPriceInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        controller: priceController,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: const InputDecoration(
            hintText: 'Valor',
            icon: Icon(
              Icons.money,
              color: Colors.grey,
            )
          ),
        validator: (value) => value!.isEmpty ? 'Informe o valor' : null,
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
            },
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue[700],
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
              showDescriptioninput(),
              showPriceInput(),
              showPrimaryButton(),
              showCancelButton(),
            ],
          ),
        ));
  }
}
