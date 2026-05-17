#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 5pt)

#mermaid("
erDiagram
    Shop ||--o{ Product : manages
    Shop ||--o{ Warehouse : manages
    Product ||--o{ ProductWarehouse : stored_in
    Warehouse ||--o{ ProductWarehouse : stores
")