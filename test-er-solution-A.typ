#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 10pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  
  // 图 1：用户与角色域
  figure(
    mermaid("
erDiagram
    User ||--o| Customer : identifies
    User ||--o| Shop : identifies
    User ||--o| Driver : identifies
    Customer ||--o{ Address : owns
    "),
    caption: "用户与角色域"
  ),

  // 图 2：商品与库存域
  figure(
    mermaid("
erDiagram
    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores
    "),
    caption: "商品与库存域"
  ),

  // 图 3：订单与配送域
  figure(
    mermaid("
erDiagram
    OrderInfo }o--|| Customer : initiates
    OrderInfo }o--|| Shop : belongs_to
    OrderInfo }o--|| Warehouse : ships_from
    OrderInfo ||--o{ Delivery : generates
    OrderInfo ||--o{ LogisticsRoute : plans
    Delivery }o--|| Driver : executed_by
    LogisticsRoute }o--|| Driver : assigned_to
    "),
    caption: "订单与配送域"
  ),

  // 图 4：调度与网络域
  figure(
    mermaid("
erDiagram
    DispatchPool ||--o{ OrderInfo : queues
    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links
    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
    "),
    caption: "调度与网络域"
  )
)