import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '80B4A19147066E6CE182BDF9C33EAEB0';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _textEditingController = new TextEditingController();
  final _focusNode = new FocusNode();

  String encryptBox = '';
  String codeBox = '';

  String listOne = "2!@HmsW736cXBTKwxzld#[RSL*()_+";
  String listTwo = "yOE-^Nio{~05/8P.?M&jka=`u9GC4]";
  String listThree = "Dt|:JQZFVfpq ghv}<,UIen>1rbAY%";

  var textController = new TextEditingController();

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Game','Gaming','Arcade','Fun','India','Bored','Entertainment','Book','Secret','Messages',"Messaging"],
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  BannerAd createBannerAd(){
    return BannerAd(
        adUnitId: 'ca-app-pub-2273073266916535/6410411478',
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("BannerAd $event");
        }
    );
  }

  InterstitialAd createInterstitialAd(){
    return InterstitialAd(
        adUnitId: 'ca-app-pub-2273073266916535/7495783503',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print("InterstitialAd $event");
        }
    );
  }

  @override
  void initState()  {

    FirebaseAdMob.instance.initialize(
      appId: 'ca-app-pub-2273073266916535~5928670529',
    );
    _bannerAd = createBannerAd()..load()..show();
    super.initState();
  }
  @override
  void dispose(){
    _bannerAd.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ENCRYPT / DECRYPT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
          onTap: (){
            createInterstitialAd()..load()..show();
          },
          child: Icon(
            Icons.videocam,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250,
                  height: 70,
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your 4 digit code.',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (String str){
                      codeBox = str;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  color: Colors.white,
                  child: TextField(
                    maxLength: 150,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    onChanged: (String str){
                      encryptBox = str;
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter a message to be encrypted or decrypted.',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        icon: Icon(Icons.lock_outline),
                        color: Colors.white,
                        iconSize: 50,
                        onPressed: (){
                          FocusScope.of(context).unfocus();
                          if(codeBox.length != 4 || encryptBox == ''){
                            return null;
                          }
                          else{
                            if((int.parse(codeBox) % 26) % 30 == 0||(int.parse(codeBox) % 12) % 30 == 0 || (int.parse(codeBox) % 50) % 30 == 0){
                              textController.text = 'Invalid Code';
                            }
                            else{
                              String temp = '';
                              int code = int.parse(codeBox);
                              int amntLtr = code % 26;
                              int amntVow = code % 12;
                              int amntNum = code % 50;
                              for(int i = 0; i < encryptBox.length;i++){
                                String chng = encryptBox[i];
                                if(listOne.indexOf(chng) > -1){
                                  int w = encodeLetter(listOne.indexOf(chng),amntLtr,29);
                                  temp += listOne[w];
                                }
                                else if(listTwo.indexOf(chng) > -1){
                                  int w = encodeLetter(listTwo.indexOf(chng),amntVow,29);
                                  temp += listTwo[w];
                                }
                                else if(listThree.indexOf(chng) > -1){
                                  int w = encodeLetter(listThree.indexOf(chng),amntNum,29);
                                  temp += listThree[w];
                                }
                                else{
                                  temp += chng;
                                }
                              }
                              setState(() {
                                textController.text = temp;
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      child: IconButton(
                        icon: Icon(Icons.lock_open),
                        color: Colors.white,
                        iconSize: 50,
                        onPressed: (){
                          FocusScope.of(context).unfocus();
                          if(codeBox.length != 4 || encryptBox == ''){
                            return null;
                          }
                          else{
                            if((int.parse(codeBox) % 26) % 30 == 0||(int.parse(codeBox) % 12) % 30 == 0 || (int.parse(codeBox) % 50) % 30 == 0){
                              textController.text = 'Invalid Code';
                            }
                            else{
                              String temp = '';
                              int code = int.parse(codeBox);
                              int amntLtr = code % 26;
                              int amntVow = code % 12;
                              int amntNum = code % 50;
                              for(int i = 0; i < encryptBox.length;i++){
                                String chng = encryptBox[i];
                                if(listOne.indexOf(chng) > -1){
                                  int w = decodeLetter(listOne.indexOf(chng),amntLtr,29);
                                  temp += listOne[w];
                                }
                                else if(listTwo.indexOf(chng) > -1){
                                  int w = decodeLetter(listTwo.indexOf(chng),amntVow,29);
                                  temp += listTwo[w];
                                }
                                else if(listThree.indexOf(chng) > -1){
                                  int w = decodeLetter(listThree.indexOf(chng),amntNum,29);
                                  temp += listThree[w];
                                }
                                else{
                                  temp += chng;
                                }
                              }
                              setState(() {
                                textController.text = temp;
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 250,
                  color: Colors.white,
                  child: TextField(
                    maxLength: 150,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    controller: textController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Output Text',
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


int encodeLetter(int n, int x, int maxNum){
  if(x == 0){
    return n;
  }
  if(n == maxNum){
    return encodeLetter(0, x-1, maxNum);
  }
  else{
    return encodeLetter(n+1, x-1, maxNum);
  }
}

int decodeLetter(int n, int x, int maxNum){
  if(x == 0){
    return n;
  }
  if(n == 0){
    return decodeLetter(maxNum, x-1, maxNum);
  }
  else{
    return decodeLetter(n-1, x-1, maxNum);
  }
}
