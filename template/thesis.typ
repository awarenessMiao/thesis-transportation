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
    title: "基于微服务的智能物流管理系统设计与实现",
    school: "计算机科学与工程学院",
    major: "网络空间安全",
    student_id: "21122119",
    name: "付苗",
    supervisor: "牛志华",
    date: "2026年1月29日起5月29日止",
  ),
  fonts: (
    fallback: false,
    songti: (
      (name: "Times New Roman", covers: "latin-in-cjk"),
      "Songti SC",
      "SimSun",
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
  author-sign: none,
  supervisor-sign: none,
  date: none,
)

#abstract(
  keywords: ("微服务架构", "智能物流管理", "路径规划算法", "网络流优化", "大语言模型"),
  keywords-en: ("Microservice Architecture", "Intelligent Logistics Management", "Route Planning Algorithm", "Network Flow Optimization", "Large Language Model"),
)[
  随着电子商务和物流行业的快速发展，物流管理对数字化协同、资源调度、路径规划和运力统筹的需求在不断提高。为满足这一现实存在的应用需求，本论文设计并实现了一套基于微服务架构的智能物流管理系统。系统针对订单履约、仓储库存、运输配送与运力调度等核心业务场景，构建了一个具备业务协同和智能决策能力的物流管理平台。

  本文在分析物流履约链路与系统模块边界的基础上，采用前后端分离与微服务架构进行设计。后端基于 Spring Boot 和 Spring Cloud Alibaba 技术栈，将系统拆分为认证、顾客、商店与库存、订单、运输配送、物流规划与网关等服务模块，并通过 Nacos 实现服务注册与配置管理，通过 Spring Cloud Gateway 提供统一访问入口和请求鉴权，通过 OpenFeign 完成服务间同步调用。系统使用 MySQL 进行业务数据持久化，结合 Redis 对路线、仓库、配送任务等高频数据进行缓存优化，并利用 RabbitMQ 实现订单履约、库存扣减、配送创建、路线绑定和物流状态流转等环节的异步解耦。

  在具体设计与实现方面，系统围绕物流履约过程构建了订单、仓储、配送和路线规划之间的协同流程。订单生成后，系统完成库存扣减、配送任务创建、路线生成和运输状态更新等处理，并通过轨迹记录与地图展示反映物流运输过程。物流规划模块集成 GraphHopper 路网引擎，并结合大语言模型对候选路线进行辅助分析；末端配送环节结合 K-Means 聚类和贪心排序，对配送任务进行分组和顺序优化；跨区域运输环节则以中转枢纽为基础，设计干线运输与末端配送相结合的分段流程，并利用最小费用最大流算法生成运力分配方案。

  本文的创新点主要体现在三个方面：一是基于微服务架构实现物流业务模块的解耦与协同，提高了系统的可维护性和扩展性；二是将真实路网路径规划、末端配送调度和跨区域运力分配结合到同一物流流程中，增强了系统对实际运输场景的支撑能力；三是在确定性算法计算结果的基础上引入大语言模型进行辅助分析，使路线选择和调度方案具有更好的可解释性。
][
  #set text(lang: "en", font: "Times New Roman")
  With the rapid development of e-commerce and the logistics industry, logistics management has an increasing demand for digital collaboration, resource scheduling, route planning, and transportation capacity coordination. To meet these practical application needs, this thesis designs and implements an intelligent logistics management system based on microservice architecture. Focusing on order fulfillment, warehouse inventory, transportation and delivery, and capacity scheduling, the system builds a logistics management platform with business collaboration and intelligent decision-making capabilities.

  Based on the analysis of the logistics fulfillment process and system module boundaries, the system adopts a front-end and back-end separated microservice architecture. The back end is developed with Spring Boot and Spring Cloud Alibaba, and is divided into service modules for authentication, customer, shop and inventory, order, transportation and delivery, logistics planning, and gateway. Nacos is used for service registration and configuration management, Spring Cloud Gateway provides unified access and request authentication, and OpenFeign supports synchronous service calls. MySQL is used for data persistence, Redis is used to cache high-frequency data such as routes, warehouses, and delivery tasks, and RabbitMQ is introduced to decouple order fulfillment, inventory deduction, delivery creation, route binding, and logistics status updates.

  In terms of design and implementation, the system builds a collaborative process among orders, warehousing, delivery, and route planning around logistics fulfillment. After an order is generated, the system completes inventory deduction, delivery task creation, route generation, and transportation status updates, and reflects the transportation process through trajectory records and map visualization. The logistics planning module integrates the GraphHopper road network engine and uses large language models to assist in analyzing candidate routes. For last-mile delivery, K-Means clustering and greedy sorting are used to group delivery tasks and optimize their visiting order. For cross-regional transportation, the system designs a segmented process combining trunk transportation and last-mile delivery based on transfer hubs, and uses the minimum-cost maximum-flow algorithm to generate capacity allocation plans.

  The innovations of this thesis are mainly reflected in three aspects. First, the microservice architecture is used to decouple and coordinate logistics business modules, improving system maintainability and scalability. Second, real-road-network route planning, last-mile delivery scheduling, and cross-regional capacity allocation are integrated into the same logistics process, strengthening the system's support for practical transportation scenarios. Third, large language models are introduced for auxiliary analysis based on deterministic algorithm results, making route selection and scheduling plans more interpretable.
]

// 显示目录
#outline()

// 设置文档主体的格式
#show: mainmatter

= 绪论

本章介绍论文的研究背景与意义、国内外研究现状及不足、主要研究内容以及论文组织结构。先讨论物流行业的发展现状与智能物流系统的现实需求，阐述微服务架构应用于物流领域的背景与意义；再从国内外两个视角梳理智能物流管理系统、路径规划与运力优化等方面的研究进展，分析现有工作的不足与本文的切入点；随后明确本文的研究内容；最后介绍论文的组织结构与各章安排。

== 研究背景及意义

物流行业作为支撑国民经济的基础性产业，在电子商务迅猛发展下其重要性日益凸显。然而，传统物流管理模式在业务复杂性、时效性与成本控制方面逐渐暴露出高成本、低效率、信息孤岛等瓶颈。中国的物流成本占GDP比重曾高达14.6%（2022年），远高于发达国家平均水平（约8%）。在物联网、大数据、人工智能等新一代技术驱动下，物流行业正经历数字化和智能化转型@ref1 @ref2 @ref3 @ref4。例如，物联网技术使货物、车辆、仓库等物流要素的状态感知与数据采集成为可能@ref2；大数据分析为路径优化、需求预测等供应链决策提供了数据驱动的理论框架@ref3；人工智能在智能调度、风险预警等方面的应用为物流系统的智能化提供了参考路径@ref4。

与此同时，传统单体式系统架构在支撑复杂智能物流应用时局限性愈发明显：模块耦合度高、维护成本大、迭代周期长，难以满足高并发与高可用需求@ref5。微服务架构将复杂系统拆分为自治服务单元，天然契合智能物流系统对灵活性、可扩展性与高可用性的要求@ref6。基于此，本研究设计并实现基于微服务架构的智能物流管理系统，具有以下意义：

+ 提高物流运作效率：微服务架构解耦各业务模块，结合路径优化与智能调度，提升运输与仓储资源利用率。

+ 降低运营成本：弹性伸缩能力避免资源浪费，优化路径与库存管理降低运输与仓储成本。

+ 提升用户体验：实时订单跟踪与精准预计送达时间改善用户满意度，独立部署保障服务连续性。

+ 促进物流行业数字化转型：为传统物流企业向智能化转型提供可借鉴的技术方案。

== 国内外研究现状及不足

=== 微服务架构

近年来，随着互联网应用规模的不断扩大，传统单体式系统在功能扩展、模块维护、并发处理和持续交付等方面逐渐暴露出局限，微服务架构逐渐成为复杂业务系统设计的重要方向。Zimmermann@ref8 对微服务架构的核心特征进行了总结，指出微服务强调围绕业务能力进行服务拆分，各服务可独立开发、测试、部署和扩展。Dragoni等@ref11 从架构演进的角度梳理了微服务的发展过程，认为微服务架构并不是简单的系统拆分，而是与云原生、DevOps、持续交付等工程实践密切相关的一种系统构建方式。与传统SOA架构相比，微服务架构更加重视服务自治、轻量级通信和独立运维，在复杂系统的快速迭代中具有较高的应用价值@ref13。

在物流管理系统领域，微服务架构同样具有较强的适用性。物流业务通常涉及订单处理、仓储库存、运输配送、路径规划和状态跟踪等多个环节，各环节之间既相互协作，又具有相对独立的业务边界。贾志刚等@ref19 基于Spring Cloud微服务架构对物流运输管理系统进行了重构设计，说明微服务拆分能够降低物流系统内部模块之间的耦合度；张恩路等@ref20 设计了基于微服务架构的物流信息平台，涵盖订单、库存和配送等常见业务模块。国外方面，Gonzalez等@ref33 对传统ERP系统向微服务架构迁移的策略与挑战进行了分析，指出服务拆分、数据边界划分和系统演进能力是大型业务系统迁移过程中需要重点考虑的问题。Liu等@ref31 设计了基于微服务架构的智能物流管控平台，也体现了微服务架构在物流系统中的应用趋势。

由上述研究可以看出，微服务架构能够为物流管理系统提供较好的扩展性和维护性，尤其适合订单、仓储、运输和规划等模块并存的复杂业务场景。但现有研究中，部分系统仍主要停留在基础业务功能实现层面，对服务之间如何协同完成完整物流履约链路的分析不够充分。例如，在订单创建后如何协调库存扣减、配送任务生成、路线规划和状态更新，如何通过同步调用与异步消息共同保证业务流程的稳定性，如何利用缓存和网关机制提升系统性能与安全性，这些问题仍需要结合具体项目进行进一步设计。因此，本文在微服务架构下对智能物流管理系统进行模块划分和业务协同设计，具有一定的工程实践意义。

=== 智能物流优化与大模型辅助决策

智能物流优化是物流信息系统向智能化发展的重要方向，主要包括路径规划、末端配送调度、物流网络优化和运力分配等内容。路径规划直接影响运输效率和配送成本，常见研究方法包括Dijkstra算法、A\*算法、遗传算法、蚁群算法以及车辆路径问题相关模型。Zhang等@ref34 将A\*算法应用于真实道路环境下的车辆路径规划，说明基于真实路网的路径搜索比理想化图模型更接近实际运输场景。Liu等@ref35 对车辆路径问题的模型、分类和应用进行了综述，指出车辆调度问题通常需要综合考虑车辆容量、配送顺序、时间约束和多点访问等因素。国内研究中，王勇等@ref39 将K-Means聚类方法应用于物流多配送中心选址优化，通过空间聚类方法提高配送节点布局的合理性。

除单点路径规划和末端配送调度外，跨区域物流网络中的运力分配同样是智能物流研究的重要内容。Zhao等@ref36 针对Hub-and-Spoke网络中的货物配送问题构建了带延迟成本的优化模型，为枢纽网络下的运输组织提供了参考。Fragkos等@ref37 对最大流和最小费用流问题的精确算法进行了综述，说明网络流模型适合描述带容量和费用约束的运输分配问题。根据中国物流与采购联合会发布的数据@ref40，我国社会物流总费用占GDP比重仍处于较高水平，这也说明物流网络组织、运输资源配置和全局运力优化仍有进一步提升空间。由此可见，将路径规划、末端调度和网络流优化结合起来，能够更全面地支撑物流系统从局部配送到跨区域运输的业务需求。

近年来，大语言模型在供应链分析和物流决策中的应用也逐渐受到关注。Simchi-Levi等@ref38 探讨了大语言模型在供应链决策中的应用潜力，指出其在信息整合、方案解释和管理建议生成等方面具有一定价值。与传统优化算法相比，大语言模型更擅长处理自然语言信息和复杂上下文，但其输出具有不确定性，难以直接替代路径规划、容量约束计算和成本最优化等确定性任务。因此，在智能物流系统中，更合理的方式是将大语言模型作为辅助决策工具，在确定性算法生成结果后，对候选路线、调度方案或运力规划结果进行解释、校准和建议生成。

综合现有研究可以发现，物流管理系统、路径规划、末端调度、网络流优化和大语言模型辅助决策等方向均已有一定研究基础，但仍存在以下不足：一是部分物流系统仍以订单、库存、配送等基础功能为主，对路径规划、调度优化和运力规划等智能化能力集成不足；二是路径规划、聚类调度和网络流优化常作为相对独立的算法问题进行研究，与订单履约、仓储库存、配送任务和运输状态流转结合不够紧密；三是大语言模型在物流领域的应用仍处于探索阶段，如何在保证确定性算法结果可控的前提下发挥其辅助分析能力，仍需要工程实践验证。基于上述问题，本文设计并实现一套基于微服务架构的智能物流管理系统，将真实路网路径规划、末端聚类调度、网络流优化和大语言模型辅助分析融入物流履约流程中，以提升系统的业务协同能力和智能化水平。

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

本章围绕论文选题展开绪论部分的论述，说明了智能物流管理系统的研究背景、现实意义、相关研究基础以及本文的主要研究内容。在电子商务持续发展和物流业务规模不断扩大的背景下，物流管理系统不再局限于订单记录和状态查询，而是逐渐承担订单协同、仓配调度、路线规划、运输跟踪等综合业务支撑功能。现有研究在微服务架构、路径规划、末端调度和运力优化等方面提供了较多参考，但在复杂物流流程下，服务间协同、算法结果嵌入业务流程以及系统可落地实现等问题仍需要进一步完善。针对上述问题，本文设计并实现基于Spring Cloud微服务架构的智能物流管理系统，将订单管理、库存管理、配送跟踪、路径规划、聚类调度和干线运力分配等功能纳入统一系统框架，以增强系统的可扩展性、业务协同能力和智能化决策支持能力。后续章节将从关键技术、总体设计、功能实现和系统验证等角度逐步展开，为智能物流管理系统的工程实现提供较为完整的设计思路和实践参考。

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

微服务架构中，服务间通信可分为同步调用与异步消息传递。消息队列提供服务解耦、异步通信与削峰填谷三方面能力。主流方案中，RabbitMQ提供灵活路由与可靠消息确认，适合业务事件驱动场景；Kafka以高吞吐和持久化著称，适合流处理场景@ref14。Fu等@ref14 对Kafka、RabbitMQ、RocketMQ、ActiveMQ与Pulsar五种主流消息队列进行了公平对比实验。本系统在订单创建后的库存扣减、配送创建与调度入池等环节采用RabbitMQ实现异步解耦。

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

Docker是目前最主流的容器化平台@ref30，允许将应用及依赖打包为轻量级、可移植的容器镜像。结合持续交付实践@ref17，容器化消除了"环境差异"导致的部署风险。Docker Compose通过YAML文件定义多容器应用的启动、停止与依赖关系，本系统仅需一个全局配置文件即可完成数据库、中间件、微服务与前端的整体部署。对于毕设阶段的单机部署需求，Docker Compose已足够；生产环境可进一步引入Kubernetes获得自动扩缩容能力。

== 智能算法技术

本项目引入了面向物流优化场景的智能算法，使系统从传统信息管理平台演进为具备辅助决策能力的智能物流平台。

=== 路网引擎与A\*搜索

GraphHopper是一款Java路径规划引擎，可加载OpenStreetMap数据构建可查询的道路图结构，基于真实道路拓扑执行路径搜索。A\*算法通过代价函数$f(n) = g(n) + h(n)$引导搜索，启发函数采用Haversine球面距离，满足可采纳性条件保证最优性。系统还使用加权启发策略，通过调整epsilon生成多条差异化候选路线。

=== 大语言模型辅助决策

大语言模型具备较强的自然语言理解与推理分析能力，在本系统中用于多个辅助决策场景：路径规划中结合候选路线与交通特征选择路线；末端调度中给出批次合并与优先级建议；运力规划中对MCMF结果进行可读分析。该方法不替代传统优化算法，而是与确定性算法协同提升决策的可解释性。

=== 最小费用最大流

最小费用最大流（MCMF）问题求解在满足流量约束的前提下运输总成本最小的网络流分配。本系统将全国干线网络抽象为带容量与费用的有向图，并采用多商品建模方式将每个起始Hub与目标Hub形成的OD对作为独立运输需求，通过MCMF求解生成跨区域运输的全局运力分配方案。

== 关键技术选型汇总

前文分别从微服务治理、数据访问、前端交互、容器化部署和智能算法等方面介绍了系统实现所需的关键技术。为了便于后续系统设计与实现章节形成对应关系，本节对主要技术选型进行集中梳理。@tech-comparison 从技术领域、选用方案、候选方案和决策理由四个角度总结核心技术决策，其中选型重点并非单纯追求技术复杂度，而是结合本课题的业务规模、开发成本、部署环境和可验证性进行权衡。

