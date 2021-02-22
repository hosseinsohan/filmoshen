import 'package:filimo/src/models/slider/Slider.dart';

class SliderModel {
  List<Slider> sliders;

  SliderModel({this.sliders});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      sliders: json['sliders'] != null
          ? (json['sliders'] as List).map((i) => Slider.fromJson(i)).toList()
          : null,
    );
  }
}
