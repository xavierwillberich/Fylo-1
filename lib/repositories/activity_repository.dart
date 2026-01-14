import '../models/event.dart';
import '../services/firebase_service.dart';
import '../core/exceptions/app_exception.dart';

/// 活动仓库接口
/// P1-4: 定义数据访问契约，便于测试和替换实现
abstract class ActivityRepository {
  /// 获取所有活动流
  Stream<List<Event>> getActivitiesStream();

  /// 获取用户参与的活动流
  Stream<List<Event>> getUserActivitiesStream(String userId);

  /// 获取所有活动（一次性）
  Future<List<Event>> getAllActivities();

  /// 获取用户参与的活动（一次性）
  Future<List<Event>> getUserActivities(String userId);

  /// 获取单个活动
  Future<Event?> getActivity(int activityId);

  /// 创建活动
  Future<void> createActivity(Event activity);

  /// 更新活动
  Future<void> updateActivity(Event activity);

  /// 删除活动
  Future<void> deleteActivity(int activityId);

  /// 加入活动
  Future<void> joinActivity(int activityId, String userId);

  /// 离开活动
  Future<void> leaveActivity(int activityId, String userId);
}

/// 活动仓库 Firebase 实现
/// P1-4: 封装 FirebaseService，转换异常为 AppException
class FirebaseActivityRepository implements ActivityRepository {
  final FirebaseService _firebaseService;

  FirebaseActivityRepository({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService();

  @override
  Stream<List<Event>> getActivitiesStream() {
    return _firebaseService.getEventsStream().handleError((error, stackTrace) {
      throw AppException.from(error, stackTrace);
    });
  }

  @override
  Stream<List<Event>> getUserActivitiesStream(String userId) {
    return _firebaseService.getUserEventsStream(userId).handleError((error, stackTrace) {
      throw AppException.from(error, stackTrace);
    });
  }

  @override
  Future<List<Event>> getAllActivities() async {
    try {
      return await _firebaseService.getAllEvents();
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<List<Event>> getUserActivities(String userId) async {
    try {
      return await _firebaseService.getUserEvents(userId);
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<Event?> getActivity(int activityId) async {
    try {
      return await _firebaseService.getEvent(activityId);
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<void> createActivity(Event activity) async {
    try {
      await _firebaseService.addEvent(activity);
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<void> updateActivity(Event activity) async {
    try {
      await _firebaseService.updateEvent(activity);
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<void> deleteActivity(int activityId) async {
    try {
      await _firebaseService.deleteEvent(activityId);
    } catch (e, s) {
      throw AppException.from(e, s);
    }
  }

  @override
  Future<void> joinActivity(int activityId, String userId) async {
    try {
      final event = await _firebaseService.getEvent(activityId);
      if (event == null) {
        throw AppException(
          type: AppExceptionType.notFound,
          message: '活动不存在',
        );
      }

      if (event.participantIds.contains(userId)) {
        return; // 已经加入
      }

      final updatedEvent = event.copyWith(
        participantIds: [...event.participantIds, userId],
        participants: event.participants + 1,
        isUserParticipating: true,
      );

      await _firebaseService.updateEvent(updatedEvent);
    } catch (e, s) {
      if (e is AppException) rethrow;
      throw AppException.from(e, s);
    }
  }

  @override
  Future<void> leaveActivity(int activityId, String userId) async {
    try {
      final event = await _firebaseService.getEvent(activityId);
      if (event == null) {
        throw AppException(
          type: AppExceptionType.notFound,
          message: '活动不存在',
        );
      }

      if (!event.participantIds.contains(userId)) {
        return; // 本来就没加入
      }

      final updatedParticipantIds = event.participantIds.where((id) => id != userId).toList();
      final updatedEvent = event.copyWith(
        participantIds: updatedParticipantIds,
        participants: (event.participants - 1).clamp(0, event.participants),
        isUserParticipating: false,
      );

      await _firebaseService.updateEvent(updatedEvent);
    } catch (e, s) {
      if (e is AppException) rethrow;
      throw AppException.from(e, s);
    }
  }
}
