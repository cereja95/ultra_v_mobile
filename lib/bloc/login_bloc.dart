import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import '../extra/Constants.dart' as Constants;
import '../extra/Messages.dart' as Messages;

String url = Constants.ENDPOINT;
HasuraConnect hasuraConnect = HasuraConnect(url);

class LoginBloc {
  String docLogin = """
mutation loginClient(\$input: LoginClientInput!){
  loginClient(input: \$input){
    errors
    token{
      accessToken
    }
  }
}
""";

  String docLoginFranq = """
mutation loginMicroFranchisee(\$input: LoginMicroFranchiseeInput!){
  loginMicroFranchisee(input: \$input){
    errors
    token{
      accessToken
    }
  }
}
""";

//MARK: - CONSTRUCTOR
  LoginBloc() {
    initTextField();
  }

//MARK: - VAR AND LET
  var email = "";
  var password = "";

  //MARK: - CONTROLLER
  var controllerEmail = new TextEditingController();
  var controllerPassword = new TextEditingController();

  //MARK: - STREAM
  var loadingLoginStreamController = StreamController<bool>();

  //MARK: - BIND FUNCTIONS
  Function goHome;
  Function(String, String) alertLogin;

//MARK: - FUNCTIONS
  void initTextField() {
    controllerEmail.addListener(onChangeEmail);
    controllerPassword.addListener(onChangePassword);
  }

  void onChangeEmail() {
    email = controllerEmail.text;
  }

  void onChangePassword() {
    password = controllerPassword.text;
  }

//MARK: - SERVICE
  Future<void> makeLogin() async {
    loadingLoginStreamController.add(true);
    var response = await hasuraConnect.mutation(docLogin, variables: {
      "input": {
        "email": email,
        "password": password,
        "clientId": Constants.CLIENTID,
        "clientSecret": Constants.CLIENTSECRECT
      }
    });
    loadingLoginStreamController.add(false);
    var errors = response["data"]["loginClient"]["errors"];

    if (errors != null) {
      alertLogin(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["loginClient"]["token"];

    if (result != null) {
      await Prefs().setPrefString("token", result['accessToken']);
      Prefs().setPrefString("type", "1");
      var response = Prefs().getPrefString("token").then((token) {
        //     print(token);
        goHome();
      });
    } else {
      alertLogin(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> makeLoginFranq() async {
    print("TAAQUIIIIII");
    loadingLoginStreamController.add(true);
    var response = await hasuraConnect.mutation(docLoginFranq, variables: {
      "input": {
        "email": email,
        "password": password,
        "clientId": Constants.CLIENTID,
        "clientSecret": Constants.CLIENTSECRECT
      }
    });
    print(email);
    print(password);
    loadingLoginStreamController.add(false);
    var errors = response["data"]["loginMicroFranchisee"]["errors"];

    if (errors != null) {
      alertLogin(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["loginMicroFranchisee"]["token"];

    if (result != null) {
      await Prefs().setPrefString("token", result['accessToken']);
      Prefs().setPrefString("type", "2");
      var response = Prefs().getPrefString("token").then((token) {
        //     print(token);
        goHome();
      });
    } else {
      alertLogin(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  //MARK: - FINISH
  void dispose() {
    loadingLoginStreamController.close();
    controllerEmail.dispose();
    controllerPassword.dispose();
  }
}
