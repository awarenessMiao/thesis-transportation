from __future__ import annotations

from pathlib import Path
import math
from PIL import Image, ImageDraw, ImageFont

ROOT = Path("/Users/miao/CodeBuddy/thesis-transportation")
FIG_DIR = ROOT / "template" / "figures"
SLIDES_FIG_DIR = ROOT / "slides" / "public" / "figures"
FONT_CANDIDATES = [
    Path("/System/Library/Fonts/Hiragino Sans GB.ttc"),
    Path("/System/Library/Fonts/STHeiti Light.ttc"),
]
FONT_PATH = next(path for path in FONT_CANDIDATES if path.exists())

TEXT = "#2f2f2f"
MUTED = "#66707a"
BORDER = "#98a1ab"
GRID = "#d4dbe3"
LINE = "#747d87"
PANEL = "#f6f7f9"
LABEL_FILL = "#fafbfc"
ROW_FILL = "#fcfcfc"
BOX_FILL = "#ffffff"
NOTE_BORDER = "#d9e0e7"

DOMAIN_STYLES = {
    "user": ("#eaf2ff", "#6b8ec9"),
    "inventory": ("#eef7ec", "#6ea56b"),
    "order": ("#fff3e8", "#d68952"),
    "dispatch": ("#f3edff", "#8b71c5"),
}


def font(size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONT_PATH), size=size)


def save_figure(img: Image.Image, filename: str, *, quality: int = 95) -> None:
    targets = [FIG_DIR / filename]
    if SLIDES_FIG_DIR.exists():
        targets.append(SLIDES_FIG_DIR / filename)
    for target in targets:
        img.save(target, quality=quality)


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


