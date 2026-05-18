# PNG 截图回收价值分析报告

> 分析范围：`/Users/miao/CodeBuddy/Transportation`（原项目）与 `/Users/miao/CodeBuddy/thesis-transportation`（当前论文项目）
> 分析目的：识别两个目录中未被论文主文件 `template/thesis.typ` 使用的 PNG 截图，评估其回收再利用价值

---

## 一、当前论文中被引用的图片清单（共 22 张）

论文 `template/thesis.typ` 实际通过 `#imagex(image("figures/xxx.png"))` 引用的图片如下：

| 序号 | 文件名 | 类型 | 备注 |
|------|--------|------|------|
| 1 | logistics-service-mode.png | 需求分析-服务模式示意图 | |
| 2 | e-commerce-flow.png | 需求分析-流程图 | |
| 3 | person-use-case.png | 需求分析-用例图 | |
| 4 | business-use-case.png | 需求分析-用例图 | |
| 5 | driver-use-case.png | 需求分析-用例图 | |
| 6 | warehouse-use-case.png | 需求分析-用例图 | |
| 7 | architecture-overview.png | 系统设计-架构总览图 | |
| 8 | core-business-flow.png | 系统设计-核心业务流 | |
| 9 | frontend-architecture.png | 系统设计-前端架构 | |
| 10 | cache-comparison.png | 系统测试-缓存对比 | |
| 11 | routing-benchmark.png | 系统测试-压测结果 | |
| 12 | login.png | UI 截图-登录页 | |
| 13 | register.png | UI 截图-注册页 | |
| 14 | create-order-pickup.png | UI 截图-发起寄件 | |
| 15 | create-order-confirm.png | UI 截图-下单确认 | |
| 16 | order-detail.png | UI 截图-订单详情与物流轨迹 | |
| 17 | shop-products.png | UI 截图-商户商品管理 | |
| 18 | warehouse-inventory.png | UI 截图-仓库与库存管理 | |
| 19 | driver-tasks.png | UI 截图-司机待接单大厅 | |
| 20 | driver-map.png | UI 截图-导航与路线地图 | |
| 21 | kmeans-dispatch-preview.png | 算法截图-K-Means 调度预览 | |
| 22 | mcmf-flow-plan.png | 算法截图-MCMF 流规划 | |

---

## 二、当前论文项目中"有文件但论文未引用"的 PNG（活跃目录，非 archive/backup）

当前 `template/figures/` 目录下共有 25 张 PNG，其中 **3 张未被 `thesis.typ` 引用**：

| 文件名 | 大小 | 现状分析 | 回收价值 |
|--------|------|----------|----------|
| **login-register.png** | 51.72 KB（原项目同名文件）| 论文中分别引用了 `login.png` 和 `register.png`，此图为两者合并版，从未被引用 | **低**。原项目遗留，当前论文已拆分使用 |
| **product-browse.png** | 64.38 KB | 仅在 `slides/slides.md` 中被引用（答辩 PPT），论文正文 **未引用** | **中**。论文前端章节描述了"商品浏览"功能，但无配图；可作为补充截图回收 |
| **er-diagram.png** | 200.54 KB | 仅在 `slides/slides.md` 和测试文件 `template/test-er3.typ` 中引用，`thesis.typ` **未引用** | **高**。图片审查报告曾指出论文"没有标准 E-R 图"，此图已存在但未插入正文，回收只需修改 thesis.typ 添加引用 |

### 结论（当前项目内部回收）

- **er-diagram.png**：零成本回收，直接插入论文即可弥补"缺 E-R 图"的缺陷。
- **product-browse.png**：如果论文章节需要商品浏览截图，可低成本回收；否则维持仅在 PPT 中使用亦可。
- **login-register.png**：无回收价值，建议删除或移入 archive。

---

## 三、Transportation 原项目中有、当前论文项目中完全没有的 PNG

