import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/services/service_edit_page.dart';
import 'package:intl/intl.dart';

import '../../api/services_api.dart';
import '../../models/services_model.dart';

class ServiceInfoPage extends StatefulWidget {
  final int serviceId;

  const ServiceInfoPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<ServiceInfoPage> createState() => _ServiceInfoPageState();
}

class _ServiceInfoPageState extends State<ServiceInfoPage> {
  late Future<RespService> _service;

  void getService() async {
    setState(() {
      _service = ServicesService.getServiceById(widget.serviceId);
    });
  }

  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }

  @override
  void initState() {
    super.initState();
    getService();
  }

  Widget _loadingDialog() {
    return AlertDialog(
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircularProgressIndicator(),
          ),
          const Text('Carregando...'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Informações do serviço',
            textAlign: TextAlign.center,
          ),
          actions: null,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
        ),
        backgroundColor: Colors.white,
        body: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: FutureBuilder<RespService>(
                future: _service,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    RespService? resp = snapshot.data;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        _showContainer(resp),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return _loadingDialog();
                },
              ),
            )));
  }

  Widget _showCard(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: const Text("Descrição"),
              subtitle: Text(snapshot!.description),
            ),
            ListTile(
              title: const Text("Status"),
              subtitle: Text(snapshot!.status.name!),
            ),
            ListTile(
              title: const Text("Data de abertura"),
              subtitle: Text(getFormatedDate(snapshot!.opening_date)),
            ),
            ListTile(
                title: const Text("Data de fechamento"),
                subtitle: snapshot!.closing_date == "" ||
                        snapshot!.closing_date == null
                    ? const Text('Serviço em aberto')
                    : Text(getFormatedDate(snapshot!.closing_date))),
            ListTile(
              title: const Text("Cliente"),
              subtitle: Text(snapshot!.client.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionsButton(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 0.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [showDeleteButton(snapshot), showEditButton(snapshot)]),
    );
  }

  Widget showEditButton(resp) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 9.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditService(serviceId: resp.service_id),
                  ))
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
                fixedSize: const Size(150, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ));
  }

  Widget showDeleteButton(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 9.0, 10.0, 0.0),
      child: SizedBox(
        height: 55.0,
        child: TextButton(
          onPressed: () => {Navigator.pop(context)},
          style: TextButton.styleFrom(
              backgroundColor: Colors.red[700],
              fixedSize: const Size(150, 100),
              primary: Colors.blue[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget circleImage() {
    return Center(
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(
                  'assets/service.jpg',
                ))),
      ),
    );
  }

  Widget _showContainer(resp) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [circleImage(), _showCard(resp), actionsButton(resp)],
      ),
    );
  }
}
