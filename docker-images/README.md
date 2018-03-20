Quorum包含geth, constellation两部分,我们这里分别打两个镜像。

#### 创建constellation image
  1. `cd constellation-node`
  2. `sudo docker build -t constellation:0.2.0 .`

#### 创建quorum node image
 1. `cd quorum-node`
 2. `sudo docker build -t quorum:2.0.0 .`