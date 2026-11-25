import 'package:flutter/material.dart';

class AddTaskModal extends StatefulWidget {
  final String? Function({
    required String title,
    required String category,
    required String priority,
  })
  onSubmitTask;
  final void Function(String message, {bool isError}) onNotify;

  const AddTaskModal({
    super.key,
    required this.onSubmitTask,
    required this.onNotify,
  });

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedCategory = 'Dev';
  String _selectedPriority = 'Sedang';
  String? _inlineErrorText;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final errorMsg = widget.onSubmitTask(
      title: _titleController.text,
      category: _selectedCategory,
      priority: _selectedPriority,
    );

    if (errorMsg != null) {
      setState(() {
        _inlineErrorText = errorMsg;
      });
      widget.onNotify('Gagal menambahkan: $errorMsg', isError: true);
      return;
    }

    Navigator.pop(context);
    widget.onNotify('Tugas berhasil ditambahkan!');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tugas Baru',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            autofocus: true,
            onChanged: (_) {
              if (_inlineErrorText != null) {
                setState(() => _inlineErrorText = null);
              }
            },
            decoration: InputDecoration(
              labelText: 'Apa yang mau dikerjakan?',
              hintText: 'Contoh: Desain halaman login',
              errorText: _inlineErrorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.task_alt_rounded),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Dev', 'Desain', 'QA', 'Umum'].map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedCategory = cat),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Prioritas',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['Rendah', 'Sedang', 'Tinggi'].map((prio) {
              final isSelected = _selectedPriority == prio;
              return ChoiceChip(
                label: Text(prio),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedPriority = prio),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _handleSave,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Simpan Tugas',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
