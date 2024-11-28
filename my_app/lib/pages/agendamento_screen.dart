import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo para representar os dados dos cortes
class Corte {
  final String id;
  final String nome;
  final String imagem;
  final String nota;

  Corte({required this.id, required this.nome, required this.imagem, required this.nota});

  factory Corte.fromJson(Map<String, dynamic> json) {
    return Corte(
      id: json['id'],
      nome: json['nome'],
      imagem: json['imagem'],
      nota: json['nota'],
    );
  }
}

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  State<AgendamentoScreen> createState() => _AgendamentoScreenState();
}

class _AgendamentoScreenState extends State<AgendamentoScreen> {
  List<Corte> cortes = [];
  bool isLoading = true;
  String errorMessage = "";

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (cortes.isEmpty) {
      carregarCortes();
    }
  }

  Future<void> carregarCortes() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = "http://192.168.0.23:3000/cortes";
      http.Response resposta = await http.get(Uri.parse(url));
      if (resposta.statusCode == 200) {
        // Garantir que a resposta seja decodificada corretamente
        List<dynamic> jsonData = jsonDecode(utf8.decode(resposta.bodyBytes));
        setState(() {
          cortes = jsonData.map((item) => Corte.fromJson(item)).toList();
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

  Future<void> selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selecionarHorario(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> confirmarAgendamento(Corte corte) async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Por favor, selecione a data e o horário."),
        ),
      );
      return;
    }

    try {
      String url = "http://192.168.0.23:3000/agendamentos";
      Map<String, dynamic> agendamento = {
        "corte_id": corte.nome,
        "corte_nome": corte.nome,
        "data": "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
        "hora": "${selectedTime!.hour}:${selectedTime!.minute}"
      };

      http.Response resposta = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(agendamento),
      );

      if (resposta.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Agendamento realizado com sucesso!"),
          ),
        );
        setState(() {
          selectedDate = null;
          selectedTime = null;
        });
      } else {
        throw Exception("Erro ao realizar agendamento: ${resposta.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao realizar agendamento."),
        ),
      );
      print("Erro: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agendar Corte de Cabelo"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: cortes.length,
                  itemBuilder: (context, index) {
                    return AgendamentoItem(
                      corte: cortes[index],
                      onAgendar: confirmarAgendamento,
                      onSelecionarData: () => selecionarData(context),
                      onSelecionarHorario: () => selecionarHorario(context),
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                    );
                  },
                ),
    );
  }
}

// Widget para representar cada item com opção de agendamento
class AgendamentoItem extends StatelessWidget {
  final Corte corte;
  final VoidCallback onSelecionarData;
  final VoidCallback onSelecionarHorario;
  final void Function(Corte) onAgendar;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const AgendamentoItem({
    required this.corte,
    required this.onSelecionarData,
    required this.onSelecionarHorario,
    required this.onAgendar,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    double imageWidth = MediaQuery.of(context).size.width * 0.8;
    double imageHeight = imageWidth * 0.66; // Proporção 3:2

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Corte: ${corte.nome}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Image.network(
              corte.imagem,
              width: imageWidth,
              height: imageHeight,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Column(
                children: [
                  Icon(Icons.broken_image, size: 100),
                  Text("Erro ao carregar imagem", style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("Tempo: ${corte.nota}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: onSelecionarData,
                  child: Text(selectedDate == null
                      ? "Selecionar Data"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                ),
                ElevatedButton(
                  onPressed: onSelecionarHorario,
                  child: Text(selectedTime == null
                      ? "Selecionar Horário"
                      : "${selectedTime!.hour}:${selectedTime!.minute}"),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onAgendar(corte),
              child: Text("Confirmar Agendamento"),
            ),
          ],
        ),
      ),
    );
  }
}
