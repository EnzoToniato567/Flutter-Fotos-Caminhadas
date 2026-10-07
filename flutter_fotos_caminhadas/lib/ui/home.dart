import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../details/detalhes_caminhada.dart';
import '../details/nova_caminhada.dart';
import '../models/caminhada.dart';
import '../services/caminhada_storage.dart';
import 'splash.dart';
import 'styles/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _storage = CaminhadaStorage();
  List<Caminhada> _caminhadas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final lista = await _storage.listar();
    if (!mounted) return;
    setState(() {
      _caminhadas = lista;
      _carregando = false;
    });
  }

  Future<void> _novaCaminhada() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NovaCaminhada()),
    );
    await _carregar();
  }

  Future<void> _detalhes(Caminhada caminhada) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalhesCaminhada(caminhada: caminhada),
      ),
    );
    await _carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas caminhadas')),
      drawer: _menu(),
      body: _conteudo(),
      floatingActionButton: FloatingActionButton(
        onPressed: _novaCaminhada,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_caminhadas.isEmpty) {
      return const Center(
        child: Text('Nenhuma caminhada. Toque no + para começar.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _caminhadas.length,
      itemBuilder: (context, index) {
        final caminhada = _caminhadas[index];
        return Card(
          child: ListTile(
            onTap: () => _detalhes(caminhada),
            leading: _miniatura(caminhada),
            title: Text(caminhada.titulo),
            subtitle: Text(
              '${caminhada.distanciaKm.toStringAsFixed(2)} km • '
              '${caminhada.tempoMinutos} min',
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget _miniatura(Caminhada caminhada) {
    final caminho = caminhada.fotoPath;
    final arquivo = caminho == null ? null : File(caminho);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox.square(
        dimension: 52,
        child: arquivo?.existsSync() == true
            ? Image.file(arquivo!, fit: BoxFit.cover)
            : ColoredBox(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.hiking),
              ),
      ),
    );
  }

  Widget _menu() {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
              child: Center(child: Icon(Icons.hiking, size: 72)),
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Splash'),
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Splash()),
                (_) => false,
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text('Tema escuro'),
              value: escuro,
              onChanged: AppTheme.alternarTema,
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: SystemNavigator.pop,
            ),
          ],
        ),
      ),
    );
  }
}
