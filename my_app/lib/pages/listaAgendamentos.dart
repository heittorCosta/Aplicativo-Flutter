import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo para representar os dados dos agendamentos
class Agendamento {
  final String id;
  final String corteNome;
  final String data;
  final String horario;
  final String cliente;

  Agendamento({
    required this.id,
    required this.corteNome,
    required this.data,
    required this.horario,
    required this.cliente

  });

  factory Agendamento.fromJson(Map<String, dynamic> json) {
    // Verifica se o nome do corte é "corte_nome" ou "corte_id" no JSON
    String corteNome = json['corte_nome'] ?? json['corteId'] ?? 'Corte não especificado';

    return Agendamento(
      cliente: json['usuarioId'] ?? 'Nome do cliente não encontrado',
      id: json['id'] ?? 'ID não especificado',
      corteNome: corteNome,
      data: json['data'] ?? 'Data não especificada',
      horario: json['hora'] ?? json['horario'] ?? 'Hora não especificada', // Verifica se o campo 'hora' ou 'horario' existe
    );
  }
}

class ListaAgendamentoScreen extends StatefulWidget {
  const ListaAgendamentoScreen({super.key});

  @override
  State<ListaAgendamentoScreen> createState() => _ListaAgendamentoScreenState();
}

class _ListaAgendamentoScreenState extends State<ListaAgendamentoScreen> {
  List<Agendamento> agendamentos = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    carregarAgendamentos();
  }

  Future<void> carregarAgendamentos() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = "http://192.168.0.23:3000/agendamentos"; // Substitua pela URL correta do seu servidor
      http.Response resposta = await http.get(Uri.parse(url));
      if (resposta.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(utf8.decode(resposta.bodyBytes));
        setState(() {
          agendamentos = jsonData.map((item) => Agendamento.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Erro ao buscar dados: ${resposta.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Erro ao carregar dados.";
      });
      print("Erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Agendamentos"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: agendamentos.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(agendamentos[index].corteNome),
                      subtitle: Text("Cliente: ${agendamentos[index].cliente}\nData: ${agendamentos[index].data}\nHora: ${agendamentos[index].horario}"),
                      trailing: Icon(Icons.calendar_today),
                    );
                  },
                ),
    );
  }
}
