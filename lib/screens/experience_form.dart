import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _startDateFieldKey = GlobalKey<FormFieldState<DateTime>>();
  final _endDateFieldKey = GlobalKey<FormFieldState<DateTime>>();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _organizationController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Experience'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const ValueKey('experience-title'),
                  controller: _titleController,
                  decoration: _inputDecoration('Title'),
                  textInputAction: TextInputAction.next,
                  validator: _validateRequired('Enter a title.'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const ValueKey('experience-organization'),
                  controller: _organizationController,
                  decoration: _inputDecoration('Organization'),
                  textInputAction: TextInputAction.next,
                  validator: _validateRequired('Enter an organization.'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const ValueKey('experience-description'),
                  controller: _descriptionController,
                  decoration: _inputDecoration('Description'),
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  validator: _validateRequired('Enter a description.'),
                ),
              ),
              _buildDateField(
                context: context,
                label: 'Start Date',
                keyName: 'experience-start-date',
                value: _startDate,
                fieldKey: _startDateFieldKey,
                initialDate: DateTime.now(),
                validator: (value) =>
                    value == null ? 'Select a start date.' : null,
                onChanged: (value) {
                  setState(() => _startDate = value);
                  _endDateFieldKey.currentState?.validate();
                },
              ),
              _buildDateField(
                context: context,
                label: 'End Date (optional)',
                keyName: 'experience-end-date',
                value: _endDate,
                fieldKey: _endDateFieldKey,
                initialDate: _startDate ?? DateTime.now(),
                validator: (value) {
                  if (value != null &&
                      _startDate != null &&
                      _dateOnly(value).isBefore(_dateOnly(_startDate!))) {
                    return 'End date must be on or after start date.';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _endDate = value),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  key: const ValueKey('experience-url'),
                  controller: _urlController,
                  decoration: _inputDecoration('URL (optional)'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  validator: _validateUrl,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: _showExperienceSummary,
                    child: const Text('Save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
    );
  }

  String? Function(String?) _validateRequired(String errorMessage) {
    return (value) =>
        value == null || value.trim().isEmpty ? errorMessage : null;
  }

  String? _validateUrl(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(trimmedValue);
    if (uri == null ||
        !{'http', 'https'}.contains(uri.scheme.toLowerCase()) ||
        uri.host.isEmpty) {
      return 'Enter a valid HTTP(S) URL.';
    }
    return null;
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required String keyName,
    required DateTime? value,
    required GlobalKey<FormFieldState<DateTime>> fieldKey,
    required DateTime initialDate,
    required String? Function(DateTime?) validator,
    required ValueChanged<DateTime> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormField<DateTime>(
        key: fieldKey,
        initialValue: value,
        validator: validator,
        builder: (field) {
          return InputDecorator(
            decoration: _inputDecoration(label)
                .copyWith(errorText: field.errorText),
            child: InkWell(
              key: ValueKey(keyName),
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: field.value ?? initialDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (selectedDate == null || !mounted) {
                  return;
                }

                final date = _dateOnly(selectedDate);
                field.didChange(date);
                onChanged(date);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        field.value == null
                            ? 'Select $label'
                            : _formatDate(field.value!),
                      ),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  void _showExperienceSummary() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience added successfully!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Title: ${_titleController.text}'),
                Text('Organization: ${_organizationController.text}'),
                Text('Description: ${_descriptionController.text}'),
                Text('Start Date: ${_formatDate(_startDate!)}'),
                Text(
                  'End Date: ${_endDate == null ? 'Not provided' : _formatDate(_endDate!)}',
                ),
                Text(
                  'URL: ${_urlController.text.trim().isEmpty ? 'Not provided' : _urlController.text.trim()}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
