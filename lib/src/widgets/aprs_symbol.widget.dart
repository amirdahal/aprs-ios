import 'package:flutter/material.dart';

class AprsSymbolIcon extends StatelessWidget {
  final String symbolTable; // '/' or '\\'
  final String symbol;
  final double size;

  const AprsSymbolIcon({
    super.key,
    required this.symbolTable,
    required this.symbol,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = _emojiMap['$symbolTable$symbol'] ?? '❓';

    return Text(
      emoji,
      style: TextStyle(fontSize: size),
    );
  }
}

const Map<String, String> _emojiMap = {
  // Primary table '/'
  '/>': '🚗', // Car
  '/<': '🏍️',
  '/A': '✈️',
  '/B': '🎈',
  '/C': '🛡️',
  '/D': '📡',
  '/E': '👁️',
  '/F': '📶',
  '/G': '⛳',
  '/H': '🏠',
  '/I': 'ℹ️',
  '/J': '🚙',
  '/K': '🪁',
  '/L': '💻',
  '/M': '📱',
  '/N': '🛰️',
  '/O': '🎯',
  '/P': '🚓',
  '/Q': '❔',
  '/R': '📻',
  '/S': '🛰️',
  '/T': '🚆',
  '/U': '❔',
  '/V': '🌋',
  '/W': '🌤️',
  '/X': '❌',
  '/Y': '🛥️',
  '/Z': '🧭',
  '/0': '📦',
  '/1': '📡',
  '/2': '🚒',
  '/3': '⛽',
  '/4': '🏫',
  '/5': '🏎️',
  '/6': '🚙',
  '/7': '🚛',
  '/8': '⛵',
  '/9': '🚘',
  '/-': '🏠',
  '/.': '🚶',
  '/!': '🚨',
  '/@': '🕒',
  '/=': '📟',
  '/?': '❓',
  '/+': '➕',
  '/*': '⭐',
  '/#': '🔁',
  '/\$': '📍',
  '/(': '🚆',
  '/)': '📞',

  // Secondary table '\'
  r'\>': '🚓', // Different from primary
  r'\<': '🏍️',
  r'\A': '🛫',
  r'\B': '🍺',
  r'\C': '📷',
  r'\D': '🖥️',
  r'\E': '👥',
  r'\F': '🪵',
  r'\G': '🏌️',
  r'\H': '🏡',
  r'\I': 'ℹ️',
  r'\J': '🚙',
  r'\K': '🪁',
  r'\L': '💻',
  r'\M': '📶',
  r'\N': '🌐',
  r'\O': '🔌',
  r'\P': '👮',
  r'\Q': '❓',
  r'\R': '🔁',
  r'\S': '📡',
  r'\T': '🚆',
  r'\U': '🧩',
  r'\V': '🔥',
  r'\W': '☀️',
  r'\X': '❌',
  r'\Y': '⛴️',
  r'\Z': '🔍',
  r'\0': '📦',
  r'\1': '📍',
  r'\2': '🚉',
  r'\3': '🛏️',
  r'\4': '🏫',
  r'\5': '🏎️',
  r'\6': '🚚',
  r'\7': '🛳️',
  r'\8': '🚘',
  r'\9': '🏁',
  r'\-': '🏡',
  r'\.': '🚶',
  r'\!': '⚡',
  r'\@': '🕔',
  r'\=': '📶',
  r'\?': '❓',
  r'\+': '➕',
  r'\*': '🌟',
  r'\#': '📡',
  r'\$': '🌊',
  r'\(': '💺',
  r'\)': '👨‍💼',
};
