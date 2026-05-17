#set page(width: auto, height: auto, margin: 10pt)
#set text(font: ("Times New Roman", "Songti SC"), size: 10pt)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align: center + horizon,
  
  figure(image("er-user.png", width: 100%), caption: "用户与角色域"),
  figure(image("er-inventory.png", width: 100%), caption: "商品与库存域"),
  figure(image("er-order.png", width: 100%), caption: "订单与配送域"),
  figure(image("er-dispatch.png", width: 100%), caption: "调度与网络域")
)