#!/usr/bin/env python3
"""Generate a clean ER diagram for the thesis using matplotlib."""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch
import numpy as np

plt.rcParams['font.family'] = ['Arial Unicode MS', 'SimHei', 'sans-serif']
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(1, 1, figsize=(20, 12))
ax.set_xlim(0, 20)
ax.set_ylim(0, 12)
ax.axis('off')
fig.patch.set_facecolor('white')
ax.set_facecolor('white')

colors = {
    'user': '#E3F2FD', 'user_border': '#1565C0',
    'product': '#E8F5E9', 'product_border': '#2E7D32',
    'order': '#FFF3E0', 'order_border': '#E65100',
    'logistics': '#F3E5F5', 'logistics_border': '#6A1B9A',
    'network': '#E0F7FA', 'network_border': '#00838F',
}

def draw_entity(ax, x, y, w, h, name, color_key, font_size=10):
    box = FancyBboxPatch((x - w/2, y - h/2), w, h,
                         boxstyle="round,pad=0.02,rounding_size=0.15",
                         facecolor=colors[color_key],
                         edgecolor=colors[f'{color_key}_border'],
                         linewidth=1.5)
    ax.add_patch(box)
    ax.text(x, y, name, ha='center', va='center', fontsize=font_size,
            fontweight='bold', color=colors[f'{color_key}_border'])
    return (x, y, w, h)

