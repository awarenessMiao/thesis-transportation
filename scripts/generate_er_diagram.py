#!/usr/bin/env python3
"""Generate a standard ER diagram for the thesis using matplotlib."""

import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.patches import FancyBboxPatch, ConnectionPatch
import numpy as np

plt.rcParams['font.family'] = ['Arial Unicode MS', 'SimHei', 'sans-serif']
plt.rcParams['axes.unicode_minus'] = False

fig, ax = plt.subplots(1, 1, figsize=(18, 12))
ax.set_xlim(0, 18)
ax.set_ylim(0, 12)
ax.axis('off')
fig.patch.set_facecolor('white')
ax.set_facecolor('white')

# Color scheme - academic style
colors = {
    'user': '#E3F2FD',      # light blue
    'user_border': '#1565C0',
    'product': '#E8F5E9',   # light green
    'product_border': '#2E7D32',
    'order': '#FFF3E0',     # light orange
    'order_border': '#E65100',
    'logistics': '#F3E5F5', # light purple
    'logistics_border': '#6A1B9A',
    'network': '#E0F7FA',   # light cyan
    'network_border': '#00838F',
    'relation': '#FFFDE7',  # light yellow
    'relation_border': '#F9A825',
}

def draw_entity(ax, x, y, w, h, name, color_key, font_size=10):
    """Draw an entity rectangle."""
    box = FancyBboxPatch((x - w/2, y - h/2), w, h,
                         boxstyle="round,pad=0.02,rounding_size=0.15",
                         facecolor=colors[color_key],
                         edgecolor=colors[f'{color_key}_border'],
                         linewidth=1.5)
    ax.add_patch(box)
    ax.text(x, y, name, ha='center', va='center', fontsize=font_size,
            fontweight='bold', color=colors[f'{color_key}_border'])
    return box

def draw_relation_diamond(ax, x, y, name, w=1.0, h=0.6):
    """Draw a relation diamond."""
    diamond = patches.RegularPolygon((x, y), numVertices=4, radius=0.5,
                                      orientation=np.pi/4,
                                      facecolor=colors['relation'],
                                      edgecolor=colors['relation_border'],
                                      linewidth=1.2)
    ax.add_patch(diamond)
    ax.text(x, y, name, ha='center', va='center', fontsize=8,
            color=colors['relation_border'])

