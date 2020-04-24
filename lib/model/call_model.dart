import 'package:ultravmobile/model/franqueados.dart';

class CallModel {
  Franqueados franqueado = Franqueados();
  Client client = Client();
  String description = "";
  String url = "";
  String photo = "";
  String id = "";
  int status = 0;
  int roomAmount = 0;
  int bathroomAmount = 0;
  int price = 0;
  int kind = 0;
  String scheduledTime = "";
  String appraisal = "";
  String cancelReason = "";
  String schedulingCancelReason = "";
  String complaint = "";
  String createdAt = "";

  CallModel populate(Map<String, dynamic> dataResponse) {
    var call = CallModel();
    if (dataResponse["microFranchisee"] != null) {
      var franqueado = Franqueados().populate(dataResponse["microFranchisee"]);
      call.franqueado = franqueado;
    }
    if (dataResponse["client"] != null) {
      var user = Client().populate(dataResponse["client"]);
      call.client = user;
    }

    call.description = dataResponse["description"];
    call.id = dataResponse["id"];
    call.status = dataResponse["status"] ?? 1;
    call.roomAmount = dataResponse["roomAmount"];
    call.bathroomAmount = dataResponse["bathroomAmount"];
    call.price = dataResponse["price"];
    call.kind = dataResponse["kind"];
    call.scheduledTime = dataResponse["scheduledTime"];
    call.createdAt = dataResponse["createdAt"];
    call.appraisal = dataResponse["appraisal"];
    call.cancelReason = dataResponse["cancelReason"];
    call.schedulingCancelReason = dataResponse["schedulingCancelReason"];
    call.complaint = dataResponse["complaint"];

    if (dataResponse["picture"] != null)
      call.photo = dataResponse["picture"]["url"];

    return call;
  }
}

class Client {
  String name = "";
  String id = "";
  String phoneNumber = "";

  Client populate(Map<String, dynamic> dataResponse) {
    // print("Franq");
    // print(dataResponse);
    var client = Client();
    client.name = dataResponse["name"];
    client.phoneNumber = dataResponse["phoneNumber"];

    client.id = dataResponse["id"];

    return client;
    ;
  }
}
