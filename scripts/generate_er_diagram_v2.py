#!/usr/bin/env python3
"""Generate a cleaner ER diagram for the thesis using matplotlib."""

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

def draw_line(ax, x1, y1, x2, y2, card_mid=None, color='#555555'):
    ax.plot([x1, x2], [y1, y2], color=color, linewidth=1.0, zorder=1)
    if card_mid:
        mx, my = (x1 + x2) / 2, (y1 + y2) / 2
        ax.text(mx, my, card_mid, ha='center', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9), zorder=5)

def draw_l_shape(ax, x1, y1, x2, y2, card_pos=None, color='#555555'):
    """Draw an L-shaped line via corner."""
    if abs(x1 - x2) < 0.1:
        draw_line(ax, x1, y1, x2, y2, card_pos, color)
        return
    if abs(y1 - y2) < 0.1:
        draw_line(ax, x1, y1, x2, y2, card_pos, color)
        return
    corner_x, corner_y = x2, y1
    ax.plot([x1, corner_x], [y1, corner_y], color=color, linewidth=1.0, zorder=1)
    ax.plot([corner_x, x2], [corner_y, y2], color=color, linewidth=1.0, zorder=1)
    if card_pos:
        ax.text(corner_x + 0.15, (corner_y + y2)/2, card_pos, ha='left', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9), zorder=5)

def draw_l_shape_v(ax, x1, y1, x2, y2, card_pos=None, color='#555555'):
    """Draw an L-shaped line via vertical corner."""
    if abs(x1 - x2) < 0.1:
        draw_line(ax, x1, y1, x2, y2, card_pos, color)
        return
    if abs(y1 - y2) < 0.1:
        draw_line(ax, x1, y1, x2, y2, card_pos, color)
        return
    corner_x, corner_y = x1, y2
    ax.plot([x1, corner_x], [y1, corner_y], color=color, linewidth=1.0, zorder=1)
    ax.plot([corner_x, x2], [corner_y, y2], color=color, linewidth=1.0, zorder=1)
    if card_pos:
        ax.text((x1 + corner_x)/2 + 0.15, (y1 + corner_y)/2, card_pos, ha='left', va='center', fontsize=8, color='#333333',
                bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9), zorder=5)

# ==================== Layout ====================
# Column 1: User domain (x=2.5)
# Column 2: Product domain (x=5.5)
# Column 3: Order domain (x=9.5)
# Column 4: Logistics domain (x=13.5)
# Column 5: Network/Planning domain (x=17.5)

# User column
draw_entity(ax, 2.5, 10.5, 1.6, 0.7, 'User', 'user')
draw_entity(ax, 2.5, 8.8, 1.6, 0.7, 'Customer', 'user')
draw_entity(ax, 2.5, 7.3, 1.6, 0.7, 'Address', 'user')

# Shop/Driver sub-column near user
draw_entity(ax, 2.5, 5.8, 1.6, 0.7, 'Shop', 'product')
draw_entity(ax, 2.5, 4.3, 1.6, 0.7, 'Driver', 'user')

# Product column
draw_entity(ax, 5.5, 8.8, 1.6, 0.7, 'Product', 'product')
draw_entity(ax, 5.5, 7.3, 1.6, 0.7, 'Warehouse', 'product')
draw_entity(ax, 4.0, 6.0, 2.0, 0.7, 'ProductWarehouse', 'product', font_size=9)

# Order column
draw_entity(ax, 9.5, 10.0, 1.8, 0.7, 'OrderInfo', 'order')
draw_entity(ax, 9.5, 8.0, 1.6, 0.7, 'Delivery', 'order')
draw_entity(ax, 9.5, 6.0, 1.8, 0.7, 'LogisticsRoute', 'order', font_size=9)

# Logistics column
draw_entity(ax, 13.5, 10.0, 1.8, 0.7, 'LogisticsBatch', 'logistics', font_size=9)
draw_entity(ax, 13.5, 8.0, 1.6, 0.7, 'BatchItem', 'logistics')
draw_entity(ax, 13.5, 6.0, 1.8, 0.7, 'DispatchPool', 'logistics', font_size=9)

# Network/Planning column
draw_entity(ax, 17.5, 10.0, 1.6, 0.7, 'Hub', 'network')
draw_entity(ax, 17.5, 8.0, 1.6, 0.7, 'HubLink', 'network')
draw_entity(ax, 17.5, 6.0, 1.6, 0.7, 'FlowPlan', 'network')
draw_entity(ax, 17.5, 4.5, 1.8, 0.7, 'FlowPlanItem', 'network', font_size=9)

