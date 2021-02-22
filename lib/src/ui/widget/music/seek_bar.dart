import 'package:filimo/src/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:video_player/video_player.dart';

class SliderWidget extends StatefulWidget {
  SliderWidget(this.controller);

  final VideoPlayerController controller;

  @override
  _SliderWidgetState createState() =>
      _SliderWidgetState(controller.value.position.inMilliseconds.toDouble());
}

class _SliderWidgetState extends State<SliderWidget> {
  _SliderWidgetState(this.position);

  double position;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (!mounted) return;
      setState(() {
        position = widget.controller.value.position.inMilliseconds.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: 40,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${widget.controller.value.duration.inMilliseconds.toDouble() > position ? (widget.controller.value.position.inSeconds / 60).floor() : 0}:${widget.controller.value.duration.inMilliseconds.toDouble() > position ? widget.controller.value.position.inSeconds % 60 : 0}',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                              ?Color(0xff97A4B7)
                                              :Colors.grey,),
                ),
                Text(
                  '${(widget.controller.value.duration.inSeconds / 60).floor()}:${widget.controller.value.duration.inSeconds % 60}',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                              ?Color(0xff97A4B7)
                                              :Colors.grey,),
                )
              ],
            ),
          ),
          Container(
            height: 20,
            child: FlutterSlider(
                values:
                    widget.controller.value.duration.inMilliseconds.toDouble() >
                            position
                        ? [position]
                        : [0],
                tooltip: FlutterSliderTooltip(
                    alwaysShowTooltip: false, disabled: true),
                max: widget.controller.value.duration.inMilliseconds.toDouble(),
                min: 0,
                jump: true,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    position = upperValue.roundToDouble() + lowerValue;
                    widget.controller
                        .seekTo(Duration(milliseconds: position.toInt()));
                  });
                },
                handler: FlutterSliderHandler(
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xff97B0EA)
                                  : yellowColor,
                          shape: BoxShape.circle),
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Color(0xffE5F1FD)
                            : bgColor,
                        //borderRadius: BorderRadius.circular(20.0),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color(0xff97A4B7)
                                  : bgdeepColor,
                              offset: new Offset(8.0, 10.0),
                              blurRadius: 25.0)
                        ])),
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 5.0,
                  inactiveTrackBarHeight: 5.0,
                  
                  activeTrackBar: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Color(0xff95AEDE)
                        : yellowColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                  ),
                  inactiveTrackBar: 
                  BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Color(0x110000ff)
                        : bgdeepColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0)),
                  ),
                )
              
                ),
          ),
        ],
      ),
    );
  }
}
