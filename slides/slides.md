---
theme: default
title: 基于微服务架构的智能物流管理系统
info: |
  本科毕业答辩演示文稿
  上海大学 · 计算机科学与工程学院
  付苗 · 21122119
class: text-center
drawings:
  persist: false
transition: slide-left
mdc: true
download: true
exportFilename: 毕业答辩-智能物流管理系统
lang: zh-CN
---

# 基于微服务架构的智能物流管理系统

<div class="pt-8">

<strong>答辩人</strong>：付苗 &nbsp;&nbsp; <strong>学号</strong>：21122119

<strong>指导教师</strong>：牛志华

<strong>专业</strong>：网络空间安全 · 计算机科学与工程学院

上海大学

</div>

<div class="abs-br m-6 text-sm opacity-50">
  2025年6月
</div>

---
layout: section
---

# 一、绪论

研究背景 · 研究现状 · 研究内容

---

# 研究背景与意义

<div class="grid grid-cols-2 gap-6">

<div>

### 行业痛点
- 物流成本占GDP比重曾达 <strong>14.6%</strong>（2022年国家统计），高于发达国家（~8%）
- 信息孤岛严重，各环节协同困难
- 传统单体架构耦合度高、迭代周期长

### 技术驱动
- 物联网与大数据推动物流信息化
- 微服务架构适合物流系统多角色、多模块的组织方式

</div>

<div>

### 研究意义
<v-clicks>

- 🚀 <strong>提高运作效率</strong> — 智能调度与路径规划
- 💰 <strong>降低运营成本</strong> — MCMF优化运力分配
- 👤 <strong>提升用户体验</strong> — 全链路物流追踪
- 🔄 <strong>探索智能增强</strong> — 大语言模型(LLM)与确定性算法的受限组合

</v-clicks>

</div>

</div>

---

# 国内外研究现状与不足

<div class="grid grid-cols-2 gap-6">

<div>

### 国内研究
- Spring Cloud重构物流系统 — 未涉及服务治理
- Spring Boot物流管理 — 未涉及智能算法
- K-Means配送选址 — 仅优化单一环节

### 国外研究
- 微服务迁移分析 — 未检索到微服务+大语言模型(LLM)工程案例
- 改进A*路径规划 — 多基于理想化模型
- VRP/MCMF理论算法 — 缺少工程化验证

</div>

<div>

### 代表工作对比 → 本课题切入点

<div class="mt-4 space-y-3">

<div class="bg-yellow-50 dark:bg-yellow-900/20 p-3 rounded border-l-4 border-yellow-500">
⚠️ 现有工作多关注单一环节，缺少多角色业务流程覆盖
</div>

<div class="bg-yellow-50 dark:bg-yellow-900/20 p-3 rounded border-l-4 border-yellow-500">
⚠️ 路径规划多基于理想化模型，未结合历史交通数据
</div>

<div class="bg-yellow-50 dark:bg-yellow-900/20 p-3 rounded border-l-4 border-yellow-500">
⚠️ 运力规划缺少Hub-and-Spoke的工程化验证
</div>

<div class="bg-blue-50 dark:bg-blue-900/20 p-3 rounded border-l-4 border-blue-500">
🔬 本课题尝试：大语言模型(LLM)与确定性算法的受限组合
</div>

</div>

</div>

</div>

---

# 本课题研究内容

<div class="grid grid-cols-3 gap-4 mt-4">

<div class="border rounded p-4 bg-blue-50 dark:bg-blue-900/20">
<div class="text-2xl mb-2">📐</div>
<div class="font-bold mb-2">需求分析与架构设计</div>
<div class="text-sm opacity-80">四方参与角色、三种服务模式、五层微服务架构</div>
</div>

<div class="border rounded p-4 bg-green-50 dark:bg-green-900/20">
<div class="text-2xl mb-2">⚙️</div>
<div class="font-bold mb-2">关键技术选型</div>
<div class="text-sm opacity-80">Spring Cloud Alibaba + GraphHopper + DeepSeek大语言模型(LLM)</div>
</div>

