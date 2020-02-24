import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:langaw/langaw-game.dart';

class Fly {
  final LangawGame game;
  Rect flyRect;
  Paint flyPaint;
  bool isDead = false;
  bool isOffScreen = false;

  Fly(this.game, double x, double y) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    flyPaint = Paint();
    flyPaint.color = Colors.brown;
  }

  void render(Canvas c) {
    c.drawRect(flyRect, flyPaint);
  }

  void update(double timeDelta) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * timeDelta);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    }
  }

  void onTapDown() {
    flyPaint.color = Colors.redAccent;
    isDead = true;
    game.spawnFly();
  }
}
