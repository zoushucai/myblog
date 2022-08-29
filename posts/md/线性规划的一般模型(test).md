---
title: 线性规划的一般模型(草稿)
date: '2018-11-17'
categories: r
---



线性规划的一般模型 :

$$
\begin{aligned}
\min \quad z &=  c_1x_1+c_2x_2+ \cdots + c_nx_n  \\
s.t. \quad
& \begin{cases}
& a_{11}x_1+a_{12}x_2+ \cdots + a_{1n}x_n  \leq b_1   \\
& a_{21}x_1+a_{22}x_2+ \cdots + a_{2n}x_n  \leq b_2   \\
& \quad \cdots \qquad \cdots   \qquad \cdots \\
& a_{m1}x_1+a_{m2}x_2+ \cdots + a_{mn}x_n  \leq b_m  \\
& x_1,x_2,x_3,\cdots,x_n \geq 0 
\end{cases}
\end{aligned}
$$


