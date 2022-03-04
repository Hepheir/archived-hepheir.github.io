---
title: "[GitHub Blog] 개별 카테고리 페이지를 자동으로 생성하게 하였다"
categories:
- "Blog Dev"
---

2022년 3월 2일, 블로그에 카테고리 페이지를 자동으로 생성하는 기능을 추가하였다.

레이아웃은 Minimal Mistakes 테마가 기본으로 제공하는 `_layout/category.html`를 사용하였다. (개별 카테고리 페이지 레이아웃이 Minimal Mistakes에서 기본으로 제공하는 레이아웃 중에 있었다.)

## 수동으로 페이지 만들기

처음부터 자동으로 카테고리 페이지를 생성하게 한 것은 아니었다. 각 카테고리별로 페이지를 따로 만들어주었다. 당시 디렉터리 구조를 보면 아래와 같았다.

```text
.
├── _config.yml
├── _pages/
│   ├── categories/
│   │   │   # 카테고리 별 페이지들
│   │   ├── algorithm.md
│   │   ├── baekjoon-online-judge.md
│   │   ├── blog-dev.md
...
        └── macos.md
│   ├── 404.md
│   └── categories.md
...
```

각 카테고리 페이지를 만들 때에는 `_pages/categories/카테고리_명(slugify).md` 파일을 생성하고, 각 파일마다 Front matter의 `layout` 속성에 `category`를 부여했다.

```yml
---
title: Blog Dev
permalink: /categories/blog-dev/
layout: category
---
```

이렇게 생성한 페이지는 **빈 페이지**이다. 그 이유는 아래 두 파일을 살펴보면 알 수 있다.

