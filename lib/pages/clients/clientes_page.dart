// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/cliente_api.dart';
import 'package:flutter_application_1/models/client_model.dart';
import 'package:flutter_application_1/pages/clients/user_info_page.dart';
import 'create_cliente_page.dart';
import 'dart:math';

class CLientesPage extends StatefulWidget {
  const CLientesPage({Key? key}) : super(key: key);

  @override
  State<CLientesPage> createState() => _CLientesPage();
}

class _CLientesPage extends State<CLientesPage> {
  final ClienteService _clienteService = ClienteService();
  late Future<List<RespCliente>> _clientes;

  @override
  void initState() {
    super.initState();
    getClientes();
  }

  void getClientes() {
    setState(() {
      _clientes = _clienteService.getClintes();
    });
  }

  void deletarCliente(RespCliente cliente) async {
    var delete = await ClienteService.deletarCliente(cliente.client_id);
    if (delete.statusCode == 500) {
      message('Não foi possível deletar este cliente',
          'Tente novamente mais tarde');
    } else {
      setState(() {
        getClientes();
      });
      message('Cliente deletado com sucesso', 'Volte para página inicial');
    }
  }

  void message(String title, String subtitle) {
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
                    genericButton(context),
                  ],
                )
              ],
            ),
          );
        });
  }

  Widget genericButton(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context, true);
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
    return AlertDialog(
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircularProgressIndicator(),
          ),
          // const CircularProgressIndicator(),
          const Text('Processando...'),
        ],
      ),
    );
  }

  void _showDialog(resp) {
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
                    buttonDelete(resp),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 0.0),
          alignment: Alignment.center,
          child: FutureBuilder<List<RespCliente>>(
            future: _clientes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        RespCliente resp = snapshot.data![index];

                        return Card(
                          elevation: 1,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)],
                              child: Text(
                                resp.name[0],
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            title: Text(resp.name),
                            onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClienteInfoPage(
                                          clienteid: resp.client_id,
                                        )),
                              ),
                            },
                            subtitle: Text("Telefone: ${resp.cell_phone}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClienteInfoPage(
                                                  clienteid: resp.client_id,
                                                )),
                                      );
                                    },
                                    icon: const Icon(Icons.person)),
                                IconButton(
                                    onPressed: () {
                                      _showDialog(resp);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return _showContainer();
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return _loadingDialog();
            },
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateClient()),
          )
        },
        tooltip: 'Adicionar cliente',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _showContainer() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [textNoData(), circleImage()],
      ),
    );
  }

  Widget buttonDelete(RespCliente cliente) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
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

  Widget buttonCancel(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
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

  Widget textNoData() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Sem clientes cadastrados',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          color: Color.fromARGB(255, 103, 101, 101),
        ),
      ),
    );
  }

  Widget circleImage() {
    return Center(
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/nodata.png',
                ))),
      ),
    );
  }
}
