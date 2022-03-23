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
