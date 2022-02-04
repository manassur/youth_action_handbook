

class CourseResponse {
  bool? error;
  List<Courses>? courses;

  CourseResponse({this.error, this.courses});

  CourseResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
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
  int? color;
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
        this.color,
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
    color = int.parse(json['color']) ;
    image = json['image']??'';
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
    data['color'] = this.color;
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
  String? video;
  String? duration;

  Lessons({this.id, this.title, this.lesson,this.video, this.duration});

  Lessons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    lesson = json['lesson'];
    video = json['video'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['lesson'] = this.lesson;
    data['video'] = this.video;
    data['duration'] = this.duration;
    return data;
  }
}

class Quiz {
  String? id;
  String? title;
  String? duration;
  String? quizType;
  List<Questions>? questions;

  Quiz({this.id, this.title, this.duration, this.quizType, this.questions});

  Quiz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    quizType = json['quiz_type'];
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
    data['quiz_type'] = this.quizType;
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Questions {
  String? id;
  String? question;
  String? type;
  String? hint;
  String? correctAnswerId;
  String? selectedAnswerId;
  double? mark;
  List<Answers>? answers;

  Questions(
      {this.id,
        this.question,
        this.type,
        this.hint,
        this.correctAnswerId,
        this.selectedAnswerId,
        this.mark,
        this.answers});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    type = json['type'];
    hint = json['hint'];
    correctAnswerId = json['correct_answer_id'];
    selectedAnswerId = json['selected_answer_id'];
    mark = json['mark'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['type'] = this.type;
    data['hint'] = this.hint;
    data['correct_answer_id'] = this.correctAnswerId;
    data['selected_answer_id'] = this.selectedAnswerId;
    data['mark'] = this.mark;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  String? id;
  String? option;

  Answers({this.id, this.option});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['option'] = this.option;
    return data;
  }
}
