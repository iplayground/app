import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iplayground19/api/api.dart';

class RoomLabel extends StatelessWidget {
  final Session session;

  const RoomLabel({
    Key key,
    @required this.session,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = () {
      switch (session.roomName) {
        case '801':
          return Colors.red;
        case '803':
          return Colors.blue;
        case '1002':
          return Colors.green;
        case '1005':
          return Colors.orange;
        default:
          return Colors.black;
      }
    }();

    return DecoratedBox(
        decoration: BoxDecoration(border: Border.all(color: color)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(session.roomName,
              style: TextStyle(color: color, fontSize: 12)),
        ));
  }
}
