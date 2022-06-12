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

    var response = await ClienteService.createCliente(
        nomeController.text, cpfController.text, telefoneController.text);
    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      _showDialog('Cliente cadastrado com sucesso',
          'Acesse a pagina de clientes', true);
    } else if (response.statusCode == 400) {
      setState(() {
        isLoading = false;
      });
      _showDialog('CPF já cadastrado', 'Utilize outro cpf', false);
    } else {
      setState(() {
        isLoading = false;
      });
      _showDialog('Não foi possível cadastrar este cliente',
          'Tente novamente mais tarde', true);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cadastrar cliente',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              _showForm(),
            ],
          ),
        ));
  }

  Widget nameFormField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o nome';
            } else if (value.length < 5) {
              return 'Informe um nome válido';
            }
            return null;
          }),
    );
  }

  Widget cpfFormField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
          maxLines: 1,
          maxLength: 11,
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
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o cpf';
            } else if (value.length < 11) {
              return 'Informe um cpf válido';
            } else if (value.length > 11) {
              return 'Informe um cpf válido';
            }
            return null;
          }),
    );
  }

  Widget phoneFormField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
          maxLines: 1,
          maxLength: 25,
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe o telefone';
            } else if (value.length < 8) {
              return 'Informe um telefone válido';
            } else if (value.length > 25) {
              return 'Informe um telefone válido';
            }
            return null;
          }),
    );
  }

  Widget confirmButton() {
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
                backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
                fixedSize: const Size(390, 100),
                primary: Colors.blue[500],
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
              Navigator.pop(context),
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

  Widget _showForm() {
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
                    nameFormField(),
                    cpfFormField(),
                    phoneFormField(),
                    confirmButton(),
                    cancelButton(),
                  ],
                ),
              ),
            )));
  }
}
