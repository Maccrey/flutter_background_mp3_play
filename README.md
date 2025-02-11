# Flutter White Noise Player

백그라운드에서 실행 가능한 화이트노이즈 플레이어 Flutter 앱입니다.

## 주요 기능

- 다중 오디오 동시 재생
- 백그라운드 재생 지원
- 각 오디오별 볼륨 컨트롤
- 8가지 화이트노이즈 사운드 제공:
  - Cafe
  - Rain
  - Wind
  - Fire
  - Wind Chime
  - Stream
  - Wave
  - Bird

## 기술 스택

- Flutter Sound: 백그라운드 오디오 재생
- Riverpod: 상태 관리
- Path Provider: 임시 파일 관리

## 설치 요구사항

### iOS

Info.plist에 다음 권한을 추가:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### Android

AndroidManifest.xml에 다음 권한을 추가:

```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

## 프로젝트 구조

```
lib/
  ├── model/
  │   └── audio_model.dart      # 오디오 모델 정의
  ├── services/
  │   └── audio_service.dart    # 오디오 재생 서비스
  ├── view/
  │   └── whitenoise_player_screen.dart  # UI 구현
  └── viewmodel/
      └── audio_viewmodel.dart  # 비즈니스 로직
```

## 사용 방법

1. 프로젝트 클론:

```bash
git clone [repository-url]
```

2. 종속성 설치:

```bash
flutter pub get
```

3. 앱 실행:

```bash
flutter run
```

## 라이선스

MIT License