<div class="border rounded p-4 bg-purple-50 dark:bg-purple-900/20">
<div class="text-2xl mb-2">🧠</div>
<div class="font-bold mb-2">智能算法设计</div>
<div class="text-sm opacity-80">路径规划增强、末端聚类、运力规划</div>
</div>

<div class="border rounded p-4 bg-orange-50 dark:bg-orange-900/20">
<div class="text-2xl mb-2">💻</div>
<div class="font-bold mb-2">核心服务实现</div>
<div class="text-sm opacity-80">8个微服务 + Vue3前端 + Docker编排</div>
</div>

<div class="border rounded p-4 bg-teal-50 dark:bg-teal-900/20">
<div class="text-2xl mb-2">🐳</div>
<div class="font-bold mb-2">系统集成与部署</div>
<div class="text-sm opacity-80">Docker Compose全栈容器化部署</div>
</div>

<div class="border rounded p-4 bg-pink-50 dark:bg-pink-900/20">
<div class="text-2xl mb-2">🧪</div>
<div class="font-bold mb-2">系统测试与评估</div>
<div class="text-sm opacity-80">功能验证、算法行为验证、部署验证</div>
</div>

</div>

---
layout: section
---

# 二、相关技术综述

微服务架构 · 数据持久化 · 智能算法

---

# 技术选型总览

<div class="mt-4">

| 技术领域 | 选用方案 | 候选方案 | 决策理由 |
|:---------|:---------|:---------|:---------|
| 注册中心 | <strong>Nacos</strong> | Eureka、Zookeeper | CP/AP可切换，支持配置中心 |
| API网关 | <strong>Spring Cloud Gateway</strong> | Zuul | WebFlux+Reactor，非阻塞 |
| 服务调用 | <strong>OpenFeign</strong> | RestTemplate | 声明式+负载均衡 |
| 消息队列 | <strong>RabbitMQ</strong> | Kafka | 灵活路由、可靠消息确认 |
| ORM | <strong>MyBatis-Plus</strong> | JPA | Lambda查询+ServiceImpl |
| 缓存 | <strong>Redis</strong> | Caffeine | 分布式缓存、Cache-Aside |
| 前端 | <strong>Vue3 + Vite</strong> | React | 组合式API+快速构建 |
| 路网引擎 | <strong>GraphHopper</strong> | OSRM | Java原生集成、OSM数据 |
| 大语言模型(LLM) | <strong>DeepSeek API</strong> | GPT-4 | 国产模型、JSON结构输出 |

</div>

---

# 智能算法理论基础

<div class="grid grid-cols-3 gap-4 mt-4">

<div class="border rounded p-4">

### Weighted A* 搜索
- f(n) = g(n) + ε·h(n)
- ε = 1.0：标准最短路
- ε > 1：牺牲最优性换取多样性
- Haversine球面启发函数

</div>

<div class="border rounded p-4">

### K-Means 聚类
- <strong>E步</strong>：分配到最近中心
- <strong>M步</strong>：重算簇中心
- Haversine球面距离
- 均匀抽样初始化
- k = ⌈√n⌉（默认值，管理员可指定）

</div>

<div class="border rounded p-4">

### MCMF 最小费用最大流
- SSP逐次最短增广
- 每Hub拆入港/出港节点
- 超级源S/超级汇T
- 单商品：SSP+SPFA
- 多商品：Dijkstra-SSP

</div>

</div>

---
layout: section
---

# 三、系统设计

需求分析 · 架构设计 · 详细设计

---

# 需求分析 — 三种服务模式 & 四方参与

<div class="grid grid-cols-2 gap-6">

<div>

### 三种服务模式

