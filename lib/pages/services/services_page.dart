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
      _showMessage('Serviço deletado com sucesso', true, true);
    } else {
      _showMessage('Não foi possível deletar este serviço', false, false);
    }
  }

  void _showDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text(
            "Deletar serviço?",
          ),
          content: const Text("Esta ação não poderá ser desfeita"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deletarServico(id);
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

  void _showMessage(String text, bool action, bool goHome) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(action ? 'Sucesso' : 'Oopss',),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                goHome
                    ? Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage(title: 'Services ON')),)
                    : Navigator.pop(context, true);
              },
              child: const Text('OK',),
            ),
          ],
        );
      },
    );
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
                if(snapshot.data!.isNotEmpty){
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Service resp = snapshot.data![index];
                      return ListTile(
                        title: Text(resp.description,),
                        subtitle: Text("${resp.status.name}",),
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: AssetImage('assets/service.jpg'),
                        ),
                        trailing: menu(resp.service_id),
                      );
                    });
                }else{
                  return _showContainer();
                }
              }else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
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
        backgroundColor: const Color.fromRGBO(42,68,171, 1),
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
        style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 103, 101, 101), ),
      ),
    );
  }

  Widget circleImage() {
    return Center(
      child : Container(
      width: 200.0,
      height: 200.0,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/nodata.png',)
            )
        ),
     ),
   );
  } 

  Widget menu(int id) {
    return PopupMenuButton<Menu>(
        // Callback that sets the selected popup menu item.
        onSelected: (Menu item) async {
          setState(() {
            switch (item) {
              case Menu.deletar:
                _showDialog(id);
                break;
              case Menu.atualizar:
                Navigator.push( context, MaterialPageRoute(builder: (context) => ServiceInfoPage(serviceId: id,)),
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
