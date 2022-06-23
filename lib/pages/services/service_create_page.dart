import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/client_model.dart';
import '../../api/cliente_api.dart';
import '../../api/services_api.dart';
import '../../global_variable.dart';
import '../../models/services_model.dart';
import '../initial/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../utils/constantes.dart';

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
  List<RespCliente> respCliente = [];
  List data = [];
  List<DropdownMenuItem> items = [];
  int _mySelection = 0;

  late bool loadingData = true;

  bool isLoading = false;

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${GlobalApi.url}/clientes');
    String? token = prefs.getString('access_token');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    var resBody = json.decode(response.body);

    setState(() {
      data = resBody;
      items = data
          .map((item) => DropdownMenuItem(
              child: Text(item['name']), value: item['client_id']))
          .toList();
      _mySelection = data[0]["client_id"];
      loadingData = false;
    });
    return "Sucess";
  }

  void getClientes() async {
    final response = await _clienteService.getClintes();
    for (RespCliente cliente in response) {
      respCliente.add(cliente);
    }
  }

  void save() async {
    setState(() {
      isLoading = true;
    });

    var cliente =
        RespCliente(cell_phone: '', name: '', client_id: _mySelection);
    var service = ServiceCreate();
    service.client = cliente;
    service.description = descController.text;

    var price = int.parse(priceController.text);
    service.price = price;

    var response = await ServicesService.createService(service);
    if (response.statusCode == 201) {
      setState(() {
        isLoading = false;
      });
      _showDialog(
          'Serviço cadastrado com sucesso!', 'Volte para página inicial', true);
    } else {
      setState(() {
        isLoading = false;
      });
      _showDialog('Não foi possível cadastrar este serviço', '', false);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            'Services ON',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: Colors.blue[700],
        ),
        body: loadingData
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: _loadingDialog(),
                ),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    collumn(),
                  ],
                ),
              ));
  }

  Widget collumn() {
    return Column(
      children: [
        header(),
        _showForm(),
      ],
    );
  }

  Widget header() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Colors.black12,
      ))),
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      child: const Text(
        'Cadastrar serviço',
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: MyCustomColors.hexHeader),
      ),
    );
  }

  Widget showDescriptioninput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: TextFormField(
          maxLines: 1,
          maxLength: 200,
          controller: descController,
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
              hintText: 'Descrição',
              prefixIcon: const Icon(
                Icons.text_decrease,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe a descrição';
            } else if (value.length < 10) {
              return 'Descreva mais sobre o serviço';
            }
            return null;
          }),
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
            hintText: 'Valor',
            prefixIcon: const Icon(
              Icons.price_change,
              color: Colors.grey,
            )),
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
              if (_formKey.currentState!.validate()) {
                save();
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: MyCustomColors.hexColorConfirmButton,
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
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            style: TextButton.styleFrom(
                backgroundColor: MyCustomColors.hexColorCancelButton,
                fixedSize: const Size(390, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget selectUser() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: DropdownButtonFormField<dynamic>(
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 15,
        hint: const Text('Cliente'),
        elevation: 16,
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
            hintText: 'Valor',
            prefixIcon: const Icon(
              Icons.person,
              color: Colors.grey,
            )),
        items: items,
        value: _mySelection,
        validator: (value) => value == null ? 'informe o cliente' : null,
        onChanged: (newVal) {
          setState(() {
            _mySelection = newVal as int;
          });
        },
      ),
    );
  }

  Widget _showForm() {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            // elevation: 6,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black12, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.1, 10.0, 10.0, 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    showDescriptioninput(),
                    showPriceInput(),
                    selectUser(),
                    showPrimaryButton(),
                    showCancelButton(),
                  ],
                ),
              ),
            )));
  }
}
