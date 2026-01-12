# android Docker Kernel

基于原生安卓编译完整支持 Docker 容器运行环境的内核。
重新编译termux的docker，去掉termux依赖通过magisk模块集中在系统里
## ✨ 已编译内核
# macvlan与bridge问题可以通过usb有线网卡解决。

- **基于 [Arrow OS 11](https://github.com/LeeHe-gif/android_kernel_xiaomi_sdm845)** 内核源码构建 polaris（MI Mix2s）内核，默认带ksu，已测试在wifi下桥接网络与macvlan有问题，其他正常。
- **基于 [Lineage OS 22.2](https://github.com/LeeHe-gif/android_kernel_xiaomi_sdm845_lineage.git)** 内核源码构建 polaris（MI Mix2s）能开机，未做功能测试。
- **基于 [Lineage OS 22.2](https://github.com/LeeHe-gif/android_kernel_xiaomi_sm8250_LineageOS/tree/lineage-22.2)** 内核源码构建 alioth（Redmi k40）已测试在wifi下桥接网络与macvlan有问题，其他正常。
- **基于 [Arrow OS 12.1](https://github.com/LeeHe-gif/android_kernel_xiaomi_alioth)** 内核源码构建 alioth（Redmi k40）已测试在wifi下桥接网络与macvlan有问题，其他正常。
- **基于 [ZTE - Opensource](https://opensource.ztedevices.com/)** 官方源码构建 ZTE U30Air 内核，正在测试中，目前仅原厂配置可以开机。
- **基于 [kirin970-kernel-based-on-emui9.1](https://github.com/LeeHe-gif/kirin970-kernel-based-on-emui9.1)** 源码构建 华为nova3 内核，默认带ksu，开启docker支持可以开机，正在测试docker功能中。
- **基于 [crDoird 12.5](https://github.com/LeeHe-gif/android_kernel_xiaomi_nabu)** 源码构建 nabu (MI pad 5) 内核，默认带ksu，已测试在wifi下桥接网络与macvlan有问题，其他正常
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
  - `overlay2`: ✅ 已启用
- **网络驱动**:
  - `bridge`: ✅ 已启用
  - `ipvlan`: ✅ 已启用  
  - `macvlan`: ✅ 已启用

### 挂载cgroups

```Bash
mkdir -p /sys/fs/cgroup

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
