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
  int get keyCode {
    switch (this) {
      case KeyCode.key0:
        return 48;
      case KeyCode.key1:
        return 49;
      case KeyCode.key2:
        return 50;
      case KeyCode.key3:
        return 51;
      case KeyCode.key4:
        return 52;
      case KeyCode.key5:
        return 53;
      case KeyCode.key6:
        return 54;
      case KeyCode.key7:
        return 55;
      case KeyCode.key8:
        return 56;
      case KeyCode.key9:
        return 57;
      case KeyCode.a:
        return 65;
      case KeyCode.b:
        return 66;
      case KeyCode.c:
        return 67;
      case KeyCode.d:
        return 68;
      case KeyCode.e:
        return 69;
      case KeyCode.f:
        return 70;
      case KeyCode.g:
        return 71;
      case KeyCode.h:
        return 72;
      case KeyCode.i:
        return 73;
      case KeyCode.j:
        return 74;
      case KeyCode.k:
        return 75;
      case KeyCode.l:
        return 76;
      case KeyCode.m:
        return 77;
      case KeyCode.n:
        return 78;
      case KeyCode.o:
        return 79;
      case KeyCode.p:
        return 80;
      case KeyCode.q:
        return 81;
      case KeyCode.r:
        return 82;
      case KeyCode.s:
        return 83;
      case KeyCode.t:
        return 84;
      case KeyCode.u:
        return 85;
      case KeyCode.v:
        return 86;
      case KeyCode.w:
        return 87;
      case KeyCode.x:
        return 88;
      case KeyCode.y:
        return 89;
      case KeyCode.z:
        return 90;
      case KeyCode.numpad_0:
        return 96;
      case KeyCode.numpad_1:
        return 97;
      case KeyCode.numpad_2:
        return 98;
      case KeyCode.numpad_3:
        return 99;
      case KeyCode.numpad_4:
        return 100;
      case KeyCode.numpad_5:
        return 101;
      case KeyCode.numpad_6:
        return 102;
      case KeyCode.numpad_7:
        return 103;
      case KeyCode.numpad_8:
        return 104;
      case KeyCode.numpad_9:
        return 105;
      case KeyCode.multiply:
        return 106;
      case KeyCode.add:
        return 107;
      case KeyCode.enter:
        return 13;
      case KeyCode.subtract:
        return 109;
      case KeyCode.decimal:
        return 110;
      case KeyCode.divide:
        return 111;
      case KeyCode.f1:
        return 112;
      case KeyCode.f2:
        return 113;
      case KeyCode.f3:
        return 114;
      case KeyCode.f4:
        return 115;
      case KeyCode.f5:
        return 116;
      case KeyCode.f6:
        return 117;
      case KeyCode.f7:
        return 118;
      case KeyCode.f8:
        return 119;
      case KeyCode.f9:
        return 120;
      case KeyCode.f10:
        return 121;
      case KeyCode.f11:
        return 122;
      case KeyCode.f12:
        return 123;
      case KeyCode.f13:
        return 124;
      case KeyCode.f14:
        return 125;
      case KeyCode.f15:
        return 126;
      case KeyCode.backSpace:
        return 8;
      case KeyCode.tab:
        return 9;
      case KeyCode.shift:
        return 16;
      case KeyCode.control:
        return 17;
      case KeyCode.capsLock:
        return 20;
      case KeyCode.esc:
        return 27;
      case KeyCode.spacebar:
        return 32;
      case KeyCode.pageUp:
        return 33;
      case KeyCode.pageDown:
        return 34;
      case KeyCode.end:
        return 35;
      case KeyCode.home:
        return 36;
      case KeyCode.leftArrow:
        return 37;
      case KeyCode.upArrow:
        return 38;
      case KeyCode.rightArrow:
        return 39;
      case KeyCode.downArrow:
        return 40;
      case KeyCode.insert:
        return 45;
      case KeyCode.delete:
        return 46;
      case KeyCode.numLock:
        return 144;
      case KeyCode.scrollLock:
        return 145;
      case KeyCode.pauseBreak:
        return 19;
      case KeyCode.semicolon:
        return 186;
      case KeyCode.equal:
        return 187;
      case KeyCode.minus:
        return 189;
      case KeyCode.slash:
        return 191;
      case KeyCode.backQuote:
        return 192;
      case KeyCode.openBracket:
        return 219;
      case KeyCode.backSlash:
        return 220;
      case KeyCode.closeBracket:
        return 221;
      case KeyCode.quote:
        return 222;
      case KeyCode.comma:
        return 188;
      case KeyCode.period:
        return 190;
      case KeyCode.printScreen:
        return 44;
      case KeyCode.volumeUp:
        return 175;
      case KeyCode.volumeDown:
        return 176;
      case KeyCode.leftShift:
        return 160;
      case KeyCode.rightShift:
        return 161;
      case KeyCode.leftControl:
        return 162;
      case KeyCode.rightControl:
        return 163;
      case KeyCode.leftAlt:
        return 164;
      case KeyCode.rightAlt:
        return 165;
      case KeyCode.leftWin:
        return 91;
      case KeyCode.rightWin:
        return 92;
      case KeyCode.contextMenu:
        return 93;
      case KeyCode.pause:
        return 178;
      case KeyCode.resumeStop:
        return 179;
      case KeyCode.next:
        return 176;
      case KeyCode.previous:
        return 177;
      case KeyCode.leftBackSlash:
        return 226;
      case KeyCode.mute:
        return 173;
      case KeyCode.corsairStar:
        return -100;
      default:
        return -1;
    }
  }

  static String name(int keyCode) {
    switch (keyCode) {
      case 65:
        return 'a';
      case 66:
        return 'b';
      case 67:
        return 'c';
      case 68:
        return 'd';
      case 69:
        return 'e';
      case 70:
        return 'f';
      case 71:
        return 'g';
      case 72:
        return 'h';
      case 73:
        return 'i';
      case 74:
        return 'j';
      case 75:
        return 'k';
      case 76:
        return 'l';
      case 77:
        return 'm';
      case 78:
        return 'n';
      case 79:
        return 'o';
      case 80:
        return 'p';
      case 81:
        return 'q';
      case 82:
        return 'r';
      case 83:
        return 's';
      case 84:
        return 't';
      case 85:
        return 'u';
      case 86:
        return 'v';
      case 87:
        return 'w';
      case 88:
        return 'x';
      case 89:
        return 'y';
      case 90:
        return 'z';
      case 48:
        return '0';
      case 49:
        return '1';
      case 50:
        return '2';
      case 51:
        return '3';
      case 52:
        return '4';
      case 53:
        return '5';
      case 54:
        return '6';
      case 55:
        return '7';
      case 56:
        return '8';
      case 57:
        return '9';
      case 96:
        return 'Num Pad 0';
      case 97:
        return 'Num Pad 1';
      case 98:
        return 'Num Pad 2';
      case 99:
        return 'Num Pad 3';
      case 100:
        return 'Num Pad 4';
      case 101:
        return 'Num Pad 5';
      case 102:
        return 'Num Pad 6';
      case 103:
        return 'Num Pad 7';
      case 104:
        return 'Num Pad 8';
      case 105:
        return 'Num Pad 9';
      case 106:
        return 'Multiply';
      case 107:
        return 'Add';
      case 109:
        return 'Subtract';
      case 110:
        return 'Decimal';
      case 111:
        return 'Divide';
      case 112:
        return 'F1';
      case 113:
        return 'F2';
      case 114:
        return 'F3';
      case 115:
        return 'F4';
      case 116:
        return 'F5';
      case 117:
        return 'F6';
      case 118:
        return 'F7';
      case 119:
        return 'F8';
      case 120:
        return 'F9';
      case 121:
        return 'F10';
      case 122:
        return 'F11';
      case 123:
        return 'F12';
      case 124:
        return 'F13';
      case 125:
        return 'F14';
      case 126:
        return 'F15';
      case 8:
        return 'Backspace';
      case 9:
        return 'Tab';
      case 13:
        return 'Enter';
      case 16:
        return 'Shift';
      case 17:
        return 'Control';
      case 20:
        return 'Caps Lock';
      case 27:
        return 'Esc';
      case 32:
        return 'Spacebar';
      case 33:
        return 'Page Up';
      case 34:
        return 'Page Down';
      case 35:
        return 'End';
      case 36:
        return 'Home';
      case 37:
        return 'Left Arrow';
      case 38:
        return 'Up Arrow';
      case 39:
        return 'Right Arrow';
      case 40:
        return 'Down Arrow';
      case 45:
        return 'Insert';
      case 46:
        return 'Delete';
      case 144:
        return 'Num Lock';
      case 145:
        return 'ScrLk';
      case 19:
        return 'Pause/Break';
      case 186:
        return 'Semicolon';
      case 187:
        return 'Equal';
      case 189:
        return 'Minus';
      case 191:
        return 'Slash';
      case 192:
        return 'Back Quote';
      case 219:
        return 'Open Bracket';
      case 220:
        return 'Back Slash';
      case 221:
        return 'Close Bracket';
      case 222:
        return 'Quote';
      case 188:
        return 'Comma';
      case 190:
        return 'Period';
      case 44:
        return 'PrintScreen';
      case 175:
        return 'Volume Up';
      case 174:
        return 'Volume Down';
      case 160:
        return 'Left Shift';
      case 161:
        return 'Right Shift';
      case 162:
        return 'Left Control';
      case 163:
        return 'Right Control';
      case 164:
        return 'Left Alt';
      case 165:
        return 'Right Alt';
      case 91:
        return 'Left Win';
      case 92:
        return 'Right Win';
      case 93:
        return 'ContextMenu';
      case 178:
        return 'Pause';
      case 179:
        return 'Resume/Stop';
      case 176:
        return 'Next';
      case 177:
        return 'Previous';
      case 226:
        return 'Left Back Slash';
      case 173:
        return 'Mute';
      case -100:
        return 'Corsair Star';
      default:
        return 'Unknown';
    }
  }
}
