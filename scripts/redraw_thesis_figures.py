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

BORDER = "#555555"
GRID = "#8a8a8a"
TEXT = "#2f2f2f"
LIGHT = "#f2f2f2"
LIGHTER = "#fafafa"
BOX_FILL = "#ffffff"
ROW_FILL = "#fcfcfc"

ER_ACCENTS = [
    ("#eaf2ff", "#5b8bd9"),
    ("#eef7ec", "#67a96b"),
    ("#fff2e8", "#e28247"),
    ("#f4ecff", "#8c63c7"),
]


def font(size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONT_PATH), size=size)


def fit_font(draw: ImageDraw.ImageDraw, text: str, max_width: int, max_height: int, start: int, min_size: int = 18) -> ImageFont.FreeTypeFont:
    size = start
    while size >= min_size:
        current = font(size)
        bbox = draw.multiline_textbbox((0, 0), text, font=current, align="center", spacing=max(6, size // 4))
        width = bbox[2] - bbox[0]
        height = bbox[3] - bbox[1]
        if width <= max_width and height <= max_height:
            return current
        size -= 2
    return font(min_size)


def draw_center_text(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], text: str, *, fill: str = TEXT, size: int = 40) -> None:
    x0, y0, x1, y1 = box
    current = fit_font(draw, text, x1 - x0 - 18, y1 - y0 - 18, size)
    spacing = max(6, current.size // 4)
    bbox = draw.multiline_textbbox((0, 0), text, font=current, align="center", spacing=spacing)
    width = bbox[2] - bbox[0]
    height = bbox[3] - bbox[1]
    draw.multiline_text(
        (x0 + (x1 - x0 - width) / 2, y0 + (y1 - y0 - height) / 2),
        text,
        font=current,
        fill=fill,
        align="center",
        spacing=spacing,
    )


def rounded_box(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int], text: str, *, fill: str = BOX_FILL, outline: str = GRID, radius: int = 18, width: int = 3, size: int = 38) -> None:
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline, width=width)
    draw_center_text(draw, box, text, size=size)


