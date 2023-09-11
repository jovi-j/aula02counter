import 'package:aula02counter/pessoa.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const int maxPessoas = 3;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PessoaListScreen(),
    );
  }
}

class PessoaListScreen extends StatefulWidget {
  const PessoaListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PessoaListScreenState createState() {
    return _PessoaListScreenState();
  }
}

class _PessoaListScreenState extends State<PessoaListScreen> {
  final List<Pessoa> _pessoas = [];
  final ValueNotifier<int> _pessoaCounter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pessoas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPessoaDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _pessoaCounter,
            builder: (context, pessoasCounter, _) {
              List<InlineSpan> textSpans = [];
              textSpans.add(TextSpan(
                text: 'Número de pessoas: $pessoasCounter',
                style: TextStyle(
                  color:
                      pessoasCounter >= maxPessoas ? Colors.red : Colors.black,
                  fontSize: 18.0,
                ),
              ));
              if (pessoasCounter >= maxPessoas) {
                textSpans.add(const WidgetSpan(
                  child: SizedBox(height: 8.0),
                ));
                textSpans.add(const TextSpan(
                  text: '\nAviso: número máximo de pessoas atingido.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                ));
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: textSpans,
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pessoas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_pessoas[index].nome),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPessoaDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPessoaDialog(BuildContext context) {
    String novoNome = '';
    if (_pessoas.length >= maxPessoas) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Número máximo de $maxPessoas pessoas atingido, por favor, remova alguma pessoa.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Pessoa'),
          content: TextField(
            onChanged: (value) {
              novoNome = value;
            },
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (novoNome.isNotEmpty) {
                  setState(() {
                    _pessoas.add(Pessoa(novoNome));
                    _pessoaCounter.value =
                        _pessoas.length; // Update the counter
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover pessoa '),
          content: Text(
              'Tem certeza que deseja remover ${_pessoas[index].nome} da lista?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pessoas.removeAt(index);
                  _pessoaCounter.value = _pessoas.length; // Update the counter
                });
                Navigator.of(context).pop();
              },
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }
}
