import 'package:flutter/material.dart';

class ExpandableAddressWidget extends StatefulWidget {
  final String title;
  final String address;

  ExpandableAddressWidget({required this.title, required this.address});

  @override
  _ExpandableAddressWidgetState createState() =>
      _ExpandableAddressWidgetState();
}

class _ExpandableAddressWidgetState extends State<ExpandableAddressWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ],
        ),
        isExpanded
            ? Text(
                widget.address,
                softWrap: true,
              )
            : Text(
                widget.address,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
      ],
    );
  }
}