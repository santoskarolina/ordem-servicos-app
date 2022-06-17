import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/dashboard_api.dart';
import 'package:intl/intl.dart';
import '../../api/user_api.dart';
import '../../models/dashboard_model.dart';
import '../../models/user.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<ClienteReport> _clientes;
  late Future<ServiceReport> _services;
  final now = DateTime.now();
  late Future<UserResponse> _userLog;

  void getReport() {
    setState(() {
      _clientes = DashbpardApi.getClientReport();
    });
  }

  void getUserData() {
    setState(() {
      _userLog = UserService.userProfile();
    });
  }

  void getServiceReport() {
    setState(() {
      _services = DashbpardApi.getServiceReport();
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
    getReport();
    getServiceReport();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[dashBg, content],
      ),
    );
  }

  get dashBg => Column(
        children: <Widget>[
          Expanded(
            // const Color.fromRGBO(42, 68, 171, 1),
            child: Container(
              color: const Color.fromRGBO(42, 68, 171, 1),
            ),
            flex: 2,
          ),
          Expanded(
            child: Container(color: Colors.transparent),
            flex: 5,
          ),
        ],
      );

  get content => Column(
        children: <Widget>[
          header,
          grid,
        ],
      );

  get header => ListTile(
        contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        title: const Text(
          'Dashboard',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          getFormatedDate(now.toString()),
          style: const TextStyle(
              color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        trailing: FutureBuilder<UserResponse>(
          future: _userLog,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                  snapshot.data!.photo,
                ),
                // backgroundColor: Colors.tra,
              );
            }
            return const CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage('assets/client.png'),
              // backgroundColor: Colors.black,
            );
          },
        ),
      );

  get grid => Expanded(
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: GridView.count(
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              crossAxisCount: 2,
              childAspectRatio: .90,
              children: [
                cardTotalClients(),
                cardTotalServices(),
                cardTotalClientsWithServices(),
                cardTotalClientsWithoutServices(),
                cardServicesOpen(),
                cardServicesClose()
              ]),
        ),
      );

  Widget cardTotalClients() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            const Padding(
              padding: EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: Text(
                'Clientes',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder<ClienteReport>(
                future: _clientes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.clientes}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                    );
                  }
                  // return const CircularProgressIndicator();
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                }),
          ],
        ),
      ),
    );
  }

  Widget cardTotalClientsWithServices() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: const Text(
                'Clientes com serviços',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder<ClienteReport>(
                future: _clientes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.clientes_com_servico}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                    );
                  }
                  // return const CircularProgressIndicator();
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                }),
          ],
        ),
      ),
    );
  }

  Widget cardTotalClientsWithoutServices() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: const Text(
                'Clientes sem serviços',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder<ClienteReport>(
                future: _clientes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.clientes_sem_servicos}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                }),
          ],
        ),
      ),
    );
  }

  Widget cardTotalServices() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: const Text(
                'Serviços',
                style: TextStyle(fontSize: 20),
              ),
            ),
            FutureBuilder<ServiceReport>(
                future: _services,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.servicos}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                })
          ],
        ),
      ),
    );
  }

  Widget cardServicesOpen() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: const Text(
                'Serviços abertos',
                style: TextStyle(fontSize: 20),
              ),
            ),
            FutureBuilder<ServiceReport>(
                future: _services,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.servicos_abertos}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                })
          ],
        ),
      ),
    );
  }

  Widget cardServicesClose() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Icon(Icons.person),
            Container(
              padding: const EdgeInsets.fromLTRB(0.0, 00.0, 0.0, 20.3),
              child: const Text(
                'Serviços finalizados',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            FutureBuilder<ServiceReport>(
                future: _services,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.servicos_fechados}",
                      style:
                          const TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      textAlign: TextAlign.center,
                    );
                  }
                  return const Text('0',
                      style: TextStyle(fontSize: 38, color: Colors.black45),
                      textAlign: TextAlign.center);
                })
          ],
        ),
      ),
    );
  }
}
