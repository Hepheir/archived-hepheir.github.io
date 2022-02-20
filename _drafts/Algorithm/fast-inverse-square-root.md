---
title: "고속 역 제곱근 (Fast Inverse Squre Root)"
categories:
  - "Algorithm"
---

> `i  = 0x5f3759df - ( i >> 1 );               // what the fuck?`

<!-- more -->

Clean Code의 4장 "주석" 챕터를 읽던 중, 불현듯 오래전에 보았던
역제곱근을 빠르게 구하는 함수의 `what the fuck?` 주석이 생각나서 이 포스트를 작성해본다.

## 개요

$$
\frac{1}{\sqrt{v}}
$$

이 포스트에서 소개할 고속 역 제곱근(Fast Inverse Square Root)은 IEEE 754 부동소수점 체계의 32비트 실수에 대한 제곱근의 역수를 계산하기 위한 알고리즘이다.


### 등장배경






## 코드

아래의 코드는 ["Quake III Arena"](https://en.wikipedia.org/wiki/Quake_III_Arena)[^1]에서 구현된 고속 역제곱근(fast inverse square root)

[^1]: 1999년 발매된 멀티플레이어 1인칭 슈팅 게임이다

```c
float Q_rsqrt( float number )
{
	long i;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

	return y;
}
```

## 알고리즘 설명
