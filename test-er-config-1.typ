#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 5pt)

#mermaid("
%%{init: {'er': {'layoutDirection': 'LR'}}}%%
erDiagram
    OrderInfo }o--|| Customer : initiates
    OrderInfo }o--|| Shop : belongs_to
    OrderInfo }o--|| Warehouse : ships_from
    OrderInfo ||--o{ Delivery : generates
    OrderInfo ||--o{ LogisticsRoute : plans
    Delivery }o--|| Driver : executed_by
    LogisticsRoute }o--|| Driver : assigned_to
")
