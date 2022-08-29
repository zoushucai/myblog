---
title: Scrapy框架+selenium爬取京东相机
date: '2018-08-10'
categories:
  - python
  - scrapy
  - selenium
---

## 1  创建一个srcapy项目：

（项目名为：jingdong)，会生成一系列文件夹，命令如下(cmd下运行)：

```python
scrapy startproject jingdong
```

## 2  创建爬虫文件

在刚刚生成的jingdong文件夹下面找到spiders文件夹,在spider文件下创建一个爬虫文件（名字叫jd）-- 用来解析网页的，命令如下(cmd下运行)：

```python
scarpy genspider jd "list.jd.com"
# 创建一个jd.py的爬虫文件，爬虫名为jd ，以及指定爬虫允许爬取的范围：只能在jd.com下.
```

## 3  编写items.py文件

创建爬虫目标（明确需要提取的数据），如下：

```python
import scrapy
class JingdongItem(scrapy.Item):
    # define the fields for your item here like:
    # 所有商品的名称、链接、价格、销售店铺、评论数的信
    # 商品名称
    name = scrapy.Field()
    # 商品的简介
    abstract = scrapy.Field()
    # 商品的链接
    link = scrapy.Field()
    # 商品的价格
    price = scrapy.Field()
    # 店铺名
    shop_name = scrapy.Field()
    # 评论数
    commet = scrapy.Field()

```

## 4   设置setting文件，开启管道

```python
ITEM_PIPELINES = {
    'jingdong.pipelines.JingdongPipeline': 300,
}

```

## 5  编写spiders/jd.py 文件 （爬虫文件）

编写爬虫文件（我们创建的jd.py,，在spiders这个文件夹下面），此文件用来处理请求和响应，以及提取数据

```python
# -*- coding: utf-8 -*-
import scrapy
from jingdong.items import JingdongItem 

class JdSpider(scrapy.Spider):
	# 爬虫名
    name = "jd"
    # 允许爬虫作用的范围
    allowed_domains = ["list.jd.com"]
    # 页面提取url  也可以拼接url:https://list.jd.com/list.html?cat=652,654,831&page=0

    # 爬虫起始的url
    start_urls = ['https://list.jd.com/list.html?cat=652,654,831']
    offset = 1 # 设置爬取的起始页数
    def parse(self, response):
        info_list = response.xpath('//div[@id="plist"]//li[@class ="gl-item"]')
        for each in info_list:
            # 构建item对象，用来保存数据
            item = JingdongItem()
            ####################################################
            ########## 一下为提取页面信息######################
            # 提取商品的名称，
            if len( each.xpath('./div/div[@class="p-name"]/a/em/text()') ) == 0 :
                item['name']=""
            else:
                item['name'] = each.xpath('./div/div[@class="p-name"]/a/em/text()').extract()[0]
    		
            # 商品简介
            if len(each.xpath('./div/div[@class="p-name"]/a/i[@class="promo-words"]/text()'))==0:
                item['abstract']=""
            else:
                item['abstract'] = each.xpath('./div/div[@class="p-name"]/a/i[@class="promo-words"]/text()').extract()[0]
    		
            # 商品链接
            if len(each.xpath('./div/div[@class="p-name"]/a/@href'))==0:
                item['link'] = ""
            else:
                item['link'] = each.xpath('./div/div[@class="p-name"]/a/@href').extract()[0]
    		
            # 商品价格
            if len(each.xpath('./div/div[@class="p-price"]/strong[1]/i/text()'))==0:
                item['price'] = ""
            else:
                item['price'] = each.xpath('./div/div[@class="p-price"]/strong[1]//i/text()').extract()[0]
    		
            # 商品店铺名称
            if len(each.xpath('./div/div[@class="p-shop"]/span/a/text()'))==0:
                item['shop_name']=""
            else:
                item['shop_name'] = each.xpath('./div/div[@class="p-shop"]/span/a/text()').extract()[0]
            
            # 商品评论数
            if len(each.xpath('./div/div[@class="p-commit p-commit-n"]/strong/a/text()'))==0:
                item['commet']=""
            else:
                item['commet'] = each.xpath('./div/div[@class="p-commit p-commit-n"]/strong/a/text()').extract()[0]
            # 通过yield 返回数据，返回数据后还能回来继续执行下面的代码
            yield item
        
        # 直接从response获取需要爬取的链接，并发送给请求处理，直到链接处理完成
        if len(response.xpath('//div[@class="p-wrap"]//a[@class="pn-next"]'))!= 0 and self.offset<1000:
            # self.offset手动控制爬取的页面数  ，当然这里没有1000个页面，直到所有为止
            self.offset = self.offset+1
            next_url = response.xpath('//div[@class="p-wrap"]//a[@class="pn-next"]/@href').extract_first()
            url = "https://list.jd.com/"+next_url# 找到下一页的url链接
            yield scrapy.Request(url=url,callback= self.parse)


```

