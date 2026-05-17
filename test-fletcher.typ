#import "@preview/fletcher:0.5.3" as fletcher: node, edge
#set page(width: auto, height: auto, margin: 5pt)

#fletcher.diagram(
  node-stroke: 1pt,
  edge-stroke: 1pt,
  node-corner-radius: 2pt,
  node((0,0), "OrderInfo"),
  node((2,0), "Customer"),
  edge((0,0), (2,0), "->", label: "initiates")
)