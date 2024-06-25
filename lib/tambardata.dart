import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({super.key});

  @override
  State<TambahData> createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nama = TextEditingController();
  TextEditingController isi = TextEditingController();
  Future _simpan() async {
    final respons = await http.post(
        Uri.parse('http://192.168.4.38/crud/create.php'),
        body: {"nama": nama.text, "isi": isi.text});
    if (respons.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data'),
      ),
      body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              child: Column(
                children: [
                  TextFormField(
                    controller: nama,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Nama',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                     
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: isi,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        hintText: 'Isi',
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nim tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _simpan().then((value) {
                            if (value) {
                              final snackBar = SnackBar(content: const Text('Data berhasil disimpan!'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
                              final snackBar = SnackBar(content: const Text('Data tidak berhasil disimpan!'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                          
                        }
                      },
                      child: Text('Simpan'))
                ],
              ),
            ),
          )),
    );
  }
}
