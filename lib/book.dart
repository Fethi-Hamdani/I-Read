import 'dart:io';
class Book{
  int id;
  String path, 
         title="",
         size="", 
         location="",
         favorite,
         last_page_opened = '0';
  
  Book(this.path){extract_info();}
  Book.withid(this.id,this.path){extract_info();}
  Book.withdata(this.path, this.favorite,this.last_page_opened){extract_info();}

  void display_book(){
    print("Book: "+title+"\nid: "+id.toString()+"\nlastpageopened :"+last_page_opened);
  }

  void update_title(String new_title){
    path = path.substring(0,path.lastIndexOf('/')+1) + new_title+".pdf";
  }

  void extract_info(){
    title = path.substring(path.lastIndexOf('/')+1,path.length-4);
    location = path.substring(0,path.lastIndexOf('/'));
    location = location.substring(location.lastIndexOf('/')+1,location.length);
    location = location == "0" ? "route" : location;
    location = "From "+location;
    size = (File(this.path).lengthSync()/1024/1024).toStringAsFixed(2)+" MB";
  } 

  Map<String, dynamic> toMap() {
      extract_info();
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['_path']     = path;
    map['_lastpage'] = last_page_opened;
    map['_favorite'] = favorite;

    return map;
  }

   Map<String, dynamic> toMap_for_recent() {
      extract_info();
    var map = Map<String, dynamic>();
    map['_path']     = path;
    map['_lastpage'] = last_page_opened;
    map['_favorite'] = favorite;
    return map;
  }

  // Extract a Note object from a Map object
  Book.fromMapObject(Map<String, dynamic> map) {
   
    this.id               = map['id'];
    this.path             = map['_path'];
    this.last_page_opened =  map['_lastpage'];
    this.favorite         =  map['_favorite'];
    extract_info();
    this.title = title;
    this.location =location;
    this.size = size;
  } 
  Book.from_Recent_MapObject(Map<String, dynamic> map){
    this.id               = map['id'];
    this.path             = map['_path'];
    this.last_page_opened =  map['_lastpage'];
    this.favorite         =  map['_favorite'];
    extract_info();
    this.title = title;
    this.location =location;
    this.size = size;
  } 
}