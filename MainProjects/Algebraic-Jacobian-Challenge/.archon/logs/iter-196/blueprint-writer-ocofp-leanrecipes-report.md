# Blueprint Writer Report

## Slug
ocofp-leanrecipes

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_OCofP.tex

## LOC delta
+368 lines (chapter grew from 720 to 1088 lines). Single net insertion
between the close of the `dim_eq_two_of_genusZero` proof (line 629) and
the opening of the `\section{Existence of a non-constant rational
function}` (now at line 1031). All 368 added lines comprise one new
`\subsection` containing three `\lemma`/`\proof` blocks and a short
contextual lead-in paragraph.

## Changes Made
- **Added subsection** `\subsection{Iter-195 substrate substeps for the
  non-constant-rational corollary}` (label
  `\label{subsec:lineBundleAtClosedPoint_substrate_substeps}`) — frames
  the three new sub-claims as project-bespoke decompositions of the
  iter-195 private helper
  `exists_nonconstant_rational_from_dim_eq_two`'s residual content
  (OCofP.lean:1421--1440).
- **Added lemma** `\label{lem:lineBundleAtClosedPoint_toFunctionField_injective}`
  with `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective}` —
  sub-claim (a). Proof sketch decomposes `toFunctionField` as a
  five-layer composition: (1) `HModule_zero_linearEquiv` (project-side
  bridge in `Cohomology/StructureSheafModuleK.lean`), (2)
  `sheafToPresheaf.map` (Mathlib `Sheaf.fullyFaithfulSheafToPresheaf`),
  (3) `constantSheafAdj.homEquiv` (Mathlib constant-sheaf adjunction),
  (4) evaluation at `1 : kbar` (Mathlib `LinearMap.applyOneEquiv` or
  hand-roll), (5) `Subtype.val` on the `carrierSubmoduleSheaf` carrier.
  Layers (1)--(4) are `LinearEquiv`s; layer (5) is
  `Subtype.val_injective`. The composition is therefore a
  `kbar`-linear injection, and `s ≠ 0 ⇒ ι(s) ≠ 0` follows. Estimated
  formalisation footprint: ~30--50 LOC.
- **Added lemma** `\label{lem:lineBundleAtClosedPoint_order_conditions_of_globalSection}`
  with `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection}` —
  sub-claim (b). The proof sketch is a one-line invocation of the
  existing private `globalSections_iff_mpr` helper (line 1024 of
  OCofP.lean) with witness `⟨s, hf_def.symm⟩` from the iter-195
  setup. Estimated formalisation footprint: ~10 LOC (typeclass
  alignment dominates).
- **Added lemma** `\label{lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant}`
  with `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant}` —
  sub-claim (c). Contrapositive proof: if `principal f = 0` then
  `ord_Q(f) = 0` for every `Q`, so `f ∈ Γ(C, 𝒪_C)`, so `f ∈ k̄`
  (Hartshorne I.3.4 / Stacks tag 01XU); together with `f ≠ 0` and
  units (Stacks tag 02P0), `f ∈ k̄^×`. Then with `s` the non-constant
  candidate from iter-195 setup, set `c := f`; `kbar`-linearity of
  `toFunctionField` (`htF_smul` + `htF_add` already in scope, lines
  1364--1387) and `hs1 : toFunctionField s₁ = 1` give
  `ι(s − c·s₁) = 0`; by sub-claim (a)'s injectivity,
  `s = c·s₁ ∈ kbar·s₁`, contradicting `hs_not_const`. Estimated
  formalisation footprint: ~30--50 LOC (plus an optional ~15--25 LOC
  helper for the Hartshorne I.3.4 input if not already available
  project-side).

## New \lean{...} pins introduced
1. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective`
2. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection`
3. `AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant`

(Each is a NEW project-side substrate declaration the iter-196 prover
will introduce — they do not yet exist in the Lean source.
`globalSections_iff_mpr` referenced inside sub-claim (b)'s proof
sketch already exists as a `private lemma` at OCofP.lean:1024 and is
not a new pin.)

## Cross-references introduced
- `\uses{def:lineBundleAtClosedPoint_toFunctionField,
  def:lineBundleAtClosedPoint_carrierSubmoduleSheaf,
  def:lineBundleAtClosedPoint}` on sub-claim (a) — verified all three
  labels exist in the same chapter (lines 273, 158, 191).
- `\uses{lem:lineBundleAtClosedPoint_globalSections_iff,
  def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}` inside the proof
  of sub-claim (a) — same chapter, lines 331, 158.
- `\uses{lem:lineBundleAtClosedPoint_globalSections_iff,
  lem:lineBundleAtClosedPoint_toFunctionField_injective}` on
  sub-claim (b) — first label in chapter (line 331); second is the
  new sub-claim (a) just introduced.
- `\uses{lem:lineBundleAtClosedPoint_globalSections_iff}` inside the
  proof of sub-claim (b) — same chapter.
