# Blueprint Review Report

## Slug

iter145

## Iteration

145

## Top-level summaries

### Incomplete parts

- **`RigidityKbar.tex` § "Iter-144 chart-algebra envelope for piece (ii)" (L99–L114)**: lists 5 critical sub-pieces as prose bullets only. None are wrapped in `\begin{lemma}` / `\begin{theorem}` blocks. None carry `\label{...}` or `\lean{...}` hints. The iter-145+ M2.body-pile prover lane targets exactly these sub-pieces per STRATEGY.md and per the writer dispatch, but without first-class declaration blocks the planner cannot enumerate them in `## Current Objectives`, and provers have no Lean target names to formalise against. The five sub-pieces (with the chapter's own LOC estimates) are:
  1. Chart-algebra (α) `Algebra.IsPushout`-from-affine-product helper (~80–150 LOC). No Lean target name in the prose.
  2. Chart-algebra (β) per-chart translation-invariance Kähler-derivation argument (~150–300 LOC). No Lean target name. Three internal layers (chart-local; char-$p$ Frobenius-iteration; no-Serre-duality) are described but none are themselves blocks.
  3. Algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (~200–350 LOC). Lean name candidate is named in prose but no `\begin{lemma}` / `\lean{...}` block.
  4. Integrally-closed-constants helper (~50–100 LOC). No Lean target name.
  5. Scheme-level lift via `Scheme.Over.ext_of_eqOnOpen` (~100–150 LOC). The chapter mentions the new `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` target name at L114 but again no first-class block.

  This is the load-bearing iter-145 must-fix: it triggers HARD GATE on `RigidityKbar.tex` and (transitively) on the `Cotangent/GrpObj.lean` file.

- **`Jacobian.tex` § "Mathlib infrastructure summary" (L370–L377)**: still presents Route B as an independent route-unlocking infrastructure build-out (item (β)), even though Routes A and B were re-disposed iter-144 (Route A COMMITTED, Route B documented at L286–287 and L420 as "historical alternative not pursued"). The summary's three-way listing predates the iter-144 commitment and is inconsistent with the rest of the chapter.

### Proofs lacking detail

- **`RigidityKbar.tex` / `lem:GrpObj_omega_free` (L1728–L1739)** and **`RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` (L1741–L1752)**: both correctly carry `\notready`, but the prose proofs depend on `lem:GrpObj_mulRight_globalises` which is itself descoped from critical path under the iter-144 chart-algebra pivot. The chapter does not surface whether these piece-(i.c) lemmas remain on any active path (they appear to be unconsumed downstream under the pivot). Informational; classify as `informational` not `proofs lacking detail` because the chapter has already gated them with `\notready`.

- **`Jacobian.tex` / `def:positiveGenusWitness` (L422–L428)**: theorem statement says "The full `JacobianWitness` data ... is supplied by the chosen construction (Route A or Route B per `thm:nonempty_jacobianWitness`)". The body proof at L433–441 commits Route A only. The theorem statement should match the body's commitment.

### Lean difficulty quality

- **`RigidityKbar.tex` § "Iter-144 chart-algebra envelope for piece (ii)" (L99–L114)**: five sub-pieces are listed for prover work but none have `\lean{...}` hints, so each sub-piece's Lean target name is unspecified. For an iter-145+ active prover lane this is the "poor quality" condition: provers have no scaffold to attach to. The chapter's other piece-(i) lemmas all carry explicit `\lean{...}` hints and serve as the contrast model.

- **`AlgebraicJacobian_Cotangent_GrpObj.tex` (the pointer chapter)** lists chart-algebra-pivot-descoped declarations (`mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, the two iter-138 helpers, and the iter-143 `basechange_along_proj_two_inv_app_isIso`) with the disposition annotation `DESCOPED iter-145+`. These items are listed for traceability, not as iter-145+ targets, so their Lean hints remain useful audit artefacts; no action required.

### Multi-route coverage

- **Route A (Picard scheme / FGA representability)**: PASS for the statement, MISSING in detail. Covered at `Jacobian.tex` L255–L284 and the `def:positiveGenusWitness` block. Sub-steps A.1–A.4 are listed but the smallest entry-point (`RelativeSpec` functor, ~700–1100 LOC per the iter-123 audit) is named only in prose, not as a first-class block with `\lean{...}`. This is acceptable for iter-145 because M3 is M2-behind per STRATEGY.md and is not an active prover lane this iter; classify as `soon`.

- **Route B (symmetric powers + Stein factorisation)**: PASS. Documented as historical at `Jacobian.tex` L286–287 and L420. No prover work is contemplated; the chapter blueprints the route purely for scholarly traceability.

- **Genus-0 / chart-algebra route (the iter-127 over-k commitment, iter-144 chart-algebra pivot)**: PARTIAL. The high-level decomposition is at `RigidityKbar.tex` L88–L114, and the iter-127 over-k commitment chain is laid out clearly. The iter-145+ prover lane's five chart-algebra piece (ii) sub-pieces are prose-only; see "Incomplete parts" item 1 above. The lower-level pieces (i.a, i.b helpers, scheme-level `ext_of_eqOnOpen`) are all first-class blocks; only the new iter-144 piece (ii) inflation lacks first-class blocks.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All four blocks (`def:ofCurve`, `rem:ofCurve_classical`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) are first-class with `\lean{...}` and `\uses{...}`.
  - Cross-references to `def:Jacobian`, `def:IsAlbanese`, `thm:nonempty_jacobianWitness`, `thm:rigidity_over_kbar`, `def:genusZeroWitness` all resolve to live labels.
  - Reflects the iter-127 over-k commitment correctly (no Galois descent).

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: true (as a pointer chapter)
- **correct**: true
- **notes**:
  - All five iter-144 edits landed: three declaration-status refreshes; the new `lem:GrpObj_basechange_along_proj_two_inv_app_isIso` `\item` (L98–L110); the intro chart-algebra disposition NOTE (L10–L17).
  - L73–L74 use the undefined LaTeX commands `\fst`/`\snd` (not defined in `blueprint/src/macros/common.tex`). This is cosmetic: many other custom macros in this chapter (`\PresheafOfModules`, `\Scheme`, `\Hom`, `\app`, `\obj`, `\thm`, `\pr` — counted ~40 occurrences in `RigidityKbar.tex` alone) are similarly undefined in `common.tex`. The convention is consistently loose across the chapter and is `informational`, not must-fix.
  - The chapter is a pointer; the mathematical content review is folded into `RigidityKbar.tex`. Per-Lean-file blueprint convention is satisfied.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All declaration blocks carry `\lean{...}` and `\leanok`; all referenced labels resolve.
  - The chapter is purely auxiliary infrastructure for $H^1(C, \mathcal O_C)$.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Single first-class declaration with proof; no issues.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three first-class declarations + one definition; all `\leanok`'d.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter (655 LOC) but uniformly well-structured; every block has `\lean{...}` and `\leanok`. No internal contradictions.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The forward-direction smoothness criterion `thm:smooth_locally_free_omega` is well-pinned with explicit Mathlib lemma names and a 4-step recipe.
  - The Mathlib gap-fill structure is honest (M1 excise, M4 deferred-converse documented, M5–M8 catalogued).

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Lean encoding is pinned to `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`; Mathlib-status section documents Serre-finiteness as the remaining theorem-level gap.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **L370–L377 (Mathlib infrastructure summary)** still lists Route B (β) as one of three independent route-unlock infrastructures, but Routes A and B were re-disposed iter-144 (Route A COMMITTED; Route B "historical alternative not pursued"). The chapter's body at L286–287, L420, and L437 correctly describes Route B as historical; the summary block at L370–L377 should be reconciled to either drop (β) or annotate it as "documented historical route, not committed".
  - **L425 `def:positiveGenusWitness` theorem statement** ends with "supplied by the chosen construction (Route A or Route B per \cref{thm:nonempty_jacobianWitness})". The proof body at L433–441 commits Route A only ("This is the M3 arm of the witness existence. M3 is **committed to Route A**"). The statement and the body should agree.
  - These two residuals were flagged by the iter-144 review and were not fully resolved by the iter-144 writer.
  - The genus-0 arm `def:genusZeroWitness` (L387–L415) is well-pinned and routes through `thm:rigidity_over_kbar` cleanly; the body-closure status note at L414 is accurate (gated on the cotangent-vanishing pile pieces (i)+(ii)+(iii) — which iter-144 has now consolidated into the chart-algebra route on piece (ii); the genus-0 arm body-closure target iter is now iter-145+ per the chart-algebra envelope, not iter-138+ as the chapter still claims).
  - The iter-135 body-restructure description at L379 remains accurate (Lean `by_cases` delegation to the two named scaffolds).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Scheme-level rigidity (`thm:GrpObj_eq_of_eqOnOpen`) is closed against the Mathlib lemma `ext_of_isDominant_of_isSeparated'`. Iter-125 refactor (drop of source-side group-object hypothesis) is documented.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - The five iter-144 writer edits landed correctly:
    - L88 paragraph "Iter-144 chart-algebra pivot --- disposition" — present.
    - L99 paragraph "Iter-144 chart-algebra envelope for piece (ii)" — present.
    - L852 Rule 4 (iter-143 empirical lesson on `Pushforward.comp_eq` / `eqToHom`) — present.
    - L1628 `lem:GrpObj_basechange_along_proj_two_inv_app_isIso` first-class lemma — present (statement + proof block with Route (b'2) recipe).
    - Step-3 status refresh inside the piece-(i.b) Route (b'2) recipe at L601–L666 — present.
  - **MUST-FIX residual on the iter-144 chart-algebra pivot**: the five chart-algebra piece-(ii) sub-pieces in the L99–L114 envelope are prose bullets ONLY. They are the targets of the iter-145+ M2.body-pile prover lane, but lack `\begin{lemma}` / `\begin{theorem}` blocks, `\label{...}`, and `\lean{...}` hints. Without these, the planner cannot enumerate them as `## Current Objectives` and provers have no Lean target names to attach to. See top-level "Incomplete parts" item 1 for the five sub-pieces and the recommended block shape.
  - **Sync_leanok mis-mark carry-overs** (still present after the writer's line-shift; flagged for the deterministic `sync_leanok` phase, not for direct review-agent edit):
    - L434: `\leanok` on the proof block of `lem:GrpObj_mulRight_globalises`. The Lean target `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent` has a `sorry` body (per the in-prose NOTE at L406–414).
    - L552: `\leanok` on the proof block of `lem:GrpObj_omega_basechange_proj`. The Lean target has multiple residual `sorry`s (d_app sub-sorry inside `basechange_along_proj_two_inv_derivation`, and the extracted `basechange_along_proj_two_inv_app_isIso` theorem body). Explicitly flagged at L527–551 as a sync_leanok mis-mark candidate by the iter-139–143 NOTE chain.
    - L1669: `\leanok` on the proof block of `lem:GrpObj_basechange_along_proj_two_inv_app_isIso`. The Lean target body is `sorry` (per Lean target stub L1644–L1647 and the chart-algebra-pivot disposition at L1677).
  - L1611 `\leanok` on the proof block of `lem:GrpObj_omega_basechange_proj_inv` is **not** a mis-mark: that target is sorry-free as a definition (the iso property is extracted into the separate `basechange_along_proj_two_inv_app_isIso` theorem).
  - `\notready` markers at L211 (bridge lemma), L1732 (`lem:GrpObj_omega_free`), L1745 (`lem:GrpObj_omega_rank_eq_dim`) are all appropriate: the bridge is vestigial under Replacement (B), and the two piece-(i.c) lemmas are descoped under the chart-algebra pivot but not formalised in Lean (so `\notready` is the correct semantic state). No stale `\notready` markers to flag.

## Cross-chapter notes

- The iter-144 chart-algebra pivot is documented consistently across `RigidityKbar.tex` (the source of truth for the pivot) and `AlgebraicJacobian_Cotangent_GrpObj.tex` (which echoes the DESCOPED iter-145+ disposition on the affected declarations). The two chapters agree on the disposition of `mulRight_globalises_cotangent`, `relativeDifferentialsPresheaf_basechange_along_proj_two`, the iter-138 helpers, and the new `basechange_along_proj_two_inv_app_isIso`.
- `Jacobian.tex` (M3 route disposition) still carries the pre-iter-144 multi-route framing in its L370–L377 infrastructure summary, even though the chapter body now correctly names Route A as committed and Route B as historical. The chapter is internally inconsistent on the route-disposition framing; see the per-chapter note for the specific lines.
- All cross-chapter `\uses{...}` / `\ref{...}` / `\cref{...}` references resolve to live labels — no broken references introduced by the iter-144 writer edits (verified by an exhaustive label-vs-reference scan of `chapters/*.tex`).
- `Differentials.tex` `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega` are all referenced consistently from `RigidityKbar.tex` (the chart-base-change machinery + the existential output used by Steps 1+2 of the rank-lemma proof). No drift.

## Strategy-modifying findings (if any)

None. The iter-144 chart-algebra pivot is itself a strategy modification but is already reflected in `STRATEGY.md` per the directive and in `RigidityKbar.tex` § L88–L114; the residual blueprint work is to lift the five sub-pieces from prose into first-class blocks, which is a writer-level task, not a strategy modification.

## Severity summary

- **must-fix-this-iter**:
  - **`RigidityKbar.tex` L99–L114 (Iter-144 chart-algebra envelope for piece (ii))**: lift the five chart-algebra sub-pieces from prose bullets into first-class `\begin{lemma}` / `\begin{theorem}` blocks, each carrying a `\label{...}`, a `\lean{...}` hint (with a project-namespaced declaration name candidate), a `\uses{...}` chain, and a proof sketch detailed enough for an iter-146+ prover lane to formalise. The five sub-pieces and recommended target-name shapes:
    1. `Algebra.IsPushout`-from-affine-product helper. Suggested Lean name: `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product` (or a Mathlib-shaped name in `Algebra.IsPushout` namespace).
    2. Per-chart translation-invariance Kähler derivation (the load-bearing $\beta$ helper; should itself be decomposed into the three layers — chart-local kernel-extraction, char-$p$ Frobenius-iteration with uniform depth, no-Serre-duality conclusion — each as its own first-class block, since the layers are the natural prover sub-targets).
    3. Algebra-level core `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`. Mathlib-shaped name; suggest the chapter pin this as the Lean target.
    4. Integrally-closed-constants helper. Suggested Lean name to be decided by the writer (e.g.\ `AlgebraicGeometry.constants_integral_over_base_field`).
    5. Scheme-level lift via `Scheme.Over.ext_of_eqOnOpen` packaged as `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` (the chapter mentions this name at L114; lift to a first-class block).
  - The blueprint-writer-rigiditykbar-iter145 dispatch should target this section specifically. Per the HARD GATE rule, `Cotangent/GrpObj.lean` (the Lean file corresponding to the affected blueprint material) MUST be dropped from `## Current Objectives` this iter, deferred to iter-146 after the writer dispatch lands.

  - **`Jacobian.tex` L370–L377 (Mathlib infrastructure summary)** and **L425 (`def:positiveGenusWitness` theorem statement)**: reconcile the route-disposition framing to match the iter-144 commitment (Route A COMMITTED, Route B HISTORICAL). The L370–L377 three-way summary should either drop the (β) Route B item or explicitly annotate it as a historical route documented for scholarly context. The L425 statement should say "Route A" (or "the chosen construction per `\cref{thm:nonempty_jacobianWitness}` Route A"). Per the HARD GATE rule, `Jacobian.lean` MUST be dropped from `## Current Objectives` this iter; this is a writer-only refresh and the next mandatory dispatch of me will confirm. (Note: if there is no active prover lane on `Jacobian.lean` this iter, the HARD GATE is moot for this finding — the planner should still dispatch a writer for the cleanup, but the deferral is informational.)

- **soon**:
  - **`Jacobian.tex` L414 (`def:genusZeroWitness` body-closure status note)** still says "Earliest realistic body-closure iteration: iter-138+". Under the iter-144 chart-algebra pivot, the M2.body-pile prover-lane trajectory has changed and the genus-0 arm body closure is now gated on the chart-algebra pieces (ii.α)+(ii.β); the iter-138+ estimate is stale. The writer should refresh this estimate to reflect the chart-algebra envelope's iter-145+ horizon.
  - **Route A first-class blocks**: `Jacobian.tex` describes Route A as four sub-steps A.1–A.4, and `def:positiveGenusWitness` proof body L433–441 names "smallest entry point ... `RelativeSpec` functor (A.1 prerequisite; ~700–1100 LOC)". If M3 is to become an active prover lane after M2 closes (per STRATEGY.md), Route A's sub-steps should be promoted from prose to first-class blocks at that point. Not blocking now (M3 sits behind M2).

- **informational**:
  - `\fst` / `\snd` undefined in `blueprint/src/macros/common.tex` (used in `AlgebraicJacobian_Cotangent_GrpObj.tex` L73–L74, and `\pr` / `\Scheme` / `\Hom` / `\app` / `\obj` / `\thm` / `\PresheafOfModules` similarly undefined and used many times across chapters). The chapter convention is consistently loose; KaTeX-rendering will swallow these silently as their literal command names (e.g.\ `fst G G` rather than $\mathrm{fst}\,G\,G$). A `common.tex` macro-completion pass would smooth dashboard rendering; not blocking.
  - `RigidityKbar.tex` L1728–L1739 / L1741–L1752 (`lem:GrpObj_omega_free` / `lem:GrpObj_omega_rank_eq_dim`): both are correctly `\notready` and both are descoped from the live path under the chart-algebra pivot. The chapter does not surface a disposition annotation explicitly tying them to the pivot; a one-line NOTE at each lemma referring to the L91-L92 disposition would aid traceability.
  - `Cohomology_StructureSheafModuleK.tex` and `Cohomology_MayerVietoris.tex` are large, well-structured, and bear no iter-145 must-fix issues. No active prover lane touches them per the directive scope.

**Overall verdict**: The blueprint is in good shape on Phase A (cohomology + genus + M1 differentials), but the iter-144 chart-algebra pivot has left `RigidityKbar.tex` § "Iter-144 chart-algebra envelope for piece (ii)" with prose-only sub-piece coverage of the iter-146+ M2.body-pile prover lane targets; the HARD GATE fires on `Cotangent/GrpObj.lean` (and on `Jacobian.lean` for the L370–L377 / L425 route-disposition cleanup) until the next blueprint-writer dispatch promotes those sub-pieces to first-class blocks with `\lean{...}` hints.
