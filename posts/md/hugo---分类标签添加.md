---
title: hugo--分类标签添加
date: '2017-12-30'
categories: hugo
---



### 分类标签添加

找到single.html的页面 添加，从 http://fontawesome.io 下载文件 解压暂时只需要`css/font-awesome.min.css` 和`fontawesome-webfont.woff2` 引入到head.html中，



##### 把下面的代码添加到single.html

```html
{{ with .Params.tags }} {{ if ge (len .) 1 }}
<div class="article-headline">
    <i class="fa fa-tags"> </i><!-- end-->
            {{ range . }}
        <a href="{{ $.Site.BaseURL }}tags/{{ . | urlize }}">{{ . }}</a> {{ end }}
    </div>
    {{ end }} {{ end}}
```

##### 下面对content\下文件夹的引入以及添加相关信息

```html
<!-- 这个是content\下的post文件夹 -->
{{ if eq .Section "post" }}
<div class="article-date">{{ with .Params.Author }} {{.}} &middot; {{ end }} 字数共{{ .WordCount }} &minus;&minus;{{ .Date.Format "2006/01/02" }} </div>
{{ end }}
<!-- 结束 -->


<!-- 这个是content\下的test文件夹-->
{{ if eq .Section "test" }}
<div class="article-date">{{ with .Params.Author }} {{.}} &middot; {{ end }} 字数共{{ .WordCount }} &minus;&minus;{{ .Date.Format "2006/01/02" }} </div>
{{ end }}
<!-- 结束 -->
```
### 2、也可以在导航栏添加一个分类汇总页面

```toml
    [[menu.main]]
    name = "Tag"
    url = "/tags/"
```

把terms.html文件拷贝到\layouts\ _default下

```html
<meta charset="utf-8"> {{ partial "header.html" . }}
<main class="content" role="main">
     <article class="article">
    <div class="tags0">
        <h1 class="tags1">分类标签有{{ len .Data.Terms }}个</h1>

        {{ $data := .Data }} {{ range .Data.Terms.ByCount }} {{ $termLink := printf "/%s/%s/" $data.Plural .Term | urlize }}
        <h2 class="tags2">
            <a href="{{ $termLink }}">{{ .Term }}</a> 有{{ .Count }}篇
        </h2>
        <div class="tags3">
            <ul>
            {{ range .Pages | first 5 }}
            <li><a href="{{ .Permalink }}" class="tags4">{{ .Title }}</a></li>
            {{ end }} {{ if gt (len .Pages) 5 }}
            <li><a href="{{ $termLink }}" class="tags4">……</a></li>
            {{ end }}
             </ul>
        </div>

        {{ end }}
    </div>
      </article>
</main>
<link rel="stylesheet" href="{{ "css/fonts.css" | relURL }}" media="all">
<link rel="stylesheet" href="{{ "css/main.css" | relURL }}" media="all">
<link rel="stylesheet" href="{{ "css/font-awesome.min.css" | relURL }}" media="all">
{{ partial "footer.html" . }}


```

然后设置自己想要的css样式即可

