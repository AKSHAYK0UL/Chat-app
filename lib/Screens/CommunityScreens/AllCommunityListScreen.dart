import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:nex_social/Model/CommunityModelandFUN.dart';
import 'package:nex_social/Screens/CommunityScreens/CreateCommunity.dart';
import 'package:nex_social/Screens/CommunityScreens/OpenCommunityScreens.dart';
import 'package:nex_social/Widget/drawerForUserInfo.dart';
import 'package:provider/provider.dart';

class AllCommunityListScreen extends StatefulWidget {
  static const routeName = 'AllCommunityListScreen';
  const AllCommunityListScreen({super.key});

  @override
  State<AllCommunityListScreen> createState() => _AllCommunityListScreenState();
}

class _AllCommunityListScreenState extends State<AllCommunityListScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _istrue = true;
  @override
  void didChangeDependencies() {
    if (_istrue) {
      Provider.of<CommunityFunctionClass>(context, listen: true)
          .getAllCommunityList();
    }
    _istrue = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final communityList =
        Provider.of<CommunityFunctionClass>(context, listen: false)
            .getCommunityList;

    final ref = FirebaseDatabase.instance.ref('CommunityList');

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Communities'),
        // actions: [
        //   TextButton(
        //     onPressed: () async {
        //       Provider.of<CommunityFunctionClass>(context, listen: false)
        //           .storeDeviceToken('1111');
        //     },
        //     child: Chip(
        //       backgroundColor: Colors.white,
        //       label: Text(
        //         'Following',
        //         style: Theme.of(context).textTheme.bodySmall,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      drawer: drawerForUserInfo(),
      body: communityList.isEmpty
          ? SizedBox(
              height: double.infinity,
              child: Lottie.asset('assets/loading.json', fit: BoxFit.fill),
            )
          : Container(
              height: 500,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                //query: ref,
                itemCount: communityList.length,
                itemBuilder: (context, index) {
                  final communityListdata = communityList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        OpenCommunityScreens.routeName,
                        arguments: {
                          'NodeIdForPOST': (
                            communityListdata.communityName
                                .toString()
                                .trim()
                                .toLowerCase(),
                          ),
                          'Community name':
                              communityListdata.communityName.toString(),
                          'admin name': communityListdata.adminName,
                          'admin uid': communityListdata.adminUID,
                          'commmunity desp': communityListdata.communtiyDesp,
                          'Register Date': communityListdata
                              .community_created_data
                              .toString(),
                          'Community Node Id':
                              communityListdata.nodeId.toString(),
                        },
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Center(
                            child: Text(
                                communityListdata.communityName.toString()[0])),
                      ),
                      title: Text(communityListdata.communityName.toString()),
                      subtitle:
                          Text(communityListdata.communtiyDesp.toString()),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