#tablex(
  [注册中心], [Nacos], [Eureka], [Zookeeper], [同时支持服务发现与配置管理，CP/AP可切换],
  [消息队列], [RabbitMQ], [Kafka], [ActiveMQ], [路由灵活、消息确认可靠，适合业务事件驱动],
  [API 网关], [Spring Cloud Gateway], [Zuul 1.x], [—], [基于 WebFlux 非阻塞模型，与 Spring Cloud 2022 深度集成],
  [ORM 框架], [MyBatis-Plus], [JPA/Hibernate], [R2DBC], [保留 SQL 控制能力，通用 CRUD 减少样板代码],
  [缓存方案], [Redis + Cache-Aside], [Caffeine 本地缓存], [—], [Redis 支持多实例共享，Cache-Aside 兼顾一致性与性能],
  [前端框架], [Vue3], [React], [Angular], [Composition API 适合多角色状态复用，TypeScript 集成友好],
  [地图组件], [Leaflet], [Mapbox GL], [高德地图 JS API], [开源免费，GeoJSON 渲染能力强，无商业授权限制],
  [容器编排], [Docker Compose], [Kubernetes], [—], [毕设阶段单机部署足够，K8s 适用于生产环境],
  header: ([技术领域], [选用方案], [候选方案 1], [候选方案 2], [决策理由]),
  columns: (auto, auto, auto, auto, 1fr),
  caption: [核心技术选型对比与决策表],
  label-name: "tech-comparison",
)

总体来看，Nacos、Gateway、OpenFeign与RabbitMQ主要支撑服务治理和跨服务协同，MySQL、MyBatis-Plus与Redis负责业务数据持久化和热点数据访问，Vue3、Element Plus与Leaflet用于多角色交互和地图可视化，Docker Compose用于统一部署，GraphHopper、A\*、K-Means、MCMF与大语言模型则支撑路径规划、末端调度、运力优化和辅助分析。上述技术选型与后续系统架构和功能实现保持对应关系。

== 本章小结

本章围绕基于微服务架构的智能物流管理系统，对系统实现所需的关键技术进行了梳理。首先介绍了注册中心、API网关、服务调用和消息队列等微服务治理技术，说明其在服务发现、统一接入和异步解耦中的作用；随后介绍了MySQL、MyBatis-Plus、Redis、Vue3、Leaflet和Docker Compose等支撑数据管理、前端交互、地图可视化与部署运行的工程技术；最后对路径规划、聚类调度、最小费用最大流和大语言模型辅助决策等智能算法技术进行了说明。通过上述分析，本章为后续系统设计、功能实现和测试验证提供了技术基础。

= 系统设计

本章按需求分析→架构设计→数据库设计的顺序展开。第一节分析系统涉及的角色用例、功能需求与非功能需求；第二节给出系统的总体架构与核心业务流程，并按微服务划分逐一阐述认证服务、顾客服务、商店与库存服务、订单服务、运输员配送服务、物流规划服务与网关服务的架构设计与数据接口，同时阐述智能算法设计方案与前端架构设计；第三节从全局视角给出系统数据库设计，包括E-R模型与核心表梳理。

== 需求分析

=== 总体分析

本系统面向B2C物流场景，核心业务流程为：顾客下单 → 商户从仓库发货 → Hub中转站干线运输与分拣 → 运输员末端配送签收。系统涉及四类参与角色：顾客（发起寄件与追踪订单）、商户（管理承运物与仓库库存）、运输员（执行配送与路线导航）、管理员（审核用户与调度管理）。在跨城物流场景中，系统基于Hub-and-Spoke三级网络拓扑组织干线运输，并通过K-Means聚类与MCMF运力规划实现智能调度。

以下以核心物流订单流程为例，分析各角色在履约链路中的参与步骤。

#imagex(
  image("figures/e-commerce-flow.png", width: 85%),
  caption: [物流订单核心流程],
  label-name: "ecommerce-flow",
)

=== 功能需求-顾客用例

顾客主要基于地址管理发起物流订单，并追踪物流状态。

#imagex(
  image("figures/person-use-case.png", width: 45%),
  caption: [顾客用例图],
  label-name: "person-use-case",
)

如@person-use-case 所示，顾客需要地址管理、平台下单、查看物流单等功能。

=== 功能需求-商户用例

商户的主要运输对象是仓库中的批量承运物。商户使用仓库作为发货地址，可在多个仓库间转运承运物，以优化库存管理和发货成本。

#imagex(
  image("figures/business-use-case.png", width: 45%),
  caption: [商户用例图],
  label-name: "business-use-case",
)

=== 功能需求-运输员用例

运输员主要负责完成物流过程中的末端配送，系统基于路线与费用自动规划最优安排，并为运输员规划最优运输路线。

#imagex(
  image("figures/driver-use-case.png", width: 50%),
  caption: [运输员用户用例图],
  label-name: "driver-use-case",
)

=== 非功能需求

本项目致力于通过微服务架构解决现实世界中物流系统数据量大、使用环境复杂、崩溃后果严重等问题，因此需要解决如下非功能需求：

+ 高并发：该系统可借助横向扩展与弹性扩容等手段，合理应对高强度、随时变化的并发规模。在大型互联网架构实践中，高并发通常通过分而治之、缓存加速与异步解耦三层策略实现@ref16，本系统的微服务拆分与Redis缓存正是遵循了这一思路。

+ 高可用：该系统可以容忍部分节点的故障、自动负载均衡并将任务迁移到可用节点。

+ 可扩展性：该系统可以轻松接入外部系统及数据，可以轻松实现新的功能以应对日新月异的功能需求。

+ 用户友好：该系统在UI设计上简洁易懂、易于使用。

+ 安全性：该系统为用户提供完善的鉴权机制与权限控制，避免恶意用户的风险操作。

== 架构设计

=== 总体架构

本系统采用基于微服务架构的分层设计思想，将复杂物流业务拆分为多个职责清晰的独立服务，并通过统一网关、服务注册发现、同步调用与异步消息机制实现协同 @ref32。在服务拆分过程中，系统遵循领域驱动设计（DDD）原则@ref23，以业务能力边界划分服务职责，确保每个服务对应一个限界上下文。同时，基于Conway定律@ref10，系统的服务划分与团队协作结构保持对齐，以降低跨服务沟通成本。整体架构可划分为接入层、业务层、通信层、存储层和编排层五个部分。

#imagex(
  image("figures/architecture-overview.png", width: 100%),
  caption: [架构总览图],
  label-name: "architecture",
)

接入层由前端单页应用、Nginx 与 API 网关组成。业务层由认证服务、顾客服务、商店与库存服务、订单服务、运输员配送服务、物流规划服务及网关服务组成，各服务统一注册到 Nacos 中。通信层同时支持基于 OpenFeign 的同步服务调用和基于 RabbitMQ 的异步消息通信。存储层采用 MySQL 作为持久化数据库，并使用 Redis 作为缓存。编排层基于 Docker Compose 进行统一部署。

=== 核心业务流程

基于上述架构，系统核心业务围绕"下单→Hub建模→全国规划→干线到达→末端调度→签收闭环"的Hub-and-Spoke履约链路展开。@order-flow 展示了从顾客用户下单到收件人签收的完整业务流程，涉及订单服务、物流服务、运输员服务三个核心服务的跨服务协作。

#imagex(
  image("figures/core-business-flow.png", width: 100%),
  caption: [系统核心业务流程图],
  label-name: "order-flow",
)

图中横向按“下单受理→Hub建模→全国规划→干线到达→末端调度→签收闭环”六个阶段组织，纵向按参与角色、订单服务、物流服务和运输员服务划分泳道。订单创建后，订单服务通过Feign同步调用物流服务完成起始Hub与目标Hub分配，并通过RabbitMQ异步写入干线待处理池；管理员首先触发MCMF全国运力规划，物流服务据此生成跨城干线批次并完成发车、到达和目标Hub末端池回写。只有订单到达目标Hub并进入城市末端调度池后，管理员才生成末端调度方案，系统在此阶段调用K-Means对待配送订单进行聚类并创建配送批次，最终由运输员完成配送并闭环签收。

=== 认证服务（auth-service）

本模块负责用户管理、登录鉴权与角色权限控制，是系统安全的入口保障。系统采用三段式认证架构：认证服务签发JWT令牌、网关层校验令牌与路径权限、下游服务透传用户身份。该设计将认证逻辑从业务服务中彻底解耦，各业务服务仅需从请求头读取用户ID与角色标识即可执行业务鉴权，无需重复校验Token有效性。在用户注册流程中，顾客直接通过审核，商户与运输员需管理员审核后方可使用系统，这一差异化审批策略对应了不同角色对数据操作权限的敏感度差异。

#tablex(
  [id], [BIGINT], [PK AUTO\_INCREMENT], [用户 ID],
  [username], [VARCHAR(100)], [NOT NULL, UNIQUE], [用户名],
  [secret], [VARCHAR(255)], [NOT NULL], [BCrypt 密码哈希值],
  [permission], [TINYINT], [NOT NULL], [角色标识：1=管理员，2=顾客，3=商户，4=运输员],
  [create\_time], [DATETIME], [NOT NULL], [创建时间],
  header: ([字段名], [数据类型], [约束], [描述]),
  columns: (1fr, 1fr, 1.2fr, 1.5fr),
  caption: [User模型属性表],
  label-name: "user-table",
  breakable: false,
)

User模型用于保存系统登录身份与基础权限信息，其中permission字段决定用户在网关层和业务层可访问的功能范围。认证服务围绕该模型提供注册、登录、用户查询和权限调整等接口，主要接口设计如@auth-api 所示。

#tablex(
  [POST], [/api/auth/register], [用户注册（顾客直接通过；商户/运输员需审核）],
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

=== 顾客服务（customer-service）

顾客服务实现个人信息与地址管理功能，主要面向寄件用户维护基础资料和常用地址。该服务不直接处理登录认证，而是通过user\_id与认证服务中的用户身份建立关联，从而在业务数据和登录身份之间保持清晰边界。

#tablex(
  [id], [BIGINT PK AUTO], [个人用户 ID],
  [user\_id], [BIGINT], [关联 user.id],
  [name], [VARCHAR(100)], [真实姓名],
  [phone], [VARCHAR(20)], [联系电话],
  [email], [VARCHAR(100)], [邮箱],
  [create\_time], [DATETIME], [创建时间],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [个人用户模型属性表],
  label-name: "person-table",
)

个人用户模型保存姓名、联系方式等资料信息，作为后续创建物流订单时的寄件人基础数据。由于同一顾客可能维护多个发货地址，系统单独设计地址模型保存地址文本与默认地址标识。

#tablex(
  [id], [BIGINT PK AUTO], [地址 ID],
  [customer\_id], [BIGINT], [所属顾客 ID],
  [address], [VARCHAR(255)], [地址文本],
  [is\_default], [TINYINT], [是否默认地址],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [Address模型属性表],
  label-name: "address-table",
)

在接口设计上，顾客服务围绕个人资料维护和地址增删改查展开，既支持用户完善自身资料，也为订单服务在下单阶段获取地址信息提供数据来源。

#tablex(
  [GET], [/api/customers/{id}], [获取个人用户信息],
  [POST], [/api/customers], [添加个人用户信息],
  [PUT], [/api/customers], [修改个人用户信息],
  [GET], [/api/customers/{id}/address], [获取个人用户地址列表],
  [POST], [/api/customers/address], [添加个人用户地址],
  [PUT], [/api/customers/address], [修改个人用户地址],
  [DELETE], [/api/customers/address/{id}], [删除个人用户地址],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [个人用户模块 API 表],
  label-name: "person-api",
)

=== 商店与库存服务（shop-service）

商店与库存服务承担商户管理、承运物管理、仓库管理与库存维护等职责，是下单链路中进行库存校验和库存扣减的关键服务。模块设计采用同步校验与异步扣减结合的方式：订单创建时同步验证库存与仓库地址有效性，订单确认后再通过RabbitMQ触发库存扣减，从而降低服务间同步阻塞对下单流程的影响。在库存扣减方面，系统采用乐观锁机制防止超卖，更新库存时附加版本校验条件，若发生并发冲突则由业务层重试。

从数据模型看，该服务围绕商户、承运物、仓库和库存关系展开。商户是承运物和仓库的管理主体，其基础属性如@shop-table 所示。

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

承运物由商户创建和维护，保存名称、申报价值、审核状态等信息。商户与承运物之间为一对多关系，因此承运物模型中直接通过shop\_id关联所属商户。

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

仓库用于描述商户可发货或存储承运物的物理地点，除地址文本外还保存经纬度坐标，便于后续路线规划和仓配调度使用。

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

承运物与仓库之间存在多对多关系，同一承运物可以分布在多个仓库，同一仓库也可以存放多个承运物，因此系统通过库存关系表记录具体库存数量。

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

围绕上述模型，商店与库存服务对外提供承运物维护、仓库维护和库存设置等接口，供商户端页面和订单服务共同调用。

#tablex(
  [GET], [/api/products?shopId={id}], [获取商户承运物列表],
  [POST], [/api/products], [添加承运物],
  [PUT], [/api/products], [修改承运物],
  [DELETE], [/api/products/{id}], [删除承运物],
  [GET], [/api/warehouses/shop/{shopId}], [获取商户仓库列表],
  [POST], [/api/warehouses], [添加仓库],
  [GET], [/api/stocks/warehouse/{warehouseId}], [查询库存],
  [PUT], [/api/stocks], [设置库存],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [商户与承运物模块核心 API 表],
  label-name: "shop-api",
)

=== 运输员配送服务（driver-service）

运输员配送服务涵盖运输员管理、车辆管理与配送执行等功能，是连接订单履约与末端配送的核心业务环节。配送流程采用状态机设计，配送单状态从待接单(0)经已接单(1)、运输中(2)到达已送达(3)完成履约，4=已取消为异常终止态，每次状态流转均记录操作时间，便于追踪配送过程。

在数据模型上，运输员实体保存身份关联、联系方式、驾照编号和审核状态等信息，用于判断用户是否具备接单和配送资格。

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

车辆实体保存车牌号、车辆类型和载重能力等信息。运输员与车辆之间为多对多关系，可支持同一运输员在不同配送任务中使用不同车辆，也便于后续扩展车辆调度能力。

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

在接口设计上，运输员配送服务既提供运输员资料与车辆绑定能力，也提供待接单配送任务查询入口。配送任务本身由物流服务在调度执行时通过RabbitMQ异步通知生成，从而使调度决策与配送执行保持解耦。

#tablex(
  [GET], [/api/drivers/{id}], [获取运输员信息],
  [POST], [/api/drivers], [添加运输员信息],
  [GET], [/api/drivers/vehicles], [获取运输员车辆],
  [POST], [/api/drivers/vehicles/{vid}], [运输员绑定车辆],
  [GET], [/api/drivers/deliveries/pending], [查看待接单配送任务],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [运输员模块核心 API 表],
  label-name: "driver-api",
)

=== 订单服务（order-service）

订单服务承担订单主记录管理、配送单管理、仓储操作与物流状态承载等职责，是订单履约流程的核心编排服务。订单创建后，该服务需要协调顾客地址、商户库存、发货仓库、中转站分配和配送状态流转等信息，因此其设计重点在于保存履约主线数据并向其他服务提供稳定的订单上下文。

仓储相关接口主要用于支撑承运物入库、出库和库存查询。仓库实体已在商店与库存服务中定义，此处不再重复建模，仅列出订单履约过程中需要调用的仓储操作接口。

#tablex(
  [GET], [/api/warehouses/{id}], [获取仓库信息],
  [GET], [/api/warehouse-shops/warehouse/{id}], [获取托管商户],
  [GET], [/api/stocks/warehouse/{id}], [获取仓库承运物库存],
  [POST], [/api/inbound-orders], [承运物入库],
  [POST], [/api/outbound-orders], [承运物出库],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [仓储模块核心 API 表],
  label-name: "warehouse-api",
)

订单主表保存订单编号、顾客、商户、收货地址、支付状态、发货仓库以及起止中转站等信息，是订单履约状态判断和后续物流规划的基础。

#tablex(
  [id], [BIGINT PK AUTO], [订单 ID],
  [order\_no], [VARCHAR(32)], [订单号（唯一）],
  [customer\_id], [BIGINT], [顾客 ID],
  [shop\_id], [BIGINT], [商户 ID],
  [address\_id], [BIGINT], [收货地址 ID],
  [total\_amount], [DECIMAL(10,2)], [订单总金额],
  [order\_status], [TINYINT], [0=待支付，1=待发货，2=待揽件，3=派送中，4=已完成，5=已取消],
  [payment\_status], [TINYINT], [0=未支付，1=已支付],
  [warehouse\_id], [BIGINT], [发货仓库 ID],
  [origin\_hub\_id], [BIGINT], [起始中转站 ID],
  [dest\_hub\_id], [BIGINT], [目标中转站 ID],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [order\_info 实际字段表],
  label-name: "order-table",
)

