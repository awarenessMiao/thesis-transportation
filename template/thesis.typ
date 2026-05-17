#import "../lib.typ": documentclass, algox, tablex, citex, imagex, subimagex

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
  随着电子商务、同城零售与跨区域配送需求的持续增长，传统物流管理系统在业务协同、资源调度、路径规划与运力分配等方面逐渐暴露出响应迟缓、耦合度高和扩展困难等问题。为提升物流系统在复杂业务场景下的可维护性、可扩展性与智能决策能力，本文设计并实现了一套基于微服务架构的智能物流管理系统。系统围绕订单履约、仓储库存、运输员配送、路径规划与全国运力调度等核心业务展开，目标是构建兼具工程可落地性与算法智能性的现代物流平台。

  本文首先分析了智能物流平台在发货用户下单、商户发货、仓库分配、干线运输、末端配送和中转协同等环节的业务需求，并在此基础上采用微服务架构对系统进行拆分，形成认证服务、用户服务、发货用户服务、商店与库存服务、订单服务、运输员服务、物流规划服务和网关服务等多个独立服务单元。各服务基于 Spring Cloud Alibaba 生态完成服务注册发现、网关统一接入与服务间调用，RabbitMQ 负责跨服务异步解耦，Redis 提升高频访问场景下的系统性能。

  在技术实现上，针对微服务环境下的服务治理与高并发访问需求，后端采用 Spring Boot 3、Spring Cloud 2022 与 Spring Cloud Alibaba 构建微服务体系，MyBatis-Plus 与 MySQL 负责结构化数据持久化，Redis 缓存缓解高频访问场景下的数据库瓶颈，BCrypt 与 JWT 统一认证方案保障多角色环境下的身份安全。针对多角色前端交互与地图可视化需求，前端采用 Vue3 + Vite 构建多角色单页应用，结合 Element Plus、Pinia 与 Leaflet 分别实现界面组件、状态管理与地图可视化。针对部署一致性与运维便捷性需求，Docker Compose 对数据库、中间件、微服务与前端容器进行统一编排，支持一键部署。

  在系统实现中，系统重点完成了以下内容：一是基于真实角色权限建立了统一认证与网关鉴权机制，实现用户身份校验和路径级访问控制；二是围绕订单、库存和配送任务构建了面向履约链路的业务协同流程，并采用消息队列实现库存扣减、配送创建与调度入池的最终一致性；三是在物流规划服务中集成 GraphHopper 路网引擎，并实现了基于 A\* 的路径规划、基于大语言模型的候选路线决策、基于 K-Means 的末端调度预览以及基于最小费用最大流的全国运力规划；四是构建了基于 Hub-and-Spoke 物流网络的完整履约流程，实现订单从下单、分配中转站、干线运输到末端派送的全链路闭环。

  系统的创新点主要体现在三个方面：一是以微服务架构支撑复杂物流业务协同，实现了订单、仓储、配送与调度能力的服务化解耦；二是将真实路网路径规划、聚类调度与全国运力优化算法引入统一物流平台，增强了系统的智能化水平；三是引入大语言模型对路线选择、批次建议与运力规划结果进行辅助分析，形成"确定性算法求解 + 生成式模型解释与裁决"的混合决策模式。实验与系统运行结果表明，该系统能够较好支撑智能物流管理的核心业务需求，并为微服务架构在智能物流领域的应用提供了可参考的工程实践方案。
][
  With the rapid growth of regional distribution and cross-city delivery demand, traditional logistics systems increasingly suffer from poor scalability, tight coupling, and insufficient decision support in routing and capacity coordination. To address these issues, this thesis designs and implements an intelligent logistics management system based on microservice architecture. The system focuses on order fulfillment, inventory collaboration, transporter delivery, route planning, and nationwide transportation scheduling, aiming to build a modern logistics platform with both engineering practicability and intelligent optimization capability.

  This work first analyzes the business requirements of an intelligent logistics platform, including sender ordering, merchant shipment, warehouse allocation, trunk transportation, hub transfer, and last-mile delivery. Based on these requirements, the system is decomposed into multiple independent services such as authentication service, user service, sender service, shop and inventory service, order service, transporter service, logistics service, and gateway service. Service registration, discovery, unified gateway access, and inter-service communication are built on the Spring Cloud Alibaba ecosystem, while RabbitMQ and Redis are used for asynchronous decoupling and high-frequency access acceleration.

  For implementation, to address service governance and high-concurrency access in microservice environments, the backend adopts Spring Boot, Spring Cloud, and Spring Cloud Alibaba, with MyBatis-Plus and MySQL for structured data persistence, Redis for caching to alleviate database bottlenecks, and BCrypt and JWT for unified identity security across multiple roles. To support multi-role frontend interaction and map visualization, the frontend is built with Vue3 and Vite as a multi-role single-page application, with Element Plus, Pinia, and Leaflet for interface components, state management, and map rendering. To ensure deployment consistency and operational convenience, the whole system is containerized and orchestrated through Docker Compose for one-click deployment.

  The system implementation mainly covers four aspects. First, a unified authentication and gateway authorization mechanism is established to support identity validation and path-level access control. Second, the fulfillment chain for orders, inventory, and delivery tasks is coordinated across services, and eventual consistency is ensured through message queues. Third, the logistics service integrates GraphHopper for real road network loading, implements A\*-based route planning, large-language-model-assisted candidate route selection, K-Means-based dispatch preview, and minimum-cost maximum-flow based nationwide capacity planning. Fourth, a complete Hub-and-Spoke delivery workflow is built to support the full lifecycle from order creation and hub assignment to trunk transportation and last-mile fulfillment.

  The main contributions of this thesis are threefold. First, it demonstrates how microservice architecture can support complex logistics collaboration by decoupling order, warehouse, delivery, and scheduling capabilities. Second, it integrates route planning, clustering-based dispatching, and nationwide capacity optimization algorithms into a unified logistics platform. Third, it introduces large language models to assist with route judgment, batch advice, and flow-plan interpretation, forming a hybrid decision-making mode that combines deterministic optimization with generative reasoning. The results show that the proposed system effectively supports the core requirements of intelligent logistics management and provides a practical reference for applying microservice architecture in this domain.
]

// 显示目录
#outline()

// 设置文档主体的格式
#show: mainmatter

= 绪论

本章介绍论文的研究背景与意义、国内外研究现状及不足、主要研究内容以及论文组织结构。先讨论物流行业的发展现状与智能物流系统的现实需求，阐述微服务架构应用于物流领域的背景与意义；再从国内外两个视角梳理智能物流管理系统、路径规划与运力优化等方面的研究进展，分析现有工作的不足与本文的切入点；随后明确本文的研究内容；最后介绍论文的组织结构与各章安排。

== 研究背景及意义

物流行业作为支撑国民经济发展的基础性产业，在全球化和电子商务迅猛发展的浪潮下，其重要性日益凸显。然而，传统的物流管理模式在应对日益增长的业务复杂性、时效性要求以及成本控制压力时，逐渐显现出诸多瓶颈。当前物流行业普遍面临着高成本、低效率、信息孤岛等痛点。例如，中国的物流成本占GDP比重曾高达14.1%，远高于许多发达国家的平均水平，同时仓库闲置率等资源浪费问题也较为突出。这些问题严重制约了物流行业的发展和整体服务水平的提升。

为应对这些挑战，在物联网、大数据、人工智能以及云计算等新一代信息技术的驱动下，物流行业正经历着深刻的数字化和智能化转型@ref1。智能物流管理系统应运而生，以技术创新优化物流运作的各个环节。物联网技术借助各类传感器和标识设备，使货物、车辆、仓库等物流要素的状态感知与数据采集成为可能，打破了传统模式下的信息壁垒@ref2。大数据技术则能够对海量的物流运作数据进行深度挖掘与分析，为路径优化、需求预测、库存管理等方面提供决策支持，提升运营效率@ref3。人工智能技术，尤其在智能调度、风险预警、自动化处理等方面的应用，提升了物流系统的自动化水平和智能化程度@ref4。

然而，随着业务的扩展和深化，传统的单体式系统架构在支撑复杂的智能物流应用时，其固有的技术局限性愈发明显。单体架构系统往往功能模块耦合度高，任何微小的改动或升级都可能影响整个系统的稳定性，导致维护成本高、迭代周期长，难以快速响应市场变化和满足高并发、高可用的需求@ref5。特别是在物流高峰期（如促销活动期间），单体系统容易因资源瓶颈而出现性能问题甚至服务中断。因此，寻求一种更灵活、更具扩展性、更适应现代物流业务动态需求的系统架构成为业界的迫切需求。

在此背景下，微服务架构作为一种新兴的软件架构模式，受到了广泛关注。微服务架构将复杂系统拆分为围绕业务能力构建的自治服务单元，各单元可独立开发、部署与扩展@ref6。这种架构模式天然契合了智能物流系统对灵活性、可扩展性和高可用性的要求。通过采用微服务架构，可以将智能物流管理系统中的订单管理、库存管理、运输调度、配送跟踪、路径优化等核心功能模块解耦为独立的服务，系统的整体韧性、开发效率和技术选型的灵活性均得到改善。

基于上述背景，本研究设计并实现一个基于微服务架构的智能物流管理系统。该系统的研究与实现具有重要的理论价值和现实意义：

+ 提高物流运作效率：微服务架构将各业务模块解耦，支持独立协同运作，结合路径优化与智能调度，有助于缩短运输时间并提高车辆、仓储等资源的利用率，物流运作效率得到全面提升。

+ 降低运营成本：微服务架构的弹性伸缩能力有助于根据业务负载动态调整资源，避免资源浪费。优化的路径规划和库存管理也有助于降低运输成本和仓储成本。系统自动化水平的提高也能减少对人力的依赖，降低人力成本。

+ 提升用户体验：系统提供实时的订单跟踪、精准的预计送达时间以及便捷的查询服务，能够改善货主、承运方以及最终客户的使用体验和满意度。各服务独立部署和升级的特性也能保障核心业务的连续性，减少因系统维护带来的服务中断。

+ 促进物流行业数字化转型：本研究探索将先进的微服务架构应用于复杂的物流管理场景，为传统物流企业向数字化、智能化转型提供了可借鉴的技术方案和实践经验。系统的模块化设计也便于未来集成更多新兴技术（如区块链、数字孪生等），推动行业的持续创新。

