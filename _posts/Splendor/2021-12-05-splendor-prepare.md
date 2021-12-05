---
title:  "[Splendor] 사용할 기술 스택 정하기"
excerpt: "스플렌더 프로젝트를 기획해보자."

categories:
- "Splendor"

tags:
- [Project, Splendor]

toc: true
toc_sticky: true

date: 2021-12-05
last_modified_at: 2021-12-05

hidden: true
---

스플렌더 프로젝트를 기획해보자.

* * *

# ✏️ 서론

유명 보드게임 "스플렌더"의 모작을 구현해보려고 한다.

![스플렌더 보드게임 커버](https://upload.wikimedia.org/wikipedia/en/2/2e/BoardGameSplendorLogoFairUse.jpg)

## 🎲 계기

온라인으로 [도미니언](http://dominion.games) 게임을 플레이 할 수 있는 서비스가 있어 친구들과 즐기던 중, 스플렌더도 온라인으로 함께 할 수 있으면 좋겠다고 생각하였다.


* * *

# ✏️ 계획

온라인으로 서비스를 제공하는 것이 목표이므로 "클라이언트"와 "서버"를 구현해야 한다.


## 🎲 클라이언트

클라이언트는 `React.js`를 사용하여 구현할 것이다. 컴포넌트마다 각기 다른 상태를 갖고, 카드·토큰과 같이 인스턴스 형태로  컴포넌트들이 존재하므로, `React.Component`를 이용하여 이를 구현하는 것이 좋을 것 같다.


## 🎲 서버

서버는 Rest API와 Socket.io를 통해 클라이언트와 상호작용 할 수 있는 마이크로 웹 서버로 구현하고자 한다.

### 서버 기술 스택

사용할 기술 스택 후보로는 다음의 두 가지 조합을 떠올렸다.

| 언어        | 라우터    | 데이터베이스 |
| ----------- | --------- | ------------ |
| **Node.js** | *Express* | *MongoDB*    |
| **Python3** | *Flask*   | *Sqlite3*    |


### Node.js를 선택하지 않은 이유

Node.js를 사용하는 경우, 클라이언트와 합쳐 MERN 스택이 완성 되고, Javascript 문법만 숙지하면 되기에 편할 수 있다. 그러나 평소에 SQL 문법을 공부해보고자 하는 욕구가 있었고, 무엇보다 최근 코딩 테스트 중 Python 언어로 지원하다 보면 개발과제에서 Flask-sqlite3 조합을 사용하는 경우가 자주 있었기에, Python3으로 서버를 구현해보려 한다.