配送单用于描述具体配送执行任务，与订单主表通过order\_id关联。其状态变化反映运输员接单、运输中、送达或取消等执行过程，是订单状态更新的重要依据。

#tablex(
  [id], [BIGINT PK AUTO], [配送单 ID],
  [order\_id], [BIGINT], [关联订单 ID],
  [driver\_id], [BIGINT], [运输员 ID],
  [delivery\_type], [TINYINT], [0=普通配送，1=末端配送],
  [delivery\_status], [TINYINT], [0=待接单，1=已接单，2=运输中，3=已送达，4=已取消],
  [start\_address / end\_address], [VARCHAR(255)], [起终点地址],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [delivery 配送单字段表],
  label-name: "delivery-table",
  breakable: false,
)

围绕订单主记录，订单服务提供订单创建、详情查询、个人订单列表和状态更新等接口。创建订单时会触发后续库存校验、Hub分配与物流规划流程，状态更新则用于保持前端订单展示和后台履约进度一致。

#tablex(
  [POST], [/api/orders], [创建订单],
  [GET], [/api/orders/{id}], [获取订单详情],
  [GET], [/api/orders/my], [获取我的订单列表],
  [PUT], [/api/orders/{id}/status], [更新订单状态],
  header: ([Method], [URI], [描述]),
  columns: (0.6fr, 2fr, 2fr),
  caption: [订单模块核心 API 表],
  label-name: "order-api",
)

=== 物流规划服务（logistics-service）

物流规划服务是系统智能化能力的核心承载，负责路径规划、中转站管理、调度执行与全国运力规划@ref36 @ref37。模块采用Hub-and-Spoke网络模型作为顶层设计范式，将全国物流节点按层级划分为全国枢纽、省级中心与城市配送中心三级，通过中转站间的运输连接构建干线网络，末端配送则由K-Means聚类生成的配送批次覆盖。

该服务的数据设计围绕“路线—枢纽—批次—调度池—运力规划”展开。其中，物流路线用于记录订单在不同运输阶段的路径信息，是连接路径规划结果与业务状态流转的基础数据。

#tablex(
  [id], [BIGINT PK AUTO], [路线 ID],
  [route\_no], [VARCHAR(32)], [路线号（唯一）],
  [segment\_type], [TINYINT], [0=普通路线，1=干线段，2=末端段],
  [route\_status], [TINYINT], [-1=等待中转激活，0=待出发，1=运输中，2=已送达，3=运输异常],
  [planned\_route], [LONGTEXT], [GeoJSON 规划路线数据],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 1.8fr),
  caption: [logistics\_route 核心字段表],
  label-name: "route-table",
)

枢纽表用于描述Hub-and-Spoke网络中的物流节点。hub\_level字段区分全国枢纽、省级中心和城市配送中心，daily\_capacity字段为后续干线运力规划提供容量约束。

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

配送批次用于承载一次调度或干线运输中被合并处理的订单集合。系统通过批次状态记录其从待出发、运输中、到达中转站到末端派送完成的过程。

#tablex(
  [id], [BIGINT PK AUTO], [批次 ID],
  [batch\_no], [VARCHAR(32)], [批次编号（唯一）],
  [batch\_status], [TINYINT], [0=待出发，1=干线运输中，2=已到中转站，3=末端派送中，4=全部完成],
  [total\_orders], [INT], [批次订单数量],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 2fr),
  caption: [logistics\_batch 批次核心字段表],
  label-name: "batch-table",
)

为支撑干线运输网络建模，系统使用hub\_link表记录枢纽之间的运输连接、运输方式、距离、容量和单位成本，这些字段也是MCMF运力分配的主要输入。

#tablex(
  [id], [BIGINT PK AUTO], [连接 ID],
  [from\_hub\_id], [BIGINT], [起始枢纽 ID],
  [to\_hub\_id], [BIGINT], [目标枢纽 ID],
  [transport\_mode], [TINYINT], [0=公路，1=铁路，2=航空],
  [distance\_km], [DECIMAL(10,2)], [运输距离（公里）],
  [capacity\_daily], [INT], [日处理容量],
  [base\_cost\_per\_unit], [DECIMAL(10,4)], [基准运输单价],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [hub\_link 运输连接表],
  label-name: "hub-link-table",
)

批次项表用于记录批次与订单、路线之间的对应关系，同时保存停靠顺序和目的地坐标，使系统能够将聚类或运力规划结果落到具体订单。

#tablex(
  [id], [BIGINT PK AUTO], [批次项 ID],
  [batch\_id], [BIGINT], [所属批次 ID],
  [order\_id], [BIGINT], [关联订单 ID],
  [route\_id], [BIGINT], [关联路线 ID],
  [visit\_sequence], [INT], [停靠顺序],
  [stop\_sequence], [INT], [路线点序号],
  [end\_lat / end\_lng], [DOUBLE], [目的地坐标],
  [end\_address], [VARCHAR(255)], [目的地地址],
  [item\_status], [TINYINT], [项状态],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [logistics\_batch\_item 批次项表],
  label-name: "batch-item-table",
)

调度池保存尚未被分配到配送批次的订单。管理员执行末端调度前，系统先从调度池读取待处理订单，再根据目的地位置进行聚类预览和批次生成。

#tablex(
  [id], [BIGINT PK AUTO], [调度池项 ID],
  [order\_id], [BIGINT], [关联订单 ID],
  [shop\_id], [BIGINT], [商户 ID],
  [warehouse\_id], [BIGINT], [发货仓库 ID],
  [end\_address], [VARCHAR(255)], [目的地地址],
  [end\_lat / end\_lng], [DOUBLE], [目的地坐标],
  [status], [TINYINT], [0=待调度，1=已调度],
  [batch\_id], [BIGINT], [分配批次 ID],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [dispatch\_pool 调度池表],
  label-name: "dispatch-pool-table",
)

全国运力规划结果由规划主表和规划明细表共同保存。规划主表记录一次MCMF求解的总体流量、总费用和大语言模型分析结果，便于管理员查看全局方案。

#tablex(
  [id], [BIGINT PK AUTO], [规划 ID],
  [total\_flow], [INT], [总分配流量],
  [total\_cost], [DECIMAL(12,2)], [总运输费用],
  [llm\_analysis], [TEXT], [LLM 分析报告],
  [create\_time], [DATETIME], [生成时间],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [flow\_plan 运力规划表],
  label-name: "flow-plan-table",
)

规划明细表进一步记录每条枢纽连接上的分配流量和单位运输费用，用于展示干线资源分配结果，并支撑后续批次生成或方案分析。

#tablex(
  [id], [BIGINT PK AUTO], [明细 ID],
  [plan\_id], [BIGINT], [所属规划 ID],
  [from\_hub\_id], [BIGINT], [起始枢纽 ID],
  [to\_hub\_id], [BIGINT], [目标枢纽 ID],
  [assigned\_flow], [INT], [分配流量],
  [unit\_cost], [DECIMAL(10,4)], [单位运输费用],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [flow\_plan\_item 规划明细表],
  label-name: "flow-plan-item-table",
)

围绕上述数据模型，物流规划服务对外提供路线创建、中转站分配、调度池查询、调度预览、调度执行、全国运力规划和位置上报等接口。

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

=== 网关服务（gateway-service）

网关服务作为系统的统一入口，基于Spring Cloud Gateway构建，承担请求路由、身份认证与权限控制三项核心职责。系统采用三段式认证架构：认证服务签发JWT令牌、网关层校验令牌与路径权限、下游服务透传用户身份。该设计将认证逻辑从业务服务中彻底解耦，下游服务仅需从请求头读取用户身份即可执行业务鉴权，无需重复校验Token有效性。路径权限规则按角色划分，确保各角色仅能访问所属业务接口。具体鉴权流程与路径权限规则的实现见第四章。

=== 智能算法设计

物流规划服务不仅承担路线、批次、轨迹和Hub网络等业务对象管理，还需要在订单履约过程中完成路径规划、末端调度和干线运力规划等决策任务。为降低算法逻辑与业务流程之间的耦合，系统在物流服务内部设置独立的算法层：业务层负责读取订单、调度池、Hub和运输边等数据，算法层负责执行路线搜索、订单聚类和流量分配，结果再由业务层转化为物流路线、配送批次、运力规划单和干线批次等可持久化对象。

结合物流履约流程中的不同决策任务，系统智能算法分为三个层次。第一层是道路级路径规划，输入为起点和终点经纬度，输出为可在前端地图渲染的GeoJSON路线；第二层是城市末端批次生成，输入为待调度订单集合及其目的地坐标，输出为聚类结果、建议批次数和末端配送批次；第三层是全国干线运力规划，输入为Hub节点、HubLink运输边和跨城OD需求，输出为各条运输边上的分配流量、总费用、未满足需求以及跨城运输批次。三类算法对应不同业务对象，但都遵循“算法结果进入业务流程”的设计原则，即算法输出不只用于展示，还需要写入系统数据表并驱动后续履约状态流转。智能算法层的输入输出关系如@algorithm-io-table 所示。

#tablex(
  [道路级路径规划], [起终点坐标、OSM路网、历史速度上下文], [A\*/Weighted A\*、LLM Judge/Waypoint], [GeoJSON路线、预计耗时、路线解释], [logistics\_route、logistics\_track],
  [城市末端调度], [dispatch\_pool订单、目的地经纬度、仓库/Hub位置], [K-Means、近似TSP、LLM调度建议], [聚类结果、建议批次数、配送批次], [logistics\_batch、dispatch\_pool],
  [全国干线规划], [Hub节点、HubLink边、OD需求、边容量与费用], [MCMF、多OD分配启发式、LLM费用校准], [边流量、总费用、OD路径、干线批次], [flow\_plan、flow\_plan\_item、inter\_city\_batch],
  header: ([算法层次], [主要输入], [核心方法], [主要输出], [关联业务对象]),
  columns: (1fr, 1.6fr, 1.5fr, 1.5fr, 1.6fr),
  caption: [智能算法层输入输出设计],
  label-name: "algorithm-io-table",
  breakable: false,
)

基于上述输入输出关系，算法层采用“确定性算法为主体、语言模型为辅助”的结构，以保证系统运行过程具有稳定性。A\*、K-Means和MCMF分别承担路径、批次和运力的核心计算；大语言模型主要用于候选路线裁决、方向性路点建议、费用倍率校准和结果解释。所有LLM输出均通过JSON格式约束、字段范围校验和失败降级处理后再进入后续流程。这样的设计使语言模型能够参与复杂上下文分析，同时不会替代路径可达性、容量约束和费用计算等核心求解环节。

围绕这些算法任务，路径规划采用策略模式封装不同路线策略；末端调度采用“预览—确认—执行”流程保留人工确认入口；全国运力规划采用“费用校准—流量求解—批次生成”流程将规划结果转化为干线运输任务。上述流程共同构成智能算法层与业务层之间的协同方式，具体代码实现与运行结果见第四章。

评价算法层设计时，本文主要关注结果可用性、约束满足性和业务转化性三类指标。结果可用性要求路径规划能够返回可渲染路线、聚类调度能够形成明确批次、干线规划能够给出边流量和费用结果；约束满足性要求路线位于真实路网，末端批次具有可执行停靠顺序，干线流量不超过HubLink容量；业务转化性要求算法输出能够继续写入logistics\_route、logistics\_batch、flow\_plan、flow\_plan\_item和inter\_city\_batch等数据表，成为后续状态流转、司机分配和管理员复核的依据。因此，本文对智能算法的设计重点不是孤立地比较算法优劣，而是说明路径、批次和运力三类计算结果如何嵌入物流履约流程。

具体到道路级路径规划，系统采用A\*算法作为基础搜索引擎，其代价函数$f(n) = g(n) + h(n)$中启发函数选用Haversine球面距离。系统使用GraphHopper导入OpenStreetMap路网数据，并使用其节点、边和空间索引能力支撑A\*搜索。A\*适合在非负边权图上进行启发式最短路搜索，Haversine距离能够反映两点间的球面直线距离，可作为道路距离的下界估计，GraphHopper提供的真实路网结构则使路径结果可以转化为前端地图可渲染的路线坐标。

在标准A\*基础上，系统引入Weighted A\*候选生成机制。通过设置不同的启发权重，系统可以得到若干条方向性不同的候选路线，再结合历史速度、延误和慢速热点等上下文进行辅助裁决。该设计将“路线可达性”和“候选路线选择”分为两个环节：前者由A\*和真实路网保证，后者由LLM Judge在有限候选集合中给出选择与解释。

系统采用策略模式将算法选择与业务逻辑解耦，定义RouteStrategy接口统一规划入口，支持纯A\*、LLM裁判与LLM路点三种策略的运行时切换。LLM裁判策略适用于候选路线可枚举、需综合评判的场景；LLM路点策略适用于已知拥堵区域但绕行方向需动态建议的场景。两种策略均设计了格式校验与降级机制，确保LLM调用异常时路径规划功能仍可返回确定性路线。

道路级路径规划解决单条路线的生成问题，末端配送调度则需要将调度池中的待配送订单按地理位置聚类为若干配送批次。K-Means算法结构清晰、迭代过程可解释，适合处理中等规模地理点集；距离度量采用Haversine球面距离，以匹配经纬度坐标的空间特性；聚类完成后对每个簇内部执行近似TSP贪心排序，以形成较合理的停靠顺序。

系统将K-Means用于两个业务阶段。第一阶段是管理员调度预览，系统根据调度池订单生成若干聚类区域，返回簇中心、订单列表和建议批次数，供管理员确认；第二阶段是末端批次生成，系统根据每名司机的最大停靠点数量估算簇数，将订单划分为可执行的配送批次。聚类结果不会直接结束流程，而是继续转化为LogisticsBatch、路线记录和司机任务，使算法结果与配送执行保持一致。

考虑到真实末端配送还可能涉及车辆容量、时间窗、司机工时和路网阻隔等因素，系统将K-Means定位为订单空间分组方法，而不是完整车辆路径问题求解器。对于聚类结果的可解释性，系统增加LLM辅助分析环节，根据簇中心、订单量、仓库距离和最近Hub信息给出批次合并或中转建议；若LLM不可用，则使用规则判断完成降级。

在跨区域运输场景下，全国干线运力规划将Hub-and-Spoke网络抽象为带容量与费用约束的有向流网络。MCMF作为经典网络流优化算法，适合描述“在容量约束下尽可能满足流量需求并降低总费用”的问题@ref37。系统采用超级源/汇点建模，将每个Hub拆分为入港与出港两个节点，Hub内部换载边表示节点处理能力，HubLink运输边表示不同Hub之间的干线连接；边容量取自hub\_link表的日处理能力，边费用取自基准运输单价及费用校准结果。

在跨城订单场景中，订单具有明确的起始Hub和目标Hub。若将所有OD需求简单聚合为单商品流，可能出现同一Hub发货需求与收货需求相互抵消的问题。为保留OD方向和后续批次生成所需的路径信息，系统在MCMF建模之外增加多OD分配启发式：按OD需求量降序处理，每个OD在共享剩余容量网络中寻找低费用可行路径，并记录经过的HubLink序列。该路径信息可进一步用于生成inter\_city\_batch干线批次。

此外，系统设计了LLM辅助费率校准机制，用于在求解前根据线路负载、历史成本和业务上下文修正边费用倍率。LLM只输出受范围约束的倍率建议，最终的容量约束和流量分配仍由网络流算法完成。规划完成后，系统将边流量、总费用、未满足需求和OD路径写入flow\_plan与flow\_plan\_item，并根据OD路径创建跨城干线批次，实现从网络流结果到业务执行对象的转换。

=== 前端架构与页面设计

本系统涉及顾客、商户、运输员和管理员四类角色，各角色的业务流程与交互模式存在显著差异：顾客侧重寄件管理与物流追踪，商户侧重库存管理与发货操作，运输员侧重地图导航与状态上报，管理员侧重调度预览与全网规划。因此，前端架构需要解决多角色路由隔离、统一认证状态管理、地图可视化集成以及前后端数据通信等核心问题。以下从总体架构、多角色页面结构和关键交互设计三个方面展开说明。

在路由隔离方面，系统将四类角色映射到四个独立路由入口（/admin/home、/customer/home、/shop/home、/driver/home），各入口拥有独立的布局组件与路由守卫，登录后根据角色标识自动跳转至对应入口，避免角色间的视图泄漏。在状态管理方面，系统选用Pinia而非Vuex，主要基于两点考量：Pinia去除了Vuex的mutations冗余层，直接通过actions修改状态，降低了多角色应用中的状态管理复杂度；Pinia的模块化store天然适合将认证状态、订单状态、地图状态等按职责拆分。在地图可视化方面，系统选用Leaflet而非商业地图SDK，因Leaflet轻量开源、无API调用限制，且通过OpenStreetMap瓦片即可实现运输轨迹与网络拓扑的交互式展示。

