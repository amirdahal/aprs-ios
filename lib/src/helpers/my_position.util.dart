import 'dart:io';

final enablePositionSharing =
    !Platform.isWindows && !Platform.isLinux && !Platform.isFuchsia;
