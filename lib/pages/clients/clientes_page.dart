// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/cliente_api.dart';
import 'package:flutter_application_1/models/client_model.dart';
import 'package:flutter_application_1/pages/clients/user_info_page.dart';
import '../../models/menu_enum.dart';
import 'create_cliente_page.dart';

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
      _showMessage('Não foi possível deletar este cliente', false);
    } else {
      setState(() {
        getClientes();
      });
      _showMessage('Cliente deletado com sucesso', true);
    }
  }

  void _showDialog(RespCliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text('Deletar cliente?'),
          content: const Text(
            "Esta ação não poderá ser desfeita",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deletarCliente(cliente);
                Navigator.pop(context, true);
              },
              child: const Text(
                'Sim',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Não',
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String text, bool sucesso) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(sucesso ? 'Sucesso' : 'Oopsss'),
          content: Text(
            text,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
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
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            backgroundImage: AssetImage('assets/cliente.jpg'),
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
                          trailing: menu(resp),
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

  Widget menu(RespCliente cliente) {
    return PopupMenuButton<Menu>(
        // Callback that sets the selected popup menu item.
        onSelected: (Menu item) async {
          setState(() {
            switch (item) {
              case Menu.deletar:
                _showDialog(cliente);
                break;
              case Menu.atualizar:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ClienteInfoPage(
                            clienteid: cliente.client_id,
                          )),
                );
                break;
            }
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem(
                value: Menu.deletar,
                child: Text('Deletar'),
              ),
              const PopupMenuItem(
                value: Menu.atualizar,
                child: Text('Detalhes'),
              ),
            ]);
  }
}
