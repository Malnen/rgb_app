import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:vector_math/vector_math.dart';

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

  static final Map<Vector3, List<KeyboardKey>> _keys = <Vector3, List<KeyboardKey>>{
    Vector3(19, 0, 0): <KeyboardKey>[mute],
    Vector3(0, 0, 1): <KeyboardKey>[esc],
    Vector3(2, 0, 1): <KeyboardKey>[f1],
    Vector3(3, 0, 1): <KeyboardKey>[f2],
    Vector3(4, 0, 1): <KeyboardKey>[f3],
    Vector3(5, 0, 1): <KeyboardKey>[f4],
    Vector3(6, 0, 1): <KeyboardKey>[f5],
    Vector3(7, 0, 1): <KeyboardKey>[f6],
    Vector3(8, 0, 1): <KeyboardKey>[f7],
    Vector3(9, 0, 1): <KeyboardKey>[f8],
    Vector3(11, 0, 1): <KeyboardKey>[f9],
    Vector3(12, 0, 1): <KeyboardKey>[f10],
    Vector3(13, 0, 1): <KeyboardKey>[f11],
    Vector3(14, 0, 1): <KeyboardKey>[f12],
    Vector3(15, 0, 1): <KeyboardKey>[printScreen],
    Vector3(16, 0, 1): <KeyboardKey>[scrollLock],
    Vector3(17, 0, 1): <KeyboardKey>[pauseBreak],
    Vector3(18, 0, 1): <KeyboardKey>[pause],
    Vector3(19, 0, 1): <KeyboardKey>[previous],
    Vector3(20, 0, 1): <KeyboardKey>[resumeStop],
    Vector3(21, 0, 1): <KeyboardKey>[next],
    Vector3(0, 0, 2): <KeyboardKey>[backQuote],
    Vector3(1, 0, 2): <KeyboardKey>[key1],
    Vector3(2, 0, 2): <KeyboardKey>[key2],
    Vector3(3, 0, 2): <KeyboardKey>[key3],
    Vector3(4, 0, 2): <KeyboardKey>[key4],
    Vector3(5, 0, 2): <KeyboardKey>[key5],
    Vector3(6, 0, 2): <KeyboardKey>[key6],
    Vector3(7, 0, 2): <KeyboardKey>[key7],
    Vector3(8, 0, 2): <KeyboardKey>[key8],
    Vector3(9, 0, 2): <KeyboardKey>[key9],
    Vector3(10, 0, 2): <KeyboardKey>[key0],
    Vector3(11, 0, 2): <KeyboardKey>[minus],
    Vector3(12, 0, 2): <KeyboardKey>[equal],
    Vector3(14, 0, 2): <KeyboardKey>[backSpace],
    Vector3(15, 0, 2): <KeyboardKey>[insert],
    Vector3(16, 0, 2): <KeyboardKey>[home],
    Vector3(17, 0, 2): <KeyboardKey>[pageUp],
    Vector3(18, 0, 2): <KeyboardKey>[numLock],
    Vector3(19, 0, 2): <KeyboardKey>[divide],
    Vector3(20, 0, 2): <KeyboardKey>[multiply],
    Vector3(21, 0, 2): <KeyboardKey>[subtract],
    Vector3(0, 0, 3): <KeyboardKey>[tab],
    Vector3(1, 0, 3): <KeyboardKey>[q],
    Vector3(2, 0, 3): <KeyboardKey>[w],
    Vector3(3, 0, 3): <KeyboardKey>[e],
    Vector3(4, 0, 3): <KeyboardKey>[r],
    Vector3(5, 0, 3): <KeyboardKey>[t],
    Vector3(6, 0, 3): <KeyboardKey>[y],
    Vector3(7, 0, 3): <KeyboardKey>[u],
    Vector3(8, 0, 3): <KeyboardKey>[i],
    Vector3(9, 0, 3): <KeyboardKey>[o],
    Vector3(10, 0, 3): <KeyboardKey>[p],
    Vector3(11, 0, 3): <KeyboardKey>[openBracket],
    Vector3(12, 0, 3): <KeyboardKey>[closeBracket],
    Vector3(13, 0, 3): <KeyboardKey>[enter],
    Vector3(14, 0, 3): <KeyboardKey>[emptyKey],
    Vector3(15, 0, 3): <KeyboardKey>[delete],
    Vector3(16, 0, 3): <KeyboardKey>[end],
    Vector3(17, 0, 3): <KeyboardKey>[pageDown],
    Vector3(18, 0, 3): <KeyboardKey>[num7],
    Vector3(19, 0, 3): <KeyboardKey>[num8],
    Vector3(20, 0, 3): <KeyboardKey>[num9],
    Vector3(21, 0, 3): <KeyboardKey>[add],
    Vector3(0, 0, 4): <KeyboardKey>[capsLock],
    Vector3(1, 0, 4): <KeyboardKey>[a],
    Vector3(2, 0, 4): <KeyboardKey>[s],
    Vector3(3, 0, 4): <KeyboardKey>[d],
    Vector3(4, 0, 4): <KeyboardKey>[f],
    Vector3(5, 0, 4): <KeyboardKey>[g],
    Vector3(6, 0, 4): <KeyboardKey>[h],
    Vector3(7, 0, 4): <KeyboardKey>[j],
    Vector3(8, 0, 4): <KeyboardKey>[k],
    Vector3(9, 0, 4): <KeyboardKey>[l],
    Vector3(10, 0, 4): <KeyboardKey>[semicolon],
    Vector3(11, 0, 4): <KeyboardKey>[quote],
    Vector3(12, 0, 4): <KeyboardKey>[backSlash],
    Vector3(18, 0, 4): <KeyboardKey>[num4],
    Vector3(19, 0, 4): <KeyboardKey>[num5],
    Vector3(20, 0, 4): <KeyboardKey>[num6],
    Vector3(0, 0, 5): <KeyboardKey>[leftShift],
    Vector3(1, 0, 5): <KeyboardKey>[leftBackSlash],
    Vector3(2, 0, 5): <KeyboardKey>[z],
    Vector3(3, 0, 5): <KeyboardKey>[x],
    Vector3(4, 0, 5): <KeyboardKey>[c],
    Vector3(5, 0, 5): <KeyboardKey>[v],
    Vector3(6, 0, 5): <KeyboardKey>[b],
    Vector3(7, 0, 5): <KeyboardKey>[n],
    Vector3(8, 0, 5): <KeyboardKey>[m],
    Vector3(9, 0, 5): <KeyboardKey>[comma],
    Vector3(10, 0, 5): <KeyboardKey>[period],
    Vector3(11, 0, 5): <KeyboardKey>[slash],
    Vector3(13, 0, 5): <KeyboardKey>[rightShift],
    Vector3(16, 0, 5): <KeyboardKey>[upArrow],
    Vector3(18, 0, 5): <KeyboardKey>[num1],
    Vector3(19, 0, 5): <KeyboardKey>[num2],
    Vector3(20, 0, 5): <KeyboardKey>[num3],
    Vector3(21, 0, 5): <KeyboardKey>[rightEnter],
    Vector3(0, 0, 6): <KeyboardKey>[leftControl],
    Vector3(1, 0, 6): <KeyboardKey>[leftWin],
    Vector3(2, 0, 6): <KeyboardKey>[leftAlt],
    Vector3(6, 0, 6): <KeyboardKey>[space],
    Vector3(10, 0, 6): <KeyboardKey>[rightAlt],
    Vector3(11, 0, 6): <KeyboardKey>[rightWin],
    Vector3(12, 0, 6): <KeyboardKey>[contextMenu],
    Vector3(14, 0, 6): <KeyboardKey>[rightControl],
    Vector3(15, 0, 6): <KeyboardKey>[leftArrow],
    Vector3(16, 0, 6): <KeyboardKey>[downArrow],
    Vector3(17, 0, 6): <KeyboardKey>[rightArrow],
    Vector3(18, 0, 6): <KeyboardKey>[num0],
    Vector3(20, 0, 6): <KeyboardKey>[decimal],
  };

  static final Map<String, Map<Vector3, List<KeyboardKey>>> keys = <String, Map<Vector3, List<KeyboardKey>>>{
    DeviceProductVendor.corsairK70Lux: _mergeKeysWith(_keys, <(Vector3, KeyboardKey)>[
      (Vector3(15, 0, 0), lightningKey),
      (Vector3(16, 0, 0), lock),
    ]),
    DeviceProductVendor.corsairK70MKIILowProfile: _mergeKeysWith(_keys, <(Vector3, KeyboardKey)>[
      (Vector3(3, 0, 0), profile),
      (Vector3(4, 0, 0), lightningKey),
      (Vector3(5, 0, 0), lock),
      (Vector3(9, 0, 0), led(0, 62)),
      (Vector3(10, 0, 0), led(0, 63)),
    ]),
    DeviceProductVendor.corsairK95Platinum: _mergeKeysWith(_keys, <(Vector3, KeyboardKey)>[
      (Vector3(3, 0, 0), profile),
      (Vector3(4, 0, 0), lightningKey),
      (Vector3(5, 0, 0), lock),
      (Vector3(0, 0, 0), led(2, 28)),
      (Vector3(1, 0, 0), led(2, 29)),
      (Vector3(2, 0, 0), led(2, 30)),
      (Vector3(3, 0, 0), led(2, 42)),
      (Vector3(4, 0, 0), led(2, 44)),
      (Vector3(5, 0, 0), led(2, 31)),
      (Vector3(6, 0, 0), led(2, 32)),
      (Vector3(7, 0, 0), led(2, 33)),
      (Vector3(9, 0, 0), led(2, 34)),
      (Vector3(11, 0, 0), led(2, 35)),
      (Vector3(13, 0, 0), led(2, 36)),
      (Vector3(14, 0, 0), led(2, 37)),
      (Vector3(15, 0, 0), led(2, 38)),
      (Vector3(16, 0, 0), led(2, 39)),
      (Vector3(17, 0, 0), led(2, 40)),
      (Vector3(18, 0, 0), led(2, 43)),
      (Vector3(19, 0, 0), led(2, 45)),
      (Vector3(20, 0, 0), led(2, 46)),
      (Vector3(0, 0, 1), g1),
      (Vector3(0, 0, 2), g2),
      (Vector3(0, 0, 3), g3),
      (Vector3(0, 0, 4), g4),
      (Vector3(0, 0, 5), g5),
      (Vector3(0, 0, 6), g6),
    ]),
  };

  static Map<Vector3, List<KeyboardKey>> _mergeKeysWith(
    Map<Vector3, List<KeyboardKey>> base,
    List<(Vector3, KeyboardKey)> additionalKeyPairs,
  ) {
    final Map<Vector3, List<KeyboardKey>> merged = <Vector3, List<KeyboardKey>>{
      for (final MapEntry<Vector3, List<KeyboardKey>> entry in base.entries)
        entry.key: List<KeyboardKey>.from(entry.value),
    };

    for (final (Vector3 position, KeyboardKey key) in additionalKeyPairs) {
      merged.putIfAbsent(position, () => <KeyboardKey>[]);
      merged[position]!.add(key);
    }

    return merged;
  }

  static Map<KeyCode, Vector3> reverseKeyCodes(String device) {
    if (_reverseKeyCodes.isEmpty) {
      _initReverseKeyCodes();
    }

    return _reverseKeyCodes[device] ?? <KeyCode, Vector3>{};
  }

  static Map<String, Map<KeyCode, Vector3>> _reverseKeyCodes = <String, Map<KeyCode, Vector3>>{};

  static void _initReverseKeyCodes() {
    _reverseKeyCodes = <String, Map<KeyCode, Vector3>>{
      for (final MapEntry<String, Map<Vector3, List<KeyboardKey>>> deviceEntry in keys.entries)
        deviceEntry.key: <KeyCode, Vector3>{
          for (final MapEntry<Vector3, List<KeyboardKey>> pointEntry in deviceEntry.value.entries)
            for (final KeyboardKey keyboardKey in pointEntry.value) keyboardKey.keyCode: pointEntry.key,
        },
    };
  }
}