原项目 `thesis-typst/template/figures/` 中存在、当前论文 `template/figures/`（含 archive/backup）中**完全缺失**的文件：

| 文件名 | 原项目大小 | 内容描述 | 回收价值评估 |
|--------|-----------|----------|-------------|
| **order-tracking.png** | 64.38 KB | 订单追踪页面 | **中**。论文正文在 `@order-detail` 处描述了"订单详情与物流轨迹页面"，已用 `order-detail.png` 覆盖。若需要单独的"订单追踪"入口截图，可回收；否则功能已被覆盖 |
| **admin-dash.png** | 69.9 KB | 管理员仪表盘 | **中**。论文第 720 行提到管理员角色拥有"仪表盘概览"功能，但**全文无任何管理员仪表盘配图**。若系统管理员端有真实的仪表盘页面，此图可回收 |
| **admin-dashboard.png** | 65.06 KB | 管理员仪表盘（另一版本）| 同上，与 admin-dash.png 内容相近，选其一即可 |
| **admin-review.png** | 35.71 KB | 用户审核管理页面 | **低**。图片审查报告已指出此图为空状态（"暂无待审核用户"），学术价值低。需重新截图才有意义 |
| **hub-operations.png** | 64.35 KB | 中转站列表与 Hub 作业台 | **低**。图片审查报告定性为**严重错误**——该图实际是司机端配送管理页面，与图题完全不符。不具备回收价值，必须重新运行系统截图 |
| **last-mile-dispatch.png** | 64.35 KB | 末端调度预览与配送批次详情 | **低**。同上，严重错配，必须重新截图 |
| **national-network.png** | 64.35 KB | 全国网络拓扑与运力规划结果 | **低**。同上，严重错配，必须重新截图 |
| **energy-distribution.png** | 41.84 KB | 能源分布图 | **无**。图表改进方案已标记为"遗留/未使用"，与论文主题无关 |
| **fletcher.png** | 273.05 KB | Fletcher 测试图 | **无**。图表改进方案已标记为"遗留/未使用"，为工具测试产物 |
| **sign.png** | 131.53 KB | 签名/签字页 | **无**。图表改进方案已标记为"遗留/未使用" |
| **LoginBackground.png** | 64.18 KB | 前端登录页背景图 | **无**。这是前端工程资源，非论文配图 |

### 关键结论（跨项目回收）

- **零文件可直接无脑复制回收**：原项目中与当前论文**同名**的 PNG，当前项目基本都已有更新版本（如 `driver-map.png` 从 64 KB 升级到 629 KB，`driver-tasks.png` 从 64 KB 升级到 165 KB），说明已重新截图过。原项目的旧版本质量更差，无回收意义。
- **唯一可能回收的是 admin-dash.png / admin-dashboard.png**：如果原项目中的管理员仪表盘截图是**真实、非空状态**的，则当前论文正缺少此配图，可以直接拷贝使用。
- **order-tracking.png 价值有限**：当前论文已用 `order-detail.png` 的"时间线物流轨迹"覆盖了订单追踪的展示需求，单独再加一张追踪页截图意义不大。

---

## 四、当前论文 archive/backup 中的"沉睡资产"

### archive/（38 张 PNG，19 个 typ 测试文件）

| 类别 | 文件示例 | 说明 |
|------|---------|------|
| 旧版 UI 截图 | `admin-dash-new.png`、`login-new.png`、`register-new.png` 等 | 带 `-new` 后缀的是已替换的新版本截图，不带后缀的是旧版本 |
| ER 图测试产物 | `test-er.png`、`test-er2.png`、`test-er3.png`、多个 `test-er-config-*.png` | Mermaid/Fletcher 渲染 ER 图的调试产物 |
| 错配占位图 | `hub-operations.png`、`last-mile-dispatch.png`、`national-network.png` | 图片审查报告中的"严重错误"截图，已全部移入 archive |
| 废弃合并图 | `test-er-combined.png` | 多 ER 子图拼接测试 |

