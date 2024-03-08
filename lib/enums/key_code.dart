enum KeyCode {
  key0,
  key1,
  key2,
  key3,
  key4,
  key5,
  key6,
  key7,
  key8,
  key9,
  a,
  b,
  c,
  d,
  e,
  f,
  g,
  h,
  i,
  j,
  k,
  l,
  m,
  n,
  o,
  p,
  q,
  r,
  s,
  t,
  u,
  v,
  w,
  x,
  y,
  z,
  numpad_0,
  numpad_1,
  numpad_2,
  numpad_3,
  numpad_4,
  numpad_5,
  numpad_6,
  numpad_7,
  numpad_8,
  numpad_9,
  multiply,
  add,
  enter,
  subtract,
  decimal,
  divide,
  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  f10,
  f11,
  f12,
  f13,
  f14,
  f15,
  backSpace,
  tab,
  shift,
  control,
  capsLock,
  esc,
  spacebar,
  pageUp,
  pageDown,
  end,
  home,
  leftArrow,
  upArrow,
  rightArrow,
  downArrow,
  insert,
  delete,
  numLock,
  scrollLock,
  pauseBreak,
  semicolon,
  equal,
  minus,
  slash,
  backQuote,
  openBracket,
  backSlash,
  closeBracket,
  quote,
  comma,
  period,
  printScreen,
  volumeUp,
  volumeDown,
  leftShift,
  rightShift,
  leftControl,
  rightControl,
  leftAlt,
  rightAlt,
  leftWin,
  rightWin,
  contextMenu,
  pause,
  resumeStop,
  next,
  previous,
  leftBackSlash,
  mute,
  corsairStar,
  unknown,
}

extension KeyCodeExtension on KeyCode {
  int get keyCode => switch (this) {
        KeyCode.key0 => 48,
        KeyCode.key1 => 49,
        KeyCode.key2 => 50,
        KeyCode.key3 => 51,
        KeyCode.key4 => 52,
        KeyCode.key5 => 53,
        KeyCode.key6 => 54,
        KeyCode.key7 => 55,
        KeyCode.key8 => 56,
        KeyCode.key9 => 57,
        KeyCode.a => 65,
        KeyCode.b => 66,
        KeyCode.c => 67,
        KeyCode.d => 68,
        KeyCode.e => 69,
        KeyCode.f => 70,
        KeyCode.g => 71,
        KeyCode.h => 72,
        KeyCode.i => 73,
        KeyCode.j => 74,
        KeyCode.k => 75,
        KeyCode.l => 76,
        KeyCode.m => 77,
        KeyCode.n => 78,
        KeyCode.o => 79,
        KeyCode.p => 80,
        KeyCode.q => 81,
        KeyCode.r => 82,
        KeyCode.s => 83,
        KeyCode.t => 84,
        KeyCode.u => 85,
        KeyCode.v => 86,
        KeyCode.w => 87,
        KeyCode.x => 88,
        KeyCode.y => 89,
        KeyCode.z => 90,
        KeyCode.numpad_0 => 96,
        KeyCode.numpad_1 => 97,
        KeyCode.numpad_2 => 98,
        KeyCode.numpad_3 => 99,
        KeyCode.numpad_4 => 100,
        KeyCode.numpad_5 => 101,
        KeyCode.numpad_6 => 102,
        KeyCode.numpad_7 => 103,
        KeyCode.numpad_8 => 104,
        KeyCode.numpad_9 => 105,
        KeyCode.multiply => 106,
        KeyCode.add => 107,
        KeyCode.enter => 13,
        KeyCode.subtract => 109,
        KeyCode.decimal => 110,
        KeyCode.divide => 111,
        KeyCode.f1 => 112,
        KeyCode.f2 => 113,
        KeyCode.f3 => 114,
        KeyCode.f4 => 115,
        KeyCode.f5 => 116,
        KeyCode.f6 => 117,
        KeyCode.f7 => 118,
        KeyCode.f8 => 119,
        KeyCode.f9 => 120,
        KeyCode.f10 => 121,
        KeyCode.f11 => 122,
        KeyCode.f12 => 123,
        KeyCode.f13 => 124,
        KeyCode.f14 => 125,
        KeyCode.f15 => 126,
        KeyCode.backSpace => 8,
        KeyCode.tab => 9,
        KeyCode.shift => 16,
        KeyCode.control => 17,
        KeyCode.capsLock => 20,
        KeyCode.esc => 27,
        KeyCode.spacebar => 32,
        KeyCode.pageUp => 33,
        KeyCode.pageDown => 34,
        KeyCode.end => 35,
        KeyCode.home => 36,
        KeyCode.leftArrow => 37,
        KeyCode.upArrow => 38,
        KeyCode.rightArrow => 39,
        KeyCode.downArrow => 40,
        KeyCode.insert => 45,
        KeyCode.delete => 46,
        KeyCode.numLock => 144,
        KeyCode.scrollLock => 145,
        KeyCode.pauseBreak => 19,
        KeyCode.semicolon => 186,
        KeyCode.equal => 187,
        KeyCode.minus => 189,
        KeyCode.slash => 191,
        KeyCode.backQuote => 192,
        KeyCode.openBracket => 219,
        KeyCode.backSlash => 220,
        KeyCode.closeBracket => 221,
        KeyCode.quote => 222,
        KeyCode.comma => 188,
        KeyCode.period => 190,
        KeyCode.printScreen => 44,
        KeyCode.volumeUp => 175,
        KeyCode.volumeDown => 174,
        KeyCode.leftShift => 160,
        KeyCode.rightShift => 161,
        KeyCode.leftControl => 162,
        KeyCode.rightControl => 163,
        KeyCode.leftAlt => 164,
        KeyCode.rightAlt => 165,
        KeyCode.leftWin => 91,
        KeyCode.rightWin => 92,
        KeyCode.contextMenu => 93,
        KeyCode.pause => 178,
        KeyCode.resumeStop => 179,
        KeyCode.next => 176,
        KeyCode.previous => 177,
        KeyCode.leftBackSlash => 226,
        KeyCode.mute => 173,
        KeyCode.corsairStar => -100,
        KeyCode.unknown => -1,
      };