前端采用Vue3 + Vite构建单页应用，架构划分为视图组件层、路由控制层、状态管理层、通信服务层和部署接入层五个层次，各层职责明确、解耦协作。

#imagex(
  image("figures/frontend-architecture.png", width: 92%),
  caption: [前端总体架构图],
  label-name: "frontend-architecture",
)

如@frontend-architecture 所示，各层的职责与设计决策如下：

+ *视图组件层*：由Vue3组件、Element Plus界面组件和Leaflet地图组件构成，负责用户交互与界面渲染。本系统采用Element Plus提供统一的后台管理类组件风格，同时引入Leaflet实现运输轨迹与网络拓扑的地图可视化，两者通过Vue3的Composition API组织为可复用的业务组件。

+ *路由控制层*：由vue-router和全局路由守卫构成，负责多角色路由分发与访问控制。系统为四类角色设计了独立路由入口，路由守卫在每次导航前校验用户登录状态与角色权限，未登录用户重定向至登录页，角色不匹配则跳转至对应首页。这种前端路由鉴权机制与后端网关的路径级权限控制形成双重保障。

+ *状态管理层*：采用Pinia构建全局状态仓库，维护用户身份（userId）、认证令牌（token）和角色标识（roleCode）等核心状态。相比Vuex，Pinia提供更简洁的Composition API风格接口，天然支持TypeScript类型推导，且无需mutation同步约束，更适合多角色应用中跨组件共享登录态与权限信息的场景。

+ *通信服务层*：基于axios封装统一的API通信层，通过请求拦截器自动注入Authorization请求头，通过响应拦截器统一处理错误码与Token过期重定向。该层对上层业务组件屏蔽了HTTP通信细节，使得组件只需关注业务逻辑而非网络请求配置。

+ *部署接入层*：前端构建产物由Nginx托管为静态资源，所有/api/前缀请求通过Nginx反向代理统一转发至API网关，再由网关路由至各微服务。这种前后端分离的部署架构使前端可独立开发、独立部署，与后端微服务保持松耦合关系。

系统为四类角色设计了独立入口路径与权限边界，各角色页面结构如下表所示。

#tablex(
  [管理员], [/admin/home], [仪表盘概览、用户审核、中转站管理、末端调度预览、全国运力规划],
  [顾客], [/customer/home], [物流订单创建、订单查询、物流轨迹追踪],
  [商户], [/shop/home], [承运物管理、仓库管理、库存维护、待发货订单处理],
  [运输员], [/driver/home], [待处理任务列表、导航路线地图、配送状态更新、GPS位置上报],
  header: ([角色], [路由前缀], [核心页面]),
  columns: (1fr, 1.5fr, 3fr),
  caption: [多角色页面—路由—功能对照表],
  label-name: "role-route-table",
)

各角色的路由入口由路由守卫统一控制，实现了登录校验、角色匹配与未授权拦截三个层面的访问控制。这种设计确保了角色间的数据隔离与操作安全，同时避免了各角色页面在权限判断上的重复实现。

*关键交互设计方面*，前端的关键交互围绕四个核心场景展开：登录鉴权流程中，JWT Token持久化至localStorage并写入Pinia，axios拦截器自动附加认证头；订单流转交互中，前端调用订单创建接口后通过轮询获取履约进展，以时间线形式呈现各节点状态；运输员导航中，地图组件加载GeoJSON路线并结合Leaflet渲染，运输员端持续上报GPS坐标实现实时追踪；管理员调度预览中，K-Means聚类结果以不同颜色渲染于地图，全国网络页面渲染Hub-and-Spoke拓扑与MCMF运力分配。

== 数据库设计

前面的各服务设计中已展示了其数据表定义与接口设计，本节从全局视角对系统数据库进行统一梳理，首先给出系统E-R模型，然后对核心表进行集中说明。

=== 系统E-R模型

系统核心实体按业务域可划分为用户与角色域、商品与库存域、订单与履约域、调度域以及网络与规划域五大部分。考虑到全局 E-R 总图在 A4 页宽下难以同时兼顾信息完整性与版面美观，本文按业务域拆分为系统总览、订单履约细节和物流规划细节三类图进行说明。在用户与角色域，User 通过权限标识派生 Customer、Shop 与 Driver 三类业务身份，Customer 与 Address 构成一对多关系，用于描述寄件人与收货地址集合。在商品与库存域，Shop 与 Product 构成一对多经营关系，Product 与 Warehouse 通过库存关系形成多对多关联，以支撑同一承运物在多仓库中的分布式备货。@er-overview 展示了用户、发货方、仓库、运单、配送批次与运输员之间的主干关系，体现系统从角色、仓储到配送执行的整体数据结构。

#imagex(
  image("figures/er-overview.png", width: 100%),
  caption: [系统核心实体关系总览图],
  label-name: "er-overview",
)

在订单与履约域，物流订单作为核心聚合实体，关联用户、货主、收货地址、仓库、订单明细、配送批次、物流路线和配送任务等对象，承载从下单、入池、批次生成到配送任务落地的完整链路。@er-orderdetail 进一步展开订单履约相关实体关系，其中物流订单连接发起用户、承接货主、起点仓库与收货地址，调度池接收待调度订单并生成配送批次，配送批次再生成物流路线并关联配送任务，从而保证订单履约过程中的数据可追溯。

#imagex(
  image("figures/er-orderdetail.png", width: 100%),
  caption: [订单履约实体关系图],
  label-name: "er-orderdetail",
)

在调度与网络规划域，运力规划单、批次规划、物流订单、物流路线、运输员、轨迹点以及中转连接共同支撑跨城干线运输与末端配送协同。@er-logistics 展示了物流规划相关实体关系：批次规划包含多条物流订单与多条物流路线，物流路线由运输员执行并产生轨迹点；运力规划明细通过中转连接和中转枢纽描述网络中的运输能力分配，为Hub-and-Spoke履约链路和最小费用最大流运力规划提供数据基础。

#imagex(
  image("figures/er-logistics.png", width: 100%),
  caption: [物流规划实体关系图],
  label-name: "er-logistics",
)

上述三类 E-R 图分别从全局主干、订单履约和物流规划三个层面描述数据库结构。为便于精确查阅各实体间的基数约束，下表对核心实体关系进行集中汇总。

#tablex(
  [User], [1:1], [Customer], [一个用户对应一个顾客身份],
  [User], [1:1], [Shop], [一个用户对应一个商户身份],
  [User], [1:1], [Driver], [一个用户对应一个运输员身份],
  [Customer], [1:N], [Address], [一个顾客拥有多个地址],
  [Shop], [1:N], [Product], [一个商户拥有多个承运物],
  [Shop], [1:N], [Warehouse], [一个商户拥有多个仓库],
  [Product], [M:N], [Warehouse], [承运物-仓库多对多（库存表）],
  [OrderInfo], [N:1], [Customer], [多个订单属同一顾客],
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

系统核心表在前文各服务设计中已逐一给出字段定义，此处对跨模块关联最密切的核心表进行集中梳理：

+ user：统一用户表，通过permission字段区分四类角色，是认证与权限控制的基础。

+ order\_info：订单主表，关联顾客、商户、地址、仓库与中转站，承载订单全生命周期状态流转。

+ delivery：配送单表，关联订单与运输员，区分普通配送与末端配送。

+ logistics\_route：物流路线表，存储GeoJSON规划路线数据，区分普通/干线/末端三种段类型。

+ logistics\_batch：批次表，将末端配送订单按聚类结果分组，记录停靠顺序与配送状态。

+ hub / hub\_link：枢纽与运输连接表，构成全国干线网络拓扑，支撑MCMF运力规划。

+ dispatch\_pool：调度池表，维护待调度订单的入库与出池状态，是调度预览与执行的输入数据源。

其余辅助表（customer、shop、product、warehouse、product\_warehouse、address、driver、vehicle、flow\_plan等）的详细字段定义见前文各服务设计小节。

上述核心表的设计遵循了以下结构合理性原则：

+ *履约链路的数据完整性*：order\_info → delivery → logistics\_route → logistics\_batch 构成了从订单创建到末端配送的完整数据链，每张表通过外键关联上游实体，确保履约过程中各环节的数据可追溯。order\_info中的origin\_hub\_id与dest\_hub\_id字段将订单与Hub-and-Spoke中转网络直接绑定，使中转分配结果成为订单的持久化属性而非临时计算结果。

+ *状态机与一致性约束*：order\_info的order\_status（0-5）、delivery的delivery\_status（0-4）、logistics\_route的route\_status（-1到3）与logistics\_batch的batch\_status（0-4）均采用有限状态枚举，状态流转方向与业务规则一一对应，避免了非法状态的产生。logistics\_batch\_item的item\_status字段支持逐停靠点更新，使批次完成条件判定可精确到单订单粒度。

+ *调度与网络的数据基础*：dispatch\_pool作为调度预览与执行的输入数据源，通过end\_lat/end\_lng字段存储收货坐标，为K-Means空间聚类提供了直接的特征向量输入，无需回查订单或地址表。hub与hub\_link构成全国干线网络的图结构，hub\_link的capacity\_daily与base\_cost\_per\_unit字段直接对应MCMF算法中边的容量与费用参数，使算法输入与数据模型无缝衔接。

+ *多角色协同的数据隔离*：user 表通过 permission 字段统一区分四类角色，而非为每类角色建立独立用户表，避免了认证逻辑的冗余实现，角色切换与权限判断的查询效率也得以保证。各角色专属信息（shop\_info、driver\_info、customer地址等）以独立表与 user 主表关联，角色公共属性与专属属性由此分离。

== 本章小结

本章从需求分析、架构设计与数据库设计三个方面对系统进行了系统性说明。基于多角色业务需求明确了功能边界与非功能目标；围绕微服务架构给出了分层总体设计，并按认证服务、顾客服务、商店与库存服务、订单服务、运输员配送服务、物流规划服务与网关服务逐一阐述了各微服务的职责、数据模型与接口设计，同时从算法选型理由与整体流程两方面阐述了智能算法的设计方案，并给出了前端架构设计；最后从全局视角给出了E-R模型与核心表梳理。

= 系统实现

本章按认证鉴权→核心服务→智能算法→前端交互→容器化部署的顺序阐述各模块的实现策略与关键技术机制，重点阐述实现过程中的设计决策与技术难点，而非罗列代码细节。

== 微服务环境搭建

为了保证各微服务在开发、测试与部署阶段具备一致的运行环境，系统首先完成了统一的微服务开发环境搭建。后端采用Spring Boot 3、Spring Cloud 2022与Spring Cloud Alibaba构建微服务体系，前端采用Vue3 + Vite完成页面开发。在服务治理方面，系统使用Nacos作为注册中心，各服务统一配置注册地址并注册至公共命名空间。服务端口采用固定划分方式，网关与各业务服务各自占用独立端口，便于开发调试与容器编排时的端口映射。

在项目结构方面，系统采用Maven多模块结构组织各微服务，每个微服务拥有独立的pom.xml文件管理自身依赖，并通过父POM统一管理Spring Boot与Spring Cloud的版本号，避免各服务间的依赖冲突。数据库迁移采用SQL脚本文件方式管理，各服务的建表语句按服务维度独立维护在database目录下。

== 认证与网关服务实现

=== 认证服务（auth-service）

认证服务负责用户注册、登录鉴权与JWT签发，采用"认证服务签发 + 网关统一鉴权 + 下游透传消费"的三段式架构。注册时序为：前端提交注册请求 → auth-service校验用户名唯一性 → BCrypt加密密码 → 写入user表 → 若角色为商户/运输员则额外写入角色信息表（待审核状态）。登录时序为：前端提交登录请求 → BCrypt校验密码 → 检查审核与禁用状态 → 生成JWT（封装userId、username、roleCode）→ 返回Token。

系统根据角色类型实施差异化审核策略：普通顾客注册后可直接使用；商户与运输员需经管理员审核。该设计将"身份建立"与"访问控制"解耦至不同服务：注册与登录由认证服务独立处理，网关仅负责令牌校验与路径授权，下游服务通过请求头获取用户身份而无需重复解析JWT。

=== 网关服务（gateway-service）

网关服务基于Spring Cloud Gateway构建，负责请求路由、JWT校验与路径级权限控制。鉴权时序为：前端携带Token发起请求 → 网关过滤器拦截 → 检查白名单 → 验证JWT → 路径级权限判断 → 附加身份透传请求头（X-User-Id、X-Role-Code）→ 转发至下游服务。

路径权限规则与角色一一对应：/api/customers/仅允许顾客、/api/shops/与/api/stocks/仅允许商户、/api/drivers/仅允许运输员、/api/logistics/dispatch/仅允许管理员，形成了"白名单 + 令牌校验 + 路径授权"的组合机制。

== 核心业务服务实现

=== 顾客服务（customer-service）

顾客服务实现个人信息与地址管理功能。注册完成后，顾客可补充真实姓名、联系电话与邮箱等个人信息，并维护多个收货地址（含默认地址标识）。服务实现较为简洁，核心逻辑为对customer表与address表的CRUD操作，通过user\_id外键与认证服务的user表关联。

=== 订单服务（order-service）

订单服务是业务编排最复杂的服务，采用"同步校验 + 异步扣减 + 最终一致性"策略。首先通过Feign同步校验收货地址归属与承运物状态，在多个仓库中寻找库存充足的发货仓，创建订单主记录（初始状态order\_status=1待发货，payment\_status=1已支付）。订单落库后，通过RabbitMQ发送库存扣减消息异步执行实际扣减，若失败则进入死信队列待补偿；同时发送配送创建消息与调度入池消息，完成下单链路的闭环。

在下单链路中，系统需要解决的核心挑战是跨服务数据一致性。订单创建涉及顾客服务（地址校验）、商店服务（承运物与库存查询）、物流服务（中转站分配）等多个服务的协同。系统将需要即时反馈的校验逻辑（地址归属、承运物状态、库存充足性）放在同步链路中完成，确保用户能立即获知下单是否成功；而将可以延迟执行的副作用（库存扣减、配送创建、调度入池）放入异步消息，由消费者保证最终一致性。这种设计使用户下单响应时间保持在100-200ms范围内，不因下游消费速度而阻塞。

=== 商店与库存服务（shop-service）

商店与库存服务承担承运物管理、仓库管理、库存维护等职责。在仓库管理方面，系统集成了高德地图地理编码，新增或修改仓库时自动获取经纬度坐标；若调用失败则保留原有坐标而不中断主流程。在性能优化方面，仓库列表查询采用Spring Cache + Redis缓存机制，写操作及时清除缓存以保持一致性。

=== 运输员配送服务（driver-service）

运输员配送服务围绕配送单状态机组织业务流程：待接单(0)→已接单(1)→运输中(2)→已送达(3)，4=已取消为异常终止态。服务以消息消费机制承接两类配送任务：商户发货后的首段配送创建，以及干线到达中转站后的末端激活。当前版本中，全国干线配送任务由管理员统一调度，运输员端仅展示末端配送任务。服务对运输员首页的高频访问"进行中配送列表"进行了Redis缓存优化。

== 智能算法实现

=== 智能算法总体架构

本文的智能算法并非单一算法模块，而是围绕物流履约链路形成的多层决策体系。根据决策对象和时间尺度不同，系统将算法能力划分为三类：第一类是面向单条配送路线的路网路径规划，主要解决“从一个经纬度点到另一个经纬度点如何沿真实道路行驶”的问题；第二类是面向城市末端配送的订单聚类与批次生成，主要解决“一组目的地相近的订单应如何分组成可执行配送批次”的问题；第三类是面向全国干线网络的运力分配，主要解决“跨城市订单应如何在Hub网络上分配到不同运输边”的问题。三类算法分别作用于路线、批次和网络三个粒度，构成由微观路径到宏观运力的递进式智能调度框架。

围绕上述三类任务，系统采用“确定性优化算法为主、LLM辅助决策为辅”的设计原则。A\*、K-Means和MCMF负责产生可复现、可校验的路线、聚类和流量结果；大语言模型用于候选路线裁决、调度建议、费用倍率校准等辅助环节，其输出经过JSON解析、范围约束和降级处理。由此形成确定性算法计算与语言模型辅助解释相结合的实现方式。

本文涉及的主要算法层次如下。

