class ClienteReport {
  final int clientes;
  final int clientes_com_servico;
  final int clientes_sem_servicos;
  

   const ClienteReport({ 
    required this.clientes, 
    required this.clientes_com_servico, 
    required this.clientes_sem_servicos, 
  });

   factory  ClienteReport.fromJson(Map<String, dynamic> json){
    return ClienteReport(
        clientes: json['clientes'],
        clientes_com_servico: json['clientes_com_servico'],
        clientes_sem_servicos: json['clientes_sem_servicos'],
    );
  }
}

class ServiceReport {
  final int servicos;
  final int servicos_abertos;
  final int servicos_fechados;
  

   const ServiceReport({ 
    required this.servicos, 
    required this.servicos_abertos, 
    required this.servicos_fechados, 
  });

   factory  ServiceReport.fromJson(Map<String, dynamic> json){
    return ServiceReport(
        servicos: json['servicos'],
        servicos_abertos: json['servicos_abertos'],
        servicos_fechados: json['servicos_fechados'],
    );
  }
}