import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'content_scaffold.dart';
import '../services/ble_scanner.dart';

/// 주변 BLE 기기를 스캔해 목록으로 보여주는 페이지.
///
/// 버튼을 눌러 스캔을 시작/중지하며, 스캔 결과는 이름/식별자/RSSI 로 표시된다.
class BleScanPage extends StatefulWidget {
  const BleScanPage({super.key});

  @override
  State<BleScanPage> createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  // BLE 로직은 서비스에 위임한다.
  final BleScanner _scanner = BleScanner();

  // 화면 상태
  List<ScanResult> _results = [];
  bool _isScanning = false;

  // 스트림 구독 (dispose 에서 반드시 해제 → after-dispose 예외/누수 방지)
  StreamSubscription<List<ScanResult>>? _resultsSub;
  StreamSubscription<bool>? _scanningSub;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) debugPrint('[BleScanPage] initState - 스트림 구독 시작');

    // 스캔 결과 구독 → 목록 갱신
    _resultsSub = _scanner.scanResults.listen((results) {
      if (!mounted) return; // 폐기된 State 에 setState 호출 방지
      setState(() => _results = results);
    });

    // 스캔 진행 상태 구독 → 버튼/인디케이터 토글
    _scanningSub = _scanner.isScanning.listen((scanning) {
      if (!mounted) return;
      setState(() => _isScanning = scanning);
    });
  }

  @override
  void dispose() {
    // 구독 해제 + 진행 중 스캔 중지 (메모리 누수 및 after-dispose 예외 방지)
    if (kDebugMode) debugPrint('[BleScanPage] dispose - 구독 해제 및 스캔 중지');
    _resultsSub?.cancel();
    _scanningSub?.cancel();
    _scanner.stopScan();
    super.dispose();
  }

  /// 스캔 버튼 핸들러: 진행 중이면 중지, 아니면 시작.
  Future<void> _toggleScan() async {
    if (_isScanning) {
      await _scanner.stopScan();
      return;
    }

    // 시작 시 실패하면 메시지를 스낵바로 표시
    final error = await _scanner.startScan();
    if (error != null && mounted) {
      if (kDebugMode) debugPrint('[BleScanPage] 스캔 시작 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentScaffold(
      title: 'BLE Scan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 스캔 시작/중지 버튼 + 진행 인디케이터
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _toggleScan,
                icon: Icon(_isScanning ? Icons.stop : Icons.search),
                label: Text(_isScanning ? '스캔 중지' : '스캔 시작'),
              ),
              const SizedBox(width: 12),
              if (_isScanning)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // 스캔 결과 목록 (비어 있으면 안내 문구)
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('검색된 기기가 없습니다'))
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final r = _results[index];
                      // platformName 이 비어 있으면 대체 문구 표시
                      final name = r.device.platformName.isNotEmpty
                          ? r.device.platformName
                          : '(이름 없음)';
                      return ListTile(
                        title: Text(name),
                        subtitle: Text(r.device.remoteId.str),
                        trailing: Text('${r.rssi} dBm'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
