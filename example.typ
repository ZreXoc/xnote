// xnote 组件库完整示例
// 编译: typst compile example.typ example.pdf
#import "lib.typ": *

#show: xnote.with(
  title: "xnote 组件示例",
  author: "xichen",
  date: "2026-07-20",
  abstract: [演示 xnote 的全部组件：模板参数、16 种 callout、行内工具与三线表。可作为新笔记的起点模板。],
)

= 模板参数

`xnote.with()` 支持的参数与默认值：

#kv-table((
  ([`title`], [文档标题，居中大字渲染]),
  ([`author` / `date` / `abstract`], [默认 `none`，给了才渲染]),
  ([`lang`], [默认 `"zh"`，影响「摘要」「目录」措辞]),
  ([`outline-title`], [默认 `auto` 生成目录；设 `none` 关闭]),
  ([`heading-numbering`], [默认 `"1.1"`；设 `none` 取消标题编号]),
  ([`font-size` / `margin` / `paper`], [默认 `10.5pt` / `(x: 2.2cm, y: 2.4cm)` / `"a4"`]),
))

#tip[不想每次开头都有目录？`outline-title: none`，短笔记更干净。]

= 基础排版

正文直接写，支持 Typst 全部原生语法：*强调*、_斜体_、行内代码 `top-k`，以及数学公式 $L = sum_(i=1)^N ell_i$。

行内代码块会自动套灰底样式；链接自动加蓝色下划线，例如 https://typst.app 。

```python
# 块级代码保持原样
def route(x, experts, k=4):
    return topk(gate(x), k)
```

= Callout 块

16 种语义化块，统一语法 `#kind[内容]`，全部支持 `title:` 自定义标题。

== 通用提示类

#note[背景信息、引用约定、阅读前提。]

#tip[最佳实践与操作建议。]

#important[不能遗漏的核心结论。]

#warning[风险与边界条件，例如某结论只在 W3 QAT 下验证过。]

#danger[会造成不可逆后果的操作。]

== 研究流程类

#question(title: "Open Question")[Late-layer routing drift 是否有统一的 margin 判据？]

#hypothesis[High-margin route changes 比 boundary reshuffling 更有害。]

#experiment[对 `high_margin_changed` tokens 强制 FP top-4 expert ids，比较 token-level NLL。]

#observation[W3 模型中 L19–L23 的 changed fraction 集中在 4% 附近。]

#result[Forced FP route 显著降低 NLL，expert id change 具有因果伤害。]

== 学术结构类

#definition(title: "Routing Drift")[量化后 router logits、gate weights 或 top-k expert set 相对 FP 模型发生的变化。]

#theorem[若 gate margin 足够大，则 top-k 集合在微小扰动下保持不变。]

#proof[由 margin 定义，扰动上界小于最小 margin 时排序不变，故 top-k 不变。]

#example[Qwen1.5-MoE 在 W3 量化下，L23 的 top-4 集合变化率为 4.21%。]

== 任务管理类

#task[本周完成 forced-route intervention 的 L21 复现。]

#todo[把 xnote 迁移到所有活跃笔记。]

== Callout 参数

#callout(kind: "note", title: "自定义标题", compact: true)[
  所有 `#kind[...]` 都是 `#callout` 的包装。`compact: true` 更紧凑；`breakable: false` 禁止跨页断开；`color:` 和 `fill:` 可覆盖配色。
]

= 行内与块级小工具

关键概念可用 #highlight[行内高亮] 标出，适合术语首次出现。

#markbox[整段强调框。比 callout 朴素，没有图标和标题，适合大段引用或核心论证。]

#side-note[紧凑旁注，适合补充一句不打断主线的话。]

#sectionline

= 表格

== 三线表 tri-table

#tri-table(
  columns: (1.2fr, 1fr, 1fr, 1fr),
  header: ([Layer], [Fraction], [Delta NLL], [Lift]),
  rows: (
    ([L23], [0.0421], [0.2323], [+0.1122]),
    ([L21], [0.0442], [0.2152], [+0.0945]),
    ([L19], [0.0394], [0.2080], [+0.0866]),
  ),
  caption: [Late-layer high-margin changed bucket],
)

== 键值表 kv-table

#kv-table((
  ([模型], [Qwen1.5-MoE]),
  ([量化], [W3 QAT]),
  ([方法], [EfficientQAT-style Block-AP]),
  ([下一步], [forced-route intervention]),
))

== 紧凑表 dense-table

#dense-table(
  header: ([符号], [含义]),
  rows: (
    [$g_i$], [router logit],
    [$m$], [top-k margin],
    [$E_k$], [top-k expert set],
  ).chunks(2),
)

#tip[`booktabs` 是 `tri-table` 的别名，习惯 LaTeX 命名可以直接用。]

= 迁移自 xyznote

xnote 的 callout 名字（`definition`、`important`、`theorem` 等）与 xyznote 基本一致，迁移通常只需把首行改成：

```typst
#import "@local/xnote:0.1.0": *
```

#warning[xyznote 特有的组件（如参考文献样式、特定封面）xnote 未覆盖，迁移前先 grep 一遍原文件用到的函数名。]
