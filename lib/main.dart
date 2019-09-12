import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        // ใส่ไว้เพื่อให้ Focus ที่ TextField หายเมื่อคลิกข้างนอก
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awesome Overlay',
        ),
      ),
      body: Container(
        color: Colors.green,
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            TextFieldWithSuggestion(),
          ],
        ),
      ),
    );
  }
}

class TextFieldWithSuggestion extends StatefulWidget {
  @override
  _TextFieldWithSuggestionState createState() =>
      _TextFieldWithSuggestionState();
}

class _TextFieldWithSuggestionState extends State<TextFieldWithSuggestion> {
  FocusNode _focusNode = FocusNode(); // FocusNode เอาไว้ควบคุมการโฟกัส Widget
  LayerLink _layerLink = LayerLink(); // ตัวเชื่อมระว่าง Widget
  OverlayEntry _overlay;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlay = _createSuggestionOverlay();
        Overlay.of(context).insert(_overlay);
      } else {
        _overlay.remove();
      }
    });
    super.initState();
  }

  OverlayEntry _createSuggestionOverlay() {
    RenderBox renderBox =
        context.findRenderObject(); // พิกัด และขนาดการ Render ของ Widget นี้
    var size = renderBox.size; // ขนาดของ Widget

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 2.0,
            child: _suggestionList(),
          ),
        ),
      ),
    );
  }

  Widget _suggestionList() {
    return Container(
      height: 100.0,
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          ListTile(title: Text('This')),
          ListTile(title: Text('is')),
          ListTile(title: Text('very')),
          ListTile(title: Text('awesome')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        focusNode: _focusNode,
      ),
    );
  }
}
