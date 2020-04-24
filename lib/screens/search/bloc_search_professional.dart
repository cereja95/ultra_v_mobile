import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ultravmobile/bloc/login_bloc.dart';
import 'package:ultravmobile/extra/Prefs.dart';
import 'package:ultravmobile/model/call_model.dart';
import 'package:ultravmobile/model/franqueados.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hasura_connect/hasura_connect.dart';
import '../../extra/Constants.dart' as Constants;
import '../../extra/Messages.dart' as Messages;
import 'dart:io' show File;
import '../../utils/Monetary.dart' as Monetary;

String url = Constants.ENDPOINT_PRIVATE;
HasuraConnect hasuraConnect = HasuraConnect(url, token: (isError) async {
  //sharedPreferences or other storage logic
  var token = await Prefs().getPrefString("token");
  return "Bearer $token";
});

class BlocSearchProfessional {
//MARK: - VAR AND LET
  var description = "";
  List<Franqueados> products = [];
  List<CallModel> calls = [];
  List<CallModel> schedules = [];
  Franqueados selectFranqueado;
  CallModel selectCall;
  File imageSend;
  String dateTime = "";
  String optionTurn = "Manhã";

  List<String> categorias = <String>['Mapeamento', 'Vazamento'];
  List<String> categoriasTurn = <String>['Manhã', 'Tarde'];
  int filtro = 0;
  String dropdowType = 'Mapeamento';

  final HttpLink httpLink = HttpLink(
    uri: Constants.ENDPOINT_PRIVATE,
  );

  final AuthLink authLink = AuthLink(getToken: () async {
    var token = await Prefs().getPrefString("token");
    return "Bearer $token";
  });

  Link link;

  GraphQLClient client;

  void setGraph() {
    link = authLink.concat(httpLink);

    client = GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    );
  }

  String docGetProfessionals = """
query findNearestMicroFranchisees(\$after: String, \$before: String, \$first: Int, \$last: Int, \$lat: String!, \$lng: String!){
  findNearestMicroFranchisees(after: \$after, before: \$before, first: \$first, last: \$last, lat: \$lat, lng: \$lng){
  
    nodes{
      email
      id
      lat
      lng
      name 
      number
      phoneNumber
      street
      city
      
    }
  }

}
""";

  String queryMe = """
query me {
  me{
    email
    id
    lat
    lng
    name
    serviceRequests{
      microFranchisee {
         email
      id
      lat
      lng
      name 
      number
      phoneNumber
      street
      city
      }
           client{
        id
        name
        phoneNumber
      }
    status
    description
    createdAt
    roomAmount
    bathroomAmount
    price
    kind
    scheduledTime
    appraisal
    cancelReason
    schedulingCancelReason
    complaint
      picture{
        url
      }
      id
    }
  }
}
""";

  String docCreateCall = """
mutation createServiceRequest(\$input: CreateServiceRequestInput!){
  createServiceRequest(input: \$input){

errors
   serviceRequest{
      microFranchisee {
         email
      id
      lat
      lng
      name 
      number
      phoneNumber
      street
      city
      }
           client{
        id
        name
        phoneNumber
      }
    status
    description
    createdAt
    roomAmount
    bathroomAmount
    price
    kind
    scheduledTime
    appraisal
    cancelReason
    schedulingCancelReason
    complaint
      picture{
        url
      }
      id
    }
  }

}
""";

  String docUpdateCall = """
mutation updateServiceRequest(\$input: UpdateServiceRequestInput!){
  updateServiceRequest(input: \$input){

errors
   serviceRequest{
      microFranchisee {
         email
      id
      lat
      lng
      name 
      number
      phoneNumber
      street
      city
      }
           client{
        id
        name
        phoneNumber
      }
    status
    description
    createdAt
    roomAmount
    bathroomAmount
    price
    kind
    scheduledTime
    appraisal
    cancelReason
    schedulingCancelReason
    complaint
      picture{
        url
      }
      id
    }
  }

}
""";

  String docCreateCallApi = """
mutation createServiceRequest(\$picture: Upload, \$description: String!, \$microFranchiseeId: ID!, \$roomAmount: Int, \$scheduledTime: ISO8601DateTime, \$price: Int){
  createServiceRequest(input: {picture: \$picture, description: \$description, microFranchiseeId: \$microFranchiseeId, roomAmount: \$roomAmount,  scheduledTime: \$scheduledTime, price: \$price}){

errors
   serviceRequest{
      microFranchisee {
         email
      id
      lat
      lng
      name 
      number
      phoneNumber
      street
      city
      }
           client{
        id
        name
        phoneNumber
      }
    status
    description
    createdAt
    roomAmount
    bathroomAmount
    price
    kind
    scheduledTime
    appraisal
    cancelReason
    schedulingCancelReason
    complaint
      picture{
        url
      }
      id
    }
  }

}
""";