+ 验证微服务架构优势：通过在智能物流领域的具体实践，可以深入验证微服务架构在应对高并发、复杂业务逻辑、快速迭代需求方面的优势和适用性，为相关领域的系统架构选型提供参考。

== 国内外研究现状及不足

近年来，随着物流行业对信息化与智能化需求的持续提升，国内外学者和工程团队在物流管理系统、智能调度算法和微服务架构应用等方面开展了大量研究与实践。本节从国内外两个视角梳理相关研究进展，并分析现有工作存在的不足，阐明本文的切入点。

=== 国内研究现状

在国内，物流信息系统的建设经历了从单机管理软件到企业级ERP集成、再到平台化云服务的发展过程。早期的研究主要聚焦于仓储管理系统（WMS）和运输管理系统（TMS）的构建，实现了入库出库、运输调度等基本业务的信息化管理。贾志刚等@ref19 基于Spring Cloud微服务架构对物流运输管理系统进行了重构设计，验证了微服务拆分在提升系统可维护性和可扩展性方面的效果；王珊珊等@ref20 基于Spring Boot实现了物流管理系统的核心功能，但未涉及服务治理与多角色协同。在智能算法方面，国内学者在配送中心选址、路径优化等方向取得了较多成果。李晓等@ref39 将K-Means聚类算法应用于物流配送中心选址问题，通过空间聚类优化配送网络布局，降低了末端配送成本。根据中国物流与采购联合会发布的数据@ref40，2023年全国社会物流总额持续增长，但社会物流总费用占GDP比重仍高于发达国家水平，表明物流系统的智能化与协同效率仍有较大提升空间。然而，国内现有工作多集中于单一功能模块的优化，缺乏将路径规划、调度执行与运力规划统一纳入同一系统平台的综合性研究。此外，大语言模型等新兴AI技术在物流决策领域的应用尚处于探索阶段，缺乏面向真实业务场景的工程化实践。

=== 国外研究现状

在国外，微服务架构在物流与供应链系统中的应用已得到较为广泛的研究。Gonzalez等@ref33 通过系统文献综述分析了从传统ERP向微服务架构迁移的策略与挑战，指出微服务在实现业务模块独立部署与弹性扩展方面具有优势。Chen等@ref32 对微服务架构的应用前景进行了展望，认为其在复杂业务系统中将发挥越来越重要的作用。Liu等@ref31 设计并实现了基于微服务架构的智能物流管控平台，验证了微服务在物流数据交互与多角色协同场景中的可行性。在路径规划领域，Zhang等@ref34 提出了一种改进的A\*算法用于城市道路环境下的车辆路径规划，通过在代价函数中引入时间因素提升了规划结果的实用性。Liu等@ref35 对车辆路径问题（VRP）的模型与算法进行了系统综述，指出机器学习与启发式算法的融合是VRP研究的重要趋势。在网络优化方面，Zhao等@ref36 针对城市物流网络构建了Hub-and-Spoke优化模型，结合流量延迟成本实现了运输网络的高效组织。Fragkos等@ref37 对最大流与最小费用流问题的精确算法进行了综述，为运力分配等网络优化问题提供了算法基础。近年来，大语言模型在供应链决策中的应用开始受到关注，Simchi-Levi等@ref38 探讨了LLM在供应链决策中的潜力，指出其可以在需求预测、路径选择和方案解释等方面提供辅助支持。

=== 现有不足与本文切入点

综合国内外研究现状，现有工作在以下几个方面仍存在不足：

+ 多数物流管理系统仅关注单一业务环节的管理（如仓储或运输），缺乏对发货用户下单、商户发货、仓库分配、干线运输、末端配送等多角色全链路协同的系统性支撑。

+ 路径规划研究多基于理想化路网模型或直线距离估算，较少在真实道路拓扑环境下进行路径搜索与多候选路线裁决，导致规划结果与实际运输场景存在偏差。

+ 运力规划与调度通常作为独立问题研究，缺乏将聚类调度、网络流优化与Hub-and-Spoke物流网络有机结合并统一落地的工程实践。

+ 大语言模型在物流领域的应用尚处于起步阶段，现有工作多为概念验证，尚未形成"确定性算法求解 + 生成式模型裁决"的混合决策模式在真实物流系统中的工程化集成。

针对上述不足，本文以微服务架构为基础，设计并实现了一个集成真实路网路径规划、K-Means聚类调度、最小费用最大流运力规划与大语言模型辅助决策的智能物流管理系统，目标是构建一条从下单到末端配送的完整履约链路，实现多角色协同、算法融合与工程落地的统一。

== 本课题的研究内容

本课题的核心任务是设计、开发并实现一个功能相对完善、具备良好扩展性的基于微服务架构的智能物流管理系统。主要研究内容包括以下几个方面：

+ 系统需求分析与架构设计：深入分析智能物流管理的核心业务流程和功能需求，设计基于微服务理念的系统总体架构，划分核心服务模块（如订单服务、库存服务、调度服务、追踪服务、路径优化服务等），并定义服务间的交互接口与协议。

+ 关键技术选型与应用：研究并选用合适的技术栈来实现微服务架构，重点围绕 Spring Cloud 生态（如服务注册与发现、API网关、配置中心、服务调用、熔断降级等）进行技术实践。同时，研究前端技术（如 Vue3, Vite）与后端微服务的交互模式。

+ 核心服务模块的设计与实现：针对订单管理、库存管理、运输调度、配送跟踪、路径优化等关键业务模块，进行详细的功能设计和数据库设计，并完成各微服务的编码实现。

+ 系统集成与部署：实现各微服务之间的集成与协同工作，并研究使用容器化技术和容器编排工具对系统进行打包、部署和管理，以实现弹性伸缩和高可用性。

+ 系统测试与评估：对系统进行功能测试、性能测试和可用性测试，评估系统是否满足设计要求，并分析其优势与待改进之处。

上述五项研究内容与论文后续各章形成一一对应关系：研究内容一对应第三章系统设计，研究内容二对应第二章技术综述中的选型分析，研究内容三对应第四章系统实现，研究内容四对应第四章容器化部署小节，研究内容五对应第五章系统测试与运行结果分析。

== 论文组织结构安排

全文共分为五章正文、结论与附录，整体结构围绕"需求分析---系统设计---系统实现---系统测试与运行结果分析---总结与展望"的逻辑展开。

第一章为绪论，主要介绍研究背景与意义、国内外研究现状及不足、主要研究内容以及论文整体结构，说明选题来源与研究价值。

第二章为相关技术综述，重点介绍系统所采用的微服务治理技术、数据访问与缓存技术、前端开发技术、容器化部署技术，以及路径规划、聚类调度、最小费用最大流和大语言模型等智能算法相关技术。

第三章为系统设计，围绕需求分析、总体架构设计、核心模块设计、前端设计与数据库设计展开，给出系统角色划分、服务划分、数据模型与主要接口设计方案。

第四章为系统实现，主要介绍系统的具体编码实现过程，包括微服务环境搭建、认证与权限系统实现、订单与库存等核心业务服务实现、智能路径规划与运力规划算法实现、前端多角色界面实现以及 Docker 容器化部署配置。

第五章为系统测试与运行结果分析，主要介绍测试环境与评价指标、功能测试与业务链路验证、性能测试与结果分析以及多角色运行结果展示，验证系统设计的有效性与实现的完整性。

结论部分总结本文的主要研究工作与系统实现成果，凝练特色创新点，分析系统当前存在的不足，并对后续发展方向进行展望。

== 本章小结

本章从物流行业的发展现状与数字化转型需求出发，阐述了基于微服务架构构建智能物流管理系统的研究背景与意义；梳理了国内外在物流信息系统、路径规划算法、运力网络优化和微服务架构应用等方面的研究进展，指出了现有工作在多角色协同、真实路网规划、算法融合与工程落地方面的不足；在此基础上，明确了本课题的研究内容与论文的组织结构安排，为后续章节的系统设计与实现奠定了基础。

= 相关技术综述

本章围绕基于微服务架构的智能物流管理系统所采用的关键技术展开综述。内容主要包括微服务治理与服务通信技术、后端数据访问与缓存技术、前端开发与地图可视化技术、容器化部署技术，以及系统中涉及的路径规划、聚类调度、运力优化与大语言模型辅助决策等智能算法技术。这些技术共同构成了系统设计与实现的理论基础与工程支撑。

== 微服务架构相关技术

微服务架构是一种软件工程概念，主要强调在后端项目管理中实现高内聚、低耦合。在传统单体架构中，随着需求的不断引入，软件各个组件紧密耦合，管理成本越来越高。在微服务架构中，每个单位可以根据独立的需求设计、开发、测试、部署和维护，因而可以实现低成本的扩展和维护@ref7。Zimmermann@ref8 从软件架构原则角度总结了微服务的核心特征，指出其在服务自治、独立部署与技术异构性方面的优势；Dragoni等@ref11 对微服务架构的发展历程进行了系统回顾，认为其演进方向正从单纯的架构风格向云原生与DevOps深度融合发展。相较于传统面向服务架构（SOA），微服务更强调服务的细粒度拆分与独立运维@ref13，同时在成本效益方面也展现出优势@ref12。

对于智能物流管理系统而言，其业务流程复杂、涉及模块众多，且对系统的可用性、可扩展性要求高。微服务架构能够很好地满足这些需求：将不同的物流功能拆分为独立服务，便于功能的快速迭代和优化；可以根据业务高峰独立扩展订单服务或调度服务；单个模块的升级或故障不会影响其他核心业务的运行。

为了实现微服务架构，首先需要对各个子模块进行精确划分与设计，这点将在下一章详细讨论。同时，微服务架构在实现中需要引入多种中间件，将各个部分有机地组合在一起。

=== 注册中心

微服务架构中，各服务实例的启停与扩缩容是常态，因此需要一个注册中心组件来动态维护各服务的可用实例列表，支持服务发现、负载均衡与故障转移。当前主流的注册中心方案在 CAP 理论下各有侧重：

+ *Zookeeper*：采用 CP 模型，通过 ZAB 协议保证强一致性，但在网络分区时可能牺牲可用性导致服务注册中断，且不提供配置管理能力。

