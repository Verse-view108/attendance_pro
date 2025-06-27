import 'package:flutter/material.dart';
import 'package:attendance_pro/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class AssignmentUploadPanel extends StatefulWidget {
  final String userId;
  final String userRole;

  const AssignmentUploadPanel({required this.userId, required this.userRole, Key? key}) : super(key: key);

  @override
  _AssignmentUploadPanelState createState() => _AssignmentUploadPanelState();
}

class _AssignmentUploadPanelState extends State<AssignmentUploadPanel> {
  final _formKey = GlobalKey<FormState>();
  String? title, description, subjectId, semester;
  int? year;
  DateTime? dueDate;
  List<String> tags = [];
  String? fileUrl;
  bool allowResubmissions = false;
  bool isLoading = false;
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> _uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
      if (result == null || result.files.isEmpty) return;
      setState(() => isLoading = true);
      final file = result.files.first;
      if (file.size > 5 * 1024 * 1024) { // 5MB limit
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('File too large')));
        return;
      }
      final ref = FirebaseStorage.instance.ref('assignments/${file.name}');
      await ref.putData(file.bytes!);
      fileUrl = await ref.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _saveAssignment() async {
    if (!_formKey.currentState!.validate() || fileUrl == null || dueDate == null) return;
    setState(() => isLoading = true);
    try {
      await _firestoreService.addAssignment({
        'title': title,
        'description': description,
        'subjectId': subjectId,
        'semester': semester,
        'year': year,
        'dueDate': dueDate!.toIso8601String(),
        'tags': tags,
        'fileUrl': fileUrl,
        'allowResubmissions': allowResubmissions,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Assignment saved')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Assignment')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) => value == null || value.isEmpty ? 'Title required' : null,
                      onChanged: (value) => title = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onChanged: (value) => description = value,
                    ),
                    DropdownButtonFormField<String>(
                      value: subjectId,
                      hint: Text('Select Subject'),
                      validator: (value) => value == null ? 'Subject required' : null,
                      items: ['CS101', 'MA102'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (value) => setState(() => subjectId = value),
                    ),
                    ElevatedButton(
                      onPressed: _uploadFile,
                      child: Text('Upload PDF'),
                    ),
                    ElevatedButton(
                      onPressed: _saveAssignment,
                      child: Text('Save Assignment'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
