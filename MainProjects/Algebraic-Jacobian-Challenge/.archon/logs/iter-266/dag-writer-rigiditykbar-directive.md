# Blueprint-writer directive — RigidityKbar.tex

## Target file
`blueprint/src/chapters/RigidityKbar.tex`

## Problem (why dispatched)
`thm:rigidity_over_kbar` (≈L56) is a leandag **∞-node**: it has a full
statement and a `\section{Proof decomposition}` (steps C.2.b–C.2.e) immediately
below, but the **theorem environment itself has no `\begin{proof}` block**, so
leandag sees an empty proof body. Add a `\begin{proof}` that assembles the
existing decomposition into a coherent informal proof with a complete `\uses{}`
set. The mathematics already exists in the chapter — this is an assembly task.

## What to do
- Insert a `\begin{proof} ... \end{proof}` block for `thm:rigidity_over_kbar`
  (place it directly after the theorem, or after `rem:rigidity_over_kbar_dim_dichotomy`
  while still attaching to the theorem — the robust choice is immediately after
  `\end{theorem}` and before the remark; move the remark below the proof if
  needed).
- The proof body should walk the existing decomposition: (C.2.b) reduction to
  the project's rigidity lemma via `thm:GrpObj_eq_of_eqOnOpen`; (C.2.c) the
  image-dimension dichotomy; (C.2.d) the keystone "proper rational curves on an
  abelian variety are constant", reducing to `df = 0`; (C.2.e) promotion of
  set-level to scheme-morphism equality. Keep it a faithful high-level sketch
  that mirrors the `\section{Proof decomposition}` and the
  `\section{The shared cotangent-vanishing Mathlib pile}` (pieces (i)–(iv)).
- The `\uses{}` must list every label the proof invokes. At minimum:
  `thm:GrpObj_eq_of_eqOnOpen`, the chart-algebra core
  `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
  `lem:constants_integral_over_base_field`, the cotangent-pile pieces (i)–(iv)
  labels that exist in this chapter (e.g. `lem:GrpObj_omega_free`,
  the `df = 0` / factor-through-`Spec k` piece, and the genus-0
  `H^0(C,\Omega)=0` input), and `rem:rigidity_over_kbar_dim_dichotomy`. Inspect
  the chapter to find the exact labels for pieces (i)–(iv) and include them.
- The C.2.d keystone is gated on a route choice (route (a) cotangent-bundle vs
  route (b) dual-AV). State the proof conditionally on whichever sub-lemmas the
  chapter already names; the goal is a **finite** informal proof whose `\uses{}`
  point at in-chapter (or cross-chapter) declarations — not ∞.

## Hard constraints
- Purely mathematical prose; no Lean code/tactics. Only the existing `\lean{}`
  annotation names Lean.
- **Do NOT add `\leanok`.**
- Do not change the theorem statement, the iter-152 alg-closed-pivot prose, or
  any `% SOURCE` block. Mumford II §4 is unbundled (paywalled) — keep the
  existing `\textit{Source: Mumford, Abelian Varieties, II §4.}` exactly; do not
  fabricate a quote.

## References (already cited in-chapter)
- Mumford, *Abelian Varieties*, II §4 (unbundled — no quote; keep as is).
- Milne, *Abelian Varieties*, §I.1, §I.3 (`references/abelian-varieties.pdf`) —
  rigidity / rational-curve-constancy context.
- `references/stacks-varieties.tex` — tag 04QM (smooth ⇒ geometrically reduced).

## Out of scope
- Do not touch other chapters.
- Do not attempt to resolve the route (a)/(b) gating choice — just produce an
  assembled informal proof referencing the in-chapter sub-lemmas.
