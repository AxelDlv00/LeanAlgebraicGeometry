# Blueprint Writer Report

## Slug
h1v-substrate-pins

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_H1Vanishing.tex

## Changes Made
- **Added lemma** `\lemma`/`\label{lem:flasque_cokernel_short_exact}`/
  `\lean{AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque}`
  — pins the iter-193 substrate helper "cokernel of a flasque-by-flasque
  short exact sequence is flasque" with the section-level
  surjectivity (Hartshorne~II.1~Ex.~1.16(b)) packaged as an explicit
  hypothesis rather than invoked internally. Prose summarises the four-line
  Lean proof (lift-extend-push pattern via naturality).
- **Added lemma** `\lemma`/`\label{lem:ext_succ_zero_of_injective_lower_zero}`/
  `\lean{AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero}`
  — pins the iter-193 abstract degree-shift lemma:
  in any abelian category with `HasExt`, a short exact sequence with
  injective middle term lets $\Ext^{n_0}(X, S_3) = 0$ propagate to
  $\Ext^{n_0+1}(X, S_1) = 0$ for $n_0 \ge 1$. Prose
  records the injective-dimension subsingleton + LES-surjectivity
  argument that the Lean proof realises.
- **Placement**: both blocks inserted immediately after the
  `\begin{proof}...\end{proof}` for the constant-sheaf flasqueness lemma
  (former line 182), and immediately before the
  `\begin{theorem}` block for `thm:H1_vanishing_flasque` (former line 184)
  — i.e.\ at the natural seam where the chapter transitions from "what
  flasqueness is" to "why flasqueness kills higher cohomology".
- **Deleted disclaimer**: removed the trailing
  "The Hartshorne~II~Exercise~1.16(b),(c) inputs..." bullet from the
  "Out of scope" section. That bullet asserted these helpers were
  "sketched inside the proof but not given their own
  `\lemma` block" — which is no longer true now that the 1.16(c)
  cokernel-helper has its own pin and the project carries an explicit
  abstract degree-shift helper. The remaining out-of-scope items
  (general coherent vanishing, Serre duality, the $H^0$ half of
  $\chi(k(P)) = 1$) are unchanged.

## Cross-references introduced
- `\uses{def:isFlasque_sheaf}` on `lem:flasque_cokernel_short_exact` —
  verify `def:isFlasque_sheaf` exists in this same chapter (it does:
  line 76 of the original).
- `\uses{def:Scheme_HModule}` on `lem:ext_succ_zero_of_injective_lower_zero`
  — verify `def:Scheme_HModule` exists in
  `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`
  (confirmed via grep at line 187 of that chapter). The directive
  sketched `lem:HModule_def`, which is not a label that exists in the
  blueprint; I replaced it with the actual `def:Scheme_HModule` label.

## Lean namespace verification
- `ext_succ_eq_zero_of_injective_of_lower_zero` is declared at
  `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean:273` inside
  `namespace AlgebraicGeometry` (the file opens this namespace at L78
  and closes it at L709). The declaration itself is **not** prefixed
  with `Scheme.` in its source name. The fully-qualified name is
  therefore `AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero`,
  not `AlgebraicGeometry.Scheme.ext_succ_eq_zero_of_injective_of_lower_zero`
  as the directive's sketch suggested. The `\lean{...}` pin in the
  added lemma uses the correct fully-qualified name.
- `Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque` is declared
  at L356 inside the same `namespace AlgebraicGeometry`, so its
  fully-qualified name is
  `AlgebraicGeometry.Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque`
  — matching the directive sketch.

## References consulted
- No new `references/` files opened this session. Both added blocks are
  project-bespoke substrate (per the directive's "project-bespoke
  iter-193 substrate" guidance), so no verbatim external `% SOURCE
  QUOTE:` is required. The classical Hartshorne pointers in the
  `% SOURCE:` comments simply locate the underlying mathematical
  statement and explicitly defer the verbatim quote to the existing
  `thm:H1_vanishing_flasque` block where the Hartshorne~III.2.5 quote
  already lives in the chapter.

## Macros needed (if any)
- None. The blocks reuse `\Module`, `\Opens`, `\Ext`, `\HModule`,
  `\mathtt`, `\bar`, `\mathcal`, `\cref` — all already in use elsewhere
  in this chapter.

## Reference-retriever dispatches (if any)
- None. The directive explicitly stated that both helpers are
  project-bespoke and that no verbatim external quote is needed.

## Notes for Plan Agent
- The directive's literal sketch contained two minor errata that I
  corrected:
  - `\lean{AlgebraicGeometry.Scheme.ext_succ_eq_zero_of_injective_of_lower_zero}`
    → corrected to `\lean{AlgebraicGeometry.ext_succ_eq_zero_of_injective_of_lower_zero}`
    (no `Scheme.` prefix in the Lean source).
  - `\uses{lem:HModule_def}` → corrected to `\uses{def:Scheme_HModule}`
    (the actual existing definition label in
    `Cohomology_StructureSheafModuleK.tex`).
- The `lem:ext_succ_zero_of_injective_lower_zero` block is stated in
  full generality over any abelian category with `HasExt` — the Lean
  declaration matches this abstraction. The chapter title and
  surrounding prose are about flasque-cohomology on a curve, but the
  helper itself is purely a structural Ext-LES degree-shift. I judged
  it correct to keep the prose at the level of the Lean signature; the
  consumer (the `i ≥ 2` inductive case of `HModule_flasque_eq_zero`)
  specialises to the sheaf category at the call site. If a reviewer
  prefers a sheaf-specialised restatement be added alongside, that
  would be a separate writer round.
- The `\textit{Source: ...}` line for
  `lem:flasque_cokernel_short_exact` says "project-bespoke iter-193
  substrate (Hartshorne~II.1, Exercise~1.16(c) packaged with the
  sections-surjectivity input from II.1, Exercise~1.16(b) as a
  hypothesis)". The reason for the explicit dual-cite is that the
  Lean signature truly takes the 1.16(b) input as a parameter rather
  than calling `shortExact_app_surjective` internally — the prose
  reflects this so a future prover wiring the consumer site
  understands why the hypothesis bundle is what it is.
- A separate iter-195+ writer round will be needed for the two
  still-unpinned substrate sorries (`shortExact_app_surjective` =
  Hartshorne II.1 Ex 1.16(b); `injective_flasque` = Hartshorne III
  Lemma 2.4). The current chapter no longer carries a disclaimer
  about these — they are simply not pinned yet.

## Strategy-modifying findings
None. The writer round is a marker-discipline fix: it adds blueprint
pins for two helpers that the iter-193 prover already landed
axiom-clean. The strategy itself (Lane H = flasque-then-skyscraper
$H^1$ vanishing route) is unchanged.
