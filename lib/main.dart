import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Examen-Claudio Vasquez'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> yesNoApi() async {
    final response = await http.get(Uri.parse('https://yesno.wtf/api'));

    final data = json.decode(response.body);

    print(data['image']);

    return data['image'];
  }

  final controller = TextEditingController();

  String texto = '';
  String url = '';

  void onSend() async {
    if (controller.text.isEmpty) return;

    if (controller.text.trim()[controller.text.length - 1] != '?') {
      controller.clear();
      setState(() {});
      return;
    }

    texto = controller.text;
    controller.clear();
    url = await yesNoApi();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Center(
                child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              url.isEmpty
                  ? const CircularProgressIndicator()
                  : Image.network(url),
              texto.isEmpty
                  ? const SizedBox()
                  : Text(
                      texto,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      texto = '';
                      url = '';
                    });
                  },
                  child: const Text('Limpiar')),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Escribe algo',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: onSend, icon: const Icon(Icons.send))),
              )
            ],
          ),
        ))));
  }
}
