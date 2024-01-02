import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nex_social/main.dart';

class CommunityModel {
  final String adminName;
  final String communityName;
  final String communtiyDesp;
  final DateTime community_created_data;
  final String nodeId;
  final bool follow;
  final String adminUID;
  CommunityModel({
    this.follow = false,
    required this.adminName,
    required this.adminUID,
    required this.communityName,
    required this.communtiyDesp,
    required this.community_created_data,
    required this.nodeId,
  });
}

class CommunityFunctionClass with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.ref();
  bool follow = false;
  List<CommunityModel> _communityDataList = [];
  List<CommunityModel> get getCommunityList {
    return [..._communityDataList];
  }

  List<CommunityModel> _followedCommunityList = [];

  bool checkIfCommunityNameIsAvaiable(String communityname) {
    final isAvaiable = _communityDataList.where((community) =>
        community.communityName.toLowerCase() == communityname.toLowerCase());
    return isAvaiable.isEmpty ? true : false;
  }

  Future<void> allCommunityNodeList(String adminname, String communityname,
      String communitydesp, String userUID) async {
    try {
      final communityNodeList = databaseRef.child('CommunityList').push();
      final nodeKey = communityNodeList.key;
      communityNodeList.set(
        {
          'Admin name': adminname,
          'Community name': communityname,
          'Community desp': communitydesp,
          'Community Register Date': DateTime.now().toString(),
          'Community Node Id': nodeKey,
          'Admin UID': userUID,
        },
      );
      _communityDataList.add(
        CommunityModel(
          adminUID: userUID,
          adminName: adminname,
          communityName: communityname,
          communtiyDesp: communitydesp,
          community_created_data: DateTime.now(),
          nodeId: nodeKey!,
          follow: false,
        ),
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> setFollow(String community, String userUid, bool follow) async {
    try {
      databaseRef.child('Follow/$community/$userUid').set({
        'bool': follow,
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getFollow(String community, String userUid) async {
    try {
      databaseRef.child('Follow/$community/$userUid').onValue.listen((event) {
        if (event.snapshot.value != null) {
          final followStatus = event.snapshot.value as Map<dynamic, dynamic>;

          follow = followStatus['bool'] == null
              ? false
              : followStatus['bool'] == false
                  ? false
                  : true;
        } else {
          follow = false;
        }

        notifyListeners();
      });
    } catch (_) {
      rethrow;
    }
  }

  Future<void> getAllCommunityList() async {
    try {
      databaseRef.child('CommunityList').onValue.listen(
        (event) {
          final communityListData =
              event.snapshot.value as Map<dynamic, dynamic>;
          List<CommunityModel> loadedList = [];
          communityListData.forEach(
            (key, communityData) {
              loadedList.add(
                CommunityModel(
                  adminName: communityData['Admin name'],
                  adminUID: communityData['Admin UID'],
                  communityName: communityData['Community name'],
                  communtiyDesp: communityData['Community desp'],
                  community_created_data:
                      DateTime.parse(communityData['Community Register Date']),
                  nodeId: key,
                ),
              );
            },
          );
          _communityDataList = loadedList;
          notifyListeners();
        },
      );
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<void> deleteCommunity(String communityName, String nodeID) async {
    try {
      await databaseRef.child('CommunityList').child(nodeID).remove();
      await databaseRef.child('CommunityPostData').child(nodeID).remove();
      await databaseRef.child('Follow').child(communityName).remove();
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  void showSnackBar(String textString) {
    ScaffoldMessenger.of(navigatorkey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          textString,
          style: Theme.of(navigatorkey.currentContext!).textTheme.titleSmall,
        ),
        duration: const Duration(seconds: 3),
        elevation: 0,
        padding: const EdgeInsets.all(17),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> storeDeviceToken(var token) async {
    final getnode = databaseRef.child('Devicetokens').push();
    final nodekey = getnode.key;
    try {
      await getnode.set({'token': token});
    } catch (e) {
      rethrow;
    }
  }

// when user follow a community it gets add to the follow community list
  Future<void> addToFollowCommunityList(
      CommunityModel followCommunity, String userID) async {
    final followCommunityListDB = databaseRef
        .child('followCommunityListDB')
        .child(userID)
        .child(followCommunity.communityName + userID);

    try {
      await followCommunityListDB.set({
        'Admin name': followCommunity.adminName,
        'Community name': followCommunity.communityName,
        'Community desp': followCommunity.communtiyDesp,
        'Community Follow Date': DateTime.now().toString(),
        'Community Node Id': followCommunity.nodeId,
        'Admin UID': followCommunity.adminUID,
      });
      _followedCommunityList.add(
        CommunityModel(
          adminName: followCommunity.adminName,
          adminUID: followCommunity.adminUID,
          communityName: followCommunity.communityName,
          communtiyDesp: followCommunity.communtiyDesp,
          community_created_data: followCommunity.community_created_data,
          nodeId: followCommunity.nodeId,
        ),
      );
    } catch (_) {
      rethrow;
    }
  }

  // fetching data using Firebase animated list

// when user unfollow a community it gets removed from the follow community list

  Future<void> removeFromFollowCommunityList(
      String _communityName, String userID) async {
    try {
      int index = _followedCommunityList
          .indexWhere((element) => element.communityName == _communityName);
      String cName = _followedCommunityList[index].communityName;

      _followedCommunityList.removeAt(index);
      await databaseRef
          .child('followCommunityListDB')
          .child(userID)
          .child(_communityName + userID)
          .remove();
    } catch (_) {
      rethrow;
    }
  }

  List<CommunityModel> get getfollowedCommunityList {
    print(_followedCommunityList);
    return [..._followedCommunityList];
  }
}
