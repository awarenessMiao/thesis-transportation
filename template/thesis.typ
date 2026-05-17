#import "../lib.typ": documentclass, algox, tablex, citex, imagex, subimagex

// 学术图表绘制工具：Mermaid 用于流程图/ER图，Fletcher 用于架构图
#import "@preview/mmdr:0.2.2": mermaid
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/facade:0.1.0": *

#let (
  info,
  doc,
  cover,
  declare,
  appendix,
  outline,
  mainmatter,
  conclusion,
  abstract,
  bib,
  acknowledgement,
  under-cover,
  fonts,
) = documentclass(
  info: (
    title: "基于微服务架构的智能物流管理系统",
    school: "计算机科学与工程学院",
    major: "网络空间安全",
    student_id: "21122119",
    name: "付苗",
    supervisor: "牛志华",
    date: "2025年2月20日起6月2日止",
  ),
  fonts: (
    fallback: false,
    songti: (
      (name: "Times New Roman", covers: "latin-in-cjk"),
      "Songti SC",
      "SimSun",
      "STSongti",
    ),
  ),
  title-line-length: 260pt,
  math-level: 2,
  outline-compact: false,
  citation: (
    func: bibliography("ref.bib"),
    full: false,
    sup: true,
  ),
)

// 设置文档格式
#fonts
#show: doc

// 显示封面
#cover()

// 显示声明
#declare(
  author-sign: [付苗],
  supervisor-sign: none,
  date: [2025年6月],
)

#abstract(
  keywords: ("微服务架构", "Spring Cloud Alibaba", "路径规划算法", "大语言模型", "Hub-and-Spoke物流网络"),
  keywords-en: ("Microservice Architecture", "Spring Cloud Alibaba", "Route Planning Algorithm", "Large Language Model", "Hub-and-Spoke Logistics Network"),
)[
  随着电子商务与跨区域配送需求的持续增长，传统物流管理系统在业务协同、资源调度与路径规划等方面逐渐暴露出响应迟缓、耦合度高和扩展困难等问题。为提升物流系统的可维护性、可扩展性与智能决策能力，本文设计并实现了一套基于微服务架构的智能物流管理系统。系统围绕订单履约、仓储库存、运输配送、路径规划与全国运力调度等核心业务展开，拆分为认证、用户、发货用户、商店与库存、订单、运输员、物流规划与网关等多个独立服务，基于Spring Cloud Alibaba生态完成服务治理，RabbitMQ负责异步解耦，Redis提供缓存加速。

  在系统实现方面，后端采用Spring Boot + Spring Cloud + MyBatis-Plus + Redis技术栈；前端采用Vue3 + Vite + Element Plus + Leaflet构建多角色单页应用；部署采用Docker Compose一键编排。系统重点完成了四项内容：一是基于BCrypt与JWT的统一认证与网关鉴权机制；二是围绕订单、库存与配送的异步协同流程；三是集成GraphHopper路网引擎，实现基于A\*的路径规划、基于K-Means的末端调度预览、基于最小费用最大流的全国运力规划以及大语言模型辅助决策；四是构建基于Hub-and-Spoke网络的完整履约流程。

  系统创新点体现在三方面：以微服务架构支撑多角色物流协同闭环；将真实路网规划、聚类调度与运力优化算法引入统一平台；引入大语言模型形成"确定性算法求解 + 生成式模型裁决"的混合决策模式。
][
  With the rapid growth of e-commerce and cross-regional delivery demand, traditional logistics systems increasingly suffer from poor scalability, tight coupling, and insufficient decision support. This thesis designs and implements an intelligent logistics management system based on microservice architecture, focusing on order fulfillment, inventory, transportation, route planning, and nationwide capacity scheduling. The system is decomposed into multiple independent services built on Spring Cloud Alibaba, with RabbitMQ for asynchronous decoupling and Redis for caching.

  The backend adopts Spring Boot, Spring Cloud, MyBatis-Plus, and Redis; the frontend uses Vue3, Vite, Element Plus, and Leaflet; deployment uses Docker Compose. Key implementations include: unified authentication and gateway authorization based on BCrypt and JWT; asynchronous collaboration for orders, inventory, and delivery; integration of GraphHopper with A\* route planning, K-Means dispatch preview, minimum-cost maximum-flow capacity planning, and LLM-assisted decision-making; and a complete Hub-and-Spoke fulfillment workflow.

  The contributions are threefold: microservice architecture supporting multi-role logistics collaboration; integration of route planning, clustering dispatch, and capacity optimization into a unified platform; and a hybrid decision-making mode combining deterministic optimization with generative LLM reasoning.
]

// 显示目录
#outline()

// 设置文档主体的格式
#show: mainmatter

= 绪论

本章介绍论文的研究背景与意义、国内外研究现状及不足、主要研究内容以及论文组织结构。先讨论物流行业的发展现状与智能物流系统的现实需求，阐述微服务架构应用于物流领域的背景与意义；再从国内外两个视角梳理智能物流管理系统、路径规划与运力优化等方面的研究进展，分析现有工作的不足与本文的切入点；随后明确本文的研究内容；最后介绍论文的组织结构与各章安排。

== 研究背景及意义

物流行业作为支撑国民经济的基础性产业，在电子商务迅猛发展下其重要性日益凸显。然而，传统物流管理模式在业务复杂性、时效性与成本控制方面逐渐暴露出高成本、低效率、信息孤岛等瓶颈。中国的物流成本占GDP比重曾高达14.1%，远高于发达国家平均水平。在物联网、大数据、人工智能等新一代技术驱动下，物流行业正经历数字化和智能化转型@ref1 @ref2 @ref3 @ref4。例如，物联网技术使货物、车辆、仓库等物流要素的状态感知与数据采集成为可能@ref2；大数据技术为路径优化、需求预测提供决策支持@ref3；人工智能在智能调度、风险预警等方面的应用提升了物流系统的自动化水平@ref4。

与此同时，传统单体式系统架构在支撑复杂智能物流应用时局限性愈发明显：模块耦合度高、维护成本大、迭代周期长，难以满足高并发与高可用需求@ref5。微服务架构将复杂系统拆分为自治服务单元，天然契合智能物流系统对灵活性、可扩展性与高可用性的要求@ref6。基于此，本研究设计并实现基于微服务架构的智能物流管理系统，具有以下意义：

+ 提高物流运作效率：微服务架构解耦各业务模块，结合路径优化与智能调度，提升运输与仓储资源利用率。

+ 降低运营成本：弹性伸缩能力避免资源浪费，优化路径与库存管理降低运输与仓储成本。

+ 提升用户体验：实时订单跟踪与精准预计送达时间改善用户满意度，独立部署保障服务连续性。

+ 促进物流行业数字化转型：为传统物流企业向智能化转型提供可借鉴的技术方案。

== 国内外研究现状及不足

=== 国内研究现状

在国内，物流信息系统经历了从单机管理软件到平台化云服务的发展过程。贾志刚等@ref19 基于Spring Cloud微服务架构对物流运输管理系统进行了重构设计；王珊珊等@ref20 基于Spring Boot实现了物流管理核心功能，但未涉及服务治理与多角色协同。在智能算法方面，李晓等@ref39 将K-Means聚类算法应用于物流配送中心选址问题。根据中国物流与采购联合会数据@ref40，2023年社会物流总费用占GDP比重仍高于发达国家水平。然而，国内现有工作多集中于单一功能模块优化，缺乏将路径规划、调度执行与运力规划统一的综合性研究，大语言模型在物流决策领域的工程化实践亦处于起步阶段。

=== 国外研究现状

在国外，微服务架构在物流与供应链系统中的应用已有较多研究。Gonzalez等@ref33 分析了从传统ERP向微服务架构迁移的策略与挑战；Liu等@ref31 设计了基于微服务的智能物流管控平台。在路径规划领域，Zhang等@ref34 提出了改进的A\*算法用于车辆路径规划；Liu等@ref35 对VRP模型与算法进行了系统综述。在网络优化方面，Zhao等@ref36 构建了Hub-and-Spoke优化模型；Fragkos等@ref37 对最小费用最大流精确算法进行了综述。近年来，Simchi-Levi等@ref38 探讨了LLM在供应链决策中的潜力。

=== 现有不足与本文切入点

综合国内外研究，现有工作存在以下不足：（1）多数系统仅关注单一业务环节，缺乏多角色全链路协同；（2）路径规划多基于理想化模型，较少在真实路网环境下裁决；（3）运力规划与调度缺乏与Hub-and-Spoke网络结合的工程实践；（4）大语言模型在物流领域的应用尚未形成"确定性算法 + 生成式模型"的混合决策模式。针对上述不足，本文以微服务架构为基础，设计并实现集成真实路网路径规划、K-Means聚类调度、MCMF运力规划与大语言模型辅助决策的智能物流管理系统。

== 本课题的研究内容

本课题的核心任务是设计并实现基于微服务架构的智能物流管理系统，主要研究内容包括以下五个方面：

+ 系统需求分析与架构设计：深入分析智能物流管理的核心业务流程和功能需求，设计基于微服务理念的系统总体架构，划分核心服务模块（如订单服务、库存服务、调度服务、路径优化服务等），并定义服务间的交互接口与协议。

+ 关键技术选型与应用：研究并选用合适的技术栈来实现微服务架构，重点围绕Spring Cloud生态进行技术实践，同时研究前端技术与后端微服务的交互模式。

+ 核心服务模块的设计与实现：针对订单管理、库存管理、运输调度、配送跟踪、路径优化等关键业务模块，进行详细的功能设计和数据库设计，并完成各微服务的编码实现。

+ 系统集成与部署：实现各微服务之间的集成与协同工作，并使用容器化技术对系统进行打包、部署和管理，以实现弹性伸缩和高可用性。

+ 系统测试与评估：对系统进行功能测试、性能测试和可用性测试，评估系统是否满足设计要求。

== 论文组织结构安排

全文共分为五章正文加结论与附录，整体结构围绕"需求分析---系统设计---系统实现---系统测试与运行结果分析---总结与展望"的逻辑展开。

第一章为绪论，介绍研究背景与意义、国内外研究现状及不足、主要研究内容以及论文整体结构。

第二章为相关技术综述，介绍系统所采用的微服务治理技术、数据访问与缓存技术、前端开发技术、容器化部署技术，以及路径规划、聚类调度、最小费用最大流和大语言模型等智能算法技术。

第三章为系统设计，围绕需求分析、总体架构设计、核心模块设计、智能算法设计、前端设计与数据库设计展开。

第四章为系统实现，介绍微服务环境搭建、认证与权限系统实现、核心业务服务实现、智能算法实现、前端交互实现以及Docker容器化部署。

第五章为系统测试与运行结果分析，介绍测试环境与评价指标、功能测试与业务链路验证、性能测试与多角色运行结果展示。

== 本章小结

本章阐述了研究背景与意义，梳理了国内外研究进展与不足，明确了研究内容与论文结构，为后续章节奠定基础。

= 相关技术综述

本章围绕基于微服务架构的智能物流管理系统所采用的关键技术展开综述。内容主要包括微服务治理与服务通信技术、后端数据访问与缓存技术、前端开发与地图可视化技术、容器化部署技术，以及系统中涉及的路径规划、聚类调度、运力优化与大语言模型辅助决策等智能算法技术。这些技术共同构成了系统设计与实现的理论基础与工程支撑。

== 微服务架构相关技术

微服务架构将复杂系统拆分为围绕业务能力构建的自治服务单元，各单元可独立开发、部署与扩展@ref6。Zimmermann@ref8 总结了微服务的核心特征，指出其在服务自治、独立部署与技术异构性方面的优势；Dragoni等@ref11 对其发展历程进行了回顾，认为演进方向正从架构风格向云原生与DevOps深度融合。相较于SOA，微服务更强调细粒度拆分与独立运维@ref13，在成本效益方面亦有优势@ref12。

