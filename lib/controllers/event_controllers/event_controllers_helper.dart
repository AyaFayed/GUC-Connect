import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guc_scheduling_app/controllers/user_controller.dart';
import 'package:guc_scheduling_app/database/database.dart';
import 'package:guc_scheduling_app/models/course/course_model.dart';
import 'package:guc_scheduling_app/models/divisions/group_model.dart';
import 'package:guc_scheduling_app/models/divisions/tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_lecture_model.dart';
import 'package:guc_scheduling_app/models/events/compensation/compensation_tutorial_model.dart';
import 'package:guc_scheduling_app/models/events/event_model.dart';
import 'package:guc_scheduling_app/models/user/professor_model.dart';
import 'package:guc_scheduling_app/models/user/student_model.dart';
import 'package:guc_scheduling_app/models/user/ta_model.dart';
import 'package:guc_scheduling_app/shared/constants.dart';

import '../../models/events/assignment_model.dart';
import '../../models/events/quiz_model.dart';

class EventsControllerHelper {
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserController _user = UserController();

  Future addEventInDivisions(String eventId, EventType eventType,
      DivisionType divisionType, List<String> divisions) async {
    for (String divisionId in divisions) {
      final docDivision =
          _database.collection(divisionType.name).doc(divisionId);

      switch (eventType) {
        case EventType.announcements:
          await docDivision.update({
            'announcements': FieldValue.arrayUnion([eventId])
          });
          break;

        case EventType.assignments:
          await docDivision.update({
            'assignments': FieldValue.arrayUnion([eventId])
          });
          break;

        case EventType.quizzes:
          await docDivision.update({
            'quizzes': FieldValue.arrayUnion([eventId])
          });
          break;

        case EventType.compensationLectures:
          await docDivision.update({
            'compensationLectures': FieldValue.arrayUnion([eventId])
          });
          break;

        case EventType.compensationTutorials:
          await docDivision.update({
            'compensationTutorials': FieldValue.arrayUnion([eventId])
          });
      }
    }
  }

  List<String> getTAEventsList(TACourse course, EventType eventType) {
    if (eventType == EventType.announcements) {
      return course.announcements;
    } else {
      return course.compensationTutorials;
    }
  }

  List<String> getProfessorEventsList(
      ProfessorCourse course, EventType eventType) {
    switch (eventType) {
      case EventType.announcements:
        return course.announcements;
      case EventType.assignments:
        return course.assignments;
      case EventType.quizzes:
        return course.quizzes;
      default:
        return course.compensationLectures;
    }
  }

  Future addEventToInstructor(
      String courseId, String eventId, EventType eventType) async {
    final docUser = Database.users.doc(_auth.currentUser?.uid);

    Professor? professor =
        await Database.getProfessor(_auth.currentUser?.uid ?? '');

    if (professor != null) {
      List<ProfessorCourse> courses = professor.courses;
      for (ProfessorCourse course in courses) {
        if (course.id == courseId) {
          getProfessorEventsList(course, eventType).add(eventId);
        }
      }
      await docUser
          .update({'courses': courses.map((course) => course.toJson())});
    } else {
      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
      if (ta != null) {
        List<TACourse> courses = ta.courses;
        for (TACourse course in courses) {
          if (course.id == courseId) {
            getTAEventsList(course, eventType).add(eventId);
          }
        }
        await docUser
            .update({'courses': courses.map((course) => course.toJson())});
      }
    }
  }

  Future getEventsFromList(List<String> eventIds, EventType eventType) async {
    switch (eventType) {
      case EventType.announcements:
        return await Database.getAnnouncementListFromIds(eventIds);
      case EventType.assignments:
        return await Database.getAssignmentListFromIds(eventIds);
      case EventType.quizzes:
        return await Database.getQuizListFromIds(eventIds);
      case EventType.compensationLectures:
        return await Database.getCompensationLectureListFromIds(eventIds);
      case EventType.compensationTutorials:
        return await Database.getCompensationTutorialListFromIds(eventIds);
    }
  }

