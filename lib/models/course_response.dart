

class CourseResponse {
  bool? error;
  List<Courses>? courses;

  CourseResponse({this.error, this.courses});

  CourseResponse.fromJsonOld(Map<String, dynamic> json) {
    error = json['error'];
    if (json['courses'] != null) {
      courses = <Courses>[];
      json['courses'].forEach((v) {
        courses!.add(Courses.fromJson(v));
      });
    }
  }

   CourseResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['items'] != null) {
        courses = <Courses>[];
        json['items'].forEach((v) {
          courses!.add(Courses.fromJson(v));
        });
      }else{
        error = true;
      }
    } catch(e){
      print('AKBR ERROR in CRJNew: ' + e.toString());
      error = true;
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
  String? icon;
  List<Lessons>? lessons;
  List<Quiz>? quiz;
  bool? is_active;
  bool? is_featured;

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
        this.icon,
        this.lessons,
        this.quiz,
        this.is_active,
        this.is_featured});

  Courses.fromJson(Map<String, dynamic> json) {
    try {
      print('AKBR: trying to make courses');
      final String baseUrl = "https://greatlakesyouth.africa"; 
      id = json['uuid'];
      title = json['title'];
      description = json['title'];
      overview = json['overview'];
      objectives = json['objectives'];
      approach = json['approach'];
      references = json['references'];
      color = int.parse(json['color'].toString().replaceAll('#', '0xff')) ;
      image = baseUrl + (json['cover_image']['meta']['download_url']??'');
      icon = baseUrl + (json['icon']['meta']['download_url']??'');
      is_active = json['is_active'];
      is_featured = json['is_featured'];

      if (json['lessons'] != null) {
        lessons = <Lessons>[];
        json['lessons'].forEach((v) {
          lessons!.add(new Lessons.fromJson(v));
        });
      }
      if (json['questions'] != null) {
        quiz = <Quiz>[new Quiz.fromJson(json)];
        // json['questions'].forEach((v) {
        //   quiz!.add(new Quiz.fromJson(v));
        // });
      }
    }catch (e){
      print('AKBR courseERROR: '+e.toString());

    }
  }



  
  Courses.fromJsonOld(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    overview = json['overview'];
    objectives = json['objectives'];
    approach = json['approach'];
    references = json['references'];
    color = int.parse(json['color']) ;
    image = json['image']??'';
    icon = json['icon']??'';
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
    data['icon'] = this.icon;
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
    try {
      id = json['id'].toString();
      title = json['title'];
      lesson = json['content'];
      video = json['video'];
      duration = json['duration'];
    } catch (e) {
     print('AKBR lesson Error: '+ e.toString());
    }

  }

  Lessons.fromJsonOld(Map<String, dynamic> json) {
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
    try {
      id = json['uuid'];
      title = 'Quiz :' + json['title'];
      duration = '5 minutes';
      quizType = 'Quiz';
      if (json['questions'] != null) {
        questions = <Questions>[];
        json['questions'].forEach((v) {
          questions!.add(new Questions.fromJson(v));
        });
      }
    } catch (e) {
      print('AKBR Quiz Error: '+ e.toString());
    }
  }

   Quiz.fromJsonOld(Map<String, dynamic> json) {
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
  bool? isCorrect;
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
    try {
      id = json['id'].toString();
      question = json['question'];
      type = 'multiple_choice';
      hint = json['hint'];
      // correctAnswerId = ;
      // selectedAnswerId = json['selected_answer_id'];
      mark = json['mark'].toDouble();
      if (json['answers'] != null) {
        answers = <Answers>[];
        json['answers'].forEach((v) {
          if((v['correct']?? false)){
            correctAnswerId = v['id'].toString();
          }
          answers!.add(new Answers.fromJson(v));
        });
      }
    }catch (e,stacktrace) {
      print('AKBR Qtn Error: '+ e.toString() + ' at: '+ stacktrace.toString());
    }
  }

  Questions.fromJsonOld(Map<String, dynamic> json) {
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
  bool? isCorrect;

  Answers({this.id, this.option, this.isCorrect});

   Answers.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'].toString();
      option = json['answer_option'];
      isCorrect = json['correct'];
    } catch (e) {
      print('AKBR ansError: '+ e.toString());
    }
  }

  Answers.fromJsonOld(Map<String, dynamic> json) {
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
