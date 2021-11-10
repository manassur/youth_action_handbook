class NewsResponse {
  bool? error;
  List<News>? news;

  NewsResponse({this.error, this.news});

  NewsResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['news'] != null) {
      news = <News>[];
      json['news'].forEach((v) {
        news!.add(new News.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.news != null) {
      data['news'] = this.news!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class News {
  String? id;
  String? title;
  String? blurb;
  String? link;
  String? date;
  String? image;

  News({this.id, this.title, this.blurb, this.link, this.date, this.image});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    blurb = json['blurb'];
    link = json['link'];
    date = json['date'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['blurb'] = this.blurb;
    data['link'] = this.link;
    data['date'] = this.date;
    data['image'] = this.image;
    return data;
  }
}
