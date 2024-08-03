# PhotoShopForText
MoveText is a Flutter application that allows users to dynamically add, customize, and move text widgets within a designated area. The app offers features such as font selection, size adjustment, color picking, and undo/redo functionalities.

**Here is a demo video:**

[![Demo Video](https://img.youtube.com/vi/5iHjXAnZuxQ/maxresdefault.jpg)](https://www.youtube.com/watch?v=5iHjXAnZuxQ)

## Features
Add Text: Users can add text widgets to the canvas by entering text in a dialog box.
Customize Text: Users can change the font, size, and color of the selected text widget.
Move Text: Text widgets can be dragged and repositioned within the canvas.
Undo/Redo: Users can undo and redo actions to manage their changes effectively.
Reset: Users can reset the selected text widget to default settings.
Getting Started

## Prerequisites
Flutter SDK: Install Flutter
Dart: Install Dart

## Setup and Installation

1. **Clone the Repository**

    ```sh
    git clone https://github.com/RishiMaddi1/Pave_ai_assignment.git
    ```

2. **Navigate to the Project Directory**

    ```sh
    cd Pave_ai_assignment
    ```

3. **Install Dependencies**

    ```sh
    flutter pub get
    ```

4. **Run the Application**

    ```sh
    flutter run
    ```

## Code Overview

**Main Application**

The main entry point of the application is defined in main.dart:

```sh
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
```

```sh
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MaterialApp(
      home: MoveText(),
    ));
  });
}
```

**MoveText Widget**
MoveText is a stateful widget that manages the text widgets, customization options, and their interactions:

```sh
class MoveText extends StatefulWidget {
  @override
  _MoveTextState createState() => _MoveTextState();
}
```

**State Management**

The state of the application, including the list of text widgets, selected index, font size, color, and family, is managed in _MoveTextState:


```sh
class _MoveTextState extends State<MoveText> {
  List<Map<String, dynamic>> _textWidgets = [];
  int _selectedIndex = -1;
  double _fontSize = 14.0;
  Color _fontColor = Colors.black;
  String _fontFamily = 'Roboto';
  // Additional state variables...
}
```

**Adding Text**
Users can add a text widget by tapping the "Add Text" button, which opens a dialog for entering text:


```
void _showAddTextDialog() {
  String newText = '';
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Text'),
        content: TextField(
          onChanged: (value) {
            newText = value;
          },
        ),
        actions: [
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              _addTextWidget(newText);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
```

**Customizing Text**
Users can customize the selected text widget's font, size, and color:



```sh
void _updateSelectedTextWidget() {
  if (_selectedIndex >= 0 && _selectedIndex < _textWidgets.length) {
    setState(() {
      _textWidgets[_selectedIndex]['fontSize'] = _fontSize;
      _textWidgets[_selectedIndex]['fontColor'] = _fontColor;
      _textWidgets[_selectedIndex]['fontFamily'] = _fontFamily;
      // Additional update logic...
    });
  }
}
```

**Undo/Redo Functionality**
The application supports undo and redo operations to manage changes:

```sh
void _undo() {
    if (_undoStack.isNotEmpty) {
      final action = _undoStack.removeLast();
      setState(() {
        switch (action['action']) {
          case 'add':
            _textWidgets.remove(action['widget']);
            break;
          case 'update':
            final index = action['index'];
            _textWidgets[index]['fontSize'] = action['previous']['fontSize'];
            _textWidgets[index]['fontColor'] = action['previous']['fontColor'];
            _textWidgets[index]['fontFamily'] = action['previous']['fontFamily'];
            break;
          case 'move':
            final index = action['index'];
            _textWidgets[index]['position'] = action['previous'];
            break;
        }
        _redoStack.add(action);
      });
    }
  }

void _redo() {
    if (_redoStack.isNotEmpty) {
      final action = _redoStack.removeLast();
      setState(() {
        switch (action['action']) {
          case 'add':
            _textWidgets.add(action['widget']);
            break;
          case 'update':
            final index = action['index'];
            _textWidgets[index]['fontSize'] = action['current']['fontSize'];
            _textWidgets[index]['fontColor'] = action['current']['fontColor'];
            _textWidgets[index]['fontFamily'] = action['current']['fontFamily'];
            break;
          case 'move':
            final index = action['index'];
            _textWidgets[index]['position'] = action['current'];
            break;
        }
        _undoStack.add(action);
      });
    }
  }
```

**Reset Functionality**
Users can reset the selected text widget to default settings:

```sh
void _reset() {
  setState(() {
    _fontSize = 14.0;
    _fontColor = Colors.black;
    _fontFamily = 'Roboto';
    _selectedIndex = -1;
    // Additional reset logic...
  });
}
```

## Contributing

To contribute to this project:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes.
4. Push to your branch.
5. Open a pull request.

## Contact

For questions or inquiries, contact:

- Email: [maddi.rishi2468@gmail.com](mailto:maddi.rishi2468@gmail.com)