**回收价值**：极低。archive 是有意保留的历史版本，除 `test-er-solution-A/B.png` 等可能作为绘图方案对比参考外，不应再放回论文。

### backup/（12 张 PNG）

被替换的旧版本图片，如旧 `architecture-overview.png`、旧 `er-diagram.png`、旧 `frontend-architecture.png` 等。

**回收价值**：无。备份目的是回滚，不应重新启用。

---

## 五、回收行动建议（优先级排序）

| 优先级 | 行动 | 理由 | 工作量 |
|--------|------|------|--------|
| **P0** | 将 `template/figures/er-diagram.png` 插入 `thesis.typ` 对应章节 | 图片审查报告明确指出的论文缺陷（"没有标准 E-R 图"），图已存在只需插入 | 极小（1 行代码） |
| **P1** | 评估 `product-browse.png` 是否插入论文 | 论文前端章节提到商品浏览功能但无配图，如需要则回收 | 极小 |
| **P1** | 检查 Transportation 原项目的 `admin-dash.png` / `admin-dashboard.png` 内容 | 若图为真实非空状态，拷贝到当前论文并插入管理员章节 | 小（需确认内容+插入） |
| **P2** | 删除或移入 archive：`login-register.png` | 活跃目录中的死文件，保持目录整洁 | 极小 |
| **P3** | 保持 `archive/` 和 `backup/` 现状 | 历史备份不应动 | 无 |
| **—** | **不回收**：`hub-operations.png`、`last-mile-dispatch.png`、`national-network.png`、`admin-review.png`（原项目版本） | 均为空状态或严重错配，回收无意义，必须重新运行系统截图 | — |

---

## 六、附录：两项目 PNG 文件名对照表

| 文件名 | Transportation（原项目） | thesis-transportation（当前） | 差异说明 |
|--------|------------------------|------------------------------|---------|
| architecture-overview.png | 138.67 KB | 148.09 KB | 当前已更新 |
| create-order-pickup.png | 99.30 KB | 150.31 KB | 当前已更新 |
| driver-map.png | 64.42 KB | **629.15 KB** | 当前已大幅更新（可能已重新截图） |
| driver-tasks.png | 64.43 KB | 165.48 KB | 当前已更新 |
| login.png | 80.39 KB | 72.01 KB | 接近，可能为同一图 |
| order-detail.png | 335.59 KB | 123.57 KB | 当前版本更小 |
| register.png | 98.29 KB | 92.90 KB | 接近，可能为同一图 |
| core-business-flow.png | ❌ 无 | ✅ 有 | 当前新增 |
| er-diagram.png | ❌ 无 | ✅ 有 | 当前新增 |
| kmeans-dispatch-preview.png | ❌ 无 | ✅ 有 | 当前新增 |
| mcmf-flow-plan.png | ❌ 无 | ✅ 有 | 当前新增 |
| admin-dash.png | ✅ 有 | ❌ 无 | 仅原项目有 |
| admin-dashboard.png | ✅ 有 | ❌ 无 | 仅原项目有 |
| admin-review.png | ✅ 有 | ❌ 无（archive 中无） | 仅原项目有 |
| hub-operations.png | ✅ 有 | ❌ 无（archive 中有旧版） | 原项目=当前 archive 旧版 |
| last-mile-dispatch.png | ✅ 有 | ❌ 无（archive 中有旧版） | 原项目=当前 archive 旧版 |
| national-network.png | ✅ 有 | ❌ 无（archive 中有旧版） | 原项目=当前 archive 旧版 |
| order-tracking.png | ✅ 有 | ❌ 无 | 仅原项目有 |
| energy-distribution.png | ✅ 有 | ❌ 无 | 遗留文件，无价值 |
| fletcher.png | ✅ 有 | ❌ 无 | 遗留文件，无价值 |
| sign.png | ✅ 有 | ❌ 无 | 遗留文件，无价值 |
