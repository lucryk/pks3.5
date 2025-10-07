import 'package:flutter/material.dart';
import 'models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note? existing;
  const EditNotePage({super.key, this.existing});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleController.text = widget.existing!.title;
      _bodyController.text = widget.existing!.body;
    }
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final result = (widget.existing == null)
        ? Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
          )
        : widget.existing!.copyWith(
            title: _titleController.text.trim(),
            body: _bodyController.text.trim(),
          );

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать заметку' : 'Новая заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontSize: 18),
                maxLength: 100,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Текст заметки',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Введите текст заметки'
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.check),
                label: const Text('Сохранить'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}