def paste_fit(canvas: Image.Image, image: Image.Image, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    width = x1 - x0
    height = y1 - y0
    ratio = min(width / image.width, height / image.height)
    resized = image.resize((int(image.width * ratio), int(image.height * ratio)), Image.Resampling.LANCZOS)
    px = x0 + (width - resized.width) // 2
    py = y0 + (height - resized.height) // 2
    canvas.paste(resized, (px, py))


def flatten_white(image: Image.Image) -> Image.Image:
    if image.mode != "RGBA":
        return image.convert("RGB")
    base = Image.new("RGBA", image.size, "white")
    base.alpha_composite(image)
    return base.convert("RGB")


def crop_transparent(image: Image.Image, pad: int = 24) -> Image.Image:
    flattened = flatten_white(image.convert("RGBA"))
    grayscale = flattened.convert("L")
    bbox = grayscale.point(lambda value: 255 if value < 245 else 0).getbbox()
    if bbox is None:
        return flattened
    left = max(0, bbox[0] - pad)
    top = max(0, bbox[1] - pad)
    right = min(flattened.width, bbox[2] + pad)
    bottom = min(flattened.height, bbox[3] + pad)
    return flattened.crop((left, top, right, bottom))


def draw_architecture_overview() -> None:
    img = Image.new("RGB", (2400, 1600), "white")
    draw = ImageDraw.Draw(img)

    outer = (60, 80, 2340, 1320)
    x0, y0, x1, y1 = outer
    col_a = 340
    col_b = 250
    row_heights = [300, 420, 300, 220]
    row_tops = [y0]
    for height in row_heights[:-1]:
        row_tops.append(row_tops[-1] + height)

    draw.rounded_rectangle(outer, radius=18, fill="white", outline=BORDER, width=4)
    draw.rectangle((x0, y0, x0 + col_a, y1), fill=LIGHT)
    draw.line((x0 + col_a, y0, x0 + col_a, y1), fill=BORDER, width=3)
    draw.line((x0 + col_a + col_b, y0, x0 + col_a + col_b, y1), fill=BORDER, width=3)

    current_y = y0
    for height in row_heights[:-1]:
        current_y += height
        draw.line((x0, current_y, x1, current_y), fill=BORDER, width=3)

    draw_center_text(draw, (x0 + 20, y0 + 20, x0 + col_a - 20, y0 + 170), "部署支撑层", size=44)
    rounded_box(draw, (x0 + 58, y0 + 220, x0 + col_a - 58, y0 + 405), "Docker\nCompose", fill="#fdfdfd", size=42)
    rounded_box(draw, (x0 + 58, y0 + 455, x0 + col_a - 58, y0 + 640), "多阶段\n构建镜像", fill="#fdfdfd", size=40)
    rounded_box(draw, (x0 + 58, y0 + 690, x0 + col_a - 58, y0 + 875), "统一\n容器网络", fill="#fdfdfd", size=40)

    labels = ["前端层", "后端层", "智能算法层", "存储层"]
    label_boxes = []
    top = y0
    for height, label in zip(row_heights, labels):
        box = (x0 + col_a, top, x0 + col_a + col_b, top + height)
        label_boxes.append(box)
        draw.rectangle(box, fill=LIGHTER)
        draw_center_text(draw, box, label, size=42)
        top += height

    content_x0 = x0 + col_a + col_b
    content_pad = 28

    # Row 1
    r0, r1 = y0, y0 + row_heights[0]
    draw.rectangle((content_x0, r0, x1, r1), fill=ROW_FILL)
    inner = (content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad)
    ix0, iy0, ix1, iy1 = inner
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 86), "Vue 3 + Vite", size=44)
    gap = 24
    box_top = iy0 + 110
    box_h = iy1 - box_top
    box_w = (ix1 - ix0 - gap * 3) // 4
    for i, text in enumerate(["Element Plus", "Pinia", "Axios", "Leaflet"]):
        bx0 = ix0 + i * (box_w + gap)
        rounded_box(draw, (bx0, box_top, bx0 + box_w, iy1), text, size=36)

    # Row 2
    r0 = y0 + row_heights[0]
    r1 = r0 + row_heights[1]
    draw.rectangle((content_x0, r0, x1, r1), fill=ROW_FILL)
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 82), "Spring Cloud Alibaba", size=44)
    mid_top = iy0 + 108
    mid_h = 86
    mid_w = (ix1 - ix0 - gap * 3) // 4
    for i, text in enumerate(["Gateway", "OpenFeign", "Nacos", "RabbitMQ"]):
        bx0 = ix0 + i * (mid_w + gap)
        rounded_box(draw, (bx0, mid_top, bx0 + mid_w, mid_top + mid_h), text, size=34)
    bottom_top = mid_top + mid_h + 26
    left_w = int((ix1 - ix0) * 0.30)
    rounded_box(draw, (ix0, bottom_top, ix0 + left_w, iy1), "Spring Boot", size=38)
    rounded_box(draw, (ix0 + left_w + gap, bottom_top, ix1, iy1), "业务微服务集群\nAuth · User · Customer · Shop · Order · Driver · Logistics", size=30)

    # Row 3
    r0 = y0 + row_heights[0] + row_heights[1]
    r1 = r0 + row_heights[2]
    draw.rectangle((content_x0, r0, x1, r1), fill=ROW_FILL)
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    rounded_box(draw, (ix0, iy0, ix1, iy0 + 82), "GraphHopper 路网引擎", size=42)
    box_top = iy0 + 108
    box_h = iy1 - box_top
    box_w = (ix1 - ix0 - gap * 3) // 4
    for i, text in enumerate(["A*\n路径规划", "K-Means\n聚类调度", "MCMF\n运力规划", "LLM\n辅助决策"]):
        bx0 = ix0 + i * (box_w + gap)
        rounded_box(draw, (bx0, box_top, bx0 + box_w, iy1), text, size=34)

    # Row 4
    r0 = y1 - row_heights[3]
    r1 = y1
    draw.rectangle((content_x0, r0, x1, r1), fill=ROW_FILL)
    ix0, iy0, ix1, iy1 = content_x0 + content_pad, r0 + content_pad, x1 - content_pad, r1 - content_pad
    box_w = (ix1 - ix0 - gap * 2) // 3
    for i, text in enumerate(["MySQL", "Redis", "Graph Cache"]):
        bx0 = ix0 + i * (box_w + gap)
        rounded_box(draw, (bx0, iy0 + 4, bx0 + box_w, iy1 - 4), text, size=38)

    img.save(FIG_DIR / "architecture-overview.png", quality=95)


