
class Project {

  final String id;

  Project({this.id});
}

class ProjectData {
  String name;
  String description;
  int maxTeammate;
  String category;
  List<String> teammate = [];

  ProjectData({this.name,this.description,this.maxTeammate,this.category,this.teammate});
}