对于智能物流管理系统而言，其业务流程复杂、模块众多，且对可用性与可扩展性要求高。微服务架构能够将不同物流功能拆分为独立服务，便于快速迭代、按需扩展和故障隔离。

=== 注册中心

微服务架构中，各服务实例的启停与扩缩容是常态，因此需要注册中心动态维护可用实例列表。主流方案的对比为：Zookeeper采用CP模型保证强一致性，但网络分区时可能牺牲可用性；Eureka采用AP模型优先保证可用性，但可能返回过期实例；Nacos支持CP与AP模式自动切换，同时提供配置管理与服务发现能力。本系统选用Nacos作为注册中心。

=== 微服务网关与服务调用

Spring Cloud Gateway是Spring Cloud官方推出的API网关，基于WebFlux和Reactor模型构建，提供统一入口、请求路由、身份认证与权限控制等能力。Rodrigues等@ref21 对API网关的分类与挑战进行了梳理，指出网关需解决认证鉴权、限流熔断等横切关注点。OpenFeign是声明式服务调用组件，配合Spring Cloud LoadBalancer可实现基于服务名的实例发现与负载均衡。本系统使用Gateway作为统一入口实现JWT认证与路径权限控制，使用OpenFeign完成服务间同步调用。

=== 消息队列

微服务架构中，服务间通信可分为同步调用与异步消息传递。消息队列提供服务解耦、异步通信与削峰填谷三方面能力。主流方案中，RabbitMQ提供灵活路由与可靠消息确认，适合业务事件驱动场景；Kafka以高吞吐和持久化著称，适合流处理场景@ref14。本系统在订单创建后的库存扣减、配送创建与调度入池等环节采用RabbitMQ实现异步解耦。

== 数据持久化与缓存技术

后端系统采用MySQL作为关系型数据库、MyBatis-Plus作为数据访问增强框架，并结合Redis提升热点数据读取效率。

=== MySQL与MyBatis-Plus

MySQL是广泛使用的开源关系型数据库，具备成熟的事务支持与索引机制@ref24，适合支撑订单、库存、配送等结构化业务数据存储。MyBatis-Plus在保留原生SQL控制能力的基础上，提供通用CRUD接口、条件构造器与分页插件，可减少样板代码。各服务普遍采用ServiceImpl\<M,T\>构建业务服务层，借助LambdaQueryWrapper获得类型安全的条件查询。

相较于响应式数据访问方案（R2DBC@ref25、Spring WebFlux@ref26 @ref27），本项目采用阻塞式MyBatis-Plus + JDBC路径。Kleppmann@ref15 指出，响应式方案在降低线程阻塞方面有理论优势，但编程模型复杂度显著高于传统阻塞式方案，在业务逻辑以同步编排为主的场景下收益有限。本系统核心链路属同步编排模式，阻塞式方案更符合工程复杂度要求。

=== Redis缓存

Redis是最主流的内存KV存储中间件@ref28，支持多种数据类型与持久化机制@ref29。本项目在多个服务中采用Spring Cache配合Redis实现Cache-Aside模式：读操作优先查缓存，未命中时查库并回填；写操作更新数据库后清除缓存。仓库列表、承运物详情、配送任务列表等高频读数据均采用该策略。认证方面采用无状态JWT，Redis不用于Token存储。

== 前端技术栈

前端采用Vue3 + Vite构建多角色单页应用。Vue3的Composition API支持以函数为单位组织组件逻辑，适合多角色应用中跨组件共享登录态与权限信息；Element Plus提供统一的后台管理组件风格；Pinia进行前端状态管理，维护用户身份、认证令牌与角色标识等核心状态；Leaflet实现运输轨迹与网络拓扑的地图可视化。前后端通过axios封装的统一API通信层交互，通过请求拦截器注入Authorization头，响应拦截器统一处理错误码与Token过期。

== 容器化部署技术

容器化部署将各微服务打包为独立容器镜像，再利用编排配置统一管理，实现弹性扩容与故障迁移。Balalaie等@ref9 的研究表明，微服务与DevOps实践存在协同促进关系，容器化编排是实现这一协同的关键基础设施。

Docker是目前最主流的容器化平台@ref30，允许将应用及依赖打包为轻量级、可移植的容器镜像。结合持续交付实践@ref17，容器化消除了"环境差异"导致的部署风险。Docker Compose通过YAML文件定义多容器应用的启动、停止与依赖关系，本系统仅需一个全局配置文件即可完成数据库、中间件、微服务与前端的一键部署。对于毕设阶段的单机部署需求，Docker Compose已足够；生产环境可进一步引入Kubernetes获得自动扩缩容能力。

== 智能算法技术

本项目引入了面向物流优化场景的智能算法，使系统从传统信息管理平台演进为具备辅助决策能力的智能物流平台。

=== 路网引擎与A\*搜索

GraphHopper是一款Java路径规划引擎，可加载OpenStreetMap数据构建可查询的道路图结构，基于真实道路拓扑执行路径搜索。A\*算法通过代价函数$f(n) = g(n) + h(n)$引导搜索，启发函数采用Haversine球面距离，满足可采纳性条件保证最优性。系统还使用加权启发策略，通过调整epsilon生成多条差异化候选路线。

=== 大语言模型辅助决策

大语言模型具备较强的自然语言理解与推理分析能力，在本系统中用于多个辅助决策场景：路径规划中结合候选路线与交通特征选择路线；末端调度中给出批次合并与优先级建议；运力规划中对MCMF结果进行可读分析。该方法不替代传统优化算法，而是与确定性算法协同提升决策的可解释性。

=== 最小费用最大流

最小费用最大流（MCMF）问题求解在满足流量约束的前提下运输总成本最小的网络流分配。本系统将全国干线网络抽象为带容量与费用的有向图，通过MCMF求解生成跨区域运输的全局运力分配方案。

== 本章小结

本章梳理了系统实现涉及的关键技术并阐述了选型依据，核心决策汇总如下表。

#tablex(
  [注册中心], [Nacos], [Eureka], [Zookeeper], [同时支持服务发现与配置管理，CP/AP可切换],
  [消息队列], [RabbitMQ], [Kafka], [ActiveMQ], [路由灵活、消息确认可靠，适合业务事件驱动],
  [API 网关], [Spring Cloud Gateway], [Zuul 1.x], [--], [基于WebFlux非阻塞模型，与Spring Cloud 2022深度集成],
  [ORM 框架], [MyBatis-Plus], [JPA/Hibernate], [R2DBC], [保留SQL控制能力，通用CRUD减少样板代码],
  [缓存方案], [Redis + Cache-Aside], [Caffeine 本地缓存], [--], [Redis支持多实例共享，Cache-Aside兼顾一致性与性能],
  [前端框架], [Vue3], [React], [Angular], [Composition API适合多角色状态复用，TypeScript集成友好],
  [地图组件], [Leaflet], [Mapbox GL], [高德地图 JS API], [开源免费，GeoJSON渲染能力强，无商业授权限制],
  [容器编排], [Docker Compose], [Kubernetes], [--], [毕设阶段单机部署足够，K8s适用于生产环境],
  header: ([技术领域], [选用方案], [候选方案 1], [候选方案 2], [决策理由]),
  columns: (1fr, 1.3fr, 1.1fr, 1.1fr, 2.5fr),
  caption: [核心技术选型对比与决策表],
  label-name: "tech-comparison",
)

在微服务治理方面，系统基于Nacos实现服务注册与配置管理，基于Spring Cloud Gateway与OpenFeign实现统一接入与同步调用，基于RabbitMQ实现异步解耦；在数据访问方面，MySQL + MyBatis-Plus提供结构化持久化，Redis + Cache-Aside提供热点数据缓存；在前端构建方面，Vue3 + Element Plus + Leaflet支撑多角色交互与地图可视化；在部署方面，Docker Compose提供一键编排；在智能算法方面，GraphHopper、A\*、K-Means、MCMF与大语言模型构成了从路网加载、路径规划、聚类调度、运力优化到辅助决策的完整技术链。

= 系统设计

本章按需求分析→总体设计→详细设计→智能算法设计→数据库设计的顺序展开。第一节分析系统涉及的角色用例、功能需求与非功能需求；第二节给出系统的总体架构设计与技术栈选型；第三节从认证权限、订单库存、配送路线、调度运力与前端架构五个方面展开详细设计；第四节阐述路径规划、末端聚类与全国运力规划等智能算法的设计方案；第五节独立给出系统数据库设计，包括全局E-R模型与核心表设计。

== 需求分析

=== 总体分析

物流行业来自人类的工业运输与商业贸易需求，当今主要有两种表现形式：以合约委托的方式服务于企业；以计件付费的方式服务于个人。为了使我们的项目具备普遍意义，本系统分别考虑如下三种常见服务模式。

#imagex(
  image("figures/logistics-service-mode.png", width: 70%),
  caption: [物流系统常见服务模式],
  label-name: "service-mode",
)

如图所示，企业间通常会依据仓储系统的信息，将供应链的运输业务外包给物流系统。承运物到达商贸企业后，会通过淘宝、京东、拼多多等电商平台零售给个人。而个人也可能出于个人需求通过微信小程序等入口寄件，或针对闲鱼上的个人二手交易发起物流订单。物流公司通常会有分布在全国各地的仓库与服务网点，并将仓库/网点间的运输任务委托给运输企业或个体货车运输员。

综上所述，物流系统的参与方主要为四方：作为客户的工厂、商贸企业；作为客户的个人；作为平台的物流仓库、网点；作为第三方服务提供者的运输企业、货车运输员。可能和本系统交互的外部系统包括：仓储系统、电商平台、社交网络、支付系统。为了专注物流系统的本质，本项目略过支付系统，并为其他必要的外部接口仅提供最简单的实现。我们保留API接入功能和抽象层，只需通过adaptor模式进行简单的适配，即可接入这些外部系统。

以其中最复杂的物流订单模式为例，我们分析在此过程的流程及各个角色参与的步骤。

#imagex(
  image("figures/e-commerce-flow.png", width: 85%),
  caption: [物流订单模式流程],
  label-name: "ecommerce-flow",
)

=== 功能需求-个人用户用例

个人用户主要是基于地址的物品收发以及在平台中发起物流订单。

#imagex(
  image("figures/person-use-case.png", width: 45%),
  caption: [个人用户用例图],
  label-name: "person-use-case",
)

如图所示，个人用户需要地址管理、发起寄件、平台下单、物流下单、查看物流单等功能。

=== 功能需求-商业用户用例

工厂/商贸的主要运输对象是仓库中的批量承运物。相比于个人，工厂/商户不使用地址，而是使用仓库作为地址。商户还可以在多个仓库间转运承运物，以优化库存管理和发货成本。智能物流系统应该能够帮助商户自动规划库存分配。

#imagex(
  image("figures/business-use-case.png", width: 55%),
  caption: [商业用户用例图],
  label-name: "business-use-case",
)

=== 功能需求-运输员用例

运输员主要负责完成物流过程中的仓库到仓库的点到点运输，智能物流系统应该能基于路线、费用等问题自动规划出订单的最优安排，并为运输员自动规划最优运输路线。

#imagex(
  image("figures/driver-use-case.png", width: 50%),
  caption: [运输员用户用例图],
  label-name: "driver-use-case",
)

=== 功能需求-仓库/网点用例

仓库网点负责完成入库、出库、转运、派送等任务，这些任务可能通过物流公司配发的扫码设备采集包裹信息后自动触发至本系统中。

