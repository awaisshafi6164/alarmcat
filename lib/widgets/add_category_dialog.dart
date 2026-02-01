import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/alarm_category.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(String name, String? emoji) onCategoryAdded;
  final AlarmCategory? existingCategory;

  const AddCategoryDialog({
    super.key,
    required this.onCategoryAdded,
    this.existingCategory,
  });

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

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      String? emoji = _emojiController.text.trim();
      String? categoryLabel = _nameController.text.trim();
      final db = await DatabaseHelper().db;
      if (widget.existingCategory != null) {
        // Edit existing category
        await db.update(
          'categories',
          {'name': categoryLabel, 'emoji': emoji.isNotEmpty ? emoji : null},
          where: 'name = ?',
          whereArgs: [widget.existingCategory!.name],
        );
        // Also update alarms with old category name to new name
        await db.update(
          'alarms',
          {'category': categoryLabel},
          where: 'category = ?',
          whereArgs: [widget.existingCategory!.name],
        );
      } else {
        // Add new category (check for duplicate)
        final existing = await db.query(
          'categories',
          where: 'name = ?',
          whereArgs: [categoryLabel],
        );
        if (existing.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Category already exists.')),
          );
          return;
        }
        await db.insert('categories', {
          'name': categoryLabel,
          'emoji': emoji.isNotEmpty ? emoji : null,
          'enabled': 1,
        });
      }
      widget.onCategoryAdded(categoryLabel, emoji.isNotEmpty ? emoji : null);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade700,
                    Colors.deepPurple.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.existingCategory == null
                        ? Icons.add_circle
                        : Icons.edit,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.existingCategory == null
                        ? 'New Category'
                        : 'Edit Category',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Category Name',
                      hint: 'e.g., Work, Study',
                      icon: Icons.label,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emojiController,
                      label: 'Emoji (Optional)',
                      hint: 'e.g., 🚀',
                      icon: Icons.emoji_emotions,
                      maxLength: 2,
                    ),
                    const SizedBox(height: 24),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            widget.existingCategory == null ? 'Create' : 'Save',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
        filled: true,
        fillColor: Colors.deepPurple.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        counterText: "", // Hide character counter
      ),
      validator: validator,
    );
  }
}