def draw_frontend_architecture() -> None:
    img = Image.new("RGB", (2400, 1760), "white")
    draw = ImageDraw.Draw(img)

    outer = (80, 80, 2320, 1680)
    x0, y0, x1, y1 = outer
    label_col = 250
    row_heights = [220, 250, 230, 230, 220, 210]

    draw.rounded_rectangle(outer, radius=18, fill="white", outline=BORDER, width=4)
    draw.rectangle((x0, y0, x0 + label_col, y1), fill=LIGHT)
    draw.line((x0 + label_col, y0, x0 + label_col, y1), fill=BORDER, width=3)

    current_y = y0
    for height in row_heights[:-1]:
        current_y += height
        draw.line((x0, current_y, x1, current_y), fill=BORDER, width=3)

    rows = [
        ("应用壳层", ["Vite 构建", "Nginx 托管\nSPA 代理"]),
        ("页面呈现层", ["Vue 3 组件", "Element Plus", "角色页面", "业务组件复用"]),
        ("地图可视化层", ["Leaflet", "GeoJSON 路线", "聚类结果 / 热区"]),
        ("路由控制层", ["Vue Router", "全局路由守卫", "多角色路由分发"]),
        ("状态管理层", ["Pinia", "Token", "roleCode", "响应式状态"]),
        ("数据通信层", ["Axios", "请求拦截", "响应拦截", "RESTful API"]),
    ]

    top = y0
    gap = 24
    pad = 28
    content_x0 = x0 + label_col
    for idx, (label, items) in enumerate(rows):
        height = row_heights[idx]
        draw.rectangle((content_x0, top, x1, top + height), fill=ROW_FILL)
        draw_center_text(draw, (x0, top, x0 + label_col, top + height), label, size=42)
        ix0, iy0, ix1, iy1 = content_x0 + pad, top + pad, x1 - pad, top + height - pad
        count = len(items)
        box_w = (ix1 - ix0 - gap * (count - 1)) // count
        for i, text in enumerate(items):
            bx0 = ix0 + i * (box_w + gap)
            rounded_box(draw, (bx0, iy0 + 16, bx0 + box_w, iy1 - 16), text, size=34)
        top += height

    draw.line((2280, y0 + 120, 2280, y1 - 120), fill="#9a9a9a", width=3)
    draw.polygon([(2270, y0 + 140), (2290, y0 + 140), (2280, y0 + 118)], fill="#9a9a9a")
    draw.polygon([(2270, y1 - 140), (2290, y1 - 140), (2280, y1 - 118)], fill="#9a9a9a")
    draw_center_text(draw, (2220, (y0 + y1) // 2 - 160, 2340, (y0 + y1) // 2 + 160), "数据流", size=34)

    img.save(FIG_DIR / "frontend-architecture.png", quality=95)


def compose_er_diagram() -> None:
    cards = [
        (ROOT / "er-user.png", "用户与角色域"),
        (ROOT / "er-inventory.png", "商品与库存域"),
        (ROOT / "er-order.png", "订单与配送域"),
        (ROOT / "er-dispatch.png", "调度与网络域"),
    ]

    canvas = Image.new("RGB", (2600, 1880), "white")
    draw = ImageDraw.Draw(canvas)
    outer = (60, 60, 2540, 1820)
    draw.rounded_rectangle(outer, radius=20, outline=BORDER, width=4, fill="white")

    card_w = 1160
    card_h = 760
    gap_x = 60
    gap_y = 60
    start_x = 110
    start_y = 120

    for idx, (path, title) in enumerate(cards):
        row = idx // 2
        col = idx % 2
        x = start_x + col * (card_w + gap_x)
        y = start_y + row * (card_h + gap_y)
        fill, accent = ER_ACCENTS[idx]
        draw.rounded_rectangle((x, y, x + card_w, y + card_h), radius=18, fill=LIGHTER, outline=accent, width=4)
        draw.rounded_rectangle((x + 24, y + 22, x + 260, y + 90), radius=14, fill=fill, outline=accent, width=3)
        draw_center_text(draw, (x + 30, y + 26, x + 254, y + 86), title, size=34)

        sub = crop_transparent(Image.open(path), pad=12)
        paste_fit(canvas, sub, (x + 28, y + 112, x + card_w - 28, y + card_h - 28))

    draw_center_text(draw, (1970, 1735, 2500, 1805), "按业务域拆分展示以提升可读性", fill="#666666", size=28)
    canvas.save(FIG_DIR / "er-diagram.png", quality=95)


def main() -> None:
    draw_architecture_overview()
    draw_frontend_architecture()
    compose_er_diagram()
    print("Redrew architecture-overview.png, frontend-architecture.png, er-diagram.png")


if __name__ == "__main__":
    main()
