# Blueprint Review Report

## Slug
iter003

## Iteration
003

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_comp` proof block: The `\begin{proof}` prose still describes the infeasible `conjugateEquiv_comp` / pullback-side-injectivity route. A `% NOTE:` added by review calls for a rewrite, but the prose itself is present and misleading. A prover reading this chapter will follow the broken route; the actual proof (`pushPullMap_eq_raw` → `rawPushPullMap_comp` → `subst` + `pushPull_pentagon`) is described only in the `% NOTE:` comment, not in the body.

- `Cohomology_CechHigherDirectImage.tex`: The following Lean declarations (`lean_aux` nodes) have no blueprint blocks and are relevant enough to deserve them: `pushPullFunctor` (the full functor assembly) and `cechNerveCosimplicial` (the composition step that produces the cosimplicial `O_X`-module from the backbone + push-pull functor). Without explicit blocks these remain opaque to future provers reading the blueprint.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine`: Blueprint proof sketch applies exclusively to standard covers ($\mathcal{U} : U = \bigcup_{i=1}^n D(f_i)$), using the explicit "Čech complex = complex of localizations" description and the prime-local contracting homotopy. The Lean signature is `CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover)` — a **general** `X.OpenCover`, not a standard cover. The proof sketch gives no route from the standard-cover result to the general case. Prover dispatched on this sketch alone will prove a lemma that does not typecheck against the declared signature.

### Lean difficulty quality

