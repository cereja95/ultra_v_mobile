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

String url = Constants.ENDPOINT_PRIVATE_MICRO;
HasuraConnect hasuraConnect = HasuraConnect(url, token: (isError) async {
  //sharedPreferences or other storage logic
  var token = await Prefs().getPrefString("token");
  return "Bearer $token";
});

class BlocProfessional {
//MARK: - VAR AND LET
  var description = "";
  List<Franqueados> products = [];
  List<CallModel> calls = [];
  List<CallModel> schedules = [];
  Franqueados selectFranqueado;
  CallModel selectCall;
  String dateTime = "";
  double ratingValue = 3;

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
      id
      picture{
        id
        url
      }
      description
    }
  }

}
""";

  String docUpdateCall = """
mutation updateServiceRequest(\$input: UpdateServiceRequestInput!){
  updateServiceRequest(input: \$input){

errors
    serviceRequest{
      id
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
        id
        url
      }
    }
  }

}
""";

  String docCreateCallApi = """
mutation createServiceRequest(\$picture: Upload, \$description: String!, \$microFranchiseeId: ID!){
  createServiceRequest(input: {picture: \$picture, description: \$description, microFranchiseeId: \$microFranchiseeId}){

errors
    serviceRequest{
      id
      picture{
        id
        url
      }
      description
    }
  }

}
""";

//MARK: - CONTROLLER
  var controllerDescription = new TextEditingController();
  var controllerScheduleCancel = new TextEditingController();
  var controllerBathCount = new TextEditingController();
  var controllerRoomCount = new TextEditingController();
  var controllerKitchenCount = new TextEditingController();
  var controllerBedCount = new TextEditingController();
  var controllerCancelReason = new TextEditingController();
  var controllerChangeValue = new TextEditingController();
  var controllerTextComplaint = new TextEditingController();

//MARK: - STREAM
  var listStreamController = BehaviorSubject<List<Franqueados>>();
  var listCallStreamController = BehaviorSubject<List<CallModel>>();
  var listScheduleStreamController = BehaviorSubject<List<CallModel>>();
  var selectCallStream = BehaviorSubject<CallModel>();
  var loadingCallStreamController = BehaviorSubject<bool>();
  var loadingCancelRequestStreamController = BehaviorSubject<bool>();
  var imageStreamController = BehaviorSubject<bool>();
  var dateStreamController = BehaviorSubject<String>();

//MARK: - BIND FUNCTIONS
  Function(String, String) alert;
  Function(String, String) alertCall;
  Function(String, String) alertDetail;
  Function(Franqueados, String, String) addMark;

  //MARK: - CONSTRUCTOR
  BlocSearchProfessional() {
    insertInitialValues();
  }

//MARK: - FUNCTIONS
  void insertInitialValues() {
    setGraph();
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

  // Future<void> createCallApi() async {
  //   if (controllerRoomCount.text == "") {
  //     alertCall("Atenção", "Prenncha o campo número de cômodos para continuar");
  //     return;
  //   }
  //   if (controllerRoomCount.text == "") {
  //     alertCall(
  //         "Atenção", "Prenncha o campo número de banheiros para continuar");
  //     return;
  //   }
  //   if (description == "") {
  //     alertCall("Atenção", "Prenncha o campo descrição para continuar");
  //     return;
  //   }
  //   loadingCallStreamController.add(true);

  //   var opts = MutationOptions(
  //     documentNode: gql(docCreateCallApi),
  //     variables: {
  //       'picture': imageSend,
  //       "microFranchiseeId": selectFranqueado.id,
  //       "description": description,
  //       "kind": filtro,
  //       "price": 10000,
  //       "roomAmount": controllerRoomCount.text,
  //       "bathroomAmount": controllerBathCount.text,
  //       "status": 1
  //     },
  //   );
  //   var response = await client.mutate(opts);

  //   print("RESULTS::::::::::");
  //   print(response.exception.toString());
  //   loadingCallStreamController.add(false);
  //   if (!response.hasException) {
  //     alertCall("Sucesso", "Chamado enviado ao micro-franqueado");
  //   } else {
  //     alertCall(Messages.ATTENTION, Messages.ERROR_MESSAGE);
  //   }
  // }

  // Future<void> getService(latitudeCoord, longitudeCoord) async {
  //   //  loadingLoginStreamController.add(true);
  //   print('request');
  //   products = [];
  //   listStreamController.add(null);
  //   var response = await hasuraConnect.query(docGetProfessionals,
  //       variables: {"lat": latitudeCoord, "lng": longitudeCoord});
  //   //loadingLoginStreamController.add(false);
  //   // print(response);
  //   var errorGraph = response["data"]["error"];

  //   if (errorGraph != null) {
  //     print("alertErrorGraph");
  //   }
  //   var result = response["data"]["findNearestMicroFranchisees"]["nodes"];
  //   if (result != null) {
  //     if (result.length == 0) {
  //       listStreamController.add([]);
  //       return;
  //     }
  //     result.forEach(
  //         (element) => {products.add(Franqueados().populate(element))});

  //     result.forEach((element) => addMark(
  //         Franqueados().populate(element), element["lat"], element["lng"]));

  //     print(products.last.lat);
  //     print(products.last.long);
  //     print(result.last);
  //     listStreamController.add(products);
  //     // goHome();

  //   }
  // }

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

  Future<void> updateComplaintStatus() async {
    selectCallStream.add(null);

    var input = {
      "input": {
        "serviceRequestId": selectCall.id,
        "status": 8,
        "complaint": controllerTextComplaint.text
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
      selectCall.status = 8;
      selectCall.complaint = controllerTextComplaint.text;
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
        "status": 6,
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
      selectCall.status = 6;
      selectCall.cancelReason = controllerCancelReason.text;
      selectCallStream.add(selectCall);
      updateListCallId();
    } else {
      selectCallStream.add(selectCall);
      alertDetail(Messages.ATTENTION, Messages.ERROR_MESSAGE);
    }
  }

  Future<void> updateRequestChangeValueCLient() async {
    if (controllerChangeValue.text == "") {
      alertDetail(Messages.ATTENTION,
          "Preencha o novo valor do serviço, para poder fazer essa ação");
      return;
    }

    selectCallStream.add(null);

    var input = {
      "input": {
        "serviceRequestId": selectCall.id,
        "status": 5,
        "price": int.parse(controllerChangeValue.text + "00")
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
      selectCall.status = 5;
      selectCall.price = int.parse(controllerChangeValue.text + "00");
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
        "scheduledTime": data
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
