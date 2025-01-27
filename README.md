# Object Detection Flutter App

## What's This About?
This app is a demo of how Flutter can be used for real-time object detection, user guidance, and image capture. Imagine pointing your phone at an object, getting tips like "Move closer" or "Move farther," and then—snap!—the app captures the perfect shot and shows it to you with useful info. Simple, clean, and responsive.

## Features
### 1. Real-Time Object Detection
- Powered by TensorFlow Lite, this app recognizes objects like laptops, cell phones, mice, and bottles on the fly.

### 2. User Guidance
- Not just detection, but guidance too! Messages like "Move closer" or "Move farther" help users position objects correctly.
- Adds a polished touch with visual cues (bounding boxes around detected objects).

### 3. Auto-Capture Magic
- When the object is perfectly aligned, the app auto-captures the image.
- You’ll then be taken to a screen where you can see the image and metadata like the object type and timestamp.

### 4. Responsive UI
- Works like a charm in both portrait and landscape modes.
- UI is minimal and user-friendly.

## How It Works (Flow)
1. Launch the app and pick an object to detect (laptop, cell phone, etc.).
2. The camera opens, detecting the selected object in real-time.
3. Follow the guidance to position the object correctly.
4. The app captures the image and shows it on a separate screen with metadata.

## Getting Started
Clone the Repo


### Step 2: Install Dependencies
Before you run the app, make sure Flutter is installed, then do:
```bash
flutter pub get
```

### Step 3: Run It!
Hook up your device or start an emulator and run:
```bash
flutter run
```

## What's Inside?
- **`main.dart`**: The entry point of the app.
- **`object_selection_screen.dart`**: Where users pick the object to detect.
- **`camera_view_ref.dart` / `camera_view.dart`**: Handles the camera feed and detection logic.
- **`scan_controller.dart` / `scan_provider.dart`**: Keeps things organized and manages the app's state.
- **`captured_image_screen.dart`**: Displays the captured image and metadata.
- **`loader_widget.dart`**: Shows a simple loading indicator.

## Dependencies
This app uses:
- **`camera`**: For accessing the camera.
- **`flutter_tflite`**: To integrate TensorFlow Lite.
- **`permission_handler`**: To manage camera permissions.
- **`path_provider`**: For saving captured images.
- **`get`** / **`provider`**: For state management.
- **`image`**: For image processing.

## Challenges We Tackled
- **Making Object Detection Smooth**: Integrated TensorFlow Lite to run seamlessly without lag.
- **Converting Images**: Figured out a way to turn `CameraImage` into a file you can view.
- **User-Friendly Guidance**: Made the guidance system intuitive so users feel confident using the app.

## Bonus Features
We didn’t stop at the basics:
- Multiple object types supported.
- Bounding boxes with labels around detected objects.
- Error handling for low-light or permission-denied scenarios.

## How Cool Is It?
Check out the demo video included in the repository to see the app in action.

## Some Quick Notes
- Make sure your device has a working camera.
- The TensorFlow Lite model (`ssd_mobilenet.tflite`) and labels must be in the `assets` folder.
- Want to add more objects? Modify the `objects` list in `object_selection_screen.dart`.

## Show Me the Screens!
Here’s what you’ll see:
- Object Selection Screen
- Real-Time Object Detection Screen
- Captured Image Screen with Metadata

