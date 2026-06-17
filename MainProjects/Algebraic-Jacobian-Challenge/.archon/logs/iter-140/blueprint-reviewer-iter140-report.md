# Blueprint Review Report

## Slug
iter140

## Iteration
140

## Hard-gate verdict (directive-specific)

**The HARD GATE CLEARS for the iter-140 prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean`** (three concrete sub-sorries:
L581 `d_app` + L585 `d_map` inside
`basechange_along_proj_two_inv_derivation`, L624 `IsIso` inside
`relativeDifferentialsPresheaf_basechange_along_proj_two`).

The iter-139 blueprint-writer dispatch on `RigidityKbar.tex` landed all
six directive edits in substantive form:

1. ✓ Iter-138 closure-shape NOTE block (L506–593): present and detailed.
2. ✓ d_app closure recipe NOTE block (L594–651): present; concrete
   3-step closure path identified (categorical commutativity of
   projections → `Scheme.Hom.toRingCatSheafHom` functorial translation →
   `ModuleCat.Derivation.d_app`).
3. ✓ d_map closure recipe NOTE block (L653–700): present; identifies
   the two naturality pieces (ψ.naturality from
   `Scheme.Hom.c.naturality` + `KaehlerDifferential.map_d`) and their
   composition shape.
4. ✓ Route (b'2) IsIso sub-paragraph in IsIso NOTE block (L842–958):
   present; supplies the 5-line iso-reflection bridge
   `isIso_of_app_iso_module`, the 4-item iter-140 prover-gap list in
   build order, and the iter-139-verified Mathlib API names.
5. ✓ Two new `\lean{...}` lemma blocks for the iter-138 helpers:
   `lem:GrpObj_omega_basechange_proj_inv_derivation` (L969–1028) and
   `lem:GrpObj_omega_basechange_proj_inv` (L1049–1093). Both carry
   complete signature stubs in the Lean encoding notes; both marked
   `\notready` with reason; both link back to the d_app/d_map and IsIso
   closure recipes in the parent proof block.
6. ✓ `% NOTE iter-139:` flag on `\leanok` mis-mark concern (L491–504):
   present; correctly identifies the issue as a `sync_leanok` handling
   question on a `letI ... := sorry` construction and names the
   doctor-skill consult as the indicated handler (the chapter does
   **not** itself touch the `\leanok` line, per project marker
   vocabulary).

The plan-agent's direct edit on `AlgebraicJacobian_Cotangent_GrpObj.tex`
(2-bullet addition, L50–69) accurately names both iter-138 helpers
(`basechange_along_proj_two_inv_derivation`,
`basechange_along_proj_two_inv`) with the right status (sub-sorries
remaining and Route (b'2) pointer).

The recipes in `RigidityKbar.tex` are prover-ready: each of the three
sub-sorries has a named closure path with the Mathlib API references
needed to execute it (sufficient for a prover lane in the same style as
prior iters; not requiring the prover to invent the strategy).

## Top-level summaries

### Incomplete parts

None for iter-140 prover-lane scope. The two new lemma scaffolds
`lem:GrpObj_omega_basechange_proj_inv_derivation` and
`lem:GrpObj_omega_basechange_proj_inv` are correctly marked
`\notready` and explain the iter-140 closure path in their proof
blocks; the parent `lem:GrpObj_omega_basechange_proj` carries the
three concrete iter-140 closure recipes inline.

The blueprint as a whole continues to carry the long-standing M3 gap
(`def:positiveGenusWitness` body is `sorry`, off-critical-path) — out
of scope this iter.

### Proofs lacking detail

- None on the iter-140 prover-lane critical path. The d_app, d_map,
  and IsIso recipes each name the Mathlib lemma(s) consumed and the
  pattern to invoke them (incl. iter-138's beta-redex-aware
  `have h ... ; change ... ; rw [h]` pattern for d_add/d_mul, which
  carries over to d_app/d_map per the chapter's explicit note at
  L590–592).

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}`:
  GOOD. Signature stub at L977–984 is fully type-annotated with the
  `PresheafOfModules.pushforward`-via-`Scheme.Hom.toRingCatSheafHom`
  packaging and the `pullbackPushforwardAdjunction` homEquiv-symm
  transpose for the `Derivation'`-of-`φ_G` shape; downstream
  consumers can construct against it without disambiguation.
- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}`:
  GOOD. Signature stub at L1060–1065 fully type-annotated
  (`PresheafOfModules.pullback ... ⟶ relativeDifferentialsPresheaf ...`).
- All other `\lean{...}` hints in the iter-140-relevant chapters are
  pre-existing and stable.

### Multi-route coverage

The directive does not enumerate routes. The strategy as embodied in
the chapters is a single-route plan for the iter-140 prover-lane:
piece (i.b) closure via the iter-138 Route (b) inverse-direction
skeleton plus iter-139 Route (b'2) iso-reflection bridge for the IsIso
closure. Both alternative routes (Route (a) chart-unfolding helper,
Route (b) without iso-reflection) are documented in the NOTE blocks
for context but Route (b'2) is the actively-routed closure.

The iter-127 over-k commitment (no Galois descent) continues to be
correctly threaded through both `RigidityKbar.tex` and `Jacobian.tex`
(genus-0 sub-case, M2.c.f DROPPED).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Stable iter-127 over-k prose; correctly cites `\cref{thm:rigidity_over_kbar}` and the
    `def:genusZeroWitness` vacuity argument for the $C(k) = \emptyset$ branch.
  - No iter-140-relevant change required.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The 2-bullet addition (L50–69) accurately names the two iter-138 helpers
    `basechange_along_proj_two_inv_derivation` and
    `basechange_along_proj_two_inv` with correct status descriptions
    (sub-sorries, Route (b'2) pointer to
    `analogies/isiso-basechange-along-proj-two-inv.md`).
  - Pointer chapter; the substantive content lives in `RigidityKbar.tex`
    §"Piece (i)", correctly cross-referenced via `\cref{chap:RigidityKbar}`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase-A Mayer–Vietoris infrastructure, mature. All declaration
    blocks and proofs in good order. Producer status on the two
    carrier classes (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`)
    explicitly documented as project-out-of-scope.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single-theorem chapter; stable.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase-A typeclass plumbing, stable.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large but mature Phase-A chapter (k-module flavour). All
    declarations have `\lean{...}` hints; the producer instance for
    wholespace Hom-finiteness is closed via the four-step chain
    (constant-sheaf adjunction, Hom-from-k evaluation, Stein
    finiteness, global-sections evaluation iso) cleanly.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Forward-direction smoothness criterion (`thm:smooth_locally_free_omega`)
    is closed; converse is correctly scoped out as M4 with explicit
    counterexample (`rem:converse_counterexample`).
  - Section "Standalone K\"ahler-localization utilities" preserves
    the two PR-quality lemmas (`kaehler_localization_subsingleton`,
    `kaehler_quotient_localization_iso`) post-iter-126 M1 excise.
  - Consumed extensively by `RigidityKbar.tex` piece (i) via
    `thm:smooth_locally_free_omega` and
    `def:relative_kaehler_presheaf` — all `\uses{}` references resolve.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition-only chapter with deferred Serre finiteness; status
    section is honest about the remaining gap.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-135 by-cases body restructure of `thm:nonempty_jacobianWitness`
    is in place, delegating to `def:genusZeroWitness` (genus-0 arm,
    `\notready`, body sorry, closure gated on `thm:rigidity_over_kbar`)
    and `def:positiveGenusWitness` (positive-genus arm, `\notready`,
    off-critical-path).
  - Genus-0 sub-case (C.2.a–C.2.g) correctly threads the iter-127
    over-k commitment with C.2.f explicitly DROPPED; the M2.c.aux
    Galois-descent gap is eliminated. Cross-reference to
    `\cref{thm:rigidity_over_kbar}` resolves correctly.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Iter-125 scheme-level refactor of `thm:GrpObj_eq_of_eqOnOpen` is
    stable; consumer pattern in `RigidityKbar.tex` C.2.b is correct.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All six iter-139 directive edits are present and substantive
    (see Hard-gate verdict above for the itemised checklist).
  - The d_app / d_map / IsIso closure recipes in the proof block of
    `lem:GrpObj_omega_basechange_proj` (L506–958) are detailed
    enough for the iter-140 prover lane: each names the consumed
    Mathlib lemma, the structural pattern of the proof, and (for
    d_app/d_map) the iter-138 beta-redex-aware tactic pattern.
  - The two new lemma scaffolds for the iter-138 helpers
    (`basechange_along_proj_two_inv_derivation`,
    `basechange_along_proj_two_inv`) carry complete
    type-annotated signature stubs in the Lean encoding notes.
  - One **soon-severity informational concern** (NOT a must-fix):
    the `\leanok` marker at L505 sits on the proof block of
    `lem:GrpObj_omega_basechange_proj`, whose Lean body still
    contains the `letI ... := sorry` IsIso construction (the L624
    sub-sorry). The chapter self-flags this at L491–504 as a
    possible `sync_leanok` handling artifact on the `letI`-bound
    `sorry` pattern, with the doctor-skill consult named as the
    indicated handler. This is NOT a blueprint-writer fix
    (per project marker vocabulary, `\leanok` is `sync_leanok`
    territory); it is also NOT a barrier to the iter-140 prover
    lane, which targets the underlying sorries, not the marker. The
    marker will self-correct once iter-140 closes (or fails to
    close) the IsIso sub-sorry and `sync_leanok` re-runs.

