import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CommunityPostModel {
  final String senderName;
  final String senderEmail;
  final String senderUID;
  final String nodeId;
  final String postMessage;
  final DateTime postTime;
  CommunityPostModel({
    required this.senderName,
    required this.senderEmail,
    required this.senderUID,
    required this.postMessage,
    required this.nodeId,
    required this.postTime,
  });
}

class CommunityPostFunction with ChangeNotifier {
  bool _sameTime = false;
  String savedTime = '';
  final databaseRef = FirebaseDatabase.instance.ref();
  List<CommunityPostModel> _post = [];
  List<CommunityPostModel> get getAllPost {
    return [..._post];
  }

  void clearall() {
    _post.clear();
  }

  bool checkTime(String time) {
    if (savedTime != time) {
      savedTime = time;
      return _sameTime = true;
    } else {
      return _sameTime = false;
    }
  }

  void cleanTimevalue() {
    savedTime = '';
    notifyListeners();
  }

  Future<void> onAddPost(String senderName, String senderEmail,
      String senderUID, String postMessage, String? communityNodeId) async {
    final postNode =
        databaseRef.child('CommunityPostData').child(communityNodeId!).push();
    final postNodeKey = postNode.key;
    try {
      await postNode.set(
        {
          'senderName': senderName,
          'senderEmail': senderEmail,
          'senderUID': senderUID,
          'postMessage': postMessage,
          'time': DateTime.now().toString(),
          'postNodeKey': postNodeKey,
        },
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  Future<void> deletePost(String communityNodeId, String nodeId) async {
    try {
      databaseRef
          .child('CommunityPostData')
          .child(communityNodeId)
          .child(nodeId)
          .remove();
    } catch (_) {
      rethrow;
    }
  }

//Fetch
  Future<void> getdata(String communityNodeId) async {
    databaseRef
        .child('CommunityPostData/$communityNodeId')
        .orderByValue()
        .onValue
        .listen(
      (postData) {
        final List<CommunityPostModel> fetchedPostList = [];
        final fetchPostData = postData.snapshot.value as Map<dynamic, dynamic>;
        fetchPostData.forEach(
          (key, postData) {
            fetchedPostList.add(
              CommunityPostModel(
                senderName: postData['senderName'],
                senderEmail: postData['senderEmail'],
                senderUID: postData['senderUID'],
                postMessage: postData['postMessage'],
                nodeId: key,
                postTime: DateTime.parse(
                  postData['time'],
                ),
              ),
            );
          },
        );
        fetchedPostList.sort(
          (a, b) {
            return a.postTime.compareTo(b.postTime);
          },
        );

        _post = fetchedPostList;

        notifyListeners();
      },
    );
  }

  //Message encryption method
  String encryption(String text) {
    String encryptedTEXT = '';
    for (var i = 0; i < text.length; i++) {
      if (text[i] == 'A') {
        encryptedTEXT = "${encryptedTEXT}L";
      } else if (text[i] == 'a') {
        encryptedTEXT = "${encryptedTEXT}l";
      } else if (text[i] == 'B') {
        encryptedTEXT = "${encryptedTEXT}T";
      } else if (text[i] == 'b') {
        encryptedTEXT = "${encryptedTEXT}t";
      } else if (text[i] == 'C') {
        encryptedTEXT = "${encryptedTEXT}X";
      } else if (text[i] == 'c') {
        encryptedTEXT = "${encryptedTEXT}x";
      } else if (text[i] == 'D') {
        encryptedTEXT = "${encryptedTEXT}Z";
      } else if (text[i] == 'd') {
        encryptedTEXT = "${encryptedTEXT}z";
      } else if (text[i] == 'E') {
        encryptedTEXT = "${encryptedTEXT}O";
      } else if (text[i] == 'e') {
        encryptedTEXT = "${encryptedTEXT}o";
      } else if (text[i] == 'F') {
        encryptedTEXT = "${encryptedTEXT}S";
      } else if (text[i] == 'f') {
        encryptedTEXT = "${encryptedTEXT}s";
      } else if (text[i] == 'G') {
        encryptedTEXT = "${encryptedTEXT}U";
      } else if (text[i] == 'g') {
        encryptedTEXT = "${encryptedTEXT}u";
      } else if (text[i] == 'H') {
        encryptedTEXT = "${encryptedTEXT}R";
      } else if (text[i] == 'h') {
        encryptedTEXT = "${encryptedTEXT}r";
      } else if (text[i] == 'I') {
        encryptedTEXT = "${encryptedTEXT}W";
      } else if (text[i] == 'i') {
        encryptedTEXT = "${encryptedTEXT}w";
      } else if (text[i] == 'J') {
        encryptedTEXT = "${encryptedTEXT}Q";
      } else if (text[i] == 'j') {
        encryptedTEXT = "${encryptedTEXT}q";
      } else if (text[i] == 'K') {
        encryptedTEXT = "${encryptedTEXT}V";
      } else if (text[i] == 'k') {
        encryptedTEXT = "${encryptedTEXT}v";
      } else if (text[i] == 'M') {
        encryptedTEXT = "${encryptedTEXT}P";
      } else if (text[i] == 'm') {
        encryptedTEXT = "${encryptedTEXT}p";
      } else if (text[i] == 'N') {
        encryptedTEXT = "${encryptedTEXT}Y";
      } else if (text[i] == 'n') {
        encryptedTEXT = "${encryptedTEXT}y";
      } else if (text[i] == ' ') {
        encryptedTEXT = "$encryptedTEXT ";
      } else if (text[i] == 'L') {
        encryptedTEXT = "${encryptedTEXT}A";
      } else if (text[i] == 'l') {
        encryptedTEXT = "${encryptedTEXT}a";
      } else if (text[i] == 'T') {
        encryptedTEXT = "${encryptedTEXT}B";
      } else if (text[i] == 't') {
        encryptedTEXT = "${encryptedTEXT}b";
      } else if (text[i] == 'X') {
        encryptedTEXT = "${encryptedTEXT}C";
      } else if (text[i] == 'x') {
        encryptedTEXT = "${encryptedTEXT}c";
      } else if (text[i] == 'Z') {
        encryptedTEXT = "${encryptedTEXT}D";
      } else if (text[i] == 'z') {
        encryptedTEXT = "${encryptedTEXT}d";
      } else if (text[i] == 'O') {
        encryptedTEXT = "${encryptedTEXT}E";
      } else if (text[i] == 'o') {
        encryptedTEXT = "${encryptedTEXT}e";
      } else if (text[i] == 'S') {
        encryptedTEXT = "${encryptedTEXT}F";
      } else if (text[i] == 's') {
        encryptedTEXT = "${encryptedTEXT}f";
      } else if (text[i] == 'U') {
        encryptedTEXT = "${encryptedTEXT}G";
      } else if (text[i] == 'u') {
        encryptedTEXT = "${encryptedTEXT}g";
      } else if (text[i] == 'R') {
        encryptedTEXT = "${encryptedTEXT}H";
      } else if (text[i] == 'r') {
        encryptedTEXT = "${encryptedTEXT}h";
      } else if (text[i] == 'W') {
        encryptedTEXT = "${encryptedTEXT}I";
      } else if (text[i] == 'w') {
        encryptedTEXT = "${encryptedTEXT}i";
      } else if (text[i] == 'Q') {
        encryptedTEXT = "${encryptedTEXT}J";
      } else if (text[i] == 'q') {
        encryptedTEXT = "${encryptedTEXT}j";
      } else if (text[i] == 'V') {
        encryptedTEXT = "${encryptedTEXT}K";
      } else if (text[i] == 'v') {
        encryptedTEXT = "${encryptedTEXT}k";
      } else if (text[i] == 'P') {
        encryptedTEXT = "${encryptedTEXT}M";
      } else if (text[i] == 'p') {
        encryptedTEXT = "${encryptedTEXT}m";
      } else if (text[i] == 'Y') {
        encryptedTEXT = "${encryptedTEXT}N";
      } else if (text[i] == 'y') {
        encryptedTEXT = "${encryptedTEXT}n";
      } else {
        encryptedTEXT = encryptedTEXT + text[i];
      }
    }
    return encryptedTEXT;
  }
  //Message decryption

  String decryption(String text) {
    String decryptedTEXT = '';
    for (var i = 0; i < text.length; i++) {
      if (text[i] == 'L') {
        decryptedTEXT = "${decryptedTEXT}A";
      } else if (text[i] == 'l') {
        decryptedTEXT = '${decryptedTEXT}a';
      } else if (text[i] == 'T') {
        decryptedTEXT = '${decryptedTEXT}B';
      } else if (text[i] == 't') {
        decryptedTEXT = '${decryptedTEXT}b';
      } else if (text[i] == 'X') {
        decryptedTEXT = '${decryptedTEXT}C';
      } else if (text[i] == 'x') {
        decryptedTEXT = '${decryptedTEXT}c';
      } else if (text[i] == 'Z') {
        decryptedTEXT = '${decryptedTEXT}D';
      } else if (text[i] == 'z') {
        decryptedTEXT = '${decryptedTEXT}d';
      } else if (text[i] == 'O') {
        decryptedTEXT = '${decryptedTEXT}E';
      } else if (text[i] == 'o') {
        decryptedTEXT = '${decryptedTEXT}e';
      } else if (text[i] == 'S') {
        decryptedTEXT = '${decryptedTEXT}F';
      } else if (text[i] == 's') {
        decryptedTEXT = '${decryptedTEXT}f';
      } else if (text[i] == 'U') {
        decryptedTEXT = '${decryptedTEXT}G';
      } else if (text[i] == 'u') {
        decryptedTEXT = '${decryptedTEXT}g';
      } else if (text[i] == 'R') {
        decryptedTEXT = '${decryptedTEXT}H';
      } else if (text[i] == 'r') {
        decryptedTEXT = '${decryptedTEXT}h';
      } else if (text[i] == 'W') {
        decryptedTEXT = '${decryptedTEXT}I';
      } else if (text[i] == 'w') {
        decryptedTEXT = '${decryptedTEXT}i';
      } else if (text[i] == 'Q') {
        decryptedTEXT = '${decryptedTEXT}J';
      } else if (text[i] == 'q') {
        decryptedTEXT = '${decryptedTEXT}j';
      } else if (text[i] == 'V') {
        decryptedTEXT = '${decryptedTEXT}K';
      } else if (text[i] == 'v') {
        decryptedTEXT = '${decryptedTEXT}k';
      } else if (text[i] == 'P') {
        decryptedTEXT = '${decryptedTEXT}M';
      } else if (text[i] == 'p') {
        decryptedTEXT = '${decryptedTEXT}m';
      } else if (text[i] == 'Y') {
        decryptedTEXT = '${decryptedTEXT}N';
      } else if (text[i] == 'y') {
        decryptedTEXT = '${decryptedTEXT}n';
      } else if (text[i] == ' ') {
        decryptedTEXT = "$decryptedTEXT ";
      } else if (text[i] == 'A') {
        decryptedTEXT = "${decryptedTEXT}L";
      } else if (text[i] == 'a') {
        decryptedTEXT = '${decryptedTEXT}l';
      } else if (text[i] == 'B') {
        decryptedTEXT = '${decryptedTEXT}T';
      } else if (text[i] == 'b') {
        decryptedTEXT = '${decryptedTEXT}t';
      } else if (text[i] == 'C') {
        decryptedTEXT = '${decryptedTEXT}X';
      } else if (text[i] == 'c') {
        decryptedTEXT = '${decryptedTEXT}x';
      } else if (text[i] == 'D') {
        decryptedTEXT = '${decryptedTEXT}Z';
      } else if (text[i] == 'd') {
        decryptedTEXT = '${decryptedTEXT}z';
      } else if (text[i] == 'E') {
        decryptedTEXT = '${decryptedTEXT}O';
      } else if (text[i] == 'e') {
        decryptedTEXT = '${decryptedTEXT}o';
      } else if (text[i] == 'F') {
        decryptedTEXT = '${decryptedTEXT}S';
      } else if (text[i] == 'f') {
        decryptedTEXT = '${decryptedTEXT}s';
      } else if (text[i] == 'G') {
        decryptedTEXT = '${decryptedTEXT}U';
      } else if (text[i] == 'g') {
        decryptedTEXT = '${decryptedTEXT}u';
      } else if (text[i] == 'H') {
        decryptedTEXT = '${decryptedTEXT}R';
      } else if (text[i] == 'h') {
        decryptedTEXT = '${decryptedTEXT}r';
      } else if (text[i] == 'I') {
        decryptedTEXT = '${decryptedTEXT}W';
      } else if (text[i] == 'i') {
        decryptedTEXT = '${decryptedTEXT}w';
      } else if (text[i] == 'J') {
        decryptedTEXT = '${decryptedTEXT}Q';
      } else if (text[i] == 'j') {
        decryptedTEXT = '${decryptedTEXT}q';
      } else if (text[i] == 'K') {
        decryptedTEXT = '${decryptedTEXT}V';
      } else if (text[i] == 'k') {
        decryptedTEXT = '${decryptedTEXT}v';
      } else if (text[i] == 'M') {
        decryptedTEXT = '${decryptedTEXT}P';
      } else if (text[i] == 'm') {
        decryptedTEXT = '${decryptedTEXT}p';
      } else if (text[i] == 'N') {
        decryptedTEXT = '${decryptedTEXT}Y';
      } else if (text[i] == 'n') {
        decryptedTEXT = '${decryptedTEXT}y';
      } else {
        decryptedTEXT = decryptedTEXT + text[i];
      }
    }
    return decryptedTEXT;
  }
}
