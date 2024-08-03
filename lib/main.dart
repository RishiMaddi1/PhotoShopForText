import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

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

class MoveText extends StatefulWidget {
  @override
  _MoveTextState createState() => _MoveTextState();
}

class _MoveTextState extends State<MoveText> {
  List<Map<String, dynamic>> _textWidgets = [];
  int _selectedIndex = -1;
  double _fontSize = 14.0;
  Color _fontColor = Colors.black;
  String _fontFamily = 'Roboto';

  final List<Map<String, dynamic>> _undoStack = [];
  final List<Map<String, dynamic>> _redoStack = [];

  final List<String> _googleFonts = [
    'Roboto',
    'Open Sans',
    'Lora',
    'Montserrat',
    'Merriweather',
    'Oswald',
    'Raleway',
    'Playfair Display',
    'Nunito',
    'Poppins',
    'Quicksand',
    'Roboto Condensed',
    'Dancing Script',
    'Amatic SC',
    'Abril Fatface',
    'Source Sans Pro',
    'Titillium Web',
    'PT Sans',
    'Work Sans',
    'Karla',
    'Ubuntu',
    // Add more fonts as needed
  ];

  void _addTextWidget(String text) {
    setState(() {
      final newTextWidget = {
        'text': text,
        'fontSize': _fontSize,
        'fontColor': _fontColor,
        'fontFamily': _fontFamily,
        'isSelected': false,
        'position': const Offset(0, 0),
      };
      _textWidgets.add(newTextWidget);
      _undoStack.add({'action': 'add', 'widget': newTextWidget});
      _redoStack.clear();
    });
  }

  void _updateSelectedTextWidget() {
    if (_selectedIndex >= 0 && _selectedIndex < _textWidgets.length) {
      setState(() {
        _undoStack.add({
          'action': 'update',
          'index': _selectedIndex,
          'previous': {
            'fontSize': _textWidgets[_selectedIndex]['fontSize'],
            'fontColor': _textWidgets[_selectedIndex]['fontColor'],
            'fontFamily': _textWidgets[_selectedIndex]['fontFamily'],
          },
          'current': {
            'fontSize': _fontSize,
            'fontColor': _fontColor,
            'fontFamily': _fontFamily,
          },
        });
        _textWidgets[_selectedIndex]['fontSize'] = _fontSize;
        _textWidgets[_selectedIndex]['fontColor'] = _fontColor;
        _textWidgets[_selectedIndex]['fontFamily'] = _fontFamily;
        _redoStack.clear();
      });
    }
  }

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