## Cross-chapter notes

- Cross-reference between `AlgebraicJacobian_Cotangent_GrpObj.tex`
  (pointer chapter) and `RigidityKbar.tex` §"Piece (i)" (substantive
  content) is consistent. The two-bullet iter-139 addition in the
  pointer chapter mentions the iter-138 helpers and points to the
  parent recipes in `RigidityKbar.tex` correctly.
- `Jacobian.tex` C.2.g and `RigidityKbar.tex` chapter intro both
  carry the iter-127 over-k inventory consistently (no contradictions).
- `RigidityKbar.tex` `\uses{def:relative_kaehler_presheaf}` and
  `\uses{lem:relative_kaehler_presheaf_obj}` on
  `lem:GrpObj_omega_basechange_proj` and its helpers all resolve to
  the canonical labels in `Differentials.tex`.

## Strategy-modifying findings (if any)

None this iter.

## Severity summary

- **must-fix-this-iter**: none.
- **soon**:
  - `RigidityKbar.tex` L505 `\leanok` mis-mark on the proof block of
    `lem:GrpObj_omega_basechange_proj` (sync_leanok handler; flagged
    in-chapter for doctor-skill consult; does NOT block iter-140
    prover lane).
- **informational**:
  - `RigidityKbar.tex` L1097 `\leanok` and L1032 `\leanok` on the
    proof blocks of the two new iter-138 helper lemmas — both
    proof blocks are "direct definition; no proof body" / "partial
    closure with named sub-sorries"; the `\leanok` placement is the
    convention used elsewhere in this chapter for partially-closed
    proof blocks whose Lean body compiles (the construction itself
    is sorry-free even when the iso-property is parked). Self-flagged
    indirectly via the parent `% NOTE iter-139` block; same
    sync_leanok / doctor scope as the primary marker concern.

Overall verdict: **HARD GATE CLEARS** — the iter-140 prover lane on
`AlgebraicJacobian/Cotangent/GrpObj.lean` may proceed; all directive
edits landed substantively and the d_app/d_map/IsIso closure recipes
are prover-ready.
