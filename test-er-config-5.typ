#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 5pt)

#mermaid("
erDiagram
    OrderInfo }o--|| Customer : \" <br><br> initiates <br><br> \"
    OrderInfo }o--|| Shop : \" <br><br> belongs_to <br><br> \"
    OrderInfo }o--|| Warehouse : \" <br><br> ships_from <br><br> \"
    OrderInfo ||--o{ Delivery : \" <br><br> generates <br><br> \"
    OrderInfo ||--o{ LogisticsRoute : \" <br><br> plans <br><br> \"
    Delivery }o--|| Driver : \" <br><br> executed_by <br><br> \"
    LogisticsRoute }o--|| Driver : \" <br><br> assigned_to <br><br> \"
")