import 'package:flutter/material.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  bool _simulateFailure = false;
  bool _hasReports = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _uiState = ReportUiState.loading);

    try {
      await Future<void>.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      if (_simulateFailure) {
        setState(() => _uiState = ReportUiState.error);
      } else {
        setState(() {
          _uiState = ReportUiState.success;
          _hasReports = true;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _uiState = ReportUiState.error);
    }
  }

  void _showEmptyState() {
    setState(() => _uiState = ReportUiState.empty);
  }

  void _retry() {
    setState(() {
      _uiState = ReportUiState.idle;
      _simulateFailure = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _uiState == ReportUiState.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Report Form')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Submit a Report',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                if (_uiState == ReportUiState.loading)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Submitting report... Please wait.'),
                        ],
                      ),
                    ),
                  ),

                if (_uiState == ReportUiState.success)
                  Card(
                    color: Colors.green.shade50,
                    child: const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Report submitted successfully!'),
                      subtitle: Text(
                        'This is a simulated submission. '
                        'No database record was saved.',
                      ),
                    ),
                  ),

                if (_uiState == ReportUiState.empty)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.inbox_outlined),
                      title: const Text('No reports available'),
                      subtitle: const Text(
                        'There are currently no report records to display.',
                      ),
                      trailing: TextButton(
                        onPressed: _retry,
                        child: const Text('Back'),
                      ),
                    ),
                  ),

                if (_uiState == ReportUiState.error)
                  Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      leading: const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      title: const Text('Submission failed'),
                      subtitle: const Text(
                        'A simulated error occurred. Please try again.',
                      ),
                      trailing: TextButton(
                        onPressed: _retry,
                        child: const Text('Retry'),
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Report Title',
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a report title.';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        maxLines: 4,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.trim().length < 5) {
                            return 'Description must be at least 5 characters.';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Simulate submission error'),
                        value: _simulateFailure,
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _simulateFailure = value;
                                });
                              },
                      ),
                      const SizedBox(height: 12),

                      AppButton(
                        label: isLoading ? 'Submitting...' : 'Submit Report',
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submitReport,
                      ),

                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: isLoading ? null : _showEmptyState,
                        icon: const Icon(Icons.inbox_outlined),
                        label: const Text('View Empty State'),
                      ),

                      if (_hasReports)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _uiState = ReportUiState.idle;
                            });
                          },
                          child: const Text('Submit Another Report'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
