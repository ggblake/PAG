import 'dart:ffi';
import 'dart:io';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';






void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PAG',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PAG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String loggedin = 'not logged in';



  @override
  State<MyHomePage> createState() => _MyHomePageState();




}

class _MyHomePageState extends State<MyHomePage> {




  Future<void> _sendEmail() async {
    EmailContent email = EmailContent(
      to: [
        'user@domain.com',
      ],
      subject: 'Hello!',
      body: 'How are you doing?',
      cc: ['user2@domain.com', 'user3@domain.com'],
      bcc: ['boss@domain.com'],
    );

    OpenMailAppResult result =
    await OpenMailApp.composeNewEmailInMailApp(
        nativePickerTitle: 'Select email app to compose',
        emailContent: email);
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);
    }


  }



  Future<void> _webSite() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyWebView()),
    );


  }



  Future<void> _login()  async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute()),
    );



  }

  void _exit() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }




}

  Future<void> _readEmail() async {
    var result = await OpenMailApp.openMailApp(
      nativePickerTitle: 'Select email app to open',
    );
    if (!result.didOpen && !result.canOpen) {
      showNoMailAppsDialog(context);

      // iOS: if multiple mail apps found, show dialog to select.
      // There is no native intent/default app system in iOS so
      // you have to do it yourself.
    }

    }
  var contents="none";
  Data data = Data(user: 'ggeob', password: 'password');
  Future<String> readID() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      File file = File('$path/id.txt');

      // Read the file
      contents = await file.readAsString();
      var words = contents.split(",");
      data = Data(
          user: words[0],
          password: words[1]);




      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "no user";
    }
  }





  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
readID();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.





    String loggedin = 'not logged in';

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: style,
              onPressed: _webSite,
              child: const Text('PAG WEBSITE'),
            ),
            ElevatedButton(
              style: style,
              onPressed: _readEmail,
              child: const Text('READ EMAIL'),
            ),
            ElevatedButton(
              style: style,
              onPressed: _sendEmail,
              child: const Text('SEND EMAIL'),
            ),
            ElevatedButton(
              style: style,
              onPressed: _login,
              child: const Text('USER PROFILE'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: style,
              onPressed: _exit,
              child: const Text('EXIT'),
            ),
            Text(
             'logged in as: ',

            ),
            Text(
               data.user,

            ),
          ],
        ),
      ),
  // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondRoute extends StatefulWidget {
  const SecondRoute({Key? key}) : super(key: key);


  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<SecondRoute> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController psswdController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: emailController,
        obscureText: false,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );
    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: psswdController,
        keyboardType: TextInputType.emailAddress,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            )
        ),
      ),
    );
    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: RaisedButton(
          child: Text('SUBMIT', style: TextStyle(color: Colors.white, fontSize: 20)),
          color: Colors.black87,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
          onPressed: () async {
            final directory = await getApplicationDocumentsDirectory();
            final path = directory.path;
            File file = File('$path/id.txt');
            String tosave = emailController.text + "," + psswdController.text;
            file.writeAsString(tosave);


            Navigator.pop(context);
          },
        ),
      ),
    );
    final buttonForgotPassword = FlatButton(
        child: Text('Forgot Password', style: TextStyle(color: Colors.grey, fontSize: 16),),
        onPressed: null
    );
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: <Widget>[

                inputEmail,
                inputPassword,
                buttonLogin,
                buttonForgotPassword
              ],
            ),
          ),
        )
    );
  }
}

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  String url = 'https://preferredalliance.ca';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("PAG Website"),
        ),
        body: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (url) {
            print("Loaded $url");
          },
        ));
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Open Mail App"),
        content: Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
class Data {
  String user;

  String password;
  Data({required this.user, required this.password});
}



