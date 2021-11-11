class CourseResponse {
  bool? error;
  List<Courses>? courses;

  CourseResponse({this.error, this.courses});

  CourseResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  String? id;
  String? title;
  String? description;
  String? overview;
  String? objectives;
  String? approach;
  String? references;
  String? image;
  List<Lessons>? lessons;
  List<Quiz>? quiz;

  Courses(
      {this.id,
        this.title,
        this.description,
        this.overview,
        this.objectives,
        this.approach,
        this.references,
        this.image,
        this.lessons,
        this.quiz});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    overview = json['overview'];
    objectives = json['objectives'];
    approach = json['approach'];
    references = json['references'];
    image = json['image'];
    if (json['lessons'] != null) {
      lessons = <Lessons>[];
      json['lessons'].forEach((v) {
        lessons!.add(new Lessons.fromJson(v));
      });
    }
    if (json['quiz'] != null) {
      quiz = <Quiz>[];
      json['quiz'].forEach((v) {
        quiz!.add(new Quiz.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['overview'] = this.overview;
    data['objectives'] = this.objectives;
    data['approach'] = this.approach;
    data['references'] = this.references;
    data['image'] = this.image;
    if (this.lessons != null) {
      data['lessons'] = this.lessons!.map((v) => v.toJson()).toList();
    }
    if (this.quiz != null) {
      data['quiz'] = this.quiz!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Lessons {
  String? id;
  String? title;
  String? lesson;
  String? duration;

  Lessons({this.id, this.title, this.lesson, this.duration});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    lesson = json['lesson'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['lesson'] = this.lesson;
    data['duration'] = this.duration;
    return data;
  }
}

class Quiz {
  String? id;
  String? title;
  String? duration;
  List<Questions>? questions;

  Quiz({this.id, this.title, this.duration, this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['duration'] = this.duration;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;
  String? question;
  String? a;
  String? b;
  String? c;
  String? d;
  String? answer;
  String? type;
  String? hint;
  int? mark;

  Questions(
      {this.id,
        this.question,
        this.a,
        this.b,
        this.c,
        this.d,
        this.answer,
        this.type,
        this.hint,
        this.mark});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    a = json['a'];
    b = json['b'];
    c = json['c'];
    d = json['d'];
    answer = json['answer'];
    type = json['type'];
    hint = json['hint'];
    mark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['a'] = this.a;
    data['b'] = this.b;
    data['c'] = this.c;
    data['d'] = this.d;
    data['answer'] = this.answer;
    data['type'] = this.type;
    data['hint'] = this.hint;
    data['mark'] = this.mark;
    return data;
  }
}