<div class="space-y-2 mt-2">
<div class="flex items-center gap-2">
<span class="bg-blue-500 text-white px-2 py-1 rounded text-sm">企业间合约</span>
<span class="text-sm">工厂/商贸 ↔ 物流企业</span>
</div>
<div class="flex items-center gap-2">
<span class="bg-green-500 text-white px-2 py-1 rounded text-sm">电商平台零售</span>
<span class="text-sm">消费者 → 商户 → 物流</span>
</div>
<div class="flex items-center gap-2">
<span class="bg-purple-500 text-white px-2 py-1 rounded text-sm">个人寄件</span>
<span class="text-sm">个人 → 物流网点 → 运输</span>
</div>
</div>

### 非功能需求
- 服务独立部署、可按需扩展
- 用户友好、安全性

</div>

<div>

### 四方参与角色

<div class="space-y-2 mt-2">
<div class="border-l-4 border-blue-500 pl-3 py-1">
🏭 <strong>工厂/商贸企业</strong> — 仓库管理、承运物管理、库存维护
</div>
<div class="border-l-4 border-green-500 pl-3 py-1">
👤 <strong>个人用户</strong> — 地址管理、寄件、查看物流
</div>
<div class="border-l-4 border-purple-500 pl-3 py-1">
📦 <strong>物流仓库/网点</strong> — 入库、出库、转运、派送
</div>
<div class="border-l-4 border-orange-500 pl-3 py-1">
🚚 <strong>运输企业/运输员</strong> — 接受任务、路线规划
</div>
</div>

</div>

</div>

---

# 架构设计 — 五层微服务架构

<div class="flex justify-center mt-2">
<img src="/figures/architecture-overview.png" class="h-80 rounded shadow" />
</div>

<div class="text-center text-sm opacity-70 mt-2">
接入层 → 业务层 → 通信层 → 存储层 → 编排层
</div>

---

# 8个核心微服务

<div class="grid grid-cols-4 gap-3 mt-4">

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">🔐</div>
<div class="font-bold text-sm">认证服务</div>
<div class="text-xs opacity-70">auth-service:8082</div>
<div class="text-xs mt-1">登录·注册·鉴权</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">👤</div>
<div class="font-bold text-sm">用户服务</div>
<div class="text-xs opacity-70">user-service:8081</div>
<div class="text-xs mt-1">用户·地址管理</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">🛒</div>
<div class="font-bold text-sm">顾客服务</div>
<div class="text-xs opacity-70">customer-service:8083</div>
<div class="text-xs mt-1">个人寄件</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">🏪</div>
<div class="font-bold text-sm">商户服务</div>
<div class="text-xs opacity-70">shop-service:8084</div>
<div class="text-xs mt-1">仓库·库存</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">📋</div>
<div class="font-bold text-sm">订单服务</div>
<div class="text-xs opacity-70">order-service:8085</div>
<div class="text-xs mt-1">订单·配送</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">🚚</div>
<div class="font-bold text-sm">运输员服务</div>
<div class="text-xs opacity-70">driver-service:8086</div>
<div class="text-xs mt-1">任务·车辆</div>
</div>

<div class="border rounded p-3 text-center bg-yellow-50 dark:bg-yellow-900/20">
<div class="text-xl mb-1">🧠</div>
<div class="font-bold text-sm">物流服务 ★</div>
<div class="text-xs opacity-70">logistics-service:8087</div>
<div class="text-xs mt-1">调度·算法·MCMF</div>
</div>

<div class="border rounded p-3 text-center">
<div class="text-xl mb-1">🌐</div>
<div class="font-bold text-sm">网关服务</div>
<div class="text-xs opacity-70">gateway-service:8090</div>
<div class="text-xs mt-1">路由·鉴权·限流</div>
</div>

</div>

---

# 数据库设计 — E-R图

<div class="flex justify-center mt-2">
<img src="/figures/er-diagram.png" class="h-80 rounded shadow" />
</div>