- `\uses{lem:lineBundleAtClosedPoint_toFunctionField_injective,
  lem:lineBundleAtClosedPoint_order_conditions_of_globalSection}` on
  sub-claim (c) — both new sub-claims (a) + (b).
- `\uses{lem:lineBundleAtClosedPoint_toFunctionField_injective}`
  inside the proof of sub-claim (c).

## References consulted
No new external reference files were opened this session — the three
new `\lemma` blocks are project-bespoke (Archon-original)
decompositions of an existing iter-195 helper, mirroring its in-Lean
documentation block at OCofP.lean:1421--1440. Per the directive
"no NEW external sources needed; no reference-retriever dispatch
required" and per the citation discipline rule for Archon-original
results, no `% SOURCE:` / `% SOURCE QUOTE:` blocks are required for
these three lemmas. The chapter-level Hartshorne and Stacks Project
citations at lines 6--13 already cover the underlying mathematical
content; Stacks tags 01XU and 02P0 are referenced inline in
sub-claim (c)'s prose body as the standard substrate for ``global
sections of `𝒪_C` on a complete curve are constants''.

## Source files I read this session (Lean substrate, not reference docs)
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` lines 996--1110 — verified
  the existing `globalSections_iff_mpr` at line 1024 and its signature,
  confirmed sub-claim (b)'s one-line invocation is feasible.
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` lines 1300--1440 — read
  the iter-195 helper body `exists_nonconstant_rational_from_dim_eq_two`
  and its documented residual sub-claims at lines 1421--1440;
  cross-referenced the local witnesses (`htF_zero`, `htF_smul`,
  `htF_add`, `hs1`, `hs_not_const`) used in the proof sketches.
- `blueprint/src/macros/common.tex` — confirmed macros `\Spec`,
  `\Hom`, `\Sheaf`, `\Psh` (substituted with `\Psh`-spelling-as-text
  where the macro doesn't exist), `\ModuleCat`, `\op`, `\val`,
  `\Module`, `\HModule`, `\Opens`, `\struct` are available.

## Macros needed (if any)
- `\Psh` / `\Sh` — the new prose uses these as shorthand inside the
  composition layers in sub-claim (a)'s proof. They are spelled as
  rendered math (`\Sh` already exists via `\DeclareMathOperator{\Sh}`
  variants in `common.tex`, but `\Psh` may not — the chapter falls
  back to `\Psh` and `\Sheaf` interchangeably). NOT added by me
  (out of write-domain); if absent, the typeset render will show
  `\Psh` as literal text. Suggested addition to `macros/common.tex`:
  `\DeclareMathOperator{\Psh}{Psh}` and (if not present)
  `\DeclareMathOperator{\Sh}{Sh}`.
- `\val` and `\op` — used in the layer descriptions and in
  `op ⊤` notation. Likely already defined (the chapter uses
  `\op\,\top` in line 122 of the existing carrier-presheaf definition
  block, which compiles fine), but worth confirming
  the new occurrences resolve.

## Reference-retriever dispatches (if any)
None. Per the directive, no new external sources are needed.

## Notes for Plan Agent
- The new subsection sits inside the `\section{The dimension formula
  in genus zero}` and is logically a continuation of that section's
  arc (the corollary at line 633ff. is the immediate consumer of the
  three sub-claims). It could equally have been placed inside the
  `\section{Existence of a non-constant rational function}` section
  if a future plan-phase prefers; the directive offered the choice
  ``in the existing dimension-formula section OR a new subsection
  at the end of that section'', and I chose the latter.
- The `\lean{...}` pins on the three new lemmas point at NEW
  project-side substrate declarations that the iter-196 prover will
  land. Until those land, the `sync_leanok` deterministic phase will
  observe missing declarations and decline to add `\leanok`; the
  lemma blocks will display in the dependency graph as ``planned''.
  This is the intended state and matches the directive's instruction
  to leave `\leanok` to `sync_leanok`.
- Sub-claim (b)'s proof sketch leans on the existing
  `globalSections_iff_mpr` helper (currently `private`). If the
  iter-196 prover decides the public pin
  `order_conditions_of_globalSection` should subsume / replace the
  private helper rather than wrap it, the chapter's text remains
  accurate (the proof sketch describes the mathematical content; the
  Lean-side realisation has flexibility).
- Sub-claim (c) references a project-side helper
  `Scheme.functionField_of_complete_curve_const` (or equivalent) for
  the Hartshorne~I.3.4 ``Γ(C, 𝒪_C) = k̄'' statement. If this helper
  does not yet exist project-side, the iter-196 prover lands it as a
  separate small named declaration before consuming it inside the
  body of `principal_ne_zero_of_nonconstant`. The blueprint's prose
  flags this dependency.

## Strategy-modifying findings
None. The three sub-claims are a clean structural decomposition of
the iter-195 helper's residual content; their existence does not
surface any strategy-level issue with STRATEGY.md. The chapter's
overall arc (RR.3 supplies the basis (1, f); RR.4 consumes it via
`Proj.fromOfGlobalSections`) is unchanged.