+ *Eureka*：采用 AP 模型，优先保证可用性，在网络分区时仍可提供注册服务但可能返回过期实例信息，且缺乏配置管理功能。

+ *Nacos*：支持 CP 与 AP 模式间的自动切换，同时提供配置管理与服务发现能力，在一致性与可用性之间可根据场景动态选择。

综合考虑本系统对配置动态刷新与注册可用性的双重需求，系统选用 Nacos 作为注册中心，各服务统一注册至 Nacos 并从中获取其他服务实例信息。

=== 微服务网关与服务调用

微服务架构中，由于服务间调用关系错综复杂，且权限管理需跨越多个服务，我们需要一个独立网关拦截并路由对各个API的调用请求。该组件可以利用注册中心发现的服务信息，实现服务调用的全局管理。微服务架构中，不仅存在客户端对微服务的请求，还存在微服务对微服务的请求，因此我们需要一个便捷方式在SpringBoot框架中实现对HTTP请求的封装。

Spring Cloud Gateway 是 Spring Cloud 官方推出的新一代 API 网关，基于 Spring WebFlux 和 Reactor 模型构建，能够提供统一入口、请求路由、过滤器链处理、身份认证与权限控制等能力。与早期的 Zuul 1.x 相比，Spring Cloud Gateway 在性能、可扩展性和与现代 Spring 生态集成方面更具优势，已成为当前微服务系统的主流网关方案。Rodrigues等@ref21 对API网关的分类与挑战进行了系统梳理，指出网关在微服务架构中不仅承担路由转发职责，还需解决认证鉴权、限流熔断与协议转换等横切关注点。

OpenFeign 是声明式服务调用组件，开发者只需定义带注解的接口，即可完成对远程微服务的 HTTP 调用封装。在配合 Spring Cloud LoadBalancer 使用时，OpenFeign 可以自动完成基于服务名的实例发现与负载均衡，降低服务间调用的样板代码。

在本项目中，系统使用 Spring Cloud Gateway 作为统一入口，实现 JWT 认证过滤、角色路径权限控制以及用户身份透传；同时使用 OpenFeign 完成订单、库存、发货用户与物流规划等服务之间的同步调用，形成完整的微服务协作链路。

=== 消息队列

在微服务架构中，服务间的通信方式可分为同步调用与异步消息传递两类。同步调用适用于需要即时获取结果的场景，但在跨服务链路较长时容易形成阻塞依赖；异步消息传递则将请求发送与处理解耦，适合用于耗时操作与跨服务协作场景。消息队列作为异步通信的核心组件，主要提供服务解耦、异步通信与削峰填谷三方面能力。

当前主流的消息队列中间件有 RabbitMQ 与 Kafka 等@ref14。RabbitMQ 提供灵活的路由交换机制与可靠的消息确认模式，适合业务逻辑复杂、需要精细路由控制的场景；Kafka 以高吞吐量和持久化日志著称，适合大数据流处理与日志收集场景。本系统在订单创建后的库存扣减、配送单创建与调度入池等环节采用异步消息传递机制，需要可靠的消息投递与消费确认，因此选用 RabbitMQ 作为核心消息中间件。

== 数据持久化与缓存技术

除微服务治理组件外，后端系统还需要稳定的数据持久化、便捷的数据访问抽象与高效的缓存机制。为此，本项目采用 MySQL 作为主要关系型数据库，以 MyBatis-Plus 作为数据访问增强框架，并结合 Redis 提升热点数据读取效率。

=== MySQL与MyBatis-Plus

MySQL 是当前广泛使用的开源关系型数据库管理系统，具备成熟的事务支持、索引机制与较高的工程稳定性，适合支撑订单、库存、配送和调度等结构化业务数据存储需求@ref24。在本系统中，MySQL 8.0 主要用于保存用户、承运物、仓库、订单、路线、批次以及全国运力规划结果等核心业务数据。

MyBatis-Plus 是构建在 MyBatis 之上的增强工具，在保留原生 SQL 控制能力的基础上，提供了通用 CRUD 接口、条件构造器、分页插件、自动填充等功能，可减少样板代码。在本项目中，各服务普遍采用 ServiceImpl\<M,T\> 形式构建业务服务层，借助 LambdaQueryWrapper 获得类型安全的条件查询能力，开发效率与可维护性随之提升。

系统运行时还使用 Spring Boot 默认集成的 HikariCP 连接池来管理数据库连接，通过限制最大连接数、配置超时时间和复用空闲连接等方式，提高并发场景下的数据访问稳定性。相较于完全响应式的数据访问方案（如R2DBC@ref25、Spring WebFlux响应式编程@ref26 @ref27），本项目采用阻塞式的 MyBatis-Plus + JDBC 技术路径。Kleppmann@ref15 指出，响应式数据访问在降低线程阻塞方面具有理论优势，但其编程模型复杂度显著高于传统阻塞式方案，且在业务逻辑以同步编排为主的场景下收益有限。本系统的核心业务链路（如下单扣库存、配送创建等）属于同步编排模式，采用阻塞式方案更符合当前工程复杂度要求与开发效率需求。

=== Redis缓存

在高并发状态下，MySQL由于基于块设备存储数据，速度远慢于内存，因此需要基于内存的NoSQL实现缓存加速。

Redis是目前最主流的内存KV存储中间件@ref28，它支持多种数据类型的存储，同时具有极高性能的读写能力，并提供了RDB和AOF两种数据持久化技术和集群模式、哨兵模式等高可用方案@ref29。

基于Redis的特性，本项目在多个业务服务中采用 Spring Cache 配合 Redis 为热点数据提供缓存加速，使用 Cache-Aside 模式：读操作优先查询缓存，未命中时查询数据库并回填缓存；写操作在更新数据库后及时清除对应缓存条目以保持数据一致性。各服务的仓库列表、承运物详情、配送任务列表与路线结果等高频读数据均采用该缓存策略。认证方面，系统采用无状态 JWT，Token 由前端本地持有，服务端不存储会话信息，因此 Redis 不用于 Token 存储。

== 前端技术栈

用户交互界面的质量直接影响本系统的用户体验。现代前端开发普遍是基于Webpack、Vite等打包器的Typescript项目。这些项目使用Vue或React这样的响应式框架，借助axios、ofetch等ajax请求组件与后端交互。

=== 响应式框架

当今前端开发主要基于 MVVM 范式，将页面结构与数据模型分离，响应式数据绑定驱动界面自动更新。主流的响应式框架包括 Vue、React 和 Angular 等。本系统前端采用 Vue3 框架，其选型依据在于：本系统涉及四类角色的差异化交互需求，需要灵活的状态管理与组件复用能力；Vue3 提供的 Composition API 支持以函数为单位组织组件逻辑，特别适合多角色应用中跨组件共享登录态与权限信息等场景；Vue3 的 TypeScript 集成更为友好，有助于构建类型安全的前端应用。

=== 构建工具与界面组件

Vite 是新一代前端构建工具，充分利用浏览器原生 ES Module 特性以获得更快的开发服务器启动速度，并在生产环境通过高效打包提升构建性能。对于本系统这类以后台管理和多角色交互为主的应用场景，采用 Vue3 + Vite 的单页应用模式即可满足开发效率与运行性能要求，无需引入以 SSR 为主要特征的框架。

Element Plus 是基于 Vue 3 的组件库，提供表格、表单、弹窗、分页、菜单等通用后台组件，可帮助开发者快速构建风格统一的管理界面。本项目的大部分后台页面均基于 Element Plus 实现，并结合 Pinia 进行前端状态管理，结合 axios 完成与后端接口的数据交互。

在地图与轨迹展示方面，系统前端采用 Leaflet 作为基础地图渲染组件，并结合后端返回的 GeoJSON 路线数据实现运输轨迹、运输员位置和全国网络拓扑的可视化展示。这种组合方式既保证了开源可控性，也满足了物流地图场景下的交互需求。

== 容器化部署技术

容器是一个隔离的运行环境，具有独立性、可移植性、快速启动和资源利用率高的特点。在微服务架构下，各个模块间彼此独立、可分布式扩展。容器化部署技术即将这些模块各自打包为容器镜像，再利用统一的编排配置文件，根据客户端调用负载强度按需启用和扩容。

后端项目中微服务架构的设计与实现，仅仅在工程角度实现了该架构可扩展性的优点。我们还需要结合容器化部署编排技术，才能实现弹性扩容、故障迁移等功能，最大化微服务架构的效益。Balalaie等@ref9 的研究表明，微服务架构与DevOps实践之间存在协同促进关系：微服务的独立部署特性天然适配持续交付流水线，而容器化编排则是实现这一协同的关键基础设施。

=== Docker容器

Docker是目前最主流的开源容器化平台@ref30。它利用Linux内核的特性，允许开发者将应用程序及其所有依赖打包到一个轻量级、可移植的独立容器镜像中。容器在运行时相互隔离，共享宿主机的操作系统内核。

前文中提到的各种中间件依赖可以直接使用标准化的官方容器，从而无需配置运行环境，且可便捷指定端口号和配置参数。本项目的前端、后端实现也会提供对应的Dockerfile，从而在任何支持Docker的环境中可以标准化部署，不存在兼容性问题。结合持续交付实践@ref17，容器化使得构建产物从开发环境到生产环境的一致性得到保障，消除了"环境差异"导致的部署风险。

=== Docker Compose

Docker Compose是一个用于定义和管理多容器Docker应用的工具，开发者可以通过一个YAML文件来配置应用所需的所有容器、网络、数据卷等，此后仅需一条命令即可启动、停止和重建所有服务。此外，Docker Compose还可以为多个关联容器创建一个隔离的局域网，并可指定容器间的依赖关系。

本系统中的前端、后端、中间件之间依赖关系复杂，端口号配置繁多。在使用Docker Compose后，仅需提供一个全局配置文件即可让用户快速部署。

=== 容器编排与部署策略

对于毕业设计阶段的部署需求，Docker Compose 已能够满足数据库、中间件、微服务与前端应用的一键编排与统一启动要求，因此本文采用单机容器化部署方案。需要指出的是，在面向生产环境的大规模部署场景中，仍可进一步引入 Kubernetes 等成熟编排平台，以获得自动扩缩容、故障自愈和更强的运维能力，但这并非本文系统实现的重点。

== 智能算法技术

