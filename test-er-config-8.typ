#import "@preview/mmdr:0.2.2": *

#set page(width: auto, height: auto, margin: 10pt)

#mermaid("
%%{init: {'theme': 'default', 'themeVariables': {'edgeLabelBackground': 'transparent'}}}%%
erDiagram
    OrderInfo ||--o{ Delivery : generates
    Delivery }o--|| Driver : executed_by
")
