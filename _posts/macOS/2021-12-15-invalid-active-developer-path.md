---
title:  "[macOS] OS 업데이트 후 개발도구 오류 (xcrun: error: invalid active developer path)"
excerpt: "macOS Monterey로 업데이트 하고나니 생긴 개발도구 오류를 해결해보자."

categories:
  - "macOS"

tags:
  - "Xcode"
  - "Command Line Interface"
  - "macOS Monterey"

toc: true
toc_sticky: true

date: 2021-12-15
last_modified_at: 2021-12-15
---

## macOS 12.1로 업데이트

macOS의 Monterey(12.1) 업데이트가 출시된지 2일이 지났다<sup>[\[1\]](#fn-1)</sup>.

뉴스나 유튜브에 OS 업데이트로 인해 소프트웨어적 결함이 생긴다는 반응이 크게 올라오지 않길래, 오늘 슬쩍 업데이트를 했다.

![macOS Monterey installed](/assets/images/2021-12-15-updated-to-monterey.png)

## Terminal에서 문제점 발견

1번의 재부팅 후 OS 업데이트가 끝났다.

새로운 기능들을 체크해보다, 곧 `git`이 정상적으로 동작하지 않음을 발견했다.

![](/assets/images/2021-12-15-can-not-run-git.png)


## 문제 원인

macOS의 터미널을 처음 사용할 때, 대부분 Xcode의 커맨드 라인 인터페이스(CLI)를 설치하고, 사용에 동의해야 터미널 쉘을 사용할 수 있었을 것이다.

`xcrun` 오류는 이 Xcode를 실행(run)하는 중에 발생한, 혹은 실행 할 수 없을 때 발생하는 오류이다.

## 문제 해결

이 문제는 다음의 명령을 쉘 터미널에서 실행하여 해결할 수 있다.

```shell
xcode-select --install
```

![Installing Xcode CLI](/assets/images/2021-12-15-xcode-install.png)

설치가 모두 완료되면, `xcrun`오류(invalid active developer path)가 더이상 발생하지 않는다.

![git is now accessible](/assets/images/2021-12-15-can-run-git.png)

* * *

<sub id="fn-1">[1] 12월 13일에 업데이트 됨. [\[참조\]](https://support.apple.com/en-us/HT212978)</sub>