//MARK: - CONTROLLER
  var controllerDescription = new TextEditingController();
  var controllerScheduleCancel = new TextEditingController();
  var controllerBathCount = new TextEditingController();
  var controllerRoomCount = new TextEditingController();
  var controllerCancelReason = new TextEditingController();
  var controllerKitchenCount = new TextEditingController();
  var controllerBedCount = new TextEditingController();

//MARK: - STREAM
  var listStreamController = BehaviorSubject<List<Franqueados>>();
  var listCallStreamController = BehaviorSubject<List<CallModel>>();
  var listScheduleStreamController = BehaviorSubject<List<CallModel>>();
  var selectCallStream = BehaviorSubject<CallModel>();
  var loadingCallStreamController = BehaviorSubject<bool>();
  var loadingCancelRequestStreamController = BehaviorSubject<bool>();
  var loadingRatingStreamController = BehaviorSubject<bool>();
  var imageStreamController = BehaviorSubject<bool>();
  var dateStreamController = BehaviorSubject<String>();
  var priceStreamController = BehaviorSubject<String>();
  double ratingValue = 3;

//MARK: - BIND FUNCTIONS
  Function(String, String) alert;
  Function(String, String, Function) alertCall;
  Function(String, String, Function) alertCallOptions;
  Function(String, String) alertDetail;
  Function(CallModel) goDetailsCall;
  Function(Franqueados, String, String) addMark;

  //MARK: - CONSTRUCTOR
  BlocSearchProfessional() {
    insertInitialValues();
  }

//MARK: - FUNCTIONS
  void insertInitialValues() {
    setGraph();
    controllerDescription.addListener(onChangeDescription);
    controllerBathCount.addListener(onChangeValue);
    controllerBedCount.addListener(onChangeValue);
    controllerKitchenCount.addListener(onChangeValue);
    controllerRoomCount.addListener(onChangeValue);
  }

  void onChangeValue() {
    var count1 =
        controllerBathCount.text != "" ? controllerBathCount.text : "0";
    var count2 = controllerBedCount.text != "" ? controllerBedCount.text : "0";
    var count3 =
        controllerRoomCount.text != "" ? controllerRoomCount.text : "0";
    var count4 =
        controllerKitchenCount.text != "" ? controllerKitchenCount.text : "0";

    var priceFinal = int.parse(count1) * 20000 +
        int.parse(count2) * 15000 +
        int.parse(count3) * 15000 +
        int.parse(count4) * 25000;

    var priceFinall =
        Monetary.formatterMoney(double.parse(priceFinal.toString()));
    priceStreamController.add("Previsão do orçamento: $priceFinall");
  }

  void onChangeDescription() {
    description = controllerDescription.text;
  }

  void updateListCallId() {
    var i = 0;
    calls.forEach((element) => {
          if (element.id == selectCall.id)
            {calls[i] = element, listCallStreamController.add(calls)},
          i++
        });
  }

  void updateSelectCall() {
    var i = 0;
    calls.forEach((element) => {
          if (element.id == selectCall.id)
            {selectCall = element, selectCallStream.add(element)}
        });
  }

