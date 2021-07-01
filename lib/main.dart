import 'dart:async';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CleverTapPlugin _clevertapPlugin;
  var inboxInitialized = false;
  var optOut = false;
  var offLine = false;
  var enableDeviceNetworkingInfo = false;
  String Productvalue = "New App";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    activateCleverTapFlutterPluginHandlers();
    CleverTapPlugin.setDebugLevel(3);
    CleverTapPlugin.createNotificationChannel(
        "fluttertest", "Flutter Test", "Flutter Test", 3, true);
    CleverTapPlugin.initializeInbox();
    CleverTapPlugin.registerForPush(); //only for iOS
    ///var initialUrl = CleverTapPlugin.getInitialUrl();
  }

  /// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  void activateCleverTapFlutterPluginHandlers() {
    _clevertapPlugin = new CleverTapPlugin();
    _clevertapPlugin.setCleverTapFeatureFlagUpdatedHandler(featureFlagsUpdated);
    _clevertapPlugin
        .setCleverTapProductConfigInitializedHandler(productConfigInitialized);
    _clevertapPlugin
        .setCleverTapProductConfigFetchedHandler(productConfigFetched);
    _clevertapPlugin
        .setCleverTapProductConfigActivatedHandler(productConfigActivated);
  }



  void featureFlagsUpdated() {
    print("Feature Flags Updated");
    this.setState(() async {
      bool booleanVar = await CleverTapPlugin.getFeatureFlag("BoolKey", false);
      print("Feature flag = " + booleanVar.toString());
    });
  }

  void productConfigInitialized() {
    print("Product Config Initialized");
    this.setState(() async {
      await CleverTapPlugin.fetch();
    });
  }

  void productConfigFetched() {
    print("Product Config Fetched");
    this.setState(() async {
      await CleverTapPlugin.activate();
    });
  }

  void productConfigActivated() {
    print("Product Config Activated");
    this.setState(() async {
      Productvalue =
      await CleverTapPlugin.getProductConfigString("welcomemessage");
      print("PC String = " + Productvalue.toString());
      // int intvar = await CleverTapPlugin.getProductConfigLong("IntKey");
      // print("PC int = " + intvar.toString());
      // double doublevar =
      // await CleverTapPlugin.getProductConfigDouble("DoubleKey");
      // print("PC double = " + doublevar.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StyledToast(
      locale: const Locale('en', 'US'),
      child: MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('CleverTap Plugin Example App'),
            ),
            body: ListView(
              children: <Widget>[
                Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      dense: true,
                      trailing: Icon(Icons.warning),
                      title: Text(
                          "NOTE : All CleverTap functions are listed below"),
                      subtitle: Text(
                          "Please check console logs for more info after tapping below"),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Set Debug Level"),
                      subtitle: Text(
                          "Sets the debug level in Android/iOS to show console logs"),
                      onTap: () {
                        CleverTapPlugin.setDebugLevel(3);
                      },
                      trailing: Icon(Icons.info),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Get CleverTap Id"),
                      subtitle: Text("Fetches CleverTap Id"),
                      onTap: getCleverTapId,
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Fetch"),
                      subtitle: Text("Fetches Product Config values"),
                      onTap: fetch,
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Activate"),
                      subtitle: Text("Activates Product Config values"),
                      onTap: activate,
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Fetch and Activate"),
                      subtitle: Text("Fetches and Activates Config values"),
                      onTap: fetchAndActivate,
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text("Show Fetch value"),
                      subtitle: Text("This will give toast for the fetch value"),
                      onTap: showvalue,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void getCleverTapId() {
    CleverTapPlugin.profileGetCleverTapID().then((clevertapId) {
      if (clevertapId == null) return;
      setState((() {
        showToast("$clevertapId");
        print("$clevertapId");
      }));
    }).catchError((error) {
      setState(() {
        print("$error");
      });
    });
  }

  void showvalue()
  {
    showToast("CleverTap Product Value:"+Productvalue);
  }

  void fetch() {
    CleverTapPlugin.fetch();
    showToast("check console for logs");
    ///CleverTapPlugin.fetchWithMinimumIntervalInSeconds(0);
  }

  // ignore: must_call_super
  void activate() {
    CleverTapPlugin.activate();
    showToast("check console for logs");
  }

  void fetchAndActivate() {
    CleverTapPlugin.fetchAndActivate();
    showToast("check console for logs");
  }
}