  Future<List<CalendarEvent>> getCalendarEventsFromList(String courseName,
      String courseId, List<String> eventIds, EventType eventType) async {
    switch (eventType) {
      case EventType.announcements:
        return [];
      case EventType.assignments:
        List<Assignment> assignments =
            await Database.getAssignmentListFromIds(eventIds);
        return assignments
            .map((assignment) => CalendarEvent(
                date: DateTime(assignment.deadline.year,
                    assignment.deadline.month, assignment.deadline.day),
                event: DisplayEvent.fromAssignment(assignment),
                courseId: courseId,
                courseName: courseName))
            .toList();
      case EventType.quizzes:
        List<Quiz> quizzes = await Database.getQuizListFromIds(eventIds);
        return quizzes
            .map((quiz) => CalendarEvent(
                date:
                    DateTime(quiz.start.year, quiz.start.month, quiz.start.day),
                event: DisplayEvent.fromQuiz(quiz),
                courseId: courseId,
                courseName: courseName))
            .toList();
      case EventType.compensationLectures:
        List<CompensationLecture> compensationLectures =
            await Database.getCompensationLectureListFromIds(eventIds);
        return compensationLectures
            .map((compensationLecture) => CalendarEvent(
                date: DateTime(
                    compensationLecture.start.year,
                    compensationLecture.start.month,
                    compensationLecture.start.day),
                event:
                    DisplayEvent.fromCompensationLecture(compensationLecture),
                courseId: courseId,
                courseName: courseName))
            .toList();
      case EventType.compensationTutorials:
        List<CompensationTutorial> compensationTutorials =
            await Database.getCompensationTutorialListFromIds(eventIds);
        return compensationTutorials
            .map((compensationTutorial) => CalendarEvent(
                date: DateTime(
                    compensationTutorial.start.year,
                    compensationTutorial.start.month,
                    compensationTutorial.start.day),
                event:
                    DisplayEvent.fromCompensationTutorial(compensationTutorial),
                courseId: courseId,
                courseName: courseName))
            .toList();
    }
  }

  Future getEventsofInstructor(String courseId, EventType eventType) async {
    Professor? professor =
        await Database.getProfessor(_auth.currentUser?.uid ?? '');

    if (professor != null) {
      List<ProfessorCourse> courses = professor.courses;
      for (ProfessorCourse course in courses) {
        if (course.id == courseId) {
          return await getEventsFromList(
              getProfessorEventsList(course, eventType), eventType);
        }
      }
    } else {
      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
      if (ta != null) {
        List<TACourse> courses = ta.courses;
        for (TACourse course in courses) {
          if (course.id == courseId) {
            return await getEventsFromList(
                getTAEventsList(course, eventType), eventType);
          }
        }
      }
    }
  }