//MARK: - SERVICE

  Future<void> createCallApi() async {
    if (controllerRoomCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de cômodos para continuar",
          () {});
      return;
    }
    if (controllerBathCount.text == "") {
      alertCall("Atenção",
          "Prenncha o campo número de banheiros para continuar", () {});
      return;
    }

    if (controllerKitchenCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de cozinhas para continuar",
          () {});
      return;
    }

    if (controllerBedCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de quartos para continuar",
          () {});
      return;
    }

    if (description == "") {
      alertCall("Atenção", "Prenncha o campo descrição para continuar", () {});
      return;
    }

    if (dateTime == "") {
      alertCall(
          "Atenção", "Selecione a data de atendimento para continuar", () {});
      return;
    }

    if (optionTurn == "") {
      alertCall(
          "Atenção", "Marque o turno do atendimento para continuar", () {});
      return;
    }

    var count1 =
        controllerBathCount.text != "" ? controllerBathCount.text : "0";
    var count2 = controllerBedCount.text != "" ? controllerBedCount.text : "0";
    var count3 =
        controllerRoomCount.text != "" ? controllerRoomCount.text : "0";
    var count4 =
        controllerKitchenCount.text != "" ? controllerKitchenCount.text : "0";

    var priceFinal = int.parse(count1) * 20000 +
        int.parse(count2) * 15000 +
        int.parse(count3) * 15000 +
        int.parse(count4) * 25000;

    var priceFinall =
        Monetary.formatterMoney(double.parse(priceFinal.toString()));

    alertCallOptions("Confirmação",
        "Deseja realmente fazer o chamado? O orçamento para esse serviço foi de $priceFinall",
        () async {
      var opt = optionTurn == "Manhã" ? 0 : 1;
      loadingCallStreamController.add(true);

      var opts = MutationOptions(
        documentNode: gql(docCreateCallApi),
        variables: {
          'picture': imageSend,
          "microFranchiseeId": selectFranqueado.id,
          "description": description,
          "kind": filtro,
          "price": int.parse(controllerBathCount.text) * 20000 +
              int.parse(controllerBedCount.text) * 15000 +
              int.parse(controllerRoomCount.text) * 15000 +
              int.parse(controllerKitchenCount.text) * 25000,
          "bathroomAmount": controllerBathCount.text,
          "status": 1,
          "roomAmount": opt,
          "scheduledTime": DateTime.parse(dateTime).toIso8601String()
        },
      );
      var response = await client.mutate(opts);

      print("RESULTS::::::::::");
      print(response.exception.toString());
      loadingCallStreamController.add(false);
      if (!response.hasException) {
        controllerRoomCount.text = "";
        controllerBathCount.text = "";
        dateStreamController.add(null);
        controllerKitchenCount.text = "";

        controllerBedCount.text = "";

        description == "";

        dateTime = "";

        optionTurn = "Manhã";
        alertCall("Sucesso", "Chamado enviado ao micro-franqueado", () {
          goDetailsCall(CallModel().populate(
              response.data["createServiceRequest"]["serviceRequest"]));
        });
      } else {
        alertCall(Messages.ATTENTION, Messages.ERROR_MESSAGE, () {});
      }
    });
  }

  Future<void> createCall() async {
    if (controllerRoomCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de cômodos para continuar",
          () {});
      return;
    }
    if (controllerBathCount.text == "") {
      alertCall("Atenção",
          "Prenncha o campo número de banheiros para continuar", () {});
      return;
    }

    if (controllerKitchenCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de cozinhas para continuar",
          () {});
      return;
    }

    if (controllerBedCount.text == "") {
      alertCall("Atenção", "Prenncha o campo número de quartos para continuar",
          () {});
      return;
    }

    if (description == "") {
      alertCall("Atenção", "Prenncha o campo descrição para continuar", () {});
      return;
    }

    if (dateTime == "") {
      alertCall(
          "Atenção", "Selecione a data de atendimento para continuar", () {});
      return;
    }

    if (optionTurn == "") {
      alertCall(
          "Atenção", "Marque o turno do atendimento para continuar", () {});
      return;
    }

    var count1 =
        controllerBathCount.text != "" ? controllerBathCount.text : "0";
    var count2 = controllerBedCount.text != "" ? controllerBedCount.text : "0";
    var count3 =
        controllerRoomCount.text != "" ? controllerRoomCount.text : "0";
    var count4 =
        controllerKitchenCount.text != "" ? controllerKitchenCount.text : "0";

    var priceFinal = int.parse(count1) * 20000 +
        int.parse(count2) * 15000 +
        int.parse(count3) * 15000 +
        int.parse(count4) * 25000;

    var priceFinall =
        Monetary.formatterMoney(double.parse(priceFinal.toString()));

    alertCallOptions("Confirmação",
        "Deseja realmente fazer o chamado? O orçamento para esse serviço foi de $priceFinall",
        () async {
      var opt = optionTurn == "Manhã" ? 0 : 1;

      loadingCallStreamController.add(true);
      print({
        "input": {
          "microFranchiseeId": selectFranqueado.id,
          "description": description,
          "kind": filtro,
          "price": int.parse(controllerBathCount.text) * 20000 +
              int.parse(controllerBedCount.text) * 15000 +
              int.parse(controllerRoomCount.text) * 15000 +
              int.parse(controllerKitchenCount.text) * 25000,
          "roomAmount": opt,
          "bathroomAmount": controllerBathCount.text,
          "status": 1,
          "scheduledTime": dateTime
        }
      });

      var response = await hasuraConnect.mutation(docCreateCall, variables: {
        "input": {
          "microFranchiseeId": selectFranqueado.id,
          "description": description,
          "kind": filtro,
          "price": int.parse(controllerBathCount.text) * 20000 +
              int.parse(controllerBedCount.text) * 15000 +
              int.parse(controllerRoomCount.text) * 15000 +
              int.parse(controllerKitchenCount.text) * 25000,
          "roomAmount": opt,
          "bathroomAmount": int.parse(controllerBathCount.text),
          "status": 1,
          "scheduledTime": DateTime.parse(dateTime).toIso8601String()
        }
      });
      loadingCallStreamController.add(false);

      print(response);

      var errors = response["data"]["createServiceRequest"]["errors"];

      if (errors != null) {
        alertCall(Messages.ATTENTION, errors.last, () {});
        return;
      }

      controllerRoomCount.text = "";
      controllerBathCount.text = "";
      dateStreamController.add(null);
      controllerKitchenCount.text = "";

      controllerBedCount.text = "";

      description == "";

      dateTime = "";

      optionTurn = "Manhã";

      var result = response["data"]["createServiceRequest"];
      print("RESULTADO");
      print(result);

      if (result != null) {
        alertCall("Sucesso", "Chamado enviado ao micro-franqueado", () {
          goDetailsCall(CallModel().populate(result["serviceRequest"]));
        });
      } else {
        alertCall(Messages.ATTENTION, Messages.ERROR_MESSAGE, () {});
      }
    });
  }

  Future<void> getService(latitudeCoord, longitudeCoord) async {
    //  loadingLoginStreamController.add(true);
    print('request');
    products = [];
    listStreamController.add(null);
    var response = await hasuraConnect.query(docGetProfessionals,
        variables: {"lat": latitudeCoord, "lng": longitudeCoord});
    //loadingLoginStreamController.add(false);
    // print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["findNearestMicroFranchisees"]["nodes"];
    if (result != null) {
      if (result.length == 0) {
        listStreamController.add([]);
        return;
      }
      result.forEach(
          (element) => {products.add(Franqueados().populate(element))});

      result.forEach((element) => addMark(
          Franqueados().populate(element), element["lat"], element["lng"]));

      print(products.last.lat);
      print(products.last.long);
      print(result.last);
      listStreamController.add(products);
      // goHome();

    }
  }

  Future<void> getMe() async {
    var response = await hasuraConnect.query(queryMe);
    print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["me"];
    if (result != null) {
      print(result);
    }
  }

  Future<void> getCalls() async {
    listCallStreamController.add(null);
    var response = await hasuraConnect.query(queryMe);
    print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["me"]["serviceRequests"];
    if (result != null) {
      print('REsultadodododood');
      print(result);
      result.forEach((element) => {calls.add(CallModel().populate(element))});
      print(calls);
      listCallStreamController.add(calls);
    }
  }

  Future<void> getCallsSchedule() async {
    listScheduleStreamController.add(null);
    var response = await hasuraConnect.query(queryMe);
    print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["me"]["serviceRequests"];
    if (result != null) {
      print('REsultadodododood');
      print(result);
      schedules = [];
      result.forEach((element) => {
            if (element["status"] == 4)
              {schedules.add(CallModel().populate(element))}
          });
      listScheduleStreamController.add(schedules);
    }
  }

  Future<void> getCallsInfinity() async {
    // listCallStreamController.add(null);
    var response = await hasuraConnect.query(queryMe);
    //print(response);
    var errorGraph = response["data"]["error"];

    if (errorGraph != null) {
      print("alertErrorGraph");
    }
    var result = response["data"]["me"]["serviceRequests"];
    if (result != null) {
      // print('REsultadodododood');
      // print(result);
      List<CallModel> callll = [];
      result.forEach((element) => {callll.add(CallModel().populate(element))});
      // print(calls);
      calls = callll;
      listCallStreamController.add(calls);
      updateSelectCall();
    }
  }