def draw_line_with_cardinality(ax, x1, y1, x2, y2, card1, card2, color='#555555'):
    """Draw a line with cardinality labels."""
    ax.plot([x1, x2], [y1, y2], color=color, linewidth=1.0, zorder=1)
    # Compute label positions
    dx, dy = x2 - x1, y2 - y1
    dist = np.hypot(dx, dy)
    if dist < 0.1:
        return
    ux, uy = dx/dist, dy/dist
    # offset for labels
    off = 0.25
    lx1, ly1 = x1 + ux*off, y1 + uy*off
    lx2, ly2 = x2 - ux*off, y2 - uy*off
    ax.text(lx1, ly1, card1, ha='center', va='center', fontsize=8,
            color='#333333', bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))
    ax.text(lx2, ly2, card2, ha='center', va='center', fontsize=8,
            color='#333333', bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# ==================== Entities ====================
# User domain (left-top)
draw_entity(ax, 2.5, 10.5, 1.6, 0.7, 'User', 'user')
draw_entity(ax, 1.2, 8.8, 1.6, 0.7, 'Customer', 'user')
draw_entity(ax, 2.5, 8.8, 1.6, 0.7, 'Shop', 'product')
draw_entity(ax, 3.8, 8.8, 1.6, 0.7, 'Driver', 'user')
draw_entity(ax, 1.2, 7.3, 1.6, 0.7, 'Address', 'user')

# Product domain (left-middle)
draw_entity(ax, 2.5, 5.8, 1.6, 0.7, 'Product', 'product')
draw_entity(ax, 2.5, 4.3, 1.6, 0.7, 'Warehouse', 'product')
draw_entity(ax, 1.2, 5.0, 1.8, 0.7, 'Product\nWarehouse', 'product', font_size=9)

# Order domain (center)
draw_entity(ax, 7.0, 8.8, 1.6, 0.7, 'OrderInfo', 'order')
draw_entity(ax, 7.0, 7.3, 1.6, 0.7, 'Delivery', 'order')
draw_entity(ax, 7.0, 5.8, 1.8, 0.7, 'Logistics\nRoute', 'order', font_size=9)

# Logistics/Network domain (right)
draw_entity(ax, 11.5, 10.5, 1.6, 0.7, 'Hub', 'network')
draw_entity(ax, 11.5, 8.8, 1.6, 0.7, 'HubLink', 'network')
draw_entity(ax, 11.5, 7.3, 1.8, 0.7, 'Logistics\nBatch', 'logistics', font_size=9)
draw_entity(ax, 11.5, 5.8, 1.8, 0.7, 'BatchItem', 'logistics', font_size=9)
draw_entity(ax, 15.5, 8.8, 1.8, 0.7, 'Dispatch\nPool', 'logistics', font_size=9)

# Planning domain (right-bottom)
draw_entity(ax, 15.5, 5.8, 1.6, 0.7, 'FlowPlan', 'network')
draw_entity(ax, 15.5, 4.3, 1.8, 0.7, 'FlowPlan\nItem', 'network', font_size=9)

# ==================== Relations ====================
# User -> roles
draw_line_with_cardinality(ax, 2.5, 10.15, 1.2, 9.15, '1', '1')
draw_line_with_cardinality(ax, 2.5, 10.15, 2.5, 9.15, '1', '1')
draw_line_with_cardinality(ax, 2.5, 10.15, 3.8, 9.15, '1', '1')

# Customer -> Address
draw_line_with_cardinality(ax, 1.2, 8.45, 1.2, 7.65, '1', 'N')

# Shop -> Product, Warehouse
draw_line_with_cardinality(ax, 2.5, 8.45, 2.5, 6.15, '1', 'N')
draw_line_with_cardinality(ax, 2.5, 8.45, 2.5, 4.65, '1', 'N')

# Product <-> Warehouse (via ProductWarehouse)
draw_line_with_cardinality(ax, 1.7, 5.5, 1.2, 5.3, 'N', '1')
draw_line_with_cardinality(ax, 2.1, 5.3, 2.5, 4.65, '1', 'N')
# fix: direct line from Product to ProductWarehouse
draw_line_with_cardinality(ax, 2.5, 5.45, 2.1, 5.15, '1', 'N')
draw_line_with_cardinality(ax, 1.2, 5.15, 1.2, 5.65, 'N', '1')

# ProductWarehouse center at (1.2, 5.0), connect to Product (2.5, 5.8) and Warehouse (2.5, 4.3)
# redraw cleanly
# Product (2.5, 5.8) -> ProductWarehouse (1.2, 5.0)
# Warehouse (2.5, 4.3) -> ProductWarehouse (1.2, 5.0)

# OrderInfo connections
draw_line_with_cardinality(ax, 6.2, 8.8, 3.8, 8.8, 'N', '1')  # Order -> Shop
# Customer to OrderInfo
ax.annotate('', xy=(6.2, 8.9), xytext=(2.0, 8.9),
            arrowprops=dict(arrowstyle='-', color='#555555', lw=1.0))
ax.text(4.1, 9.15, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# Address to OrderInfo
ax.plot([1.2, 1.2, 6.2], [6.95, 6.0, 6.0], color='#555555', linewidth=1.0)
ax.text(3.7, 6.25, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# Warehouse to OrderInfo
ax.plot([2.5, 4.5, 4.5, 6.2], [4.65, 4.65, 7.5, 7.5], color='#555555', linewidth=1.0)
ax.text(4.7, 4.9, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# OrderInfo -> Delivery
draw_line_with_cardinality(ax, 7.0, 8.45, 7.0, 7.65, '1', 'N')

# Delivery -> Driver
ax.plot([7.8, 8.5, 8.5, 3.8], [7.3, 7.3, 8.5, 8.5], color='#555555', linewidth=1.0)
ax.text(8.7, 7.55, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# OrderInfo -> LogisticsRoute
draw_line_with_cardinality(ax, 7.0, 6.15, 7.0, 6.95, '1', 'N')
# LogisticsRoute -> Driver
ax.plot([7.8, 8.8, 8.8, 3.8], [5.8, 5.8, 8.5, 8.5], color='#555555', linewidth=1.0)
ax.text(8.9, 6.05, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# Hub <-> HubLink (self-relation via two foreign keys)
# Hub (11.5, 10.5) -> HubLink (11.5, 8.8)
draw_line_with_cardinality(ax, 11.5, 10.15, 11.5, 9.15, '1', 'N')
# HubLink has from_hub and to_hub, show as M:N self relation on Hub
# Add a curved line for Hub self relation
ax.annotate('', xy=(10.7, 10.8), xytext=(12.3, 10.8),
            arrowprops=dict(arrowstyle='<->', color='#555555', lw=1.0,
                           connectionstyle='arc3,rad=0.3'))
ax.text(11.5, 11.4, 'M:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# LogisticsBatch -> BatchItem
draw_line_with_cardinality(ax, 11.5, 6.95, 11.5, 6.15, '1', 'N')

# BatchItem -> OrderInfo
ax.plot([10.6, 9.0, 9.0, 7.8], [5.8, 5.8, 8.5, 8.5], color='#555555', linewidth=1.0)
ax.text(9.2, 6.05, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# OrderInfo -> DispatchPool
ax.plot([7.8, 9.5, 9.5, 14.6], [8.5, 8.5, 8.8, 8.8], color='#555555', linewidth=1.0)
ax.text(11.2, 9.05, '1:N', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# FlowPlan -> FlowPlanItem
draw_line_with_cardinality(ax, 15.5, 5.45, 15.5, 4.65, '1', 'N')

# FlowPlan -> HubLink
ax.plot([14.7, 13.5, 13.5, 12.4], [5.8, 5.8, 8.8, 8.8], color='#555555', linewidth=1.0)
ax.text(13.7, 6.05, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# LogisticsBatch -> Hub
ax.plot([11.5, 11.5], [7.65, 7.65], color='#555555', linewidth=1.0)  # placeholder
ax.plot([10.6, 10.0, 10.0, 11.5], [7.3, 7.3, 9.9, 9.9], color='#555555', linewidth=1.0)
ax.text(10.2, 7.55, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# LogisticsBatch -> Warehouse
ax.plot([10.6, 5.0, 5.0, 3.3], [5.8, 5.8, 4.3, 4.3], color='#555555', linewidth=1.0)
ax.text(7.0, 6.05, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# LogisticsRoute -> LogisticsBatch (via route_id in batch or trunk_route_id)
# Actually LogisticsBatch has trunk_route_id, let's connect
ax.plot([8.0, 9.0, 9.0, 10.6], [5.8, 5.8, 7.3, 7.3], color='#555555', linewidth=1.0)
ax.text(8.5, 6.05, 'N:1', ha='center', va='center', fontsize=8, color='#333333',
        bbox=dict(boxstyle='round,pad=0.15', facecolor='white', edgecolor='none', alpha=0.9))

# Add legend / domain labels
ax.text(2.5, 11.5, '用户与角色域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['user_border'])
ax.text(2.5, 6.7, '商品与库存域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['product_border'])
ax.text(7.0, 9.7, '订单与配送域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['order_border'])
ax.text(13.5, 11.5, '网络与调度域', ha='center', va='center', fontsize=11,
        fontweight='bold', color=colors['network_border'])

# Title
ax.text(9, 11.8, '智能物流管理系统 E-R 图', ha='center', va='center',
        fontsize=16, fontweight='bold', color='#1a1a1a')

plt.tight_layout()
plt.savefig('/Users/miao/CodeBuddy/thesis-transportation/template/figures/er-diagram.png',
            dpi=300, bbox_inches='tight', facecolor='white', edgecolor='none')
print('ER diagram saved to figures/er-diagram.png')