* [_layouts/category.html](https://github.com/mmistakes/minimal-mistakes/blob/master/_layouts/category.html)
* [_includes/posts-category.html](https://github.com/mmistakes/minimal-mistakes/blob/master/_includes/posts-category.html)


두 페이지가 주고받는 `taxonomy` 라는 속성에 주목해보자. 이 속성은 `_includes/posts-category.html`에서 `site.categories[include taxonomy]` 라는 구문을 통해 카테고리를 선택하는데 사용된다. 이 속성을 생성할 페이지의 머릿말에 추가해야 한다는 것을 알 수 있다.

```yml
# _pages/categories/blog-dev.md

---
title: Blog Dev
permalink: /categories/blog-dev/
layout: category
taxonomy: Blog Dev
---

깃헙 블로그 관련 포스트 모음입니다.

```

위와 같이 파일을 생성해두고 다시 `bundle exec jekyll serve` 명령을 실행해보면 지정한 주소에 카테고리 페이지가 생성되어 있음을 확인할 수 있다.

단, 이런식으로 **각 카테고리 페이지를 직접 만들어야 한다는건 상당히 번거로운 일이다**. 만약 새로운 카테고리가 생기거나 없어진다고 하면, 내가 항상 위의 카테고리 페이지들을 함께 관리해낼 수 있을까... 난 자신이 없다.

## 페이지 생성을 자동화할 방법 모색

내가 코딩을 좋아하는 이유는, 무지성 단순 반복 작업을 절대 귀찮아하기 때문이다. 정말 극혐이다. 그래서 카테고리 페이지 생성역시 자동화 할 방법이 없나 구색하기 시작했다.

처음에는 liquid 템플릿 언어를 이용하면 될 거라는 생각으로 시작했다. 하지만 liquid 템플릿 언어를 공부하면 할 수록 liquid의 한계를 깨달았고 다른 방법을 모색해야 한다는 결론에 다다랐다.

그러던 중, Jekyll의 공식문서에서 Generator 라는 것을 알게되었다.

### Jekyll::Generator

<https://jekyllrb.com/docs/plugins/generators/>

> * Jekyll이 사용자 규칙에 따라 추가 컨텐츠를 생성하길 원한다면, generator를 만들어 사용할 수 있다.
> * 기본적으로, Jekyll은 "_plugins/" 디렉토리에 위치하는 generator를 찾아본다.

사용자 플러그인을 통해 페이지를 생성할 수 있고, 이는 Ruby 언어로 작성하는 모양이다.

위 문서에서 소개하는 새로운 페이지를 생성하는 generator 예제를 베이스로 하여 새 플러그인을 작성하기로 하였다.

```ruby
module SamplePlugin
  class CategoryPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.categories.each do |category, posts|
        site.pages << CategoryPage.new(site, category, posts)
      end
    end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class CategoryPage < Jekyll::Page
    def initialize(site, category, posts)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = category         # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
      @ext      = '.html'      # the extension.
      @name     = 'index.html' # basically @basename + @ext.

      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
        'linked_docs' => posts
      }

      # Look up front matter defaults scoped to type `categories`, if given key
      # doesn't exist in the `data` hash.
      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, :categories, key)
      end
    end

    # Placeholders that are used in constructing page URL.
    def url_placeholders
      {
        :category   => @dir,
        :basename   => basename,
        :output_ext => output_ext,
      }
    end
  end
end
```

### 빠른 Ruby 언어 공부

우선 Ruby 언어를 간단히 공부할 필요가 있었다. 감으로 알 수 있는 건 다음과 같았다.

> * 모듈과 클래스 개념은 이미 어느정도 익숙하다.
> * `<` 기호는모종의 대입문으로 쓰이는 것 같다. (`C++`의 `cin > variable` 처럼 연산자 오버라이드일 수도 있음에 유의.)
> * end로 블럭을 닫는 문법은 쉘 스크립트, Basic 언어 등에서 겪어보아 익숙한 것 같다.
> * `Jekyll::Generator`의 `::` 은 C++의 namespace 개념과 비슷한 것 같다.
> * 주석이 친절해 각 함수의 역할은 대충 알 것 같다.

이어서 잘 모르겠는것들을 하나씩 찾아보았다.

> * `@`가 변수명 앞에 붙으면, 이는 인스턴스 변수임을 의미한다.[(참조)](https://stackoverflow.com/questions/14319347/variables-in-ruby-on-rails)
> * `=>` 연산자는 해쉬(딕셔너리) 자료형의 키에 값을 할당할 때 사용하는 연산자이다. [(참조)](https://stackoverflow.com/questions/6393872/what-is-the-equals-greater-than-operator-in-ruby)

### 사용자 플러그인 작성

Ruby 언어를 어느정도 사용할 수는 있을 정도로 공부했다. 계속해서, 아래와 같이 사용자 플러그인을 필요에 맞게 손보았다.

```diff
@@ -1,4 +1,4 @@
- module SamplePlugin
+ module CategoryPageGeneratingPlugin
    class CategoryPageGenerator < Jekyll::Generator
      safe true

@@ -24,7 +24,11 @@ def initialize(site, category, posts)
      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
-       'linked_docs' => posts
+       'linked_docs' => posts,
+       'title' => category,
+       'layout' => 'category',
+       'permalink' => 'categories/:category/',
+       'taxonomy' => category,
      }

      # Look up front matter defaults scoped to type `categories`, if given key
```

이제 번거롭게 `_pages/categories/카테고리_명.md` 파일을 일일이 만들어주지 않아도 알아서 카테고리들이 생성된다!

...다만, 주소 패턴을 `'permalink' => 'categories/:category/'`로 해두어서 그런지, `/categories/Baekjoon%20Online%20Judge/`와 같이 못생긴 url encoded 주소로 부여되었다.

좀 더 깔끔한 slugified 스타일로 통일하고 싶어, Jekyll API를 조사해보다 관련 기능을 제공하는 메소드가 있는 것을 확인하여 코드를 조금 수정하였다.

* [`Jekyll::Utils#slugify`](https://www.rubydoc.info/gems/jekyll/Jekyll%2FUtils:slugify)

```diff
@@ -14,7 +14,7 @@ class CategoryPage < Jekyll::Page
    def initialize(site, category, posts)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
-     @dir  = category         # the directory the page will reside in.
+     @dir  = Jekyll::Utils.slugify(category)         # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
```

### 새로운 카테고리 페이지 주소를 적용

다음은 새로 생긴 변경사항들을 블로그 곳곳에 적용하는 디테일을 보여줄 차례이다. 다행히 변경해야 할 곳은 몇 군데 밖에 못 발견했다.

* 사이드 바의 카테고리 리스트 하이퍼링크.
  * _includes/sidebar__categories.html
    {% raw %}
    ```diff
    @@ -13,7 +13,7 @@ <h3 class="nav__title" style="padding-left: 0;">
        {% for category in categories %}
        {% assign title = category[0] %}
        {% assign posts = category[1] %}
    -   {% capture url %}/categories/{{ title }}{% endcapture %}
    +   {% capture url %}/categories/{{ title | slugify }}{% endcapture %}
        <li>
            <a href="{{ url }}"{% if url == page.url %} class="active"{% endif %}>
            {{ title }}
    ```
    {% endraw %}
* 각 페이지의 Breadcrumbs 카테고리 하이퍼링크.
  * _includes/breadcrumbs.html
    {% raw %}
    ```diff
    @@ -1,6 +1,6 @@
        {% case site.category_archive.type %}
        {% when "liquid" %}
    -       {% assign path_type = "#" %}
    +       {% assign path_type = "" %}
        {% when "jekyll-archives" %}
            {% assign path_type = nil %}
        {% endcase %}
    ```
    {% endraw %}
    Breadcrumbs 는 조금 임시방편식으로 수정했다. 추후 기능 추가/제거 시 유의할 필요가 있다.

## GitHub Pages에 적용

나는 GitHub Pages를 이용하여 <https://hepheir.github.io/>에 블로그를 배포 하고 있다. 지금까지 만든 변경사항이 잘 적용되길 바라며 master 브랜치로 변경사항들을 Push하였다.

잠시 후, 정상적으로 Deploy가 완료되었다고 뜨길래 어디 카테고리 페이지들이 잘 만들어졌나 확인해보려 찾아보았으나, 그렇지 않았다. ...어째서? ㅠㅠ

찾아보니 GitHub Pages의 자동 빌드를 사용하면 GitHub Pages가 지정한 특정 플러그인들을 제외하고는 적용되지 않는다고 한다. 이 문제를 해결할 방법으로 나는 두 가지 방법을 찾았다.

1. 로컬 환경에서 직접 `bundle exec jekyll build`를 한 후, 빌드된 결과물을 업로드 하는 것.
2. GitHub Action을 통해 사용 플러그인에 제한이 없는 `jekyll`로 페이지를 빌드하도록 설정하는 것.

### GitHub Action을 사용하여 빌드

그럼 바로 GitHub Action을 통해 Jekyll 사이트를 빌드하도록 설정해보자.

* [GitHub Action :: Jekyll Deploy Action](https://github.com/marketplace/actions/jekyll-deploy-action)

설치방법도 매우 간단하다. 다음의 파일을 새로 작성하면 된다.

* [.github/workflows/build-jekyll.yml](https://github.com/marketplace/actions/jekyll-deploy-action#-usage)

새로 만든 `build-jekyll.yml`을 푸쉬하고 경과를 지켜보면, 새로 생성된 `build_and_deploy` workflow에 의해 `gh-pages`라는 원격 브랜치가 새로 생성되고, 해당 브랜치에 빌드된 사이트가 있음을 확인 할 수 있다.

마지막으로, 레포지토리의 \[Settings - Pages - Source\]로 이동하여 GitHub Pages가 호스팅할 파일들이 위치한 Branch로 `gh-pages`를 지정해준다.

## 마무리

이로서 개별 카테고리 페이지를 자동으로 생성하는 소스코드를 추가하고 적용하는 일련의 과정이 끝났다. <https://hepheir.github.io/> 에서도 개별 카테고리 페이지들이 정상적으로 출력되는 걸 확인했다. 이 포스트에서 다룰 내용은 여기서 잘 끝났다.
