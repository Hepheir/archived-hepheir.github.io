---
title:  "[Splendor] 사이드 프로젝트 : 스플렌더"

categories:
  - "Splendor"

tags:
  - "side-project"

toc: true
toc_sticky: true

date: 2021-12-16
last_modified_at: 2021-12-18
---

클론코딩중이던 사이드 프로젝트: '스플렌더'를 소개합니다.

<!-- more -->

## 서론

![](/assets/images/2021-12-17-splendor-legacy-development.png)

지난 3개월간<sup>[[1]](#fn-1)</sup> 스플렌더 &lt;기본판&gt;을 클론코딩하고 있었다.

그리고 최근 &lt;확장판:찬란한 도시&gt;까지 목표범위를 넓혔는데,
기존의 설계 및 코드로는 표현이 어려운 부분들이 생겼다.

DB와 백엔드(BE) 서버의 재설계가 필요해졌다.

## 기본판 구현에 사용하던 DB 구조

<!--

> <details><summary>DB 구조를 간단히 표현한 표 보기</summary>
> <br>
>
> | users            | games       | cards      | gamecards   | tiles      | gametiles   | coins  | gamecoins   |
> | ---------------- | ----------- | ---------- | ----------- | ---------- | ----------- | ------ | ----------- |
> | id               | id          | id         | id          | id         | id          | id     | id          |
> | username         | host_id     | score      | card_id     | score      | tile_id     | gem_id | coin_id     |
> | game_id          | title       | background | owner_id    | background | owner_id    |        | owner_id    |
> | next_player      | min_players | costs      | is_selected | costs      | is_selected |        | is_selected |
> | is_online        | max_players | level      |             |            |             |        |             |
> | is_player        | is_ingame   | bonus      |             |            |             |        |             |
> | is_playing       |             |            |             |            |             |        |             |
> | is_round_starter |             |            |             |            |             |        |             |
>
> 기존에는 너무 비효율적인 구조
>
> </details>

-->

기존에는 **보석토큰**은 오직 보석의 종류와 그 수량으로만 구분하고,
각 **개발카드**와 **귀족타일**의 속성들을 다음과 같이 구분하였다.

![](/assets/images/2021-12-16-legacy-properties.png)

### 개발 카드의 경우

![개발 카드](/assets/images/2021-12-18-development-card.png)
![개발 카드 배경](/assets/images/2021-12-18-development-card-backflip.png)

* 레벨 (level): 구매 난이도. 카드가 놓일 행을 구분하는데 사용.
* 승점 (score)
* 보너스 (bonus): 보석종류를 나타내는 문자<sup>[[2]](#fn-2)</sup>
* 배경 (background)
* 비용 (cost): 필요한 보석으로 이루어진 문자열<sup>[[3]](#fn-3)</sup>

### 귀족 타일의 경우

![귀족 타일](/assets/images/2021-12-18-noble-tile.png)
![귀족 타일](/assets/images/2021-12-18-noble-tile-backflip.png)

* 승점 (score)
* 배경 (background)
* 비용 (cost): 필요한 보석으로 이루어진 문자열<sup>[[3]](#fn-3)</sup>

## 확장하며 생긴 문제

위의 구조으로는, 개발타일과 귀족타일 외의 컴포넌트를 다루기가 난해하다.

새로운 종류의 컴포넌트가 생길때마다 새로운 테이블의 스키마를 설계해야하고,
개발카드를 구매하기 위한 방식<sup>[[4]](#fn-4)</sup>과
귀족타일을 구매하기 위한 방식<sup>[[5]](#fn-5)</sup>이
매우 제한적이다.

하지만 확장판에는 다양한 신규 요소들이 등장한다. 🥲

### 새로운 컴포넌트 등장

![](/assets/images/2021-12-18-splendor-expansion-component.png)

우선 새로운 컴포넌트들이 등장하였다.

* 대도시 타일 <sup>(대도시)</sup>
* 문장 토큰 <sup>(교역소)</sup>
* 동방교역로 게임판 <sup>(교역소)</sup>
* 동방무역 개발 카드 <sup>(동방무역)</sup>
* 성채 <sup>(성채)</sup>


### 더 다양해진 속성

![](/assets/images/2021-12-18-splendor-cities-city-tile-example.png)
* 도시 타일을 획득하기 위한 **최소 요구 승점**이 추가되었다.
* 요구되는 보너스 카드의 종류 중 아무 종류나 허용하는 경우가 생겼다.

![](/assets/images/2021-12-18-splendor-the-orient-card-description.png)


* 비용 종류로 **카드 보너스 지불**이 추가되었다.
* 보너스 종류로 **황금 토큰 두 개**가 추가되었다.
* 보너스 종류로 **보따리**가 추가되었다
* 보너스 종류로 **더블 보석 토큰**이 추가되었다.
* ...

### 확장에 따라 달라지는 게임 진행

확장의 종류에 따라:
* 게임의 종료 조건이 변경된다. <sup>(대도시)</sup>
* 카드의 구매 조건이 변경된다. <sup>(동방무역, 성채)</sup>
* 카드 구매 시 취할 수 있는 행동이 늘어난다. <sup>(교역로, 동방무역, 성채)</sup>
* ...

## 결론

앞서 소개한 점들을 보며 느낀 것은 '리엔지니어링이 필요하다'는 것이었다.

DB의 설계, 게임 로직 재작성은 굉장한 부담이 된다.

<sub>하지만 스플렌더는 기간이 정해지지 않은 사이드 프로젝트이기도 하고...</sub>

무엇보다도 *"이왕 시작한 거, 조금 돌아가더라도 제대로 만들어 보자."*는 생각이 크다.

## 주석

<span id="fn-1">[1] 8월 말부터 시작한 사이드 프로젝트이다.</span>

<span id="fn-2">[2] ex: `"D"` = (다이아몬드), `"S"` = (사파이어), `"R"` = (루비)</span>

<span id="fn-3">[3] ex: `"DDSSR"` = (다이아몬드x2 + 사파이어x2 + 루비x1)</span>

<span id="fn-4">[4] "선 할인 - 후 지불": 가지고 있는 카드 보너스 만큼 할인받고, 남은 가격만큼의 코인을 지불</span>

<span id="fn-5">[5] "보너스 소유": 일정 수량 이상의 보너스를 가지고 있어야 함.</span>