#tablex(
  [路网路径规划], [A\* / Weighted A\*], [道路节点与道路边], [生成可在地图上渲染的GeoJSON路线],
  [路线智能裁决], [LLM Judge / LLM Waypoint], [A\*候选路线、历史速度与异常信息], [选择候选路线或给出方向性路点],
  [末端批次生成], [K-Means + 贪心TSP], [调度池订单目的地坐标], [生成末端配送批次与停靠顺序],
  [末端调度建议], [LLM调度顾问], [聚类结果、仓库/Hub位置、订单数量与距离估算], [给出批次合并、中转建议与调度说明],
  [全国运力规划], [MCMF / 多OD分配启发式], [Hub节点、干线边、OD需求], [生成边流量、跨城路径与干线批次],
  [运营参数修正], [LLM费用校准], [天气、链路负载、基准费用], [输出受限倍率并修正边费用],
  header: ([算法层次], [核心方法], [输入对象], [输出结果]),
  alignment: (left, left, left, left),
  columns: (1.1fr, 1.4fr, 1.8fr, 2.2fr),
  caption: [智能算法分层结构],
  label-name: "algorithm-layer-table",
)

由上述分层可以看出，系统将OSM路网、调度池订单、Hub网络和历史上下文分别映射到路径规划、末端聚类、干线规划和LLM辅助决策模块，最终输出地图路线、配送批次、干线规划单和可解释建议。路线、聚类和流量由确定性或启发式算法计算，LLM输出作为辅助信息进入候选裁决、费用校准和结果解释环节。

为便于后续说明，本文将上述问题抽象为如下符号模型。路网路径规划以道路图$G_r=(V_r,E_r)$为基础，其中$V_r$表示道路节点集合，$E_r$表示可通行道路边集合，每条边具有距离权重；一次路径规划输入为起点$s$与终点$t$的经纬度坐标，经过空间吸附后转换为路网节点。末端调度输入为订单集合$O={o_1,o_2,...,o_n}$，每个订单包含目的地坐标$"lat"_i,"lng"_i$；算法需要将订单划分为若干簇$C={C_1,C_2,...,C_k}$，并为每个簇生成可执行的停靠顺序。全国运力规划输入为Hub集合$H$、干线边集合$L$和OD需求集合$D$，每个需求$d=(h_o,h_d,q)$表示从起始Hub到目标Hub的订单量；算法需要在边容量约束下为需求分配低费用路径。

上述建模聚焦于路径、批次和干线运力三个核心对象。车辆时间窗、车辆容量、司机工时和动态交通预测等约束属于更复杂的车辆路径问题和运营优化问题，本文将其作为后续扩展方向；当前实现重点验证图搜索、聚类、网络流与大语言模型辅助决策在物流管理系统中的集成方式，并明确各算法的输入、输出和适用场景。

=== GraphHopper 路网集成

系统在物流服务中集成了 GraphHopper 作为底层路网引擎。GraphHopper 可加载 OpenStreetMap 地图数据并构建可查询的道路图结构，首次启动时需要对 OSM 数据进行建图，后续重启时可直接加载缓存，避免重复建图带来的启动延迟。系统配置了 OSM 数据路径、图缓存路径及路由策略等关键参数，使物流服务能够基于真实道路拓扑执行路径搜索。

从工程实现角度看，GraphHopper在本系统中承担“路网数据层”职责，为自实现的A\*算法提供道路拓扑、节点坐标与邻接边遍历能力。系统在GraphHopperConfig中读取graphhopper.osm-file、graphhopper.graph-cache和graphhopper.vehicle等配置项，调用setOSMFile指定上海市OSM路网数据，调用setGraphHopperLocation指定图缓存目录，并通过importOrLoad()完成“首次导入、后续加载缓存”的初始化过程。这样设计的意义在于：物流服务第一次启动时可以从PBF文件构建BaseGraph与LocationIndex，后续启动时直接复用graph-cache目录中的节点、边、几何信息与空间索引，避免每次运行都重复解析OSM文件。

系统使用GraphHopper底层图结构支持自主A\*搜索。具体而言，路径规划服务依赖三个关键API：第一，LocationIndex.findClosest将仓库、Hub或用户地址经纬度吸附到最近道路节点，解决业务坐标可能落在建筑、水域或非道路区域的问题；第二，BaseGraph.getNodeAccess读取路网节点的经纬度，用于计算启发函数并还原路径坐标；第三，BaseGraph.createEdgeExplorer遍历当前节点的邻接边，使A\*算法可以在真实道路图上扩展节点。由此，GraphHopper承担路网导入、空间索引和边遍历职责，而路径搜索策略、启发函数权重和候选路线生成逻辑由系统自行控制。

GraphHopper路网集成的关键配置与代码含义如下。

#tablex(
  [OSM 数据文件], [shanghai-260310.osm.pbf], [上海市道路网络PBF文件，覆盖系统测试订单与仓库坐标范围],
  [图缓存目录], [graph-cache], [首次导入后缓存节点、边、几何与空间索引，后续启动秒级加载],
  [空间吸附], [LocationIndex.findClosest], [将业务经纬度映射到最近路网节点，避免起终点脱离路网],
  [邻接边遍历], [EdgeExplorer], [为A\*算法提供当前节点可达邻接边与边距离],
  [权重模型], [custom + car_average_speed], [保留车辆通行属性与平均速度编码，作为底层路网可行性约束],
  header: ([项目], [代码/配置], [作用]),
  alignment: (left, left, left),
  columns: (1.1fr, 1.8fr, 2.7fr),
  caption: [GraphHopper 路网集成关键配置],
  label-name: "graphhopper-config-table",
  breakable: false,
)

=== A\* 路径规划实现

基于第三章的选型设计，系统实现了基于 A\* 算法的路径规划策略 @ref34。以下给出 A\* 路径规划的核心伪代码：

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

在标准A\*基础上，系统还实现了Weighted A\*机制，通过设置epsilon=1.0、1.8与3.5生成多条具有风格差异的候选路径。epsilon > 1时算法倾向于更激进地探索靠近目标的节点，可在较短时间内生成与标准A\*路线不同的替代方案，为后续LLM裁决提供多样化的候选输入。

加权A\*的三个epsilon取值用于生成不同启发强度下的路线候选：epsilon=1.0保持标准A\*的最短路性质，作为基准路线；epsilon=1.8提供中等启发松弛，用于在存在多条可行道路时形成与基准路线略有差异的候选；epsilon=3.5进一步放大启发函数，使搜索更倾向于靠近终点，从而为LLM裁决提供差异化候选路线。若三次搜索得到的路线距离差异小于1%，系统会将其视为重复路线并进行去重；当去重后只剩一条有效路线时，直接返回标准A\*结果。

路径规划与LLM决策模块的关键参数配置如下。

#tablex(
  [A\* 加权系数 ε], [1.0 / 1.8 / 3.5], [分别生成最短路径、次优绕行与远距高速三条候选路线],
  [A\* 启发函数 $h(n)$], [Haversine 球面距离], [满足可采纳性，保证 $ε=1.0$ 时最优],
  [LLM 模型], [DeepSeek API], [候选路线裁决与调度建议],
  [LLM 降级策略], [返回 $ε=1.0$ 路线], [调用失败或格式异常时保障可用性],
  [GraphHopper OSM 数据], [shanghai-260310.osm.pbf], [上海市道路网络，首次建图后缓存复用],
  header: ([参数], [取值/配置], [设计意图]),
  columns: (1.2fr, 1.5fr, 2.5fr),
  caption: [路径规划模块关键参数表],
  label-name: "route-params",
)

从算法性质看，当epsilon=1.0且边权均为非负距离时，A\*退化为标准A\*搜索；由于Haversine距离表示两个经纬度点之间的球面直线距离，而真实道路距离通常不小于直线距离，因此该启发函数可作为道路距离的下界估计。该条件下，算法在理论上能够保持最短路径搜索的正确性。实际代码中，路网边权来自GraphHopper道路边距离，均为非负值，符合A\*的基本前提。对于epsilon=1.8和epsilon=3.5的Weighted A\*，启发函数被放大，算法更偏向目标方向搜索，适用于候选路线构造。

在复杂度方面，若不考虑启发函数剪枝效果，A\*在二叉堆优先队列实现下的时间复杂度可表示为$O((|V_r|+|E_r|) log |V_r|)$，空间复杂度为$O(|V_r|)$。在城市道路网络中，完整路网节点规模较大，但路径查询通常只扩展起终点附近和通往目标方向的部分节点，因此实际搜索规模显著小于全图遍历。系统通过closedSet避免重复展开节点，通过PriorityQueue降低最小fScore节点选择成本，使路线查询能够满足交互式地图展示需要。

A\*路径规划的有效性主要受三类因素影响：一是起终点坐标是否能够吸附到路网节点；二是OSM数据是否覆盖业务坐标范围；三是平均速度估算是否与真实交通状态接近。针对第一类问题，系统在坐标无法匹配时返回错误结果，避免生成无意义路线；针对第二类问题，系统使用上海区域OSM数据作为运行范围，并在部署说明中明确数据覆盖范围；针对第三类问题，系统将40km/h作为基础估计速度，同时在LLM Judge中引入历史速度上下文进行修正。因此，路径规划模块的基础路线由A\*与GraphHopper路网生成，时间估计由基础速度与历史上下文共同修正。

=== LLM 路径决策实现

基于第三章的LLM裁判策略设计，系统在LlmJudgeRouteStrategy中实现了大语言模型辅助的路线裁决策略。该策略的核心定位不是让模型直接生成道路轨迹，而是在A\*算法已经生成候选路线后，由模型结合历史交通上下文完成受限选择。具体流程如下：

+ *候选路线生成*：分别以 epsilon=1.0、1.8、3.5 调用 A\* 算法，生成三条具有风格差异的候选路线（标准最短路线、次优绕行路线、远距高速路线）。

+ *上下文信息组装*：查询订单对应的出发时段、历史交通特征，将三条路线的距离、预计时间、途经道路类型等信息与上下文合并为结构化提示词。

+ *模型调用与结果解析*：调用 DeepSeek API，要求模型以 JSON 格式返回推荐路线编号与推荐理由。系统解析返回结果并选择对应路线。

+ *降级容错*：若 LLM 调用超时或返回格式异常，系统自动降级返回 epsilon=1.0 的标准 A\* 最优路线，确保路径规划功能始终可用。

系统还实现了LLM路点策略（LlmWaypointRouteStrategy），采用分层决策架构：LLM在战略层决定是否需要绕路路点（0-2个），A\*在战术层保证每段路线在真实路网上。战略层根据历史交通数据判断拥堵路段（速度比低于0.7时考虑绕路），由LLM输出路点经纬度坐标；战术层将路线拆分为多段分别调用A\*规划后拼接。路点坐标需通过地理校验（上海市区范围内，纬度30.6°\~31.9°，经度120.8°\~122.2°），防止LLM产生地理幻觉；LLM调用失败或路点无效时直接回退为标准A\*规划。

上述两种LLM路径策略体现了本文对大语言模型输出范围的约束。以LlmJudgeRouteStrategy为例，系统提示词说明候选路线由A\*算法规划且坐标不可修改，模型只能在候选1、候选2、候选3中选择，并返回严格JSON字段，包括selectedCandidate、reasoning、adjustedDurationMs、summary、warnings与confidenceLevel。其中selectedCandidate必须落在候选路线编号范围内，解析时若越界则裁剪到合法区间；若JSON解析失败、接口超时或返回格式异常，则回退到epsilon=1.0路线。该结构形成“确定性算法生成候选、语言模型辅助裁决、异常情况下规则降级”的组合方式。

LlmWaypointRouteStrategy采用分层处理方式：LLM给出0到2个中间路点，并且这些路点必须经过地理范围校验。系统将路线端点组织为“起点→路点1→路点2→终点”序列，每一段仍调用A\*算法在真实路网中规划，最后拼接各段GeoJSON坐标。若任一路点超出上海范围，系统直接过滤；若分段规划失败，则回退为直接A\*。因此，LLM在该策略中提供绕行方向建议，具体道路路径仍由A\*算法计算。

LLM路径决策的受限设计如下表所示。

#tablex(
  [路线生成], [A\*/Weighted A\*], [路线坐标来自真实路网，LLM不生成道路轨迹],
  [候选裁决], [LLM Judge], [在有限候选中选择，并给出理由与预计时间修正],
  [路点建议], [LLM Waypoint], [仅输出0-2个方向性路点，必须通过地理范围校验],
  [输出约束], [严格JSON], [便于后端解析字段并进行合法性校验],
  [失败处理], [回退A\*], [LLM不可用时不影响路径规划主流程],
  header: ([环节], [实现方式], [约束方式]),
  columns: (1fr, 1.4fr, 2.8fr),
  caption: [LLM路径策略的受限辅助设计],
  label-name: "llm-route-boundary-table",
)

从数据流看，业务坐标首先通过GraphHopper空间索引吸附到道路节点，再由不同epsilon参数的Weighted A\*生成候选路线。候选路线经过近似去重后，与历史速度、延误、慢速热点和异常路线统计共同组成LLM输入。LLM只需返回候选编号、理由和耗时修正等字段，最终结果仍是A\*路线坐标封装而成的GeoJSON。若模型调用失败、输出越界或JSON解析异常，则回退到epsilon=1.0的标准A\*结果。

为提高LLM输出的结构化程度，系统在提示词构建时将自然语言问题转化为结构化选择任务。RouteHistoryServiceImpl首先从历史数据中构造上下文：基于logistics\_track统计过去30天按小时聚合的平均速度，计算全天均速、当前小时均速和速度比；基于logistics\_route统计延误分钟数；以起终点中心附近约0.1度范围查询慢速热点；并统计起点附近近7天异常路线次数。上述信息不会直接改变A\*搜索结果，而是作为路线候选裁决时的参考特征，使模型能够区分高峰时段、慢速区域和异常路线模式。

LLM Judge的输入可以概括为“候选路线集合 + 历史上下文 + 输出格式约束”。候选路线集合由Weighted A\*生成，每条候选包含距离、预计时间和路线坐标摘要；历史上下文包含当前小时、星期、时段、均速、速度比、慢速热点和异常次数；输出格式约束要求模型返回严格JSON对象。系统解析后只读取固定字段，并对路线编号、预计时间等关键值进行合法性处理。这种设计将开放式文本生成转化为受限选择任务，降低了非结构化输出对系统的影响。

#tablex(
  [时间特征], [当前小时、星期、早晚高峰标识], [判断路线在不同时段的拥堵倾向],
  [速度特征], [全天均速、当前小时均速、速度比], [修正预计到达时间与候选路线偏好],
  [空间特征], [起终点中心附近慢速热点], [识别候选路线可能经过的低速区域],
  [异常特征], [起点附近近7天异常路线次数], [提示路线异常模式与运营稳定性],
  [输出约束], [selectedCandidate等JSON字段], [支持后端解析和失败回退],
  header: ([上下文类型], [代码来源/字段], [辅助决策作用]),
  columns: (1fr, 1.8fr, 2.2fr),
  caption: [LLM路线裁决上下文特征],
  label-name: "llm-route-context-table",
  breakable: false,
)

在上述上下文特征基础上，路径规划模块分别为路线裁决和战略路点建议构造提示词。LlmJudgeRouteStrategy的提示词强调候选路线由A\*生成且坐标不可修改，模型需要结合历史均速、延误、慢速热点和异常路线记录，返回候选序号、选择理由、修正后的预计时间及风险提示。@route-judge-prompt 给出了该提示词结构。

#algox(
  caption: [LlmJudge路线裁决提示词结构],
  label-name: "route-judge-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为物流路线优化助手；\
  #h(2em)任务限定为从多条A\*候选路线中选择最优方案；\
  #h(2em)决策优先级为准时率、路线稳定性和总距离；\
  #h(2em)要求严格返回JSON对象。\
  \
  UserPrompt:\
  #h(2em)输入起点、终点和计划出发时段；\
  #h(2em)for each route in candidates:\
  #h(4em)输入候选序号、路线距离、A\*基准时间和路网节点数；\
  #h(2em)输入当前时段历史均速、全天均速、速度比、平均延误；\
  #h(2em)输入慢速热点和近7天异常路线数量；\
  #h(2em)要求模型只返回候选路线序号，不生成新路线。\
  \
  ExpectedOutput:\
  #h(2em)selectedCandidate, reasoning, adjustedDurationMs, summary, warnings, confidenceLevel
]

LlmWaypointRouteStrategy的提示词用于判断是否存在绕行必要。模型根据起终点、直线距离、历史交通速度比、慢速热点和异常记录，返回直达或绕行策略以及0到2个战略路点。后端只采纳位于上海范围内的路点，并对各分段分别调用A\*，因此最终路线仍由真实路网算法生成。@route-waypoint-prompt 给出了该提示词结构。

