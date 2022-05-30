class Cliente {
  final int client_id;
  final String name;
  String? cpf;
  final String cell_phone;

  Cliente({required this.client_id,required this.name, this.cpf, required this.cell_phone});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      name: json["name"],
      client_id: json["client_id"],
      cell_phone: json["cell_phone"],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'cpf': cpf,
        'cell_phone': cell_phone,
    };
}


class RespCliente {
  final int client_id;
  final String name;
  final String cell_phone;

  RespCliente({required this.client_id, required this.name, required this.cell_phone});
  
  RespCliente.noData(this.client_id, this.name, this.cell_phone);

  factory RespCliente.fromJson(Map<String, dynamic> json) {
    return RespCliente(
      name: json["name"],
      client_id: json["client_id"],
      cell_phone: json["cell_phone"],
    );
  }

  Map<String, dynamic> toJson() => {
        'client_id': client_id,
        'name': name,
        'cell_phone': cell_phone,
    };
}

class IRespCliente {
   int? client_id;
  String? name;
   String? cell_phone;
   String? cpf;

   IRespCliente({this.client_id, this.name, this.cell_phone, this.cpf});

  factory IRespCliente.fromJson(Map<String, dynamic> json) {
    return IRespCliente(
      client_id: json["client_id"],
      name: json["name"],
      cell_phone: json["cell_phone"],
      cpf: json["cpf"],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'name': name.toString(),
      'cell_phone': cell_phone.toString(),
      'cpf': cpf.toString(),
    };
    return map;
  }
}