- `Cohomology_AcyclicResolution.tex` / `lem:homology_long_exact_sequence`: `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` names exactness at ONE position of the short complex. The block states the **full** long exact sequence — connecting map δ plus exactness at every position. The proofs in this chapter that invoke this lemma (`lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) consume all four Mathlib pieces: `homology_exact₁`, `homology_exact₂`, `homology_exact₃`, and `ShortComplex.ShortExact.δ`. A prover reading only the `\lean{}` hint will use one piece and miss three. The anchor is unfaithful per the `\mathlibok` faithfulness rule — **hard fail**.

### Dependency & isolation findings

All 12 isolated nodes in `leandag show isolated` are `lean_aux` type (Lean-side helpers with no blueprint counterparts); none are isolated blueprint nodes, and there are **no unknown_uses** (broken `\uses{}` edges). Lean-aux isolation triage:

- `lean:AlgebraicGeometry.pushPullFunctor` — the assembly of `pushPullObj`/`pushPullMap` into the functor `G : (Over X)ᵒᵖ ⥤ X.Modules`. **wire-up (soon)** — add a `\definition` block in `Cohomology_CechHigherDirectImage.tex` that names this functor, or add it to `def:cech_nerve`'s `\uses{}` so the DAG edge is visible.
- `lean:AlgebraicGeometry.cechNerveCosimplicial` — the composition step that applies `pushPullFunctor` to the backbone `coverCechNerveOverAug` to produce the cosimplicial `O_X`-module that IS `CechNerve`. **wire-up (soon)** — `def:cech_nerve` should `\uses{def:push_pull_functor}` (once a block for `pushPullFunctor` exists) or have `cechNerveCosimplicial` explicitly mentioned.
- `lean:AlgebraicGeometry.coverCechNerveOver`, `lean:AlgebraicGeometry.coverCechNerveOverAug` — packaging helpers for the geometric backbone in `Over X`. **keep** — internal plumbing; adequately described within the `def:cover_cech_nerve` prose.
- `lean:AlgebraicGeometry.rawPushPullMap`, `lean:AlgebraicGeometry.rawPushPullMap_comp`, `lean:AlgebraicGeometry.rawPushPullMap_self`, `lean:AlgebraicGeometry.rawPushPullMap_self_gen` — proof infrastructure for the `subst`-based pentagon route of `pushPullMap_comp`. **keep** — internal proof helpers; their role is described in the `% NOTE:` on `lem:push_pull_comp` and the file comments.
- `lean:AlgebraicGeometry.pushPull_pentagon`, `lean:AlgebraicGeometry.pushPull_unit_comp`, `lean:AlgebraicGeometry.pushforwardComp_hom_app_id` — coherence bricks consumed by `rawPushPullMap_comp`. **keep** — covered by the existing `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` blueprint blocks and the `% NOTE:` on `lem:push_pull_comp`.
- `lean:AlgebraicGeometry.pushPullMap_eq_raw` — the `rfl`-bridge between `pushPullMap` and `rawPushPullMap`. **keep** — internal bridge; mentioned in the `% NOTE:`.

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:homology_long_exact_sequence` / `\mathlibok` anchor unfaithful — **hard fail, must-fix-this-iter.** `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` covers exactness at only one of the three sequence positions. The block's stated content is the full LES (exactness at all positions + connecting map δ); the chapter's proofs (`lem:acyclic_dimension_shift` proof, `lem:acyclic_resolution_computes_derived` proof) consume all four Mathlib declarations: `homology_exact₁`, `homology_exact₂`, `homology_exact₃`, and `ShortComplex.ShortExact.δ`. Fix options: (a) split the block into two `\mathlibok` anchors — one for `\lean{CategoryTheory.ShortComplex.ShortExact.δ}` (the connecting map) and one for the three exactness results with `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₁}` as representative and a note naming all three; or (b) identify whether a single bundled Mathlib declaration covers the full LES and use that.
  - All proof sketches are otherwise detailed, internally consistent, and adequate for a prover: the horseshoe-lift construction (`lem:injective_resolution_of_ses`) is precise; the dimension-shift induction (`lem:acyclic_dimension_shift`) is complete with both the connecting-isomorphism case ($k \geq 1$) and the cokernel case ($k=1$) spelled out; the staircase argument in `lem:acyclic_resolution_computes_derived` is correct.
  - `lem:injective_resolution_of_ses`: `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` is listed as an `unmatched_lean` node (the declaration doesn't yet exist — correct, it's a project-side gap). This is expected; the prover will create it.
  - `def:right_acyclic`: `\lean{CategoryTheory.Functor.IsRightAcyclic}` likewise unmatched (project-side definition to create). Expected.
  - `blueprint-doctor covers_problems`: covers `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` (does not yet exist). Expected — will be scaffolded this iter. Not a blocker.
  - **P4 HARD GATE: DOES NOT CLEAR.** The unfaithful `\mathlibok` anchor on `lem:homology_long_exact_sequence` is a hard-fail per the faithfulness rule. Dispatch a blueprint-writer to fix the anchor; re-review after; only then dispatch the P4 prover.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:cech_acyclic_affine` (P3) — **standard-cover vs. general-cover gap, must-fix-this-iter.** Blueprint statement: "Let $\mathcal{U} : U = \bigcup_{i=1}^n D(f_i)$ a standard open cover (so the $f_i \in A$ generate the unit ideal)." Lean signature (line 764–766): `theorem CechAcyclic.affine [IsAffine X] (f : X ⟶ S) [IsAffineHom f] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] …`. The Lean declaration takes an arbitrary `X.OpenCover`, not specifically a standard cover. The blueprint proof sketch ("the Čech complex of the standard cover is the complex of localizations; prime-local contracting homotopy") is valid only for standard covers; it does not prove the Lean statement for a general open cover. Two resolution paths: (a) narrow the Lean signature to standard covers (change `𝒰 : X.OpenCover` to a standard-cover type — `CechAcyclic.affine` is NOT a protected declaration, so this is permissible; plan agent to decide); or (b) upgrade the blueprint proof sketch to cover the general affine cover case (noting that every affine open cover of an affine scheme is refined by a standard cover, and applying cofinality). For path (a) to work, confirm that downstream uses of `CechAcyclic.affine` (via `lem:cech_augmented_resolution`) also reduce to standard covers — inspection of `lem:cech_augmented_resolution`'s proof confirms it only invokes `lem:cech_acyclic_affine` on "the cover restricts to a standard cover $U = \bigcup D(f_i)$", so narrowing to standard covers is downstream-safe.
  - `lem:push_pull_comp` — **misleading proof sketch, must-fix-this-iter.** The `\begin{proof}` body describes the `conjugateEquiv_comp` / pullback-side injectivity route, which was found infeasible in Lean (kernel `whnf` blow-up, verified iter-002). The `% NOTE:` added by the review agent correctly identifies the working route (`pushPullMap_eq_raw` → `rawPushPullMap_comp` → `subst` over-triangles → `pushPull_unit_comp` + `pushPull_pentagon`), but the proof body prose is unchanged and misleading. Any prover reading this chapter this iter for P2 follow-up will be misdirected. Dispatch a blueprint-writer to replace the proof body with the `rawPushPullMap`/`subst`/pentagon narration.
  - 1-to-1 debt (`lean_aux` nodes, soon severity): `pushPullFunctor` (the full functor `G : (Over X)ᵒᵖ ⥤ X.Modules`) and `cechNerveCosimplicial` (the step composing backbone + functor to get the cosimplicial `O_X`-module) have no blueprint blocks. Both are mathematically significant intermediate results deserving `\definition` entries. Dispatch a writer to add them, gating on the P3/P5 work.
  - `lem:cech_to_cohomology_on_basis`: proof explicitly notes the result "is not yet available in Mathlib and is recorded here as a to-build dependency." The `\lean{AlgebraicGeometry.cech_eq_cohomology_of_basis}` is unmatched (not yet implemented). This is expected for the current iter; it feeds P5, not P3. STRATEGY.md open question (verify Mathlib coverage) remains open.
  - `lem:push_pull_comp` `\uses{}` edges in statement and proof blocks are technically correct: `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` (both present in the same chapter) ARE used in the actual proof. The DAG edges are sound.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter:**

1. `Cohomology_AcyclicResolution.tex` / `lem:homology_long_exact_sequence` — unfaithful `\mathlibok` anchor (`\lean{}` covers one exactness position, block states full LES + δ). **P4 hard gate DOES NOT CLEAR.** Dispatch blueprint-writer to fix anchor before dispatching P4 prover.

2. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_acyclic_affine` — standard-cover vs. general-cover gap between blueprint statement (standard cover $D(f_i)$) and Lean signature (general `X.OpenCover`). Blueprint proof sketch does not prove the Lean declaration. Plan agent must decide: narrow the Lean signature, or upgrade the blueprint. Either way, dispatch a writer before sending the P3 effort-breaker.

3. `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_comp` — proof body still describes the infeasible route; the `% NOTE:` calls for a rewrite but has not been acted on. Dispatch blueprint-writer to replace proof prose with the `rawPushPullMap`/`subst`/pentagon route.

**soon:**

4. `Cohomology_CechHigherDirectImage.tex` / `pushPullFunctor` (lean_aux) — deserves `\definition` block. Wire-up to DAG via `def:cech_nerve` `\uses{}` or dedicated entry.

5. `Cohomology_CechHigherDirectImage.tex` / `cechNerveCosimplicial` (lean_aux) — the key composition step inside `CechNerve`. Wire-up to DAG; either add `\definition` block or reference from `def:cech_nerve`.

Overall verdict: **3 must-fix findings; P4 hard gate DOES NOT CLEAR (unfaithful `\mathlibok` anchor in `Cohomology_AcyclicResolution.tex`) and the P3 effort-breaker cannot run until the standard-cover gap in `Cohomology_CechHigherDirectImage.tex` is resolved; 0 unstarted-phase proposals (all phases have coverage).**
