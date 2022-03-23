---
title: "[VS Code Extension] Jekyll N Hyde 개발 일지 (v0.0.1)"
categories:
- "Side Project"
tags:
- "Visual Studio Code"
- "Visual Studio Code Extension"
excerpt: "Jekyll을 이용하는 GitHub Pages 블로그를 관리하면서 포스트를 관리하는 것이 굉장히 불편하다고 느꼈습니다. 때 마침, Visual Studio Code의 확장프로그램을 한 번 제작해보고 싶었기에 Jekyll의 포스트 관리 메커니즘을 편리하게 보강해줄 확장을 개발해보기로 하였습니다."
---

![Jekyll N Hyde - icon](https://github.com/Hepheir/vscode-jekyll-n-hyde/blob/v0.0.1/images/icon.png?raw=true)

"**Jekyll N Hyde**"는 Visual Studio Code 전용 확장 프로그램으로, Jekyll 을 사용하는 프로젝트에서 간결하게 포스트를 관리할 수 있도록 해주는 확장프로그램입니다.

[>> Jekyll N Hyde 저장소](https://github.com/Hepheir/vscode-jekyll-n-hyde)

[>> Jekyll N Hyde Microsoft 마켓플레이스](https://marketplace.visualstudio.com/items?itemName=Hepheir.jekyll-n-hyde)

## Jekyll

많은 [Jekyll](https://jekyllrb.com/) 사용자들은 카테고리 기능을 활용하고 있습니다. 머릿말의 `category` 혹은 `categories` 속성을 이용하면 포스트들을 체계적으로 관리할 수 있고, 독자들로 하여금 관심있는 주제의 포스트를 찾기 쉽게 해주죠. 하지만 블로그 관리자의 입장에서 보면, Jekyll 디렉터리 구조상에서 카테고리를 이용하여 post와 draft를 관리한다는 것은 상당히 번거로운 일입니다.

저 또한 Jekyll을 이용하는 GitHub Pages 블로그를 관리하면서 포스트를 관리하는 것이 굉장히 불편하다고 느꼈습니다. 때 마침, Visual Studio Code의 확장프로그램을 한 번 제작해보고 싶었기에 Jekyll의 포스트 관리 메커니즘을 편리하게 보강해줄 확장을 개발해보기로 하였습니다.

## View 영역

![Workbench Contribution](https://code.visualstudio.com/assets/api/extension-capabilities/extending-workbench/workbench-contribution.png)

Visual Studio Code의 UI 구조는 위와 같이 이루어져있습니다. 이 중, 접거나 펼칠 수 있는 노드들로 구성되어있는 Tree View는 디렉터리 구조를 표현하기에 가장 적합한 형태를 띄고 있습니다. 이 Tree View API를 이용하여 "카테고리별 포스트"를 보여주는 기능을 구현해보기로 했습니다.

[>> Tree View API 보기](https://code.visualstudio.com/api/extension-guides/tree-view)

## Jekyll API

[Jekyll](https://jekyllrb.com/) 공식 문서에 의하면, `site.categories[CATEGORY]`를 통해 각 카테고리별 포스트 목록에 접근할 수 있습니다. 물론 이는 liquid 템플릿 언어를 이용할 때 사용가능한 값이므로, TypeScript에서 사용할 수 있는지는 알 수 없습니다.

[npmjs.com](https://www.npmjs.com/search?q=jekyll)에서 Jekyll의 TypeScript 버전의 인터페이스 혹은 구현체가 있나 검색해보았지만 찾지 못했습니다. 직접 [jekyllrb.com](https://jekyllrb.com/docs/variables/)에 기재된 설명을 보고 `site`와 `page`를 이루는 변수들을 담은 인터페이스를 작성하였습니다.

[>> `jekyll.d.ts` 파일 보기](https://github.com/Hepheir/vscode-jekyll-n-hyde/blob/v0.0.1/src/%40types/jekyll.d.ts)