def floating_label(
    draw: ImageDraw.ImageDraw,
    center: tuple[int, int],
    text: str,
    *,
    size: int = 20,
    fill: str = MUTED,
    bg: str = "white",
) -> None:
    current = font(size)
    bbox = draw.textbbox((0, 0), text, font=current)
    w = bbox[2] - bbox[0] + 18
    h = bbox[3] - bbox[1] + 10
    x, y = center
    box = (x - w // 2, y - h // 2, x + w // 2, y + h // 2)
    draw.rounded_rectangle(box, radius=10, fill=bg)
    draw.text((box[0] + 9, box[1] + 5), text, font=current, fill=fill)


def anchor(box: tuple[int, int, int, int], side: str, ratio: float = 0.5) -> tuple[int, int]:
    x0, y0, x1, y1 = box
    if side == "top":
        return int(x0 + (x1 - x0) * ratio), y0
    if side == "bottom":
        return int(x0 + (x1 - x0) * ratio), y1
    if side == "left":
        return x0, int(y0 + (y1 - y0) * ratio)
    return x1, int(y0 + (y1 - y0) * ratio)


def _clamp_ratio(value: float, lower: float = 0.14, upper: float = 0.86) -> float:
    return max(lower, min(upper, value))


def anchor_at_x(box: tuple[int, int, int, int], side: str, x: int) -> tuple[int, int]:
    x0, _, x1, _ = box
    if x1 == x0:
        return anchor(box, side, 0.5)
    ratio = _clamp_ratio((x - x0) / (x1 - x0))
    return anchor(box, side, ratio)


def anchor_at_y(box: tuple[int, int, int, int], side: str, y: int) -> tuple[int, int]:
    _, y0, _, y1 = box
    if y1 == y0:
        return anchor(box, side, 0.5)
    ratio = _clamp_ratio((y - y0) / (y1 - y0), 0.18, 0.82)
    return anchor(box, side, ratio)


def _int_point(point: tuple[float, float]) -> tuple[int, int]:
    return round(point[0]), round(point[1])


def draw_polyline(
    draw: ImageDraw.ImageDraw,
    points: list[tuple[float, float] | tuple[int, int]],
    *,
    fill: str,
    width: int,
) -> None:
    if len(points) < 2:
        return
    int_points = [_int_point((float(x), float(y))) for x, y in points]
    draw.line(int_points, fill=fill, width=width)
    joint_radius = max(2, width // 2)
    for px, py in int_points[1:-1]:
        draw.ellipse((px - joint_radius, py - joint_radius, px + joint_radius, py + joint_radius), fill=fill)


def draw_connection(
    draw: ImageDraw.ImageDraw,
    points: list[tuple[int, int]],
    *,
    start_card: tuple[str, tuple[int, int]] | None = None,
    end_card: tuple[str, tuple[int, int]] | None = None,
    mid_label: tuple[str, tuple[int, int]] | None = None,
    width: int = 3,
) -> None:
    draw_polyline(draw, points, fill=LINE, width=width)
    if start_card:
        floating_label(draw, start_card[1], start_card[0], size=18)
    if end_card:
        floating_label(draw, end_card[1], end_card[0], size=18)
    if mid_label:
        floating_label(draw, mid_label[1], mid_label[0], size=20, fill=MUTED)


def draw_arrow_path(
    draw: ImageDraw.ImageDraw,
    points: list[tuple[int, int]],
    *,
    fill: str = LINE,
    width: int = 4,
    label: tuple[str, tuple[int, int]] | None = None,
    arrow_length: int | None = None,
    arrow_half_width: int | None = None,
    end_gap: int = 0,
) -> None:
    if len(points) < 2:
        return
    start = (float(points[-2][0]), float(points[-2][1]))
    tip = (float(points[-1][0]), float(points[-1][1]))
    dx = tip[0] - start[0]
    dy = tip[1] - start[1]
    seg_len = math.hypot(dx, dy)
    if seg_len == 0:
        return
    ux = dx / seg_len
    uy = dy / seg_len
    arrow_length = arrow_length or max(14, width * 4)
    arrow_half_width = arrow_half_width or max(6, round(arrow_length * 0.45))
    adjusted_tip = (tip[0] - ux * end_gap, tip[1] - uy * end_gap)
    base_center = (adjusted_tip[0] - ux * arrow_length, adjusted_tip[1] - uy * arrow_length)
    shaft_points = [(float(x), float(y)) for x, y in points[:-1]] + [base_center]
    draw_polyline(draw, shaft_points, fill=fill, width=width)
    left = (base_center[0] + uy * arrow_half_width, base_center[1] - ux * arrow_half_width)
    right = (base_center[0] - uy * arrow_half_width, base_center[1] + ux * arrow_half_width)
    draw.polygon([_int_point(adjusted_tip), _int_point(left), _int_point(right)], fill=fill)
    if label:
        floating_label(draw, label[1], label[0], size=20, fill=MUTED)


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

    save_figure(img, "architecture-overview.png", quality=95)


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
    img = Image.new("RGB", (3200, 1900), "white")
    draw = ImageDraw.Draw(img)

    outer = (50, 50, 3150, 1850)
    rounded_panel(draw, outer, fill="white", outline="#d7d7d7", width=2, radius=20)

    groups = {
        "user": (90, 100, 1050, 860),
        "inventory": (1090, 100, 2010, 860),
        "order": (90, 950, 1870, 1730),
        "dispatch": (1960, 950, 3110, 1730),
    }
    titles = {
        "user": "用户与角色域",
        "inventory": "商品与库存域",
        "order": "订单与履约域",
        "dispatch": "调度与网络规划域",
    }
    for key, box in groups.items():
        fill, accent = DOMAIN_STYLES[key]
        rounded_panel(draw, box, fill="#fcfcfc", outline=accent, width=2, radius=20)
        gx0, gy0, _, _ = box
        draw.rounded_rectangle((gx0 + 24, gy0 + 22, gx0 + 246, gy0 + 76), radius=12, fill=fill, outline=accent, width=2)
        draw_fitted_text(draw, (gx0 + 28, gy0 + 24, gx0 + 242, gy0 + 74), titles[key], size=28, min_size=18)

    boxes = {
        "user": (360, 210, 710, 360),
        "customer": (120, 470, 400, 620),
        "shop": (440, 470, 720, 620),
        "driver": (720, 470, 1000, 620),
        "address": (120, 670, 400, 820),
        "product": (1180, 300, 1520, 450),
        "warehouse": (1610, 300, 1950, 450),
        "order_info": (520, 1080, 1020, 1240),
        "order_item": (260, 1400, 760, 1560),
        "order_delivery": (1090, 1080, 1590, 1240),
        "logistics_route": (1090, 1400, 1590, 1560),
        "dispatch_pool": (2080, 1080, 2440, 1240),
        "logistics_batch": (2670, 1080, 3030, 1240),
        "national_hub": (2080, 1400, 2440, 1560),
        "flow_plan": (2670, 1400, 3030, 1560),
    }

    entity_card(draw, boxes["user"], "User", "统一账号主体", domain="user")
    entity_card(draw, boxes["customer"], "CustomerInfo", "发货用户身份", domain="user")
    entity_card(draw, boxes["shop"], "ShopInfo", "商户主体", domain="user")
    entity_card(draw, boxes["driver"], "DriverInfo", "运输员身份", domain="user")
    entity_card(draw, boxes["address"], "CustomerAddress", "收货地址集合", domain="user")

    entity_card(draw, boxes["product"], "ProductInfo", "商品主数据", domain="inventory")
    entity_card(draw, boxes["warehouse"], "Warehouse", "发货 / 中转仓", domain="inventory")

    entity_card(draw, boxes["order_info"], "OrderInfo", "订单聚合根", domain="order")
    entity_card(draw, boxes["order_item"], "OrderItem", "订单明细", domain="order")
    entity_card(draw, boxes["order_delivery"], "OrderDelivery", "配送执行记录", domain="order")
    entity_card(draw, boxes["logistics_route"], "LogisticsRoute", "路线片段", domain="order")

    entity_card(draw, boxes["dispatch_pool"], "DispatchPool", "待调度订单池", domain="dispatch")
    entity_card(draw, boxes["logistics_batch"], "LogisticsBatch", "聚类运输批次", domain="dispatch")
    entity_card(draw, boxes["national_hub"], "NationalHub", "城市 Hub 节点", domain="dispatch")
    entity_card(draw, boxes["flow_plan"], "FlowPlan", "干线运力方案", domain="dispatch")

    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.26), (450, 414), (260, 414), anchor(boxes["customer"], "top", 0.5)],
        start_card=("1", (450, 390)),
        end_card=("1", (260, 442)),
        mid_label=("映射", (355, 386)),
    )
    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.5), (535, 432), anchor(boxes["shop"], "top", 0.5)],
        start_card=("1", (535, 390)),
        end_card=("1", (580, 442)),
    )
    draw_connection(
        draw,
        [anchor(boxes["user"], "bottom", 0.74), (620, 414), (860, 414), anchor(boxes["driver"], "top", 0.5)],
        start_card=("1", (620, 390)),
        end_card=("1", (860, 442)),
        mid_label=("映射", (742, 386)),
    )
    draw_connection(
        draw,
        [anchor(boxes["customer"], "bottom", 0.5), (260, 645), anchor(boxes["address"], "top", 0.5)],
        start_card=("1", (286, 640)),
        end_card=("N", (286, 652)),
        mid_label=("拥有", (178, 646)),
    )

    draw_connection(
        draw,
        [anchor(boxes["shop"], "right", 0.40), (1020, 530), (1020, 375), anchor(boxes["product"], "left", 0.5)],
        start_card=("1", (748, 514)),
        end_card=("N", (1148, 352)),
        mid_label=("经营", (1038, 500)),
    )
    draw_connection(
        draw,
        [anchor(boxes["product"], "right", 0.5), (1570, 375), anchor(boxes["warehouse"], "left", 0.5)],
        start_card=("M", (1540, 344)),
        end_card=("N", (1600, 344)),
        mid_label=("库存", (1570, 320)),
    )

    draw_connection(
        draw,
        [anchor(boxes["customer"], "bottom", 0.72), (316, 930), (620, 930), anchor(boxes["order_info"], "top", 0.20)],
        start_card=("1", (346, 904)),
        end_card=("N", (620, 1048)),
        mid_label=("下单", (430, 904)),
    )
    draw_connection(
        draw,
        [anchor(boxes["shop"], "bottom", 0.5), (580, 1010), (680, 1010), anchor(boxes["order_info"], "top", 0.32)],
        start_card=("1", (606, 644)),
        end_card=("N", (680, 1048)),
    )
    draw_connection(
        draw,
        [anchor(boxes["address"], "right", 0.44), (470, 736), (470, 1160), anchor(boxes["order_info"], "left", 0.56)],
        start_card=("1", (420, 710)),
        end_card=("N", (494, 1160)),
    )
    draw_connection(
        draw,
        [anchor(boxes["warehouse"], "bottom", 0.32), (1720, 930), (930, 930), anchor(boxes["order_info"], "top", 0.82)],
        start_card=("1", (1750, 904)),
        end_card=("N", (930, 1048)),
        mid_label=("出库", (1310, 904)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "bottom", 0.38), (710, 1320), anchor(boxes["order_item"], "top", 0.62)],
        start_card=("1", (740, 1302)),
        end_card=("N", (560, 1368)),
        mid_label=("包含", (640, 1322)),
    )
    draw_connection(
        draw,
        [anchor(boxes["product"], "bottom", 0.35), (1299, 1480), anchor(boxes["order_item"], "right", 0.50)],
        start_card=("1", (1334, 474)),
        end_card=("N", (796, 1480)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.50), (1054, 1160), anchor(boxes["order_delivery"], "left", 0.50)],
        start_card=("1", (1038, 1128)),
        end_card=("1", (1072, 1128)),
    )
    draw_connection(
        draw,
        [anchor(boxes["driver"], "bottom", 0.82), (952, 980), (1230, 980), anchor(boxes["order_delivery"], "top", 0.28)],
        start_card=("1", (980, 952)),
        end_card=("N", (1230, 1050)),
        mid_label=("执行", (1090, 952)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.78), (1060, 1205), (1060, 1480), anchor(boxes["logistics_route"], "left", 0.50)],
        start_card=("1", (1036, 1232)),
        end_card=("N", (1068, 1480)),
        mid_label=("规划", (998, 1360)),
    )

    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.20), (1038, 1112), (1038, 1030), (1830, 1030), (1830, 1140), anchor(boxes["dispatch_pool"], "left", 0.38)],
        start_card=("1", (1044, 1090)),
        end_card=("0..1", (2040, 1110)),
        mid_label=("入池", (1832, 996)),
    )
    draw_connection(
        draw,
        [anchor(boxes["dispatch_pool"], "right", 0.50), (2555, 1160), anchor(boxes["logistics_batch"], "left", 0.50)],
        start_card=("N", (2528, 1128)),
        end_card=("1", (2582, 1128)),
        mid_label=("聚类", (2555, 1088)),
    )
    draw_connection(
        draw,
        [anchor(boxes["warehouse"], "bottom", 0.72), (1855, 930), (2260, 930), anchor(boxes["national_hub"], "top", 0.50)],
        start_card=("N", (1884, 904)),
        end_card=("1", (2260, 1368)),
        mid_label=("归属", (2050, 904)),
    )
    draw_connection(
        draw,
        [anchor(boxes["order_info"], "right", 0.92), (1660, 1260), (2850, 1260), anchor(boxes["flow_plan"], "top", 0.50)],
        start_card=("N", (1040, 1234)),
        end_card=("1", (2850, 1368)),
        mid_label=("运力分配", (2240, 1226)),
    )
    draw_connection(
        draw,
        [anchor(boxes["national_hub"], "right", 0.50), (2550, 1480), anchor(boxes["flow_plan"], "left", 0.50)],
        start_card=("N", (2522, 1448)),
        end_card=("N", (2578, 1448)),
        mid_label=("干线网络", (2550, 1410)),
    )

    draw_fitted_text(
        draw,
        (190, 1772, 3020, 1828),
        "注：本图采用论文型概念 E-R 表达，仅保留核心实体与主关系；字段细节、辅助表及算法中间表见后续关系表与实现说明。",
        size=24,
        min_size=18,
        align="left",
        fill=MUTED,
    )

    save_figure(img, "er-diagram.png", quality=96)


