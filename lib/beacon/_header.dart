import 'package:beacons/beacons.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  Header(
      {Key key,
      this.regionIdentifier,
      this.running,
      this.onStart,
      this.onStop,
      this.beaconID,
      this.major,
      this.minor})
      : super(key: key);
  final String beaconID, major, minor;
  final String regionIdentifier;
  final bool running;
  final ValueChanged<BeaconRegion> onStart;
  final VoidCallback onStop;

  @override
  _HeaderState createState() => new _HeaderState();
}

class _HeaderState extends State<Header> {
  void _onTapSubmit() {
    if (widget.running) {
      widget.onStop();
    } else {
      BeaconRegion region =
          BeaconRegion(identifier: widget.regionIdentifier, ids: [
        widget.beaconID.toString(),
        int.parse(widget.major, radix: 16)?.toString() ?? null,
        int.parse(widget.minor, radix: 16)?.toString() ?? null,
        // '23A01AF0-232A-4518-9C0E-323FB773F5EF',
        // int.parse('ACE6', radix: 16).toString(),
        // int.parse('51F0', radix: 16).toString()
      ]);
      widget.onStart(region);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          new SizedBox(
            height: 10.0,
          ),
          new _Button(
            running: widget.running,
            onTap: _onTapSubmit,
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  _Button({
    @required this.running,
    @required this.onTap,
  });

  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: new BoxDecoration(
          color: running ? Colors.red[200] : Colors.green[200],
          borderRadius: new BorderRadius.all(
            new Radius.circular(6.0),
          ),
        ),
        child: new Text(
          running ? 'Stop' : 'Start',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
