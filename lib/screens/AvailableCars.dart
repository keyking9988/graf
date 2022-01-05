// @dart=2.9
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie_animation/components/rounded_button.dart';
import 'package:lottie_animation/models/Constants.dart';
import 'package:lottie_animation/services/Payment_Services.dart';
import 'package:pay/pay.dart';
import 'CarBlock.dart';
import 'package:lottie_animation/models/Car.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: SearchResultsScreen()));
}

class SearchResultsScreen extends StatefulWidget {
  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {

  @override
  void initState() {
    super.initState();
  }
  final _paymentItems = <PaymentItem>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF90ADC6),
        title: Align(
          alignment: Alignment.center,
          child: Text('Available Cars'),
        )
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Cars').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView.builder(
                  padding: new EdgeInsets.all(8.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot info = snapshot.data.docs[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(children: <Widget>[
                        ListTile(
                          title: Text( info['Name']+' Car', style: kHeadingStyle),
                          subtitle: Text(
                            info['Model']+" "+info['Color'],
                            style: TextStyle(
                              color: greyColor,
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image(
                              image: NetworkImage(info['Image']),
                              width: 100.0,
                              height: 250.0,
                            ),
                          ),
                        ),

                        // CachedNetworkImage(
                        //   imageUrl: info['Image'],
                        //   placeholder: (context, url) => CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) => Icon(Icons.error),
                        // ),
                        Row(
                          //Divider line
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                                child: Divider(color: greyColor),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        info['Price'].toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 22.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    Container(
                                      //color: Colors.red,
                                      // padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Total'+' JD',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    RoundedButton(title: 'BOOK NOW', colour:Color(0xFFFAD02C) , onPressed:(){
                                      showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            height: 150,
                                            color: Colors.white,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                   Row(mainAxisAlignment:MainAxisAlignment.center ,
                                                    children: [
                                                      GooglePayButton(
                                                        paymentConfigurationAsset: 'gpay.json',
                                                        paymentItems: _paymentItems,
                                                        width: 200,
                                                        height: 50,
                                                        style: GooglePayButtonStyle.black,
                                                        type: GooglePayButtonType.pay,
                                                        margin: const EdgeInsets.only(top: 15.0),
                                                        onPaymentResult: (data) {
                                                          print(data);
                                                        },
                                                        loadingIndicator: const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                  // ElevatedButton(
                                                  //   child: const Text('Close BottomSheet'),
                                                  //   onPressed: () => Navigator.pop(context),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    );
                  });
            }),
      ),
    );
  }
}
//
// setState(() {
// Navigator.push(context,MaterialPageRoute(builder: (context) => Payment()));
// });
