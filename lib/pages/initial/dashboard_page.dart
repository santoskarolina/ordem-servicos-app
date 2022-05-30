import 'package:flutter/material.dart';
import 'package:flutter_application_1/api/dashboard_api.dart';

import '../../models/dashboard_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<ClienteReport> _clientes;
  late Future<ServiceReport> _services;

  void getReport() {
    setState(() {
      _clientes = DashbpardApi.getClientReport();
    });
  }

  void getServiceReport() {
    setState(() {
      _services = DashbpardApi.getServiceReport();
    });
  }

  @override
  void initState() {
    super.initState();
    getReport();
    getServiceReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: _showContainer(),
      ),
    );
  }

  Widget _showCardClientes() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Relatório de clientes',
              style: TextStyle(fontSize: 20),
            ),
            const Divider(),
            ListTile(
                title: const Text("Total de clientes"),
                subtitle: FutureBuilder<ClienteReport>(
                    future: _clientes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.clientes}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
            ListTile(
                title: const Text("Clientes com serviços"),
                subtitle: FutureBuilder<ClienteReport>(
                    future: _clientes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.clientes_com_servico}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
            ListTile(
                title: const Text("Clientes sem serviços"),
                subtitle: FutureBuilder<ClienteReport>(
                    future: _clientes,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.clientes_sem_servicos}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
          ],
        ),
      ),
    );
  }

  Widget _showCardServices() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Relatório de serviços',
              style: TextStyle(fontSize: 20),
            ),
            const Divider(),
            ListTile(
                title: const Text("Total de serviços"),
                subtitle: FutureBuilder<ServiceReport>(
                    future: _services,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.servicos}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
            ListTile(
                title: const Text("Abertos"),
                subtitle: FutureBuilder<ServiceReport>(
                    future: _services,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.servicos_abertos}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
            ListTile(
                title: const Text("Fechados"),
                subtitle: FutureBuilder<ServiceReport>(
                    future: _services,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data!.servicos_fechados}");
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const Text('0');
                    })),
          ],
        ),
      ),
    );
  }

  Widget _showContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _showCardClientes(),
          _showCardServices(),
        ],
      ),
    );
  }
}