  static KeyCode fromKeyCode(int keyCode) => switch (keyCode) {
        48 => KeyCode.key0,
        49 => KeyCode.key1,
        50 => KeyCode.key2,
        51 => KeyCode.key3,
        52 => KeyCode.key4,
        53 => KeyCode.key5,
        54 => KeyCode.key6,
        55 => KeyCode.key7,
        56 => KeyCode.key8,
        57 => KeyCode.key9,
        65 => KeyCode.a,
        66 => KeyCode.b,
        67 => KeyCode.c,
        68 => KeyCode.d,
        69 => KeyCode.e,
        70 => KeyCode.f,
        71 => KeyCode.g,
        72 => KeyCode.h,
        73 => KeyCode.i,
        74 => KeyCode.j,
        75 => KeyCode.k,
        76 => KeyCode.l,
        77 => KeyCode.m,
        78 => KeyCode.n,
        79 => KeyCode.o,
        80 => KeyCode.p,
        81 => KeyCode.q,
        82 => KeyCode.r,
        83 => KeyCode.s,
        84 => KeyCode.t,
        85 => KeyCode.u,
        86 => KeyCode.v,
        87 => KeyCode.w,
        88 => KeyCode.x,
        89 => KeyCode.y,
        90 => KeyCode.z,
        96 => KeyCode.numpad_0,
        97 => KeyCode.numpad_1,
        98 => KeyCode.numpad_2,
        99 => KeyCode.numpad_3,
        100 => KeyCode.numpad_4,
        101 => KeyCode.numpad_5,
        102 => KeyCode.numpad_6,
        103 => KeyCode.numpad_7,
        104 => KeyCode.numpad_8,
        105 => KeyCode.numpad_9,
        106 => KeyCode.multiply,
        107 => KeyCode.add,
        13 => KeyCode.enter,
        109 => KeyCode.subtract,
        110 => KeyCode.decimal,
        111 => KeyCode.divide,
        112 => KeyCode.f1,
        113 => KeyCode.f2,
        114 => KeyCode.f3,
        115 => KeyCode.f4,
        116 => KeyCode.f5,
        117 => KeyCode.f6,
        118 => KeyCode.f7,
        119 => KeyCode.f8,
        120 => KeyCode.f9,
        121 => KeyCode.f10,
        122 => KeyCode.f11,
        123 => KeyCode.f12,
        124 => KeyCode.f13,
        125 => KeyCode.f14,
        126 => KeyCode.f15,
        8 => KeyCode.backSpace,
        9 => KeyCode.tab,
        16 => KeyCode.shift,
        17 => KeyCode.control,
        20 => KeyCode.capsLock,
        27 => KeyCode.esc,
        32 => KeyCode.spacebar,
        33 => KeyCode.pageUp,
        34 => KeyCode.pageDown,
        35 => KeyCode.end,
        36 => KeyCode.home,
        37 => KeyCode.leftArrow,
        38 => KeyCode.upArrow,
        39 => KeyCode.rightArrow,
        40 => KeyCode.downArrow,
        45 => KeyCode.insert,
        46 => KeyCode.delete,
        144 => KeyCode.numLock,
        145 => KeyCode.scrollLock,
        19 => KeyCode.pauseBreak,
        186 => KeyCode.semicolon,
        187 => KeyCode.equal,
        189 => KeyCode.minus,
        191 => KeyCode.slash,
        192 => KeyCode.backQuote,
        219 => KeyCode.openBracket,
        220 => KeyCode.backSlash,
        221 => KeyCode.closeBracket,
        222 => KeyCode.quote,
        188 => KeyCode.comma,
        190 => KeyCode.period,
        44 => KeyCode.printScreen,
        175 => KeyCode.volumeUp,
        174 => KeyCode.volumeDown,
        160 => KeyCode.leftShift,
        161 => KeyCode.rightShift,
        162 => KeyCode.leftControl,
        163 => KeyCode.rightControl,
        164 => KeyCode.leftAlt,
        165 => KeyCode.rightAlt,
        91 => KeyCode.leftWin,
        92 => KeyCode.rightWin,
        93 => KeyCode.contextMenu,
        178 => KeyCode.pause,
        179 => KeyCode.resumeStop,
        176 => KeyCode.next,
        177 => KeyCode.previous,
        226 => KeyCode.leftBackSlash,
        173 => KeyCode.mute,
        -100 => KeyCode.corsairStar,
        _ => KeyCode.unknown,
      };