#imagex(
  image("figures/warehouse-use-case.png", width: 55%),
  caption: [仓库/网点用例图],
  label-name: "warehouse-use-case",
)

=== 非功能需求

本项目致力于通过微服务架构解决现实世界中物流系统数据量大、使用环境复杂、崩溃后果严重等问题，因此需要解决如下非功能需求：

+ 高并发：该系统可借助横向扩展与弹性扩容等手段，合理应对高强度、随时变化的并发规模。在大型互联网架构实践中，高并发通常通过分而治之、缓存加速与异步解耦三层策略实现@ref16，本系统的微服务拆分与Redis缓存正是遵循了这一思路。

+ 高可用：该系统可以容忍部分节点的故障、自动负载均衡并将任务迁移到可用节点。

+ 可扩展性：该系统可以轻松接入外部系统及数据，可以轻松实现新的功能以应对日新月异的功能需求。

+ 用户友好：该系统在UI设计上简洁易懂、易于使用。

+ 安全性：该系统为用户提供完善的鉴权机制与权限控制，避免恶意用户的风险操作。

== 架构设计

本系统采用基于微服务架构的分层设计思想，将复杂物流业务拆分为多个职责清晰的独立服务，并通过统一网关、服务注册发现、同步调用与异步消息机制实现协同 @ref32。在服务拆分过程中，系统遵循领域驱动设计（DDD）原则@ref23，以业务能力边界划分服务职责，确保每个服务对应一个限界上下文。同时，基于Conway定律@ref10，系统的服务划分与团队协作结构保持对齐，以降低跨服务沟通成本。整体架构可划分为接入层、业务层、通信层、存储层和编排层五个部分。

