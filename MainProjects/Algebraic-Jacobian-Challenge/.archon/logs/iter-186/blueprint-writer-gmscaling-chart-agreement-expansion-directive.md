# blueprint-writer · gmscaling-chart-agreement-expansion (iter-186)

## Chapter to edit
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (consolidated chapter
that covers `Genus0BaseObjects/GmScaling.lean` and several siblings; see
`% archon:covers` line near top).

## Problem (from lean-vs-blueprint-checker iter185-gmscaling — 1 MUST-FIX-THIS-ITER)

`lem:gmscaling_chart_agreement` (around L1308 area; grep the file to
locate the exact line range) is the canonical chart-bridge
agreement lemma that the project's `gmScalingP1_chart_agreement_cross01`
in `GmScaling.lean:cross01` depends on for closure. The proof sketch
in the chapter has been demonstrably **inadequate to guide
formalization for 5 consecutive iters**. The iter-185
lean-vs-blueprint-checker MUST-FIX-THIS-ITER finding requires
expansion of the proof sketch.

Specifically, the prose:
- Still references "`analogies/chart-bridge.md` (iter-173 in flight)"
  — 12 iters stale. iter-173's `analogies/chart-bridge.md` was
  superseded by `analogies/gmscaling-projection-idiom.md` (iter-184)
  which itself is the analogist verdict driving the Recipe 1/2/3
  decomposition.
- Does NOT describe the current proof state's entry point: a
  `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv`
  structural lift that the iter-184/iter-185 prover has been
  attempting against.
- Does NOT explain why the `Iso.trans_inv`-based simp chain is
  blocked: the iso
  `gmScalingP1_cover_intersection_X_iso` is constructed in tactic
  mode (`refine ≪≫ ?_; refine; exact`), so `Iso.inv_comp_eq`,
  `pullback.congrHom_inv`, `asIso_inv` rewrites report "unused" —
  the syntactic pattern simp needs is not present.

## Required expansion

Rewrite the proof block of `lem:gmscaling_chart_agreement` to include
the following tactic-level material. The block should be a textbook-
quality proof sketch (mathematical, not Lean tactic strings) but
WITH ENOUGH STRUCTURAL DETAIL that a prover can match each prose step
to a Lean tactic without re-deriving the structure.

### Required material (4 sub-paragraphs)

**(I) Setup and structural lift.** Restate the lemma's hypothesis +
conclusion in the project's notation. Identify the two charts being
compared: `gmScalingP1_chart 0` (the chart over the patch
containing `0 ∈ 𝔸¹`) and `gmScalingP1_chart 1` (over the patch
containing `∞ ∈ 𝔸¹`), and their pullback intersection
`gmScalingP1_cover_intersection_X_iso : pullback _ _ ≅ Spec ...`.
The `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv`
move is the cleanest entry point: post-composing with the
intersection iso's inverse reduces the agreement to an equality
between two morphisms on the pullback intersection.

**(II) Why the canonical simp chain is blocked.** Explain in 2-3
sentences that `gmScalingP1_cover_intersection_X_iso` is currently
constructed by a tactic-mode `refine ≪≫ ?_; refine; exact ...`
proof term whose elaboration produces a fully-applied opaque iso
form. The Mathlib-canonical simp lemmas `Iso.trans_inv`,
`Iso.inv_comp_eq`, `pullback.congrHom_inv`, `asIso_inv` cannot
fire against the elaborated form. This is why iter-181 through
iter-184 attempts via direct `simp [Iso.trans_inv, ...]` after
`cancel_epi` fail to close.

**(III) Three concrete pickup paths.** State three orthogonal
recipes for iter-186+ to attempt; the iter-186 plan agent chooses
one based on budget and risk:

- **(III.a) Refactor `gmScalingP1_cover_intersection_X_iso` to
  term-mode (`≪≫`-spine only).** Rewrite the iso construction so
  the spine is an explicit `≪≫`-chain of named Mathlib isos with no
  intermediate `refine` / `exact` tactics; the canonical simp chain
  then fires (`Iso.trans_inv` unfolds each link in turn). LOC
  estimate: ~30-50 LOC; risk: the term-mode form needs explicit
  type annotations at each link; structural-refactor subagent (in
  the catalog) is the right tool.

