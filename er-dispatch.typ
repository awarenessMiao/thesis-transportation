#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 5pt)

#mermaid("
erDiagram
    DispatchPool ||--o{ OrderInfo : queues
    LogisticsBatch ||--o{ BatchItem : contains
    BatchItem ||--|| OrderInfo : links
    Hub ||--o{ HubLink : is_source
    Hub ||--o{ HubLink : is_target
    FlowPlan ||--o{ FlowPlanItem : contains
")