#algox(
  caption: [LlmWaypoint战略路点提示词结构],
  label-name: "route-waypoint-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为物流路径策略顾问；\
  #h(2em)任务限定为判断是否插入中间路点，而非生成道路级路径；\
  #h(2em)当speedRatio明显偏低且存在慢速热点时，可建议1到2个战略路点；\
  #h(2em)当样本不足或绕行收益不明确时，优先返回直达策略；\
  #h(2em)要求严格返回JSON对象。\
  \
  UserPrompt:\
  #h(2em)输入起点、终点、直线距离和当前时段；\
  #h(2em)输入当前时段历史均速、全天均速、speedRatio和平均延误；\
  #h(2em)输入历史慢速热点、样本量和异常路线数量；\
  #h(2em)要求返回保守可执行的战略路点建议。\
  \
  ExpectedOutput:\
  #h(2em)strategy, reasoning, waypoints, expectedSpeedKmh, confidenceLevel, warnings, summary
]

综上，4.4.4小节中的LLM讨论限定在路径规划服务内部：模型只参与候选路线选择、方向性路点建议和路线选择理由说明，真实道路可达性、路线坐标生成与异常降级仍由A\*和GraphHopper路网能力保证。

=== K-Means 聚类调度预览

基于第三章的选型设计，系统实现了基于 K-Means 的调度预览能力 @ref39。该功能为管理员提供末端配送方案的可视化预览与决策辅助。以下给出 K-Means 聚类调度的核心伪代码：

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

代码层面，KMeansClusterServiceImpl首先对调度池订单进行过滤，只保留包含endLat与endLng坐标的订单。该处理保证聚类输入具有明确地理特征，也避免地址数据缺失导致距离计算异常。若调用方未指定$k$值或$k$值小于等于0，系统默认取$ceil(sqrt(n))$；随后将$k$限制在不超过有效订单数$n$的范围内，避免簇数大于样本数。

初始化阶段没有采用随机选点，而是按等间距索引从订单列表中抽取初始中心，使相同输入下聚类结果具有可复现性。E步中，系统对每个订单计算其到各聚类中心的Haversine球面距离，并分配到最近中心；M步中，系统对每个簇内订单经纬度做算术平均，生成新的中心点。由于当前调度场景主要限定在城市内或同一Hub服务范围内，使用经纬度算术平均作为中心近似在工程上可接受。若某一轮迭代中所有订单的簇分配均未变化，系统提前终止；否则最多迭代100次。聚类完成后，系统将每个非空簇封装为ClusterResultDTO，包含簇编号、中心坐标和订单列表，供管理员调度预览界面渲染。

K-Means嵌入到“调度池→预览→确认→批次执行”业务流程中。管理员调用调度预览接口时，DispatchController从dispatch\_pool中读取待调度订单，转换为DispatchPoolItemDTO后调用聚类服务；若没有显式传入仓库坐标，系统会从调度池条目的调度起点坐标中推断代表性起点。管理员确认后，执行调度接口根据聚类结果创建LogisticsBatch与对应路线，将算法输出转化为可分配给运输员的配送任务。

K-Means聚类结果与业务实体之间的关系如下。

#tablex(
  [dispatch\_pool], [输入], [保存待调度订单、目的地坐标与调度起点，为聚类提供样本点],
  [ClusterResultDTO], [算法中间结果], [保存簇编号、中心点和簇内订单列表，用于预览展示],
  [DispatchPreviewDTO], [接口返回], [聚合总订单数、建议批次数、聚类结果与后续调度建议],
  [logistics\_batch], [执行结果], [管理员确认后按簇生成配送批次，进入运输员任务流程],
  header: ([对象], [角色], [说明]),
  columns: (1.5fr, 1.2fr, 3fr),
  caption: [K-Means调度与业务实体映射],
  label-name: "kmeans-business-mapping",
)

在本文实现中，K-Means承担末端订单空间分组任务，车辆容量、时间窗、司机工时、装载顺序与多目标优化等约束暂未纳入聚类模型。系统先通过K-Means完成地理位置分组，再通过近似TSP贪心排序优化簇内停靠顺序，形成面向末端配送批次生成的启发式调度方案。该方案实现复杂度较低、结果易于可视化和解释，适合中小规模调度池场景；更复杂的容量约束和时间窗约束可在后续工作中结合VRP模型进一步扩展。

K-Means末端聚类调度的关键参数配置如下。

#tablex(
  [k 值], [管理员指定，未指定时默认$ceil(sqrt(n))$], [末端配送聚类簇数],
  [初始化策略], [均匀抽样], [按等间距索引选取初始中心，减少随机性、保证可复现],
  [收敛条件], [分配不变或迭代 ≥ 100 次], [保证聚类结果收敛],
  [距离度量], [Haversine 球面距离], [匹配地理空间实际距离],
  [簇内排序], [近似 TSP 贪心], [优化停靠顺序],
  [末端执行 k 值], [$ceil(N/4)$], [每名末端司机最多4个停靠点],
  [末端执行最大迭代], [50 次], [末端分组场景下减少计算开销],
  header: ([参数], [取值/配置], [设计意图]),
  columns: (1.2fr, 1.8fr, 2fr),
  caption: [K-Means调度模块关键参数表],
  label-name: "kmeans-params",
)

K-Means调度的时间复杂度主要由迭代次数、订单数和簇数决定。设有效订单数为$n$，簇数为$k$，最大迭代次数为$I$，则每轮迭代需要计算每个订单到每个簇中心的距离，时间复杂度约为$O(I*n*k)$；空间复杂度主要用于保存订单、簇分配和中心点，为$O(n+k)$。在系统默认策略中，若管理员未指定$k$，算法取$ceil(sqrt(n))$作为初始簇数，因此在中小规模末端调度场景下计算开销可控。

从调度效果看，K-Means适合解决“目的地空间聚集”问题。当订单目的地呈现多个明显区域时，聚类中心能够较好地代表每一组订单的服务范围，并为后续批次创建提供直观依据。当订单沿狭长道路带分布、存在河流高架等路网阻隔，或者订单数量过少时，仅基于经纬度距离的聚类可能与真实驾驶距离存在偏差。为缓解该问题，系统在簇内进一步使用近似TSP贪心排序生成停靠顺序，并在调度建议中引入Hub距离、订单数和里程估算作为补充判断。

=== LLM 末端调度辅助决策实现

在K-Means完成空间聚类之后，系统并不直接让大语言模型修改聚类结果，而是将模型定位为末端调度建议组件。K-Means负责根据收货坐标将调度池订单划分为若干配送簇，并通过贪心排序生成簇内停靠顺序；LLM介入的位置在聚类完成之后，主要解决“某一簇应直接配送，还是先进入Hub再做末端派送”这一管理判断。系统会为每个簇补充最近Hub、仓库到簇中心距离、Hub到簇中心距离和部分地址摘要，然后要求模型判断是否采用Hub-and-Spoke模式，并返回批次数、紧急程度、推荐Hub及说明。

末端调度提示词由三部分组成：第一部分设定模型角色为熟悉“仓库→中转站→客户”模式的物流调度专家；第二部分给出判断原则，例如远距离且订单集中时倾向Hub模式，近距离或订单极少时倾向直送；第三部分要求返回固定JSON字段，包括suggestedBatchCount、strategy、reason、estimatedSavingKm和batchSuggestions。@dispatch-llm-prompt 给出了该提示词在论文中的抽象表示。

#algox(
  caption: [末端调度LLM提示词结构],
  label-name: "dispatch-llm-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为熟悉Hub-and-Spoke模式的物流调度专家；\
  #h(2em)说明中转模式适用条件：目的地较远、订单集中、附近存在合适Hub；\
  #h(2em)说明直送模式适用条件：订单数量较少或目的地距仓库较近；\
  #h(2em)要求严格返回JSON对象，不输出额外解释。\
  \
  UserPrompt:\
  #h(2em)输入发货仓库坐标、总订单数和K-Means聚类批次数；\
  #h(2em)for each cluster in clusters:\
  #h(4em)输入clusterId、订单数、簇中心坐标和仓库到簇距离；\
  #h(4em)输入最近Hub名称、Hub地址、Hub到簇距离和目的地摘要；\
  #h(2em)要求返回整体策略、预计节省里程和每个簇的调度建议。\
  \
  ExpectedOutput:\
  #h(2em)suggestedBatchCount, strategy, reason, estimatedSavingKm, batchSuggestions
]

模型返回结果只作为管理员调度预览的辅助信息，不直接绕过人工确认。若LLM不可用，系统按规则降级：当仓库到目的地簇距离较远、订单数达到阈值且存在较近Hub时推荐Hub模式，否则推荐直送。系统还在调度池加载时使用LLM识别订单备注中的“急送、加急、今天必须到”等语义；该功能失败时仅返回空紧急列表，不影响普通订单调度。

在批次创建阶段，系统还调用LLM进行Hub选择。后端先选出距离订单群中心最近的若干候选Hub，再补充今日已处理批次数和历史交通状态。模型只能在候选Hub范围内返回selectedIndex和选择理由，不能生成新的Hub；若返回索引越界或调用失败，系统选择距离最近的Hub作为降级结果。

Hub选择提示词的核心约束是“只在候选集合内选择”，避免模型生成系统中不存在的中转站。后端为每个候选Hub补充三类信息：一是Hub到订单群中心的距离，二是该Hub当天已处理批次数，三是订单群中心到Hub方向的历史均速与拥堵状态。@hub-selection-prompt 给出了该提示词结构。

#algox(
  caption: [Hub选择LLM提示词结构],
  label-name: "hub-selection-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为物流调度专家；\
  #h(2em)要求从候选中转站中选择一个最优Hub；\
  #h(2em)综合考虑距离、今日负载和当前交通；\
  #h(2em)要求严格返回JSON对象，不输出额外解释。\
  \
  UserPrompt:\
  #h(2em)输入订单群中心坐标、订单数量和计划发车时间；\
  #h(2em)for each hub in candidateHubs:\
  #h(4em)输入候选序号、Hub名称、地址和距订单群中心距离；\
  #h(4em)输入今日已处理批次数和当前路段交通状态；\
  #h(2em)要求模型在候选序号范围内返回最优Hub。\
  \
  ExpectedOutput:\
  #h(2em)selectedIndex, selectedHubName, reason, confidenceLevel
]

=== MCMF 全国运力规划实现

基于第三章的MCMF选型与网络建模设计，系统引入最小费用最大流算法 @ref37 对全国干线运输运力分配进行全局优化。不同于城市末端调度只处理同一局部区域内的订单分组，全国运力规划需要在Hub-and-Spoke网络中同时考虑多个起点Hub、终点Hub、干线容量和单位运输费用。

MCMF规划由FlowPlanServiceImpl负责整体编排。系统首先从订单数据中统计指定日期的跨城OD需求，形成以(originHubId, destHubId)为键、订单数量为值的odDemands映射；然后读取启用状态的national\_hub与hub\_link记录，构建Hub节点集合与运输边集合。正式业务链路采用多商品MCMF方案：每个OD对作为一类独立运输需求，在共享残差容量网络中寻找低费用可行路径。求解结果同时包含干线边流量和OD路径，因此能够直接支撑后续inter\_city\_batch生成和订单路径绑定。

系统保留单商品SSP+SPFA实现用于兼容和理论对照，但该方案会将所有Hub的供给与需求聚合到一个总流问题中，容易在同一Hub既有发货需求又有收货需求时发生代数抵消。为保留订单方向和后续批次生成所需的路径信息，本文实现说明以多OD分配方案为主。MCMF求解的核心步骤如下：

#algox(
  caption: [多商品MCMF算法（Dijkstra-SSP）],
  label-name: "mcmf-algo",
)[
  function MultiCommodityMCMF(graph, odDemands):\
  #h(2em)residualCap ← capacity of each hub link\
  #h(2em)edgeFlow ← empty map; odRoutes ← empty list\
  #h(2em)totalFlow ← 0; totalCost ← 0\
  #h(2em)for each (origin, dest, demand) in odDemands:\
  #h(4em)remaining ← demand\
  #h(4em)while remaining > 0:\
  #h(6em)path ← Dijkstra(origin, dest, residualCap, edgeCost)\
  #h(6em)if path is null: break\
  #h(6em)flow ← min(remaining, bottleneck(path, residualCap))\
  #h(6em)for each edge in path:\
  #h(8em)residualCap[edge] ← residualCap[edge] - flow\
  #h(8em)edgeFlow[edge] ← edgeFlow[edge] + flow\
  #h(6em)odRoutes.add(origin, dest, path, flow)\
  #h(6em)totalFlow ← totalFlow + flow\
  #h(6em)totalCost ← totalCost + cost(path) × flow\
  #h(6em)remaining ← remaining - flow\
  #h(2em)return (edgeFlow, odRoutes, totalFlow, totalCost)
]

在多OD方案中，系统首先为所有hub\_link构建费用邻接表costAdj、剩余容量表resCap和边映射linkMap。随后按OD需求量降序处理各OD对，使高需求OD对优先占用容量。对每个OD对，系统只在剩余容量大于0的边上执行Dijkstra，找到从起始Hub到目标Hub的最低费用路径；路径瓶颈容量与剩余需求量的较小值作为本次分配流量，随后更新路径上各边的剩余容量并累计边流量。若某一OD对在容量耗尽后仍有未满足需求，系统记录警告并继续处理下一OD对。该方案牺牲了部分全局严格最优性，但能够避免单商品聚合导致的同Hub供需抵消问题，并保留每个OD对的具体Hub路径，便于后续生成跨城干线批次。

MCMF相关数据表与算法输入输出的对应关系如下。

#tablex(
  [national\_hub], [节点集合], [提供Hub编号、层级与启用状态，构成网络节点],
  [hub\_link], [边集合], [提供fromHub、toHub、transportMode、capacityDaily、baseCostPerUnit等边属性],
  [order\_info], [OD需求], [按originHubId与destHubId统计跨城订单需求量],
  [flow\_plan], [规划主表], [保存规划日期、算法名称、总需求、实际流量、总费用与可行性状态],
  [flow\_plan\_item], [边流明细], [保存每条HubLink分配流量、边费用与总费用，供前端地图展示],
  [inter\_city\_batch], [执行批次], [根据多OD路径生成干线运输批次，支撑后续运输执行],
  header: ([数据表], [算法角色], [作用]),
  columns: (1.4fr, 1.2fr, 3.2fr),
  caption: [MCMF算法与数据表映射关系],
  label-name: "mcmf-data-mapping",
)

MCMF求解完成后，系统将结果继续转化为可执行业务对象。FlowPlanServiceImpl将边流明细写入flow\_plan\_item表，并依据多OD结果中的OD路径创建inter\_city\_batch干线批次。对于一条包含多段HubLink的路径，系统会为每一跳创建或复用干线批次，初始状态为CHAINED；有实际订单绑定的第一跳会被激活为CREATED，后续跳保持预规划状态，等待中转到达后自动激活。这样，MCMF的输出既包含地图上的边流量，也进入真实订单的干线履约过程。

MCMF全国运力规划的关键参数配置如下。

#tablex(
  [商品定义], [OD 对], [每个起始Hub至目标Hub的需求独立建模],
  [容量共享], [残差容量图], [不同OD对共享hub\_link容量并逐次扣减],
  [边费用输入], [costPerUnit], [作为Dijkstra寻路权重，可由基准费用或校准后费用提供],
  [建模方案], [多商品MCMF], [保留OD路径，支撑干线批次生成与订单绑定],
  header: ([参数], [取值/配置], [设计意图]),
  columns: (1.2fr, 1.5fr, 2.5fr),
  caption: [MCMF运力规划模块关键参数表],
  label-name: "mcmf-params",
)

从数学建模角度看，多商品MCMF的目标是在满足共享容量约束和OD需求方向的前提下尽可能降低运输费用。设每条干线边$e$具有容量$u_e$和单位费用$c_e$，边上分配流量为$x_e$，则费用目标可表述为最小化$sum_e c_e x_e$。与单商品聚合相比，多OD方案除计算边流量和总费用外，还将OD路径作为重要输出。系统对每个OD需求记录经过的HubLink序列，随后将每条路径拆分为多个干线批次或批次跳段，并把订单绑定到对应首跳。这样，管理员在前端看到的边流量、后端保存的flow\_plan\_item和实际执行的inter\_city\_batch具有一致来源。

=== LLM 全国运力规划辅助决策实现

全国运力规划中的LLM调用分为两个阶段。第一阶段发生在MCMF求解前，用于干线边费用倍率校准。系统将活跃HubLink、基准运输费用、天气信息和历史负载摘要输入模型，要求模型为每条边输出multiplier。后端将边费用更新为“基准费用 × multiplier”后再执行多商品MCMF求解。为了避免模型输出破坏网络流约束，系统只接受已有linkId的倍率，且将倍率限制在$[0.7, 2.0]$区间内；若某条边缺失或模型调用失败，则该边使用倍率1.0。

