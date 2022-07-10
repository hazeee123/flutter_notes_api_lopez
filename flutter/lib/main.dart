import 'package:flutter/material.dart';
import 'package:flutter_notes_api/services/notes_service.dart';
import 'package:get_it/get_it.dart';
import 'views/note_list.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: NoteList(),
    );
  }
}
