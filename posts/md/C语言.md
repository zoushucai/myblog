---
title: 用c语言设置定时关机
date: '2018-11-20'
categories: r
---





# C代码

## 创建定时任务
发现代码，win有自动防范木马的可能，于是要手动去在定时任务勾选某些指标，所以不可行。
```c
# include<stdio.h>
# include <windows.h>
int main() {
  //如果存在任务名为myTaskName2 则强制删除，若没有则报错，但不终止该程序的运行
	system("schtasks /delete /tn myTaskName2 /f"); 
	// 创建一个任务名为myTaskName2的任务,/tr 后面是 要执行的命令， 双引号要转义，/st 后面接的是触发时间
	system("schtasks /create /tn myTaskName2  /f /tr \"shutdown -s -f -t 10\" /sc once /st 22:35:00");

	system("schtasks /delete /tn myTaskName4 /f");
	system("schtasks /create /tn myTaskName4  /f /tr \"shutdown -s -f -t 10\" /sc once /st 22:42:00");

	system("schtasks /delete /tn myTaskName3 /f");
	system("schtasks /create /tn myTaskName3  /f /tr \"shutdown -s -f -t 10\" /sc once /st 22:52:00");

	system("schtasks /delete /tn myTaskName5 /f");
	system("schtasks /delete /tn myTaskName6 /f");
	system("schtasks /delete /tn myTaskName7 /f");
	system("schtasks /create /tn myTaskName5  /f /tr \"shutdown -s -f -t 10\" /sc once /st 23:00:00");
	system("schtasks /create /tn myTaskName6  /f /tr \"shutdown -s -f -t 10\" /sc once /st 23:15:00");
	system("schtasks /create /tn myTaskName7  /f /tr \"shutdown -s -f -t 10\" /sc once /st 23:27:00");

	system("schtasks /delete /tn myTaskName8 /f");
	system("schtasks /delete /tn myTaskName9 /f");
	system("schtasks /create /tn myTaskName8  /f /tr \"shutdown -s -f -t 10\" /sc once /st 23:43:00");
	system("schtasks /create /tn myTaskName9  /f /tr \"shutdown -s -f -t 10\" /sc once /st 23:58:00");

	return 0;
}
```

# 编译运行后
编译运行后，找到对应得exe文件 ,把其放在开始启动目录中即可（`C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp`）

或者 写一个bat命令，放在开始启动目录，eg：
`start "" "E:\TIM\xin\Bin\TIM.exe" & ping localhost -n 5`

命令中的`&` `&&` `||` 分别的含义：  
其中： 
- & : 用来分隔一个命令行中的多个命令,即运行第一个命令，然后运行第二个命令。
- && ： 只有在符号 && 前面的命令成功时，才用于运行该符号后面的命令
- || : 只有在符号 || 前面的命令失败时，才用于运行符号 || 后面的命令。

## 直接注入关机命令

