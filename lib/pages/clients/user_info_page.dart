import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/client_model.dart';
import 'package:flutter_application_1/pages/initial/home_page.dart';
import '../../api/cliente_api.dart';
import 'edit_cliente_page.dart';

class ClienteInfoPage extends StatefulWidget {
  final int clienteid;

  const ClienteInfoPage({Key? key, required this.clienteid}) : super(key: key);

  @override
  State<ClienteInfoPage> createState() => _ClienteInfoPageState();
}

class _ClienteInfoPageState extends State<ClienteInfoPage> {
  late Future<IRespCliente> _cliente;

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
      message('Cliente não pode ser deletado', 'Ele possui serviços', false);
    } else if (response.statusCode == 200) {
      message('Cliente deletado com sucesso', 'Volte para tela inicial', true);
    }
  }

  @override
  void initState() {
    loadingDelete = false;
    super.initState();
    getCliente();
  }

  void message(String title, String subtitle, bool goHome) {
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

  void _showDialog(id) {
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
                const Text(
                  'Você quer deletar este cliente?',
                  style: TextStyle(fontSize: 20),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 8.2),
                    child: Text(
                      'Esta ação não poderá ser desfeita.',
                      style: TextStyle(fontSize: 17, color: Colors.black54),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buttonCancel(context),
                    buttonDelete(id),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget buttonCancel(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              setState(() {
                loadingDelete = false;
                print(loadingDelete);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(11, 122, 222, 1),
                fixedSize: const Size(150, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Não',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget buttonDelete(int cliente) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              setState(() {
                loadingDelete = true;
              });
              deletarCliente(cliente);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 0, 0, 120),
                fixedSize: const Size(150, 100),
                primary: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Sim',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ));
  }

  Widget _loadingDialog() {
    return AlertDialog(
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircularProgressIndicator(),
          ),
          // const CircularProgressIndicator(),
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
          child: FutureBuilder<IRespCliente>(
            future: _cliente,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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
          )),
    );
  }

  Widget _showCard(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
      child: Card(
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: const Text("Nome"),
              subtitle: Text(snapshot.data!.name),
            ),
            ListTile(
              title: const Text("CPF"),
              subtitle: Text(snapshot.data!.cpf),
            ),
            ListTile(
              title: const Text("Telefone"),
              subtitle: Text(snapshot.data!.cell_phone),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionsButton(snapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 9.0, 0.0, 0.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [showButton(snapshot), showDeleteButton(snapshot)]),
    );
  }

  Widget showButton(snapshot) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 9.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditClient(
                          clienteId: snapshot.data!.client_id,
                        )),
              )
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
          onPressed: () {
            _showDialog(snapshot.data!.client_id);
          },
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

  Widget circleImage(response) {
    return Center(
      child: Container(
        width: 150.0,
        height: 150.0,
        child: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(
            response.data.name[0],
            style: const TextStyle(fontSize: 100, color: Colors.white),
          ),
          // backgroundImage: AssetImage('assets/cliente.jpg'),
        ),
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          // image: DecorationImage(
          // fit: BoxFit.cover,
          // image: AssetImage('assets/cliente.jpg',)
          //   )
        ),
      ),
    );
  }

  Widget _showContainer(snapshot) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          circleImage(snapshot),
          _showCard(snapshot),
          actionsButton(snapshot)
        ],
      ),
    );
  }
}