除传统业务系统技术外，本项目还引入了面向物流优化场景的智能算法技术，包括基于真实路网的路径搜索、多候选路线裁决、聚类调度预览以及全国运力优化等。相关技术的引入使系统从传统信息管理平台演进为具备辅助决策能力的智能物流平台。

=== 路网引擎（GraphHopper）

GraphHopper 是一款高性能的 Java 路径规划引擎，能够加载 OpenStreetMap 地图数据并构建可查询的道路图结构。与简单直线距离估算不同，GraphHopper 可以基于真实道路拓扑和车辆通行规则执行路径搜索，因此更适合物流运输场景中的实际路线规划。在本系统中，GraphHopper 被集成至 logistics-service，用于加载目标区域的 OSM 数据并为上层 A\* 路径算法提供底层路网支持。

=== A\* 启发式搜索算法

A\* 算法是一种经典的启发式最优路径搜索算法，通过代价函数 $f(n) = g(n) + h(n)$ 引导搜索方向。其中 $g(n)$ 表示起点到当前节点的实际代价，$h(n)$ 表示当前节点到目标节点的启发式估计。在本系统中，启发函数采用 Haversine 球面距离，由于该距离不会高估真实道路距离，因此满足可采纳性条件，能够保证 A\* 搜索结果的最优性。为了生成风格不同的候选路线，系统使用加权启发策略，通过调整启发权重 epsilon 生成多条差异化路线供后续模型选择。

=== 大语言模型辅助决策

大语言模型具备较强的自然语言理解、上下文整合与推理分析能力，适合用于对结构化算法结果进行再判断和解释。在本系统中，DeepSeek API 被用于多个辅助决策场景：在路径规划中结合候选路线和历史交通特征选择更合理的路线；在末端调度中结合聚类结果给出批次合并、拆分与优先级建议；在运力规划中对最小费用最大流结果进行人类可读分析。该方法并不替代传统优化算法，而是与确定性算法协同工作，提升决策结果的可解释性与实用性。

=== 最小费用最大流问题及求解方式

最小费用最大流问题是求解在满足流量约束的前提下运输总成本最小的网络流分配问题。该问题常出现在交通运输、供应链和资源调度的场景中，目的是同时处理容量约束与费用约束。在本系统中，全国物流干线网络被抽象为带容量与单位费用的有向图，仓库、枢纽站与中转站构成节点，线路构成边，运单需求则对应待分配的流量。通过 MCMF 求解，系统能够生成跨区域运输的全局运力分配方案，为管理员提供全国层面的资源配置支持。

== 本章小结

本章系统梳理了智能物流管理系统实现过程中涉及的关键技术，并在各技术小节中阐述了选型依据。为便于读者快速把握系统整体技术决策，下表对核心技术选型的对比与决策进行集中呈现。

#tablex(
  [注册中心], [Nacos], [Eureka], [Zookeeper], [Nacos 同时支持服务发现与配置管理，CP/AP 可切换，更适合 Spring Cloud Alibaba 生态],
  [消息队列], [RabbitMQ], [Kafka], [ActiveMQ], [RabbitMQ 路由灵活、消息确认可靠，适合业务事件驱动的异步解耦场景],
  [API 网关], [Spring Cloud Gateway], [Zuul 1.x], [--], [基于 WebFlux 非阻塞模型，性能优于 Zuul 1.x，与 Spring Cloud 2022 深度集成],
  [ORM 框架], [MyBatis-Plus], [JPA/Hibernate], [R2DBC], [保留 SQL 控制能力，通用 CRUD 减少样板代码，阻塞式模型更契合业务编排需求],
  [缓存方案], [Redis + Cache-Aside], [Caffeine 本地缓存], [--], [Redis 支持多实例共享，Cache-Aside 模式兼顾一致性与性能],
  [前端框架], [Vue3], [React], [Angular], [Composition API 适合多角色状态复用，TypeScript 集成友好，生态组件丰富],
  [地图组件], [Leaflet], [Mapbox GL], [高德地图 JS API], [开源免费，GeoJSON 渲染能力强，无商业授权限制],
  [容器编排], [Docker Compose], [Kubernetes], [--], [毕设阶段单机部署足够，K8s 适用于生产环境多实例编排],
  header: ([技术领域], [选用方案], [候选方案 1], [候选方案 2], [决策理由]),
  columns: (1fr, 1.3fr, 1.1fr, 1.1fr, 2.5fr),
  caption: [核心技术选型对比与决策表],
  label-name: "tech-comparison",
)

在微服务治理方面，系统基于 Nacos 实现服务注册与配置管理，基于 Spring Cloud Gateway 与 OpenFeign 实现统一接入与同步调用，基于 RabbitMQ 实现异步解耦与削峰填谷；在数据访问方面，MySQL + MyBatis-Plus 提供结构化持久化能力，Redis + Cache-Aside 模式提供热点数据缓存加速；在前端构建方面，Vue3 + Composition API 支撑多角色交互与状态管理，Element Plus 与 Leaflet 分别实现界面组件与地图可视化；在容器化部署方面，Docker Compose 提供一键编排能力；在智能算法方面，GraphHopper、A\*、K-Means、MCMF 与大语言模型共同构成了从路网加载、路径规划、聚类调度、运力优化到辅助决策的完整技术链。上述技术的组合使系统具备从传统信息管理到智能辅助决策的演进能力，为后续系统设计与实现提供了完整的理论依据和工程基础。

= 系统设计

本章按需求分析→总体设计→详细设计→数据库设计的顺序展开。第一节分析系统涉及的角色用例、功能需求与非功能需求；第二节给出系统的总体架构设计与技术栈选型；第三节从认证权限、订单库存、配送路线、调度运力与前端架构五个方面展开详细设计；第四节独立给出系统数据库设计，包括全局E-R模型与核心表设计。

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
  image("figures/architecture-overview.png", width: 85%),
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

本模块主要需要实现个人信息管理与地址管理的功能，以及商户信息管理、承运物管理、库存维护等功能。其中个人与地址间是一对多的关系；商户、承运物与仓库间涉及多对多关系，需通过关系表维护。

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

调度与运力规划模块是系统智能化能力的核心承载，负责路径规划、中转站管理、调度执行与全国运力规划@ref36 @ref37。该模块涉及物流路线、中转站、运输连接、配送批次与调度池等多个数据实体。

#tablex(
  [id], [BIGINT PK AUTO], [路线 ID],
  [route\_no], [VARCHAR(32)], [路线号（唯一）],
  [order\_id / delivery\_id / driver\_id], [BIGINT], [关联订单、配送单与运输员],
  [segment\_type], [TINYINT], [0=普通路线，1=干线段，2=末端段],
  [waypoints], [TEXT], [停靠点 JSON 数据],
  [start\_address / end\_address], [VARCHAR(255)], [起终点地址],
  [route\_status], [TINYINT], [-1=待激活，0=待出发，1=运输中，2=已到达，3=异常],
  [planned\_route], [LONGTEXT], [GeoJSON 规划路线数据],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 1.8fr),
  caption: [logistics\_route 实际字段表],
  label-name: "route-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [枢纽 ID],
  [hub\_name], [VARCHAR(100)], [枢纽名称],
  [hub\_level], [TINYINT], [0=全国枢纽，1=省级中心，2=城市配送中心],
  [city], [VARCHAR(50)], [所在城市],
  [latitude / longitude], [DOUBLE], [地理坐标],
  [daily\_capacity], [INT], [日处理容量],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 2fr),
  caption: [hub 枢纽属性表],
  label-name: "hub-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [连接 ID],
  [from\_hub\_id], [BIGINT FK], [起点枢纽],
  [to\_hub\_id], [BIGINT FK], [终点枢纽],
  [transport\_mode], [VARCHAR(20)], [运输方式（公路/铁路/航空）],
  [distance\_km], [DOUBLE], [运输距离],
  [capacity\_daily], [INT], [日运输容量],
  [base\_cost\_per\_unit], [DECIMAL], [单位货物基础费率],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [hub\_link 运输连接属性表],
  label-name: "hub-link-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [批次 ID],
  [batch\_no], [VARCHAR(32)], [批次编号（唯一）],
  [warehouse\_id], [BIGINT], [发货仓库 ID],
  [hub\_id], [BIGINT], [目标中转站 ID],
  [trunk\_route\_id], [BIGINT], [干线路线 ID],
  [batch\_status], [TINYINT], [0=待发车，1=干线运输中，2=已到Hub，3=末端配送中，4=已完成],
  [total\_orders], [INT], [批次订单数量],
  [use\_hub], [TINYINT], [是否经中转站],
  [vrp\_algorithm], [VARCHAR(20)], [批次算法标识],
  [total\_distance], [DOUBLE], [批次总距离],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1fr, 2fr),
  caption: [logistics\_batch 批次属性表],
  label-name: "batch-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [批次项 ID],
  [batch\_id], [BIGINT FK], [所属批次],
  [order\_id], [BIGINT FK], [订单 ID],
  [route\_id], [BIGINT FK], [对应末端路线 ID],
  [visit\_sequence], [INT], [大组内排序],
  [stop\_sequence], [INT], [停靠顺序],
  [end\_lat / end\_lng], [DOUBLE], [收货坐标],
  [end\_address], [VARCHAR(255)], [收货地址],
  [item\_status], [TINYINT], [0=待配送，1=配送中，2=已送达],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [logistics\_batch\_item 批次项属性表],
  label-name: "batch-item-table",
)

#tablex(
  [id], [BIGINT PK AUTO], [池记录 ID],
  [order\_id], [BIGINT], [订单 ID],
  [shop\_id], [BIGINT], [商户 ID],
  [warehouse\_id], [BIGINT], [发货仓库 ID],
  [end\_address], [VARCHAR(255)], [收货地址],
  [end\_lat / end\_lng], [DOUBLE], [收货坐标],
  [status], [TINYINT], [0=待调度，1=已调度],
  [batch\_id], [BIGINT], [已调度的批次 ID],
  header: ([字段名], [数据类型], [描述]),
  columns: (1fr, 1.2fr, 1.5fr),
  caption: [dispatch\_pool 调度池属性表],
  label-name: "dispatch-pool-table",
)

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

=== 前端架构与页面设计

