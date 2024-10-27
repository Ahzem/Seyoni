import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';

class DraggableFloatingActionButton extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const DraggableFloatingActionButton({super.key, required this.navigatorKey});

  @override
  DraggableFloatingActionButtonState createState() =>
      DraggableFloatingActionButtonState();
}

class DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  double posX = 100;
  double posY = 100;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: posX,
          top: posY,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                posX += details.delta.dx;
                posY += details.delta.dy;
              });
            },
            onTap: () {
              showDialog(
                context: widget.navigatorKey.currentContext!,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(0),
                    child: Container(
                      width: 300,
                      height: 500,
                      color: Colors.white,
                      child: Center(child: Text('Popup Content Here')),
                    ),
                  );
                },
              );
            },
            child: FloatingActionButton(
              onPressed: null,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