def draw_straight(ax, x1, y1, x2, y2, label='', label_offset=(0, 0.15), color='#555555'):
    ax.plot([x1, x2], [y1, y2], color=color, linewidth=1.0, zorder=1)
    if label:
        mx, my = (x1 + x2) / 2 + label_offset[0], (y1 + y2) / 2 + label_offset[1]
        ax.text(mx, my, label, ha='center', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.12', facecolor='white', edgecolor='none', alpha=0.95), zorder=5)

def draw_step_hv(ax, x1, y1, x2, y2, label='', label_pos=(0, 0), color='#555555'):
    """Horizontal then vertical step."""
    ax.plot([x1, x2, x2], [y1, y1, y2], color=color, linewidth=1.0, zorder=1)
    if label:
        ax.text(x2 + label_pos[0], y1 + label_pos[1], label, ha='center', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.12', facecolor='white', edgecolor='none', alpha=0.95), zorder=5)

def draw_step_vh(ax, x1, y1, x2, y2, label='', label_pos=(0, 0), color='#555555'):
    """Vertical then horizontal step."""
    ax.plot([x1, x1, x2], [y1, y2, y2], color=color, linewidth=1.0, zorder=1)
    if label:
        ax.text(x1 + label_pos[0], y2 + label_pos[1], label, ha='center', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.12', facecolor='white', edgecolor='none', alpha=0.95), zorder=5)

# ==================== Entities ====================
# Col 1: User/Role (x=2.5)
user   = draw_entity(ax, 2.5, 10.2, 1.6, 0.7, 'User', 'user')
cust   = draw_entity(ax, 2.5,  8.5, 1.6, 0.7, 'Customer', 'user')
addr   = draw_entity(ax, 2.5,  6.8, 1.6, 0.7, 'Address', 'user')
shop   = draw_entity(ax, 2.5,  5.0, 1.6, 0.7, 'Shop', 'product')
driver = draw_entity(ax, 2.5,  3.3, 1.6, 0.7, 'Driver', 'user')

# Col 2: Product/Inventory (x=5.8)
prod   = draw_entity(ax, 5.8,  8.5, 1.6, 0.7, 'Product', 'product')
wh     = draw_entity(ax, 5.8,  6.8, 1.6, 0.7, 'Warehouse', 'product')
pw     = draw_entity(ax, 4.3,  5.0, 2.0, 0.7, 'ProductWarehouse', 'product', font_size=9)

# Col 3: Order/Delivery (x=9.5)
order  = draw_entity(ax, 9.5,  9.5, 1.8, 0.7, 'OrderInfo', 'order')
deliv  = draw_entity(ax, 9.5,  7.5, 1.6, 0.7, 'Delivery', 'order')
route  = draw_entity(ax, 9.5,  5.5, 1.8, 0.7, 'LogisticsRoute', 'order', font_size=9)

# Col 4: Logistics (x=13.2)
batch  = draw_entity(ax, 13.2, 9.5, 1.8, 0.7, 'LogisticsBatch', 'logistics', font_size=9)
item   = draw_entity(ax, 13.2, 7.5, 1.6, 0.7, 'BatchItem', 'logistics')
pool   = draw_entity(ax, 13.2, 5.5, 1.8, 0.7, 'DispatchPool', 'logistics', font_size=9)

# Col 5: Network/Planning (x=17.0)
hub    = draw_entity(ax, 17.0, 9.5, 1.6, 0.7, 'Hub', 'network')
link   = draw_entity(ax, 17.0, 7.5, 1.6, 0.7, 'HubLink', 'network')
flow   = draw_entity(ax, 17.0, 5.5, 1.6, 0.7, 'FlowPlan', 'network')
flowi  = draw_entity(ax, 17.0, 3.8, 1.8, 0.7, 'FlowPlanItem', 'network', font_size=9)

# ==================== Connections ====================
# User -> Customer, Shop, Driver (vertical chain)
draw_straight(ax, 2.5, 9.85, 2.5, 8.85, '1:1', (0.15, 0))
draw_straight(ax, 2.5, 8.15, 2.5, 6.5,  '1:1', (-0.45, 0.7))   # through gap
draw_straight(ax, 2.5, 6.45, 2.5, 5.35, '1:1', (0.15, 0))
draw_straight(ax, 2.5, 4.65, 2.5, 3.65, '1:1', (0.15, 0))

# Customer -> Address
draw_straight(ax, 2.5, 8.15, 2.5, 7.15, '1:N', (0.15, 0))

# Shop -> Product
draw_step_hv(ax, 3.3, 5.0, 5.0, 8.5, '1:N', (0, 0.15))
# Shop -> Warehouse
draw_step_hv(ax, 3.3, 5.0, 5.0, 6.8, '1:N', (0, -0.15))

# Product <-> ProductWarehouse
draw_straight(ax, 5.0, 8.15, 5.0, 5.35, '1:N', (-0.3, 0))
# Warehouse <-> ProductWarehouse
draw_straight(ax, 5.0, 6.45, 5.0, 5.35, '1:N', (-0.3, 0))
# M:N label for Product-Warehouse
ax.text(4.3, 5.8, 'M:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.12', facecolor='white', edgecolor='none', alpha=0.95), zorder=5)

# Customer -> OrderInfo
draw_step_hv(ax, 3.3, 8.5, 8.6, 9.5, 'N:1', (0, 0.15))
# Shop -> OrderInfo
draw_step_hv(ax, 3.3, 5.0, 8.6, 9.2, 'N:1', (0, -0.15))
# Address -> OrderInfo
draw_step_hv(ax, 3.3, 6.8, 8.6, 8.95, 'N:1', (0, 0.1))
# Warehouse -> OrderInfo
draw_step_hv(ax, 5.0, 6.8, 8.6, 8.75, 'N:1', (0, -0.1))

# OrderInfo -> Delivery
draw_straight(ax, 9.5, 9.15, 9.5, 7.85, '1:N', (0.15, 0))
# OrderInfo -> LogisticsRoute
draw_straight(ax, 9.5, 8.85, 9.5, 5.85, '1:N', (-0.5, 1.0))

# Delivery -> Driver
draw_step_vh(ax, 10.3, 7.5, 3.3, 3.3, 'N:1', (0, 0.15))
# LogisticsRoute -> Driver
draw_step_vh(ax, 10.3, 5.5, 3.3, 3.6, 'N:1', (0, -0.15))

# OrderInfo -> LogisticsBatch
draw_step_hv(ax, 10.4, 9.2, 12.3, 9.5, '1:N', (0, 0.15))
# OrderInfo -> DispatchPool
draw_step_hv(ax, 10.4, 8.8, 12.3, 5.5, '1:N', (0, 0.15))

# LogisticsBatch -> BatchItem
draw_straight(ax, 13.2, 9.15, 13.2, 7.85, '1:N', (0.15, 0))
# BatchItem -> OrderInfo
draw_step_vh(ax, 14.0, 7.5, 10.4, 9.0, 'N:1', (0, 0.15))

# LogisticsBatch -> Hub
draw_step_hv(ax, 14.1, 9.5, 16.2, 9.5, 'N:1', (0, 0.15))
# LogisticsBatch -> Warehouse
draw_step_hv(ax, 13.2, 9.15, 6.6, 6.8, 'N:1', (0, 0.15))
# LogisticsBatch -> LogisticsRoute
draw_step_hv(ax, 13.2, 8.8, 10.4, 5.5, 'N:1', (0, 0.15))

# Hub self-relation (M:N)
ax.annotate('', xy=(16.2, 10.15), xytext=(17.8, 10.15),
            arrowprops=dict(arrowstyle='<->', color='#555555', lw=1.0,
                           connectionstyle='arc3,rad=0.35'))
ax.text(17.0, 10.75, 'M:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.12', facecolor='white', edgecolor='none', alpha=0.95), zorder=5)

# Hub -> HubLink
draw_straight(ax, 17.0, 9.15, 17.0, 7.85, '1:N', (0.15, 0))
# HubLink -> FlowPlan
draw_step_vh(ax, 17.0, 7.15, 17.0, 5.85, 'N:1', (0.3, 0))
# FlowPlan -> FlowPlanItem
draw_straight(ax, 17.0, 5.15, 17.0, 4.15, '1:N', (0.15, 0))

# ==================== Domain Labels ====================
ax.text(2.5, 11.2, '用户与角色域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['user_border'])
ax.text(5.0, 9.9, '商品与库存域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['product_border'])
ax.text(9.5, 10.5, '订单与配送域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['order_border'])
ax.text(13.2, 10.5, '调度域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['logistics_border'])
ax.text(17.0, 10.9, '网络与规划域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['network_border'])

# Title
ax.text(9.75, 11.6, '智能物流管理系统 E-R 图', ha='center', va='center',
        fontsize=16, fontweight='bold', color='#1a1a1a')

# Legend
legend_y = 2.3
ax.text(1.0, legend_y, '图例：', ha='left', va='center', fontsize=10, fontweight='bold', color='#333')
legend_items = [
    (2.0, legend_y, 'user', '用户域'),
    (4.0, legend_y, 'product', '商品域'),
    (6.2, legend_y, 'order', '订单域'),
    (8.5, legend_y, 'logistics', '调度域'),
    (11.0, legend_y, 'network', '网络域'),
]
for lx, ly, ckey, label in legend_items:
    box = FancyBboxPatch((lx - 0.35, ly - 0.18), 0.7, 0.36,
                         boxstyle="round,pad=0.02,rounding_size=0.1",
                         facecolor=colors[ckey], edgecolor=colors[f'{ckey}_border'], linewidth=1.2)
    ax.add_patch(box)
    ax.text(lx + 0.55, ly, label, ha='left', va='center', fontsize=9, color='#444')

plt.tight_layout()
plt.savefig('/Users/miao/CodeBuddy/thesis-transportation/template/figures/er-diagram.png',
            dpi=300, bbox_inches='tight', facecolor='white', edgecolor='none')
print('ER diagram saved to figures/er-diagram.png')