这样感觉，电脑右下角一直有一个图标，
于是再次改进
```c
# include<stdio.h>
#include <time.h>
#include<stdlib.h>
#include <string.h>
#include<windows.h>

void loop_shut(){
	while(1){
		system("shutdown -s -f -t 5");
		Sleep(1);
	}
}
int main()
{
	char str1[100]="shutdown -s -f -t ";
	char str2[32];
	char *str3; 
	int now_hour=0,now_min=0,now_second=0;
	struct tm * tmpointer;  //申明tm结构体指针
	time_t secs;  //申明time_t类型变量
	time(&secs); //获取当前系统日期与时间
	tmpointer = localtime(&secs); //获取tm结构的日期时间,获取当地日期与时间
	printf("\Now: %d-%d-%d %d:%d:%d\n",tmpointer->tm_mon,tmpointer->tm_mday,
	tmpointer->tm_year+1900,tmpointer->tm_hour,tmpointer->tm_min,tmpointer->tm_sec); 
	//获取当前系统时间 
	now_hour = tmpointer->tm_hour;
	now_min = tmpointer->tm_min;
	now_second = tmpointer->tm_sec;
	
	
	
    printf("\n当前时间:%d:%d:%d",tmpointer->tm_hour,tmpointer->tm_min,tmpointer->tm_sec);
	
	//设置关机时间
	int close_hour = 22,close_min =30,close_sec = 0;
	printf("\n关机时间:%d:%d:%d\n",close_hour,close_min,close_sec);

	int i=0,j=0;
	int diff_hour ,diff_min;//时间差
	int left_time ;//离关机时间还剩多少秒 (单位:秒)
	diff_hour = now_hour - close_hour; //离关机时间还剩多少个小时 
	diff_min = now_min -close_min;// 离关机时间还剩多少个分钟 
	printf("时间差: 小时:%d  分钟:%d \n",diff_hour,diff_min);
	//时间在 关机时间后 
	if(diff_hour > 0) {
		// 当前小时在关机时间之后  
		printf("正在关机1\n");
		system("shutdown -s -f -t 10");//立即关机 
		loop_shut(); 
			
	}else if(diff_hour ==0){
		//当前小时 正在关机时间处 
		if(diff_min <0){
			//没超过关机时间 
			printf("正在关机2\n");
			diff_min =(-1) * diff_min;
			i = diff_min*60;
			printf("还剩%d秒==%d分钟\n",i,diff_min);
			itoa(i,str2,10);//把数字转变为字符串 ，后面的10 为10进制 
			strcat(str1,str2);  //拼接字符串 
			system(str1);
		}else if(diff_min ==0){
			printf("正在关机3\n");
			system("shutdown -s -f -t 20");//立即关机 
			loop_shut();
		}else{
			//超过关机时间 
			printf("正在关机4\n");
			system("shutdown -s -f -t 20");//立即关机 
			loop_shut();
		}
	}else{
		//当前小时 在关机时间之前 
		printf("正在关机5\n");
		left_time = diff_hour*(-1)*60 + diff_min*(-1);
		i = left_time*60;
		printf("还剩%d秒==%d分钟\n",i,left_time);
		itoa(i,str2,10);//把数字转变为字符串 ，后面的10 为10进制 
		strcat(str1,str2);  //拼接字符串 
		system(str1);
	}
  return 0; 
}

```

## 结合定时任务关机

到某个时间以后，如果在重启，就会直接关机（除非你手速快）,并把生成的exe文件设置为开机启动。

```c
# include <stdio.h>
# include <time.h>
# include <stdlib.h>
# include <string.h>
# include <windows.h>

void loop_shut() {
	while(1) {
		system("shutdown -s -f -t 5");
		Sleep(6);
	}
}
int main() {
	//设置关机时间
	int close_hour = 22,close_min =35,close_sec = 0;

	int diff_hour ,diff_min;//声明变量用来存储时间差
    int temp;
	//声明变量获取时间结构
	int now_hour=0,now_min=0,now_second=0;
	struct tm * tmpointer;  //申明tm结构体指针
	time_t secs;  //申明time_t类型变量
	time(&secs); //获取当前系统日期与时间
	tmpointer = localtime(&secs); //获取tm结构的日期时间,获取当地日期与时间

	//获取当前系统时间
	now_hour = tmpointer->tm_hour;
	now_min = tmpointer->tm_min;
	now_second = tmpointer->tm_sec;

	//时间差
	diff_hour = now_hour - close_hour; //离关机时间还剩多少个小时
	diff_min = now_min -close_min;// 离关机时间还剩多少个分钟
	//关机程序，时间在22:30分以后 以及早上7点之前
	temp = ( diff_hour >0 ||(diff_hour ==0 && diff_min>=0) ) || (now_hour <7); 
	if(temp) {
		// 已过关机时间之后
		printf("正在关机1\n");
		//system("shutdown -s -f -t 5");//立即关机 ,有时候需要保存一点重要资料
		loop_shut();
	} else {
		printf("不关机!");
	}
	return 0;
}
```
同时在win的程序计划任务中自己添加几个任务，到点自动关机，注意第一个留一点时间，保存文件，后面一个直接关机.并设置选项，不然不会自动运行
如下:

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/guanji01.png)

![](https://cdn.jsdelivr.net/gh/zscmmm/imgs2208save@master/img/guanji02.png)


亲试，根本还没有看到桌面，就显示关机了.
