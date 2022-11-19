import 'package:flutter/material.dart';

class GenericTile<T> extends StatelessWidget {
  final T value;
  final IconData iconData;
  final String name;
  final void Function(T value) onTap;

  GenericTile({
    required this.value,
    required this.iconData,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 40,
      margin: EdgeInsets.only(top: 6),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 70, 70, 70),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => _onTap(context),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            _icon(),
            _name(),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    onTap(value);
  }

  Widget _icon() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Icon(
        iconData,
        color: Colors.white,
      ),
    );
  }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
