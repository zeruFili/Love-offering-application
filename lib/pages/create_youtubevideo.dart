import 'package:flutter/material.dart';
import '../controllers/youtube_controller.dart';
import './YouTubeVideoPage.dart';

class CreateYouTubeVideoPage extends StatefulWidget {
  const CreateYouTubeVideoPage({super.key});

  @override
  _CreateYouTubeVideoPageState createState() => _CreateYouTubeVideoPageState();
}

class _CreateYouTubeVideoPageState extends State<CreateYouTubeVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final _youtubeUrlController = TextEditingController();
  final _videoNameController = TextEditingController();
  final _messageController = TextEditingController();
  final YouTubeVideoController _controller = YouTubeVideoController();

  bool _isLoading = false;

  @override
  void dispose() {
    _youtubeUrlController.dispose();
    _videoNameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final success = await _controller.createVideo(
        youtubeURL: _youtubeUrlController.text,
        videoName: _videoNameController.text,
        message:
            _messageController.text.isNotEmpty ? _messageController.text : null,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const YouTubeVideoPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A5D4A), // App bar color
        title: const Text('Add YouTube Video',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _youtubeUrlController,
                decoration: InputDecoration(
                  labelText: 'YouTube URL',
                  labelStyle: TextStyle(color: const Color(0xFF0A5D4A)),
                  hintText: 'https://www.youtube.com/watch?v=...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF0A5D4A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF0A5D4A), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'URL is required';
                  if (!value.contains('youtube.com') &&
                      !value.contains('youtu.be')) {
                    return 'Invalid YouTube URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoNameController,
                decoration: InputDecoration(
                  labelText: 'Video Title',
                  labelStyle: TextStyle(color: const Color(0xFF0A5D4A)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF0A5D4A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF0A5D4A), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Title is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  labelStyle: TextStyle(color: const Color(0xFF0A5D4A)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF0A5D4A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF0A5D4A), width: 2),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xFF0A5D4A), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
