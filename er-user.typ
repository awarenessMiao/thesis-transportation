#import "@preview/mmdr:0.2.2": mermaid
#set page(width: auto, height: auto, margin: 5pt)

#mermaid("
erDiagram
    User ||--o| Customer : identifies
    User ||--o| Shop : identifies
    User ||--o| Driver : identifies
    Customer ||--o{ Address : owns
")