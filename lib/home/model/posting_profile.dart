import 'dart:convert';

import 'dart:developer';

class Posting_profile {
  Posting_profile(
    this.status,
    this.error,
    this.keterangan,
    this.datum,
  );

  int status;
  bool error;
  String keterangan;
  List<Datum> datum = [];

  static Posting_profile fromMap(Map<String, dynamic> json) {
    List<Datum> datum = [];
    if (json['data'] != null) {
      for (Iterable row in json['data']) {
        log('Data');
        if (row == null) continue;
        for (Map map in row) {
          datum.add(Datum.fromMap(map));
        }
      }
    }

    return Posting_profile(
        json['status'], 
        json['error'], 
        json['keterangan'], 
        datum);
  }
}

class Datum {
  Datum(
    this.idPostProfile,
    this.idProfile,
    this.description,
    this.foto,
    this.privasiPost,
    this.created,
    this.updated,
  );

  String idPostProfile;
  String idProfile;
  String description;
  String foto;
  String privasiPost;
  String created;
  String updated;

  @override
  String toString() {
    log("$idPostProfile");
    return idPostProfile;
  }

  static Datum fromMap(Map map) {
    return Datum(
        map['idPostProfile'].toString(),
        map['idProfile'].toString(),
        map['description'].toString(),
        map['foto'].toString(),
        map['privasiPost'].toString(),
        map['created'].toString(),
        map['updated'].toString(),);
  }
}
