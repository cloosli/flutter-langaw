import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:langaw/components/agile-fly.dart';
import 'package:langaw/components/backyard.dart';
import 'package:langaw/components/credits-button.dart';
import 'package:langaw/components/drooler-fly.dart';
import 'package:langaw/components/fly.dart';
import 'package:langaw/components/help-button.dart';
import 'package:langaw/components/house-fly.dart';
import 'package:langaw/components/hungry-fly.dart';
import 'package:langaw/components/macho-fly.dart';
import 'package:langaw/components/start-button.dart';
import 'package:langaw/controllers/spawner.dart';
import 'package:langaw/view.dart';
import 'package:langaw/views/credits-view.dart';
import 'package:langaw/views/help-view.dart';
import 'package:langaw/views/home-view.dart';
import 'package:langaw/views/lost-view.dart';

class LangawGame extends Game {
  Size screenSize;
  double tileSize;
  Backyard background;
  List<Fly> flies;
  Random rnd;
  View activeView = View.home;
  HomeView homeView;
  StartButton startButton;
  LostView lostView;
  HelpView helpView;
  CreditsView creditsView;
  FlySpawner spawner;
  HelpButton helpButton;
  CreditsButton creditsButton;

  LangawGame() {
    initialize();
  }

  void initialize() async {
    rnd = Random();
    flies = List<Fly>();
    resize(await Flame.util.initialDimensions());

    background = Backyard(this);
    startButton = StartButton(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);

    spawner = FlySpawner(this);
    homeView = HomeView(this);
    lostView = LostView(this);
    helpView = HelpView(this);
    creditsView = CreditsView(this);
  }

  void render(Canvas canvas) {
    background.render(canvas);
    flies.forEach((Fly fly) => fly.render(canvas));
    if (activeView == View.home) homeView.render(canvas);
    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }
    if (activeView == View.lost) lostView.render(canvas);
    if (activeView == View.help) helpView.render(canvas);
    if (activeView == View.credits) creditsView.render(canvas);
  }

  void update(double t) {
    flies.forEach((Fly fly) => fly.update(t));
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    spawner.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 2.025));
    double y = rnd.nextDouble() * (screenSize.height - (tileSize * 2.025));
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    // start button
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    // flies
    if (!isHandled) {
      bool didHitAFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) {
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        activeView = View.lost;
      }
    }
  }
}
