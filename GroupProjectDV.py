"""
Superstore Intelligence Dashboard
E-Commerce domain | Built with Streamlit + Plotly
Run with: streamlit run GroupProjectDV.py
"""

import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime

# ============================================================
# PAGE CONFIG
# ============================================================
st.set_page_config(
    page_title="Superstore Intelligence Dashboard",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

NAVY = "#16213E"
AMBER = "#E8A33D"
PROFIT = "#2F9E5B"
LOSS = "#D64550"
CAT_COLORS = {"Furniture": NAVY, "Office Supplies": AMBER, "Technology": PROFIT}

# ============================================================
# LOAD DATA
# ============================================================
@st.cache_data
def load_data():
    df = pd.read_csv("superstore_dataset.csv")
    df["Order Date"] = pd.to_datetime(df["Order Date"])
    df["Ship Date"] = pd.to_datetime(df["Ship Date"])
    df["Year"] = df["Order Date"].dt.year
    df["Month"] = df["Order Date"].dt.to_period("M").astype(str)
    return df

df = load_data()

# ============================================================
# SESSION STATE
# ============================================================
if "mode" not in st.session_state:
    st.session_state.mode = "Standard View"
if "drill_category" not in st.session_state:
    st.session_state.drill_category = None

# ============================================================
# MODE-BASED STYLING (User-Centered Design)
# ============================================================
def inject_css(mode):
    base_font = "16px"
    if mode == "Large Text View":
        base_font = "21px"
    elif mode == "Simple View":
        base_font = "18px"

    st.markdown(f"""
    <style>
    html, body, [class*="css"]  {{
        font-size: {base_font};
    }}
    .kpi-card {{
        background:#fff; border:1px solid #E2E5EE; border-radius:14px;
        padding:16px 18px; text-align:center;
    }}
    .kpi-label {{ font-size:0.75em; color:#5B6584; font-weight:600; text-transform:uppercase; letter-spacing:0.04em; }}
    .kpi-value {{ font-size:1.6em; font-weight:700; color:{NAVY}; margin-top:4px; }}
    .insight-box {{
        background:#FFF7E8; border:1px solid #F1D9A6; border-radius:10px;
        padding:12px 14px; margin-bottom:10px; font-size:0.95em; color:#7A5A1B;
    }}
    .stButton button {{ border-radius:10px; font-weight:600; }}
    </style>
    """, unsafe_allow_html=True)

inject_css(st.session_state.mode)

# ============================================================
# TOP BAR
# ============================================================
top_left, top_right = st.columns([3, 2])
with top_left:
    st.markdown("<h1 style='color:#FFFFFF; margin-bottom:0;'>📊 Superstore Intelligence</h1>", unsafe_allow_html=True)
    st.caption("E-Commerce Performance Dashboard · Sample Superstore dataset, 2015–2018")
with top_right:
    st.session_state.mode = st.radio(
        "Display mode",
        ["Simple View", "Standard View", "Large Text View"],
        index=["Simple View", "Standard View", "Large Text View"].index(st.session_state.mode),
        horizontal=True,
        label_visibility="collapsed"
    )

mode = st.session_state.mode
st.divider()

# ============================================================
# SIDEBAR FILTERS (hidden in Simple View)
# ============================================================
regions_all = sorted(df["Region"].unique())
categories_all = sorted(df["Category"].unique())
segments_all = sorted(df["Segment"].unique())
years_all = sorted(df["Year"].unique())

def _init_filter_state():
    defaults = {"f_regions": [], "f_categories": [], "f_segments": [], "f_years": [], "f_state": ""}
    for k, v in defaults.items():
        if k not in st.session_state:
            st.session_state[k] = v

_init_filter_state()

def _clear_filters():
    st.session_state.drill_category = None
    st.session_state.f_regions = []
    st.session_state.f_categories = []
    st.session_state.f_segments = []
    st.session_state.f_years = []
    st.session_state.f_state = ""

if mode != "Simple View":
    with st.sidebar:
        st.header("Filters")
        f_regions = st.multiselect("Region", regions_all, key="f_regions")
        f_categories = st.multiselect("Category", categories_all, key="f_categories")
        f_segments = st.multiselect("Customer Segment", segments_all, key="f_segments")
        f_years = st.multiselect("Order Year", years_all, key="f_years")
        f_state = st.text_input("Search state", key="f_state")
        st.button("Clear all filters", on_click=_clear_filters)
else:
    # Simple View: one big category picker instead of a filter sidebar
    f_regions, f_segments, f_years, f_state = [], [], [], ""
    icons = {"Furniture": "🪑", "Office Supplies": "📎", "Technology": "💻"}
    st.markdown("### Pick a category")
    cols = st.columns(len(categories_all) + 1)
    picked = None
    if cols[0].button("🛒 Everything", use_container_width=True):
        picked = []
    for i, cat in enumerate(categories_all):
        if cols[i + 1].button(f"{icons.get(cat,'📦')} {cat}", use_container_width=True):
            picked = [cat]
    if "simple_cat" not in st.session_state:
        st.session_state.simple_cat = []
    if picked is not None:
        st.session_state.simple_cat = picked
    f_categories = st.session_state.simple_cat

# ============================================================
# APPLY FILTERS
# ============================================================
filtered = df.copy()
if f_regions:
    filtered = filtered[filtered["Region"].isin(f_regions)]
if f_categories:
    filtered = filtered[filtered["Category"].isin(f_categories)]
if f_segments:
    filtered = filtered[filtered["Segment"].isin(f_segments)]
if f_years:
    filtered = filtered[filtered["Year"].isin(f_years)]
if f_state:
    filtered = filtered[filtered["State"].str.contains(f_state, case=False, na=False)]

# ============================================================
# KPI CARDS
# ============================================================
total_sales = filtered["Sales"].sum()
total_profit = filtered["Profit"].sum()
total_orders = len(filtered)
margin = (total_profit / total_sales * 100) if total_sales else 0
avg_discount = filtered["Discount"].mean() * 100 if total_orders else 0

if mode == "Simple View":
    c1, c2, c3 = st.columns(3)
    cards = [
        ("💰 Money Made", f"${total_sales:,.0f}"),
        ("📦 Orders Sold", f"{total_orders:,}"),
        ("📈 Profit", f"${total_profit:,.0f}"),
    ]
    for col, (label, value) in zip([c1, c2, c3], cards):
        col.markdown(f"<div class='kpi-card'><div class='kpi-label'>{label}</div>"
                      f"<div class='kpi-value'>{value}</div></div>", unsafe_allow_html=True)
else:
    c1, c2, c3, c4, c5 = st.columns(5)
    cards = [
        ("Total Sales", f"${total_sales:,.0f}"),
        ("Total Profit", f"${total_profit:,.0f}"),
        ("Total Orders", f"{total_orders:,}"),
        ("Avg Discount", f"{avg_discount:.1f}%"),
        ("Profit Margin", f"{margin:.1f}%"),
    ]
    for col, (label, value) in zip([c1, c2, c3, c4, c5], cards):
        col.markdown(f"<div class='kpi-card'><div class='kpi-label'>{label}</div>"
                      f"<div class='kpi-value'>{value}</div></div>", unsafe_allow_html=True)

st.write("")

if filtered.empty:
    st.warning("No orders match these filters. Try clearing a filter.")
    st.stop()

# ============================================================
# ROW 1: Category/Sub-category drill-down bar  +  Monthly trend
# ============================================================
row1_left, row1_right = st.columns(2)

with row1_left:
    if mode != "Simple View":
        drill_options = ["All categories"] + categories_all
        chosen = st.selectbox("Drill into a category", drill_options,
                               index=0 if not st.session_state.drill_category
                               else drill_options.index(st.session_state.drill_category))
        st.session_state.drill_category = None if chosen == "All categories" else chosen

    if st.session_state.drill_category and mode != "Simple View":
        sub = filtered[filtered["Category"] == st.session_state.drill_category]
        grouped = sub.groupby("Sub-Category")[["Sales", "Profit"]].sum().reset_index()
        grouped = grouped.sort_values("Sales", ascending=False)
        title = f"{st.session_state.drill_category}: Sales & Profit by Sub-Category"
        x_col = "Sub-Category"
    else:
        grouped = filtered.groupby("Category")[["Sales", "Profit"]].sum().reset_index()
        grouped = grouped.sort_values("Sales", ascending=False)
        title = "Sales & Profit by Category"
        x_col = "Category"

    fig_bar = go.Figure()
    fig_bar.add_bar(x=grouped[x_col], y=grouped["Sales"], name="Sales", marker_color=NAVY)
    fig_bar.add_bar(x=grouped[x_col], y=grouped["Profit"], name="Profit",
                     marker_color=[PROFIT if v >= 0 else LOSS for v in grouped["Profit"]])
    fig_bar.update_layout(title=title, barmode="group", height=380,
                           legend=dict(orientation="h", y=1.1),
                           margin=dict(t=60, b=40))
    st.plotly_chart(fig_bar, use_container_width=True)

with row1_right:
    monthly = filtered.groupby("Month")["Sales"].sum().reset_index().sort_values("Month")
    fig_line = px.area(monthly, x="Month", y="Sales", title="Monthly Sales Trend")
    fig_line.update_traces(line_color=NAVY, fillcolor="rgba(22,33,62,0.15)")
    fig_line.update_layout(height=380, margin=dict(t=60, b=40))
    fig_line.update_xaxes(rangeslider_visible=(mode != "Simple View"))
    st.plotly_chart(fig_line, use_container_width=True)

# ============================================================
# ADVANCED VIEWS (hidden in Simple View)
# ============================================================
if mode != "Simple View":

    st.markdown("### Advanced Visualizations")
    row2_left, row2_right = st.columns(2)

    # --- Heat map: Region x Category profit margin ---
    with row2_left:
        st.markdown("**Profit Margin Heat Map** — Region vs Category")
        pivot_sales = filtered.pivot_table(index="Region", columns="Category", values="Sales", aggfunc="sum", fill_value=0)
        pivot_profit = filtered.pivot_table(index="Region", columns="Category", values="Profit", aggfunc="sum", fill_value=0)
        pivot_margin = (pivot_profit / pivot_sales.replace(0, pd.NA) * 100).fillna(0)

        fig_heat = px.imshow(
            pivot_margin, text_auto=".1f", color_continuous_scale=["#D64550", "#F6F7FB", "#2F9E5B"],
            color_continuous_midpoint=0, aspect="auto", labels=dict(color="Margin %")
        )
        fig_heat.update_layout(height=340, margin=dict(t=20, b=20))
        st.plotly_chart(fig_heat, use_container_width=True)

    # --- Parallel coordinates: Sales, Quantity, Discount, Profit ---
    with row2_right:
        st.markdown("**Sales · Quantity · Discount · Profit** — Parallel Coordinates")
        sample = filtered.sample(min(700, len(filtered)), random_state=1).copy()
        sample["CategoryCode"] = sample["Category"].map({c: i for i, c in enumerate(categories_all)})
        fig_pc = px.parallel_coordinates(
            sample,
            dimensions=["Sales", "Quantity", "Discount", "Profit"],
            color="CategoryCode",
            color_continuous_scale=[CAT_COLORS[c] for c in categories_all],
        )
        fig_pc.update_layout(height=340, margin=dict(t=20, b=20), coloraxis_showscale=False)
        st.plotly_chart(fig_pc, use_container_width=True)
        legend_html = " &nbsp; ".join(
            f"<span style='color:{CAT_COLORS[c]}'>●</span> {c}" for c in categories_all
        )
        st.markdown(legend_html, unsafe_allow_html=True)

    # ============================================================
    # ROW 3: Top states + Insights
    # ============================================================
    row3_left, row3_right = st.columns(2)

    with row3_left:
        st.markdown("**Top 10 States by Sales**")
        by_state = filtered.groupby("State")[["Sales", "Profit"]].sum().reset_index()
        by_state = by_state.sort_values("Sales", ascending=False).head(10)
        fig_state = px.bar(
            by_state.sort_values("Sales"), x="Sales", y="State", orientation="h",
            color=by_state.sort_values("Sales")["Profit"] >= 0,
            color_discrete_map={True: NAVY, False: LOSS},
        )
        fig_state.update_layout(height=340, showlegend=False, margin=dict(t=20, b=20))
        st.plotly_chart(fig_state, use_container_width=True)

    with row3_right:
        st.markdown("**Generated Insights**")

        insights = []
        by_cat = filtered.groupby("Category")[["Sales", "Profit"]].sum()
        by_cat["margin"] = by_cat["Profit"] / by_cat["Sales"] * 100
        worst_cat = by_cat["margin"].idxmin()
        if by_cat.loc[worst_cat, "margin"] < 5:
            insights.append(f"**{worst_cat}** runs the thinnest margin at {by_cat.loc[worst_cat,'margin']:.1f}%. Check discount levels here first.")

        by_sub = filtered.groupby("Sub-Category").agg(Profit=("Profit", "sum"), Discount=("Discount", "mean"))
        loss_subs = by_sub[by_sub["Profit"] < 0].sort_values("Profit")
        if len(loss_subs):
            top_loss = loss_subs.index[0]
            insights.append(f"**{top_loss}** loses money overall (${loss_subs.loc[top_loss,'Profit']:,.2f}), averaging {loss_subs.loc[top_loss,'Discount']*100:.1f}% discount. Cutting the discount here could turn it profitable.")

        by_region = filtered.groupby("Region")[["Sales", "Profit"]].sum()
        by_region["margin"] = by_region["Profit"] / by_region["Sales"] * 100
        best_region = by_region["margin"].idxmax()
        insights.append(f"**{best_region}** region holds the strongest margin at {by_region.loc[best_region,'margin']:.1f}%. Worth pushing more inventory there.")

        dec_sales = filtered[filtered["Order Date"].dt.month == 12]
        if not dec_sales.empty:
            dec_by_year = dec_sales.groupby("Year")["Sales"].sum()
            if len(dec_by_year) > 0:
                insights.append(f"Sales peak every December, averaging ${dec_by_year.mean():,.0f} that month. Plan stock and staffing ahead of year end.")

        high_disc_loss = filtered[(filtered["Discount"] >= 0.3) & (filtered["Profit"] < 0)]
        if len(high_disc_loss):
            pct = len(high_disc_loss) / len(filtered) * 100
            insights.append(f"{len(high_disc_loss)} orders ({pct:.1f}% of current view) used a discount of 30% or more and still lost money. Review the discount policy above this threshold.")

        if not insights:
            insights.append("This slice of the data looks healthy. No major risk flags found.")

        for i in insights:
            st.markdown(f"<div class='insight-box'>{i}</div>", unsafe_allow_html=True)

# ============================================================
# TIMELINE
# ============================================================
st.markdown("### Project Progress Timeline")

phases = pd.DataFrame([
    dict(Phase="Project Initiation", Start="2025-11-03", Finish="2025-11-14",
         Desc="Defined the business problem, picked the e-commerce domain, and assigned roles across the team."),
    dict(Phase="Data Collection", Start="2025-11-17", Finish="2026-01-16",
         Desc="Sourced the Sample Superstore dataset covering 9,983 orders from 2015 to 2018."),
    dict(Phase="Data Cleaning", Start="2026-01-19", Finish="2026-02-13",
         Desc="Removed rows with missing postal codes, standardized date formats, rounded currency fields."),
    dict(Phase="Dashboard Development", Start="2026-02-16", Finish="2026-05-22",
         Desc="Built the Streamlit + Plotly dashboard: KPIs, filters, drill-down, trend line, heat map, parallel coordinates."),
    dict(Phase="Testing and Validation", Start="2026-05-25", Finish="2026-07-17",
         Desc="Checked every chart against manual calculations, tested all three user modes, fixed filter edge cases."),
    dict(Phase="Deployment / Presentation", Start="2026-07-20", Finish="2026-07-24",
         Desc="Packaged source files, wrote the report and poster, rehearsed the live demo for Week 11."),
])
phases["Start"] = pd.to_datetime(phases["Start"])
phases["Finish"] = pd.to_datetime(phases["Finish"])

fig_tl = px.timeline(
    phases, x_start="Start", x_end="Finish", y="Phase", color="Phase",
    color_discrete_sequence=["#16213E", "#2F4170", "#4A639F", "#E8A33D", "#2F9E5B", "#D64550"],
)
fig_tl.update_yaxes(autorange="reversed", title="")
fig_tl.update_layout(height=280, showlegend=False, margin=dict(t=10, b=10))
st.plotly_chart(fig_tl, use_container_width=True)

with st.expander("See phase details"):
    for _, row in phases.iterrows():
        st.markdown(f"**{row['Phase']}** · {row['Start'].strftime('%b %d')}–{row['Finish'].strftime('%b %d, %Y')}  \n{row['Desc']}")

st.caption("Sample Superstore Dataset · 9,983 orders · 2015–2018 · Built with Streamlit + Plotly")