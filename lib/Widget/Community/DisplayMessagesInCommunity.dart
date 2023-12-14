import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nex_social/AuthService/FireBaseAuthFunctions.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Model/CommunityPostModel.dart';
import 'package:nex_social/main.dart';
import 'package:provider/provider.dart';

class DisplayMessagesInCommunity extends StatefulWidget {
  final String nodeID;
  final String name;
  final String date;
  final String message;
  final String uid;
  final String communityNodeId;

  DisplayMessagesInCommunity({
    required this.communityNodeId,
    required this.nodeID,
    required this.name,
    required this.date,
    required this.uid,
    required this.message,
  });

  @override
  State<DisplayMessagesInCommunity> createState() =>
      _DisplayMessagesInCommunityState();
}

class _DisplayMessagesInCommunityState
    extends State<DisplayMessagesInCommunity> {
  final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
  final currentUsername = FirebaseAuth.instance.currentUser!.displayName;
  bool _sameDateTime = false;
  bool _notSameDateTime = false;

  void checkTime() {
    final currentDate = DateFormat('dd MMM yy').format(DateTime.now());
    final postDate =
        DateFormat('dd MMM yy').format(DateTime.parse(widget.date));

    bool _timeValue = Provider.of<CommunityPostFunction>(context, listen: false)
        .checkTime(DateFormat('dd MMM yy').format(DateTime.parse(widget.date)));
    if (_timeValue) {
      if (currentDate == postDate) {
        setState(() {
          _sameDateTime = true;
        });
      } else {
        setState(() {
          _notSameDateTime = true;
        });
      }
    }
  }

  Future<void> deletePost() async {
    try {
      await Provider.of<CommunityPostFunction>(context, listen: false)
          .deletePost(widget.communityNodeId, widget.nodeID);
      setState(() {});
    } on FirebaseException catch (error) {
      Provider.of<AuthFunction>(navigatorkey.currentContext!, listen: false)
          .showError('Delete Error', error.code);
    }
  }

  @override
  void initState() {
    checkTime();
    super.initState();
  }

  bool copyOption = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
            visible: _sameDateTime,
            child: Chip(
              backgroundColor: Colors.blue.shade400,
              label: Text(
                'Today',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )),
        Visibility(
          visible: _notSameDateTime,
          child: Chip(
            backgroundColor: Colors.blue.shade400,
            label: Text(
              DateFormat('dd MMM yy').format(
                DateTime.parse(widget.date),
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        Container(
          margin: currentUserUid == widget.uid
              ? const EdgeInsets.only(left: 100, bottom: 10)
              : const EdgeInsets.only(right: 100, bottom: 10),
          padding: currentUserUid == widget.uid
              ? const EdgeInsets.only(right: 8.0)
              : const EdgeInsets.only(left: 8.0),
          child: Dismissible(
            key: ValueKey(widget.nodeID),
            direction: currentUserUid == widget.uid
                ? DismissDirection.endToStart
                : DismissDirection.none,
            onDismissed: currentUserUid == widget.uid
                ? (direction) {
                    setState(() {
                      checkTime();
                    });
                    Provider.of<CommunityPostFunction>(context, listen: false)
                        .deletePost(widget.communityNodeId, widget.nodeID)
                        .then((value) {});
                  }
                : null,
            confirmDismiss: currentUserUid == widget.uid
                ? (direction) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          title: Text(
                            "Are You Sure?",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          content: const Text(
                            "Are you sure you want to delete this Post?",
                            style: TextStyle(
                              fontSize: 17.5,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(
                                "No",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                "Yes",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                : null,
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 4.3),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              alignment: Alignment.centerRight,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                setState(
                  () {
                    copyOption = false;
                  },
                );
              },
              onLongPress: () {
                setState(
                  () {
                    copyOption = true;
                  },
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: currentUserUid == widget.uid
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                    topRight: currentUserUid == widget.uid
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentUserUid == widget.uid
                                  ? 'You'
                                  : widget.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            copyOption
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        copyOption = false;
                                      });
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: widget.message,
                                        ),
                                      );
                                      Provider.of<CommunityFunctionClass>(
                                              navigatorkey.currentContext!,
                                              listen: false)
                                          .showSnackBar('Copied to Clipboard');
                                    },
                                    icon: const Icon(
                                      Icons.copy,
                                      size: 20,
                                      color: Colors.blue,
                                    ),
                                  )
                                : Text(
                                    DateFormat('hh:mm a').format(
                                      DateTime.parse(widget.date),
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.message,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
