import 'package:flutter/material.dart';
import '../models/alarm_category.dart'; // Import AlarmCategory

class AddCategoryDialog extends StatefulWidget {
  final Function(String name, String? emoji) onCategoryAdded;
  final AlarmCategory? existingCategory;

  const AddCategoryDialog({super.key, required this.onCategoryAdded, this.existingCategory});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emojiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingCategory != null) {
      _nameController.text = widget.existingCategory!.name;
      _emojiController.text = widget.existingCategory!.emoji ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      String? emoji = _emojiController.text.trim();
      widget.onCategoryAdded(_nameController.text.trim(), emoji.isNotEmpty ? emoji : null);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingCategory == null ? 'Add New Category' : 'Edit Category'),
      content: SingleChildScrollView( // Added SingleChildScrollView for smaller screens
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g., Work, Study',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emojiController,
                decoration: const InputDecoration(
                  labelText: 'Emoji (optional)',
                  hintText: 'e.g., 👍, 🚀',
                  border: OutlineInputBorder(),
                ),
                maxLength: 2, // Allow for emoji + skin tone modifier if any, or just one char
                validator: (value) {
                  // Optional: Add validation for emoji format if needed,
                  // but for simplicity, we'll allow any short string.
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.existingCategory == null ? 'Add' : 'Save'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Theme.of(context).cardColor,
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}