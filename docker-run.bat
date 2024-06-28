docker run ^
    --mount type=bind,source=D:\dev\playstrategy,target=/home/playstrategy/projects ^
    --publish 9663:9663 ^
    --publish 9664:9664 ^
    --publish 8212:8212 ^
    --interactive ^
    --tty ^
    --name playstrategy ^
    --memory=4g ^
    --memory-swap=4g ^
    playstrategy