费用校准提示词的核心要求包括：模型身份为物流调度助手；任务仅限于为每条干线链路输出费用倍率；倍率含义限定为对基准费用的上调或下调；输出必须覆盖全部linkId，并严格返回calibrations数组。@mcmf-calibration-prompt 给出了该提示词结构。

#algox(
  caption: [MCMF费用校准LLM提示词结构],
  label-name: "mcmf-calibration-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为物流调度助手；\
  #h(2em)任务限定为：为每条干线链路输出费用倍率multiplier；\
  #h(2em)定义实际费用 = 基准费用 × multiplier；\
  #h(2em)约束multiplier取值范围为$[0.7, 2.0]$；\
  #h(2em)要求输出覆盖全部linkId的calibrations数组。\
  \
  UserPrompt:\
  #h(2em)输入决策日期、天气信息和历史边流量摘要；\
  #h(2em)for each link in hubLinks:\
  #h(4em)输入linkId、起点Hub、终点Hub、运输方式和基准费用；\
  #h(2em)要求模型为每条链路返回费用倍率和简短原因。\
  \
  ExpectedOutput:\
  #h(2em)calibrations = [(linkId, multiplier, reason), ...]
]

第二阶段发生在MCMF求解后，用于运营解读。此时流量分配、总成本和各边负载率已由算法确定，LLM只负责将这些数字转化为管理者可读的瓶颈分析、成本异常提示和调整建议。提示词中特别强调"数字已由算法算好"，要求模型不要重新求解网络流，而是从枢纽集中度、走廊压力、成本结构和次日需求波动风险等角度进行解释。结果字段包括bottleneckAnalysis、costAnomalyWarning、suggestions和summary，最终持久化到flow\_plan.llm\_advice并展示给管理员。

#algox(
  caption: [MCMF结果解读LLM提示词结构],
  label-name: "mcmf-advice-prompt",
)[
  SystemPrompt:\
  #h(2em)设定角色为全国干线网络运营顾问；\
  #h(2em)强调输入数字已由MCMF算法求得，模型不得重新求解网络流；\
  #h(2em)要求从瓶颈走廊、枢纽集中度、成本异常和潜在风险角度解读；\
  #h(2em)要求返回JSON对象，用于管理员端展示。\
  \
  UserPrompt:\
  #h(2em)输入总流量、总成本、有流量边数量和最高负载率；\
  #h(2em)for each item in flowPlanItems:\
  #h(4em)输入起止Hub、流量、容量、负载率、边成本和成本占比；\
  #h(2em)要求生成瓶颈分析、成本异常提示、建议列表和管理摘要。\
  \
  ExpectedOutput:\
  #h(2em)bottleneckAnalysis, costAnomalyWarning, suggestions, summary
]

=== Hub-and-Spoke 完整配送流程

基于上述算法与服务能力，系统形成了完整的Hub-and-Spoke配送闭环@ref36。该流程涉及订单服务、物流服务与运输员配送服务三个核心服务的跨服务协作，以下按时间顺序描述完整时序：

+ *步骤一：下单与中转站分配*。顾客下单后，订单服务同步创建订单记录，并通过Feign调用物流服务的/routing/assign-hubs接口，为订单分配起始中转站（距发货仓库最近）与目标中转站（距收货地址最近），分配结果写入order\_info的origin\_hub\_id与dest\_hub\_id字段。

+ *步骤二：调度入池与待规划*。订单服务通过RabbitMQ发送调度入池消息，物流服务消费后将订单写入dispatch\_pool，标记为待调度（status=0）。对于跨城订单，该记录首先作为干线待处理数据参与后续全国运力规划，而不是直接进入末端K-Means调度。

+ *步骤三：全国运力规划*。管理员触发MCMF全国规划接口后，物流服务读取跨城待处理订单和HubLink网络，按OD对计算共享容量约束下的干线路径与边流量分配方案，生成FlowPlan、FlowPlanItem以及对应的inter\_city\_batch干线批次。

+ *步骤四：干线运输与到达入池*。管理员在全国干线页面对干线批次执行发车与到达操作。批次到达目标Hub后，物流服务将最终目的地属于该Hub的订单重新写入或激活为城市末端调度池数据；若订单仍需中转，则根据规划路径自动衔接下一跳批次。

+ *步骤五：末端调度预览与批次执行*。当订单进入目标Hub的城市末端调度池后，管理员调用previewDispatch触发K-Means聚类预览，确认后调用executeDispatch执行末端调度，创建LogisticsBatch、批次明细和对应末端路线。

+ *步骤六：末端任务激活与配送*。末端路线满足执行条件后，物流服务发送末端激活消息，运输员服务消费消息并创建末端配送单。末端运输员确认承接任务后按多停靠点路线逐单配送，每次送达后更新logistics\_batch\_item的item\_status。

+ *步骤七：批次完成*。当批次内全部配送项状态均为已送达时，系统将批次更新为已完成（batch\_status=4）。

该流程覆盖从下单、分配中转站、全国运力规划、干线运输、到达入池、末端聚类调度、末端派送直至批次完成的完整履约链路，体现了"中心枢纽 + 辐射末端"物流模式在微服务架构下的工程化落地能力。

== 前端实现

前端采用Vue3 + Vite构建多角色单页应用，核心技术支撑为vue-router、Pinia、Element Plus、Axios和Leaflet。前端实现的重点不是简单堆叠页面，而是围绕四类角色建立独立路由域、统一认证状态、统一接口封装和地图可视化组件，使顾客、商户、运输员和管理员能够在同一前端工程中访问各自业务视图。

在项目入口方面，main.ts负责创建Vue应用实例，注册Pinia、Vue Router与Element Plus，并引入中文语言包以统一分页、日期选择器等组件的显示方式。Vite配置中使用\@作为src目录别名，降低跨目录组件引用的复杂度；开发环境下通过Vite proxy将/api请求转发至网关服务http://localhost:8090，使前端开发服务器与后端网关之间保持统一接口前缀。生产环境下该代理能力由Nginx反向代理接管，保证开发与部署阶段的请求路径一致。

前端主要文件与职责对应关系如下表所示。

#tablex(
  [src/router/index.ts], [路由配置与全局守卫], [划分/admin、/customer、/shop、/driver四个路由域，并根据角色控制页面访问],
  [src/stores/userStore.ts], [登录状态管理], [保存Token、用户编号、用户名与角色信息，并通过localStorage支持刷新后恢复],
  [src/utils/request.ts], [HTTP请求封装], [统一Axios实例、自动注入Authorization请求头、集中处理401与业务错误码],
  [src/components/RouteMap.vue], [路线地图组件], [渲染GeoJSON路线、起终点标记、实时轨迹和车辆当前位置],
  [src/components/NationalNetworkMap.vue], [全国网络可视化], [展示Hub节点、HubLink线路和MCMF运力规划结果],
  [src/pages/Admin/\*], [管理员页面组], [承载用户审核、订单管理、仓库管理、Hub管理、调度预览与全国运力规划],
  [src/pages/Customer/\*], [顾客页面组], [承载商品浏览、寄件下单、订单查看和物流追踪],
  [src/pages/Shop/\*], [商户页面组], [承载商品、仓库、库存和订单发货管理],
  [src/pages/Driver/\*], [运输员页面组], [承载配送任务、车辆信息、导航和GPS上报],
  header: ([文件/目录], [实现职责], [说明]),
  alignment: (left, left, left),
  columns: (1.9fr, 1.1fr, 2.5fr),
  caption: [前端关键文件与职责表],
  label-name: "frontend-file-role-table",
)

在路由控制方面，系统通过createRouter和createWebHistory创建前端路由，并在路由元信息中设置meta.role字段。登录页和注册页作为公共入口，不要求用户已登录；四类角色登录后分别进入/admin/home、/customer/home、/shop/home和/driver/home四个首页。全局前置守卫在每次跳转前读取Pinia中的Token与角色标识：若用户未登录，则重定向至登录页；若用户已登录但访问其他角色页面，则重定向至自身角色首页。该机制在前端层面阻止了明显的角色页面误访问，并与网关层路径权限控制形成前后端双重校验。

在状态管理方面，系统使用Pinia维护token与userInfo两个核心状态。用户登录成功后，前端调用setUser方法将Token与用户信息写入Pinia，并同步保存至localStorage；页面刷新时，store初始化阶段从localStorage恢复登录状态，从而避免刷新后丢失用户身份。用户退出登录或后端返回401未授权时，前端调用logout清空本地状态并跳转登录页。与传统Vuex相比，Pinia的状态与动作定义更简洁，适合本系统按认证状态、页面状态和业务数据逐步拆分前端模块。

在接口通信方面，系统将所有HTTP请求统一封装在request.ts中，Axios实例的baseURL设置为/api。请求拦截器从Pinia读取Token并写入Authorization: Bearer \<token\>请求头，使各业务API文件无需重复处理认证信息；响应拦截器统一检查后端返回的业务码，非200结果通过Element Plus消息组件提示用户。若响应状态为401，则说明认证失效或Token过期，前端会清空登录状态并跳转登录页。由此，认证失败、业务错误与网络异常均有统一处理入口，降低了各页面重复编写错误处理逻辑的成本。

前端地图可视化是系统区别于普通管理页面的重要部分。路径规划算法输出GeoJSON格式路线后，前端可直接通过Leaflet解析并叠加到地图上；订单追踪页面同时展示发货仓库、收货地址、预计路线、已行驶轨迹和运输员当前位置，使用户能够理解订单当前所处阶段。运输员导航页面则围绕当前配送任务展示路径与GPS上报入口。管理员页面在城市内调度预览中渲染K-Means聚类结果，在全国网络页面中展示Hub-and-Spoke拓扑、MCMF边流量与线路状态。通过上述组件复用，算法输出不再停留在后端日志或数据库记录中，而是转化为可交互、可观察的业务界面。

在页面组织方面，系统按照角色拆分页面目录，并通过公共组件复用降低重复开发量。顾客端侧重寄件与追踪，商户端侧重商品、仓库和库存，运输员端侧重任务执行与轨迹上报，管理员端侧重审核、调度和网络规划。每个角色页面只暴露与该角色相关的导航入口，避免不同业务流程在同一界面中混杂。该组织方式与后端微服务的职责划分相互对应，使前端路由域、后端接口路径和用户角色权限保持一致。

== 容器化部署实现

系统采用Docker Compose实现容器化集成部署，目标是将数据库、中间件、后端微服务、网关和前端静态资源统一编排，降低本地复现和综合测试的环境成本。整体部署结构分为基础设施层、后端微服务层、网关层和前端层。基础设施层包含MySQL、Redis、RabbitMQ和Nacos；后端微服务层包含auth-service、user-service、customer-service、shop-service、order-service、driver-service和logistics-service；网关层由gateway-service统一暴露API入口；前端层由Nginx容器托管Vue构建产物并反向代理/api请求。

Docker Compose中定义了独立的transport-net桥接网络，各容器通过服务名完成内部通信。例如后端服务访问MySQL时使用mysql:3306，访问Redis时使用redis:6379，访问RabbitMQ时使用rabbitmq:5672，注册中心地址配置为nacos:8848。这种方式避免了在容器内部硬编码宿主机IP，也使服务迁移到其他主机时只需保持Compose网络与环境变量一致。

系统容器化部署的主要组件如下表所示。

#tablex(
  [MySQL], [transport-mysql], [3307:3306], [保存系统业务数据，启动时加载database/all.sql等初始化脚本],
  [Redis], [transport-redis], [6379:6379], [缓存仓库、商品、配送与路线等高频读数据],
  [RabbitMQ], [transport-rabbitmq], [5672:5672, 15672:15672], [支撑库存扣减、配送创建、调度入池等异步消息],
  [Nacos], [transport-nacos], [8848:8848, 9848:9848], [提供服务注册与发现能力],
  [业务微服务], [transport-auth等], [8081-8087], [承载认证、用户、顾客、商户、订单、运输员和物流规划逻辑],
  [Gateway], [transport-gateway], [8090:8090], [统一API入口，完成鉴权、路由与跨域处理],
  [Frontend], [transport-frontend], [80:80], [托管Vue静态资源，并将/api代理到gateway-service],
  header: ([组件], [容器名称], [端口映射], [部署作用]),
  alignment: (left, left, left, left),
  columns: (0.8fr, 1.4fr, 1.3fr, 3fr),
  caption: [Docker Compose部署组件表],
  label-name: "docker-compose-components",
)

在镜像构建方面，后端各微服务均采用多阶段Dockerfile。第一阶段使用maven:3.9-eclipse-temurin-17作为构建镜像，复制父POM、common模块、各子模块POM和当前服务源码，通过mvn package -pl \<service\> -am -DskipTests构建目标服务及其依赖模块；第二阶段使用eclipse-temurin:17-jre作为运行镜像，仅复制构建完成的jar包并通过java -jar app.jar启动。该方式将Maven构建环境与最终运行环境分离，减小运行镜像体积，也避免在生产运行容器中保留完整源码和构建缓存。

物流服务容器还需要处理路径规划所需的路网数据。Compose文件将shanghai-260310.osm.pbf以只读方式挂载到/app/shanghai-260310.osm.pbf，同时将graph-cache目录挂载到/app/graph-cache。GraphHopper首次加载OSM数据后会生成路网缓存，后续启动可直接读取缓存，减少每次容器启动时重新解析路网的耗时。由于路径规划模块依赖该数据卷，物流服务的部署不仅包含普通Java应用启动，还包含对外部地理数据与缓存目录的挂载配置。

在服务启动顺序方面，Compose通过depends_on与healthcheck组合控制基础设施与业务服务之间的依赖关系。MySQL通过mysqladmin ping检测可用性，Redis通过redis-cli ping检测可用性，RabbitMQ通过rabbitmq-diagnostics ping检测可用性，Nacos通过健康接口检测可用性。业务服务在对应基础设施健康后再启动，并通过环境变量注入数据库连接、Nacos地址、Redis地址和RabbitMQ地址。该设计比单纯依赖容器创建顺序更稳健，因为它关注服务是否真正可用，而不仅是进程是否已经启动。

前端容器采用Node构建与Nginx运行的两阶段镜像。构建阶段使用node:20.19-alpine执行npm ci和npm run build，生成Vite静态资源；运行阶段使用nginx:1.27-alpine托管dist目录。Nginx配置中通过try_files \$uri \$uri/ /index.html支持Vue Router history模式，使用户直接访问/admin/home等前端路由时仍能回退到单页应用入口；同时将/api/路径反向代理到http://gateway-service:8090，使浏览器访问前端容器时无需知道后端各服务的实际地址。

从部署结果看，Docker Compose将原本需要手动启动的多个组件统一为一个可复现的运行环境。开发阶段可以通过Vite代理直接联调网关，集成测试阶段则通过Nginx容器模拟生产访问路径。当前部署方式仍属于单机集成部署，适合系统演示、功能测试和性能初步验证；若后续需要面向更大并发规模，可进一步迁移到Kubernetes，通过Deployment、Service、ConfigMap、Secret和Ingress等资源实现多实例伸缩、配置隔离和统一入口治理。

== 本章小结

本章围绕系统实现过程，依次介绍了微服务环境与工程结构搭建、认证与网关服务实现、核心业务服务实现、智能算法实现、前端实现以及容器化部署实现。通过上述实现工作，系统完成了从架构设计到工程落地的闭环，为下一章的测试与运行结果分析提供了可执行基础。



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

+ *注册登录链路*：顾客用户、商户与运输员分别完成注册与登录，验证角色权限分配与 JWT 令牌签发的正确性。测试确认商户与运输员注册后初始状态为待审核，登录时返回对应提示；普通顾客注册后可直接登录。

+ *下单—扣库存—创建配送链路*：顾客下单后，系统自动完成地址校验、承运物状态检查、库存查询与发货仓选择、订单创建、库存异步扣减与配送单创建。测试确认订单创建后 order\_status 初始值为 1（待发货）、payment\_status 为 1（已支付），异步扣减成功后库存数量与订单金额一致，配送单状态正确初始化。

+ *中转站分配—调度入池链路*：订单创建后，系统调用 logistics-service 为订单分配起始与目标中转站，并将订单写入调度池。测试确认中转站分配结果与订单收发货地址匹配，调度池状态更新为待调度。

+ *K-Means 调度预览—批次执行链路*：管理员触发调度预览后，系统对调度池中的订单执行 K-Means 聚类与 TSP 排序，生成配送批次方案；确认后执行调度，创建LogisticsBatch与对应路线。测试验证批次内订单的聚类一致性与停靠顺序合理性。

+ *Hub-and-Spoke 全流程链路*：从干线运输员接单、运输、抵达中转站触发末端激活，到末端运输员接单并逐单配送直至批次完成。测试验证干线路线与末端路线的状态流转正确，末端激活消息触达运输员服务，批次完成条件判定准确。

