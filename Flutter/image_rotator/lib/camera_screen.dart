import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.courseNum
  });

  final CameraDescription camera;
  final String courseNum;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                  courseNum: widget.courseNum,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final String courseNum;
  const DisplayPictureScreen({Key? key, required this.imagePath, required this.courseNum}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.file(File(widget.imagePath)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isUploading ? null : _uploadToDrive,
            child: _isUploading ? const CircularProgressIndicator() : const Text('Upload to Drive'),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadToDrive() async {
    setState(() {
      _isUploading = true;
    });

    try {
      await uploadImageToDrive(File(widget.imagePath), widget.courseNum);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading image: $e')));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<ServiceAccountCredentials> getServiceAccountCredentials() async {
    final jsonString = await rootBundle.loadString('assets/oelp-414905-f8a2167cc383.json');

    // print(jsonString);
    final jsonData = json.decode(jsonString);
    return ServiceAccountCredentials.fromJson(jsonData);
  }
  Future<void> uploadImageToDrive(File imageFile, String courseNum) async {
    final serviceAccountCredentials = await getServiceAccountCredentials();

    final client = await clientViaServiceAccount(serviceAccountCredentials, [
      drive.DriveApi.driveScope,
    ]);

    final driveApi = drive.DriveApi(client);
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now); // Format the timestamp as desired
    final imageFileName = '{$courseNum}_$timestamp.jpg';
    final imageBytes = await imageFile.readAsBytes();

    // Search for the folder named "camera_photos"
    var folderId = await getFolderId(driveApi, "Camera_photos");

    if (folderId == null) {
      print("Folder not found!");
      return;
    }

    final media = drive.Media(imageFile.openRead(), imageBytes.length);

    await driveApi.files.create(
      drive.File()
        ..name = imageFileName
        ..parents = [folderId],
      uploadMedia: media,
    );

    client.close();
  }
}

Future<String?> getFolderId(drive.DriveApi driveApi, String folderName) async {
  try {
    final response = await driveApi.files.list(q: "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder'");
    if (response.files != null && response.files!.isNotEmpty) {
      return response.files!.first.id;
    }
  } catch (e) {
    print("Error fetching folder ID: $e");
  }
  return null;
}