## 6  编写pipelines.py(管道文件)

编写管道文件，处理spider返回的item数据，我把它存为json文件： 如下

```python
import json

class JingdongPipeline(object):
    def __init__(self):
        self.f = open("jingdong_xiangji.json","w")
        
    def process_item(self, item, spider):
        content = json.dumps(dict(item),ensure_ascii=False) + ",\n"
        self.f.write(content)
        return item # 一定要返回item  ，相当于告诉引擎，我做事做完了，请给我下一个item
    
    # 第一个方法：只执行一次
    def close_spider(self,spider):
        self.f.close()

```

## 7  编写middlewares.py(下载中间件)

由于京东这个网站，网页是动态加载的，于是结合selenium进行下载，（如果是静态页面，无需写这个文件，以及后面的第8步）

```python

from selenium import webdriver
#检查页面是否加载完毕
import time
from scrapy.http import HtmlResponse
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.chrome.options import Options #设置Google的无头浏览器

class JingdongSpiderMiddleware(object):
    # 开始运行的选项
    def __init__(self):
        chrome_options = Options()
        prefs =  {"profile.managed_default_content_settings.images":2}
        # 设置Chrome浏览器不加载图片的方法
        chrome_options.add_experimental_option("prefs",prefs) 
        #设置Google的无头浏览器
        chrome_options.add_argument('--headless') 
        self.browser = webdriver.Chrome(chrome_options=chrome_options) 
        self.browser.maximize_window()  # 最大化浏览器
        self.browser.implicitly_wait(10)#隐式等待10s
        
    #  最后结束的时候运行的选项
    def __del__(self):
        self.browser.close()
        self.browser.quit()
        
    def process_request(self,request,spider):
        try:
            self.browser.get(request.url)
            self.browser.implicitly_wait(6)
            self.browser.execute_script('window.scrollTo(0,document.body.scrollHeight)')
            time.sleep(3)
            self.browser.execute_script('window.scrollTo(0,document.body.scrollHeight)')
            time.sleep(3)
            return HtmlResponse(url=self.browser.current_url,body=self.browser.page_source,encoding='utf-8',request=request,status=200)
        except TimeoutException as e:
            print("超时")
            self.browser.execute_script('window.stop()')
            return HtmlResponse(url=request.url,status=500,request = request)

```

## 8   设置下载中间件

```python
DOWNLOADER_MIDDLEWARES = {
     'jingdong.middlewares.JingdongSpiderMiddleware': 543,
}

```



## 9  最后的settings.py(设置文件)

由于爬虫有时候网站不让你爬 。有一个robots协议，我们不管这个，需要在setting.py设置，把ROBOTSTXT_OBEY = False即可

最后我的setting.py 如下:

```python
BOT_NAME = 'jingdong'

SPIDER_MODULES = ['jingdong.spiders']
NEWSPIDER_MODULE = 'jingdong.spiders'
########################### 以上全自动生成
#以下为 手动改写
ROBOTSTXT_OBEY = False 
DOWNLOADER_MIDDLEWARES = {
     'jingdong.middlewares.JingdongSpiderMiddleware': 543,
}
ITEM_PIPELINES = {
    'jingdong.pipelines.JingdongPipeline'
    : 300,
}

## 解释： 'jingdong.pipelines.JingdongPipeline' ## 注意这里的字典 键要对应前面的类，
#####  jingdong 为爬虫项目名，
#####  pipelines为爬虫下面的pipelines.py文件的文件名，
#####  JingdongPipeline为pipelines.py中的类名


```

## 10  最后执行爬虫文件：

cmd下执行：

```bash
scrapy crawl jd
# 注意：jd为 spiders/jd.py文件中name的值  即（name = "jd"）
# 也可以执行  scrapy crawl jd  -o  jd_xiangji.csv  
#### 即存为 json  又有保存了csv文件  ，生成的文件都在当前目录下（我们可以在爬虫的项目的文件下创建一个data文件夹，在这个文件夹下执行爬虫文件，就可以把代码和数据分开了。
######################
#  在cmd下运行的命令 只要在爬虫项目文件下运行都可以执行，
```

## 11  结果展示

![20180810scrapyjingdong](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/20180810scrapyjingdong.png)

一共 7192 条信息  =  120* 60  （最后一页没有60个商品）

可以看出速度很快（大概20分钟左右）就抓取玩了