  Future removeEventFromInstructor(
      String courseId, String eventId, EventType eventType) async {
    final docUser = Database.users.doc(_auth.currentUser?.uid);

    Professor? professor =
        await Database.getProfessor(_auth.currentUser?.uid ?? '');

    if (professor != null) {
      List<ProfessorCourse> courses = professor.courses;
      for (ProfessorCourse course in courses) {
        if (course.id == courseId) {
          getProfessorEventsList(course, eventType).remove(eventId);
        }
      }
      await docUser
          .update({'courses': courses.map((course) => course.toJson())});
    } else {
      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? '');
      if (ta != null) {
        List<TACourse> courses = ta.courses;
        for (TACourse course in courses) {
          if (course.id == courseId) {
            getTAEventsList(course, eventType).remove(eventId);
          }
        }
        await docUser
            .update({'courses': courses.map((course) => course.toJson())});
      }
    }
  }

  Future removeEventFromDivisions(String eventId, EventType eventType,
      DivisionType divisionType, List<String> divisions) async {
    for (String divisionId in divisions) {
      final docDivision =
          _database.collection(divisionType.name).doc(divisionId);
      final divisionSnapshot = await docDivision.get();

      if (divisionSnapshot.exists) {
        final division = divisionSnapshot.data();
        List<String> events =
            (division![eventType.name] as List<dynamic>).cast<String>();
        events.remove(eventId);

        switch (eventType) {
          case EventType.announcements:
            await docDivision.update({'announcements': events});
            break;

          case EventType.assignments:
            await docDivision.update({'assignments': events});
            break;

          case EventType.quizzes:
            await docDivision.update({'quizzes': events});
            break;

          case EventType.compensationLectures:
            await docDivision.update({'compensationLectures': events});
            break;

          case EventType.compensationTutorials:
            await docDivision.update({'compensationTutorials': events});
        }
      }
    }
  }

  Future<Map<DateTime, List<CalendarEvent>>> getMyCalendarEvents() async {
    UserType userType = await _user.getCurrentUserType();
    List<Future<List<CalendarEvent>>> calendarEvents = [];
    if (userType == UserType.student) {
      Student? student =
          await Database.getStudent(_auth.currentUser?.uid ?? "");
      if (student != null) {
        for (StudentCourse course in student.courses) {
          Course? courseData = await Database.getCourse(course.id);
          Group? group = await Database.getGroup(course.group);
          Tutorial? tutorial = await Database.getTutorial(course.tutorial);
          if (group != null) {
            calendarEvents.add(getCalendarEventsFromList(courseData?.name ?? '',
                courseData?.id ?? '', group.quizzes, EventType.quizzes));
            calendarEvents.add(getCalendarEventsFromList(
                courseData?.name ?? '',
                courseData?.id ?? '',
                group.assignments,
                EventType.assignments));
            calendarEvents.add(getCalendarEventsFromList(
                courseData?.name ?? '',
                courseData?.id ?? '',
                group.compensationLectures,
                EventType.compensationLectures));
          }
          if (tutorial != null) {
            calendarEvents.add(getCalendarEventsFromList(
                courseData?.name ?? '',
                courseData?.id ?? '',
                tutorial.compensationTutorials,
                EventType.compensationTutorials));
          }
        }
      }
    } else if (userType == UserType.professor) {
      Professor? professor =
          await Database.getProfessor(_auth.currentUser?.uid ?? "");
      if (professor != null) {
        for (ProfessorCourse course in professor.courses) {
          Course? courseData = await Database.getCourse(course.id);
          calendarEvents.add(getCalendarEventsFromList(courseData?.name ?? '',
              courseData?.id ?? '', course.quizzes, EventType.quizzes));
          calendarEvents.add(getCalendarEventsFromList(courseData?.name ?? '',
              courseData?.id ?? '', course.assignments, EventType.assignments));
          calendarEvents.add(getCalendarEventsFromList(
              courseData?.name ?? '',
              courseData?.id ?? '',
              course.compensationLectures,
              EventType.compensationLectures));
        }
      }
    } else if (userType == UserType.ta) {
      TA? ta = await Database.getTa(_auth.currentUser?.uid ?? "");
      if (ta != null) {
        for (TACourse course in ta.courses) {
          Course? courseData = await Database.getCourse(course.id);
          calendarEvents.add(getCalendarEventsFromList(
              courseData?.name ?? '',
              courseData?.id ?? '',
              course.compensationTutorials,
              EventType.compensationTutorials));
        }
      }
    }

    List<List<CalendarEvent>> events = await Future.wait(calendarEvents);
    Map<DateTime, List<CalendarEvent>> eventsMap = {};
    for (List<CalendarEvent> eventList in events) {
      for (CalendarEvent event in eventList) {
        if (eventsMap[event.date] != null) {
          eventsMap[event.date]?.add(event);
        } else {
          eventsMap[event.date] = [event];
        }
      }
    }
    return eventsMap;
  }
}
