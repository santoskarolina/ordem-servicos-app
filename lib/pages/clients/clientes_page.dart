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
          'Verifique se ele possui serviços', false);
    } else {
      setState(() {
        getClientes();
      });
      message(
          'Cliente deletado com sucesso', 'Volte para página inicial', true);
    }
  }

  void message(String title, String subtitle, bool icon) {
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
                genericButton(context),
              ],
            ),
          );
        });
  }

  Widget genericButton(context) {
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
          Navigator.pop(context, true);
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

  void _showDialog(resp) {
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
                    buttonDelete(resp),
                    buttonCancel(context),
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
