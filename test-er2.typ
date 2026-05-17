#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 10pt)

#mermaid("
erDiagram
    %% Core Order Domain in Center
    OrderInfo }o--|| Customer : initiates
    OrderInfo }o--|| Shop : belongs_to
    OrderInfo }o--|| Address : delivers_to
    OrderInfo }o--|| Warehouse : ships_from

    %% Order execution
    OrderInfo ||--o{ Delivery : generates
    OrderInfo ||--o{ LogisticsRoute : plans
    Delivery }o--|| Driver : executed_by
    LogisticsRoute }o--|| Driver : assigned_to

    %% User & Roles Domain
    User ||--o| Customer : identifies
    User ||--o| Shop : identifies
    User ||--o| Driver : identifies
    Customer ||--o{ Address : owns

    %% Inventory Domain
    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores

    %% Dispatch Domain
    DispatchPool ||--o{ OrderInfo : queues
    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links

    %% Network & Flow Domain
    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
")
