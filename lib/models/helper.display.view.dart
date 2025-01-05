import 'package:flutter/material.dart';

class HelperDisplayView {
    CrossAxisAlignment columAlinment;
    MainAxisAlignment rowAlinment;
    Color bgMessage;
    bool isMe;
    String avatarPath;
    double avatarSize;

HelperDisplayView({ required this.avatarPath, required this.avatarSize, required this.bgMessage, required this.columAlinment, required this.isMe, required this.rowAlinment });
}