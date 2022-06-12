import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/services_api.dart';
import 'package:flutter_application_1/models/services_model.dart';
import 'package:flutter_application_1/pages/services/service_create_page.dart';
import 'package:flutter_application_1/pages/services/service_details.dart';
import '../../models/menu_enum.dart';
import '../initial/home_page.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPage();
}

class _ServicesPage extends State<ServicesPage> {
  final ServicesService _servicesService = ServicesService();
  late Future<List<Service>> _services;

  void getCLientes() {
    setState(() {
      _services = _servicesService.get();
    });
  }

  @override
  void initState() {
    super.initState();
    getCLientes();
  }

  void deletarServico(int id) async {
    var response = await ServicesService.deletarService(id);
    if (response.statusCode == 200) {
      setState(() {
        getCLientes();
      });
      message('Serviço deletado com sucesso', 'Volte para página inicial');
    } else {
      message('Não foi possível deletar este serviço',
          'Tente novamente mais tarde');
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
          const Text('Carregando...'),
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
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Você quer deletar este serviço?',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 0.0),
          alignment: Alignment.center,
          child: FutureBuilder<List<Service>>(
            future: _services,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                      padding: const EdgeInsets.only(top: 10.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Service resp = snapshot.data![index];
                        return Card(
                          elevation: 1,
                          child: ListTile(
                            title: Text(
                              resp.description,
                            ),
                            subtitle: Text(
                              "${resp.status.name}",
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              backgroundImage: AssetImage('assets/service.jpg'),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ServiceInfoPage(
                                                    serviceId: resp.service_id,
                                                  )));
                                    },
                                    icon: const Icon(Icons.info_rounded)),
                                IconButton(
                                    onPressed: () {
                                      _showDialog(resp.service_id);
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
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateService()),
          )
        },
        tooltip: 'Adicionar serviço',
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromRGBO(42, 68, 171, 1),
      ),
    );
  }

  Widget buttonDelete(int cliente) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 55.0,
          child: TextButton(
            onPressed: () {
              deletarServico(cliente);
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
        'Sem serviços cadastrados',
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
