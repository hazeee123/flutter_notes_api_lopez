import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../models/note.dart';
import '../models/note_insert.dart';
import '../services/notes_service.dart';

class NoteModify extends StatefulWidget {
  const NoteModify({Key? key, this.noteID}) : super(key: key);

  final String? noteID;

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteID != null;

  NotesService get notesService => GetIt.I<NotesService>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String? errorMessage;

  late Note note;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      notesService.getNote(widget.noteID!).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response!.error) {
          errorMessage = response.errorMessage ?? 'An error occurred';
        }
        note = response.data!;
        _titleController.text = note.noteTitle!;
        _contentController.text = note.noteContent!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit note' : 'Create note')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Note title'),
                  ),
                  Container(
                    height: 8,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(hintText: 'Note content'),
                  ),
                  Container(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (isEditing) {
                          setState(() {
                              _isLoading = true;
                            });
                            final note = NoteManipulation(
                                noteTitle: _titleController.text,
                                noteContent: _contentController.text);
                            final result = await notesService.updateNote(widget.noteID!, note);

                            setState(() {
                              _isLoading = false;
                            });
                            const title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occured')
                                : 'Your note was updated';

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(title),
                                content: Text(text),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ).then((data) {
                              if (result.data!) {
                                Navigator.of(context).pop();
                              }
                          });


                        } else {
                            setState(() {
                              _isLoading = true;
                            });
                            final note = NoteManipulation(
                                noteTitle: _titleController.text,
                                noteContent: _contentController.text);
                            final result = await notesService.createNote(note);

                            setState(() {
                              _isLoading = false;
                            });
                            const title = 'Done';
                            final text = result.error
                                ? (result.errorMessage ?? 'An error occured')
                                : 'Your note was created';

                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text(title),
                                content: Text(text),
                                actions: [
                                  ElevatedButton(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ).then((data) {
                              if (result.data!) {
                                Navigator.of(context).pop();
                              }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