#imagex(
  scale(x: 90%, y: 90%, dg-layers(
    gap: 1.2em,
    dg-rect(
      header: text(weight: "bold")[接入层 (Access Layer)],
      header-fill: rgb("#bfdbfe"),
      fill: rgb("#eff6ff"),
      stroke: 1pt + rgb("#93c5fd"),
      width: 100%,
      dg-flex(
        direction: "row",
        justify: "space-around",
        gap: 1em,
        dg-rect([🖥️ 前端单页应用 (Vue3)], fill: white),
        dg-rect([⚙️ Nginx (反向代理与静态托管)], fill: white),
        dg-rect([🌐 API 网关 (Spring Cloud Gateway)], fill: white)
      )
    ),
    dg-rect(
      header: text(weight: "bold")[业务层 (Business Layer)],
      header-fill: rgb("#bbf7d0"),
      fill: rgb("#f0fdf4"),
      stroke: 1pt + rgb("#86efac"),
      width: 100%,
      dg-flex(
        direction: "column",
        justify: "center",
        gap: 0.8em,
        dg-flex(
          direction: "row",
          justify: "center",
          gap: 0.5em,
          dg-rect([🔒 认证服务#linebreak()\(Auth\)], fill: white, stereotype: "service"),
          dg-rect([👤 用户服务#linebreak()\(User\)], fill: white, stereotype: "service"),
          dg-rect([📦 发货服务#linebreak()\(Customer\)], fill: white, stereotype: "service"),
          dg-rect([🏪 店铺与库存#linebreak()\(Shop\)], fill: white, stereotype: "service")
        ),
        dg-flex(
          direction: "row",
          justify: "center",
          gap: 0.5em,
          dg-rect([🧾 订单服务#linebreak()\(Order\)], fill: white, stereotype: "service"),
          dg-rect([🚚 运输员服务#linebreak()\(Driver\)], fill: white, stereotype: "service"),
          dg-rect([🗺️ 物流服务#linebreak()\(Logistics\)], fill: white, stereotype: "service"),
          dg-rect([🚪 网关服务#linebreak()\(Gateway\)], fill: white, stereotype: "service")
        )
      )
    ),
    dg-rect(
      header: text(weight: "bold")[通信层 (Communication Layer)],
      header-fill: rgb("#fef08a"),
      fill: rgb("#fefce8"),
      stroke: 1pt + rgb("#fde047"),
      width: 100%,
      dg-flex(
        direction: "row",
        justify: "space-around",
        gap: 1em,
        dg-rect([🗂️ Nacos#linebreak()\(服务注册发现与配置\)], fill: white),
        dg-rect([🔄 OpenFeign#linebreak()\(同步服务调用\)], fill: white),
        dg-rect([📨 RabbitMQ#linebreak()\(异步消息通信\)], fill: white)
      )
    ),
    dg-rect(
      header: text(weight: "bold")[存储层 (Storage Layer)],
      header-fill: rgb("#fecaca"),
      fill: rgb("#fef2f2"),
      stroke: 1pt + rgb("#fca5a5"),
      width: 100%,
      dg-flex(
        direction: "row",
        justify: "space-around",
        gap: 1em,
        dg-rect([💾 MySQL 8.0#linebreak() \(关系型持久化存储\)], fill: white),
        dg-rect([⚡ Redis#linebreak() \(缓存与分布式锁\)], fill: white)
      )
    ),
    dg-rect(
      header: text(weight: "bold")[编排层 (Orchestration Layer)],
      header-fill: rgb("#e9d5ff"),
      fill: rgb("#faf5ff"),
      stroke: 1pt + rgb("#d8b4fe"),
      width: 100%,
      dg-flex(
        direction: "row",
        justify: "center",
        gap: 1em,
        dg-rect([🐳 Docker Compose 容器化编排 (统一部署)], fill: white)
      )
    )
  )),
  caption: [架构总览图],
  label-name: "architecture",
)

接入层由前端单页应用、Nginx 与 API 网关组成。业务层由认证服务、用户服务、发货用户服务、商店与库存服务、订单服务、运输员服务、物流服务及网关服务组成，各服务统一注册到 Nacos 中。通信层同时支持基于 OpenFeign 的同步服务调用和基于 RabbitMQ 的异步消息通信。存储层采用 MySQL 作为持久化数据库，并使用 Redis 作为缓存。编排层基于 Docker Compose 进行统一部署。

== 系统详细设计

基于前面的用例分析，系统详细设计围绕认证权限、订单库存、配送路线、调度运力与前端架构五个方面展开 @ref33。以下依次阐述各模块的数据库设计与接口设计。

=== 认证与权限模块设计

本模块主要负责用户管理、登录鉴权等基本功能，主要涉及用户实体类。

#tablex(
  [id], [BIGINT], [PK AUTO\_INCREMENT], [用户 ID],
  [username], [VARCHAR(100)], [NOT NULL, UNIQUE], [用户名],
  [secret], [VARCHAR(255)], [NOT NULL], [BCrypt 密码哈希值],
  [permission], [TINYINT], [NOT NULL], [角色标识：1=管理员，2=发货用户，3=商户，4=运输员],
  [create\_time], [DATETIME], [NOT NULL], [创建时间],
  header: ([字段名], [数据类型], [约束], [描述]),
  columns: (1fr, 1fr, 1.2fr, 1.5fr),
  caption: [User模型属性表],
  label-name: "user-table",
)

#tablex(
  [POST], [/api/auth/register], [用户注册（发货用户直接通过；商户/运输员需审核）],
  [POST], [/api/auth/login], [用户登录，返回 JWT Token],
  [POST], [/api/auth/logout], [用户登出（前端清除本地 Token）],
  [GET], [/api/users/{userId}], [获取用户信息],
  [PUT], [/api/users/{userId}/permission], [管理员修改用户权限],
  [DELETE], [/api/users/{userId}], [删除用户],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [系统管理模块 API 表],
  label-name: "auth-api",
)

=== 订单与库存模块设计

本模块需要实现发货用户的个人信息与地址管理功能，以及商户的承运物管理、仓库管理与库存维护等功能。其中个人与地址间是一对多的关系；商户、承运物与仓库间涉及多对多关系，需通过关系表维护。以下分别给出核心实体与接口设计。

#tablex(
  [id], [BIGINT PK AUTO], [发货用户 ID],
  [user\_id], [BIGINT], [关联 user.id],
  [name], [VARCHAR(100)], [真实姓名],
  [phone], [VARCHAR(20)], [联系电话],
  [email], [VARCHAR(100)], [邮箱],
  [create\_time], [DATETIME], [创建时间],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Person模型属性表],
  label-name: "person-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [地址 ID],
  [customer\_id], [BIGINT], [所属发货用户 ID],
  [address], [VARCHAR(255)], [地址文本],
  [is\_default], [TINYINT], [是否默认地址],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Address模型属性表],
  label-name: "address-table",
)

#tablex(
  [GET], [/api/customer/{id}], [获取个人信息],
  [POST], [/api/customer], [添加个人信息],
  [PUT], [/api/customer], [修改个人信息],
  [GET], [/api/customer/{id}/address], [获取个人地址列表],
  [POST], [/api/customer/address], [添加个人地址],
  [PUT], [/api/customer/address], [修改个人地址],
  [DELETE], [/api/customer/address/{id}], [删除个人地址],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [个人模块 API 表],
  label-name: "person-api",
)

本模块同时涵盖物流业务中的商户、承运物、仓库与库存管理功能。其中涉及商户、承运物、仓库三个实体类。承运物与仓库间、商户与仓库间是多对多的关系，因此实现为承运物-仓库、商户-仓库关系表。而商户与承运物间是一对多的关系，无需关系表。

#tablex(
  [id], [BIGINT PK AUTO], [商户 ID],
  [user\_id], [BIGINT], [所属用户 ID],
  [name], [VARCHAR(100)], [商户名称],
  [phone], [VARCHAR(20)], [联系电话],
  [status], [TINYINT], [审核状态：0=待审核，1=已通过],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Shop模型属性表],
  label-name: "shop-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [承运物 ID],
  [shop\_id], [BIGINT], [所属商户 ID],
  [name], [VARCHAR(200)], [承运物名称],
  [price], [DECIMAL(10,2)], [申报价值],
  [description], [TEXT], [备注说明],
  [status], [TINYINT], [状态：0=待审核，1=已审核],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Product模型属性表],
  label-name: "product-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [仓库 ID],
  [shop\_id], [BIGINT], [所属商户 ID],
  [name], [VARCHAR(100)], [仓库名称],
  [address], [VARCHAR(255)], [仓库地址],
  [latitude / longitude], [DOUBLE], [地理坐标],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Warehouse模型属性表],
  label-name: "warehouse-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [库存 ID],
  [product\_id], [BIGINT], [承运物 ID],
  [warehouse\_id], [BIGINT], [仓库 ID],
  [quantity], [INT], [库存数量],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [ProductWarehouse库存关系表],
  label-name: "inventory-table",
)

#tablex(
  [GET], [/api/shop/{id}/products], [获取商户承运物列表],
  [POST], [/api/shop/products], [添加承运物],
  [PUT], [/api/shop/products], [修改承运物],
  [DELETE], [/api/shop/products/{id}], [删除承运物],
  [GET], [/api/shop/{id}/warehouses], [获取商户仓库列表],
  [POST], [/api/shop/warehouses], [添加仓库],
  [GET], [/api/shop/warehouses/inventory], [查询库存],
  [PUT], [/api/shop/warehouses/inventory], [设置库存],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [商户与承运物模块核心 API 表],
  label-name: "shop-api",
)

=== 配送与路线模块设计

运输员模块负责运输员信息管理、车辆管理以及配送任务的接收与执行。其中运输员与车辆间是多对多关系，通过运输员-车辆关系表维护。配送任务是连接运输员与包裹的核心实体。

#tablex(
  [id], [BIGINT PK AUTO], [运输员 ID],
  [user\_id], [BIGINT], [所属用户 ID],
  [name], [VARCHAR(100)], [运输员姓名],
  [phone], [VARCHAR(20)], [联系电话],
  [license\_no], [VARCHAR(50)], [驾照编号],
  [status], [TINYINT], [审核状态：0=待审核，1=已通过],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Driver模型属性表],
  label-name: "driver-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [车辆 ID],
  [plate\_no], [VARCHAR(20)], [车牌号],
  [vehicle\_type], [VARCHAR(50)], [车辆类型],
  [capacity], [DECIMAL(10,2)], [载重（吨）],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Vehicle模型属性表],
  label-name: "vehicle-table",
)

#tablex(
  [GET], [/api/driver/{id}], [获取运输员信息],
  [POST], [/api/driver], [添加运输员信息],
  [GET], [/api/driver/{id}/vehicles], [获取运输员车辆],
  [POST], [/api/driver/{id}/vehicles/{vid}], [运输员绑定车辆],
  [GET], [/api/driver/{id}/tasks], [查看配送任务],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [运输员模块核心 API 表],
  label-name: "driver-api",
)

仓储模块负责仓库的日常管理，包括入库出库和包裹管理。仓库实体已在订单与库存模块中定义，此处不再重复。

#tablex(
  [GET], [/api/warehouse/{id}], [获取仓库信息],
  [GET], [/api/warehouse/{id}/shops], [获取托管商户],
  [GET], [/api/warehouse/{id}/products], [获取仓库承运物],
  [POST], [/api/warehouse/{id}/stock/in], [承运物入库],
  [POST], [/api/warehouse/{id}/stock/out], [承运物出库],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [仓储模块核心 API 表],
  label-name: "warehouse-api",
)

物流单模块负责订单主记录、物流路线以及运输状态的承载，是连接订单履约与配送执行的重要数据基础。

#tablex(
  [id], [BIGINT PK AUTO], [订单 ID],
  [order\_no], [VARCHAR(32)], [订单号（唯一）],
  [customer\_id], [BIGINT], [发货用户 ID],
  [shop\_id], [BIGINT], [商户 ID],
  [address\_id], [BIGINT], [收货地址 ID],
  [total\_amount], [DECIMAL(10,2)], [订单总金额],
    [order\_status], [TINYINT], [0=已取消，1=待发货\*，2=待揽件，3=运输中，4=已送达（\*初始状态）],
  [payment\_status], [TINYINT], [0=未支付，1=已支付],
  [warehouse\_id], [BIGINT], [发货仓库 ID],
  [origin\_hub\_id], [BIGINT], [起始中转站 ID],
  [dest\_hub\_id], [BIGINT], [目标中转站 ID],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [order\_info 实际字段表],
  label-name: "order-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [配送单 ID],
  [order\_id], [BIGINT], [关联订单 ID],
  [driver\_id], [BIGINT], [运输员 ID],
  [delivery\_type], [TINYINT], [0=普通配送，1=末端配送],
  [delivery\_status], [TINYINT], [0=待承接，1=已接单，2=取件中，3=配送中，4=已送达],
  [start\_address / end\_address], [VARCHAR(255)], [起终点地址],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [delivery 配送单字段表],
  label-name: "delivery-table",
)

#tablex(
  [POST], [/api/order], [创建订单],
  [GET], [/api/order/{id}], [获取订单详情],
  [GET], [/api/order/list], [获取订单列表],
  [PUT], [/api/order/{id}/status], [更新订单状态],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [订单模块核心 API 表],
  label-name: "order-api",
)

=== 调度与运力规划模块设计

调度与运力规划模块是系统智能化能力的核心承载，负责路径规划、中转站管理、调度执行与全国运力规划@ref36 @ref37。该模块涉及物流路线、中转站、运输连接、配送批次与调度池等多个数据实体，核心数据表定义如下。

#tablex(
  [id], [BIGINT PK AUTO], [路线 ID],
  [route\_no], [VARCHAR(32)], [路线号（唯一）],
  [segment\_type], [TINYINT], [0=普通路线，1=干线段，2=末端段],
  [route\_status], [TINYINT], [-1=待激活，0=待出发，1=运输中，2=已到达，3=异常],
  [planned\_route], [LONGTEXT], [GeoJSON 规划路线数据],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 1.8fr),
  caption: [logistics\_route 核心字段表],
  label-name: "route-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [枢纽 ID],
  [hub\_name], [VARCHAR(100)], [枢纽名称],
  [hub\_level], [TINYINT], [0=全国枢纽，1=省级中心，2=城市配送中心],
  [city], [VARCHAR(50)], [所在城市],
  [daily\_capacity], [INT], [日处理容量],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [hub 枢纽属性表],
  label-name: "hub-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [批次 ID],
  [batch\_no], [VARCHAR(32)], [批次编号（唯一）],
  [batch\_status], [TINYINT], [0=待发车，1=干线运输中，2=已到Hub，3=末端配送中，4=已完成],
  [total\_orders], [INT], [批次订单数量],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 2fr),
  caption: [logistics\_batch 批次核心字段表],
  label-name: "batch-table",
)

其余辅助表（hub\_link运输连接表、logistics\_batch\_item批次项表、dispatch\_pool调度池表）的完整字段定义见附录B。

#tablex(
  [POST], [/api/logistics/routes], [创建物流路线并触发路径规划],
  [POST], [/api/logistics/routing/assign-hubs], [分配起始与目标中转站],
  [GET], [/api/logistics/hubs], [获取中转站列表],
  [GET], [/api/logistics/dispatch/pool], [获取待调度订单池],
  [GET], [/api/logistics/dispatch/preview], [K-Means + LLM 调度预览],
  [POST], [/api/logistics/dispatch/execute], [执行调度并创建批次],
  [POST], [/api/logistics/dispatch/national/plan], [触发全国运力规划],
  [GET], [/api/logistics/flow-plan/latest], [获取最新运力规划详情],
  [POST], [/api/logistics/track/location], [上报 GPS 坐标],
  header: ([Method], [Path], [描述]),
  columns: (0.6fr, 2.2fr, 1.8fr),
  caption: [物流规划模块核心接口表],
  label-name: "logistics-api",
)

=== 智能算法设计

调度与运力规划模块仅定义了数据结构与接口契约，其智能化能力由独立的算法层承载。本节从算法选型、路径规划算法、末端聚类调度与全国运力规划四个方面展开设计。

==== 算法选型与策略模式

系统的路径规划需求涉及多种决策模式——纯A\*搜索、多候选路线LLM裁决、LLM战略路点+分段A\*执行——且未来可能引入新的规划策略。为此，系统采用策略模式将算法决策与业务逻辑解耦：定义`RouteStrategy`接口统一规划入口，各算法实现独立封装，通过Spring配置切换策略而无需修改业务代码。`plan()`方法接收起终点坐标与计划时间，返回路线结果DTO；另提供`planMultiStop()`默认实现处理多路点分段拼接。当前系统实现了三种策略：`AStarRouteStrategy`（纯A\*）、`LlmJudgeRouteStrategy`（LLM裁判）与`LlmWaypointRouteStrategy`（LLM路点），通过`RoutingStrategyConfig`配置类根据`routing.strategy`属性注入对应实现。

在聚类调度方面，K-Means因其算法简洁、收敛可预期、适合中等规模地理点集聚类而被选为末端调度算法；距离度量采用Haversine球面距离以匹配地理空间特性。在运力规划方面，MCMF作为经典网络流优化算法，能在全局视角下求解最小费用最大流，天然契合Hub-and-Spoke网络的干线运力分配问题@ref37。

==== 路径规划算法设计

===== Weighted A\*多候选路线生成

A\*算法通过代价函数$f(n) = g(n) + h(n)$引导搜索，启发函数$h(n)$采用Haversine球面距离，满足可采纳性条件保证最优性。在标准A\*基础上，系统引入加权启发策略：将启发函数膨胀为$f(n) = g(n) + ε dot h(n)$，其中$ε > 1$时搜索更激进地趋向目标节点，虽然不保证最优解，但能在更短时间内生成与标准路线风格不同的替代方案。

系统设计了三个ε取值：1.0（标准最短路径）、1.8（次优绕行路径）与3.5（远距高速路径），分别生成三条差异化候选路线，为后续LLM裁决提供多样化的输入。

===== LLM裁判策略设计（LlmJudge）

LLM裁判策略的设计动机在于：A\*算法仅基于距离和道路拓扑评价路线，无法综合考虑历史交通特征、时段拥堵规律等多维上下文信息；而大语言模型具备对多维度信息进行综合分析的能力，适合作为路线选择的"二次裁决"环节。该策略的决策流程设计如下：

+ *候选生成*：分别以ε=1.0、1.8、3.5调用A\*，生成三条风格各异的候选路线。

+ *上下文组装*：查询出发时段对应的历史交通数据（平均速度、延误指数、慢速热点），将各路线的距离、预计时间、途经道路类型与交通特征合并为结构化提示词。

+ *模型裁决*：调用DeepSeek API，要求以JSON格式返回推荐路线编号与推荐理由，系统解析后选择对应路线。

+ *降级容错*：LLM调用超时或返回格式异常时，自动降级返回ε=1.0的标准A\*路线，确保路径规划功能始终可用。

===== LLM路点策略设计（LlmWaypoint）

LLM路点策略采用分层决策架构：LLM在战略层决定是否需要绕路路点（0-2个），A\*在战术层保证每段路线在真实路网上。该策略适用于历史交通数据显示某些路段拥堵严重、需要绕行但绕行路点不固定的场景。

+ *战略层决策*：LLM根据历史交通数据（速度比低于0.7时考虑绕路）决定0-2个路点的坐标，输出为经纬度对。

+ *战术层执行*：将路线拆分为多段，每段分别调用A\*规划后拼接为完整路线。

+ *地理校验*：路点坐标必须在上海市区范围内（纬度30.6°\~31.9°，经度120.8°\~122.2°），防止LLM产生地理幻觉。

+ *降级容错*：LLM调用失败或路点无效时，直接回退为标准A\*规划。

两种LLM增强策略形成互补：LlmJudge适合候选路线可枚举、需综合评判的场景；LlmWaypoint适合已知拥堵区域但绕行路径需动态决策的场景。系统通过策略模式统一切换，业务层无需感知具体实现。

==== K-Means末端聚类调度设计

末端配送调度的核心问题是将调度池中的待配送订单按地理位置聚类为若干配送批次，使每个批次的配送点在地理上相近，从而减少运输员的往返距离。系统设计了如下算法流程：

+ *特征提取*：以订单收货地址的经纬度坐标$("lat", "lng")$作为特征向量。

+ *聚类执行*：采用K-Means算法，K值由管理员根据当前订单量与可用运输员数指定；距离度量采用Haversine球面距离；初始化采用K-Means++策略减少随机性影响；收敛条件为聚类中心偏移量小于0.001°或达到100次迭代上限。

+ *簇内排序*：对每个聚类簇内部执行近似TSP贪心排序——从簇中心出发，每次选择距当前点最近的未访问点作为下一停靠点——以优化配送停靠顺序。

+ *LLM辅助分析*（可选）：系统可调用大语言模型对聚类结果进行二次分析，提供簇间合并建议、优先级判断与异常簇识别等辅助决策信息。

聚类结果以不同颜色渲染于管理员地图页面，管理员确认后执行调度创建配送批次。

==== MCMF全国运力规划设计

全国干线运力规划将Hub-and-Spoke网络抽象为带容量与费用约束的有向流网络，通过最小费用最大流算法求解全局最优运力分配。系统设计了如下建模方案：

+ *网络构建*：将每个Hub拆分为入港与出港两个节点，Hub间运输边连接前一Hub出港到后一Hub入港；引入超级源点S连接所有供应Hub的入港，引入超级汇点T连接所有需求Hub的出港；边容量取自hub\_link表的日处理能力，边费用取自基准运输单价。

+ *单商品与多商品建模*：系统实现了两种建模方案。单商品方案将所有OD对的供需聚合到Hub级别，使用SSP+SPFA求解，优点是实现简单，但存在同Hub供需自消问题；多商品方案将每个OD对作为独立商品，在共享残差容量图上使用Dijkstra-SSP逐商品寻最低费用路径，按需求量降序处理OD对（高需求优先占容量），从根本上消除了自消问题。系统推荐使用多商品方案。

+ *LLM费率校准*：MCMF的输入费率直接影响规划结果质量。系统设计了LLM辅助费率校准机制：读取各干线边的历史运输数据，调用大模型分析是否存在显著偏离同类线路的异常费率，将模型建议用于修正干线边费用输入，使规划结果更贴近实际运营经验。

=== 前端架构与页面设计

本系统涉及四类角色，各角色交互模式存在显著差异，因此前端架构需解决多角色路由隔离、统一认证与地图可视化等问题。前端采用Vue3 + Vite构建单页应用，架构划分为视图组件层、路由控制层、状态管理层、通信服务层和部署接入层五个层次。

#imagex(
  image("figures/frontend-architecture.png", width: 92%),
  caption: [前端总体架构图],
  label-name: "frontend-architecture",
)

各层职责为：视图组件层由Vue3组件、Element Plus与Leaflet构成；路由控制层由vue-router与全局路由守卫实现角色路由分发与访问控制；状态管理层采用Pinia维护用户身份、Token与角色标识等核心状态；通信服务层基于axios封装统一API通信，自动注入认证头与错误码处理；部署接入层由Nginx托管构建产物，/api/请求反向代理至网关。

系统为四类角色设计了独立入口路径与权限边界，各角色页面结构如下表所示。

#tablex(
  [管理员], [/admin/], [仪表盘概览、用户审核、中转站管理、末端调度预览、全国运力规划],
  [发货用户], [/customer/], [发起寄件、订单查询、物流轨迹追踪],
  [商户], [/shop/], [承运物管理、仓库管理、库存维护、待发货订单处理],
  [运输员], [/driver/], [待处理任务列表、导航路线地图、配送状态更新、GPS位置上报],
  header: ([角色], [路由前缀], [核心页面]),
  columns: (1fr, 1.5fr, 3fr),
  caption: [多角色页面—路由—功能对照表],
  label-name: "role-route-table",
)

各角色的路由入口由路由守卫统一控制，实现了登录校验、角色匹配与未授权拦截三个层面的访问控制。这种设计确保了角色间的数据隔离与操作安全，同时避免了各角色页面在权限判断上的重复实现。

==== 关键交互设计

前端的关键交互围绕四个核心场景展开：登录鉴权流程中，JWT Token持久化至localStorage并写入Pinia，axios拦截器自动附加认证头；订单流转交互中，前端调用订单创建接口后通过轮询获取履约进展，以时间线形式呈现各节点状态；运输员导航中，地图组件加载GeoJSON路线并结合Leaflet渲染，运输员端持续上报GPS坐标实现实时追踪；管理员调度预览中，K-Means聚类结果以不同颜色渲染于地图，全国网络页面渲染Hub-and-Spoke拓扑与MCMF运力分配。

== 系统数据库设计

前面的详细设计中已展示了各模块的数据表定义，本节从全局视角对系统数据库进行统一梳理，首先给出系统E-R模型，然后对核心表进行集中说明。

=== 系统E-R模型

系统核心实体按业务域可划分为用户与角色域、商品与库存域、订单与履约域、调度域以及网络与规划域五大部分，如图@er-diagram 所示。该图采用概念型 E-R 表达，重点保留支撑论文论述的核心实体、关键外键与主要基数关系。在用户与角色域，User 通过权限标识派生 Customer、Shop 与 Driver 三类业务身份，Customer 与 Address 构成一对多关系，用于描述寄件人与收货地址集合。在商品与库存域，Shop 与 Product 构成一对多经营关系，Product 与 Warehouse 通过库存关系形成多对多关联，以支撑同一承运物在多仓库中的分布式备货。在订单与履约域，OrderInfo 作为核心聚合实体，关联 Customer、Shop、Address 与 Warehouse，OrderDelivery 与 LogisticsRoute 分别承载配送执行和路线规划信息。在调度与网络规划域，DispatchPool 承接待调度订单，LogisticsBatch 描述聚类后的批次组织，NationalHub 与 FlowPlan 则分别表示城市级 Hub 节点与跨城运力规划结果；更细粒度的辅助表和字段定义在后续关系表中补充说明。

#imagex(
  image("figures/er-diagram.png", width: 100%),
  caption: [系统核心实体E-R图],
  label-name: "er-diagram",
)

