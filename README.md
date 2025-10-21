# android Docker Kernel

基于原生安卓编译完整支持 Docker 容器运行环境的内核。
重新编译termux的docker，去掉termux依赖通过magisk模块集中在系统里
## ✨ 已编译内核

- **基于 [Arrow OS 11](https://github.com/LeeHe-gif/android_kernel_xiaomi_sdm845)** 内核源码构建 polaris（MI Mix2s）已测试除桥接网络与macvlan有问题之外，其他正常工作。
- **基于 [CRDoird 11.1](https://github.com/LeeHe-gif/android_kernel_xiaomi_sm8250)** 内核源码构建 alioth（Redmi k40）测试目前刷面具卡米，加ksu卡米。
- **基于 [Arrow OS 12.1](https://github.com/LeeHe-gif/android_kernel_xiaomi_alioth)** 内核源码构建 alioth（Redmi k40） 目前还在测试中

## ✅ Docker 支持状态

根据内核配置检测，本内核已完整支持 Docker 运行环境：

### 🟢 必需功能 (全部启用)
![](/img/效果图.png "脚本测试图")
- **Cgroup 层级**: 已挂载
- **命名空间支持**: PID、网络、IPC、UTS、挂载命名空间
- **控制组 (Cgroup)**: CPU、内存、I/O、设备控制
- **网络过滤**: IPv4/IPv6 NAT、MASQUERADE、连接跟踪
- **内存管理**: MEMCG 支持

### 🟢 可选功能 (大部分启用)
- **用户命名空间**: ✅ 已启用
- **Seccomp 过滤**: ✅ 已启用
- **存储驱动**: 
  - `overlay2`: ✅ 已启用 (推荐)
  - `aufs`: ✅ 已启用
- **网络驱动**:
  - `bridge`: ✅ 已启用
  - `ipvlan`: ✅ 已启用  
  - `macvlan`: ✅ 已启用

## 📥 刷入方法

### 前提条件
- 已解锁 Bootloader
- 已安装 TWRP Recovery
- 备份重要数据

### 挂载cgroups

```Bash
mkdir -p /sys/fs/cgroup
mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime cgroup_root /sys/fs/cgroup 2>/dev/null

cgroups="blkio cpu cpuacct cpuset devices freezer memory pids"
for cg in $cgroups; do
    mkdir -p /sys/fs/cgroup/$cg
    mount -t cgroup -o rw,nosuid,nodev,noexec,relatime,$cg $cg /sys/fs/cgroup/$cg 2>/dev/null
done
```

### 启用网络转发

```Bash
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
echo 1 > /proc/sys/net/ipv6/conf/default/forwarding
```

### 检测脚本
```Bash
wget https://github.com/moby/moby/raw/master/contrib/check-config.sh
sh check-config.sh
```

### 刷机步骤

1. **下载文件**
   - 从 Releases 页面下载最新的 `polaris_dockerkernel.zip`

2. **进入 TWRP**

3. **刷入polaris_dockerkernel.zip**

4. **刷入magisk**

5.**重启**