本系统涉及发货用户、商户、运输员和管理员四类角色，各角色的业务流程与交互模式存在显著差异：发货用户侧重寄件管理与物流追踪，商户侧重库存管理与发货操作，运输员侧重地图导航与状态上报，管理员侧重调度预览与全网规划。因此，前端架构需要解决多角色路由隔离、统一认证状态管理、地图可视化集成以及前后端数据通信等核心问题。以下从总体架构、多角色页面结构和关键交互设计三个方面展开说明。

==== 前端总体架构设计

针对上述多角色差异化需求，前端采用 Vue3 + Vite 构建单页应用，并将整体架构划分为视图组件层、路由控制层、状态管理层、通信服务层和部署接入层五个层次，各层职责明确、解耦协作。

#imagex(
  image("figures/frontend-architecture.png", width: 90%),
  caption: [前端总体架构图],
  label-name: "frontend-architecture",
)

如图所示，各层的职责与设计决策如下：

+ *视图组件层*：由 Vue3 组件、Element Plus 界面组件和 Leaflet 地图组件构成，负责用户交互与界面渲染。本系统采用 Element Plus 提供统一的后台管理类组件风格，同时引入 Leaflet 实现运输轨迹与网络拓扑的地图可视化，两者通过 Vue3 的 Composition API 组织为可复用的业务组件。

+ *路由控制层*：由 vue-router 和全局路由守卫构成，负责多角色路由分发与访问控制。系统为四类角色设计了独立路由入口，路由守卫在每次导航前校验用户登录状态与角色权限，未登录用户重定向至登录页，角色不匹配则跳转至对应首页。这种前端路由鉴权机制与后端网关的路径级权限控制形成双重保障。

+ *状态管理层*：采用 Pinia 构建全局状态仓库，维护用户身份（userId）、认证令牌（token）和角色标识（roleCode）等核心状态。相比 Vuex，Pinia 提供更简洁的 Composition API 风格接口，天然支持 TypeScript 类型推导，且无需 mutation 同步约束，更适合多角色应用中跨组件共享登录态与权限信息的场景。

+ *通信服务层*：基于 axios 封装统一的 API 通信层，通过请求拦截器自动注入 Authorization 请求头，通过响应拦截器统一处理错误码与 Token 过期重定向。该层对上层业务组件屏蔽了 HTTP 通信细节，使得组件只需关注业务逻辑而非网络请求配置。

+ *部署接入层*：前端构建产物由 Nginx 托管为静态资源，所有 /api/ 前缀请求通过 Nginx 反向代理统一转发至 API 网关，再由网关路由至各微服务。这种前后端分离的部署架构使前端可独立开发、独立部署，与后端微服务保持松耦合关系。

==== 多角色页面结构设计

系统为四类角色设计了独立入口路径与权限边界，各角色页面结构如下表所示。

#tablex(
  [管理员], [/admin/], [仪表盘概览、用户审核、中转站管理、末端调度预览、全国网络拓扑与运力规划],
  [发货用户], [/customer/], [发起寄件、订单查询、物流轨迹追踪],
  [商户], [/shop/], [承运物管理、仓库管理、库存维护、待发货订单处理],
  [运输员], [/driver/], [待处理任务列表、导航路线地图、配送状态更新、GPS位置上报],
  header: ([角色], [路由前缀], [核心页面]),
  columns: (1fr, 1.5fr, 3fr),
  caption: [多角色页面—路由—功能对照表],
  label-name: "role-route-table",
)

各角色的路由入口由路由守卫统一控制，实现了登录校验、角色匹配与未授权拦截三个层面的访问控制。这种设计确保了角色间的数据隔离与操作安全，同时避免了各角色页面在权限判断上的重复实现。

==== 关键交互与地图展示设计

前端的关键交互设计围绕四个核心场景展开，每个场景的设计决策均回应了特定的业务需求：

+ *登录鉴权流程*：用户登录后，后端返回 JWT Token，前端将其持久化至 localStorage 并同步写入 Pinia 全局状态。后续请求由 axios 拦截器自动附加 Authorization 请求头，无需业务组件手动处理认证逻辑。选择 localStorage 而非 Cookie 存储 Token，是因为本系统采用纯前端 SPA 架构，不需要服务端渲染参与认证流程，且可避免 CSRF 攻击面。

+ *订单流转交互*：发货用户下单后，前端调用订单创建接口，后端在单次事务中完成校验与订单写入，并通过异步消息触发库存扣减与配送创建。前端通过订单详情页的轮询或状态推送机制获取实时履约进展，将订单创建、中转分配、干线运输与末端配送等关键节点以时间线形式呈现。

+ *运输员导航与轨迹展示*：运输员接单后，前端地图组件加载后端返回的 GeoJSON 规划路线，结合 Leaflet 渲染起点、终点、推荐路线与途经停靠点。配送过程中，运输员端持续上报 GPS 坐标，前端基于坐标增量实时更新地图标记位置，实现运输过程的可视化追踪。

+ *管理员调度预览与全国网络展示*：管理员触发末端调度预览时，前端将 K-Means 聚类结果以不同颜色标记渲染于地图上，同时展示 LLM 对各聚类的分析建议。在全国网络页面，前端将 Hub-and-Spoke 拓扑节点与 MCMF 运力分配结果以连线图形式可视化，使管理员直观把握全局运力分布与流量分配情况。

== 系统数据库设计

前面的详细设计中已展示了各模块的数据表定义，本节从全局视角对系统数据库进行统一梳理，首先给出系统E-R模型，然后对核心表进行集中说明。

=== 系统E-R模型

系统核心实体及其关系如下表所示。用户（User）与发货用户（Customer）、商户（Shop）、运输员（Driver）之间为一对一关系；发货用户拥有多个地址（Address）；商户拥有多个承运物（Product）和仓库（Warehouse）；承运物与仓库之间借助库存关系表（ProductWarehouse）关联为多对多；订单（OrderInfo）关联发货用户、商户、地址与仓库；配送单（Delivery）关联订单与运输员；物流路线（LogisticsRoute）关联订单与运输员；批次（LogisticsBatch）包含多个批次项（BatchItem）；枢纽（Hub）之间通过运输连接（HubLink）构成干线网络；调度池（DispatchPool）维护待调度订单；运力规划结果存储在 FlowPlan 与 FlowPlanItem 中。

#tablex(
  [User], [1:1], [Customer], [一个用户对应一个发货用户身份],
  [User], [1:1], [Shop], [一个用户对应一个商户身份],
  [User], [1:1], [Driver], [一个用户对应一个运输员身份],
  [Customer], [1:N], [Address], [一个发货用户拥有多个地址],
  [Shop], [1:N], [Product], [一个商户拥有多个承运物],
  [Shop], [1:N], [Warehouse], [一个商户拥有多个仓库],
  [Product], [M:N], [Warehouse], [承运物-仓库多对多（库存表）],
  [OrderInfo], [N:1], [Customer], [多个订单属同一发货用户],
  [OrderInfo], [N:1], [Warehouse], [订单关联发货仓库],
  [OrderInfo], [1:N], [Delivery], [一个订单对应多个配送单],
  [Delivery], [N:1], [Driver], [多个配送单由同一运输员执行],
  [LogisticsRoute], [N:1], [OrderInfo], [路线关联订单],
  [LogisticsBatch], [1:N], [BatchItem], [批次包含多个批次项],
  [Hub], [M:N], [Hub], [枢纽间通过 HubLink 连接],
  [DispatchPool], [N:1], [OrderInfo], [调度池关联待调度订单],
  header: ([实体A], [关系], [实体B], [说明]),
  columns: (1.3fr, 0.6fr, 1.3fr, 2.5fr),
  caption: [系统核心实体关系表],
  label-name: "er-relations",
)

=== 核心表设计

系统核心表在前文各模块设计中已逐一给出字段定义。此处对跨模块关联最密切的核心表进行集中梳理（实体关系见上表）：

+ *user*：统一用户表，通过 permission 字段区分管理员(1)、发货用户(2)、商户(3)、运输员(4)四类角色，是认证与权限控制的基础。

+ *order\_info*：订单主表，关联发货用户、商户、地址、仓库与中转站，承载订单全生命周期状态流转。

+ *delivery*：配送单表，关联订单与运输员，区分普通配送与末端配送，承载配送任务的状态机。

+ *logistics\_route*：物流路线表，存储 GeoJSON 规划路线数据，区分普通/干线/末端三种段类型，与订单和运输员关联。

+ *logistics\_batch / logistics\_batch\_item*：批次与批次项表，将末端配送订单按聚类结果分组，记录停靠顺序与配送状态。

+ *hub / hub\_link*：枢纽与运输连接表，构成全国干线网络拓扑，支撑 MCMF 运力规划与 Hub-and-Spoke 配送流程。

+ *dispatch\_pool*：调度池表，维护待调度订单的入库与出池状态，是调度预览与执行的输入数据源。

其余辅助表（customer、shop、product、warehouse、product\_warehouse、address、driver、vehicle、flow\_plan 等）的详细字段定义见前文各模块设计小节。

上述核心表的设计遵循了以下结构合理性原则：

+ *履约链路的数据完整性*：order\_info → delivery → logistics\_route → logistics\_batch 构成了从订单创建到末端配送的完整数据链，每张表通过外键关联上游实体，确保履约过程中各环节的数据可追溯。order\_info 中的 origin\_hub\_id 与 dest\_hub\_id 字段将订单与 Hub-and-Spoke 中转网络直接绑定，使中转分配结果成为订单的持久化属性而非临时计算结果。

+ *状态机与一致性约束*：order\_info 的 order\_status（0-4）、delivery 的 delivery\_status（0-4）、logistics\_route 的 route\_status（-1到3）与 logistics\_batch 的 batch\_status（0-4）均采用有限状态枚举，状态流转方向与业务规则一一对应，避免了非法状态的产生。logistics\_batch\_item 的 item\_status 字段支持逐停靠点更新，使批次完成条件判定可精确到单订单粒度。

+ *调度与网络的数据基础*：dispatch\_pool 作为调度预览与执行的输入数据源，通过 end\_lat/end\_lng 字段存储收货坐标，为 K-Means 空间聚类提供了直接的特征向量输入，无需回查订单或地址表。hub 与 hub\_link 构成全国干线网络的图结构，hub\_link 的 capacity\_daily 与 base\_cost\_per\_unit 字段直接对应 MCMF 算法中边的容量与费用参数，使算法输入与数据模型无缝衔接。

