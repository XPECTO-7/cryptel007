import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptel007/Pages/Navigation%20Pages/home_page.dart';
import 'package:cryptel007/Pages/Seperated%20Class/details_container.dart';
import 'package:cryptel007/Pages/Seperated%20Class/work_header.dart';
import 'package:cryptel007/Tools/colors.dart';
import 'package:cryptel007/Tools/custom_button.dart';
import 'package:cryptel007/Tools/user_role_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WorkDetailPage extends StatefulWidget {
  final String workOrderNumber;

  const WorkDetailPage({super.key, required this.workOrderNumber});

  @override
  _WorkDetailPageState createState() => _WorkDetailPageState();
}

class _WorkDetailPageState extends State<WorkDetailPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserRoleService _userRoleService = UserRoleService();
  GoogleSignInAccount? _currentUser;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        _isLoading = true;
      });
      _fetchUserRole(account?.email);
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _fetchUserRole(String? email) async {
    if (email == null) return;

    final role = await _userRoleService.fetchUserRole(email);

    if (mounted) {
      setState(() {
        _userRole = role;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Work Details',
          style: TextStyle(fontSize: 20 * textScaleFactor),
        ),
        leading: IconButton(
          icon: Image.asset('assets/arrow.png'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        actions: [
          if (_userRole == 'ADMIN' ||
              _userRole == 'Manager' ||
              _userRole == 'Editor')
            CustomButton(
              text: 'Edit',
              onPressed: () {
                // Handle edit action
              },
              h: 37,
              w: 37,
              buttonColor: Colors.white,
              textColor: AppColors.logoblue,
              suffixIcon: Icons.edit_square,
              iconColor: AppColors.logoblue,
            ),
          const SizedBox(width: 17),
          IconButton(
            icon: Image.asset('assets/bookmark.png'),
            onPressed: () {
              // Handle bookmark action
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('works')
                        .doc(widget.workOrderNumber)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return const Center(
                            child:
                                Text('No details found for this work order.'));
                      }

                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WorkHeader(
                            workTitle: data['WORKTITLE'],
                            workPhoto: data['PHOTO'],
                            cdate: data['CDATE'],
                            customerName: data['CUSTOMERNAME'],
                            screenWidth: screenWidth,
                            textScaleFactor: textScaleFactor,
                          ),
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.04),
                            child: DetailsContainer(
                              data: data,
                              screenWidth: screenWidth,
                              textScaleFactor: textScaleFactor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