  void _showColorPicker() {
    Color pickerColor = _fontColor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                setState(() {
                  _fontColor = pickerColor;
                  _updateSelectedTextWidget();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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

  void _reset() {
    setState(() {
      _fontSize = 14.0;
      _fontColor = Colors.black;
      _fontFamily = 'Roboto';
      _selectedIndex = -1;
      // _undoStack.clear();
      // _redoStack.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        hintColor: Colors.black,
        scaffoldBackgroundColor: Colors.green[50],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [

              const SizedBox(width: 10),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _undo, child: const Icon(Icons.undo)),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: _redo, child: const Icon(Icons.redo)),
            ],
          ),
          backgroundColor: Colors.green,
          actions: [
            const Center(
              child: Text(
                'MoveText',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('About Move Text'),
                      content: const Text(
                          'This website is designed to work like Photoshop but for text'),
                      actions: [
                        ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),

        body: GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedIndex >= 0 && _selectedIndex < _textWidgets.length) {
                _textWidgets[_selectedIndex]['isSelected'] = false;
                _selectedIndex = -1;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 7,

                  child: FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    heightFactor: 0.9, // 90% of available height
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Stack(
                        children: _textWidgets.map((widgetData) {
                          int index = _textWidgets.indexOf(widgetData);
                          return Positioned(
                            left: widgetData['position'].dx,
                            top: widgetData['position'].dy,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedIndex >= 0 &&
                                      _selectedIndex < _textWidgets.length) {
                                    _textWidgets[_selectedIndex]['isSelected'] =
                                    false;
                                  }
                                  _selectedIndex = index;
                                  _textWidgets[_selectedIndex]['isSelected'] =
                                  true;

                                  _fontSize = widgetData['fontSize'];
                                  _fontColor = widgetData['fontColor'];
                                  _fontFamily = widgetData['fontFamily'];
                                });
                              },
                              child: Draggable(
                                feedback: Material(
                                  child: Text(
                                    widgetData['text'],
                                    style: GoogleFonts.getFont(
                                      widgetData['fontFamily'],
                                      textStyle: TextStyle(
                                        fontSize: widgetData['fontSize'],
                                        color: widgetData['fontColor'],
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(),
                                onDragEnd: (details) {
                                  setState(() {
                                    _undoStack.add({
                                      'action': 'move',
                                      'index': index,
                                      'previous': widgetData['position'],
                                      'current': Offset(
                                        details.offset.dx - 20,
                                        details.offset.dy - 100,
                                      ),
                                    });
                                    _textWidgets[index]['position'] = Offset(
                                      details.offset.dx - 20,
                                      // Adjust these values to fit your layout
                                      details.offset.dy - 100,
                                      // Adjust these values to fit your layout
                                    );
                                    _redoStack.clear();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: widgetData['isSelected']
                                      ? Colors.blue
                                      : Colors.green[50],
                                  child: Text(
                                    widgetData['text'],
                                    style: GoogleFonts.getFont(
                                      widgetData['fontFamily'],
                                      textStyle: TextStyle(
                                        fontSize: widgetData['fontSize'],
                                        color: widgetData['fontColor'],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double availableHeight = constraints.maxHeight;
                      double padding = availableHeight * 0.03; // 1% of available height for padding
                      double dropdownHeight = availableHeight * 0.15; // 15% of available height for dropdowns
                      double containerHeight = availableHeight * 0.07; // 7% of available height for container
                      double buttonHeight = availableHeight * 0.10; // 10% of available height for buttons

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: padding),
                          const Text(
                            'Font',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: double.infinity,
                              height: dropdownHeight,
                              child: DropdownButton<String>(
                                value: _fontFamily,
                                isExpanded: true,
                                items: _googleFonts.map((font) {
                                  return DropdownMenuItem<String>(
                                    value: font,
                                    child: Text(font),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _fontFamily = value!;
                                    _updateSelectedTextWidget();
                                  });
                                },
                              ),
                            ),
                          ),
                          const Text(
                            'Size',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: double.infinity,
                              height: dropdownHeight,
                              child: DropdownButton<double>(
                                value: _fontSize,
                                isExpanded: true,
                                items: List.generate(
                                  20,
                                      (index) => DropdownMenuItem<double>(
                                    value: (index + 1) * 2.0,
                                    child: Text('${(index + 1) * 2}'),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _fontSize = value!;
                                    _updateSelectedTextWidget();
                                  });
                                },
                              ),
                            ),
                          ),
                          const Text(
                            'Color',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: containerHeight,
                                  child: GestureDetector(
                                    onTap: _showColorPicker,
                                    child: Container(
                                      width: double.infinity,
                                      height: containerHeight,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: _fontColor,
                                      ),
                                      child: Center(
                                        child: Icon(Icons.rectangle, color: _fontColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: padding),
                                Container(
                                  width: double.infinity,
                                  height: buttonHeight,
                                  child: FloatingActionButton.extended(
                                    onPressed: _showAddTextDialog,
                                    label: const Text('Add Text'),
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                SizedBox(height: padding),
                                Container(
                                  width: double.infinity,
                                  height: buttonHeight*0.3,
                                  child: ElevatedButton(
                                    onPressed: _reset,
                                    child: const Text('Reset'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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