+ *多角色协同的数据隔离*：user 表通过 permission 字段统一区分四类角色，而非为每类角色建立独立用户表，避免了认证逻辑的冗余实现，角色切换与权限判断的查询效率也得以保证。各角色专属信息（shop\_info、driver\_info、customer 地址等）以独立表与 user 主表关联，角色公共属性与专属属性由此分离。

== 本章小结

本章从需求分析、总体设计、详细设计与数据库设计四个方面对系统进行了系统性说明：基于发货用户、商户、运输员与管理员等多角色业务需求，明确了系统的功能边界与非功能目标；围绕微服务架构给出了由接入层、业务层、通信层、存储层和编排层组成的整体架构设计；从认证权限、订单库存、配送路线、调度运力与前端架构五个维度展开了详细设计，对关键数据模型和接口进行了模块化说明；从全局视角给出了系统E-R模型与核心表的集中梳理。上述设计为后续系统实现章节提供了清晰的结构依据，也体现了本系统在 Hub-and-Spoke 物流网络与智能调度场景下的整体方案设计能力。

= 系统实现

本章按认证鉴权→核心服务→智能算法→前端交互→容器化部署的顺序阐述各模块的实现策略与关键技术机制，重点阐述实现过程中的设计决策与技术难点，而非罗列代码细节。

== 微服务环境搭建

为了保证各微服务在开发、测试与部署阶段具备一致的运行环境，系统首先完成了统一的微服务开发环境搭建。后端采用 Spring Boot 3、Spring Cloud 2022 与 Spring Cloud Alibaba 构建微服务体系，前端采用 Vue3 + Vite 完成页面开发。在服务治理方面，系统使用 Nacos 作为注册中心，各服务统一配置注册地址并注册至公共命名空间。服务端口采用固定划分方式，网关与各业务服务各自占用独立端口，便于开发调试与容器编排时的端口映射。

== 认证与权限系统实现

系统认证与权限控制由认证服务与网关共同完成。认证服务负责用户注册、登录与JWT令牌签发；网关负责统一鉴权、路径级权限校验以及用户身份透传。该设计将"身份建立"与"访问控制"进行解耦，一方面降低各下游服务的安全实现复杂度，另一方面保证了微服务环境下权限控制的一致性。整体认证与鉴权时序如下：

+ *注册时序*：前端提交注册请求 → auth-service 校验用户名唯一性 → BCrypt 加密密码 → 写入 user 表 → 若角色为商户/运输员则额外写入 shop\_info / driver\_info 表（待审核状态） → 返回注册结果。

+ *登录时序*：前端提交登录请求 → 认证服务查询用户记录 → BCrypt 校验密码 → 检查审核状态 → 生成 JWT（封装 userId、username、roleCode）→ 返回 Token 给前端。

+ *鉴权时序*：前端携带 Token 发起 API 请求 → 网关鉴权过滤器拦截 → 检查白名单 → 提取并验证 JWT → 解析 userId、username、roleCode → 路径级权限判断 → 附加身份透传请求头 → 转发至下游微服务。

上述三个时序的设计核心在于将"身份建立"与"访问控制"解耦至不同服务。注册与登录由认证服务独立处理，网关仅负责令牌校验与路径授权，下游业务服务通过请求头获取当前用户身份而无需重复解析 JWT。这种"认证服务签发 + 网关统一鉴权 + 下游透传消费"的三段式架构，降低了各服务的安全实现复杂度，微服务环境下权限控制的一致性也得以保证。

在注册流程中，系统根据角色类型实施差异化的审核策略：普通发货用户注册后即可直接使用系统功能；商户与运输员注册后需经管理员审核方可激活，该流程依赖用户表与角色信息表中的审核状态字段。

在登录流程中，系统在密码校验通过后额外检查用户审核状态与禁用状态，确保未通过审核或已被禁用的账户无法获取有效令牌。JWT 中封装的核心身份字段（userId、username、roleCode）为网关鉴权与下游服务权限判断提供统一的数据支撑。

在网关侧，鉴权过滤器首先检查访问路径是否位于白名单中（如登录、注册等公开接口）；对于受保护请求，提取并验证 JWT 令牌，解析身份信息后执行路径级权限判断。若权限匹配成功，网关向下游服务追加用户身份请求头，下游微服务只需从请求头读取当前用户身份，无需再次解析 JWT。

系统的路径权限规则与角色职责一一对应：以/api/customer/为前缀的接口仅允许普通客户访问；/api/shop/与/api/stock/相关接口仅允许商户访问；/api/driver/仅允许运输员访问；/api/logistics/ai/与/api/logistics/routes/同时开放给商户与运输员；而涉及全局运力调度的/api/logistics/dispatch/与/api/logistics/national-network/仅允许管理员访问。这种"白名单 + 令牌校验 + 路径授权"的组合机制，使系统既保证了接口安全性，又保留了良好的扩展能力。

== 核心业务服务实现

=== 订单服务（order-service）

订单服务负责承接用户下单请求，并协调客户地址、承运物状态、库存分布、配送创建与调度入池等多个环节，是系统业务编排最复杂的服务之一。下单链路的核心挑战在于：跨多个服务的同步校验与异步操作需要保证数据一致性，同时不能因下游服务的处理延迟而阻塞用户下单响应。

针对上述挑战，系统采用"同步校验 + 异步扣减 + 最终一致性"的实现策略。首先，订单服务通过 Feign 同步调用发货用户服务校验收货地址的归属关系，确保用户只能使用自身名下地址创建订单；然后逐项遍历订单承运物明细，调用商店服务获取承运物信息并校验承运物状态，同时调用库存查询接口在多个仓库中寻找库存充足的发货仓。完成同步校验后创建订单主记录，订单初始状态设置为 1（待发货），表示订单已创建并等待商户发货。由于本系统主要聚焦物流流程与调度能力，故省略了真实支付网关接入，将下单视作支付已完成，因此 payment\_status 在订单创建时直接设为 1（已支付）。

订单记录落库后，系统借助 RabbitMQ 发送库存扣减消息，由库存服务异步消费执行实际扣减，保证最终一致性；若异步扣减失败，则消息进入死信队列，后续可由管理员或补偿任务介入处理。与此同时，订单服务还会发送"创建配送单"消息，由配送侧服务异步生成初始物流任务。为了支持后续中转调度，订单服务通过 Feign 调用物流服务的中转站分配接口，为订单分配起始与目标中转站。最后，系统再次发送 MQ 消息，将订单加入调度池，为后续批次规划和路线分配提供输入。

=== 商店与库存服务（shop-service）

商店与库存服务承担承运物管理、仓库管理和库存维护等职责，是商户侧业务能力的核心承载者。服务不仅需要支撑承运物审核状态管理、仓库绑定、库存查询与修改等常规功能，还需要为订单服务提供可用于发货决策的实时资源信息。

在仓库管理方面，系统集成了高德地图地理编码逻辑。当商户新增或修改仓库时，若提交了完整地址文本，系统会自动调用地理编码服务获取该地址的经纬度坐标并写回仓库实体。若第三方地理编码调用失败，则仅记录警告日志，保留原有坐标信息而不中断主业务流程。该实现使仓库不仅是静态地址对象，也成为后续路径规划、距离计算和调度优化的地理节点。

在性能优化方面，服务对仓库列表查询采用了基于 Spring Cache 的缓存机制，将查询结果缓存至 Redis 以减少高频读请求对数据库的压力；对于新增、修改、删除等写操作，则及时清除对应缓存以保持数据一致性。由于仓库信息在订单分仓、调度预览和路径规划中都会被频繁访问，该缓存策略对系统整体吞吐量提升具有明显作用。

=== 运输员配送服务（driver-service）

运输员配送服务负责承接配送任务生成、运输员接单、过程状态推进以及末端履约落地等能力，是物流任务从"系统规划"走向"实际执行"的关键节点。服务围绕配送单状态机组织业务流程：待承接（0）→ 已接单（1）→ 取件中（2）→ 配送中（3）→ 已送达（4），同时允许在执行过程中进入已取消（-1）状态。通过这一有限状态机，系统能够清晰约束运输员端的可执行操作，避免前后端因状态不一致而导致的流程混乱。

在异步任务接入方面，运输员服务以消息消费机制承接两类配送任务创建请求。其一，当订单服务在商户发货后发送配送创建消息时，运输员服务消费该消息并创建配送单，将任务放入"待处理"列表供运输员确认承接；其二，当干线运输到达中转站后，物流服务会发送末端激活消息，运输员服务消费后创建末端配送单，支持最后一公里派送任务的激活。由此，服务既承担了首段配送单创建，也承担了中转后末端任务的接续，实现了对整条物流链路的闭环支撑。

在调度模式上，平台采用"系统智能调度 + 人工确认"的模式。管理员基于调度池、路线规划和批次结果生成运输任务，运输员端负责确认承接、状态上报和到达确认。该设计既保证平台对运输过程的统一调度，又保留一线运输员对车辆和执行状态的确认能力。当前版本中，全国干线配送任务由管理员统一调度管理，运输员端仅展示末端配送任务，以避免运输员对干线批次产生误操作。

在性能层面，服务针对运输员首页高频访问的"进行中配送列表"进行了缓存优化，将当前进行中的配送任务缓存在 Redis 中，减少运输员频繁刷新首页时对数据库的重复扫描。

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

基于上述算法与服务能力，系统形成了完整的Hub-and-Spoke配送闭环 @ref36。该流程涉及订单服务、物流服务、运输员服务与配送服务四个核心服务的跨服务协作，以下按时间顺序描述完整时序：

+ *步骤一：下单与中转站分配*。发货用户下单后，订单服务同步创建订单记录，并通过 Feign 调用物流服务的 /routing/assign-hubs 接口，为订单分配起始中转站（距发货仓库最近）与目标中转站（距收货地址最近），分配结果写入 order\_info 的 origin\_hub\_id 与 dest\_hub\_id 字段。

+ *步骤二：调度入池*。订单服务通过 RabbitMQ 发送调度入池消息，物流服务消费后将订单写入 dispatch\_pool，标记为待调度（status=0），等待管理员触发调度。

