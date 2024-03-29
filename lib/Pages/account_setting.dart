import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/Pages/member_list.dart';
import 'package:flutter_demo/Pages/payment_info.dart';
import 'package:flutter_demo/Pages/sign_in.dart';
import 'package:flutter_demo/Pages/sign_up.dart';
import 'package:flutter_demo/Pages/stripe_module.dart';
import 'package:flutter_demo/Pages/update_image.dart';
import 'package:flutter_demo/utils/Stripe.dart';
import 'package:flutter_demo/utils/blankProfile.dart';
import 'package:modals/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_demo/utils/token_preference.dart';
import 'package:flutter_demo/utils/user.dart';
import 'package:flutter/cupertino.dart';

class AccountSetting extends StatefulWidget {
  @override
  State<AccountSetting> createState() => _AccountSettingtate();
}

class _AccountSettingtate extends State<AccountSetting> {

  bool _isVisibleCurrent = false;
  bool _isVisibleNew = false;
  bool _isVisibleRecheck = false;

  void updateStatus() {
    setState(() {
      _isVisibleCurrent = !_isVisibleCurrent;
    });
  }

  void updateStatusNew() {
    setState(() {
      _isVisibleNew = !_isVisibleNew;
    });
  }

  void updateStatusRecheck() {
    setState(() {
      _isVisibleRecheck = !_isVisibleRecheck;
    });
  }

  Future<User> futureUser;
  Future<Stripe> futureStripe;
  File image;
  bool _isLoading = false;
  bool _isLoading2 = false;
  String name;
  String _email;
  var _image;
  String _purpose;
  String _public_key;
  String _private_key;
  String _id;
  String invitation_code;
  String short_invitation_code;
  bool apiload = true;