//MARK: - SERVICE STATUS

  Future<void> updateRequestAccept(bool cancel, schedulingCancelReason) async {
    print("HSVHSVHVSHHSVHJVS");
    selectCallStream.add(null);
    if (cancel) {
      if (schedulingCancelReason == null) {
        alertDetail(Messages.ATTENTION,
            "Preencha o campo motivo de recusa, para poder selecionar essa opção");
        return;
      }
    }
    selectCallStream.add(null);
    var input = schedulingCancelReason == null
        ? {
            "input": {"serviceRequestId": selectCall.id, "status": 4}
          }
        : {
            "input": {
              "serviceRequestId": selectCall.id,
              "schedulingCancelReason": schedulingCancelReason,
              "status": 3
            }
          };

    print(input);

    var response =
        await hasuraConnect.mutation(docUpdateCall, variables: input);
    loadingCallStreamController.add(false);

    var errors = response["data"]["updateServiceRequest"]["errors"];

    if (errors != null) {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["updateServiceRequest"];

    if (result != null) {
      selectCall.status = schedulingCancelReason == null ? 4 : 3;
      schedulingCancelReason == null
          ? null
          : selectCall.schedulingCancelReason = schedulingCancelReason;
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> updateRequestStatus(int status) async {
    selectCallStream.add(null);

    var input = {
      "input": {"serviceRequestId": selectCall.id, "status": status}
    };

    var response =
        await hasuraConnect.mutation(docUpdateCall, variables: input);
    loadingCallStreamController.add(false);

    var errors = response["data"]["updateServiceRequest"]["errors"];

    if (errors != null) {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["updateServiceRequest"];

    if (result != null) {
      selectCall.status = status;
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> updateRating() async {
    selectCallStream.add(null);
    var input = {
      "input": {
        "serviceRequestId": selectCall.id,
        "status": 10,
        "bathroomAmount": ratingValue.round()
      }
    };

    var response =
        await hasuraConnect.mutation(docUpdateCall, variables: input);
    loadingCallStreamController.add(false);

    var errors = response["data"]["updateServiceRequest"]["errors"];

    if (errors != null) {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["updateServiceRequest"];

    if (result != null) {
      selectCall.status = 10;
      selectCall.bathroomAmount = ratingValue.round();
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> updateRequestCancelCLient() async {
    if (controllerCancelReason.text == "") {
      alertDetail(Messages.ATTENTION,
          "Preencha o campo razão de cancelamento, para poder fazer essa ação");
      return;
    }

    selectCallStream.add(null);

    var input = {
      "input": {
        "serviceRequestId": selectCall.id,
        "status": 7,
        "cancelReason": controllerCancelReason.text
      }
    };

    var response =
        await hasuraConnect.mutation(docUpdateCall, variables: input);

    var errors = response["data"]["updateServiceRequest"]["errors"];

    if (errors != null) {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["updateServiceRequest"];

    if (result != null) {
      selectCall.status = 7;
      selectCall.cancelReason = controllerCancelReason.text;
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> updateRequestChangeTime() async {
    if (dateTime == "") {
      alertDetail(Messages.ATTENTION,
          "Selecione um horário para o agendamento do serviço");
      return;
    }

    selectCallStream.add(null);

    var data = DateTime.parse(dateTime).toIso8601String();

    var input = {
      "input": {
        "serviceRequestId": selectCall.id,
        "status": 4,
        "scheduledTime": data,
        "roomAmount": optionTurn == "Manhã" ? 0 : 1
      }
    };

    var response =
        await hasuraConnect.mutation(docUpdateCall, variables: input);
    print("RESULT::::::");
    print(response);
    var errors = response["data"]["updateServiceRequest"]["errors"];

    if (errors != null) {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, errors.last);
      return;
    }

    var result = response["data"]["updateServiceRequest"];

    if (result != null) {
      selectCall.status = 4;
      selectCall.scheduledTime = data;
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

//MARK: - FINISH
  @override
  void dispose() {
    // listStreamController.close();
  }
}
