import 'package:flame/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:langaw/langaw-game.dart';

void main() {
  LangawGame game = LangawGame();
  runApp(game.widget);

  Util flameUtil = Util();
  flameUtil.fullScreen();
  flameUtil.setOrientation(DeviceOrientation.portraitUp);

  TapGestureRecognizer tapper = TapGestureRecognizer()
    ..onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}
