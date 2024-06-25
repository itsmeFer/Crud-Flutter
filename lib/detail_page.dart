import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  DetailPage({required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namaController.text = widget.item['nama'];
    _isiController.text = widget.item['isi'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama:'),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama',
              ),
            ),
            SizedBox(height: 20),
            Text('Isi:'),
            TextField(
              controller: _isiController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Masukkan isi',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Kirim data yang diubah kembali ke halaman sebelumnya
                Navigator.pop(context, {
                  'nama': _namaController.text,
                  'isi': _isiController.text,
                });
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
