import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/services/service_edit_page.dart';
import 'package:intl/intl.dart';

import '../../api/services_api.dart';
import '../../models/services_model.dart';
import '../initial/home_page.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ServiceInfoPage extends StatefulWidget {
  final int serviceId;

  const ServiceInfoPage({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<ServiceInfoPage> createState() => _ServiceInfoPageState();
}

class _ServiceInfoPageState extends State<ServiceInfoPage> {
  late Future<RespService> _service;
  var serviceIdbutton;

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

  void deletarServico(int id) async {
    var response = await ServicesService.deletarService(id);
    if (response.statusCode == 200) {
      message('Serviço deletado com sucesso', 'Volte para página principal',
          true, true);
    } else {
      message('Não foi possível deletar este serviço',
          'Tente novamente mais tarde', false, false);
    }
  }

  void message(String title, String subtitle, bool goHome, bool icon) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: icon
                        ? Image.asset("assets/success.png")
                        : Image.asset("assets/close.png")),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.2),
                    child: Text(
                      subtitle,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.black54),
                    )),
                genericButton(context, true),
              ],
            ),
          );
        });
  }

  Widget genericButton(context, goHome) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      height: 55.0,
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ))),
        child: const Text('OK',
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
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
      ),
    );
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
          'Informações do serviço',
          textAlign: TextAlign.center,
        ),
        actions: null,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
      ),
      backgroundColor: Colors.white,
      body: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: FutureBuilder<RespService>(
              future: _service,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  RespService? resp = snapshot.data;
                  serviceIdbutton = resp?.service_id;
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      _showContainer(resp),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Center(
                    child: _loadingDialog(),
                  ),
                );
              },
            ),
          )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue[600],
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        closeManually: false,
        children: [
          SpeedDialChild(
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: 'Deletar',
              backgroundColor: Colors.red,
              onTap: () {
                _showDialog(serviceIdbutton);
              }),
          SpeedDialChild(
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue[900],
              label: 'Editar',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditService(serviceId: serviceIdbutton),
                    ));
              }),
        ],
      ),
    );
  }

  Widget circleImage(snapshot) {
    return Container(
      width: double.infinity,
      height: 290.0,
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle, color: Color.fromRGBO(70, 143, 175, 1)
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Color.fromRGBO(70, 143, 175, 1),
          //     Color.fromRGBO(168, 214, 229, 1),
          //     Color.fromRGBO(137, 194, 217, 1),
          //     Color.fromRGBO(70, 143, 175, 1),
          //   ],
          // ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 170.0,
              height: 170.0,
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage("assets/service.jpg"),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            snapshot.description,
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget priceService(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    AntIcons.playCircleOutlined,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valor',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      ('R\$ ${snapshot!.price}'),
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statusService(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    AntIcons.starOutlined,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot.status.name,
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget clienteService(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    AntIcons.userOutlined,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot.client.name,
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget oppeningDateService(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    AntIcons.calendarFilled,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data de abertura',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      getFormatedDate(snapshot!.opening_date),
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget closingDateService(snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 0.9,
      ))),
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                  child: Icon(
                    AntIcons.calendarFilled,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data de fechamento',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot!.closing_date == "" ||
                              snapshot!.closing_date == null
                          ? 'Serviço em aberto'
                          : getFormatedDate(snapshot!.closing_date),
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showContainer(resp) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          circleImage(resp),
          priceService(resp),
          statusService(resp),
          clienteService(resp),
          oppeningDateService(resp),
          closingDateService(resp),
        ],
      ),
    );
  }

  void _showDialog(id) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: const Text(
                    'Você quer deletar este serviço?',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
                  child: const Text(
                    'Esta ação não poderá ser desfeita.',
                    style: TextStyle(fontSize: 17, color: Colors.black54),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonDelete(id),
                    buttonCancel(context),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget buttonCancel(context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      height: 55.0,
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Colors.grey[600] ?? Colors.blue),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ))),
        child: const Text('Não, cancelar',
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buttonDelete(int servico) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      height: 55.0,
      width: double.maxFinite,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.red[300] ?? Colors.red),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0)),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ))),
        child: const Text('Sim, deletar serviço',
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        onPressed: () {
          deletarServico(servico);
          Navigator.pop(context);
        },
      ),
    );
  }
}
