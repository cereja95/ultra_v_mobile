class Franqueados {
  String nome = "";
  String endereco = "";
  String telefone = "";
  String foto = "";
  String email = "";
  String id = "";
  String lat = "";
  String long = "";

  Franqueados populate(Map<String, dynamic> dataResponse) {
    // print("Franq");
    // print(dataResponse);
    var franqueado = Franqueados();
    franqueado.nome = dataResponse["name"];
    franqueado.endereco = dataResponse["street"] +
        ", " +
        dataResponse["number"] +
        " - " +
        dataResponse["city"];
    franqueado.telefone = dataResponse["phoneNumber"];
    //franqueado.foto = dataResponse["foto"];

    // franqueado.endereco = "Av Hugo Musso 2000, Vila Velha - ES";
    franqueado.foto =
        "https://acotubo.com.br/wp-content/uploads/2016/07/tubos-de-aco-carbono-acotubo-3.png";
    //  franqueado.nome = "Assistência Praia da Costa";
    // franqueado.telefone = "(27) 3349-9472";
    franqueado.email = dataResponse["email"];
    franqueado.id = dataResponse["id"];
    franqueado.lat = dataResponse["lat"];
    franqueado.long = dataResponse["lng"];
    // print(franqueado.email);
    return franqueado;
    ;
  }
}
