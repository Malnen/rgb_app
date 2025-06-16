import 'dart:math';

import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/models/device_product_vendor.dart';

class KeyDictionary {
  static KeyboardKey esc = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 4,
    keyCode: KeyCode.esc,
  );
  static KeyboardKey backQuote = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 5,
    keyCode: KeyCode.backQuote,
  );
  static KeyboardKey tab = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 6,
    keyCode: KeyCode.tab,
  );
  static KeyboardKey capsLock = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 7,
    keyCode: KeyCode.capsLock,
  );
  static KeyboardKey leftShift = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 8,
    keyCode: KeyCode.leftShift,
  );
  static KeyboardKey leftControl = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 9,
    keyCode: KeyCode.leftControl,
  );
  static KeyboardKey f12 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 10,
    keyCode: KeyCode.f12,
  );
  static KeyboardKey equal = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 11,
    keyCode: KeyCode.equal,
  );
  static KeyboardKey lock = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 12,
    keyCode: KeyCode.lock,
  );
  static KeyboardKey num7 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 13,
    keyCode: KeyCode.numpad_7,
  );
  static KeyboardKey g1 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 14,
    keyCode: KeyCode.g1,
  );
  static KeyboardKey f1 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 16,
    keyCode: KeyCode.f1,
  );
  static KeyboardKey key1 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 17,
    keyCode: KeyCode.key1,
  );
  static KeyboardKey q = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 18,
    keyCode: KeyCode.q,
  );
  static KeyboardKey a = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 19,
    keyCode: KeyCode.a,
  );
  static KeyboardKey leftBackSlash = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 20,
    keyCode: KeyCode.leftBackSlash,
  );
  static KeyboardKey leftWin = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 21,
    keyCode: KeyCode.leftWin,
  );
  static KeyboardKey printScreen = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 22,
    keyCode: KeyCode.printScreen,
  );
  static KeyboardKey mute = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 24,
    keyCode: KeyCode.mute,
  );
  static KeyboardKey num8 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 25,
    keyCode: KeyCode.numpad_8,
  );
  static KeyboardKey g2 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 26,
    keyCode: KeyCode.g2,
  );
  static KeyboardKey f2 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 28,
    keyCode: KeyCode.f2,
  );
  static KeyboardKey key2 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 29,
    keyCode: KeyCode.key2,
  );
  static KeyboardKey w = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 30,
    keyCode: KeyCode.w,
  );
  static KeyboardKey s = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 31,
    keyCode: KeyCode.s,
  );
  static KeyboardKey z = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 32,
    keyCode: KeyCode.z,
  );
  static KeyboardKey leftAlt = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 33,
    keyCode: KeyCode.leftAlt,
  );
  static KeyboardKey scrollLock = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 34,
    keyCode: KeyCode.scrollLock,
  );
  static KeyboardKey backSpace = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 35,
    keyCode: KeyCode.backSpace,
  );
  static KeyboardKey pause = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 36,
    keyCode: KeyCode.pause,
  );
  static KeyboardKey num9 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 37,
    keyCode: KeyCode.numpad_9,
  );
  static KeyboardKey g3 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 38,
    keyCode: KeyCode.g3,
  );
  static KeyboardKey f3 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 40,
    keyCode: KeyCode.f3,
  );
  static KeyboardKey key3 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 41,
    keyCode: KeyCode.key3,
  );
  static KeyboardKey e = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 42,
    keyCode: KeyCode.e,
  );
  static KeyboardKey d = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 43,
    keyCode: KeyCode.d,
  );
  static KeyboardKey x = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 44,
    keyCode: KeyCode.x,
  );
  static KeyboardKey pauseBreak = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 46,
    keyCode: KeyCode.pauseBreak,
  );
  static KeyboardKey delete = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 47,
    keyCode: KeyCode.delete,
  );
  static KeyboardKey previous = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 48,
    keyCode: KeyCode.previous,
  );
  static KeyboardKey g4 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 50,
    keyCode: KeyCode.g4,
  );
  static KeyboardKey f4 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 52,
    keyCode: KeyCode.f4,
  );
  static KeyboardKey key4 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 53,
    keyCode: KeyCode.key4,
  );
  static KeyboardKey r = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 54,
    keyCode: KeyCode.r,
  );
  static KeyboardKey f = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 55,
    keyCode: KeyCode.f,
  );
  static KeyboardKey c = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 56,
    keyCode: KeyCode.c,
  );
  static KeyboardKey space = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 57,
    keyCode: KeyCode.spacebar,
  );
  static KeyboardKey insert = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 58,
    keyCode: KeyCode.insert,
  );
  static KeyboardKey end = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 59,
    keyCode: KeyCode.end,
  );
  static KeyboardKey resumeStop = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 60,
    keyCode: KeyCode.resumeStop,
  );
  static KeyboardKey num4 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 61,
    keyCode: KeyCode.numpad_4,
  );
  static KeyboardKey g5 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 62,
    keyCode: KeyCode.g5,
  );
  static KeyboardKey f5 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 4,
    keyCode: KeyCode.f5,
  );
  static KeyboardKey key5 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 5,
    keyCode: KeyCode.key5,
  );
  static KeyboardKey t = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 6,
    keyCode: KeyCode.t,
  );
  static KeyboardKey g = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 7,
    keyCode: KeyCode.g,
  );
  static KeyboardKey v = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 8,
    keyCode: KeyCode.v,
  );
  static KeyboardKey home = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 10,
    keyCode: KeyCode.home,
  );
  static KeyboardKey pageDown = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 11,
    keyCode: KeyCode.pageDown,
  );
  static KeyboardKey next = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 12,
    keyCode: KeyCode.next,
  );
  static KeyboardKey num5 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 13,
    keyCode: KeyCode.numpad_5,
  );
  static KeyboardKey g6 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 14,
    keyCode: KeyCode.g6,
  );
  static KeyboardKey f6 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 16,
    keyCode: KeyCode.f6,
  );
  static KeyboardKey key6 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 17,
    keyCode: KeyCode.key6,
  );
  static KeyboardKey y = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 18,
    keyCode: KeyCode.y,
  );
  static KeyboardKey h = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 19,
    keyCode: KeyCode.h,
  );
  static KeyboardKey b = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 20,
    keyCode: KeyCode.b,
  );
  static KeyboardKey pageUp = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 22,
    keyCode: KeyCode.pageUp,
  );
  static KeyboardKey rightShift = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 23,
    keyCode: KeyCode.rightShift,
  );
  static KeyboardKey numLock = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 24,
    keyCode: KeyCode.numLock,
  );
  static KeyboardKey num6 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 25,
    keyCode: KeyCode.numpad_6,
  );
  static KeyboardKey f7 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 28,
    keyCode: KeyCode.f7,
  );
  static KeyboardKey key7 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 29,
    keyCode: KeyCode.key7,
  );
  static KeyboardKey u = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 30,
    keyCode: KeyCode.u,
  );
  static KeyboardKey j = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 31,
    keyCode: KeyCode.j,
  );
  static KeyboardKey n = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 32,
    keyCode: KeyCode.n,
  );
  static KeyboardKey rightAlt = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 33,
    keyCode: KeyCode.rightAlt,
  );
  static KeyboardKey closeBracket = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 34,
    keyCode: KeyCode.closeBracket,
  );
  static KeyboardKey rightControl = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 35,
    keyCode: KeyCode.rightControl,
  );
  static KeyboardKey divide = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 36,
    keyCode: KeyCode.divide,
  );
  static KeyboardKey num1 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 37,
    keyCode: KeyCode.numpad_1,
  );
  static KeyboardKey f8 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 40,
    keyCode: KeyCode.f8,
  );
  static KeyboardKey key8 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 41,
    keyCode: KeyCode.key8,
  );
  static KeyboardKey i = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 42,
    keyCode: KeyCode.i,
  );
  static KeyboardKey k = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 43,
    keyCode: KeyCode.k,
  );
  static KeyboardKey m = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 44,
    keyCode: KeyCode.m,
  );
  static KeyboardKey rightWin = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 45,
    keyCode: KeyCode.rightWin,
  );
  static KeyboardKey upArrow = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 47,
    keyCode: KeyCode.upArrow,
  );
  static KeyboardKey multiply = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 48,
    keyCode: KeyCode.multiply,
  );
  static KeyboardKey num2 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 49,
    keyCode: KeyCode.numpad_2,
  );
  static KeyboardKey f9 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 52,
    keyCode: KeyCode.f9,
  );
  static KeyboardKey key9 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 53,
    keyCode: KeyCode.key9,
  );
  static KeyboardKey o = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 54,
    keyCode: KeyCode.o,
  );
  static KeyboardKey l = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 55,
    keyCode: KeyCode.l,
  );
  static KeyboardKey comma = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 56,
    keyCode: KeyCode.comma,
  );
  static KeyboardKey contextMenu = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 57,
    keyCode: KeyCode.contextMenu,
  );
  static KeyboardKey backSlash = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 58,
    keyCode: KeyCode.backSlash,
  );
  static KeyboardKey leftArrow = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 59,
    keyCode: KeyCode.leftArrow,
  );
  static KeyboardKey subtract = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 60,
    keyCode: KeyCode.subtract,
  );
  static KeyboardKey num3 = KeyboardKey.withRandomKey(
    packetIndex: 1,
    index: 61,
    keyCode: KeyCode.numpad_3,
  );
  static KeyboardKey f10 = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 4,
    keyCode: KeyCode.f10,
  );
  static KeyboardKey key0 = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 5,
    keyCode: KeyCode.key0,
  );
  static KeyboardKey p = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 6,
    keyCode: KeyCode.p,
  );
  static KeyboardKey semicolon = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 7,
    keyCode: KeyCode.semicolon,
  );
  static KeyboardKey period = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 8,
    keyCode: KeyCode.period,
  );
  static KeyboardKey profile = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 9,
    keyCode: KeyCode.profile,
  );
  static KeyboardKey enter = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 10,
    keyCode: KeyCode.enter,
  );
  static KeyboardKey downArrow = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 11,
    keyCode: KeyCode.downArrow,
  );
  static KeyboardKey add = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 12,
    keyCode: KeyCode.add,
  );
  static KeyboardKey num0 = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 13,
    keyCode: KeyCode.numpad_0,
  );
  static KeyboardKey f11 = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 16,
    keyCode: KeyCode.f11,
  );
  static KeyboardKey minus = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 17,
    keyCode: KeyCode.minus,
  );
  static KeyboardKey openBracket = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 18,
    keyCode: KeyCode.openBracket,
  );
  static KeyboardKey quote = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 19,
    keyCode: KeyCode.quote,
  );
  static KeyboardKey slash = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 20,
    keyCode: KeyCode.slash,
  );
  static KeyboardKey lightningKey = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 21,
    keyCode: KeyCode.lightningKey,
  );
  static KeyboardKey rightArrow = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 23,
    keyCode: KeyCode.rightArrow,
  );
  static KeyboardKey rightEnter = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 24,
    keyCode: KeyCode.enter,
  );
  static KeyboardKey decimal = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 25,
    keyCode: KeyCode.decimal,
  );

  static KeyboardKey led(int packetIndex, int index) => KeyboardKey.withRandomKey(
        packetIndex: packetIndex,
        index: index,
        keyCode: KeyCode.unknown,
      );

  static KeyboardKey get emptyKey => KeyboardKey.withRandomKey(
        packetIndex: -1,
        index: -1,
        keyCode: KeyCode.unknown,
      );

  static final Map<Point<int>, List<KeyboardKey>> _keys = <Point<int>, List<KeyboardKey>>{
    Point<int>(19, 0): <KeyboardKey>[mute],
    Point<int>(0, 1): <KeyboardKey>[esc],
    Point<int>(2, 1): <KeyboardKey>[f1],
    Point<int>(3, 1): <KeyboardKey>[f2],
    Point<int>(4, 1): <KeyboardKey>[f3],
    Point<int>(5, 1): <KeyboardKey>[f4],
    Point<int>(6, 1): <KeyboardKey>[f5],
    Point<int>(7, 1): <KeyboardKey>[f6],
    Point<int>(8, 1): <KeyboardKey>[f7],
    Point<int>(9, 1): <KeyboardKey>[f8],
    Point<int>(11, 1): <KeyboardKey>[f9],
    Point<int>(12, 1): <KeyboardKey>[f10],
    Point<int>(13, 1): <KeyboardKey>[f11],
    Point<int>(14, 1): <KeyboardKey>[f12],
    Point<int>(15, 1): <KeyboardKey>[printScreen],
    Point<int>(16, 1): <KeyboardKey>[scrollLock],
    Point<int>(17, 1): <KeyboardKey>[pauseBreak],
    Point<int>(18, 1): <KeyboardKey>[pause],
    Point<int>(19, 1): <KeyboardKey>[previous],
    Point<int>(20, 1): <KeyboardKey>[resumeStop],
    Point<int>(21, 1): <KeyboardKey>[next],
    Point<int>(0, 2): <KeyboardKey>[backQuote],
    Point<int>(1, 2): <KeyboardKey>[key1],
    Point<int>(2, 2): <KeyboardKey>[key2],
    Point<int>(3, 2): <KeyboardKey>[key3],
    Point<int>(4, 2): <KeyboardKey>[key4],
    Point<int>(5, 2): <KeyboardKey>[key5],
    Point<int>(6, 2): <KeyboardKey>[key6],
    Point<int>(7, 2): <KeyboardKey>[key7],
    Point<int>(8, 2): <KeyboardKey>[key8],
    Point<int>(9, 2): <KeyboardKey>[key9],
    Point<int>(10, 2): <KeyboardKey>[key0],
    Point<int>(11, 2): <KeyboardKey>[minus],
    Point<int>(12, 2): <KeyboardKey>[equal],
    Point<int>(14, 2): <KeyboardKey>[backSpace],
    Point<int>(15, 2): <KeyboardKey>[insert],
    Point<int>(16, 2): <KeyboardKey>[home],
    Point<int>(17, 2): <KeyboardKey>[pageUp],
    Point<int>(18, 2): <KeyboardKey>[numLock],
    Point<int>(19, 2): <KeyboardKey>[divide],
    Point<int>(20, 2): <KeyboardKey>[multiply],
    Point<int>(21, 2): <KeyboardKey>[subtract],
    Point<int>(0, 3): <KeyboardKey>[tab],
    Point<int>(1, 3): <KeyboardKey>[q],
    Point<int>(2, 3): <KeyboardKey>[w],
    Point<int>(3, 3): <KeyboardKey>[e],
    Point<int>(4, 3): <KeyboardKey>[r],
    Point<int>(5, 3): <KeyboardKey>[t],
    Point<int>(6, 3): <KeyboardKey>[y],
    Point<int>(7, 3): <KeyboardKey>[u],
    Point<int>(8, 3): <KeyboardKey>[i],
    Point<int>(9, 3): <KeyboardKey>[o],
    Point<int>(10, 3): <KeyboardKey>[p],
    Point<int>(11, 3): <KeyboardKey>[openBracket],
    Point<int>(12, 3): <KeyboardKey>[closeBracket],
    Point<int>(13, 3): <KeyboardKey>[enter],
    Point<int>(14, 3): <KeyboardKey>[emptyKey],
    Point<int>(15, 3): <KeyboardKey>[delete],
    Point<int>(16, 3): <KeyboardKey>[end],
    Point<int>(17, 3): <KeyboardKey>[pageDown],
    Point<int>(18, 3): <KeyboardKey>[num7],
    Point<int>(19, 3): <KeyboardKey>[num8],
    Point<int>(20, 3): <KeyboardKey>[num9],
    Point<int>(21, 3): <KeyboardKey>[add],
    Point<int>(0, 4): <KeyboardKey>[capsLock],
    Point<int>(1, 4): <KeyboardKey>[a],
    Point<int>(2, 4): <KeyboardKey>[s],
    Point<int>(3, 4): <KeyboardKey>[d],
    Point<int>(4, 4): <KeyboardKey>[f],
    Point<int>(5, 4): <KeyboardKey>[g],
    Point<int>(6, 4): <KeyboardKey>[h],
    Point<int>(7, 4): <KeyboardKey>[j],
    Point<int>(8, 4): <KeyboardKey>[k],
    Point<int>(9, 4): <KeyboardKey>[l],
    Point<int>(10, 4): <KeyboardKey>[semicolon],
    Point<int>(11, 4): <KeyboardKey>[quote],
    Point<int>(12, 4): <KeyboardKey>[backSlash],
    Point<int>(18, 4): <KeyboardKey>[num4],
    Point<int>(19, 4): <KeyboardKey>[num5],
    Point<int>(20, 4): <KeyboardKey>[num6],
    Point<int>(0, 5): <KeyboardKey>[leftShift],
    Point<int>(1, 5): <KeyboardKey>[leftBackSlash],
    Point<int>(2, 5): <KeyboardKey>[z],
    Point<int>(3, 5): <KeyboardKey>[x],
    Point<int>(4, 5): <KeyboardKey>[c],
    Point<int>(5, 5): <KeyboardKey>[v],
    Point<int>(6, 5): <KeyboardKey>[b],
    Point<int>(7, 5): <KeyboardKey>[n],
    Point<int>(8, 5): <KeyboardKey>[m],
    Point<int>(9, 5): <KeyboardKey>[comma],
    Point<int>(10, 5): <KeyboardKey>[period],
    Point<int>(11, 5): <KeyboardKey>[slash],
    Point<int>(13, 5): <KeyboardKey>[rightShift],
    Point<int>(16, 5): <KeyboardKey>[upArrow],
    Point<int>(18, 5): <KeyboardKey>[num1],
    Point<int>(19, 5): <KeyboardKey>[num2],
    Point<int>(20, 5): <KeyboardKey>[num3],
    Point<int>(21, 5): <KeyboardKey>[rightEnter],
    Point<int>(0, 6): <KeyboardKey>[leftControl],
    Point<int>(1, 6): <KeyboardKey>[leftWin],
    Point<int>(2, 6): <KeyboardKey>[leftAlt],
    Point<int>(6, 6): <KeyboardKey>[space],
    Point<int>(10, 6): <KeyboardKey>[rightAlt],
    Point<int>(11, 6): <KeyboardKey>[rightWin],
    Point<int>(12, 6): <KeyboardKey>[contextMenu],
    Point<int>(14, 6): <KeyboardKey>[rightControl],
    Point<int>(15, 6): <KeyboardKey>[leftArrow],
    Point<int>(16, 6): <KeyboardKey>[downArrow],
    Point<int>(17, 6): <KeyboardKey>[rightArrow],
    Point<int>(18, 6): <KeyboardKey>[num0],
    Point<int>(20, 6): <KeyboardKey>[decimal],
  };

  static final Map<String, Map<Point<int>, List<KeyboardKey>>> keys = <String, Map<Point<int>, List<KeyboardKey>>>{
    DeviceProductVendor.corsairK70Lux: _mergeKeysWith(_keys, <(Point<int>, KeyboardKey)>[
      (Point<int>(15, 0), lightningKey),
      (Point<int>(16, 0), lock),
    ]),
    DeviceProductVendor.corsairK70MKIILowProfile: _mergeKeysWith(_keys, <(Point<int>, KeyboardKey)>[
      (Point<int>(3, 0), profile),
      (Point<int>(4, 0), lightningKey),
      (Point<int>(5, 0), lock),
      (Point<int>(9, 0), led(0, 62)),
      (Point<int>(10, 0), led(0, 63)),
    ]),
    DeviceProductVendor.corsairK95Platinum: _mergeKeysWith(_keys, <(Point<int>, KeyboardKey)>[
      (Point<int>(3, 0), profile),
      (Point<int>(4, 0), lightningKey),
      (Point<int>(5, 0), lock),
      (Point<int>(0, 0), led(2, 28)),
      (Point<int>(1, 0), led(2, 29)),
      (Point<int>(2, 0), led(2, 30)),
      (Point<int>(3, 0), led(2, 42)),
      (Point<int>(4, 0), led(2, 44)),
      (Point<int>(5, 0), led(2, 31)),
      (Point<int>(6, 0), led(2, 32)),
      (Point<int>(7, 0), led(2, 33)),
      (Point<int>(9, 0), led(2, 34)),
      (Point<int>(11, 0), led(2, 35)),
      (Point<int>(13, 0), led(2, 36)),
      (Point<int>(14, 0), led(2, 37)),
      (Point<int>(15, 0), led(2, 38)),
      (Point<int>(16, 0), led(2, 39)),
      (Point<int>(17, 0), led(2, 40)),
      (Point<int>(18, 0), led(2, 43)),
      (Point<int>(19, 0), led(2, 45)),
      (Point<int>(20, 0), led(2, 46)),
      (Point<int>(0, 1), g1),
      (Point<int>(0, 2), g2),
      (Point<int>(0, 3), g3),
      (Point<int>(0, 4), g4),
      (Point<int>(0, 5), g5),
      (Point<int>(0, 6), g6),
    ]),
  };

  static Map<Point<int>, List<KeyboardKey>> _mergeKeysWith(
    Map<Point<int>, List<KeyboardKey>> base,
    List<(Point<int>, KeyboardKey)> additionalKeyPairs,
  ) {
    final Map<Point<int>, List<KeyboardKey>> merged = <Point<int>, List<KeyboardKey>>{
      for (final MapEntry<Point<int>, List<KeyboardKey>> entry in base.entries)
        entry.key: List<KeyboardKey>.from(entry.value),
    };

    for (final (Point<int> position, KeyboardKey key) in additionalKeyPairs) {
      merged.putIfAbsent(position, () => <KeyboardKey>[]);
      merged[position]!.add(key);
    }

    return merged;
  }

  static Map<KeyCode, Point<int>> reverseKeyCodes(String device) {
    if (_reverseKeyCodes.isEmpty) {
      _initReverseKeyCodes();
    }

    return _reverseKeyCodes[device] ?? <KeyCode, Point<int>>{};
  }

  static Map<String, Map<KeyCode, Point<int>>> _reverseKeyCodes = <String, Map<KeyCode, Point<int>>>{};

  static void _initReverseKeyCodes() {
    _reverseKeyCodes = <String, Map<KeyCode, Point<int>>>{
      for (final MapEntry<String, Map<Point<int>, List<KeyboardKey>>> deviceEntry in keys.entries)
        deviceEntry.key: <KeyCode, Point<int>>{
          for (final MapEntry<Point<int>, List<KeyboardKey>> pointEntry in deviceEntry.value.entries)
            for (final KeyboardKey keyboardKey in pointEntry.value) keyboardKey.keyCode: pointEntry.key,
        },
    };
  }
}