  static String name(int keyCode) => switch (keyCode) {
        65 => 'a',
        66 => 'b',
        67 => 'c',
        68 => 'd',
        69 => 'e',
        70 => 'f',
        71 => 'g',
        72 => 'h',
        73 => 'i',
        74 => 'j',
        75 => 'k',
        76 => 'l',
        77 => 'm',
        78 => 'n',
        79 => 'o',
        80 => 'p',
        81 => 'q',
        82 => 'r',
        83 => 's',
        84 => 't',
        85 => 'u',
        86 => 'v',
        87 => 'w',
        88 => 'x',
        89 => 'y',
        90 => 'z',
        48 => '0',
        49 => '1',
        50 => '2',
        51 => '3',
        52 => '4',
        53 => '5',
        54 => '6',
        55 => '7',
        56 => '8',
        57 => '9',
        96 => 'Num Pad 0',
        97 => 'Num Pad 1',
        98 => 'Num Pad 2',
        99 => 'Num Pad 3',
        100 => 'Num Pad 4',
        101 => 'Num Pad 5',
        102 => 'Num Pad 6',
        103 => 'Num Pad 7',
        104 => 'Num Pad 8',
        105 => 'Num Pad 9',
        106 => 'Multiply',
        107 => 'Add',
        109 => 'Subtract',
        110 => 'Decimal',
        111 => 'Divide',
        112 => 'F1',
        113 => 'F2',
        114 => 'F3',
        115 => 'F4',
        116 => 'F5',
        117 => 'F6',
        118 => 'F7',
        119 => 'F8',
        120 => 'F9',
        121 => 'F10',
        122 => 'F11',
        123 => 'F12',
        124 => 'F13',
        125 => 'F14',
        126 => 'F15',
        8 => 'Backspace',
        9 => 'Tab',
        13 => 'Enter',
        16 => 'Shift',
        17 => 'Control',
        20 => 'Caps Lock',
        27 => 'Esc',
        32 => 'Spacebar',
        33 => 'Page Up',
        34 => 'Page Down',
        35 => 'End',
        36 => 'Home',
        37 => 'Left Arrow',
        38 => 'Up Arrow',
        39 => 'Right Arrow',
        40 => 'Down Arrow',
        45 => 'Insert',
        46 => 'Delete',
        144 => 'Num Lock',
        145 => 'ScrLk',
        19 => 'Pause/Break',
        186 => 'Semicolon',
        187 => 'Equal',
        189 => 'Minus',
        191 => 'Slash',
        192 => 'Back Quote',
        219 => 'Open Bracket',
        220 => 'Back Slash',
        221 => 'Close Bracket',
        222 => 'Quote',
        188 => 'Comma',
        190 => 'Period',
        44 => 'PrintScreen',
        175 => 'Volume Up',
        174 => 'Volume Down',
        160 => 'Left Shift',
        161 => 'Right Shift',
        162 => 'Left Control',
        163 => 'Right Control',
        164 => 'Left Alt',
        165 => 'Right Alt',
        91 => 'Left Win',
        92 => 'Right Win',
        93 => 'ContextMenu',
        178 => 'Pause',
        179 => 'Resume/Stop',
        176 => 'Next',
        177 => 'Previous',
        226 => 'Left Back Slash',
        173 => 'Mute',
        -100 => 'Corsair Star',
        _ => 'Unknown',
      };
}
