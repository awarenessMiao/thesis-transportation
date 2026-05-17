#import "@preview/mmdr:0.2.2": mermaid
#import "../lib.typ": imagex
#set page(width: auto, height: auto, margin: 10pt)

#imagex(
  mermaid("
erDiagram
    OrderInfo }o--|| Customer : initiates
    OrderInfo }o--|| Shop : belongs_to
    OrderInfo }o--|| Address : delivers_to
    OrderInfo }o--|| Warehouse : ships_from

    OrderInfo ||--o{ Delivery : generates
    OrderInfo ||--o{ LogisticsRoute : plans
    Delivery }o--|| Driver : executed_by
    LogisticsRoute }o--|| Driver : assigned_to

    User ||--o| Customer : identifies
    User ||--o| Shop : identifies
    User ||--o| Driver : identifies
    Customer ||--o{ Address : owns

    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores

    DispatchPool ||--o{ OrderInfo : queues
    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links

    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
  "),
  caption: [系统核心实体E-R图],
  label-name: "er-diagram",
)
