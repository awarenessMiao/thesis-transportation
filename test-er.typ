#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 10pt)

#mermaid("
erDiagram
    User ||--o| Customer : has
    User ||--o| Shop : has
    User ||--o| Driver : has
    Customer ||--o{ Address : has

    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores

    OrderInfo }o--|| Customer : initiates
    OrderInfo }o--|| Shop : belongs_to
    OrderInfo }o--|| Address : delivers_to
    OrderInfo }o--|| Warehouse : ships_from
    OrderInfo ||--o{ Delivery : has
    OrderInfo ||--o{ LogisticsRoute : has
    Delivery }o--|| Driver : executed_by
    LogisticsRoute }o--|| Driver : assigned_to

    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links
    DispatchPool ||--o{ OrderInfo : maintains

    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
")