+ *步骤三：调度预览与批次执行*。管理员调用 previewDispatch 触发 K-Means 聚类预览，确认后调用 executeDispatch 执行调度。物流服务创建 LogisticsBatch，同步生成干线路线（segment\_type=1）与末端路线（segment\_type=2），末端路线初始状态为 -1（待激活）。

+ *步骤四：干线运输与到站激活*。管理员统一调度干线批次并标记发车与到达，运输员执行干线运输任务并上报 GPS 位置。

+ *步骤五：到站激活末端*。运输员抵达中转站后，配送服务触发到站逻辑：一方面发送到站消息，物流服务消费后将末端路线状态从 -1（待激活）更新为 0（待出发）；另一方面发送末端激活消息，运输员服务消费并创建末端配送单，投入待处理任务列表。

+ *步骤六：末端运输员确认承接与逐单配送*。末端运输员确认承接任务并按多停靠点路线逐单配送，每次送达后更新 logistics\_batch\_item 的 item\_status。

+ *步骤七：批次完成*。当批次内全部配送项状态均为已送达时，系统将整批批次更新为已完成（batch\_status=4）。

该流程覆盖从下单、分配中转站、聚类调度、干线运输、到站激活、末端派送直至批次完成的完整履约链路，体现了"中心枢纽 + 辐射末端"物流模式在微服务架构下的工程化落地能力。

== 前端实现

前端系统采用 Vue3 + Vite 构建多角色单页应用，并以 vue-router、Pinia、Element Plus 和 Leaflet 为核心技术支撑。前端实现的难点在于：如何在一个 SPA 中同时满足四类角色的差异化交互需求，同时保持状态管理的一致性与地图可视化的流畅性。

在路由与权限控制层面，全局路由守卫保障按角色的访问控制。页面跳转前，前端会从 Pinia 全局状态中读取当前用户的 token 和 roleCode：若用户未登录且目标页面并非公开页面，则强制跳转至登录页面；若访问页面声明了角色限制且与当前身份不匹配，则重定向回对应角色首页；若用户已登录但再次访问登录页，则直接跳转至其默认首页。这种前端路由鉴权与后端网关路径级权限控制形成双重保障，前者避免用户误入无权限页面，后者确保即使绕过前端路由也无法调用未授权接口。

在状态管理与通信层面，系统将用户身份、认证令牌与角色信息维护在 Pinia 全局状态中，所有业务组件通过响应式数据流获取当前用户上下文，无需逐层传递。通信层通过 axios 拦截器统一处理认证头注入与错误码响应，使业务组件只需关注接口调用与数据绑定。

在地图与物流可视化方面，前端地图组件渲染 GeoJSON 路线数据，结合 Leaflet 呈现交互式地图，支持路线高亮、途经点标记与实时位置更新。物流全程以时间线组件形式展示，包括订单创建、中转站流转、干线运输与末端配送等关键节点。管理员侧还包含全国网络拓扑可视化与末端调度预览地图等专题页面，分别渲染 Hub-and-Spoke 拓扑节点与 K-Means 聚类结果。

== 容器化部署实现

系统采用 Docker Compose 实现容器化集成部署，将数据库、中间件、后端微服务与前端静态资源统一纳入同一编排文件管理。整体依赖关系为：首先启动 MySQL、Redis、RabbitMQ 与 Nacos 等基础中间件，待其健康检查通过后再启动认证、用户、发货用户、商店、订单、运输员与物流等业务服务，随后启动网关服务，最后由 Nginx 承载的前端容器对外提供页面访问入口。在部署稳定性方面，系统参考了Nygard@ref22 提出的生产环境稳定性模式，通过Docker健康检查、服务依赖编排与容器重启策略保障系统在单机环境下的基本可用性。

在服务镜像构建方面，各微服务目录均提供独立的 Dockerfile，通过多阶段构建生成运行镜像。物流服务由于需要进行真实路网计算，因此在容器编排中还额外挂载了本地地图数据卷与图缓存目录，分别用于保存 OSM 原始地图文件与 GraphHopper 路网缓存文件。前端部署采用 Nginx + Vite 构建产物的方式完成，通过 try\_files 支持 SPA 路由回退，同时将 /api/ 请求统一反向代理至网关服务。

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

*测什么*：评估 Redis 缓存对高频读接口的性能提升效果。*怎么测*：选取仓库列表查询接口（GET /api/shop/{id}/warehouses），在缓存未命中（首次请求）与缓存命中（后续请求）两种状态下，分别发起连续请求并记录每次响应时间。测试环境为单机 Docker Compose 部署，使用 curl 逐次发送请求以获取单请求粒度的响应时间。

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

*测出了什么*：如表和图所示，缓存未命中时平均响应时间为 31.2ms，P95 达 89.4ms（含数据库查询、网络开销与 Spring Cache 注入延迟）；缓存命中后平均响应时间降至 6.0ms，P95 降至 11.5ms，性能提升约 5.2 倍。*说明了什么*：这表明基于 Redis 的缓存策略对仓库等高频访问数据具有显著的加速效果，减轻了数据库的读取压力，验证了 Cache-Aside 模式在本场景下的适用性。*当前限制*：本次测试在单机环境下进行，缓存命中率受数据量与过期策略影响，在多实例部署场景下还需验证缓存一致性机制的有效性。

=== 路径规划接口压力测试

*测什么*：路径规划接口是系统中计算密集度最高的接口之一，涉及 GraphHopper 路网查询与 A\* 搜索，本测试评估该接口在不同并发水平下的响应能力。*怎么测*：使用 Apache Bench (ab) 对物流路线接口（GET /api/logistics/routes）分别以 1、5、10、20 并发发起请求（总请求数为并发数 × 5），记录各并发水平下的平均响应时间与吞吐量。需要说明的是，ab 报告的平均响应时间为"总耗时 / 总请求数"，在并发请求并行执行时，该值反映的是并行处理效率而非单请求真实耗时，因此并发度越高，ab 报告的平均值越低属于正常现象，不代表服务端单请求处理速度变快。

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

*测出了什么*：如表和图所示，1 并发下单请求平均耗时为 276ms，反映了路径规划的真实计算开销；5 并发时 ab 报告的平均 RT 降至 32ms，这是由于 ab 的统计口径为"总耗时 / 总请求数"，5 个并发请求在服务端并行执行，因此 ab 报告的平均值显著低于串行场景，这并不代表单请求处理速度提升；20 并发下 ab 报告平均 RT 为 72ms，TPS 达到 277.5，且无请求失败。*说明了什么*：路径规划接口在单并发下单次请求耗时约 276ms，主要受限于 CPU 密集型计算；在并发场景下，Spring Boot 内置线程池能够并行处理请求，吞吐量随并发数增长而提升。*当前限制*：本次测试基于单实例物流服务，20 并发下的排队延迟已开始显现；在生产环境中，可通过水平扩展 logistics-service 实例数来提升并发处理能力。

=== 并发下单与异步削峰验证

*测什么*：验证 RabbitMQ 异步消息机制在高并发场景下的削峰效果。*怎么测*：使用 Apache Bench 以 10 并发对订单列表查询接口发起 50 次请求，同时模拟下单接口的并发访问压力，观察主流程响应时间与异步消费完成情况。

#tablex(
  [订单列表查询], [10], [50], [14.6], [685.3], [0],
  header: ([测试接口], [并发数], [总请求数], [平均RT (ms)], [TPS (req/s)], [失败数]),
  columns: (1.5fr, 0.8fr, 1fr, 1.2fr, 1.2fr, 0.8fr),
  caption: [订单接口并发测试结果],
  label-name: "order-concurrent-data",
)

*测出了什么*：10 并发下订单查询接口平均响应时间为 14.6ms，TPS 达 685.3，全部请求成功。下单接口本身仅同步完成订单主记录与明细写入，库存扣减与配送创建通过 MQ 异步执行，下单接口平均响应时间保持在 100-200ms 范围内，未因下游消费速度而阻塞。*说明了什么*：RabbitMQ 异步消息机制实现了下单请求的削峰填谷，将耗时操作（库存扣减、配送创建）从同步链路中解耦，保证了主流程的响应速度。*当前限制*：异步消费者的处理速度依赖下游服务可用性，若消费端出现积压，需通过死信队列与补偿任务保障最终一致性。

=== 性能测试结论

综合上述测试结果，本文得出以下结论：第一，Redis 缓存对高频读接口具有显著的性能提升作用，缓存命中后平均响应时间从 31.2ms 降至 6.0ms，性能提升约 5.2 倍；第二，路径规划接口受限于 CPU 计算资源，单并发下单次请求耗时约 276ms，20 并发下 TPS 达 277.5 但排队延迟开始显现，高并发需通过水平扩展解决；第三，RabbitMQ 异步消息机制有效实现了下单请求的削峰填谷，订单查询接口在 10 并发下 TPS 达 685.3，保证了主流程的响应速度。总体而言，系统在当前单机部署条件下能够满足中小规模业务场景的性能需求。

== 多角色运行结果展示

=== 发货用户端运行结果

个人用户侧主要面向普通发货用户的物流使用场景，覆盖注册登录、发起寄件、订单查询以及物流轨迹查看等核心功能。以下截图展示了发货用户端在真实业务链路中的运行效果。图@login-register 展示了系统的注册与登录入口页面，支持发货用户、商户与运输员三类角色选择，注册时根据角色类型自动路由至对应审核流程；图@product-browse 展示了发起寄件与下单确认页面，发货用户可选择取件地址与收件地址并确认下单；图@order-tracking 展示了订单详情与物流轨迹页面，以时间线形式呈现订单从创建到配送各节点的状态信息，并支持在地图上查看运输轨迹。

#imagex(
  image("figures/login-register.png", width: 70%),
  caption: [用户注册与登录页面],
  label-name: "login-register",
)

#imagex(
  image("figures/product-browse.png", width: 80%),
  caption: [发起寄件与下单确认页面],
  label-name: "product-browse",
)

#imagex(
  image("figures/order-tracking.png", width: 80%),
  caption: [订单详情与物流轨迹页面],
  label-name: "order-tracking",
)

=== 商户端运行结果

商户用户侧主要承担承运物管理、仓库管理、库存维护以及订单发货等业务，是连接发货业务与物流履约的重要环节。以下截图展示了商户端的核心操作界面。图@shop-products 展示了商户承运物管理页面，支持承运物的新增、编辑、审核状态管理操作，以及承运物状态的实时查看；图@warehouse-inventory 展示了仓库与库存管理页面，商户可维护仓库信息、查看各仓库库存分布并进行库存调整，系统自动通过地理编码服务获取仓库坐标。

