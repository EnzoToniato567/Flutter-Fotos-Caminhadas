import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/caminhada.dart';
import '../services/caminhada_storage.dart';

class DetalhesCaminhada extends StatefulWidget {
  const DetalhesCaminhada({super.key, required this.caminhada});

  final Caminhada caminhada;

  @override
  State<DetalhesCaminhada> createState() => _DetalhesCaminhadaState();
}

class _DetalhesCaminhadaState extends State<DetalhesCaminhada> {
  final _storage = CaminhadaStorage();
  late Caminhada _caminhada = widget.caminhada;

  LatLng get _origem =>
      LatLng(_caminhada.origemLatitude, _caminhada.origemLongitude);
  LatLng get _destino =>
      LatLng(_caminhada.destinoLatitude, _caminhada.destinoLongitude);

  Future<void> _tirarFoto() async {
    try {
      final foto = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (foto == null) return;

      final pasta = await getApplicationDocumentsDirectory();
      final caminho =
          '${pasta.path}${Platform.pathSeparator}caminhada_${_caminhada.id}.jpg';
      final arquivo = await File(foto.path).copy(caminho);
      _caminhada = _caminhada.copiarCom(fotoPath: arquivo.path);
      await _storage.atualizar(_caminhada);
      if (mounted) setState(() {});
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar foto: $erro')));
    }
  }

  Future<void> _editar() async {
    final controller = TextEditingController(text: _caminhada.titulo);
    final novoTitulo = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar caminhada'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              controller.text.trim(),
            ),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (novoTitulo == null || novoTitulo.isEmpty) return;

    final atualizada = _caminhada.copiarCom(titulo: novoTitulo);
    await _storage.atualizar(atualizada);
    if (mounted) setState(() => _caminhada = atualizada);
  }

  Future<void> _excluir() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir caminhada'),
        content: const Text('Deseja realmente excluir esta caminhada?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    await _storage.excluir(_caminhada.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final foto = _caminhada.fotoPath;
    final temFoto = foto != null && File(foto).existsSync();
    final centro = LatLng(
      (_origem.latitude + _destino.latitude) / 2,
      (_origem.longitude + _destino.longitude) / 2,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_caminhada.titulo),
        actions: [
          IconButton(
            onPressed: _editar,
            tooltip: 'Editar caminhada',
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: _excluir,
            tooltip: 'Excluir caminhada',
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 280,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: centro, zoom: 14),
              zoomControlsEnabled: false,
              markers: {
                Marker(markerId: const MarkerId('origem'), position: _origem),
                Marker(markerId: const MarkerId('destino'), position: _destino),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('trajeto'),
                  points: [_origem, _destino],
                  width: 6,
                  color: Theme.of(context).colorScheme.primary,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${_caminhada.distanciaKm.toStringAsFixed(2)} km  •  '
                  '${_caminhada.tempoMinutos} min  •  '
                  '${_caminhada.calorias} kcal',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                if (temFoto)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(foto),
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: _tirarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Tirar foto'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
