from __future__ import annotations

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path("/Users/miao/CodeBuddy/thesis-transportation")
FIG_DIR = ROOT / "template" / "figures"
FONT_CANDIDATES = [
    Path("/System/Library/Fonts/Hiragino Sans GB.ttc"),
    Path("/System/Library/Fonts/STHeiti Light.ttc"),
]
FONT_PATH = next(path for path in FONT_CANDIDATES if path.exists())

TEXT = "#2f2f2f"
MUTED = "#666666"
BORDER = "#8b8b8b"
GRID = "#bdbdbd"
LINE = "#7a7a7a"
PANEL = "#f5f5f5"
LABEL_FILL = "#fafafa"
ROW_FILL = "#fcfcfc"
BOX_FILL = "#ffffff"

DOMAIN_STYLES = {
    "user": ("#eaf2ff", "#6b8ec9"),
    "inventory": ("#eef7ec", "#6ea56b"),
    "order": ("#fff3e8", "#d68952"),
    "dispatch": ("#f3edff", "#8b71c5"),
}


def font(size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONT_PATH), size=size)


def fit_font(
    draw: ImageDraw.ImageDraw,
    text: str,
    max_width: int,
    max_height: int,
    start: int,
    min_size: int = 16,
    align: str = "center",
) -> ImageFont.FreeTypeFont:
    size = start
    while size >= min_size:
        current = font(size)
        spacing = max(5, size // 4)
        bbox = draw.multiline_textbbox((0, 0), text, font=current, align=align, spacing=spacing)
        width = bbox[2] - bbox[0]
        height = bbox[3] - bbox[1]
        if width <= max_width and height <= max_height:
            return current
        size -= 2
    return font(min_size)


def draw_fitted_text(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    text: str,
    *,
    fill: str = TEXT,
    size: int = 34,
    min_size: int = 16,
    align: str = "center",
    padding: int = 14,
) -> None:
    x0, y0, x1, y1 = box
    current = fit_font(draw, text, x1 - x0 - padding * 2, y1 - y0 - padding * 2, size, min_size=min_size, align=align)
    spacing = max(5, current.size // 4)
    bbox = draw.multiline_textbbox((0, 0), text, font=current, align=align, spacing=spacing)
    width = bbox[2] - bbox[0]
    height = bbox[3] - bbox[1]
    x = x0 + (x1 - x0 - width) / 2 if align == "center" else x0 + padding
    y = y0 + (y1 - y0 - height) / 2
    draw.multiline_text((x, y), text, font=current, fill=fill, align=align, spacing=spacing)


def rounded_panel(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    *,
    fill: str = BOX_FILL,
    outline: str = BORDER,
    width: int = 2,
    radius: int = 16,
) -> None:
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)


def rounded_box(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    text: str,
    *,
    fill: str = BOX_FILL,
    outline: str = GRID,
    width: int = 2,
    radius: int = 14,
    size: int = 34,
) -> None:
    rounded_panel(draw, box, fill=fill, outline=outline, width=width, radius=radius)
    draw_fitted_text(draw, box, text, size=size, min_size=18)


def label_chip(
    draw: ImageDraw.ImageDraw,
    center: tuple[int, int],
    text: str,
    *,
    fill: str = BOX_FILL,
    outline: str = GRID,
    text_fill: str = MUTED,
    size: int = 22,
) -> None:
    current = font(size)
    bbox = draw.textbbox((0, 0), text, font=current)
    w = bbox[2] - bbox[0] + 28
    h = bbox[3] - bbox[1] + 16
    x, y = center
    box = (x - w // 2, y - h // 2, x + w // 2, y + h // 2)
    draw.rounded_rectangle(box, radius=12, fill=fill, outline=outline, width=2)
    draw.text((box[0] + 14, box[1] + 8), text, font=current, fill=text_fill)


def anchor(box: tuple[int, int, int, int], side: str, ratio: float = 0.5) -> tuple[int, int]:
    x0, y0, x1, y1 = box
    if side == "top":
        return int(x0 + (x1 - x0) * ratio), y0
    if side == "bottom":
        return int(x0 + (x1 - x0) * ratio), y1
    if side == "left":
        return x0, int(y0 + (y1 - y0) * ratio)
    return x1, int(y0 + (y1 - y0) * ratio)


def draw_connection(
    draw: ImageDraw.ImageDraw,
    points: list[tuple[int, int]],
    *,
    start_card: tuple[str, tuple[int, int]] | None = None,
    end_card: tuple[str, tuple[int, int]] | None = None,
    mid_label: tuple[str, tuple[int, int]] | None = None,
    width: int = 3,
) -> None:
    draw.line(points, fill=LINE, width=width)
    if start_card:
        label_chip(draw, start_card[1], start_card[0], size=20)
    if end_card:
        label_chip(draw, end_card[1], end_card[0], size=20)
    if mid_label:
        label_chip(draw, mid_label[1], mid_label[0], size=20, fill="#fefefe")


def entity_card(
    draw: ImageDraw.ImageDraw,
    box: tuple[int, int, int, int],
    title: str,
    attrs: str,
    *,
    domain: str,
) -> None:
    fill, accent = DOMAIN_STYLES[domain]
    x0, y0, x1, y1 = box
    rounded_panel(draw, box, fill=BOX_FILL, outline=accent, width=3, radius=18)
    header_h = 52
    draw.rounded_rectangle((x0 + 2, y0 + 2, x1 - 2, y0 + header_h + 10), radius=15, fill=fill, outline=fill)
    draw.rectangle((x0 + 2, y0 + header_h - 8, x1 - 2, y0 + header_h + 12), fill=fill)
    draw.line((x0 + 18, y0 + header_h + 10, x1 - 18, y0 + header_h + 10), fill=accent, width=2)
    draw_fitted_text(draw, (x0 + 10, y0 + 6, x1 - 10, y0 + header_h + 4), title, size=28, min_size=20)
    draw_fitted_text(draw, (x0 + 18, y0 + header_h + 18, x1 - 18, y1 - 16), attrs, size=22, min_size=16, align="left", padding=6)


def distribute_row(x0: int, y0: int, x1: int, y1: int, count: int, gap: int) -> list[tuple[int, int, int, int]]:
    width = (x1 - x0 - gap * (count - 1)) // count
    boxes = []
    for idx in range(count):
        left = x0 + idx * (width + gap)
        boxes.append((left, y0, left + width, y1))
    return boxes


def draw_architecture_overview() -> None:
    img = Image.new("RGB", (2400, 1400), "white")
    draw = ImageDraw.Draw(img)

    outer = (90, 90, 2310, 1270)
    x0, y0, x1, y1 = outer
    support_w = 300
    label_w = 220
    rows = [240, 380, 320, 240]

    rounded_panel(draw, outer, fill="white", outline=BORDER, width=3, radius=20)
    draw.rounded_rectangle((x0 + 2, y0 + 2, x0 + support_w, y1 - 2), radius=18, fill=PANEL, outline=PANEL)
    draw.rectangle((x0 + support_w, y0, x0 + support_w + label_w, y1), fill=LABEL_FILL)
    draw.line((x0 + support_w, y0, x0 + support_w, y1), fill=BORDER, width=2)
    draw.line((x0 + support_w + label_w, y0, x0 + support_w + label_w, y1), fill=BORDER, width=2)

    content_x0 = x0 + support_w + label_w
    top = y0
    for height in rows[:-1]:
        top += height
        draw.line((x0 + support_w, top, x1, top), fill=GRID, width=2)

    draw_fitted_text(draw, (x0 + 28, y0 + 34, x0 + support_w - 28, y0 + 140), "部署支撑层", size=38)
    support_boxes = [
        (x0 + 60, y0 + 210, x0 + support_w - 60, y0 + 350),
        (x0 + 60, y0 + 430, x0 + support_w - 60, y0 + 570),
        (x0 + 60, y0 + 650, x0 + support_w - 60, y0 + 790),
    ]
    for box, text in zip(support_boxes, ["Docker\nCompose", "多阶段\n构建镜像", "统一\n容器网络"]):
        rounded_box(draw, box, text, size=34)

    labels = ["前端层", "后端层", "智能算法层", "存储层"]
    top = y0
    for height, label in zip(rows, labels):
        draw_fitted_text(draw, (x0 + support_w + 12, top + 12, x0 + support_w + label_w - 12, top + height - 12), label, size=38)
        draw.rectangle((content_x0, top, x1, top + height), fill=ROW_FILL)
        top += height

    gap = 26
    content_pad = 30

    r0 = y0
    r1 = r0 + rows[0]
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 72), "Vue 3 + Vite", size=38)
    for box, text in zip(distribute_row(ix0, iy0 + 98, ix1, iy1, 4, gap), ["Element Plus", "Pinia", "Axios", "Leaflet"]):
        rounded_box(draw, box, text, size=30)

    r0 = r1
    r1 = r0 + rows[1]
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 72), "Spring Cloud Alibaba", size=38)
    mid_y1 = iy0 + 170
    for box, text in zip(distribute_row(ix0, iy0 + 96, ix1, mid_y1, 4, gap), ["Gateway", "OpenFeign", "Nacos", "RabbitMQ"]):
        rounded_box(draw, box, text, size=28)
    bottom_y0 = mid_y1 + 24
    left_w = int((ix1 - ix0) * 0.30)
    rounded_box(draw, (ix0, bottom_y0, ix0 + left_w, iy1), "Spring Boot", size=34)
    rounded_box(draw, (ix0 + left_w + gap, bottom_y0, ix1, iy1), "业务微服务集群\nAuth · User · Customer · Shop · Order · Driver · Logistics", size=26)

    r0 = r1
    r1 = r0 + rows[2]
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 72), "GraphHopper 路网引擎", size=36)
    for box, text in zip(distribute_row(ix0, iy0 + 98, ix1, iy1, 4, gap), ["A*\n路径规划", "K-Means\n聚类调度", "MCMF\n运力规划", "LLM\n辅助决策"]):
        rounded_box(draw, box, text, size=28)

    r0 = r1
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, y1 - content_pad
    for box, text in zip(distribute_row(ix0, iy0 + 14, ix1, iy1 - 14, 3, gap), ["MySQL", "Redis", "Graph Cache"]):
        rounded_box(draw, box, text, size=34)

    img.save(FIG_DIR / "architecture-overview.png", quality=95)


