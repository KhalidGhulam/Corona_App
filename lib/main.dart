import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corona App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoronaHomePage(),
    );
  }
}

class CoronaHomePage extends StatefulWidget {
  @override
  _CoronaHomePageState createState() => _CoronaHomePageState();
}

class _CoronaHomePageState extends State<CoronaHomePage> {
  TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _coronaData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/all'));
    if (response.statusCode == 200) {
      setState(() {
        _coronaData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchCountryData(String country) async {
    final response = await http.get(Uri.parse('https://disease.sh/v3/covid-19/countries/$country'));
    if (response.statusCode == 200) {
      setState(() {
        _coronaData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Corona App'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Country',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchCountryData(_searchController.text);
                  },
                ),
              ),
            ),
            SizedBox(height: 20.0),
            if (_coronaData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Country: ${_coronaData!['country']}'),
                  Text('Cases: ${_coronaData!['cases']}'),
                  Text('Deaths: ${_coronaData!['deaths']}'),
                  Text('Recovered: ${_coronaData!['recovered']}'),
                  Text('Active Cases: ${_coronaData!['active']}'),
                ],
              )
            else
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
