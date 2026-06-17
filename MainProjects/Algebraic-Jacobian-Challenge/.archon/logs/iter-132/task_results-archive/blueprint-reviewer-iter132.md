# Blueprint Review Report

## Slug
iter132

## Iteration
132

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`: all carry `\notready` — intentional iter-131 deferral per directive's "Known issues" (no action needed this iter on these five).
- `Jacobian.tex` / `def:genusZeroWitness`: `\notready`. Body in `AlgebraicJacobian/Jacobian.lean:188` is `sorry` — intentional, scheduled for iter-138+ per its own status block.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: declaration scaffolded with `\leanok` on the statement; body is `sorry` (`AlgebraicJacobian/RigidityKbar.lean:87`) — intentional, this is the M2.a target.

(All five `\notready` items and the two open sorries are scheduled and correctly tagged in `STRATEGY.md`. They are not blockers for this iter's plan.)

### Proofs lacking detail

- `Jacobian.tex` / proof of `thm:nonempty_jacobianWitness`, sub-steps C.2.a–C.2.e (lines 322–350): still narrated over $\bar k$ as "Statement (over $\bar k$)", "the standard reduced-source / separated-target argument …", with $f \colon \mathbb P^1_{\bar k} \to A$ as the canonical setup. C.2.f (DROPPED iter-127) and C.2.g (over-k inventory) then re-route the actual rigidity claim through `\cref{thm:rigidity_over_kbar}` directly over $k$, but the C.2.a–C.2.e prose chain is now historical scaffolding rather than the live argument. The chapter remains internally consistent (C.2.f explicitly notes the drop), so this is **soft drift, not blocker**: a future cleanup pass could collapse C.2.a–C.2.e to a one-paragraph "the keystone is now packaged as `thm:rigidity_over_kbar`, see Chapter `RigidityKbar`" reference.

### Lean difficulty quality

- No findings. Every `\lean{...}` hint on an `\leanok`-marked block resolves cleanly to a present Lean declaration; every `\lean{...}` hint on a `\notready` block (the five iter-131 deferred targets in `RigidityKbar.tex` plus `def:genusZeroWitness` in `Jacobian.tex`) names a future declaration whose signature stub is given as a comment-level Lean signature in the chapter prose. All target names are concrete and well-formed.

### Multi-route coverage

- Route "single (over-k, post-iter-127 commitment; over-`k̄` baseline + M2.c removed)": **PASS** — covered end-to-end by `Jacobian.tex` (C.2.f explicitly DROPPED, C.2.g over-k inventory, `def:genusZeroWitness` routes via `thm:rigidity_over_kbar`), `AbelJacobi.tex` (lines 82/87/89 all over-k), and `RigidityKbar.tex` (the chapter itself, including the iter-127 over-k commitment paragraph at line 14 and the shared cotangent-vanishing pile § "Iter-127 over-k risk register" at line 258 of `lem:GrpObj_mulRight_globalises`).

(The directive lists Replacements (A), (B′), and the fibre-free piece (i) reformulation as documented-but-inactive sub-route variants kept in `STRATEGY.md`. They are not active routes and require no blueprint coverage this iter.)

## Per-chapter

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - `lem:GrpObj_lieAlgebra_finrank` statement-level `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge}` (line 190) and proof-level `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge, thm:smooth_locally_free_omega}` (line 202) **still list the bridge lemma as a dependency**, but the iter-131 strategy-critic Q4 collapse footer in the same proof (line 240) explicitly states the live closure path under Replacement (B) is Steps 1+2 and **bypasses the bridge**; Step 3 (lines 230) documents the bridge as a deferred alternative route only. The `\uses{}` blocks should drop `lem:GrpObj_cotangent_bridge` to match the live closure path. This is the primary iter-132 writer item.
  - `rem:piece_i_first_target` (line 298) `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_cotangent_bridge, lem:GrpObj_lieAlgebra_finrank}`: the bridge reference is vestigial under Replacement (B); the remark itself documents the iter-128-era plan, so the `\uses` could keep the bridge (informational) or drop it (cleaner). Soft cleanup.
  - Line 88 paragraph "Iter-128 / iter-129 prover lane re-scoping": ends with "The bridge and rank lemmas are deferred to iter-130+." We are at iter-132 and the rank lemma is the iter-132 prover-lane target. This sentence should be updated to "The bridge is deferred indefinitely (vestigial under Replacement (B), see line 240 footer); the rank lemma is the iter-132+ prover-lane target." (Soft drift but mis-leading on a quick read.)
  - All five `\notready` deferrals (`lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) are correctly tagged.
  - Bridge proof Step 1 (line 159) is **already aligned** with the iter-131 body shape: it explicitly says "The iter-131 body of \cref{lem:GrpObj_cotangentSpace} is the chart-base-change …" and factors $\psi_V$ through the localisation. **No drift remaining here** (the directive's snapshot may have been written before this update landed; the current text reads cleanly).
  - Rank-lemma proof Step 1 (line 205) is **already aligned**: "Step 1: chart-side Kähler rank" using `thm:smooth_locally_free_omega`'s existential directly, internally consuming `Algebra.IsStandardSmooth.free_kaehlerDifferential` and `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`. Step 2 base-changes via `Module.finrank_baseChange`. Step 3 is correctly marked "alternative canonical route, currently deferred". Step 4 dualises. **No drift on the live closure path.**
  - "Iter-131 \texttt{Classical.choose}-chain body shape" paragraph at line 302 cleanly documents the rewrite handle (`cotangentSpaceAtIdentity_eq_extendScalars`) and the recommended `obtain` pattern for the iter-132+ rank-lemma prover. Aligned with the actual Lean body in `AlgebraicJacobian/Cotangent/GrpObj.lean:149` and the companion lemma at line 198.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three previously-flagged Galois-descent drift passages (lines 82, 87, 89) are now all over-k: line 82 explicitly says "C.2.f (Galois descent of morphism equality back to k) is **DROPPED** under the iter-127 commitment: no base-change-and-descent step appears anywhere in the M2 critical path"; lines 87/89 both phrase the genus-0 sub-case as "rigidity for $C \to A$ established directly over $k$ via \cref{thm:rigidity_over_kbar} (per the iter-127 over-k commitment; no base-change to $\bar k$ and no Galois descent of morphism equality enter)". The chapter is now coherent.
  - Brauer–Severi conics over $\mathbb Q$ are cited correctly in line 82 as the standard counterexample to a $k$-side identification without a rational point.
  - The iter-131 blueprint-writer `blueprint-writer-abeljacobi-galois-iter131` did its job; no further work needed.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - C.2.f (line 352) explicitly marked "[DROPPED iter-127.] Galois descent to $k$ --- no longer needed." and gives the over-k justification chain (cotangent-vanishing pile pieces (i)+(ii)+(iii) all build over arbitrary $k$). C.2.g (line 354) gives the iter-127 over-k Mathlib-gap inventory. Both are clean and aligned with the iter-127 commitment.
  - **Soft drift**: C.2.a–C.2.e (lines 322–350) are still narrated over $\bar k$ — "Statement (over $\bar k$)", "Let $A$ be a smooth proper geometrically irreducible group scheme over $\bar k$", "$f \colon \mathbb P^1_{\bar k} \to A$", "reduced-source / separated-target argument". The text is self-consistent (C.2.f immediately follows and DROPS the descent step), but C.2.a–C.2.e is now historical scaffolding rather than live argument. A future cleanup pass could collapse the C.2.a–C.2.e chain into a one-paragraph pointer to `thm:rigidity_over_kbar` (this would also drop the now-vestigial $\mathbb P^1_{\bar k}$-specific reduced-source / separated-target prose). Not a blocker for this iter — the chapter does not contradict the over-k commitment, it just over-narrates.
  - `def:genusZeroWitness` (line 383) cleanly routes through `thm:rigidity_over_kbar` directly over $k$; the $C(k) \neq \emptyset$ branch feeds the supplied marked point into the rigidity hypothesis, the $C(k) = \emptyset$ branch is vacuously satisfied at the Lean type level (line 408).
  - `\lean{AlgebraicGeometry.genusZeroWitness}` resolves to the body at `AlgebraicJacobian/Jacobian.lean:188` which is `sorry` (iter-138+ target). Consistent.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:smooth_locally_free_omega` (line 48) provides the existential consumed by `RigidityKbar.tex` § Piece (i.a) Step 1+2 of the rank-lemma proof. The proof sketch is detailed: 5 Mathlib `[verified]` closure pieces named, including the `Nontrivial B` discharge in Step 4.5 via `AlgebraicGeometry.Scheme.component_nontrivial`. Aligned with the iter-131 body shape of `cotangentSpaceAtIdentity` (which extracts U, V, e from this very existential via a `Classical.choose`-chain).
  - Section "Standalone Kähler-localization utilities (post-iter-126 M1 excise)" cleanly documents the iter-126 excise and preserves `lem:kaehler_quotient_localization_iso` as the standalone Mathlib-PR candidate.
  - `sec:converse-out-of-scope` correctly documents the converse implication as mathematically false and identifies the missing deformation-theoretic content (`Algebra.H1Cotangent` subsingleton).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` (named `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`) is the load-bearing C.2.b input for both `Jacobian.tex` C.2 and `def:genusZeroWitness`. Proof sketch is detailed (3 derived instances + the closure step + the `Over.OverMorphism.ext` promotion).
  - Section "Use in the project" (line 52) correctly names the two downstream consumers: M2.a (genus-0 Albanese witness) and the uniqueness half of `thm:exists_unique_ofCurve_comp`.
  - The Lean target resolves to `AlgebraicJacobian/Rigidity.lean:91` (declared, no `sorry`).

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` cleanly defines $g(C) = \dim_k H^1(C, \mathcal O_C)$ via the project's `Scheme.HModule` $k$-flavoured sheaf cohomology of `Scheme.toModuleKSheaf C`.
  - The "Mathlib gap" section (line 44) correctly notes Serre finiteness as the deep work pending; the genus *theorem* (finiteness) is properly distinguished from the genus *definition*.
  - `noncomputable` modifier authorisation is documented.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Long chapter (650+ lines) covering Phase A step 5 + the Stein-finiteness chain + the Čech-cohomology infrastructure. All `\lean{...}` hints resolve to existing declarations in `AlgebraicJacobian/Cohomology/`. No drift.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Mayer–Vietoris long exact sequence + comparison isomorphism + Čech-acyclicity carrier classes. The two producer-class hypotheses (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`) are honestly documented as currently unproduced and the genus carrier theorem ships as conditional under them — parallel to how `Jacobian.lean` ships conditional under `nonempty_jacobianWitness`. Status is clean.

