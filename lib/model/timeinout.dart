class MarkTime{

  String uid;
  String location;
  String aid;
  String act;
  String shiftid;
  String refid;
  String latit;
  String longi;
  String start;
  String finish;
  String tractor;

  MarkTime(this.uid, this.location, this.aid, this.act, this.shiftid, this.refid, this.latit, this.longi, this.start, this.finish, this.tractor);

  MarkTime.fromMap(Map map){
    uid = map[uid];
    location = map[location];
    aid = map[aid];
    act = map[act];
    shiftid = map[shiftid];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
    start = map[start];
    finish = map[finish];
    tractor = map[tractor];
  }
  MarkTime.fromJson(Map map){
    uid = map[uid];
    location = map[location];
    aid = map[aid];
    act = map[act];
    shiftid = map[shiftid];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
    start = map[start];
    finish = map[finish];
    tractor = map[tractor];
  }


}

class MarkVisit{

  String uid;
  String cid;
  String location;
  String refid;
  String latit;
  String longi;
  String start;
  String finish;
  String pro;
  String trailer;
  String action;
  String remarkin;

  MarkVisit(this.uid,this.cid, this.location, this.refid, this.latit, this.longi, this.start, this.finish, this.pro, this.trailer, this.action, this.remarkin);

  MarkVisit.fromMap(Map map){
    uid = map[uid];
    cid = map[cid];
    location = map[location];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
    start = map[start];
    finish = map[finish];
    pro = map[pro];
    trailer = map[trailer];
    action = map[action];
    remarkin = map[remarkin];
  }
  MarkVisit.fromJson(Map map){
    uid = map[uid];
    cid = map[cid];
    location = map[location];
    refid = map[refid];
    latit = map[latit];
    longi = map[longi];
    start = map[start];
    finish = map[finish];
    pro = map[pro];
    trailer = map[trailer];
    action = map[action];
    remarkin = map[remarkin];
  }


}