import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/services_api.dart';
import 'package:flutter_application_1/models/services_model.dart';
import 'package:flutter_application_1/pages/services/service_create_page.dart';
import 'package:flutter_application_1/pages/services/service_details.dart';
import 'package:antdesign_icons/antdesign_icons.dart';

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
      message(
          'Serviço deletado com sucesso', 'Volte para página inicial', true);
    } else {
      message('Não foi possível deletar este serviço',
          'Tente novamente mais tarde', false);
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
                                    icon: const Icon(
                                        AntIcons.infoCircleOutlined)),
                                IconButton(
                                    onPressed: () {
                                      _showDialog(resp.service_id);
                                    },
                                    icon: const Icon(AntIcons.deleteTwotone)),
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
          deletarServico(cliente);
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