def draw_core_business_flow(size: tuple[int, int] = (2600, 1180)) -> None:
    width, height = size
    scale = min(width / 2600, height / 1180)

    def u(value: int) -> int:
        return max(1, round(value * scale))

    img = Image.new("RGB", (width, height), "white")
    draw = ImageDraw.Draw(img)

    mono_outline = "#111111"
    mono_grid = "#8c8c8c"
    mono_fill = "#ffffff"

    outer = (u(80), u(70), width - u(80), height - u(70))
    x0, y0, x1, y1 = outer
    label_w = u(240)
    header_h = u(142)
    row_h = (y1 - y0 - header_h) // 4
    content_x0 = x0 + label_w
    content_w = x1 - content_x0

    outer_width = u(3)
    panel_width = u(2)
    connector_width = max(2, u(4))
    divider_width = u(2)
    grid_width = max(1, u(1))
    box_outline_width = u(2)
    corner_radius = u(22)
    box_radius = u(18)

    lane_styles = [
        ("参与角色", mono_fill, mono_outline),
        ("订单服务", mono_fill, mono_outline),
        ("物流服务", mono_fill, mono_outline),
        ("运输员服务", mono_fill, mono_outline),
    ]
    stage_styles = [
        ("1 下单受理", mono_fill, mono_outline),
        ("2 Hub 建模", mono_fill, mono_outline),
        ("3 全国规划", mono_fill, mono_outline),
        ("4 干线到达", mono_fill, mono_outline),
        ("5 末端调度", mono_fill, mono_outline),
        ("6 签收闭环", mono_fill, mono_outline),
    ]

    rounded_panel(draw, outer, fill="white", outline=mono_outline, width=outer_width, radius=corner_radius)
    draw.rectangle((x0, y0, x0 + label_w, y1), fill=mono_fill)
    draw.line((content_x0, y0, content_x0, y1), fill=mono_outline, width=divider_width)
    draw.line((x0, y0 + header_h, x1, y0 + header_h), fill=mono_outline, width=divider_width)

    stage_edges = [content_x0 + round(content_w * idx / 6) for idx in range(7)]
    for edge_x in stage_edges[1:-1]:
        draw.line((edge_x, y0, edge_x, y1), fill=mono_grid, width=grid_width)

    for idx, (label, fill, accent) in enumerate(stage_styles):
        sx0 = stage_edges[idx] + u(18)
        sx1 = stage_edges[idx + 1] - u(18)
        rounded_panel(draw, (sx0, y0 + u(20), sx1, y0 + header_h - u(22)), fill=fill, outline=accent, width=panel_width, radius=box_radius)
        draw_fitted_text(draw, (sx0 + u(8), y0 + u(24), sx1 - u(8), y0 + header_h - u(26)), label, size=u(31), min_size=u(20), fill=mono_outline)

    for idx, (label, fill, accent) in enumerate(lane_styles):
        ry0 = y0 + header_h + idx * row_h
        ry1 = ry0 + row_h
        draw.rectangle((content_x0, ry0, x1, ry1), fill=fill)
        if idx > 0:
            draw.line((x0, ry0, x1, ry0), fill=mono_grid, width=panel_width)
        rounded_panel(draw, (x0 + u(22), ry0 + u(34), x0 + label_w - u(22), ry1 - u(34)), fill=fill, outline=accent, width=panel_width, radius=box_radius)
        draw_fitted_text(draw, (x0 + u(28), ry0 + u(38), x0 + label_w - u(28), ry1 - u(38)), label, size=u(33), min_size=u(20), fill=mono_outline)

    def cell_bounds(col_start: int, row: int, col_end: int | None = None) -> tuple[int, int, int, int]:
        col_end = col_start if col_end is None else col_end
        cx0 = stage_edges[col_start - 1]
        cx1 = stage_edges[col_end]
        ry0 = y0 + header_h + (row - 1) * row_h
        ry1 = ry0 + row_h
        return cx0, ry0, cx1, ry1

    def flow_box(
        col_start: int,
        row: int,
        text: str,
        *,
        accent: str,
        fill: str = BOX_FILL,
        size: int = 30,
        height_value: int = 96,
        vertical: str = "center",
        margin_x: int = 26,
        margin_left: int | None = None,
        margin_right: int | None = None,
        col_end: int | None = None,
    ) -> tuple[int, int, int, int]:
        cx0, ry0, cx1, ry1 = cell_bounds(col_start, row, col_end)
        left_gap = margin_left if margin_left is not None else margin_x
        right_gap = margin_right if margin_right is not None else margin_x
        box_h = u(height_value)
        if vertical == "top":
            by0 = ry0 + u(22)
        elif vertical == "bottom":
            by0 = ry1 - box_h - u(22)
        else:
            by0 = ry0 + (row_h - box_h) // 2
        box = (cx0 + u(left_gap), by0, cx1 - u(right_gap), by0 + box_h)
        rounded_panel(draw, box, fill=fill, outline=accent, width=box_outline_width, radius=box_radius)
        draw_fitted_text(draw, box, text, size=u(size), min_size=u(18))
        return box

    b_submit = flow_box(1, 1, "发货用户 / 商户\n提交物流订单", accent=mono_outline, fill=mono_fill, size=29, height_value=100, margin_left=28, margin_right=46)
    b_create = flow_box(1, 2, "OrderService\n创建订单与明细", accent=mono_outline, fill=mono_fill, size=27, height_value=98, margin_left=30, margin_right=52)
    b_assign = flow_box(2, 3, "LogisticsService\n分配 origin / dest Hub", accent=mono_outline, fill=mono_fill, size=24, height_value=86, vertical="top", margin_left=42, margin_right=72)
    b_pool = flow_box(2, 3, "跨城订单进入\n干线待处理池", accent=mono_outline, fill=mono_fill, size=26, height_value=90, vertical="bottom", margin_left=54, margin_right=60)
    b_admin_mcmf = flow_box(3, 1, "管理员触发\nMCMF 全国规划", accent=mono_outline, fill=mono_fill, size=26, height_value=98, margin_left=58, margin_right=58)
    b_mcmf = flow_box(3, 3, "MCMF 生成\ninter_city_batch", accent=mono_outline, fill=mono_fill, size=25, height_value=96, margin_left=48, margin_right=54)
    b_arrive = flow_box(4, 3, "干线发车 / 到达\n写入目标 Hub 末端池", accent=mono_outline, fill=mono_fill, size=24, height_value=104, margin_left=42, margin_right=42)
    b_admin_lastmile = flow_box(5, 1, "管理员生成\n末端调度方案", accent=mono_outline, fill=mono_fill, size=27, height_value=98, margin_left=58, margin_right=58)
    b_kmeans = flow_box(5, 3, "K-Means 末端聚类\n创建配送批次", accent=mono_outline, fill=mono_fill, size=25, height_value=98, margin_left=48, margin_right=52)
    b_delivery = flow_box(6, 4, "DriverService 接收\n末端任务并配送", accent=mono_outline, fill=mono_fill, size=25, height_value=104, margin_left=48, margin_right=52)
    b_done = flow_box(6, 1, "收件人签收\n闭环完成", accent=mono_outline, fill=mono_fill, size=29, height_value=96, margin_left=58, margin_right=54)

    create_assign_end = anchor(b_assign, "left", 0.48)
    create_assign_start = anchor_at_y(b_create, "right", create_assign_end[1])
    assign_route_x = create_assign_end[0] - u(34)
    assign_pool_start = anchor(b_assign, "bottom")
    assign_pool_end = anchor(b_pool, "top")
    pool_admin_x = (b_admin_mcmf[0] + b_admin_mcmf[2]) // 2
    pool_admin_start = anchor_at_x(b_pool, "top", pool_admin_x)
    pool_admin_end = anchor(b_admin_mcmf, "bottom")
    admin_mcmf_start = anchor(b_admin_mcmf, "bottom")
    mcmf_entry = anchor_at_x(b_mcmf, "top", admin_mcmf_start[0])
    arrive_admin_x = (b_admin_lastmile[0] + b_admin_lastmile[2]) // 2
    arrive_admin_start = anchor_at_x(b_arrive, "top", arrive_admin_x)
    arrive_admin_end = anchor(b_admin_lastmile, "bottom")
    admin_lastmile_start = anchor(b_admin_lastmile, "bottom")
    kmeans_entry = anchor_at_x(b_kmeans, "top", admin_lastmile_start[0])
    delivery_entry = anchor(b_delivery, "left", 0.50)
    kmeans_delivery_start = anchor_at_y(b_kmeans, "right", delivery_entry[1])
    delivery_done_end = anchor(b_done, "bottom")
    delivery_done_start = anchor_at_x(b_delivery, "top", delivery_done_end[0])

    draw_arrow_path(draw, [anchor(b_submit, "bottom"), ((b_submit[0] + b_submit[2]) // 2, b_create[1] - u(16)), anchor(b_create, "top")], width=connector_width, arrow_length=u(18), arrow_half_width=u(8))
    draw_arrow_path(
        draw,
        [
            create_assign_start,
            (assign_route_x, create_assign_start[1]),
            (assign_route_x, create_assign_end[1]),
            create_assign_end,
        ],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
        label=("Feign同步", (assign_route_x + u(58), create_assign_start[1] - u(30))),
    )
    draw_arrow_path(
        draw,
        [assign_pool_start, assign_pool_end],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
    )
    draw_arrow_path(
        draw,
        [pool_admin_start, pool_admin_end],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
        label=("等待规划", (pool_admin_start[0] + u(18), pool_admin_start[1] - u(28))),
    )
    draw_arrow_path(
        draw,
        [admin_mcmf_start, mcmf_entry],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
    )
    draw_arrow_path(draw, [anchor(b_mcmf, "right", 0.5), anchor(b_arrive, "left", 0.5)], width=connector_width, arrow_length=u(18), arrow_half_width=u(8))
    draw_arrow_path(
        draw,
        [arrive_admin_start, arrive_admin_end],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
        label=("到达后", (arrive_admin_start[0] + u(16), arrive_admin_start[1] - u(28))),
    )
    draw_arrow_path(
        draw,
        [admin_lastmile_start, kmeans_entry],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
    )
    draw_arrow_path(
        draw,
        [kmeans_delivery_start, delivery_entry],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
    )
    draw_arrow_path(
        draw,
        [delivery_done_start, delivery_done_end],
        width=connector_width,
        arrow_length=u(18),
        arrow_half_width=u(8),
    )

    save_figure(img, "core-business-flow.png", quality=96)


def main() -> None:
    draw_architecture_overview()
    draw_frontend_architecture()
    draw_core_business_flow()
    draw_er_diagram()
    print("Redrew architecture-overview.png, frontend-architecture.png, core-business-flow.png, er-diagram.png")


if __name__ == "__main__":
    main()
