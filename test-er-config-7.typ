#import "@preview/mmdr:0.2.2": *

#set page(width: auto, height: auto, margin: 10pt)

#mermaid("
%%{init: {'theme': 'default', 'er': {'layoutDirection': 'TB', 'minEntityWidth': 160, 'nodeSpacing': 150, 'rankSpacing': 150}}}%%
erDiagram
    OrderInfo ||--o{ Delivery : generates
    Delivery }o--|| Driver : executed_by
")