# ==================== Connections ====================
# User -> Customer
draw_line(ax, 2.5, 10.15, 2.5, 9.15, '1:1')
# User -> Shop
draw_l_shape(ax, 2.5, 10.15, 2.5, 6.15, '1:1')
# User -> Driver
draw_l_shape(ax, 2.5, 10.15, 2.5, 4.65, '1:1')

# Customer -> Address
draw_line(ax, 2.5, 8.45, 2.5, 7.65, '1:N')

# Shop -> Product
draw_l_shape(ax, 2.5, 5.45, 5.5, 9.15, '1:N')
# Shop -> Warehouse
draw_l_shape(ax, 2.5, 5.45, 5.5, 7.65, '1:N')

# Product <-> Warehouse (via ProductWarehouse)
draw_line(ax, 5.5, 8.45, 5.0, 6.35, '1:N')
draw_line(ax, 5.5, 7.65, 5.0, 6.0, '1:N')
# ProductWarehouse note
ax.text(4.0, 5.3, 'M:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9), zorder=5)

# Customer -> OrderInfo
draw_l_shape(ax, 2.5, 8.45, 8.6, 10.0, 'N:1')
# Shop -> OrderInfo
draw_l_shape(ax, 2.5, 5.45, 8.6, 9.85, 'N:1')
# Address -> OrderInfo
draw_l_shape(ax, 2.5, 7.65, 8.6, 9.7, 'N:1')
# Warehouse -> OrderInfo
draw_l_shape(ax, 5.5, 7.65, 8.6, 9.55, 'N:1')

# OrderInfo -> Delivery
draw_line(ax, 9.5, 9.65, 9.5, 8.35, '1:N')
# Delivery -> Driver
draw_l_shape_v(ax, 9.5, 8.0, 3.3, 4.3, 'N:1')

# OrderInfo -> LogisticsRoute
draw_line(ax, 9.5, 9.3, 9.5, 6.35, '1:N')
# LogisticsRoute -> Driver
draw_l_shape_v(ax, 9.5, 6.0, 3.3, 4.65, 'N:1')

# OrderInfo -> LogisticsBatch (actually via order in batch items, indirect)
# LogisticsBatch -> BatchItem
draw_line(ax, 13.5, 9.65, 13.5, 8.35, '1:N')
# BatchItem -> OrderInfo
draw_l_shape_v(ax, 13.5, 8.0, 10.4, 9.85, 'N:1')

# OrderInfo -> DispatchPool
draw_line(ax, 10.4, 9.5, 12.6, 6.0, '1:N')

# Hub self relation (M:N via HubLink)
# Hub -> HubLink
draw_line(ax, 17.5, 9.65, 17.5, 8.35, '1:N')
# Hub self-relation arc
ax.annotate('', xy=(16.7, 10.3), xytext=(18.3, 10.3),
            arrowprops=dict(arrowstyle='<->', color='#555555', lw=1.0,
                           connectionstyle='arc3,rad=0.4'))
ax.text(17.5, 11.0, 'M:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9), zorder=5)

# LogisticsBatch -> Hub
draw_l_shape_v(ax, 13.5, 10.0, 16.7, 10.0, 'N:1')
# LogisticsBatch -> Warehouse
draw_l_shape_v(ax, 13.5, 9.65, 6.3, 7.3, 'N:1')
# LogisticsBatch -> LogisticsRoute
draw_l_shape_v(ax, 13.5, 9.65, 10.4, 6.0, 'N:1')

# FlowPlan -> FlowPlanItem
draw_line(ax, 17.5, 5.65, 17.5, 4.85, '1:N')
# FlowPlan -> HubLink
draw_l_shape(ax, 17.5, 5.65, 18.3, 7.65, 'N:1')

# ==================== Domain Labels ====================
ax.text(2.5, 11.5, '用户与角色域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['user_border'])
ax.text(5.0, 9.7, '商品与库存域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['product_border'])
ax.text(9.5, 11.3, '订单与配送域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['order_border'])
ax.text(13.5, 11.3, '调度域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['logistics_border'])
ax.text(17.5, 11.3, '网络与规划域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['network_border'])

# Title
ax.text(10, 11.8, '智能物流管理系统 E-R 图', ha='center', va='center',
        fontsize=16, fontweight='bold', color='#1a1a1a')

# Legend
legend_y = 3.2
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