## Cross-chapter notes

- `RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" header still says "iter-128+ build" but the rank lemma is now the iter-132 prover-lane target. Soft mis-narration; not a blocker.
- The rank lemma's proof Step 4 (line 232 of `RigidityKbar.tex`) closes $\finrank_k \mathfrak{g} = \finrank_k \mathfrak{g}^\vee = n$ via $k$-linear duality. This is correct but currently not surfaced as a separate named `\lean{...}` declaration — the rank lemma's `\lean{cotangentSpaceAtIdentity_finrank_eq}` returns the un-dualised cotangent rank, which is what downstream needs (per the iter-129 dualisation pinning at line 109). Consistent across chapters.
- All `\uses{...}` cross-references in the blueprint resolve to real labels (spot-checked the iter-132-relevant ones: `def:JacobianWitness`, `thm:rigidity_over_kbar`, `thm:GrpObj_eq_of_eqOnOpen`, `thm:smooth_locally_free_omega`, `def:genus`, `def:IsAlbanese`, `def:Scheme_HModule`, `def:Scheme_toModuleKSheaf` are all defined in the chapters claimed by the references).

## Strategy-modifying findings

None. No definition conflicts with `STRATEGY.md` in a way that would require a strategy update. The iter-127 over-k commitment is consistently reflected across `RigidityKbar.tex`, `Jacobian.tex`, and `AbelJacobi.tex`.

## Severity summary

- **must-fix-this-iter**:
  - **`RigidityKbar.tex`** is marked `correct: partial`. Per the HARD GATE rule, the corresponding `.lean` file `AlgebraicJacobian/Cotangent/GrpObj.lean` (the iter-132 prover-lane target for `cotangentSpaceAtIdentity_finrank_eq`) **should NOT be added to this iter's prover objectives** unless a `blueprint-writer` for `RigidityKbar.tex` is dispatched this iter to address the must-fix items below. The directive already anticipates this: "the plan agent intends to dispatch the writer in parallel with the prover lane (writer finishes first; or the rank lemma scaffold-only is acceptable)" — both options are defensible. The concrete writer items:
    1. Drop `lem:GrpObj_cotangent_bridge` from the `\uses{...}` blocks of `lem:GrpObj_lieAlgebra_finrank` (statement at line 190; proof at line 202). The live closure path under Replacement (B) does **not** use the bridge per the iter-131 strategy-critic Q4 collapse footer at line 240.
    2. Update line 88 paragraph: "The bridge and rank lemmas are deferred to iter-130+." → "The bridge is vestigial on the live path under Replacement (B) (see line 240 footer); the rank lemma is the iter-132+ prover-lane target."
    3. (Optional cleanup) Drop `lem:GrpObj_cotangent_bridge` from `rem:piece_i_first_target` (line 298) `\uses{}`, or rephrase the remark to clarify the bridge reference is informational/historical.
- **soon**:
  - `Jacobian.tex` C.2.a–C.2.e prose chain still narrates the rigidity argument over $\bar k$ as historical scaffolding before the C.2.f DROP. The chapter is internally consistent (`correct: partial` is the conservative marking), but a future cleanup pass could collapse the C.2.a–C.2.e chain into a one-paragraph pointer to `thm:rigidity_over_kbar`. Not blocker-grade because no prover route consumes the C.2.a–C.2.e sub-step prose directly — they consume `def:genusZeroWitness` and `thm:rigidity_over_kbar`, both of which are over-k clean.
- **informational**:
  - `RigidityKbar.tex` § "Piece (i): sub-lemma decomposition for iter-128+ build" subsection header is mis-narrated as iter-128+ but the prose throughout the subsection has caught up to iter-131/iter-132. Cosmetic.
  - `def:genusZeroWitness` body at `AlgebraicJacobian/Jacobian.lean:188` is `sorry` (intentional, scheduled iter-138+). The blueprint correctly tags this with `\notready` at line 387 of `Jacobian.tex`.

**Per-file prover dispatch gate verdict.** Apply per HARD GATE:

- `AlgebraicJacobian/Cotangent/GrpObj.lean` (mapped chapter `RigidityKbar.tex`): chapter is `correct: partial` with a must-fix-this-iter finding naming the rank lemma's `\uses{}`. Strictly per HARD GATE, the prover lane should be DEFERRED unless a `blueprint-writer` for `RigidityKbar.tex` is dispatched THIS iter. The directive permits parallel dispatch (writer finishes first), which is acceptable. The findings are localised to `\uses{}` cleanup + one historical-narration sentence; the substantive prose for the rank-lemma proof (Steps 1+2 on the live closure path) is already aligned with the iter-131 body and would not mislead the prover. **If parallel dispatch is chosen, the rank-lemma prover should be given the directive to follow Steps 1+2 of the rank-lemma proof (live closure path, lines 205–226 of `RigidityKbar.tex`) and to use `cotangentSpaceAtIdentity_eq_extendScalars` as the structural-shape rewrite handle per § "Iter-131 \texttt{Classical.choose}-chain body shape" at line 302.**
- All other `.lean` files map to chapters marked `correct: true` and may be added to objectives without writer-dispatch precondition.

**Overall verdict.** The blueprint is fundamentally aligned with the iter-127 over-k commitment and the iter-131 Lean refactor of `cotangentSpaceAtIdentity`; the iter-132 writer items for `RigidityKbar.tex` are narrowly scoped (three `\uses{}` cleanups + one historical-narration sentence) and should be dispatched in parallel with — or before — the iter-132 rank-lemma prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`.
