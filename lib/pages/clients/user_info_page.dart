import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/client_model.dart';
import 'package:flutter_application_1/pages/initial/home_page.dart';
import '../../api/cliente_api.dart';
import 'edit_cliente_page.dart';
import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ClienteInfoPage extends StatefulWidget {
  final int clienteid;

  const ClienteInfoPage({Key? key, required this.clienteid}) : super(key: key);

  @override
  State<ClienteInfoPage> createState() => _ClienteInfoPageState();
}

class _ClienteInfoPageState extends State<ClienteInfoPage> {
  late Future<IRespCliente> _cliente;

  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  var clientIdButton;
  late bool loadingDelete;

  void getCliente() {
    setState(() {
      _cliente = ClienteService.getClientById(widget.clienteid);
      loadingDelete = false;
    });
  }

  void deletarCliente(int cliente) async {
    var response = await ClienteService.deletarCliente(cliente);
    if (response.statusCode == 500) {
      message(
          'Cliente não pode ser deletado', 'Ele possui serviços', false, false);
    } else if (response.statusCode == 200) {
      message('Cliente deletado com sucesso', 'Volte para tela inicial', true,
          true);
    }
  }

  @override
  void initState() {
    loadingDelete = false;
    super.initState();
    getCliente();
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
                    'Você quer deletar este cliente?',
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

  Widget buttonDelete(int cliente) {
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
        child: const Text('Sim, deletar cliente',
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        onPressed: () {
          deletarCliente(cliente);
          Navigator.pop(context);
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
          'Informações do cliente',
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
            child: FutureBuilder<IRespCliente>(
              future: _cliente,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  clientIdButton = snapshot.data!.client_id;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      _showContainer(snapshot),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return _loadingDialog();
              },
            ),
          )),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue[600],
        overlayColor: Colors.grey,
        openCloseDial: isDialOpen,
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
                _showDialog(clientIdButton);
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
                      builder: (context) => EditClient(
                            clienteId: clientIdButton,
                          )),
                );
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
        shape: BoxShape.rectangle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color.fromRGBO(42, 68, 171, 1),
            Color.fromRGBO(42, 90, 182, 1),
            Color.fromRGBO(42, 170, 171, 1),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 170.0,
              height: 170.0,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  snapshot.data.name[0],
                  style: const TextStyle(fontSize: 100, color: Colors.white),
                ),
                // backgroundImage: AssetImage('assets/cliente.jpg'),
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            snapshot.data!.name,
            style: const TextStyle(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget nameUser(snapshot) {
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
                    'Nome do cliente',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot!.data.name,
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

  Widget cpfuser(snapshot) {
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
                    AntIcons.securityScanFilled,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CPF',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot!.data.cpf,
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

  Widget phoneUser(snapshot) {
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
                    AntIcons.phoneOutlined,
                    color: Colors.grey,
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Telefone',
                    style: TextStyle(color: Colors.grey[600], fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      snapshot!.data.cell_phone,
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

  Widget _showContainer(snapshot) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          circleImage(snapshot),
          nameUser(snapshot),
          cpfuser(snapshot),
          phoneUser(snapshot),
        ],
      ),
    );
  }
}