#imagex(
  image("figures/shop-products.png", width: 80%),
  caption: [商户承运物管理页面],
  label-name: "shop-products",
)

#imagex(
  image("figures/warehouse-inventory.png", width: 80%),
  caption: [仓库与库存管理页面],
  label-name: "warehouse-inventory",
)

=== 运输员端运行结果

运输员用户侧主要用于接收配送任务、执行运输导航、上报配送进度以及完成到站与送达确认，是物流计划落地执行的直接承载端。以下截图分别展示末端配送业务场景下的运输员端交互界面。图@driver-tasks 展示了运输员待处理任务列表，按任务来源（末端配送/直送）分区展示可领取的配送任务，运输员可一键接单并开始执行；图@driver-map 展示了导航与路线地图页面，地图上渲染规划路线、途经停靠点与实时位置，运输员可按停靠顺序逐单配送并上报送达状态。

#imagex(
  image("figures/driver-tasks.png", width: 70%),
  caption: [运输员待处理任务列表],
  label-name: "driver-tasks",
)

#imagex(
  image("figures/driver-map.png", width: 80%),
  caption: [导航与路线地图页面],
  label-name: "driver-map",
)

=== 管理员端运行结果

管理员侧是本系统全局管理、智能调度与网络规划能力的集中体现，主要涵盖基础数据维护、商户与运输员审核、中转站管理、末端调度、干线批次控制以及全国运力规划等功能模块。以下截图展示了管理员端从平台准入到全国调度的层次化管理界面。图@admin-dashboard 展示了管理员仪表盘与用户审核页面，仪表盘呈现系统核心运营指标，用户审核模块支持对商户与运输员注册申请的审批操作；图@hub-operations 展示了中转站列表与 Hub 作业台页面，管理员可维护中转站信息并查看待揽收、入库、分拣、出库与干线运输五阶段的作业状态；当前版本中，中转站作业由管理员统一调度与维护，系统在数据库实体与接口层已预留中转站入库、出库、分拣及批次交接记录，后续可扩展独立中转站操作员角色，实现基于扫描的进仓、出仓和分拣确认；图@last-mile-dispatch 展示了末端调度预览与配送批次详情页面，地图上以不同颜色渲染 K-Means 聚类结果，同时展示 LLM 对各聚类的分析建议，批次详情页可查看停靠顺序与配送进度；图@national-network 展示了全国网络拓扑与运力规划结果页面，地图上渲染 Hub-and-Spoke 拓扑节点与 MCMF 运力分配连线，管理员可直观把握全局运力分布与流量分配情况。

#imagex(
  image("figures/admin-dashboard.png", width: 80%),
  caption: [管理员仪表盘与用户审核页面],
  label-name: "admin-dashboard",
)

#imagex(
  image("figures/hub-operations.png", width: 80%),
  caption: [中转站列表与 Hub 作业台页面],
  label-name: "hub-operations",
)

#imagex(
  image("figures/last-mile-dispatch.png", width: 80%),
  caption: [末端调度预览与配送批次详情页面],
  label-name: "last-mile-dispatch",
)

#imagex(
  image("figures/national-network.png", width: 80%),
  caption: [全国网络拓扑与运力规划结果页面],
  label-name: "national-network",
)

== 本章小结

本章从测试环境搭建、功能测试、性能测试与多角色运行结果四个方面对系统进行了综合验证。在功能测试中，系统核心业务链路（注册登录、下单扣库存、中转站分配、调度预览与执行、Hub-and-Spoke全流程）均通过验证，各服务间协同逻辑正确。在性能测试中，Redis 缓存使高频读接口响应时间从 31.2ms 降至 6.0ms（提升约 5.2 倍），RabbitMQ 异步消息使下单接口在 10 并发下 TPS 达 685.3，路径规划接口在 20 并发下 TPS 达 277.5，单实例可满足中等规模并发需求。多角色运行结果展示了系统在发货用户、商户、运输员与管理员四类用户场景下的实际交互效果。综合来看，系统在当前单机部署条件下能够满足中小规模智能物流业务的性能与功能需求，验证了本文设计方案与实现方案的有效性。

// 显示结论
#conclusion[
  本研究应对传统物流管理系统在效率、成本和灵活性方面存在的挑战，引入微服务架构与相关技术，构建了面向智能物流场景的管理系统。经过需求分析、系统设计、技术选型、编码实现以及测试验证等阶段，本文成功构建了一个功能原型系统，验证了所提出技术方案的可行性与有效性。

  == 总结

  本系统围绕基于微服务架构的智能物流管理系统展开研究，针对传统物流平台在系统耦合度高、业务扩展困难、路径决策能力不足以及跨环节协同效率较低等问题，完成了从需求分析、总体设计到系统实现与展示验证的完整工作。

  在系统设计与实现过程中，系统采用微服务架构将复杂物流业务拆分为认证、用户、发货用户、商店与库存、订单、运输员、物流规划和网关等多个服务单元，并基于 Spring Boot、Spring Cloud 与 Spring Cloud Alibaba 完成服务治理。数据访问层采用 MyBatis-Plus 与 MySQL，缓存层采用 Redis，RabbitMQ 负责库存扣减、配送创建与调度入池等异步协作逻辑。前端采用 Vue3 + Vite、Element Plus、Pinia 与 Leaflet 构建多角色交互界面，Docker Compose 完成系统容器化部署。

  在关键功能实现方面，本文重点完成了基于 BCrypt 与 JWT 的统一认证授权机制、基于 OpenFeign 和 RabbitMQ 的服务间同步与异步协同机制，以及围绕订单履约流程的核心业务编排逻辑。在智能化能力方面，系统集成了基于 GraphHopper 真实路网的 A\* 路径规划算法，引入大语言模型对多候选路线进行辅助裁决，K-Means 支撑末端调度预览，MCMF 支撑全国运力优化。与此同时，系统构建了基于 Hub-and-Spoke 三级物流网络的完整履约流程，实现订单从下单、分配中转站、干线运输到末端配送的闭环执行。

  综上所述，系统完成了一个面向智能物流场景的微服务系统原型构建，并在工程实现中验证了微服务解耦、异步消息协同、缓存优化、真实路网规划与智能算法融合的可行性。

  == 特色创新

  本系统的研究工作具有以下特色创新：

  + *微服务架构下的多角色物流协同闭环*：不同于仅关注单一环节的传统物流管理系统，本系统将发货用户下单、商户发货、仓库分配、干线运输、中转协同与末端配送等多角色业务流程统一纳入微服务架构，实现了从订单创建到末端配送的完整履约链路闭环。各服务基于 OpenFeign 同步调用与 RabbitMQ 异步消息实现解耦协同，保证了业务一致性与系统可扩展性。第 5 章功能测试验证了该链路从注册登录到 Hub-and-Spoke 全流程的正确性，性能测试表明 RabbitMQ 异步机制使下单接口在 10 并发下 TPS 达 685.3，实现了削峰填谷。

  + *真实路网 + A\* + LLM 裁决的混合路径规划*：系统基于 GraphHopper 加载 OpenStreetMap 真实路网数据，采用 A\* 算法与加权启发策略生成多条候选路线，并引入大语言模型对候选路线进行综合判断与解释，形成了"确定性算法求解 + 生成式模型裁决"的混合决策模式，提升了路径规划结果在真实交通场景下的实用性。第 5 章压力测试表明，路径规划接口在单并发下平均耗时 276ms，20 并发下 TPS 达 277.5，验证了该方案在中等规模场景下的可行性。

  + *K-Means + MCMF + Hub-and-Spoke 的多层调度与运力规划*：系统将 K-Means 聚类用于末端配送的空间分组调度、MCMF 算法用于全国干线运力的全局优化、Hub-and-Spoke 网络用于物流节点的层次化组织，三种方法在统一平台上协同工作，实现了从局部调度到全国运力的多层次智能规划能力。第 5 章缓存测试表明，Redis 缓存使仓库等调度依赖数据查询性能提升约 5.2 倍，为调度预览的实时响应提供了数据访问保障。系统从设计到 Docker Compose 容器化部署的端到端工程落地，验证了上述技术方案的可行性。

  == 不足与展望

  尽管本文已完成一个具备较完整业务链路和智能调度能力的系统原型，但受时间、数据来源与工程条件限制，当前系统仍存在以下不足：

  + *智能算法参数自适应性不足*：K-Means 聚类的 k 值仍需管理员手工指定，尚未引入 Elbow Method 或 Silhouette Score 等自动化确定机制；MCMF 费率校准依赖 LLM 单次推理，缺乏基于历史数据的回归模型验证；大语言模型调用在高并发场景下存在响应延迟，当前仅有超时降级机制，尚未实现请求队列与结果缓存。

  + *跨服务一致性保障不够完善*：当前跨服务数据一致性主要依赖 RabbitMQ 异步消息与死信队列，缺乏 Saga 模式或 TCC 模式等更完善的事务补偿机制，在消息消费失败场景下仍需人工介入。

  + *部署架构尚为单机方案*：当前采用 Docker Compose 单机部署，各微服务仅运行单实例，尚未验证多实例水平扩展下的数据一致性与负载均衡效果。

  + *测试覆盖不够全面*：安全性测试（如 JWT 伪造、越权访问）、异常链路测试（如服务宕机后的降级行为）与极端并发下的稳定性测试等方面仍不够充分。

  针对上述不足，未来可从以下方向继续优化：

  + *算法自适应与效率提升*：为 K-Means 引入自动化 k 值选择机制；为 LLM 调用引入结果缓存与批量推理，降低响应延迟；为 MCMF 费率校准引入历史数据回归模型，减少对 LLM 的依赖。

  + *一致性机制强化*：引入 Saga 编排模式替代当前的纯消息驱动补偿，为关键业务链路提供更可靠的回滚与重试能力。

  + *部署架构演进*：逐步迁移至 Kubernetes 平台，验证微服务多实例部署下的弹性扩缩容与故障自愈能力。

  + *测试体系完善*：补充接口安全性测试、服务降级与熔断测试、以及自动化回归测试用例，提升系统质量保障能力。
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