<div class="text-center text-sm opacity-70 mt-2">
38张数据表 · 4大模块 · Hub三级层次（全国枢纽/省级中心/城市配送中心）
</div>

---
layout: section
---

# 四、系统实现

核心功能 · 前端界面 · 容器化部署

---

# 前端功能展示

<div class="grid grid-cols-2 gap-4 mt-4">

<div>
<img src="/figures/login.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">登录页面</div>
</div>

<div>
<img src="/figures/create-order-pickup.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">创建寄件订单</div>
</div>

<div>
<img src="/figures/order-detail.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">订单详情与追踪</div>
</div>

<div>
<img src="/figures/driver-map.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">运输员地图导航</div>
</div>

</div>

---

# 更多功能展示

<div class="grid grid-cols-2 gap-4 mt-4">

<div>
<img src="/figures/kmeans-dispatch-preview.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">K-Means调度预览</div>
</div>

<div>
<img src="/figures/mcmf-flow-plan.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">MCMF全国运力规划</div>
</div>

<div>
<img src="/figures/driver-tasks.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">运输员任务列表</div>
</div>

<div>
<img src="/figures/shop-products.png" class="rounded shadow h-44" />
<div class="text-center text-sm mt-1">商户商品管理</div>
</div>

</div>

---

# Docker全栈部署

<div class="grid grid-cols-2 gap-6 mt-4">

<div>

### 容器编排架构

```yaml
services:
  # 基础设施
  mysql:        # 数据库
  redis:        # 缓存
  rabbitmq:     # 消息队列
  nacos:        # 注册中心

  # 微服务 (8个)
  auth-service:     # :8082
  user-service:     # :8081
  customer-service: # :8083
  shop-service:     # :8084
  order-service:    # :8085
  driver-service:   # :8086
  logistics-service:# :8087
  gateway-service:  # :8090

  # 前端
  frontend:         # :80
```

</div>

<div>

### 部署特性
- 支持 `docker compose up -d` 整体部署（含healthcheck启动顺序保障）
- 已完成 Apple Silicon 兼容性验证
- 基础环境可自动初始化，演示数据通过脚本补充
- 网关统一入口 + 服务发现
- 前后端分离 + Nginx反向代理

<div class="mt-4 border-l-4 border-blue-500 pl-3 py-2 bg-blue-50 dark:bg-blue-900/20 rounded">
<div class="font-bold">容器化部署</div>
<div class="text-sm font-mono">docker compose up -d</div>
</div>

</div>

</div>

---
layout: section
---

# 五、智能算法设计

路径规划 · 末端聚类 · 运力规划

---

# 路径规划 — 策略模式架构

<div class="grid grid-cols-2 gap-6">

<div>

### 设计思想

采用<strong>策略模式</strong>封装三种路径规划算法，通过配置文件切换：

```yaml
routing:
  strategy: A_STAR  
  # A_STAR / LLM_JUDGE / LLM_WAYPOINT
```

<div class="mt-4">

```java
// 策略接口
public interface RouteStrategy {
    RouteResult planRoute(
        double startLat, double startLon,
        double endLat, double endLon
    );
}
```

</div>

<div class="mt-3 bg-green-50 dark:bg-green-900/20 p-3 rounded border-l-4 border-green-500">
<strong>策略可扩展</strong>：新增策略无需修改调用方代码<br/>
<strong>配置切换</strong>：`@Primary` Bean动态注入
</div>

</div>

<div>

### 三种策略实现

<div class="space-y-3 mt-2">

<div class="border rounded p-3">
<div class="font-bold">AStarRouteStrategy</div>
<div class="text-sm">纯A*算法，基于GraphHopper路网</div>
<div class="text-xs opacity-70">ε=1.0最短路 / ε>1加权搜索</div>
</div>

