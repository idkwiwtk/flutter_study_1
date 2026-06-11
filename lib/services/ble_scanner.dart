import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// BLE 스캔 관련 로직을 담당하는 서비스.
///
/// UI(위젯)는 이 서비스의 스트림을 구독하고 start/stop 만 호출한다.
/// 모든 콘솔 로그는 개발용이며, 배포(release) 빌드에서는 출력되지 않도록
/// `kDebugMode` 로 감싼다.
class BleScanner {
  /// 스캔 결과 스트림 (UI 가 구독해서 목록을 갱신)
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  /// 스캔 진행 상태 스트림 (UI 의 버튼/인디케이터 토글에 사용)
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  /// 스캔을 시작한다.
  ///
  /// 성공하면 `null` 을, 실패하면 사용자에게 보여줄 메시지 문자열을 반환한다.
  /// (지원 여부 → 어댑터 상태 → 실제 스캔 순서로 안전하게 진행)
  Future<String?> startScan() async {
    try {
      // 1) 하드웨어가 BLE 를 지원하는지 확인
      if (await FlutterBluePlus.isSupported == false) {
        if (kDebugMode) debugPrint('[BleScanner] BLE 미지원 디바이스');
        return 'BLE를 지원하지 않는 기기입니다';
      }

      // 2) 블루투스 어댑터가 켜져 있는지 확인 (현재 상태 1회 조회)
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        if (kDebugMode) debugPrint('[BleScanner] 블루투스 꺼짐: $adapterState');
        return '블루투스를 켜주세요';
      }

      // 3) 스캔 시작 (10초 후 자동 종료)
      if (kDebugMode) debugPrint('[BleScanner] 스캔 시작');
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      return null;
    } catch (e) {
      // 어떤 예외든 UI 로 전파하지 않고 메시지로 변환해 반환
      if (kDebugMode) debugPrint('[BleScanner] 스캔 오류: $e');
      return '스캔 중 오류가 발생했습니다: $e';
    }
  }

  /// 진행 중인 스캔을 중지한다.
  Future<void> stopScan() async {
    try {
      if (kDebugMode) debugPrint('[BleScanner] 스캔 중지');
      await FlutterBluePlus.stopScan();
    } catch (e) {
      // 중지 실패는 치명적이지 않으므로 로그만 남긴다.
      if (kDebugMode) debugPrint('[BleScanner] 스캔 중지 오류: $e');
    }
  }
}
