# Blueprint Reviewer Directive

## Slug
iter154

## Iter
154

## Why now

A significant blueprint-writer round landed this iter on
`blueprint/src/chapters/RigidityKbar.tex`: the proof block of
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM) was
rewritten to present a NEW live route — the single-element / perfect-field /
Jacobi–Zariski `H1Cotangent` assembly (FT.1)–(FT.3) — replacing the prior
separating-transcendence-basis sketch. The (C.a)–(C.c) polynomial-ring
helpers and the (p1)/(p2) exploration blocks were demoted to a marked
"Historical record (NOT on the critical path)" section. This route is the
basis for a KDM prover lane I intend to dispatch on
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` THIS iter, so I need a
current HARD-GATE audit of `RigidityKbar.tex`.

## Scope

Audit the WHOLE blueprint as usual (the cross-chapter view is the point).
Render your standard per-chapter completeness/correctness checklist.

Pay particular attention to:

- **`RigidityKbar.tex` (KDM proof block)** — is the new live (FT.1)–(FT.3)
  route mathematically correct and detailed enough for a prover to formalize?
  Are the `[verified]` Mathlib lemma names plausible and used in the right
  roles (no obvious misuse of `H1Cotangent.exact_δ_mapBaseChange`,
  `FormallySmooth.of_perfectField`, `FaithfullyFlat.one_tmul_eq_zero_iff`,
  `isLocalizedModule_map`, `polynomialEquiv_D`,
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`)? Does the demotion of
  (C.a)–(C.c)/(p1)/(p2) leave the live route unambiguous and the chapter
  internally consistent?
- **Dependency-graph hygiene** — the writer reports the KDM *statement-block*
  `\uses{...}` still lists `lem:chart_algebra_isPushout_of_affine_product` and
  `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`, while the new
  live proof route depends on neither (it is a self-contained Mathlib
  assembly). Flag whether this over-declaration is a must-fix (e.g. it
  mis-propagates `\leanok` or breaks a `\uses` edge) or merely cosmetic, and
  whether `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` is now
  orphaned.
- Any broken `\ref`/`\uses`/`\cref` introduced by the rewrite.

## Output

Your standard per-chapter checklist + must-fix block. The single decision I
need from you: does `RigidityKbar.tex` clear the HARD GATE for a KDM prover
lane on `ChartAlgebra.lean` this iter?
