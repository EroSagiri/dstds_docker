# Don’t Starve Together Dedicated Servers  Docker 镜像
这个镜像在官方steamcmd docker的基础上构造
start_server.sh 是一个启动脚本，会自动更新steamcmd以及Don’t Starve Together Dedicated Servers，并且启动Don’t Starve Together Dedicated Servers  
test文件夹测试用  
## 安装Docker
可以有阅读官方文档 [Get Docker](https://docs.docker.com/get-docker/)  
## 下载镜像到本地
```
docker pull eromangasensei/dstds:latest
```
## 创建容器
映射端口号是存档文件夹 Caves， Masger 下的 server.ini 文件里面的server_port=11000
挂载目录本地存档挂载到/home/steam/.klei/DoNotStarveTogether/world 没有存档是无法运行的
```
docker container run -d \
    -v test:/home/steam/.klei/DoNotStarveTogether/world \
    -p 11000:11000/udp \
    -p 11001:11001/udp \
    --name=game \
    eromangasensei/dstds:latest
```
## 查看运行日志
```
docker logs game -f
```
## 存档文件夹
Don’t Starve Together Dedicated Servers 使用的存档和 Don’t Starve Together 是一样一样的
关于各个文件的作用阅读 [Guides/Don’t Starve Together Dedicated Servers](https://dontstarve.fandom.com/wiki/Guides/Don%E2%80%99t_Starve_Together_Dedicated_Servers)