<div class="border rounded p-3 bg-yellow-50 dark:bg-yellow-900/20">
<div class="font-bold">LlmJudgeRouteStrategy</div>
<div class="text-sm">方案A：多候选 + 大语言模型(LLM)裁判</div>
<div class="text-xs opacity-70">3条候选路线 → LLM选择最优</div>
</div>

<div class="border rounded p-3 bg-purple-50 dark:bg-purple-900/20">
<div class="font-bold">LlmWaypointRouteStrategy</div>
<div class="text-sm">方案B：大语言模型(LLM)决策路点 + A*分段</div>
<div class="text-xs opacity-70">LLM上层建议 + A*底层寻路</div>
</div>

</div>

</div>

</div>

---

# 路径规划 — 大语言模型(LLM) Judge 裁判策略

<div class="mt-2">

### 执行流程

<div class="flex items-center justify-center gap-2 mt-4 text-sm">

<div class="border rounded p-2 bg-blue-50 dark:bg-blue-900/20 text-center" style="min-width:120px">
<div class="font-bold">① 候选生成</div>
<div class="text-xs">ε=1.0/1.8/3.5</div>
<div class="text-xs">3条差异化路线</div>
</div>

→

<div class="border rounded p-2 bg-green-50 dark:bg-green-900/20 text-center" style="min-width:120px">
<div class="font-bold">② 去重</div>
<div class="text-xs">距离差&lt;1%</div>
<div class="text-xs">去除重复路线</div>
</div>

→

<div class="border rounded p-2 bg-orange-50 dark:bg-orange-900/20 text-center" style="min-width:120px">
<div class="font-bold">③ 上下文组装</div>
<div class="text-xs">历史速度·延误</div>
<div class="text-xs">慢速热点</div>
</div>

→

<div class="border rounded p-2 bg-purple-50 dark:bg-purple-900/20 text-center" style="min-width:120px">
<div class="font-bold">④ LLM裁决</div>
<div class="text-xs">DeepSeek API</div>
<div class="text-xs">JSON返回</div>
</div>

</div>

</div>

<div class="grid grid-cols-2 gap-4 mt-6">

<div class="bg-green-50 dark:bg-green-900/20 p-3 rounded border-l-4 border-green-500">
<strong>关键设计</strong>：大语言模型(LLM)只做"选择"而非"生成"，路线坐标全部来自A*（真实路网），通过约束输出范围和失败降级降低不可控输出的影响
</div>

<div class="bg-blue-50 dark:bg-blue-900/20 p-3 rounded border-l-4 border-blue-500">
🛡️ <strong>降级容错</strong>：LLM调用失败时自动回退ε=1.0标准A*路线，系统核心不依赖LLM
</div>

</div>

---

# 路径规划 — 大语言模型(LLM) Waypoint 路点策略

<div class="mt-2">

### 分层决策架构

<div class="flex items-center justify-center gap-4 mt-4">

<div class="border-2 rounded p-4 bg-purple-50 dark:bg-purple-900/20 text-center" style="min-width:180px">
<div class="text-lg font-bold mb-1">🧠 LLM 上层建议</div>
<div class="text-sm">提供方向性路点建议</div>
<div class="text-xs mt-1">输出0-2个路点</div>
<div class="text-xs opacity-70">基于历史交通数据</div>
</div>

<div class="text-2xl">⇄</div>

<div class="border-2 rounded p-4 bg-blue-50 dark:bg-blue-900/20 text-center" style="min-width:180px">
<div class="text-lg font-bold mb-1">🗺️ A* 底层寻路</div>
<div class="text-sm">计算具体路径</div>
<div class="text-xs mt-1">分段A*路径拼接</div>
<div class="text-xs opacity-70">基于真实路网</div>
</div>

</div>

</div>

<div class="grid grid-cols-3 gap-3 mt-6">

<div class="border rounded p-3 text-center">
<div class="font-bold text-sm">地理校验</div>
<div class="text-xs mt-1">上海市区范围校验</div>
<div class="text-xs opacity-70">纬度30.6°~31.9°<br/>经度120.8°~122.2°</div>
</div>

