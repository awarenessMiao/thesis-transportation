#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 10pt)

// 优化顺序：Mermaid是Dagre布局，最先定义的实体在上方。
// 把处于中心的 OrderInfo 和 User 隔开。
// 减少互相交叉
#mermaid("
erDiagram
    %% Users & Roles (Top Left)
    User ||--o| Customer : identifies
    User ||--o| Shop : identifies
    User ||--o| Driver : identifies
    Customer ||--o{ Address : owns

    %% Inventory (Top Right)
    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores

    %% Core Order (Center)
    Customer ||--o{ OrderInfo : initiates
    Shop ||--o{ OrderInfo : belongs_to
    Warehouse ||--o{ OrderInfo : ships_from

    %% Delivery & Route (Bottom Left)
    OrderInfo ||--o{ Delivery : generates
    OrderInfo ||--o{ LogisticsRoute : plans
    Driver ||--o{ Delivery : executed_by
    Driver ||--o{ LogisticsRoute : assigned_to

    %% Dispatch & Network (Bottom Right)
    DispatchPool ||--o{ OrderInfo : queues
    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links
    
    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
")