def draw_frontend_architecture() -> None:
    img = Image.new("RGB", (2400, 1600), "white")
    draw = ImageDraw.Draw(img)

    outer = (120, 90, 2280, 1490)
    x0, y0, x1, y1 = outer
    label_w = 240
    flow_w = 96
    rows = [210, 250, 220, 220, 220, 280]

    rounded_panel(draw, outer, fill="white", outline=BORDER, width=3, radius=20)
    draw.rectangle((x0, y0, x0 + label_w, y1), fill=LABEL_FILL)
    draw.line((x0 + label_w, y0, x0 + label_w, y1), fill=BORDER, width=2)

    top = y0
    for height in rows[:-1]:
        top += height
        draw.line((x0, top, x1, top), fill=GRID, width=2)

    labels = ["部署接入层", "视图组件层", "地图可视化层", "路由控制层", "状态管理层", "通信服务层"]
    top = y0
    content_x0 = x0 + label_w
    for height, label in zip(rows, labels):
        draw_fitted_text(draw, (x0 + 10, top + 10, x0 + label_w - 10, top + height - 10), label, size=36)
        draw.rectangle((content_x0, top, x1, top + height), fill=ROW_FILL)
        top += height

    gap = 24
    pad = 30
    usable_x1 = x1 - flow_w - 24

    top = y0
    row = rows[0]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    for box, text in zip(distribute_row(ix0, iy0 + 16, ix1, iy1 - 16, 2, gap), ["Nginx 静态托管\n/API 代理", "Vue 3 + Vite SPA"]):
        rounded_box(draw, box, text, size=32)

    top += row
    row = rows[1]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    for box, text in zip(distribute_row(ix0, iy0 + 16, ix1, iy1 - 16, 4, gap), ["Vue 3 页面组件", "Element Plus", "角色工作台", "业务组件复用"]):
        rounded_box(draw, box, text, size=28)

    top += row
    row = rows[2]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    for box, text in zip(distribute_row(ix0, iy0 + 16, ix1, iy1 - 16, 3, gap), ["Leaflet 地图容器", "GeoJSON 路线渲染", "热区 / 聚类可视化"]):
        rounded_box(draw, box, text, size=28)

    top += row
    row = rows[3]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    for box, text in zip(distribute_row(ix0, iy0 + 16, ix1, iy1 - 16, 3, gap), ["Vue Router", "全局路由守卫", "多角色路由分发"]):
        rounded_box(draw, box, text, size=28)

    top += row
    row = rows[4]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    for box, text in zip(distribute_row(ix0, iy0 + 16, ix1, iy1 - 16, 4, gap), ["Pinia", "Token", "roleCode", "响应式状态"]):
        rounded_box(draw, box, text, size=28)

    top += row
    row = rows[5]
    ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, usable_x1, top + row - pad
    header = (ix0, iy0, ix1, iy0 + 74)
    rounded_box(draw, header, "Axios 统一通信封装", size=34)
    for box, text in zip(distribute_row(ix0, iy0 + 100, ix1, iy1, 4, gap), ["请求拦截器", "认证头注入", "响应拦截器", "RESTful API"]):
        rounded_box(draw, box, text, size=26)

    arrow_x = x1 - 48
    draw.line((arrow_x, y0 + 88, arrow_x, y1 - 88), fill=LINE, width=3)
    draw.polygon([(arrow_x - 10, y0 + 106), (arrow_x + 10, y0 + 106), (arrow_x, y0 + 86)], fill=LINE)
    draw.polygon([(arrow_x - 10, y1 - 106), (arrow_x + 10, y1 - 106), (arrow_x, y1 - 86)], fill=LINE)
    draw_fitted_text(draw, (x1 - flow_w, (y0 + y1) // 2 - 80, x1 - 8, (y0 + y1) // 2 + 80), "数据流", size=30, min_size=18)

    img.save(FIG_DIR / "frontend-architecture.png", quality=95)


def draw_er_diagram() -> None:
    img = Image.new("RGB", (3200, 2280), "white")
    draw = ImageDraw.Draw(img)

    outer = (50, 50, 3150, 2230)
    rounded_panel(draw, outer, fill="white", outline=BORDER, width=3, radius=22)

    groups = {
        "user": (90, 110, 1040, 900),
        "inventory": (1090, 110, 1950, 900),
        "order": (90, 980, 1870, 2030),
        "dispatch": (1990, 980, 3110, 2030),
    }
    titles = {
        "user": "用户与角色域",
        "inventory": "商品与库存域",
        "order": "订单与履约域",
        "dispatch": "调度与网络规划域",
    }
    for key, box in groups.items():
        fill, accent = DOMAIN_STYLES[key]
        rounded_panel(draw, box, fill="#fcfcfc", outline=accent, width=3, radius=20)
        gx0, gy0, _, _ = box
        draw.rounded_rectangle((gx0 + 24, gy0 + 22, gx0 + 240, gy0 + 78), radius=14, fill=fill, outline=accent, width=2)
        draw_fitted_text(draw, (gx0 + 28, gy0 + 24, gx0 + 236, gy0 + 76), titles[key], size=28, min_size=18)

    boxes = {
        "user": (380, 220, 670, 378),
        "customer": (120, 470, 390, 628),
        "shop": (435, 470, 705, 628),
        "driver": (750, 470, 1020, 628),
        "address": (120, 680, 390, 838),
        "product": (1180, 250, 1470, 408),
        "warehouse": (1590, 250, 1880, 408),
        "order_info": (430, 1090, 890, 1280),
        "order_item": (430, 1380, 890, 1540),
        "order_delivery": (1060, 1090, 1410, 1250),
        "logistics_route": (1060, 1380, 1410, 1540),
        "dispatch_pool": (2120, 1080, 2480, 1240),
        "logistics_batch": (2570, 1080, 2930, 1240),
        "national_hub": (2120, 1420, 2480, 1580),
        "flow_plan": (2570, 1420, 2930, 1580),
    }

    entity_card(draw, boxes["user"], "User", "id · username · permission", domain="user")
    entity_card(draw, boxes["customer"], "CustomerInfo", "id · user_id · phone", domain="user")
    entity_card(draw, boxes["shop"], "ShopInfo", "id · user_id · shop_name", domain="user")
    entity_card(draw, boxes["driver"], "DriverInfo", "id · user_id · license_no", domain="user")
    entity_card(draw, boxes["address"], "CustomerAddress", "id · customer_id · lng/lat", domain="user")

    entity_card(draw, boxes["product"], "ProductInfo", "id · shop_id · price", domain="inventory")
    entity_card(draw, boxes["warehouse"], "Warehouse", "id · detail_address · hub_id", domain="inventory")

    entity_card(draw, boxes["order_info"], "OrderInfo", "order_no · customer_id · shop_id\naddress_id · warehouse_id · flow_plan_id", domain="order")
    entity_card(draw, boxes["order_item"], "OrderItem", "order_id · product_id · quantity", domain="order")
    entity_card(draw, boxes["order_delivery"], "OrderDelivery", "order_id · driver_id · status", domain="order")
    entity_card(draw, boxes["logistics_route"], "LogisticsRoute", "order_id · segment_type · hub_id", domain="order")

    entity_card(draw, boxes["dispatch_pool"], "DispatchPool", "order_id · origin_hub · dest_hub", domain="dispatch")
    entity_card(draw, boxes["logistics_batch"], "LogisticsBatch", "batch_no · warehouse_id · hub_id", domain="dispatch")
    entity_card(draw, boxes["national_hub"], "NationalHub", "city · hub_level · max_capacity", domain="dispatch")
    entity_card(draw, boxes["flow_plan"], "FlowPlan", "plan_date · total_cost · status", domain="dispatch")

    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.26), (456, 424), (255, 424), anchor(boxes["customer"], "top", 0.5)],
        start_card=("1", (456, 396)),
        end_card=("1", (255, 444)),
        mid_label=("扩展", (356, 392)),
    )
    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.5), (525, 436), anchor(boxes["shop"], "top", 0.5)],
        start_card=("1", (525, 398)),
        end_card=("1", (570, 444)),
    )
    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.74), (594, 424), (885, 424), anchor(boxes["driver"], "top", 0.5)],
        start_card=("1", (594, 396)),
        end_card=("1", (885, 444)),
        mid_label=("扩展", (744, 392)),
    )
    draw_connection(
        draw,
        [anchor(boxes["customer"], "bottom", 0.5), (255, 652), anchor(boxes["address"], "top", 0.5)],
        start_card=("1", (286, 646)),
        end_card=("N", (286, 664)),
        mid_label=("拥有地址", (168, 652)),
    )

    draw_connection(
        draw,
        [anchor(boxes["shop"], "right", 0.38), (830, 530), (1080, 530), (1080, 329), anchor(boxes["product"], "left", 0.5)],
        start_card=("1", (735, 514)),
        end_card=("N", (1148, 304)),
        mid_label=("经营商品", (960, 502)),
    )
    draw_connection(
        draw,
        [anchor(boxes["product"], "right", 0.5), (1530, 329), anchor(boxes["warehouse"], "left", 0.5)],
        start_card=("M", (1500, 298)),
        end_card=("N", (1560, 298)),
        mid_label=("库存关系", (1530, 278)),
    )

    draw_connection(
        draw,
        [anchor(boxes["customer"], "bottom", 0.72), (316, 960), (540, 960), anchor(boxes["order_info"], "top", 0.18)],
        start_card=("1", (346, 934)),
        end_card=("N", (540, 1060)),
        mid_label=("下单", (430, 930)),
    )
    draw_connection(
        draw,
        [anchor(boxes["shop"], "bottom", 0.45), (556, 1008), anchor(boxes["order_info"], "top", 0.44)],
        start_card=("1", (586, 656)),
        end_card=("N", (632, 1060)),
        mid_label=("发货方", (664, 982)),
    )
    draw_connection(
        draw,
        [anchor(boxes["address"], "right", 0.44), (470, 750), (470, 1185), anchor(boxes["order_info"], "left", 0.56)],
        start_card=("1", (416, 724)),
        end_card=("N", (402, 1185)),
        mid_label=("收货地址", (360, 1026)),
    )
    draw_connection(
        draw,
        [anchor(boxes["warehouse"], "bottom", 0.34), (1688, 950), (820, 950), anchor(boxes["order_info"], "top", 0.84)],
        start_card=("1", (1718, 924)),
        end_card=("N", (820, 1060)),
        mid_label=("出库仓", (1260, 926)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "bottom", 0.5), (660, 1325), anchor(boxes["order_item"], "top", 0.5)],
        start_card=("1", (690, 1310)),
        end_card=("N", (690, 1348)),
        mid_label=("包含", (578, 1325)),
    )
    draw_connection(
        draw,
        [anchor(boxes["product"], "bottom", 0.36), (1284, 920), (1284, 1460), anchor(boxes["order_item"], "right", 0.5)],
        start_card=("1", (1318, 892)),
        end_card=("N", (918, 1460)),
        mid_label=("商品引用", (1370, 1200)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.38), (960, 1162), anchor(boxes["order_delivery"], "left", 0.45)],
        start_card=("1", (934, 1130)),
        end_card=("1", (1032, 1130)),
        mid_label=("生成配送", (996, 1098)),
    )
    draw_connection(
        draw,
        [anchor(boxes["driver"], "bottom", 0.78), (940, 980), anchor(boxes["order_delivery"], "top", 0.22)],
        start_card=("1", (964, 954)),
        end_card=("N", (1138, 1062)),
        mid_label=("执行配送", (1084, 932)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.78), (980, 1238), (980, 1460), anchor(boxes["logistics_route"], "left", 0.5)],
        start_card=("1", (952, 1262)),
        end_card=("N", (1032, 1460)),
        mid_label=("生成路线", (900, 1360)),
    )

    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.20), (1580, 1128), anchor(boxes["dispatch_pool"], "left", 0.35)],
        start_card=("1", (936, 1100)),
        end_card=("0..1", (2062, 1100)),
        mid_label=("入调度池", (1578, 1086)),
    )
    draw_connection(
        draw,
        [anchor(boxes["dispatch_pool"], "right", 0.5), (2520, 1160), anchor(boxes["logistics_batch"], "left", 0.5)],
        start_card=("N", (2490, 1128)),
        end_card=("1", (2548, 1128)),
        mid_label=("聚类成批", (2520, 1086)),
    )
    draw_connection(
        draw,
        [anchor(boxes["logistics_batch"], "left", 0.78), (2445, 1500), anchor(boxes["logistics_route"], "right", 0.60)],
        start_card=("1", (2536, 1248)),
        end_card=("N", (1436, 1476)),
        mid_label=("生成批次路线", (2140, 1460)),
    )
    draw_connection(
        draw,
        [anchor(boxes["warehouse"], "bottom", 0.72), (1800, 1288), (2300, 1288), anchor(boxes["national_hub"], "top", 0.5)],
        start_card=("N", (1828, 1260)),
        end_card=("1", (2300, 1392)),
        mid_label=("归属城市Hub", (2040, 1254)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.90), (1640, 1270), (2750, 1270), anchor(boxes["flow_plan"], "top", 0.5)],
        start_card=("N", (938, 1252)),
        end_card=("1", (2750, 1392)),
        mid_label=("跨城运力分配", (2140, 1236)),
    )
    draw_connection(
        draw,
        [anchor(boxes["national_hub"], "right", 0.5), (2520, 1500), anchor(boxes["flow_plan"], "left", 0.5)],
        start_card=("N", (2494, 1468)),
        end_card=("N", (2548, 1468)),
        mid_label=("规划使用Hub网络", (2520, 1426)),
    )

    draw_fitted_text(
        draw,
        (2120, 1840, 3030, 1970),
        "注：本图采用论文型概念 E-R 表达，仅展示支撑系统说明的核心实体与关键基数；字段级细节和辅助表见后续关系表。",
        size=24,
        min_size=18,
        align="left",
        fill=MUTED,
    )

    img.save(FIG_DIR / "er-diagram.png", quality=96)


def main() -> None:
    draw_architecture_overview()
    draw_frontend_architecture()
    draw_er_diagram()
    print("Redrew architecture-overview.png, frontend-architecture.png, er-diagram.png")


if __name__ == "__main__":
    main()