<div class="border rounded p-3 text-center">
<div class="font-bold text-sm">分段拼接</div>
<div class="text-xs mt-1">起点→路点1→路点2→终点</div>
<div class="text-xs opacity-70">各段独立A*计算</div>
</div>

<div class="border rounded p-3 text-center">
<div class="font-bold text-sm">降级容错</div>
<div class="text-xs mt-1">LLM失败回退标准A*</div>
<div class="text-xs opacity-70">保证系统可用性</div>
</div>

</div>

---

# K-Means 末端聚类调度

<div class="grid grid-cols-2 gap-6 mt-4">

<div>

### 算法流程

<div class="space-y-2 mt-2 text-sm">
<div class="border-l-4 border-blue-500 pl-3 py-1">
<span class="font-bold">① 特征提取</span> — 经纬度坐标
</div>
<div class="border-l-4 border-green-500 pl-3 py-1">
<span class="font-bold">② 均匀抽样初始化</span> — k = ⌈√n⌉（默认值）
</div>
<div class="border-l-4 border-orange-500 pl-3 py-1">
<span class="font-bold">③ EM迭代</span> — Haversine距离，分配不变或100次迭代
</div>
<div class="border-l-4 border-purple-500 pl-3 py-1">
<span class="font-bold">④ 簇内排序</span> — 近似TSP贪心
</div>
<div class="border-l-4 border-pink-500 pl-3 py-1">
<span class="font-bold">⑤ LLM辅助分析</span>（可选扩展）— 簇间合并建议
</div>
</div>

</div>

<div>

<div class="flex justify-center">
<img src="/figures/kmeans-dispatch-preview.png" class="h-56 rounded shadow" />
</div>

<div class="mt-2 bg-yellow-50 dark:bg-yellow-900/20 p-3 rounded border-l-4 border-yellow-500 text-sm">
<strong>两处实现：</strong><br/>
① KMeansClusterServiceImpl — 调度预览（k=⌈√n⌉，100次迭代）<br/>
② LogisticsBatchServiceImpl — 末端分组（k=⌈N/4⌉，50次迭代，每司机≤4停靠点）
</div>

</div>

</div>

---

# MCMF 全国运力规划

<div class="grid grid-cols-2 gap-6 mt-4">

<div>

### Hub-and-Spoke 网络模型

<div class="mt-2 text-sm">
- Hub三级层次：全国枢纽(0) / 省级中心(1) / 城市配送中心(2)
- 每Hub拆<strong>入港</strong>+<strong>出港</strong>两个节点
- 超级源S → 供给Hub → 中转Hub → 需求Hub → 超级汇T
</div>

### 两种算法实现

<div class="space-y-2 mt-2">
<div class="border rounded p-2">
<div class="font-bold text-sm">单商品MCMF</div>
<div class="text-xs">SSP + SPFA · 适合单一品类</div>
</div>
<div class="border rounded p-2 bg-green-50 dark:bg-green-900/20">
<div class="font-bold text-sm">多商品MCMF ★ 推荐</div>
<div class="text-xs">Dijkstra-SSP · 按OD对需求量降序处理</div>
</div>
</div>

</div>

<div>

<div class="flex justify-center">
<img src="/figures/mcmf-flow-plan.png" class="h-48 rounded shadow" />
</div>

<div class="mt-2 text-sm">

### 关键设计
- 📊 LLM费率校准（可选扩展）— 动态调整边费用
- 🔄 残差网络 — 邻接表实现
- 📈 收敛保证 — SSP保证找到最优解

</div>

</div>

</div>

---

# 路径规划样例实验对比

<div class="flex justify-center mt-4">
<img src="/figures/routing-benchmark.png" class="h-72 rounded shadow" />
</div>

