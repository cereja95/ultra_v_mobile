import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import '../extra/Constants.dart' as Constants;
import '../extra/Messages.dart' as Messages;

String url = Constants.ENDPOINT;
HasuraConnect hasuraConnect = HasuraConnect(url);

class SignUpBloc {
  String docSignUp = """
mutation signupClient (\$input: SignupClientInput!){
  signupClient(input: \$input){
    errors
    token{
      accessToken
    }
  }
}
""";

//MARK: - CONSTRUCTOR
  SignUpBloc() {
    initTextField();
  }

//MARK: - VAR AND LET
  var email = "";
  var password = "";
  var name = "";
  var phone = "";
  var confirmPassword = "";

  //MARK: - CONTROLLER
  var controllerEmail = new TextEditingController();
  var controllerName = new TextEditingController();
  var controllerConfirmPassword = new TextEditingController();
  var controllerPhone = new TextEditingController();
  var controllerPassword = new TextEditingController();

  //MARK: - STREAM
  var loadingSignStreamController = StreamController<bool>();

  //MARK: - BIND FUNCTIONS
  Function goHome;
  Function(String, String) alert;

//MARK: - FUNCTIONS
  void initTextField() {
    controllerEmail.addListener(onChangeEmail);
    controllerPassword.addListener(onChangePassword);
    controllerName.addListener(onChangeName);
    controllerPhone.addListener(onChangePhone);
    controllerConfirmPassword.addListener(onChangeConfirmPassword);
  }

  void onChangeEmail() {
    email = controllerEmail.text;
  }

  void onChangePassword() {
    password = controllerPassword.text;
  }

  void onChangeConfirmPassword() {
    confirmPassword = controllerConfirmPassword.text;
  }

  void onChangeName() {
    name = controllerName.text;
  }

  void onChangePhone() {
    phone = controllerPhone.text;
  }

//MARK: - SERVICE
  Future<void> makeSignUp() async {
    if (name.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        email.isEmpty) {
      return alert(Messages.ATTENTION, Messages.EMPTY_FIELD);
    }

    if (password != confirmPassword || password.length < 6) {
      return alert(Messages.ATTENTION, Messages.PASSWORD_FIELD);
    }

    loadingSignStreamController.add(true);
    var response = await hasuraConnect.mutation(docSignUp, variables: {
      "input": {
        "email": email,
        "password": password,
        "phoneNumber": phone,
        "name": name,
        "lat": "-25.3990388",
        "lng": " -49.2806514",
        "clientId": Constants.CLIENTID,
        "clientSecret": Constants.CLIENTSECRECT
      }
    });
    loadingSignStreamController.add(false);
    var errors = response["data"]["signupClient"]["errors"];

    if (errors != null) {
      alert(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["signupClient"]["token"];

    if (result != null) {
      await Prefs().setPrefString("token", result['accessToken']);
      var response = Prefs().getPrefString("token").then((token) {
        //     print(token);
        goHome();
      });
    } else {
      alert(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  //MARK: - FINISH
  void dispose() {
    loadingSignStreamController.close();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerName.dispose();
    controllerConfirmPassword.dispose();
    controllerPhone.dispose();
  }
}