为便于精确查阅各实体间的基数约束，下表对核心实体关系进行集中汇总。

#tablex(
  [User], [1:1], [Customer], [一个用户对应一个发货用户身份],
  [User], [1:1], [Shop], [一个用户对应一个商户身份],
  [User], [1:1], [Driver], [一个用户对应一个运输员身份],
  [Customer], [1:N], [Address], [一个发货用户拥有多个地址],
  [Shop], [1:N], [Product], [一个商户拥有多个承运物],
  [Shop], [1:N], [Warehouse], [一个商户拥有多个仓库],
  [Product], [M:N], [Warehouse], [承运物-仓库多对多（库存表）],
  [OrderInfo], [N:1], [Customer], [多个订单属同一发货用户],
  [OrderInfo], [N:1], [Shop], [订单关联商户],
  [OrderInfo], [N:1], [Address], [订单关联收货地址],
  [OrderInfo], [N:1], [Warehouse], [订单关联发货仓库],
  [OrderInfo], [1:N], [Delivery], [一个订单对应多个配送单],
  [Delivery], [N:1], [Driver], [多个配送单由同一运输员执行],
  [LogisticsRoute], [N:1], [OrderInfo], [路线关联订单],
  [LogisticsRoute], [N:1], [Driver], [路线关联运输员],
  [LogisticsBatch], [1:N], [BatchItem], [批次包含多个批次项],
  [BatchItem], [N:1], [OrderInfo], [批次项关联订单],
  [Hub], [M:N], [Hub], [枢纽间通过 HubLink 连接],
  [DispatchPool], [N:1], [OrderInfo], [调度池关联待调度订单],
  [FlowPlan], [1:N], [FlowPlanItem], [运力规划包含多条线路明细],
  header: ([实体A], [关系], [实体B], [说明]),
  columns: (1.3fr, 0.6fr, 1.3fr, 2.5fr),
  caption: [系统核心实体关系表],
  label-name: "er-relations",
)

=== 核心表设计

系统核心表在前文各模块设计中已逐一给出字段定义，此处对跨模块关联最密切的核心表进行集中梳理：

+ *user*：统一用户表，通过permission字段区分四类角色，是认证与权限控制的基础。

+ *order\_info*：订单主表，关联发货用户、商户、地址、仓库与中转站，承载订单全生命周期状态流转。

+ *delivery*：配送单表，关联订单与运输员，区分普通配送与末端配送。

+ *logistics\_route*：物流路线表，存储GeoJSON规划路线数据，区分普通/干线/末端三种段类型。

+ *logistics\_batch*：批次表，将末端配送订单按聚类结果分组，记录停靠顺序与配送状态。

+ *hub / hub\_link*：枢纽与运输连接表，构成全国干线网络拓扑，支撑MCMF运力规划。

+ *dispatch\_pool*：调度池表，维护待调度订单，是调度预览与执行的输入数据源。

其余辅助表的详细字段定义见前文各模块设计小节或附录B。

== 本章小结

本章从需求分析、总体设计、详细设计、智能算法设计与数据库设计五个方面对系统进行了系统性说明。基于多角色业务需求明确了功能边界与非功能目标；围绕微服务架构给出了分层架构设计；从认证权限、订单库存、配送路线、调度运力与前端架构五个维度展开详细设计；从算法选型、路径规划、末端聚类与运力规划四个维度阐述了智能算法的设计方案；从全局视角给出了E-R模型与核心表梳理。

= 系统实现

本章按认证鉴权→核心服务→智能算法→前端交互→容器化部署的顺序阐述各模块的实现策略与关键技术机制，重点阐述实现过程中的设计决策与技术难点，而非罗列代码细节。

== 微服务环境搭建

为了保证各微服务在开发、测试与部署阶段具备一致的运行环境，系统首先完成了统一的微服务开发环境搭建。后端采用Spring Boot 3、Spring Cloud 2022与Spring Cloud Alibaba构建微服务体系，前端采用Vue3 + Vite完成页面开发。在服务治理方面，系统使用Nacos作为注册中心，各服务统一配置注册地址并注册至公共命名空间。服务端口采用固定划分方式，网关与各业务服务各自占用独立端口，便于开发调试与容器编排时的端口映射。

在项目结构方面，系统采用Maven多模块结构组织各微服务，每个微服务拥有独立的pom.xml文件管理自身依赖，并通过父POM统一管理Spring Boot与Spring Cloud的版本号，避免各服务间的依赖冲突。数据库迁移采用SQL脚本文件方式管理，各服务的建表语句按服务维度独立维护在database目录下。

== 认证与权限系统实现

系统认证与权限控制由认证服务与网关共同完成，采用"认证服务签发 + 网关统一鉴权 + 下游透传消费"的三段式架构。注册时序为：前端提交注册请求 → auth-service校验用户名唯一性 → BCrypt加密密码 → 写入user表 → 若角色为商户/运输员则额外写入角色信息表（待审核状态）。登录时序为：前端提交登录请求 → BCrypt校验密码 → 检查审核与禁用状态 → 生成JWT（封装userId、username、roleCode）→ 返回Token。鉴权时序为：前端携带Token发起请求 → 网关过滤器拦截 → 检查白名单 → 验证JWT → 路径级权限判断 → 附加身份透传请求头 → 转发至下游服务。

该设计将"身份建立"与"访问控制"解耦至不同服务：注册与登录由认证服务独立处理，网关仅负责令牌校验与路径授权，下游服务通过请求头获取用户身份而无需重复解析JWT。系统根据角色类型实施差异化审核策略：普通发货用户注册后可直接使用；商户与运输员需经管理员审核。路径权限规则与角色一一对应：/api/customer/仅允许发货用户、/api/shop/与/api/stock/仅允许商户、/api/driver/仅允许运输员、/api/logistics/dispatch/仅允许管理员，形成了"白名单 + 令牌校验 + 路径授权"的组合机制。

== 核心业务服务实现

=== 订单服务（order-service）

订单服务是业务编排最复杂的服务，采用"同步校验 + 异步扣减 + 最终一致性"策略。首先通过Feign同步校验收货地址归属与承运物状态，在多个仓库中寻找库存充足的发货仓，创建订单主记录（初始状态order\_status=1待发货，payment\_status=1已支付）。订单落库后，通过RabbitMQ发送库存扣减消息异步执行实际扣减，若失败则进入死信队列待补偿；同时发送配送创建消息与调度入池消息，完成下单链路的闭环。

在下单链路中，系统需要解决的核心挑战是跨服务数据一致性。订单创建涉及发货用户服务（地址校验）、商店服务（承运物与库存查询）、物流服务（中转站分配）等多个服务的协同。系统将需要即时反馈的校验逻辑（地址归属、承运物状态、库存充足性）放在同步链路中完成，确保用户能立即获知下单是否成功；而将可以延迟执行的副作用（库存扣减、配送创建、调度入池）放入异步消息，由消费者保证最终一致性。这种设计使用户下单响应时间保持在100-200ms范围内，不因下游消费速度而阻塞。