<div class="text-center text-sm opacity-70 mt-2">
三种策略在若干OD对上的距离与时间对比（样例验证，不构成普适统计结论）
</div>

---
layout: section
---

# 六、系统测试与运行结果

---

# 三类验证

<div class="grid grid-cols-3 gap-6 mt-4">

<div>

### 功能可用性验证

<div class="space-y-2 mt-2">
<div class="border-l-4 border-blue-500 pl-3 py-1 text-sm">
用户注册/登录/鉴权
</div>
<div class="border-l-4 border-green-500 pl-3 py-1 text-sm">
个人寄件全流程
</div>
<div class="border-l-4 border-purple-500 pl-3 py-1 text-sm">
商户仓库/库存管理
</div>
<div class="border-l-4 border-orange-500 pl-3 py-1 text-sm">
运输员任务接受与地图导航
</div>
<div class="border-l-4 border-teal-500 pl-3 py-1 text-sm">
仓储入/出库/转运/派送
</div>
<div class="border-l-4 border-pink-500 pl-3 py-1 text-sm">
K-Means调度预览 & MCMF运力规划
</div>
</div>

<div class="mt-2 text-xs opacity-60">结论：核心业务流程可正常运行</div>

</div>

<div>

### 算法行为验证

<div class="space-y-2 mt-2">
<div class="border-l-4 border-blue-500 pl-3 py-1 text-sm">
A*路径规划 — 上海OSM路网
</div>
<div class="border-l-4 border-green-500 pl-3 py-1 text-sm">
大语言模型(LLM) Judge裁判策略 — 候选生成+裁决
</div>
<div class="border-l-4 border-purple-500 pl-3 py-1 text-sm">
大语言模型(LLM) Waypoint路点策略 — 分层决策
</div>
<div class="border-l-4 border-orange-500 pl-3 py-1 text-sm">
K-Means聚类 — 多组订单验证
</div>
<div class="border-l-4 border-teal-500 pl-3 py-1 text-sm">
MCMF运力规划 — Hub网络样例
</div>
</div>

<div class="mt-2 text-xs opacity-60">结论：算法行为可观察，但样例规模有限</div>

</div>

<div>

### 部署验证

<div class="space-y-2 mt-2">
<div class="border-l-4 border-blue-500 pl-3 py-1 text-sm">
Docker Compose整体部署
</div>
<div class="border-l-4 border-green-500 pl-3 py-1 text-sm">
Apple Silicon 兼容性
</div>
<div class="border-l-4 border-purple-500 pl-3 py-1 text-sm">
数据库初始化脚本
</div>
</div>

<div class="mt-2 text-xs opacity-60">结论：环境可搭建、系统可运行</div>

</div>

</div>

---

# 系统运行界面

<div class="grid grid-cols-3 gap-3 mt-4">

<div>
<img src="/figures/create-order-confirm.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">订单确认</div>
</div>

<div>
<img src="/figures/warehouse-inventory.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">仓库库存</div>
</div>

<div>
<img src="/figures/product-browse.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">商品浏览</div>
</div>

<div>
<img src="/figures/register.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">注册页面</div>
</div>

<div>
<img src="/figures/shop-products.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">商户商品</div>
</div>

<div>
<img src="/figures/driver-tasks.png" class="rounded shadow h-36" />
<div class="text-center text-xs mt-1">运输员任务</div>
</div>

</div>

---
layout: section
---

# 七、总结与展望

---

# 论文总结

<div class="grid grid-cols-2 gap-6 mt-4">

<div>

### 主要工作

