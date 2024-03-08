import 'dart:math';

import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';

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
  static KeyboardKey num7 = KeyboardKey.withRandomKey(
    packetIndex: 0,
    index: 13,
    keyCode: KeyCode.numpad_7,
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
  static KeyboardKey corsairStar = KeyboardKey.withRandomKey(
    packetIndex: 2,
    index: 21,
    keyCode: KeyCode.corsairStar,
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

  static KeyboardKey get emptyKey => KeyboardKey.withRandomKey(
        packetIndex: -1,
        index: -1,
        keyCode: KeyCode.unknown,
      );

  static Map<Point<int>, KeyboardKey> keys = <Point<int>, KeyboardKey>{
    Point<int>(0, 0): emptyKey,
    Point<int>(1, 0): emptyKey,
    Point<int>(2, 0): emptyKey,
    Point<int>(3, 0): emptyKey,
    Point<int>(4, 0): emptyKey,
    Point<int>(5, 0): emptyKey,
    Point<int>(6, 0): emptyKey,
    Point<int>(7, 0): emptyKey,
    Point<int>(8, 0): emptyKey,
    Point<int>(9, 0): emptyKey,
    Point<int>(10, 0): emptyKey,
    Point<int>(11, 0): emptyKey,
    Point<int>(12, 0): emptyKey,
    Point<int>(13, 0): emptyKey,
    Point<int>(14, 0): emptyKey,
    Point<int>(15, 0): corsairStar,
    Point<int>(16, 0): emptyKey,
    Point<int>(17, 0): emptyKey,
    Point<int>(18, 0): emptyKey,
    Point<int>(19, 0): mute,
    Point<int>(20, 0): emptyKey,
    Point<int>(21, 0): emptyKey,
    Point<int>(0, 1): esc,
    Point<int>(1, 1): emptyKey,
    Point<int>(2, 1): f1,
    Point<int>(3, 1): f2,
    Point<int>(4, 1): f3,
    Point<int>(5, 1): f4,
    Point<int>(6, 1): f5,
    Point<int>(7, 1): f6,
    Point<int>(8, 1): f7,
    Point<int>(9, 1): f8,
    Point<int>(10, 1): emptyKey,
    Point<int>(11, 1): f9,
    Point<int>(12, 1): f10,
    Point<int>(13, 1): f11,
    Point<int>(14, 1): f12,
    Point<int>(15, 1): printScreen,
    Point<int>(16, 1): scrollLock,
    Point<int>(17, 1): pauseBreak,
    Point<int>(18, 1): pause,
    Point<int>(19, 1): previous,
    Point<int>(20, 1): resumeStop,
    Point<int>(21, 1): next,
    Point<int>(0, 2): backQuote,
    Point<int>(1, 2): key1,
    Point<int>(2, 2): key2,
    Point<int>(3, 2): key3,
    Point<int>(4, 2): key4,
    Point<int>(5, 2): key5,
    Point<int>(6, 2): key6,
    Point<int>(7, 2): key7,
    Point<int>(8, 2): key8,
    Point<int>(9, 2): key9,
    Point<int>(10, 2): key0,
    Point<int>(11, 2): minus,
    Point<int>(12, 2): equal,
    Point<int>(13, 2): emptyKey,
    Point<int>(14, 2): backSpace,
    Point<int>(15, 2): insert,
    Point<int>(16, 2): home,
    Point<int>(17, 2): pageUp,
    Point<int>(18, 2): numLock,
    Point<int>(19, 2): divide,
    Point<int>(20, 2): multiply,
    Point<int>(21, 2): subtract,
    Point<int>(0, 3): tab,
    Point<int>(1, 3): q,
    Point<int>(2, 3): w,
    Point<int>(3, 3): e,
    Point<int>(4, 3): r,
    Point<int>(5, 3): t,
    Point<int>(6, 3): y,
    Point<int>(7, 3): u,
    Point<int>(8, 3): i,
    Point<int>(9, 3): o,
    Point<int>(10, 3): p,
    Point<int>(11, 3): openBracket,
    Point<int>(12, 3): closeBracket,
    Point<int>(13, 3): enter,
    Point<int>(14, 3): emptyKey,
    Point<int>(15, 3): delete,
    Point<int>(16, 3): end,
    Point<int>(17, 3): pageDown,
    Point<int>(18, 3): num7,
    Point<int>(19, 3): num8,
    Point<int>(20, 3): num9,
    Point<int>(21, 3): add,
    Point<int>(0, 4): capsLock,
    Point<int>(1, 4): a,
    Point<int>(2, 4): s,
    Point<int>(3, 4): d,
    Point<int>(4, 4): f,
    Point<int>(5, 4): g,
    Point<int>(6, 4): h,
    Point<int>(7, 4): j,
    Point<int>(8, 4): k,
    Point<int>(9, 4): l,
    Point<int>(10, 4): semicolon,
    Point<int>(11, 4): quote,
    Point<int>(12, 4): backSlash,
    Point<int>(13, 4): emptyKey,
    Point<int>(14, 4): emptyKey,
    Point<int>(15, 4): emptyKey,
    Point<int>(16, 4): emptyKey,
    Point<int>(17, 4): emptyKey,
    Point<int>(18, 4): num4,
    Point<int>(19, 4): num5,
    Point<int>(20, 4): num6,
    Point<int>(21, 4): emptyKey,
    Point<int>(0, 5): leftShift,
    Point<int>(1, 5): leftBackSlash,
    Point<int>(2, 5): z,
    Point<int>(3, 5): x,
    Point<int>(4, 5): c,
    Point<int>(5, 5): v,
    Point<int>(6, 5): b,
    Point<int>(7, 5): n,
    Point<int>(8, 5): m,
    Point<int>(9, 5): comma,
    Point<int>(10, 5): period,
    Point<int>(11, 5): slash,
    Point<int>(12, 5): emptyKey,
    Point<int>(13, 5): rightShift,
    Point<int>(14, 5): emptyKey,
    Point<int>(15, 5): emptyKey,
    Point<int>(16, 5): upArrow,
    Point<int>(17, 5): emptyKey,
    Point<int>(18, 5): num1,
    Point<int>(19, 5): num2,
    Point<int>(20, 5): num3,
    Point<int>(21, 5): rightEnter,
    Point<int>(0, 6): leftControl,
    Point<int>(1, 6): leftWin,
    Point<int>(2, 6): leftAlt,
    Point<int>(3, 6): emptyKey,
    Point<int>(4, 6): emptyKey,
    Point<int>(5, 6): emptyKey,
    Point<int>(6, 6): space,
    Point<int>(7, 6): emptyKey,
    Point<int>(8, 6): emptyKey,
    Point<int>(9, 6): emptyKey,
    Point<int>(10, 6): rightAlt,
    Point<int>(11, 6): rightWin,
    Point<int>(12, 6): contextMenu,
    Point<int>(13, 6): emptyKey,
    Point<int>(14, 6): rightControl,
    Point<int>(15, 6): leftArrow,
    Point<int>(16, 6): downArrow,
    Point<int>(17, 6): rightArrow,
    Point<int>(18, 6): num0,
    Point<int>(19, 6): emptyKey,
    Point<int>(20, 6): decimal,
    Point<int>(21, 6): emptyKey,
  };

  static Map<KeyCode, Point<int>> get reverseKeyCodes {
    if (_reverseKeyCodes.isEmpty) {
      _initReverseKeyCodes();
    }

    return _reverseKeyCodes;
  }

  static Map<KeyCode, Point<int>> _reverseKeyCodes = <KeyCode, Point<int>>{};

  static void _initReverseKeyCodes() {
    _reverseKeyCodes = Map<KeyCode, Point<int>>.fromEntries(
      keys.entries.map(
        (MapEntry<Point<int>, KeyboardKey> entry) => MapEntry<KeyCode, Point<int>>(
          entry.value.keyCode,
          entry.key,
        ),
      ),
    );
  }
}