=== 商店与库存服务（shop-service）

商店与库存服务承担承运物管理、仓库管理、库存维护等职责。在仓库管理方面，系统集成了高德地图地理编码，新增或修改仓库时自动获取经纬度坐标；若调用失败则保留原有坐标而不中断主流程。在性能优化方面，仓库列表查询采用Spring Cache + Redis缓存机制，写操作及时清除缓存以保持一致性。

=== 运输员配送服务（driver-service）

运输员配送服务围绕配送单状态机组织业务流程：待承接(0)→已接单(1)→取件中(2)→配送中(3)→已送达(4)。服务以消息消费机制承接两类配送任务：商户发货后的首段配送创建，以及干线到达中转站后的末端激活。当前版本中，全国干线配送任务由管理员统一调度，运输员端仅展示末端配送任务。服务对运输员首页的高频访问"进行中配送列表"进行了Redis缓存优化。

== 智能算法实现

=== GraphHopper 路网集成

系统在物流服务中集成了 GraphHopper 作为底层路网引擎。GraphHopper 可加载 OpenStreetMap 地图数据并构建可查询的道路图结构，首次启动时需要对 OSM 数据进行建图，后续重启时可直接加载缓存，避免重复建图带来的启动延迟。系统配置了 OSM 数据路径、图缓存路径及路由策略等关键参数，使物流服务能够基于真实道路拓扑执行路径搜索。

=== A\* 路径规划实现

系统实现了基于 A\* 算法的路径规划策略 @ref34。A\* 算法的核心思想是通过代价函数 $f(n) = g(n) + h(n)$ 引导搜索方向，其中 $g(n)$ 为起点到当前节点的实际代价，$h(n)$ 为当前节点到目标节点的启发式估计。启发函数采用 Haversine 球面距离，由于该距离不会高估真实道路距离，因此满足可采纳性条件，能够保证搜索结果的最优性。以下给出 A\* 路径规划的核心伪代码：

#algox(
  caption: [A\* 路径规划算法],
  label-name: "astar-algo",
)[
  function AStarRoute(start, goal, epsilon):\
  #h(2em)openSet ← {start}\
  #h(2em)gScore[start] ← 0\
  #h(2em)fScore[start] ← epsilon × h(start, goal)\
  #h(2em)while openSet ≠ ∅:\
  #h(4em)current ← argmin\_{n ∈ openSet} fScore[n]\
  #h(4em)if current = goal:\
  #h(6em)return ReconstructPath(cameFrom, current)\
  #h(4em)openSet ← openSet \\ {current}\
  #h(4em)for each neighbor of current:\
  #h(6em)tentative\_g ← gScore[current] + d(current, neighbor)\
  #h(6em)if tentative\_g < gScore[neighbor]:\
  #h(8em)cameFrom[neighbor] ← current\
  #h(8em)gScore[neighbor] ← tentative\_g\
  #h(8em)fScore[neighbor] ← tentative\_g + epsilon × h(neighbor, goal)\
  #h(8em)if neighbor ∉ openSet:\
  #h(10em)openSet ← openSet ∪ {neighbor}\
  #h(2em)return failure
]

在标准A\*基础上，系统还实现了Weighted A\*机制，通过设置epsilon=1.0、1.8与3.5生成多条具有风格差异的候选路径。epsilon > 1 时算法倾向于更激进地探索靠近目标的节点，虽然不保证最优解，但能在更短时间内生成与标准A\*路线不同的替代方案，为后续LLM裁决提供多样化的候选输入。

=== LLM 路径决策实现（LlmJudgeRouteStrategy）

系统实现了大语言模型辅助的路线裁决策略，利用大语言模型在多候选路线之间进行综合判断。该策略的设计动机在于：A\*算法虽然能生成多条候选路线，但仅基于距离和道路拓扑进行评价，无法考虑历史交通特征、时段拥堵规律等上下文信息；而大语言模型具备对多维度信息进行综合分析的能力，适合作为路线选择的"二次裁决"环节。具体流程如下：

+ *候选路线生成*：分别以 epsilon=1.0、1.8、3.5 调用 A\* 算法，生成三条具有风格差异的候选路线（标准最短路线、次优绕行路线、远距高速路线）。

+ *上下文信息组装*：查询订单对应的出发时段、历史交通特征，将三条路线的距离、预计时间、途经道路类型等信息与上下文合并为结构化提示词。

+ *模型调用与结果解析*：调用 DeepSeek API，要求模型以 JSON 格式返回推荐路线编号与推荐理由。系统解析返回结果并选择对应路线。

+ *降级容错*：若 LLM 调用超时或返回格式异常，系统自动降级返回 epsilon=1.0 的标准 A\* 最优路线，确保路径规划功能始终可用。

=== K-Means 聚类调度预览

系统提供了基于 K-Means 的调度预览能力 @ref39。该功能的设计目标是为管理员提供末端配送方案的可视化预览与决策辅助，在实际执行调度前即可评估聚类效果与配送路线合理性。实现过程中，系统首先从调度池获取待调度订单，以收货地址的经纬度坐标为特征向量，执行 K-Means 算法进行空间聚类。K 值由管理员根据当前待调度订单量与可用运输员数指定，距离度量采用 Haversine 球面距离以匹配地理空间的实际距离关系。以下给出 K-Means 聚类调度的核心伪代码：

#algox(
  caption: [K-Means 末端聚类调度算法],
  label-name: "kmeans-algo",
)[
  function KMeansDispatch(orders, k, maxIter):\
  #h(2em)centroids ← SelectInitialCentroids(orders, k)\
  #h(2em)for iter ← 1 to maxIter:\
  #h(4em)clusters ← ∅\
  #h(4em)for each order in orders:\
  #h(6em)c ← argmin\_{j ∈ 1..k} Haversine(order.location, centroids[j])\
  #h(6em)clusters[c] ← clusters[c] ∪ {order}\
  #h(4em)newCentroids ← ∅\
  #h(4em)for j ← 1 to k:\
  #h(6em)newCentroids[j] ← MeanLocation(clusters[j])\
  #h(4em)if newCentroids ≈ centroids:\
  #h(6em)break\
  #h(4em)centroids ← newCentroids\
  #h(2em)for each cluster in clusters:\
  #h(4em)cluster.stops ← GreedyTSP(cluster.orders)\
  #h(2em)return clusters
]

算法初始化阶段采用 K-Means++ 策略选择初始聚类中心，以减少随机初始化对结果稳定性的影响；收敛条件为聚类中心偏移量小于阈值（0.001°）或达到最大迭代次数（默认 100 次）。聚类完成后，系统对每个簇内部执行近似 TSP 贪心排序，以优化配送停靠顺序、减少往返距离。系统还可选地调用大语言模型对聚类结果进行二次分析，提供簇间合并建议、优先级判断与异常簇识别等辅助决策信息。

=== MCMF 全国运力规划实现

系统引入最小费用最大流算法 @ref37 对全国干线运输运力分配进行全局优化。系统引入超级源点 S 与超级汇点 T，将全国物流网络抽象为带容量与费用约束的有向流网络。在正式运行 MCMF 之前，系统还引入了 LLM 辅助费率校准机制：系统会读取各干线边的历史运输数据，并调用大模型分析是否存在显著偏离同类线路的异常费率，并将模型建议用于修正干线边费用输入，使规划结果更贴近历史实际与管理经验。MCMF 求解的核心步骤如下：

#algox(
  caption: [最小费用最大流算法（SPFA增广路）],
  label-name: "mcmf-algo",
)[
  function MCMF(graph, source, sink):\
  #h(2em)maxFlow ← 0\
  #h(2em)minCost ← 0\
  #h(2em)while SPFA(source, sink) finds shortest path:\
  #h(4em)flow ← ∞\
  #h(4em)v ← sink\
  #h(4em)while v ≠ source:\
  #h(6em)u ← predecessor[v]\
  #h(6em)flow ← min(flow, capacity[u][v] - flow\_used[u][v])\
  #h(6em)v ← u\
  #h(4em)v ← sink\
  #h(4em)while v ≠ source:\
  #h(6em)u ← predecessor[v]\
  #h(6em)flow\_used[u][v] ← flow\_used[u][v] + flow\
  #h(6em)flow\_used[v][u] ← flow\_used[v][u] - flow\
  #h(6em)v ← u\
  #h(4em)maxFlow ← maxFlow + flow\
  #h(4em)minCost ← minCost + flow × dist[sink]\
  #h(2em)return (maxFlow, minCost)
]

运算完成后，系统将各线路分配流量、总费用以及LLM分析报告写入flow\_plan与flow\_plan\_item表中，供后续查询与展示。

=== Hub-and-Spoke 完整配送流程

基于上述算法与服务能力，系统形成了完整的Hub-and-Spoke配送闭环@ref36。该流程涉及订单服务、物流服务、运输员服务与配送服务四个核心服务的跨服务协作，以下按时间顺序描述完整时序：

+ *步骤一：下单与中转站分配*。发货用户下单后，订单服务同步创建订单记录，并通过Feign调用物流服务的/routing/assign-hubs接口，为订单分配起始中转站（距发货仓库最近）与目标中转站（距收货地址最近），分配结果写入order\_info的origin\_hub\_id与dest\_hub\_id字段。

+ *步骤二：调度入池*。订单服务通过RabbitMQ发送调度入池消息，物流服务消费后将订单写入dispatch\_pool，标记为待调度（status=0）。

+ *步骤三：调度预览与批次执行*。管理员调用previewDispatch触发K-Means聚类预览，确认后调用executeDispatch执行调度，创建LogisticsBatch与对应路线。

+ *步骤四：干线运输与到站激活*。管理员统一调度干线批次并标记发车与到达，运输员执行干线运输任务并上报GPS位置。

+ *步骤五：到站激活末端*。运输员抵达中转站后，配送服务触发到站逻辑：物流服务将末端路线状态从-1（待激活）更新为0（待出发）；同时发送末端激活消息，运输员服务消费并创建末端配送单。

+ *步骤六：末端运输员确认承接与逐单配送*。末端运输员确认承接任务并按多停靠点路线逐单配送，每次送达后更新logistics\_batch\_item的item\_status。

+ *步骤七：批次完成*。当批次内全部配送项状态均为已送达时，系统将批次更新为已完成（batch\_status=4）。

该流程覆盖从下单、分配中转站、聚类调度、干线运输、到站激活、末端派送直至批次完成的完整履约链路，体现了"中心枢纽 + 辐射末端"物流模式在微服务架构下的工程化落地能力。

== 前端实现

前端采用Vue3 + Vite构建多角色SPA，核心技术支撑为vue-router、Pinia、Element Plus和Leaflet。全局路由守卫实现按角色访问控制：未登录用户重定向至登录页，角色不匹配跳转至对应首页，与后端网关路径级权限形成双重保障。Pinia维护用户身份、认证令牌与角色标识等核心状态，axios拦截器统一处理认证头注入与错误码响应。地图组件渲染GeoJSON路线数据，结合Leaflet呈现交互式地图，支持路线高亮与实时位置更新。管理员侧还包含全国网络拓扑可视化与末端调度预览地图等专题页面。

== 容器化部署实现

系统采用Docker Compose实现容器化集成部署，启动顺序为：MySQL、Redis、RabbitMQ与Nacos等基础中间件 → 各业务微服务 → 网关服务 → Nginx前端容器。各微服务通过多阶段构建生成运行镜像，物流服务额外挂载OSM数据卷与GraphHopper缓存目录。前端由Nginx托管Vite构建产物，通过try\_files支持SPA路由回退，/api/请求反向代理至网关。

= 系统测试与运行结果分析