  int startIndex = 0;
  int endIndex = 4;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController publickeyController = TextEditingController();
  TextEditingController privatekeyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    allapiload();
  }

  allapiload() async {
    futureUser = await fetchUser();
    futureStripe = await fetchStripe();
    setState(() {
      apiload = false;
    });
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  accountSetting(
    String name,
    email,
    purpose,
    currentpassword,
    newpassword,
    confirmpassword,
  ) async {
    setState(() {
      _isLoading = true;
    });
    String token = await getToken();
    Map data = {
      'name': name,
      'email': email,
      'purpose': purpose,
      'old_password': currentpassword,
      'new_password': newpassword,
      'confirm_password': confirmpassword,
    };
    var jsonResponse = null;
    var response = await http.put(
        Uri.parse(
            "https://crowdfunderteam.com/api/profile/userInfo"),
        headers: {
          'Authorization': token,
          'Private-key':
              "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
        },
        body: jsonEncode(data));

    jsonResponse = json.decode(response.body);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      return jsonResponse;
    } else {
      return jsonResponse;
    }
  }

  fetchUser() async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(
          'https://crowdfunderteam.com/api/profile/userInfo'),
      headers: {
        'Authorization': token,
        'Private-key':
            "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      print("NAX");
      print(data);
      setState(() {
        _email = data["USER_DATA"][0]["email_address"];
      });
      setState(() {
        name = data["USER_DATA"][0]["name"];
      });

      setState(() {
        invitation_code = data["USER_DATA"][0]["invitation_code"];
        short_invitation_code = invitation_code.substring(startIndex, endIndex);
      });

      setState(() {
        // _purpose = data["USER_DATA"][0]["purpose"];
        _purpose = data["USER_DATA"][0]["purpose"];
      });

      setState(() {
        _id = data["USER_DATA"][0]["id"];
      });

      nameController.text = data["USER_DATA"][0]["name"];

      emailController.text = (_email == "") ? "Email Address" : _email;
      purposeController.text = (_purpose == "") ? "Purpose" : _purpose;
      var image1 = data["USER_DATA"][0]["profile_image"];

      if (image1 == null) {
        setState(() {
          _image = base64Decode(blank_image);
        });
      } else {
        setState(() {
          _image = base64Decode(image1);
        });
      }
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  fetchStripe() async {
    String token = await getToken();
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(
          "https://crowdfunderteam.com/api/profile/stripeInfo"),
      headers: {
        'Authorization': token,
        'Private-key':
            "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
      },
    );

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        _public_key = data["STRIPE_DATA"][0]["public_key"];
      });

      setState(() {
        _private_key = data["STRIPE_DATA"][0]["secret_key"];
      });
      publickeyController.text =
          (_public_key == "") ? "Public Key" : _public_key;
      privatekeyController.text =
          (_private_key == "") ? "Private Key" : _private_key;

      print(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception('Failed to load album');
    }
  }

  saveStripe(
    String public,
    String private,
  ) async {
    setState(() {
      _isLoading2 = true;
    });
    String token = await getToken();
    Map data = {
      'public_key': public,
      'secret_key': private,
    };
    var jsonResponse = null;
    var response = await http.put(
        Uri.parse(
            "https://crowdfunderteam.com/api/profile/stripeInfo"),
        headers: {
          'Authorization': token,
          'Private-key':
              "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
        },
        body: jsonEncode(data));
    jsonResponse = json.decode(response.body);

    setState(() {
      _isLoading2 = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _isLoading2 = true;
      });
      jsonResponse = json.decode(response.body);
      setState(() {
        _isLoading2 = false;
      });
      return jsonResponse;
    } else {
      setState(() {
        _isLoading2 = false;
      });
      return jsonResponse;
    }
  }

  /*Update Profile Postman API*/

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: nameController,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildPuropose() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: purposeController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                prefixIcon: Icon(
                  Icons.clean_hands_sharp,
                  color: Colors.black,
                ),
                hintText: 'Purpose for raising money',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildCurrentPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: currentpasswordController,
            obscureText: _isVisibleCurrent ? false : true,
            inputFormatters: [
               FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
            ],
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                suffixIcon: IconButton(  
                  onPressed: () => updateStatus(),
                  icon: Icon(
                    _isVisibleCurrent ? Icons.visibility : Icons.visibility_off
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Current password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildNewPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: newpasswordController,
            obscureText: _isVisibleNew ? false : true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                suffixIcon: IconButton(  
                  onPressed: () => updateStatusNew(),
                  icon: Icon(
                    _isVisibleNew ? Icons.visibility : Icons.visibility_off 
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'New password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: confirmpasswordController,
            obscureText: _isVisibleRecheck ? false : true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xff800080), width: 2.0),
                ),
                suffixIcon: IconButton(  
                  onPressed: () => updateStatusRecheck(),
                  icon: Icon(
                    _isVisibleRecheck ? Icons.visibility : Icons.visibility_off
                  ),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                hintText: 'Confirm password',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }

  Widget buildSaveChangesBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    accountSetting(
                      nameController.text,
                      emailController.text,
                      purposeController.text,
                      currentpasswordController.text,
                      newpasswordController.text,
                      confirmpasswordController.text,
                    ).then((res) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(res["message"]),
                        duration: Duration(milliseconds: 3000),
                      ));
                    });
                  },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(15),
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              primary: Color(0xff800080),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.rubik(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPublicKey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: publickeyController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 14),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff800080), width: 2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPrivateKey() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 48,
          child: TextFormField(
            controller: privatekeyController,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 14),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff800080), width: 2.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSetUpAccountbtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading2
            ? null
            : () {
                saveStripe(publickeyController.text, privatekeyController.text)
                    .then((res) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(res["message"]),
                    duration: Duration(milliseconds: 3000),
                  ));
                });
              },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          primary: Color(0xff800080),
        ),
        child: Text(
          'Set Up Account',
          style: GoogleFonts.rubik(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget buildBackBtn() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => StripeModuleX()),
              (_) => false,
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Icon(
            Icons.arrow_back,
            color: Color(0xff800080),
          )),
    );
  }

  Clipbooard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: invitation_code)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Copied to Clipbaord")));
    });
    ;
  }

  Widget buildUserProfile(BuildContext context) {
    return Container(
        child: Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: new BorderSide(color: Color(0xff800080), width: 1.0)),
      child: Row(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: (_image == null || _image == '')
                  ? CircularProgressIndicator()
                  : GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                              builder: (context) => UpdateImage()),
                          (_) => false,
                        );
                      },
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: MemoryImage(_image), //here
                      ),
                    )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (name == null) ? "Fetching value..." : '$name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Text(
                    (invitation_code == null)
                        ? "Fetching value..."
                        : 'Invitation code: $short_invitation_code' + ".....",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    onPressed: (() async {
                      Clipboard.setData(ClipboardData(text: invitation_code))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied to Clipbaord")));
                      });
                      ;
                    }),
                    child: const Icon(Icons.copy),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ));
  }

  Widget BuildDeleteAccountBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
          onPressed: () {
            showModal(ModalEntry.aligned(context,
                tag: 'Delete Account',
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey, spreadRadius: 1),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: new TextSpan(
                            text: "Delete Account",
                            style: GoogleFonts.roboto(
                                color: Colors.black, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        RichText(
                          text: new TextSpan(
                            text:
                                "Are you sure you want to delete your account ?",
                            style: GoogleFonts.roboto(
                                color: Colors.black87, fontSize: 12),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor: Color(0xff800080),
                              ),
                              onPressed: () async {
                                String token = await getToken();

                                var response = await http.delete(
                                  Uri.parse(
                                      'https://crowdfunderteam.com/api/profile/deleteAccount'),
                                  headers: {
                                    'Authorization': '$token',
                                    'Private-key':
                                        "0cf0761127a8ca5b42f04509d15989677937c9cf6a004e2019f41ab7a11815dc"
                                  },
                                );

                                Map<String, dynamic> data =
                                    jsonDecode(response.body);

                                print(data);

                                if (data["status"] == 0) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Failed to delete account. Please contact support."),
                                    duration: Duration(milliseconds: 3000),
                                  ));
                                } else {
                                  TokenPreference.saveAddress("token", "");
                                  TokenPreference.saveAddress(
                                      "remember_token", "");
                                  removeAllModals();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Account deleted succesffuly."),
                                    duration: Duration(milliseconds: 3000),
                                  ));
                                  Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                        builder: (context) => SignIn()),
                                    (_) => false,
                                  );
                                }
                              },
                              child: Text(
                                "Yes",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor: Color(0xff800080),
                              ),
                              onPressed: () => removeAllModals(),
                              child: Text(
                                "No",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
          },
          style: ElevatedButton.styleFrom(
            shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Color(0xff800080),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Delete Account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(children: [
                  buildBackBtn(),
                  buildUserProfile(context),
                  SizedBox(height: 20),
                  apiload
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            buildName(),
                            SizedBox(height: 20),
                            buildEmail(),
                            SizedBox(height: 20),
                            buildPuropose(),
                            SizedBox(height: 20),
                            buildCurrentPassword(),
                            SizedBox(height: 20),
                            buildNewPassword(),
                            SizedBox(height: 20),
                            buildConfirmPassword(),
                            buildSaveChangesBtn(),
                            SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Stripe Account Info',
                                  style: GoogleFonts.rubik(
                                    color: Color(0xff800080),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Input the public key \*',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 20),
                                buildPublicKey(),
                                SizedBox(height: 20),
                                Text(
                                  'Input the Private Key \*',
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 20),
                                buildPrivateKey(),
                                SizedBox(
                                  height: 20,
                                ),
                                buildSetUpAccountbtn(),
                                SizedBox(
                                  height: 20,
                                ),
                                BuildDeleteAccountBtn(context)
                              ],
                            )
                          ],
                        ),
                ]))));
  }
}
