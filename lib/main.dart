// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:for_her_by_her/Signup/Signup.dart';
import 'package:for_her_by_her/aboutus.dart';
import 'package:for_her_by_her/addPeriod.dart';
import 'package:for_her_by_her/feedback.dart';
import 'package:for_her_by_her/community.dart';
import 'package:for_her_by_her/healthtips.dart';
import 'package:for_her_by_her/logs.dart';
import 'package:for_her_by_her/myCart.dart';
import 'package:for_her_by_her/phone.dart';
import 'package:for_her_by_her/shopPage.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Login/Login.dart';

FirebaseFirestore fsi = FirebaseFirestore.instance;

const magenta = const Color(0x8e3a59);
int _currentIndex = 1;
int _pageIndex = 1;

var startDates = [];
var endDates = [];
Map<String, dynamic> map;
Map<String, dynamic> selectedDateValue;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    KhaltiScope(
      publicKey: 'test_public_key_3cec85624bc746f0b0b0a567d3d25c34',
      enabledDebugging: true,
      builder: (context, navKey) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Login(),
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate,
          ],
        );
      },
    ),
  );
}

class MyCycles extends StatefulWidget {
  _MyCycleState createState() => _MyCycleState();
}

class _MyCycleState extends State<MyCycles> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // final User user;
  CalendarController _controller;
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController _textFieldController = TextEditingController();
  final List<Widget> _children = [Community(), MyCycles(), AboutUs(), ShopPage()];
  bool _initialized = false;
  bool _error = false;
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  // ignore: non_constant_identifier_names
  _OnTap() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => _children[_currentIndex]));
  }

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    initializeFlutterFire();
    _getPeriodData();
  }

  _getPeriodData() async {
    FirebaseFirestore.instance
        .collection("periodinfo")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        map = result.data();
        selectedDateValue = map['Selected Date'];
        var temp1 = DateFormat('yyyy-MM-dd').parse(selectedDateValue['start']);
        startDates.add(temp1);
        var temp2 = DateFormat('yyyy-MM-dd').parse(selectedDateValue['end']);
        endDates.add(temp2);
        print(startDates);
        print(endDates);
      });
    });
  }

  _getStartDate() {
    if (startDates.length > 0) {
      print('here');
      print(startDates[0]);
      print(startDates);
      return startDates[0];
    } else {
      return null;
    }
  }

  _getEndDate() {
    if (startDates.length > 0) {
      return endDates[0];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            new SizedBox(
              height: 100.0,
              width: 80.0,
              child: new IconButton(
                  icon: Image.asset('assets/logo.png'), onPressed: () => {}),
            ),
          ],
          title: Text(
            "For Her, By Her",
            style: TextStyle(fontFamily: 'Allura', fontSize: 30),
          ),
          backgroundColor: Colors.pink[900],
          centerTitle: true,
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TableCalendar(
                  initialCalendarFormat: CalendarFormat.month,
                  weekendDays: [],
                  startDay: _getStartDate(),
                  endDay: _getEndDate(),
                  calendarStyle: CalendarStyle(
                      unavailableStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      weekendStyle: TextStyle(
                          color: Colors.pink[900],
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                      outsideStyle: TextStyle(color: Colors.pink[900]),
                      outsideWeekendStyle: TextStyle(color: Colors.pink[900]),
                      weekdayStyle: TextStyle(
                          color: Colors.pink[900],
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                      todayColor: Colors.pink[900],
                      // selectedColor: Theme.of(context).primaryColor,
                      todayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.white)),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    titleTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: 22.0,
                        fontFamily: 'Poppins'),
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.pink[900],
                      borderRadius: BorderRadius.circular(22.0),
                    ),
                    formatButtonTextStyle:
                        TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    formatButtonShowsNext: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (date, events, _) {
                    print(date.toUtc());
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            // color: Theme.of(context).primaryColor,
                            color: Colors.pink[900],
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(5.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.pink[900],
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        )),
                  ),
                  calendarController: _controller,
                ),
                Divider(),
                // Divider(),
                new Column(
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(
                            height: 50,
                            width: 300,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(100, 0, 40, 10),
                                child: Text("Add Period",
                                    style: TextStyle(
                                        fontSize: 28,
                                        color: Colors.pink[900],
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins')))),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 10),
                          child: SizedBox(
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddPeriod()),
                                );
                              },
                              backgroundColor: Colors.pink[900],
                              child: Icon(Icons.add, color: Colors.pink[100]),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        SizedBox(
                            height: 60,
                            width: 392,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink[900]),
                                    ),
                                    onPressed: () {
                                      _displayTextInputDialog(context,
                                          "Temperature", "temperature");
                                    },
                                    child: Text(
                                      "BODY TEMPERATURE",
                                      style: TextStyle(
                                          color: Colors.pink[200],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                      ),
                                    )))),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        SizedBox(
                            height: 60,
                            width: 392,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink[900]),
                                    ),
                                    onPressed: () {
                                      _displayTextInputDialog(
                                          context, "Mood", "mood");
                                    },
                                    child: Text(
                                      "MOOD",
                                      style: TextStyle(
                                          color: Colors.pink[200],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                    )))),
                      ],
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        SizedBox(
                            height: 60,
                            width: 392,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.pink[900]),
                                    ),
                                    onPressed: () {
                                      _displayTextInputDialog(
                                          context, "Weight", "weight");
                                    },
                                    child: Text(
                                      "WEIGHT",
                                      style: TextStyle(
                                          color: Colors.pink[200],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins'),
                                    )))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.pink[100],
            selectedItemColor: Colors.pink[900],
            unselectedItemColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.escalator_warning),
                  label: "Community"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "About Us"),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.shop), label: "Shop"),
            ],
            type: BottomNavigationBarType.shifting,
            currentIndex: _pageIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
              _OnTap();
            },
            elevation: 5),
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors
                  .pink[100], //This will change the drawer background to blue.
              //other styles
            ),
            child: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.fromLTRB(0, 2, 20, 2),
                    decoration: BoxDecoration(
                      color: Colors.pink[900],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            iconSize: 100,
                            padding: EdgeInsets.fromLTRB(0.1, 2, 2, 2),
                            icon: Image.asset('assets/logo.png'),
                            onPressed: () => {}),
                        Text(
                          "Explore",
                          style: TextStyle(
                              fontFamily: 'Allura',
                              fontSize: 40,
                              color: Colors.pink[50]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.add_box,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "Health Tips",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HealthTips()));
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.plumbing,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "Medicine",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      _displayTextInputDialog(context, "Medicine", "medicine");
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.chat_bubble_rounded,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "My Logs",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Logs()));
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.email,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "Feedback",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackForm()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.shopping_cart,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "My Cart",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyCart()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.shop,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "Shop",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopPage()),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    tileColor: Colors.pink[900],
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.pink[100],
                      size: 40,
                    ),
                    title: Text(
                      "Log Out",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.pink[100],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      logout(context);
                    },
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 40,
                      ),
                      title: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.right,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ))
                ],
              ),
            ))
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  String codeDialog;
  String valueText;
  _displayTextInputDialog(
      BuildContext context, String heading, String collection_name) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(heading),
            backgroundColor: Colors.pink[50],
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter your " + heading),
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.pink[900]),
                ),
                child: Text(
                  'CANCEL',
                  style:
                      TextStyle(color: Colors.pink[50], fontFamily: 'Poppins'),
                ),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.pink[900]),
                ),
                child: Text('SUBMIT',
                    style: TextStyle(
                        color: Colors.pink[50], fontFamily: 'Poppins')),
                onPressed: () {
                  DateTime now = new DateTime.now();
                  String dateValue = formatter.format(now);
                  FirebaseFirestore.instance.collection(collection_name).add({
                    "Value": valueText,
                    "Date": dateValue,
                  }).then((value) {
                    print(value.id);
                  }).catchError((error) => print("Failed to add data: $error"));
                  setState(() {
                    codeDialog = valueText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if(context != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } catch (e) {}
  }
}