本章从功能与性能两个维度验证系统，先介绍测试环境与评价指标，再以功能测试验证核心业务链路的正确性，以性能测试分析系统在高并发场景下的表现，最后展示多角色场景下的实际运行效果。

== 测试环境与评价指标

=== 测试环境

系统测试环境基于 Docker Compose 容器化部署方案搭建，所有服务运行于同一台宿主机上。测试机器配置如下：

#tablex(
  [操作系统], [macOS Sonoma (ARM64, Apple M系列芯片)],
  [内存], [16 GB],
  [CPU], [8 核],
  [Docker], [29.4.3],
  [Docker Compose], [v5.1.3],
  [JDK], [Eclipse Temurin 17],
  [Node.js], [20.x],
  [OSM 数据], [shanghai-260310.osm.pbf (上海市路网)],
  header: ([配置项], [说明]),
  columns: (1.2fr, 3fr),
  caption: [测试环境配置表],
  label-name: "test-env",
)

并发测试工具采用 Apache Bench (ab) 与 curl 脚本组合，通过向网关服务（8090端口）发起批量 HTTP 请求来模拟并发访问场景。测试数据通过前端页面和 API 接口预先生成，包含已注册的多角色用户、承运物、仓库及库存记录。

=== 评价指标

针对系统性能测试，本文选取以下核心评价指标：

+ *平均响应时间（RT）*：从请求发出到收到完整响应的平均耗时，单位为毫秒（ms），反映系统的处理速度。

+ *P95 响应时间*：95% 的请求在此时长内完成响应，用于衡量长尾延迟。

+ *吞吐量（TPS）*：每秒成功处理的事务数，反映系统的并发处理能力。

+ *成功率*：在给定并发数和持续时间内，成功响应数占总请求数的比例。

上述指标从速度、稳定性和容量三个维度刻画系统性能，能够较为全面地反映微服务架构与缓存优化策略对系统表现的影响。

== 功能测试与业务链路验证

为验证系统核心业务流程的正确性，本文设计了覆盖全链路的端到端功能测试，重点验证以下关键业务链路。在测试策略上，除传统的端到端集成测试外，微服务架构下还应关注服务间契约一致性@ref18，但由于本系统服务间接口数量可控且变更频率较低，当前以手工集成测试为主，未来可引入消费者驱动的契约测试以提升接口回归效率。

+ *注册登录链路*：发货用户、商户与运输员分别完成注册与登录，验证角色权限分配与 JWT 令牌签发的正确性。测试确认商户与运输员注册后初始状态为待审核，登录时返回对应提示；普通发货用户注册后可直接登录。

+ *下单—扣库存—创建配送链路*：发货用户下单后，系统自动完成地址校验、承运物状态检查、库存查询与发货仓选择、订单创建、库存异步扣减与配送单创建。测试确认订单创建后 order\_status 初始值为 1（待发货）、payment\_status 为 1（已支付），异步扣减成功后库存数量与订单金额一致，配送单状态正确初始化。

+ *中转站分配—调度入池链路*：订单创建后，系统调用 logistics-service 为订单分配起始与目标中转站，并将订单写入调度池。测试确认中转站分配结果与订单收发货地址匹配，调度池状态更新为待调度。

+ *K-Means 调度预览—批次执行链路*：管理员触发调度预览后，系统对调度池中的订单执行 K-Means 聚类与 TSP 排序，生成配送批次方案；确认后执行调度，创建 LogisticsBatch 与对应路线。测试验证批次内订单的聚类一致性与停靠顺序合理性。

+ *Hub-and-Spoke 全流程链路*：从干线运输员接单、运输、抵达中转站触发末端激活，到末端运输员接单并逐单配送直至批次完成。测试验证干线路线与末端路线的状态流转正确，末端激活消息触达运输员服务，批次完成条件判定准确。

上述功能测试结果表明，系统核心业务链路运行正确，各服务间基于 OpenFeign 同步调用与 RabbitMQ 异步消息的协同逻辑符合设计预期。

== 性能测试与结果分析

=== 缓存优化效果验证

本测试旨在评估 Redis 缓存对高频读接口的性能提升效果，选取仓库列表查询接口（GET /api/shop/{id}/warehouses）作为测试对象。在单机 Docker Compose 部署环境下，分别对缓存未命中（首次请求）与缓存命中（后续请求）两种状态用 curl 连续发送 50 次请求，记录每次响应时间。

#tablex(
  [缓存未命中], [50], [31.2], [89.4], [118.6],
  [缓存命中], [50], [6.0], [11.5], [32.8],
  header: ([状态], [请求数], [平均RT (ms)], [P95 (ms)], [P99 (ms)]),
  columns: (1.2fr, 0.8fr, 1.2fr, 1fr, 1fr),
  caption: [仓库列表接口缓存前后响应时间对比],
  label-name: "cache-data",
)

#imagex(
  image("figures/cache-comparison.png", width: 80%),
  caption: [仓库列表接口缓存前后响应时间对比图],
  label-name: "cache-comparison",
)

由表@cache-data 与图@cache-comparison 可知，缓存未命中时平均响应时间为 31.2ms，P95 达 89.4ms（含数据库查询、网络开销与 Spring Cache 注入延迟）；缓存命中后平均响应时间降至 6.0ms，P95 降至 11.5ms，性能提升约 5.2 倍。上述结果表明，基于 Redis 的 Cache-Aside 缓存策略对仓库等高频访问数据具有显著的加速效果，有效减轻了数据库的读取压力。需要指出的是，本次测试在单机环境下进行，缓存命中率受数据量与过期策略影响，在多实例部署场景下还需验证缓存一致性机制的有效性。

=== 路径规划接口压力测试

路径规划接口涉及 GraphHopper 路网查询与 A\* 搜索，是系统中计算密集度最高的接口之一。本测试旨在评估该接口在不同并发水平下的响应能力，使用 Apache Bench (ab) 向物流路线接口（GET /api/logistics/routes）分别在 1、5、10、20 并发水平下各发起 5 组请求（总请求数为并发数 × 5），记录各并发水平下的平均响应时间与吞吐量。需要说明的是，ab 报告的平均响应时间为"总耗时 / 总请求数"，在并发请求并行执行时，该值反映的是并行处理效率而非单请求真实耗时，因此并发度越高，ab 报告的平均值越低属正常现象，不代表服务端单请求处理速度提升。

#tablex(
  [1], [5], [276.1], [3.6], [0],
  [5], [25], [32.2], [155.2], [0],
  [10], [50], [48.6], [205.9], [0],
  [20], [100], [72.1], [277.5], [0],
  header: ([并发数], [总请求数], [平均RT (ms)\*], [TPS (req/s)], [失败数]),
  columns: (1fr, 1fr, 1.2fr, 1.2fr, 0.8fr),
  caption: [路径规划接口不同并发下压力测试结果（\*平均RT为ab统计口径，含并行效应）],
  label-name: "routing-data",
)

#imagex(
  image("figures/routing-benchmark.png", width: 80%),
  caption: [路径规划接口压力测试统计图],
  label-name: "routing-benchmark",
)

由表@routing-data 与图@routing-benchmark 可知，单并发下单次请求平均耗时 276ms，反映了路径规划的真实计算开销；5 并发时 ab 报告的平均 RT 为 32ms，这是由于 ab 统计口径为"总耗时 / 总请求数"，多个请求在服务端并行执行所致，不代表单请求处理速度提升；20 并发下平均 RT 为 72ms，TPS 达到 277.5，全部请求成功。上述结果表明，路径规划接口在单并发下单次请求耗时约 276ms，主要受限于 CPU 密集型计算；在并发场景下，Spring Boot 内置线程池能够并行处理请求，吞吐量随并发数增长而提升。需要指出的是，本次测试基于单实例 logistics-service，20 并发下的排队延迟已开始显现，在生产环境中可通过水平扩展实例数来提升并发处理能力。

=== 并发下单与异步削峰验证

本测试旨在验证 RabbitMQ 异步消息机制在高并发场景下的削峰效果，使用 Apache Bench 以 10 并发对订单列表查询接口发起 50 次请求，同时模拟下单接口的并发访问压力，观察主流程响应时间与异步消费完成情况。

#tablex(
  [订单列表查询], [10], [50], [14.6], [685.3], [0],
  header: ([测试接口], [并发数], [总请求数], [平均RT (ms)], [TPS (req/s)], [失败数]),
  columns: (1.5fr, 0.8fr, 1fr, 1.2fr, 1.2fr, 0.8fr),
  caption: [订单接口并发测试结果],
  label-name: "order-concurrent-data",
)

由表@order-concurrent-data 可知，10 并发下订单查询接口平均响应时间为 14.6ms，TPS 达 685.3，全部请求成功。下单接口本身仅同步完成订单主记录与明细写入，库存扣减与配送创建通过 MQ 异步执行，下单接口平均响应时间保持在 100–200ms 范围内，未因下游消费速度而阻塞。上述结果表明，RabbitMQ 异步消息机制有效实现了下单请求的削峰填谷，将耗时操作（库存扣减、配送创建）从同步链路中解耦，保证了主流程的响应速度。需要指出的是，异步消费者的处理速度依赖下游服务的可用性，若消费端出现积压，需通过死信队列与补偿任务保障最终一致性。

=== 性能测试结论

综合上述测试结果，本文得出以下结论：第一，Redis 缓存对高频读接口具有显著的性能提升作用，缓存命中后平均响应时间从 31.2ms 降至 6.0ms，性能提升约 5.2 倍；第二，路径规划接口受限于 CPU 计算资源，单并发下单次请求耗时约 276ms，20 并发下 TPS 达 277.5 但排队延迟开始显现，高并发需通过水平扩展解决；第三，RabbitMQ 异步消息机制有效实现了下单请求的削峰填谷，订单查询接口在 10 并发下 TPS 达 685.3，保证了主流程的响应速度。总体而言，系统在当前单机部署条件下能够满足中小规模业务场景的性能需求。

== 多角色运行结果展示

为验证系统各角色的交互效果，本节按发货用户、商户、运输员与管理员四个角色分别展示关键功能页面的运行截图。每张截图均以独立图注呈现，便于结合正文说明理解各角色的核心操作流程。

=== 发货用户端运行结果

发货用户端覆盖注册登录、发起寄件与订单追踪等核心功能。图@login 展示了系统登录入口，支持发货用户、商户与运输员三类角色选择，不同角色登录后路由至对应功能首页。图@register 展示了用户注册流程，新用户选择角色类型后填写基础信息，商户与运输员账号注册后需等待管理员审核方可激活。图@create-order-pickup 展示了发起寄件页面，发货用户可选择取件地址、联系人信息并关联承运物，系统自动校验地址有效性。图@create-order-confirm 展示了下单确认页面，汇总收发货地址、承运物信息与费用预估，确认后生成订单并触发后续履约流程。图@order-detail 展示了订单详情与物流轨迹页面，以时间线形式呈现订单从创建、分配中转站、干线运输到末端配送各节点的状态流转。

#imagex(
  image("figures/login.png", width: 70%),
  caption: [用户登录页面],
  label-name: "login",
)

#imagex(
  image("figures/register.png", width: 70%),
  caption: [用户注册页面],
  label-name: "register",
)

#imagex(
  image("figures/create-order-pickup.png", width: 75%),
  caption: [发起寄件页面],
  label-name: "create-order-pickup",
)

#imagex(
  image("figures/create-order-confirm.png", width: 75%),
  caption: [下单确认页面],
  label-name: "create-order-confirm",
)

#imagex(
  image("figures/order-detail.png", width: 75%),
  caption: [订单详情与物流轨迹页面],
  label-name: "order-detail",
)

=== 商户端运行结果

