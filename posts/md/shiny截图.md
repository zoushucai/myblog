---
title: R&shiny自动截图
date: '2020-05-18'
categories:
  - shiny
  - r
---


# 利用webshot 进行截图


```R
library(shiny)
library(ggplot2)
histogram <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
    df <- data.frame(
        x = c(x1, x2),
        g = c(rep("x1", length(x1)), rep("x2", length(x2)))
    )
    
    ggplot(df, aes(x, fill = g)) +
        geom_histogram(binwidth = binwidth) +
        coord_cartesian(xlim = xlim)
}
ui <- fluidPage(
    fluidRow(
        column(3, 
               numericInput("lambda1", label = "lambda1", value = 3),
               numericInput("lambda2", label = "lambda2", value = 4),
               numericInput("n", label = "n", value = 1e4, min = 0),
               # 增加一个按钮
               actionButton("simulate", "Simulate!")
        ),
        column(9, plotOutput("hist"))
    )
)

server <- function(input, output, session) {
    x1 <- reactive({
        a = input$simulate
        print(a)
        rpois(input$n, input$lambda1)
    })
    x2 <- reactive({
        b = input$simulate
        print(b)
        rpois(input$n, input$lambda2)
    })
    output$hist <- renderPlot({
        histogram(x1(), x2(), binwidth = 1, xlim = c(0, 40))
    }, res = 96)
}

mm =shinyApp(ui, server)
Sys.sleep(5)
library(webshot)
appshot(mm, "01_hello1.png",webshot_timeout= 100,delay=10)
# 其中delay参数最好设置大一点, 特别是当使用动态网页时

## 还可以根据css来截图
appshot(mm, "01_hello2.png",webshot_timeout= 100,delay=10,selector='body')
```

感兴趣可以参考`webshot包`网站: https://wch.github.io/webshot/reference/webshot.html
