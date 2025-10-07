Практическое занятие №5. Работа со списками. Передача данных между модулями
ЭФБО-09-23 Кузнецов Матвей
Цели:

Научиться отображать коллекции данных с помощью ListView.builder.
Освоить базовую навигацию Navigator.push / Navigator.pop и передачу данных через конструктор.
Научиться добавлять, редактировать и удалять элементы списка без внешних пакетов и сложных архитектур.

Ход работы
Шаг 1. Определение модели данных
В файле lib/models/note.dart описал класс Note, который хранит данные заметки (id, заголовок, текст) и метод copyWith для удобного обновления.

Фрагмент кода:
class Note {
  final String id;
  String title;
  String body;

  Note({required this.id, required this.title, required this.body});

  Note copyWith({String? title, String? body}) => Note(
    id: id,
    title: title ?? this.title,
    body: body ?? this.body,
  );
}


Шаг 2. Реализация главного экрана со списком
В main.dart создал экран NotesPage. Список заметок хранится в состоянии (_notes), а отображение реализовано через ListView.builder. Каждая заметка представлена карточкой (Card + ListTile) с закруглениями, отступами и иконкой удаления.

Фрагмент кода:
 : ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, i) {
                final note = _filteredNotes[i];
                return Dismissible(
                  key: ValueKey(note.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _deleteNote(note),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.note_outlined),
                      title: Text(
                        note.title.isEmpty ? '(без названия)' : note.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        note.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _editNote(note),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteNote(note),
                      ),
                    ),
                  ),
                );
              },
            ),


Шаг 3. Добавление и редактирование заметок
Создан отдельный экран EditNotePage (edit_note_page.dart) с формой (Form + TextFormField).

Если заметка новая → генерируется уникальный id.
Если заметка уже существует → применяется метод copyWith.
Фрагмент кода:

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

Шаг 4. Удаление и свайп-удаление
Удаление реализовано двумя способами:

Кнопка с корзиной (IconButton в trailing).
Свайп по элементу через Dismissible.
Фрагмент кода:

Dismissible(
  key: ValueKey(note.id),
  direction: DismissDirection.endToStart,
  onDismissed: (_) => _delete(note),
  background: Container(
    color: Colors.red,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  child: Card(...),
),

Шаг 5. Реализация поиска
Для поиска добавлен SearchDelegate. Вызов через иконку 🔍 в AppBar. Фильтрация выполняется по заголовку заметки.

Фрагмент кода:

final filtered = _notes
    .where((n) => n.title.toLowerCase().contains(_search.toLowerCase()))
    .toList();

Скриншот списока задач.
<img width="701" height="1276" alt="image" src="https://github.com/user-attachments/assets/f726f4f7-68f8-49cd-9217-d938f28a0577" />
Скриншот страницы создания задачи.
<img width="711" height="1261" alt="image" src="https://github.com/user-attachments/assets/16bed6cf-3f6b-4a5f-b235-c67aff73a138" />
Скриншот страницы редактирования задачи.
<img width="706" height="1266" alt="image" src="https://github.com/user-attachments/assets/2504bd2f-01ec-40af-abde-dd5a6ef8e664" />
Скриншот после удаления задачи.
<img width="709" height="1124" alt="image" src="https://github.com/user-attachments/assets/0e30b8c0-5349-400f-b125-80804abd6dc9" />
Скриншоты страницы поиска задач.
<img width="712" height="1266" alt="image" src="https://github.com/user-attachments/assets/3029e219-fddb-48f4-a34b-933bbe8339b0" />
<img width="699" height="1292" alt="image" src="https://github.com/user-attachments/assets/5e4a8db6-ff3f-4c46-9afc-06a5c3675acc" />



