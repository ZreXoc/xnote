// xnote 组件库完整示例
// 编译: typst compile example.typ example.pdf
#import "lib.typ": *

#show: xnote.with(
  title: "xnote 组件示例",
  author: "xichen",
  date: "2026-07-20",
  abstract: [演示 xnote 的全部组件：模板参数、16 种 callout、行内工具、三线表，以及带来源定位和批注的文本、图片、代码摘录。可作为新笔记的起点模板。],
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

正文与标题统一使用无衬线字体：英文 Arial，中文优先 Noto Sans CJK SC，回退到 Microsoft YaHei。行内代码使用 Consolas，回退到 Courier New；数学公式保留原有字体设置。编译环境需安装上述字体，避免缺失字体警告。

正文直接写，支持 Typst 全部原生语法：*强调*、_斜体_、行内代码 `top-k`，以及数学公式 $L = sum_(i=1)^N ell_i$。

行内代码块会自动套灰底样式；链接自动加蓝色下划线，例如 https://typst.app 。

```python
# 块级代码保持原样
def route(x, experts, k=4):
    return topk(gate(x), k)
```

= Callout 块

16 种语义化块，统一语法 `#kind[内容]`。默认无图标，使用浅底色和细左边线；短标签与正文同行，不单独占一行。`title:` 可自定义标签，`title: none` 隐藏标签。

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
  所有 `#kind[...]` 都是 `#callout` 的包装。默认 `compact: true`；设为 `false` 可增加留白。`breakable: false` 禁止跨页断开；`color:` 和 `fill:` 可覆盖配色。
]

#note(title: none)[无标签样式，只保留正文、浅底色和左边线。]

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

= 引用、摘录与批注

`excerpt` 接收任意 Typst 内容，不自动改写原文；正文、图片和代码使用同一接口。
必填的 `source:` 可以是文献名称，也可以是原生 `cite`，与文末参考文献联动。
`page:` 记录原文页码，`location:` 记录章节、段落、公式、图号或代码行号，
`url:` 提供可点击的原文链接，`annotation:` 把自己的解读与摘录正文分开。
页码按原文填写；PDF 阅读器页序与印刷页码不一致时，在 `location:` 中注明。

== 论文文本

#excerpt(
  source: cite(<vaswani2017attention>),
  page: 1,
  location: [Abstract],
  url: "https://arxiv.org/pdf/1706.03762#page=1",
  annotation: [这里强调的是架构不依赖 recurrence 和 convolution，并不意味着不需要位置信息。],
)[
  #quote(block: true)[We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely.]
]

== 图片与图注

下面的图片是本地绘制的接口演示图，*不是论文原图*。实际使用时将图片路径替换为论文截图，
并在 `location:` 中填写原文图号及子图编号；可设 `breakable: false` 保持图片和批注在同一页。

#excerpt(
  source: [xnote 本地演示素材],
  location: [assets/excerpt-demo.svg；非论文原图],
  title: "图片摘录",
  breakable: false,
  annotation: [批注可解释箭头、符号或裁剪范围；原始图注应留在摘录正文中。],
)[
  #image("assets/excerpt-demo.svg", width: 90%)
  #par[演示图：Input → Attention → Output。]
]

== 代码摘录

代码可直接放 fenced raw block，保留语言高亮；来源位置手动标明文件、版本和行号。
下面是演示代码，不宣称来自论文或真实仓库。

#excerpt(
  source: [本节演示代码],
  location: [route.py，L1–L2；实际引用时应补充 commit],
  title: "代码摘录",
  annotation: [这里返回 expert ids；未展示 gate weights 和 expert 输出聚合。],
)[
  ```python
  def route(logits, k):
      return logits.topk(k, dim=-1).indices
  ```
]

== 独立来源与批注

已有图片或段落不需要外框时，可单独加来源行：

#source-ref(
  cite(<vaswani2017attention>),
  page: 3,
  location: [§3.2.1，Eq. (1)],
  url: "https://arxiv.org/pdf/1706.03762#page=3",
)

#annotation(title: "阅读批注")[区分原文结论与自己的推断；行内仍可使用 #highlight[高亮] 和公式 $Q K^T / sqrt(d_k)$。]

调用方式：

```typst
#excerpt(
  source: cite(<paper-key>),
  page: 5,
  location: [§3.2，Fig. 4(b)],
  url: "https://example.org/paper.pdf#page=5",
  annotation: [我的解读。],
)[
  #image("assets/paper-figure.png", width: 90%)
  原图图注。
]
#bibliography("refs.bib", title: "参考文献")
```

`source-ref` 不解析或自动验证页码；链接能否跳到指定页取决于 PDF 阅读器。
这些组件生成正文中的阅读批注，不是 PDF 阅读器里的可编辑注释对象。

= 迁移自 xyznote

xnote 的 callout 名字（`definition`、`important`、`theorem` 等）与 xyznote 基本一致，迁移通常只需把首行改成：

```typst
#import "@local/xnote:0.1.0": *
```

#warning[xyznote 特有的组件（如参考文献样式、特定封面）xnote 未覆盖，迁移前先 grep 一遍原文件用到的函数名。]

= 参考文献

#bibliography("refs.bib", title: none)
