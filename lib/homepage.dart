import 'dart:convert';
import 'package:crud/tambardata.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'detail_page.dart'; 

class MyHomePage extends StatefulWidget {
  final String username;

  const MyHomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _listdata = [];
  bool _isLoading = true;
  int _selectedIndex = 0;



  Future _getdata() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.4.38/crud/read.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isLoading = false;
        });
      } else {
        // Handle non-200 responses here
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _editItem(int index) async {
    // Navigasi ke halaman detail untuk mengedit item
    Map<String, dynamic> selectedItem = _listdata[index];
    final editedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(item: selectedItem),
      ),
    );

    // Jika ada data yang dikembalikan dari halaman detail, update data di list
    if (editedItem != null) {
      setState(() {
        _listdata[index]['nama'] = editedItem['nama'];
        _listdata[index]['isi'] = editedItem['isi'];
      });

      // Kirim data yang diubah ke server untuk disimpan di database
      try {
        final response = await http.post(
          Uri.parse('http://192.168.4.38/crud/update.php'),
          body: {
            'id': _listdata[index]['id'], // Ubah dengan nama kolom id di database Anda
            'nama': editedItem['nama'],
            'isi': editedItem['isi'],
          },
        );

        if (response.statusCode == 200) {
          // Tampilkan pesan sukses jika data berhasil disimpan di database
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data updated successfully')),
          );
        } else {
          // Tampilkan pesan error jika ada masalah saat menyimpan data
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update data')),
          );
        }
      } catch (e) {
        print(e);
        // Tangani error jika terjadi kesalahan koneksi atau lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteItem(int index) async {
    // Kirim permintaan untuk menghapus item dari database
    try {
      final response = await http.post(
        Uri.parse('http://192.168.4.38/crud/delete.php'),
        body: {
          'id': _listdata[index]['id'], // Ubah dengan nama kolom id di database Anda
        },
      );

      if (response.statusCode == 200) {
        // Hapus item dari list setelah berhasil dihapus dari database
        setState(() {
          _listdata.removeAt(index);
        });

        // Tampilkan snackbar untuk memberi tahu pengguna bahwa item telah dihapus
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted successfully')),
        );
      } else {
        // Tampilkan pesan error jika ada masalah saat menghapus data
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item')),
        );
      }
    } catch (e) {
      print(e);
      // Tangani error jika terjadi kesalahan koneksi atau lainnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE, d MMMM y').format(DateTime.now());

    List<Widget> _pages = <Widget>[
      _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _listdata.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_listdata[index]['id'].toString()),
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteItem(index);
                  },
                  child: GestureDetector(
                    onTap: () {
                      _editItem(index);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(_listdata[index]['nama']),
                        subtitle: Text(_listdata[index]['isi']),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editItem(index);
                          },
                        ),
                        
                      ),
                    ),
                  ),
                );
              },
            ),
      Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TambahData()));
          },
          child: Text('Create New Note'),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Center(
          child: _selectedIndex == 0
              ? Column(
                  children: [
                    Text('Your Evernote'),
                    Text(formattedDate),
                   
                  ],
                )
              : Text('Create Note'),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _pages[_selectedIndex],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text('Hey',),
              SizedBox(width: 9,),
              Text(widget.username,style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w900
              ),), 
            ],
          ),
           
          Text(
            'Notes (${_listdata.length})',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
