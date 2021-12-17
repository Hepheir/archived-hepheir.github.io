---
title:  "[Splendor] 아키텍쳐 설계"
excerpt: "스플렌더의 아키텍쳐를 설계해보자."

categories:
  - "Splendor"

# tags:
#   - ""

toc: true
toc_sticky: true

date: 2021-12-16
last_modified_at: 2021-12-17
---

## 서론

![](/assets/images/2021-12-16-splendor-legacy-development.png)

지난 3개월간<sup>[[1]](#fn-1)</sup> 스플렌더 &lt;기본판&gt;을 클론코딩하고 있었다.

그리고 최근 &lt;확장판:찬란한 도시&gt;까지 목표범위를 넓혔는데,
기존의 설계 및 코드로는 표현이 어려운 부분들이 생겼다.

DB와 백엔드(BE) 서버의 재설계가 필요해졌다.

### &lt;기본판&gt; 구현에 사용하던 DB 구조

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

#### 개발카드의 경우
* 레벨 (level): 구매 난이도. 카드가 놓일 행을 구분하는데 사용.
* 승점 (score)
* 보너스 (bonus): 보석종류를 나타내는 문자<sup>[[2]](#fn-2)</sup>
* 배경 (background)
* 비용 (cost): 필요한 보석으로 이루어진 문자열<sup>[[3]](#fn-3)</sup>

#### 귀족타일의 경우
* 승점 (score)
* 배경 (background)
* 비용 (cost): 필요한 보석으로 이루어진 문자열<sup>[[3]](#fn-3)</sup>

## 확장하며 생긴 문제

위의 구조으로는, 개발타일과 귀족타일 외의 컴포넌트를 다루기가 난해해진다.

새로운 종류의 컴포넌트가 생길때마다 새로운 테이블의 스키마를 설계해야하고,
개발카드를 구매하기 위한 방식<sup>[[4]](#fn-4)</sup>과
귀족타일을 구매하기 위한 방식<sup>[[5]](#fn-5)</sup>이
매우 제한적이었다.

이러한 한계들은 확장판을 구현하는데 있어 큰 걸림돌이 되었다.

### 새로운 컴포넌트 등장

우선 새로운 컴포넌트들이 등장하였다.

* 대도시 타일 (대도시)
* 문장 토큰 (교역소)
* 동방교역로 게임판 (교역소)
* 동방무역 개발 카드 (동방무역)
* 성채 (성채)


### 더 다양해진 속성

개발카드가 갖는 속성이 다양해졌다.

* 비용 종류로 **최소 요구 승점**이 추가되었다.
* 비용 종류로 **카드 보너스 지불**이 추가되었다.
* 보너스 종류로 **황금 토큰 두 개**가 추가되었다.
* 보너스 종류로 **보따리**가 추가되었다
* 보너스 종류로 **보석 토큰 두 개**가 추가되었다.
* ...

### 확장에 따라 달라지는 게임 진행

확장의 종류에 따라:
* 게임의 종료 조건이 변경된다. (대도시)
* 카드의 구매 조건이 변경된다. (동방무역, 성채)
* 카드 구매 시 취할 수 있는 행동이 늘어난다. (교역로, 동방무역, 성채)
* ...

## 새로운 아키텍쳐 설계




### 다이어그램

![database diagram](/assets/images/2021-12-16-splendor-database-relationship.png)

최소한 필요하다고 생각되는



* * *

## 주석

<span id="fn-1">[1] 8월 말부터 시작한 사이드 프로젝트이다.</span>

<span id="fn-2">[2] ex: `"D"` = (다이아몬드), `"S"` = (사파이어), `"R"` = (루비)</span>

<span id="fn-3">[3] ex: `"DDSSR"` = (다이아몬드x2 + 사파이어x2 + 루비x1)</span>

<span id="fn-4">[4] "선 할인 - 후 지불": 가지고 있는 카드 보너스 만큼 할인받고, 남은 가격만큼의 코인을 지불</span>

<span id="fn-5">[5] "보너스 소유": 일정 수량 이상의 보너스를 가지고 있어야 함.</span>