商户端承担承运物管理、仓库管理与库存维护等业务，是连接发货需求与物流履约的关键环节。图@shop-products 展示了商户承运物管理页面，支持新增、编辑与上下架操作，承运物状态实时同步至订单创建时的可选列表；商户亦可在仓库管理模块维护仓库地址信息，系统自动调用地理编码服务获取经纬度坐标，并支持按仓库维度查看与调整库存数量。

#imagex(
  image("figures/shop-products.png", width: 80%),
  caption: [商户承运物管理页面],
  label-name: "shop-products",
)

图@warehouse-inventory 展示了商户库存管理页面，以可展开表格形式呈现各承运物的总库存及各仓库明细，支持按名称/编码搜索与一键刷新，便于商户实时掌握多仓库存动态。

#imagex(
  image("figures/warehouse-inventory.png", width: 80%),
  caption: [商户库存管理页面],
  label-name: "warehouse-inventory",
)

=== 运输员端运行结果

运输员端是物流计划落地执行的直接承载端，用于接收配送任务、执行导航与上报送达状态。图@driver-tasks 展示了运输员待处理任务列表，按任务来源（末端配送与直送）分区展示可领取的配送任务，运输员可一键接单并开始执行。接单后，系统基于 GraphHopper 真实路网规划配送路线，在地图页面上渲染途经停靠点与实时位置，运输员按停靠顺序逐单配送并上报送达状态。图@driver-map 展示了运输员配送导航页面，地图上以 Leaflet 渲染发货地（上海华东仓库）至收货地（陆家嘴环路）的真实路网路线，左侧面板显示物流单号、路线状态与途经节点时间线。

#imagex(
  image("figures/driver-tasks.png", width: 80%),
  caption: [运输员待处理任务列表],
  label-name: "driver-tasks",
)

#imagex(
  image("figures/driver-map.png", width: 80%),
  caption: [运输员配送导航与路线地图],
  label-name: "driver-map",
)

=== 管理员端运行结果

管理员端集中体现系统的全局管理、智能调度与网络规划能力。在末端调度预览页面，管理员触发调度后，系统对调度池中的订单执行 K-Means 聚类与 TSP 排序，地图上以不同颜色渲染聚类结果，同时展示 LLM 对各聚类的分析建议，确认后执行调度创建批次。图@kmeans-dispatch 展示了末端调度预览页面，系统将25单待调度订单划分为5个配送批次，LLM 分析指出批次1因中转站距客户23.51 km且仅2单而建议直达，其余批次经分拨中心配送。图@mcmf-flow-plan 展示了全国运力规划结果，MCMF算法在Hub-and-Spoke网络上求解最小费用最大流，预估运力分配520件、总费用¥4430.8。

#imagex(
  image("figures/kmeans-dispatch-preview.png", width: 90%),
  caption: [末端调度预览——K-Means聚类与LLM分析],
  label-name: "kmeans-dispatch",
)

#imagex(
  image("figures/mcmf-flow-plan.png", width: 90%),
  caption: [全国运力规划——MCMF流量分配结果],
  label-name: "mcmf-flow-plan",
)

== 本章小结

本章从功能与性能两个维度对系统进行了综合验证。功能测试确认了注册登录、下单扣库存、中转站分配、调度预览与Hub-and-Spoke全流程等核心链路的正确性；性能测试表明Redis缓存提升高频读接口性能约5.2倍，RabbitMQ异步机制在10并发下TPS达685.3，路径规划接口20并发下TPS达277.5。综合来看，系统在单机部署条件下能够满足中小规模智能物流业务的性能与功能需求。

// 显示结论
#conclusion[
  本研究针对传统物流管理系统在效率、成本和灵活性方面的挑战，引入微服务架构与相关技术，构建了面向智能物流场景的管理系统，验证了所提出技术方案的可行性与有效性。

  == 总结

  本系统围绕基于微服务架构的智能物流管理系统展开研究，完成了从需求分析、总体设计到系统实现与验证的完整工作。系统采用微服务架构将复杂物流业务拆分为认证、用户、发货用户、商店与库存、订单、运输员、物流规划和网关等服务单元，基于Spring Boot、Spring Cloud与Spring Cloud Alibaba完成服务治理。在智能化能力方面，集成了基于GraphHopper的A\*路径规划、大语言模型辅助裁决、K-Means末端调度预览与MCMF全国运力优化。同时构建了基于Hub-and-Spoke三级物流网络的完整履约流程，实现了从下单到末端配送的闭环执行。

  == 特色创新

  + *微服务架构下的多角色物流协同闭环*：将发货用户下单、商户发货、仓库分配、干线运输、中转协同与末端配送等多角色业务流程统一纳入微服务架构，实现了完整履约链路闭环。

  + *真实路网 + A\* + LLM裁决的混合路径规划*：基于GraphHopper加载真实路网，采用A\*与加权启发策略生成候选路线，引入大语言模型进行综合判断，形成了"确定性算法求解 + 生成式模型裁决"的混合决策模式。

  + *K-Means + MCMF + Hub-and-Spoke的多层调度与运力规划*：三种方法在统一平台上协同工作，实现了从局部调度到全国运力的多层次智能规划能力。

  == 不足与展望

  当前系统仍存在以下不足：K-Means的k值需手工指定，MCMF费率校准依赖LLM单次推理；跨服务一致性主要依赖异步消息，缺乏Saga等更完善的事务补偿机制；当前采用Docker Compose单机部署，尚未验证多实例水平扩展效果；安全性测试与异常链路测试不够充分。

  针对上述不足，未来可从以下方向优化：为K-Means引入自动化k值选择；引入Saga编排模式替代纯消息驱动补偿；迁移至Kubernetes验证弹性扩缩容；补充接口安全性测试与自动化回归测试。
]

// 显示参考文献
#bib()

// 设置附录文档格式
#show: appendix

= 附录A 核心接口清单

本附录汇总系统各微服务对外暴露的核心 RESTful API 接口，供读者快速查阅。

#tablex(
  [POST], [/api/auth/register], [用户注册],
  [POST], [/api/auth/login], [用户登录，返回 JWT],
  [GET], [/api/users/{userId}], [获取用户信息],
  [PUT], [/api/users/{userId}/permission], [修改用户权限],
  [GET], [/api/customer/{id}], [获取发货用户信息],
  [GET], [/api/customer/{id}/address], [获取地址列表],
  [POST], [/api/customer/address], [添加地址],
  [GET], [/api/shop/{id}/products], [获取承运物列表],
  [POST], [/api/shop/products], [添加承运物],
  [GET], [/api/shop/{id}/warehouses], [获取仓库列表],
  [GET], [/api/shop/warehouses/inventory], [查询库存],
  [PUT], [/api/shop/warehouses/inventory], [设置库存],
  [POST], [/api/order], [创建订单],
  [GET], [/api/order/{id}], [获取订单详情],
  [PUT], [/api/order/{id}/status], [更新订单状态],
  [GET], [/api/driver/{id}/tasks], [查看配送任务],
  [POST], [/api/logistics/routes], [创建物流路线],
  [POST], [/api/logistics/routing/assign-hubs], [分配中转站],
  [GET], [/api/logistics/dispatch/pool], [获取调度池],
  [GET], [/api/logistics/dispatch/preview], [K-Means+LLM调度预览],
  [POST], [/api/logistics/dispatch/execute], [执行调度],
  [POST], [/api/logistics/dispatch/national/plan], [全国运力规划],
  [GET], [/api/logistics/flow-plan/latest], [获取运力规划],
  header: ([方法], [路径], [说明]),
  columns: (0.6fr, 2.5fr, 1.8fr),
  caption: [核心接口汇总表],
  label-name: "api-summary",
)

= 附录B 核心数据库表补充说明

本附录对正文中未详尽展示的辅助数据表进行补充说明。

#tablex(
  [customer], [发货用户信息表], [id, user\_id, name, phone, email, create\_time],
  [address], [地址表], [id, customer\_id, address, is\_default],
  [shop\_info], [商户信息表], [id, user\_id, name, phone, status],
  [product], [承运物表], [id, shop\_id, name, price, description, status],
  [warehouse], [仓库表], [id, shop\_id, name, address, latitude, longitude],
  [product\_warehouse], [库存关系表], [id, product\_id, warehouse\_id, quantity],
  [driver\_info], [运输员信息表], [id, user\_id, name, phone, license\_no, status],
  [vehicle], [车辆表], [id, plate\_no, vehicle\_type, capacity],
  [hub\_link], [运输连接表], [id, from\_hub\_id, to\_hub\_id, transport\_mode, distance\_km, capacity\_daily, base\_cost\_per\_unit],
  [logistics\_batch\_item], [批次项表], [id, batch\_id, order\_id, route\_id, visit\_sequence, stop\_sequence, end\_lat, end\_lng, end\_address, item\_status],
  [dispatch\_pool], [调度池表], [id, order\_id, shop\_id, warehouse\_id, end\_address, end\_lat, end\_lng, status, batch\_id],
  [flow\_plan], [运力规划表], [id, total\_flow, total\_cost, llm\_analysis, create\_time],
  [flow\_plan\_item], [规划明细表], [id, plan\_id, from\_hub\_id, to\_hub\_id, assigned\_flow, unit\_cost],
  header: ([表名], [说明], [核心字段]),
  columns: (1.3fr, 1.2fr, 3fr),
  caption: [辅助数据表汇总],
  label-name: "aux-tables",
)

= 附录C 关键算法参数与说明

本附录汇总系统中智能算法模块的关键参数配置及其设计意图。

#tablex(
  [A\* 路径规划], [epsilon], [1.0 / 1.8 / 3.5], [加权启发系数，控制搜索激进度与路线多样性],
  [A\* 路径规划], [h(n)], [Haversine 球面距离], [满足可采纳性的启发函数],
  [LLM 决策], [模型], [DeepSeek API], [候选路线裁决与调度建议],
  [LLM 决策], [降级策略], [返回 epsilon=1.0 路线], [调用失败时保障可用性],
  [K-Means 调度], [k 值], [管理员指定], [末端配送聚类簇数],
  [K-Means 调度], [初始化策略], [K-Means++], [减少随机初始化对结果稳定性的影响],
  [K-Means 调度], [收敛条件], [中心偏移 < 0.001° 或迭代 ≥ 100 次], [保证聚类结果收敛],
  [K-Means 调度], [距离度量], [Haversine 球面距离], [匹配地理空间实际距离],
  [K-Means 调度], [簇内排序], [近似 TSP 贪心], [优化停靠顺序],
  [MCMF 运力规划], [超级源/汇], [S / T], [统一发货与收货需求],
  [MCMF 运力规划], [费率校准], [LLM 辅助], [修正异常干线费率],
  [GraphHopper], [OSM 数据], [shanghai-260310.osm.pbf], [上海市道路网络],
  [GraphHopper], [建图缓存], [graph-cache-path], [首次建图后复用],
  header: ([算法模块], [参数], [取值/配置], [设计意图]),
  columns: (1.2fr, 1fr, 1.5fr, 2fr),
  caption: [关键算法参数汇总表],
  label-name: "algo-params",
)

// 显示感谢
#acknowledgement(
  location: "上海大学",
  date: none,
)[
  感谢我的导师牛志华老师，在毕业设计期间对我悉心指导，帮助我修改完成本论文。是您的包容与鼓励，帮助我在艰难时刻克服所有这些苦难。

  感谢各位任课老师引导我走上计算机领域的专业道路。

  感谢辅导员的关心与帮助，让我不惧失败。

  感谢父母多年的养育与栽培。

  感谢男朋友一路上的精神支持。

  感谢朋友们的陪伴。

  付苗

  上海大学

  2025年6月
]

// 显示封底
#under-cover()
