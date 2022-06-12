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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditService extends StatefulWidget {
  final int serviceId;

  const EditService({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<EditService> createState() => _EditService();
}

class _EditService extends State<EditService> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController cliController = TextEditingController();
  TextEditingController closingDateController = TextEditingController();

  late dynamic _service;

  Future<dynamic> getService() async {
    var _id = widget.serviceId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('${GlobalApi.url}/servicos/$_id');
    String? token = prefs.getString('access_token');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    var resBody = json.decode(response.body);

    setState(() {
      _service = resBody;
      descController.text = _service["description"];
      priceController.text = _service["price"];
      closingDateController.text = _service["closing_date"];
      var client = _service["client"];
      _mySelection = client["client_id"];

      var status = _service["status"];
      _mySelectionStatus = status["status_id"];
    });
    return null;
  }

  late bool updateServiceForm;

  final ClienteService _clienteService = ClienteService();
  List<RespCliente> respCliente = [];
  List data = [];
  List dataStatus = [];
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> itemsStatus = [];
  int _mySelection = 0;
  int _mySelectionStatus = 0;

  bool isLoading = false;

  Future<String> getDataStatus() async {
    var url = Uri.parse('${GlobalApi.url}/status');
    var response = await http.get(url);
    var resBody = json.decode(response.body);

    setState(() {
      dataStatus = resBody;
      itemsStatus = dataStatus
          .map((status) => DropdownMenuItem(
              child: Text(status['name']), value: status['status_id']))
          .toList();
      _mySelectionStatus = dataStatus[0]["status_id"];
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
    var status = Status();
    status.status_id = _mySelectionStatus;
    var price = int.parse(priceController.text);

    var _id = widget.serviceId;
    var data = RespService();

    data.description = descController.text;
    data.client = cliente;
    data.status = status;
    data.price = price;
    data.opening_date = _service["opening_date"];
    data.closing_date = closingDateController.text;

    var response = await ServicesService.updateService(_id, data);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      _showDialog('Serviço atualizado com sucesso!',
          'Volte para tela de serviços', true);
    } else {
      setState(() {
        isLoading = false;
      });
      _showDialog('Não foi possível atualizar este serviço', '', false);
    }
  }

  @override
  void initState() {
    super.initState();
    getDataStatus();
    getService();
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
            'Editar serviço',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: Colors.blue[700],
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              _showForm(),
            ],
          ),
        )));
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
                Icons.text_fields,
                color: Colors.grey,
              )),
          // validator: (value) => value!.isEmpty ? 'Informe a descrição' : null,
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
              Icons.price_change_outlined,
              color: Colors.grey,
            )),
        validator: (value) => value!.isEmpty ? 'Informe o valor' : null,
      ),
    );
  }

  Widget selectClossingDate() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    theme: const DatePickerTheme(
                        headerColor: Colors.black12,
                        backgroundColor: Colors.white,
                        itemStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        doneStyle:
                            TextStyle(color: Colors.black, fontSize: 16)),
                    onChanged: (date) {
                  // print('change $date in time zone ' +
                  //     date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  var now = date;
                  var _formattetime = DateTime(now.year, now.month, now.day);
                  setState(() {
                    closingDateController.text = _formattetime.toString();
                  });
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              icon: const Icon(
                Icons.date_range,
                size: 24.0,
              ),
              label: const Text('Data de fechamento'),
            ),
          ],
        ));
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
                backgroundColor: Colors.blue[500],
                fixedSize: const Size(190, 100),
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
                backgroundColor: Colors.red[500],
                fixedSize: const Size(190, 100),
                primary: Colors.blue[600],
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

  Widget selectStatus() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: DropdownButtonFormField<dynamic>(
        icon: const Icon(Icons.keyboard_arrow_down),
        iconSize: 15,
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
            hintText: 'Status',
            prefixIcon: const Icon(
              Icons.start_outlined,
              color: Colors.grey,
            )),
        hint: const Text('Status'),
        elevation: 16,
        items: itemsStatus,
        value: _mySelectionStatus,
        validator: (value) => value == null ? 'informe o status' : null,
        onChanged: (newVal) {
          setState(() {
            _mySelectionStatus = newVal as int;
          });
        },
      ),
    );
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
                    showDescriptioninput(),
                    showPriceInput(),
                    selectStatus(),
                    selectClossingDate(),
                    showPrimaryButton(),
                    showCancelButton(),
                  ],
                ),
              ),
            )));
  }
}