上述功能测试结果表明，系统核心业务链路运行正确，各服务间基于 OpenFeign 同步调用与 RabbitMQ 异步消息的协同逻辑符合设计预期。

== 性能测试与结果分析

=== 测试环境

本节性能测试均在单机 Docker Compose 部署环境下进行，各微服务、MySQL、Redis 与 RabbitMQ 均运行于同一主机（macOS ARM64, M 系列芯片, 16GB 内存）。数据库中仓库记录约 8 条、商品约 20 条、订单约 30 条，属于开发验证阶段的小规模数据集。JVM 在首次请求前已完成类加载与 JIT 预热。需指出的是，由于数据库与 Redis 部署在同一主机，网络延迟极低（< 1ms），冷请求的数据库查询耗时较短；在生产环境中数据库通常独立部署，网络延迟与查询开销更大，缓存提速效果将更为显著。

=== 缓存优化效果验证

本测试旨在评估 Redis 缓存对高频读接口的性能提升效果，选取仓库列表查询接口（GET /api/warehouses）作为测试对象。测试前通过 redis-cli DEL 命令清除对应缓存键，确保每次冷请求均为真正的缓存未命中；缓存命中测试则在前序请求已填充缓存后连续发送，保证所有请求均为命中状态。两种状态各发送 50 次请求，记录每次响应时间。

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

由@cache-data 与@cache-comparison 可知，缓存未命中时平均响应时间为 31.2ms，P95 达 89.4ms（含数据库查询、对象关系映射、网络开销与 Spring Cache 注入延迟）；缓存命中后平均响应时间降至 6.0ms，P95 降至 11.5ms，性能提升约 5.2 倍。冷请求耗时主要消耗在数据库查询与结果集映射上，而缓存命中后仅需从 Redis 读取已序列化的 Java 对象并反序列化，省去了 SQL 解析、磁盘 I/O 与 ORM 映射开销。上述结果表明，基于 Redis 的 Cache-Aside 缓存策略对仓库等高频访问数据具有显著的加速效果，有效减轻了数据库的读取压力。需要指出的是，本次测试在单机环境下进行，数据库与 Redis 部署于同一主机，冷请求的网络延迟极低；在生产环境中数据库通常独立部署，冷请求的数据库查询耗时将更长，缓存提速效果将更为显著。此外，缓存命中率受数据量与过期策略影响，在多实例部署场景下还需验证缓存一致性机制的有效性。

=== 路径规划接口压力测试

路径规划接口涉及 GraphHopper 路网查询与 A\* 搜索，是系统中计算密集度最高的接口之一。本测试旨在评估该接口在不同并发水平下的响应能力，使用 Apache Bench (ab) 向物流路线规划接口（POST /api/logistics/route/plan）分别在 1、5、10、20 并发水平下各发起 5 组请求（总请求数为并发数 × 5），记录各并发水平下的平均响应时间与吞吐量。需要说明的是，ab 报告的平均响应时间为"总耗时 / 总请求数"，在并发请求并行执行时，该值反映的是并行处理效率而非单请求真实耗时，因此并发度越高，ab 报告的平均值越低属正常现象，不代表服务端单请求处理速度提升。

#tablex(
  [1], [5], [276.1], [3.6], [0],
  [5], [25], [32.2], [155.2], [0],
  [10], [50], [48.6], [205.9], [0],
  [20], [100], [72.1], [277.5], [0],
  header: ([并发数], [总请求数], [平均RT (ms)\*], [TPS (req/s)], [失败数]),
  columns: (1fr, 1fr, 1.2fr, 1.2fr, 0.8fr),
  caption: [路径规划接口不同并发下压力测试结果],
  label-name: "routing-data",
)

#imagex(
  image("figures/routing-benchmark.png", width: 80%),
  caption: [路径规划接口压力测试统计图],
  label-name: "routing-benchmark",
)

由@routing-data 与@routing-benchmark 可知，单并发下单次请求平均耗时 276ms，反映了路径规划的真实计算开销（包含 GraphHopper 路网加载、A\* 搜索与路线坐标序列化）；5 并发时 ab 报告的平均 RT 为 32ms，这是由于 ab 统计口径为\u201c总耗时 / 总请求数\u201d，多个请求在服务端并行执行所致，不代表单请求处理速度提升；20 并发下平均 RT 为 72ms，TPS 达到 277.5，全部请求成功。上述结果表明，路径规划接口在单并发下单次请求耗时约 276ms，主要受限于 CPU 密集型计算；在并发场景下，Spring Boot 内置线程池能够并行处理请求，吞吐量随并发数增长而提升。需要指出的是，本次测试基于单实例 logistics-service，20 并发下的排队延迟已开始显现，在生产环境中可通过水平扩展实例数来提升并发处理能力。

=== 并发下单与异步削峰验证

本测试旨在验证 RabbitMQ 异步消息机制在高并发场景下的削峰效果，使用 Apache Bench 以 10 并发对订单列表查询接口发起 50 次请求，同时模拟下单接口的并发访问压力，观察主流程响应时间与异步消费完成情况。

#tablex(
  [订单列表查询], [10], [50], [14.6], [685.3], [0],
  header: ([测试接口], [并发数], [总请求数], [平均RT (ms)], [TPS (req/s)], [失败数]),
  columns: (1.5fr, 0.8fr, 1fr, 1.2fr, 1.2fr, 0.8fr),
  caption: [订单接口并发测试结果],
  label-name: "order-concurrent-data",
)

由@order-concurrent-data 可知，10 并发下订单查询接口平均响应时间为 14.6ms，TPS 达 685.3，全部请求成功。下单接口本身仅同步完成订单主记录与明细写入，库存扣减与配送创建通过 MQ 异步执行，下单接口平均响应时间保持在 100–200ms 范围内，未因下游消费速度而阻塞。上述结果表明，RabbitMQ 异步消息机制有效实现了下单请求的削峰填谷，将耗时操作（库存扣减、配送创建）从同步链路中解耦，保证了主流程的响应速度。需要指出的是，异步消费者的处理速度依赖下游服务的可用性，若消费端出现积压，需通过死信队列与补偿任务保障最终一致性。

=== 性能测试结论

综合上述测试结果，本文得出以下结论：第一，Redis 缓存对高频读接口具有显著的性能提升作用，缓存命中后平均响应时间从 31.2ms 降至 6.0ms，性能提升约 5.2 倍，且在生产环境中数据库独立部署时提速效果将更为显著；第二，路径规划接口受限于 CPU 计算资源，单并发下单次请求耗时约 276ms，20 并发下 TPS 达 277.5 但排队延迟开始显现，高并发需通过水平扩展解决；第三，RabbitMQ 异步消息机制有效实现了下单请求的削峰填谷，订单查询接口在 10 并发下 TPS 达 685.3，保证了主流程的响应速度。总体而言，系统在当前单机部署条件下能够满足中小规模业务场景的性能需求。

== 多角色运行结果展示

为验证系统各角色的交互效果，本节按顾客、商户、运输员与管理员四个角色分别展示关键功能页面的运行截图。每张截图均以独立图注呈现，便于结合正文说明理解各角色的核心操作流程。

=== 顾客端运行结果

顾客端覆盖物流订单创建与订单追踪等核心功能。@create-order-pickup 展示了创建物流订单页面，顾客可选择承运物、填写数量、选择收件地址并补充订单备注，提交后生成物流订单；后续由商户仓库出库发货，系统再完成中转分配、路径规划与配送调度等履约流程。

#imagex(
  image("figures/create-order-pickup.png", width: 105%),
  caption: [顾客创建物流订单页面],
  label-name: "create-order-pickup",
)

订单生成后，用户可在订单详情中查看全程物流路线与阶段性履约节点。@customer-order-track-map 展示了订单追踪地图，系统在同一地图中叠加已走路径、预计路线、中转站与当前车辆位置；@customer-order-track-timeline 展示了物流节点时间线，可区分跨城干线运输、城市内转运和末端配送等环节，从而帮助用户理解订单当前所处的履约阶段。

#imagex(
  image("figures/customer_order_detail_1.png", width: 80%),
  caption: [顾客订单追踪地图],
  label-name: "customer-order-track-map",
)

#imagex(
  image("figures/customer_order_detail_2.png", width: 80%),
  caption: [顾客物流节点时间线],
  label-name: "customer-order-track-timeline",
)

=== 商户端运行结果

商户端承担承运物管理、仓库管理与库存维护等业务，是连接发货需求与物流履约的关键环节。@shop-products 展示了商户承运物管理页面，支持新增、编辑与上下架操作，承运物状态实时同步至订单创建时的可选列表；商户亦可在仓库管理模块维护仓库地址信息，系统自动调用地理编码服务获取经纬度坐标，并支持按仓库维度查看与调整库存数量。

#imagex(
  image("figures/shop-products.png", width: 80%),
  caption: [商户承运物管理页面],
  label-name: "shop-products",
)

@warehouse-inventory 展示了商户库存管理页面，以可展开表格形式呈现各承运物的总库存及各仓库明细，支持按名称/编码搜索与一键刷新，便于商户实时掌握多仓库存动态。

#imagex(
  image("figures/warehouse-inventory.png", width: 80%),
  caption: [商户库存管理页面],
  label-name: "warehouse-inventory",
)

=== 运输员端运行结果

运输员端是物流计划落地执行的直接承载端，用于接收配送任务、执行导航与上报送达状态。@driver-preassigned-missions 展示了管理员已生成但尚未到达执行条件的预调度任务，干线任务到达分拨中心后会自动转入运输员的我的任务列表。@driver-active-missions 展示了运输员当前任务，系统区分干线运输、末端配送与已送达记录，并提供开始运输、到达中转站等状态操作。

#imagex(
  image("figures/driver_mission_2.png", width: 85%),
  caption: [运输员预调度任务列表],
  label-name: "driver-preassigned-missions",
)

#imagex(
  image("figures/driver_mission_1.png", width: 85%),
  caption: [运输员当前任务列表],
  label-name: "driver-active-missions",
)

接单后，系统基于 GraphHopper 真实路网规划配送路线，在地图页面上渲染途经停靠点与实时位置，运输员按停靠顺序逐单配送并上报送达状态。@driver-route-guide 展示了路线指引页面，运输员可查看物流单号、路线状态、出发地与预计到达时间；@driver-last-mile-confirm 展示了末端多停靠点配送确认页面，只有逐站完成确认后，末端配送单才会进入完成状态。

#imagex(
  image("figures/driver_guide.png", width: 90%),
  caption: [运输员配送路线指引页面],
  label-name: "driver-route-guide",
)

#imagex(
  image("figures/driver_last_mission_confirm.png", width: 70%),
  caption: [末端配送多停靠点确认页面],
  label-name: "driver-last-mile-confirm",
)

=== 管理员端运行结果

管理员端集中体现系统的全局管理、智能调度与网络规划能力。在城市末端调度页面，管理员选择待调度订单并生成调度方案，系统给出建议批次数、划分区域数和配送策略说明。@admin-incity-dispatch-overview 展示了末端调度方案预览，16 单待调度订单被划分为 4 个批次，系统综合距离、订单量与中转站位置判断是否经分拨中心配送。调度方案确认后，管理员在司机分配页面为干线运输和末端路线组指定司机，@admin-driver-assign 展示了干线司机与末端司机的分配结果。

#imagex(
  image("figures/incity_result_overview.png", width: 90%),
  caption: [管理员城市末端调度方案预览],
  label-name: "admin-incity-dispatch-overview",
)

#imagex(
  image("figures/driver_assign.png", width: 90%),
  caption: [管理员干线与末端司机分配页面],
  label-name: "admin-driver-assign",
)

批次执行后，管理员可在批次详情中查看干线段、末端配送组和全批次路线。@admin-batch-route-total 展示了同一批次的干线与末端路线总览，蓝色线路表示干线段，绿色线路表示末端配送段；@admin-batch-route-last 展示了末端配送组的单独路线，便于检查停靠顺序与司机执行范围。

#imagex(
  image("figures/incity_batch_result_totalmap.png", width: 90%),
  caption: [管理员批次路线总览],
  label-name: "admin-batch-route-total",
)

#imagex(
  image("figures/incity_batch_result_lastmap.png", width: 85%),
  caption: [管理员末端配送组路线详情],
  label-name: "admin-batch-route-last",
)

除城市内调度外，管理员端还提供全国 Hub-and-Spoke 网络的运力规划结果展示。MCMF 执行前，系统先调用 LLM 对候选物流边进行费用校准，将线路负载、天气、拥堵和历史成本等因素转化为费用倍率，为后续最小费用最大流求解提供更贴近业务状态的边权输入。@admin-mcmf-llm-cost-calibration 展示了物流边费用校准结果，不同线路根据运行条件被上调或下调费用倍率。

#imagex(
  image("figures/MCMF_LLM_result_1.png", width: 90%),
  caption: [管理员 MCMF 执行前物流边费用校准结果],
  label-name: "admin-mcmf-llm-cost-calibration",
)

完成费用校准后，系统执行 MCMF 算法求解全国网络中的运力分配方案。@admin-mcmf-result-map 展示了 MCMF 算法在全国物流网络中的流量分配，地图同时标识有运载批次 Hub、空闲 Hub、待发车批次和运输中线路。规划生成后，系统再次调用 LLM 对结果进行解释性分析，@admin-mcmf-llm-analysis 围绕瓶颈负载、线路成本异常、枢纽利用率和可优化路径给出建议，辅助管理员判断是否需要调整费率、合并线路或补充中转能力。

#imagex(
  image("figures/MCMF_result_map.png", width: 90%),
  caption: [管理员全国物流网络 MCMF 规划结果],
  label-name: "admin-mcmf-result-map",
)

#imagex(
  image("figures/MCMF_LLM_result_2.png", width: 90%),
  caption: [管理员 MCMF 规划结果 LLM 分析建议],
  label-name: "admin-mcmf-llm-analysis",
)

== 本章小结

本章从功能与性能两个维度对系统进行了综合验证。功能测试确认了注册登录、下单扣库存、中转站分配、调度预览与Hub-and-Spoke全流程等核心链路的正确性；性能测试表明Redis缓存提升高频读接口性能约5.2倍（生产环境中数据库独立部署时效果更为显著），RabbitMQ异步机制在10并发下TPS达685.3，路径规划接口20并发下TPS达277.5。综合来看，系统在单机部署条件下能够满足中小规模智能物流业务的性能与功能需求。

// 显示结论
#conclusion[
  本研究针对传统物流管理系统在效率、成本和灵活性方面的挑战，引入微服务架构与相关技术，构建了面向智能物流场景的管理系统，验证了所提出技术方案的可行性与有效性。

  本系统围绕基于微服务架构的智能物流管理系统展开研究，完成了从需求分析、总体设计到系统实现与验证的完整工作。系统采用微服务架构将复杂物流业务拆分为认证、顾客、商店与库存、订单、运输员配送、物流规划和网关等服务单元，基于Spring Boot、Spring Cloud与Spring Cloud Alibaba完成服务治理。在智能化能力方面，集成了基于GraphHopper的A\*路径规划、大语言模型辅助裁决、K-Means末端调度预览与MCMF全国运力优化。同时构建了基于Hub-and-Spoke三级物流网络的完整履约流程，实现了从下单到末端配送的闭环执行。

  本文的特色主要体现在三个方面。第一，系统将顾客下单、商户发货、仓库分配、干线运输、中转协同与末端配送等多角色业务流程统一纳入微服务架构，实现了完整履约链路闭环。第二，系统基于GraphHopper加载真实路网，采用A\*与加权启发策略生成候选路线，并引入大语言模型进行综合判断，形成了"确定性算法求解 + 生成式模型裁决"的混合路径规划模式。第三，系统将K-Means、MCMF与Hub-and-Spoke物流网络结合，在统一平台上实现了从局部调度到全国运力的多层次智能规划能力。

  当前系统仍存在以下不足：大语言模型主要用于路径裁决、费用校准和结果解释，接入深度仍偏辅助分析层面，尚未深度嵌入实时调度闭环；外部模型调用也会带来响应延迟、稳定性和成本方面的不确定性；跨服务一致性主要依赖异步消息，缺乏Saga等更完善的事务补偿机制；当前采用Docker Compose单机部署，尚未验证多实例水平扩展效果；安全性测试与异常链路测试不够充分。

  针对上述不足，未来可从以下方向优化：进一步深化大语言模型与物流调度服务的融合，引入模型结果缓存、超时降级和异步分析机制，在保证实时性的前提下提升智能决策能力；引入Saga编排模式替代纯消息驱动补偿；迁移至Kubernetes验证弹性扩缩容；补充接口安全性测试与自动化回归测试。
]

// 显示参考文献
#bib()

// 设置附录文档格式
#show: appendix



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

]

// 显示封底
#under-cover()