<div class="space-y-2 mt-2">
<div class="border-l-4 border-blue-500 pl-3 py-2 text-sm">
📐 完成了智能物流系统的<strong>需求分析与五层微服务架构设计</strong>
</div>
<div class="border-l-4 border-green-500 pl-3 py-2 text-sm">
⚙️ 基于 Spring Cloud Alibaba 实现了 <strong>8个微服务 + Vue3前端</strong>
</div>
<div class="border-l-4 border-purple-500 pl-3 py-2 text-sm">
🧠 构建了<strong>可切换的路径规划策略框架</strong>（3种策略可切换）
</div>
<div class="border-l-4 border-orange-500 pl-3 py-2 text-sm">
🤖 尝试了 <strong>大语言模型(LLM)与确定性算法的受限组合</strong>决策模式
</div>
<div class="border-l-4 border-teal-500 pl-3 py-2 text-sm">
📊 将 K-Means末端聚类 和 MCMF运力规划<strong>接入业务流程界面</strong>
</div>
<div class="border-l-4 border-pink-500 pl-3 py-2 text-sm">
🐳 完成了 Docker Compose <strong>全栈容器化部署</strong>
</div>
</div>

</div>

<div>

### 本文工作总结

<div class="space-y-3 mt-2">

<div class="bg-gradient-to-r from-blue-50 to-purple-50 dark:from-blue-900/20 dark:to-purple-900/20 p-3 rounded">
<div class="font-bold">🎯 可切换的路径规划策略框架</div>
<div class="text-sm mt-1">在物流微服务系统中实现了三种策略的运行时切换，便于比较和扩展</div>
</div>

<div class="bg-gradient-to-r from-green-50 to-teal-50 dark:from-green-900/20 dark:to-teal-900/20 p-3 rounded">
<div class="font-bold">🤖 大语言模型(LLM)受限增强决策</div>
<div class="text-sm mt-1">将LLM限制在裁决/路点建议角色，设置规则校验与降级机制，系统核心不依赖LLM</div>
</div>

<div class="bg-gradient-to-r from-orange-50 to-red-50 dark:from-orange-900/20 dark:to-red-900/20 p-3 rounded">
<div class="font-bold">📊 K-Means与MCMF的工程验证</div>
<div class="text-sm mt-1">将K-Means与MCMF接入实际业务流程界面，完成了可运行的系统验证</div>
</div>

</div>

</div>

</div>

---

# 未来展望

<div class="grid grid-cols-2 gap-4 mt-6">

<div class="border rounded p-4">
<div class="text-xl mb-2">🚀</div>
<div class="font-bold">算法优化</div>
<div class="text-sm mt-1">
- 引入强化学习优化路径规划<br/>
- 多目标优化（时间·成本·碳排放）<br/>
- 动态定价与实时调度
</div>
</div>

<div class="border rounded p-4">
<div class="text-xl mb-2">📈</div>
<div class="font-bold">系统扩展</div>
<div class="text-sm mt-1">
- Kubernetes容器编排<br/>
- 分布式链路追踪<br/>
- 灰度发布与熔断降级
</div>
</div>

<div class="border rounded p-4">
<div class="text-xl mb-2">🤖</div>
<div class="font-bold">大语言模型(LLM)深化</div>
<div class="text-sm mt-1">
- 本地化模型部署（隐私保护）<br/>
- 多模态理解（图像·语音）<br/>
- 智能体自主决策与工具调用
</div>
</div>

<div class="border rounded p-4">
<div class="text-xl mb-2">🌍</div>
<div class="font-bold">业务拓展</div>
<div class="text-sm mt-1">
- 跨境物流与多式联运<br/>
- 冷链物流温控集成<br/>
- 供应链金融数据打通
</div>
</div>

</div>

---

# 致谢

<div class="text-center mt-16">

感谢牛志华老师的悉心指导！

感谢各位评审老师！

</div>

<div class="abs-br m-6 text-sm opacity-50">
  Q & A
</div>

---
layout: center
class: text-center
---

# 谢谢！

<div class="mt-8 text-2xl opacity-60">
答辩人：付苗 &nbsp;|&nbsp; 指导教师：牛志华
</div>

<div class="mt-4 text-lg opacity-40">
基于微服务架构的智能物流管理系统
</div>