- **(III.b) Package two projection lemmas
  `gmScalingP1_cover_intersection_X_iso_inv_fst` /
  `gmScalingP1_cover_intersection_X_iso_inv_snd` as
  `@[reassoc (attr := simp)]` named lemmas, each proved by
  `pullback.hom_ext` against the relevant projection.** The
  hand-written `pullback.hom_ext` proofs sidestep the opaque
  elaborated form: each projection's value is forced by the
  pullback's universal property, which is a structural fact about
  the diagram, not a syntactic identity on the elaborated iso. LOC
  estimate: ~50-80 LOC for the two named lemmas + ~10-20 LOC reuse
  in `cross01`. This is the analogist-recommended path per
  `analogies/gmscaling-projection-idiom.md` Recipe 2 — but it
  requires relaxing the iter-184/iter-185 helper budget = 0 since
  these are 2 NEW named lemmas.

- **(III.c) Bypass via a separating-sheaf argument.** The chart
  agreement is equivalent to the claim "two morphisms
  `X → Spec R` agree iff their composites with a separating family
  of opens agree". The genus-0 chart cover has an obvious
  separating family (the two `𝔾_m`-affine pieces); using the
  separating-sheaf criterion bypasses the pullback-iso chase
  entirely. LOC estimate: ~80-120 LOC; risk: requires
  `AlgebraicGeometry.IsSeparatedOver` / `Scheme.sheafExt` lemmas
  whose iter-186 availability the plan agent should check. Falls
  under the STRATEGY.md "Genus-0 separated-locus alternative" open
  strategic question.

**(IV) Mathlib gaps recorded.** A `% NOTE (iter-186 writer)`
LaTeX comment near the start of the proof block listing 2 known
Mathlib gaps that have repeatedly blocked closure:

- `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` (absent at
  commit b80f227 — needed for `gm_geomIrred` / `projGm_isReduced`
  product-stability instances).
- `Iso.trans_inv`-friendly elaboration of nested `≪≫`-chains
  produced by tactic-mode `refine ≪≫ ?_` constructions (a project
  ergonomic gap, not strictly a Mathlib lemma gap).

## Additional chapter touches (iter-185 lean-vs-blueprint-checker iter185-gmscaling — 3 majors, partial)

The iter-185 review applied 2 of 3 majors inline; the 6 missing
`\lean{...}` pin additions remain for you:

Add `\lean{...}` blueprint pins for these 6 currently-unreferenced
public declarations (find the natural blueprint block for each;
several should be near `def:gmscaling_chart_PLB` and
`def:projGm_locally_finite_type` if they exist, or in the §
"Lean encoding" / "Project material" subsection of the consolidated
chapter):

1. `\lean{AlgebraicGeometry.pullback_map_fst_proj}` (iter-184
   Recipe 1 helper, simp-globally-active).
2. `\lean{AlgebraicGeometry.pullback_map_snd_proj}` (iter-184
   Recipe 1 helper, simp-globally-active).
3. `\lean{AlgebraicGeometry.projGm_locallyOfFiniteType}` (instance).
4. `\lean{AlgebraicGeometry.gm_geomIrred}` (instance — flagged
   Mathlib-gap by iter-185 review comment).
5. `\lean{AlgebraicGeometry.projGm_geomIrred}` (instance).
6. `\lean{AlgebraicGeometry.projGm_isReduced}` (instance — flagged
   Mathlib-gap by iter-185 review comment).

Each pin can land in the corresponding existing definition / theorem
block that documents the property, OR in a new mini-block at the
end of the relevant section. Add the pins where the prose mentions
the conclusion (e.g. the projection lemmas land near the cover-iso
helper definitions).

## Out of scope

- DO NOT add `\leanok` or `\mathlibok` markers.
- DO NOT touch any other chapter file (only
  `AbelianVarietyRigidity.tex`).
- DO NOT consult new references; everything you need is in the
  existing chapter prose + `analogies/gmscaling-projection-idiom.md`
  (already on disk).
- DO NOT modify the Lean files.

## Expected outcome

The proof block of `lem:gmscaling_chart_agreement` grows by ~30-60
LOC (4 sub-paragraphs + NOTE). 6 new `\lean{...}` pins land in
neighbouring blocks. Total chapter delta: ~50-100 LOC.

Downstream: with the expanded sketch in place, the iter-186 plan
agent can pick one of the three pickup paths and assign the iter-186
Lane B prover with an authoritative chapter to ground the directive
in. Without this expansion, Lane B remains in 5-iter CHURNING.

## Report

Write to `.archon/task_results/blueprint-writer-gmscaling-chart-agreement-expansion.md`:
- Which subsection of the chapter you touched (line ranges).
- Each of the 4 sub-paragraphs with a 1-line summary.
- The 6 `\lean{...}` pin additions with their landing locations.
- Any new prose-level open questions the expansion surfaced.
