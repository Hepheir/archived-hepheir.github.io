---
title: "이진 검색 (Binary search)"
categories:
  - "Study"
  - "Algorithm"
---

이진 검색은 오름차순으로 정렬된 리스트에서 특정한 값의 위치를 찾는 알고리즘이다.

<!-- more -->

## 설명

### 원리

이진 검색의 원리는 오름차순으로 정렬된 리스트에서 임의의 구간을 정하고, 구간 내에서 중간값을 선택하여, 중간값과 찾고자 하는 값의 대소를 비교하는 방식이다.

구간에서 선택한 중간값이 찾고자 하는 값보다 크면 중간값은 다음구간의 최대값이 되며, 작으면 그 값은 다음구간의 최소값이 된다.

### 장단점

검색이 반복됨에 따라 찾고자 하는 값을 찾을 확률이 2배가 되기에 속도가 빠르다는 장점이 있지만,
검색 원리상 정렬된 리스트에서만 유효하다는 단점이 있다.

## 구현

아래의 코드는 C언어를 통해 구현한 이진 검색 알고리즘이다.

이진 검색 알고리즘을 이용하여 배열에서 목표값이 위치한 인덱스 번호를 반환한다.
만약, 찾고자 하는 값이 없을 경우 `-1` 을 반환한다.

### 재귀적으로 구현

```c
int binarySearchRecursive(int A[], int target, int low, int high) {
    int mid;
    if (high < low)
        return -1; // not found

    mid = (low + high) / 2;

    if (A[mid] > target)
        return binarySearchRecursive(A, target, low, mid-1);
    else if (A[mid] < target)
        return binarySearchRecursive(A, target, mid+1, high);
    else
        return mid; // found
}
```

### 반복문으로 구현

```c
int binarySearch(int A[], int low, int high, int target) {
    int mid;
    while (low <= high) {
        mid = (low + high) / 2;

        if (A[mid] == target)
            return mid; // found
        if (A[mid] > target)
            high = mid-1;
        else
            low = mid+1;
    }
    return -1; // not found
}
```

## 시간 복잡도

리스트의 크기가 $N$, 목표값을 찾기까지 검색한 횟수가 $S$라고 할 때, 다음의 관계가 성립한다.
<sub>($log_2{N}$인 이유는 검색이 반복됨에 따라 목표값을 찾을 확률이 두 배로 증가하기 때문)</sub>

$$ S \propto \log_2{N} $$

이때, 검색 횟수 $S$는 곧 프로그램의 수행 시간과 비례한다고 볼 수 있기 때문에, 이진 검색의 시간 복잡도는 Big-O 표기법으로 아래와 같이 표현할 수 있다.

$$ O(\log{N}) $$

## 증명

이진 검색 알고리즘의 정당성은 귀납법의 일종인 **반복문 불변식** 기법을 통하여 증명할 수 있다.

### 반복문 불변식 (Loop invariant)

반복문 불변식이란 반복문 속에서 각 반복 전과 후에도 참인 사실이 변하지 않는 속성을 말한다.[^1]

[^1]: 위키백과에서 다음 문장을 참조 "In computer science, a loop invariant is a property of a program loop that is true before (and after) each iteration."

### 알고리즘 분석

반복문을 사용하여 구현한 이진 검색 알고리즘을 분석해보자.

* 목표: 크기가 $n$인 리스트 $A_{0, 1, \cdots , n-1}$에서 $x$의 위치를 찾는다.
* 초기 조건:
  * $A$는 오름차순으로 정렬되어 있다.
  * 이때, $A_{-1}=-\infty, A_{n}=\infty$ 라고 가정한다.
* 결과: $A_{i-1} < x \leq A_{i}$ 인 $i$를 반환한다.

이때, 반복문 불변식을 다음과 같이 지정한다.

1. $low < high$
2. $A_{low} < x \leq A_{high}$

```c
int binarySearch(int A[], int n, int x) {
    int mid;
    int low = -1;
    int high = n;
    // 불변식은 여기에서 성립해야 한다.
    //   low < high
    //   A[low] < x && x <= A[high]
    while (low+1 < high) {
        mid = (low + high) / 2;
        if (A[mid] < x)
            low = mid;
        else
            high = mid;
        // 불변식은 여기에서도 성립해야 한다.
    }
    return high;
}
```

만약 위 코드에서 `while`문이 종료 될때까지 반복문 불변식이 계속 성립했다면, 아래의 사실을 알 수 있다.

* $low + 1 = high$:
  1. `while`문이 종료되었으므로, $low+1 \geq high$[^2].
  2. 불변식에 의해 $low < high$
  3. $\therefore low+1 = high$
* $A_{low} < x \leq A_{high}$: 불변식과 같음.

[^2]: `low+1 < high`가 성립하지 않으므로.

### 초기 조건

`while` 문이 시작할 $low$와 $high$는 초기값 $-1$과 $n$으로 초기화된 상태이다.
(단, $low, high, n$은 정수이다.)

* 만약 $n \leq 0$이면, `while`문을 건너뛰므로 '불변식1'은 항상 성립한다.
* $A_{-1} = -\infty$ 이고 $A_{n} = \infty$ 라고 가정하므로 '불변식2' 항상 성립한다.


## 참고 문헌

* 알고리즘 문제 해결 전략 1. 구종만, 2012. 인사이트. p.121-125.
* <https://ko.wikipedia.org/wiki/이진_검색_알고리즘>
* <https://en.wikipedia.org/wiki/Loop_invariant>
