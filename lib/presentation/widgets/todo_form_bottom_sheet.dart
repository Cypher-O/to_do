import 'package:to_do/core/utils/imports/general_import.dart';
import 'package:to_do/domain/entities/todo.dart';

class TodoFormBottomSheet extends StatefulWidget {
  final String title;
  final String submitButtonText;
  final Todo? initialTodo;
  final Function(String, String) onSubmit;

  const TodoFormBottomSheet({
    super.key,
    required this.title,
    required this.submitButtonText,
    required this.onSubmit,
    this.initialTodo,
  });

  @override
  TodoFormBottomSheetState createState() => TodoFormBottomSheetState();
}

class TodoFormBottomSheetState extends State<TodoFormBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTodo?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialTodo?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        (_titleController.text != widget.initialTodo?.title ||
            _descriptionController.text != widget.initialTodo?.description);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: enterTodo,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
              autofocus: true,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: enterTodoDescription,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
              maxLines: 3,
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      widget.onSubmit(
                        _titleController.text,
                        _descriptionController.text,
                      );
                      Navigator.pop(context);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                widget.submitButtonText,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}