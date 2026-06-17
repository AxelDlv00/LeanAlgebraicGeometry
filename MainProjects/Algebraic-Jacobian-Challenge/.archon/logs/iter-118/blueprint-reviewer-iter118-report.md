# Blueprint Review Report

## Slug
iter118

## Iteration
118

## Top-level summaries

### Incomplete parts

- `Jacobian.tex`: the structure `JacobianWitness` has no `\structure` / `\def` block. The structure is named in the prose of `def:Jacobian` (line 53) and in the proof of `thm:nonempty_jacobianWitness` (line 152), and is the carrier through which the four protected instances on `Jacobian C` and the three protected `IsAlbanese.*` projections are obtained, but it is never introduced as a definition in the blueprint. A prover or reader is forced to read `AlgebraicJacobian/Jacobian.lean` to recover the field names (`J`, `grpObj`, `proper`, `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`).
- `Jacobian.tex` / `IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}`: the three `IsAlbanese.*` projection helpers (witnessed at `AlgebraicJacobian/Jacobian.lean:67,72,78`) are entirely absent from the blueprint, despite being the *direct* implementation route for `AbelJacobi.Jacobian.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` of `AbelJacobi.tex` (where the latter are protected declarations). The `def:ofCurve` block in `AbelJacobi.tex` directly references "the projection of the universal-pointed-morphism field of the Albanese predicate", which IS the `IsAlbanese.ofCurve` helper, but no `\lean{...}` hint or definition block names it. Same for `comp_ofCurve` and `exists_unique_ofCurve_comp` (the latter is a re-export of the existential field of `IsAlbanese`).
- `Differentials.tex` / `thm:smooth_iff_locally_free_omega`: the iff statement is mathematically false in the converse direction (per the directive, with the concrete counterexample `Spec k → Spec k[t]` via `t ↦ 0` — l.f.p., `Ω = 0` locally free of rank 0, but not smooth). The chapter is therefore mathematically incorrect as written. Iter-118 plans to demote the statement to a forward implication; the chapter must be rewritten to match before any prover can be assigned to `AlgebraicJacobian/Differentials.lean` (`Differentials.lean:74` currently still types the Lean target as the full iff).

### Proofs lacking detail

- `Jacobian.tex` / `thm:IsAlbanese_unique`: the Lean target `AlgebraicGeometry.IsAlbanese.unique` returns `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e` — i.e. a unique *morphism* of `Over (Spec k)`-objects, NOT a unique *isomorphism*. The blueprint prose at line 43 says "uniquely isomorphic by an isomorphism compatible with their universal morphisms", which is strictly stronger. The Lean proof at `Jacobian.lean:88-114` *computes* the iso data (`g ≫ h = 𝟙 J₁` and `h ≫ g = 𝟙 J₂` are both witnessed inside the proof) but discards the iso when returning the ExistsUnique. The blueprint prose and the Lean statement are not equivalent.
- `Jacobian.tex` / `thm:nonempty_jacobianWitness`: the proof is structured as the disjunction of three routes (A/B/C) plus a genus-0 sub-case, with each route blocked by named Mathlib infrastructure. The narrative covers the mathematical *content* of each route at standard textbook depth, but no route is detailed enough for a prover to formalize. This is intentional — the theorem is the project's single deferred existence hypothesis — and is documented as such by `\leanok` on the statement marking the sorry inside the Lean body.
- `Cohomology_MayerVietoris.tex` / `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: the proof body is detailed at the level of Mathlib API names but defers six labelled transient sorries plus one budget-deferred sub-step. Remark `rem:basicOpenCover_step2_status` (line 1167) cross-links the deferrals to specific source-line ranges. No prover should be redirected here without a writer first separating the deferred items into named, separately stated sub-lemmas.

### Lean difficulty quality

- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega}` — the named target's signature in the Lean file is the iff (`Differentials.lean:74`). The blueprint statement is the iff. The directive says iter-118 will demote to forward implication. A prover handed this chapter today would be asked to prove a false statement. Severity: **must-fix-this-iter**, but the directive already records the intent.
- `Differentials.tex`: two `[verified]`-tagged Mathlib references in the proof of `thm:smooth_iff_locally_free_omega` are wrong (line 67/84 and line 69):
  - Line 67/84: `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` — the actual Mathlib declaration in `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:160` is `smoothOfRelativeDimension_iff` (no `is` prefix). A prover plugging the `[verified]`-tagged name in verbatim will get a `unknown identifier` error.
  - Line 69: `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` — this declaration does **not** exist in Mathlib at the project's pin. What exists is `IsStandardSmooth.free_kaehlerDifferential` (an instance giving `Module.Free S Ω[S⁄R]` in `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:301`) and `SubmersivePresentation.free_kaehlerDifferential` (the underlying constructive route). The forward-direction sketch as currently written cites a name that won't resolve; replacing it with the `IsStandardSmooth.free_kaehlerDifferential` instance is the correct path. (The other three `[verified]`-tagged names — `IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`, `IsStandardSmooth.iff_exists_basis_kaehlerDifferential`, `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` — all check out.)

### Multi-route coverage

Directive does not list separate active routes; the strategy is single-track ("Albanese framework via the existence hypothesis `nonempty_jacobianWitness`"). The three *classical* descriptions inside the proof of `thm:nonempty_jacobianWitness` (Pic-scheme route A; symmetric-powers route B; genus-0 rigidity route C) are all bundled into a single deferred witness; they are presented as alternatives the future Mathlib build-out can take, not as Lean-level routes the project currently formalizes. **PASS** — coverage of the in-project route (Albanese) is uniform across `Jacobian.tex`, `AbelJacobi.tex`, `Rigidity.tex`, and `Differentials.tex` (the smoothness criterion that anchors the dimension hypothesis).

## Per-chapter

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Small chapter (40 lines), one theorem (`thm:HasSheafCompose_forget`), proof is a 5-line composition. `\leanok` on statement and proof. Lean target `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp` is concrete and well-formed.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three blocks (sheafification instance, Ext instance, structure-sheaf promotion). All `\leanok`. `\uses{...}` cross-refs all resolve to existing labels in `Cohomology_SheafCompose.tex` or within this chapter.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Large chapter (655 lines), comprehensive coverage of $k$-module-valued sheafification, Ext, structure-sheaf promotion, $H^0$ bridges, finite-dim transports, $\text{\v Cech}$ scaffolding. All blocks marked `\leanok`. Cross-references audited; all `\uses{...}` resolve.
  - Minor informational: the section title "$k$-finite transport companions" uses iteration numbers in labels (e.g. `sec:HModule_finite_zero_iter038`) — historical, not a problem.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Very large chapter (1180 lines). The abstract Mayer–Vietoris framework, the two-affine-cover specialisation, the universe-bump bridges, the Čech-acyclicity carrier, and the basic-open infrastructure are all present and `\leanok`.
  - `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (line 1126) and the surrounding Step-2 transport (Remark `rem:basicOpenCover_step2_status`, line 1167) are flagged with six labelled transient sorries plus one budget-deferred sub-step in the Lean body. The blueprint *does* document this honestly (lines 1167–1180). The transient sorries are localised to a single Lean file (`BasicOpenCech.lean`) that is **not in the iter-118 active prover surface** — the active Lean surface is the 10 files in the directive's "Files / paths". So this chapter's partial status does not affect any active prover dispatch this iter. **soon**, not must-fix.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: false
- **notes**:
  - `thm:smooth_iff_locally_free_omega` (line 48): statement is the iff — directive flags this as mathematically false in the converse direction. The Lean target at `AlgebraicJacobian/Differentials.lean:74` is the same iff (with a `sorry` body). The chapter must be rewritten to demote to forward implication before any prover round on `Differentials.lean`. **must-fix-this-iter**.
  - Line 67/84: `[verified]`-tagged Mathlib reference `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` is wrong — the actual Mathlib name is `smoothOfRelativeDimension_iff` (no `is` prefix). **must-fix-this-iter** (broken `\lean`-style hint baked into the proof prose).
  - Line 69: `[verified]`-tagged Mathlib reference `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` does not exist in Mathlib at the project's pin. Closest existing routes: `IsStandardSmooth.free_kaehlerDifferential` (instance) or `SubmersivePresentation.free_kaehlerDifferential`. **must-fix-this-iter**.
  - "Content out of autonomous-loop scope" section (line 94 onwards) is informational and clean — flags four pieces (sheaf condition, cotangent exact sequence, cotangent space at a section, Serre-duality genus identity) as trimmed in iter-117.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genus` (line 8) presents the genus as `dim_k H^1(C, O_C)`, with the Lean target `AlgebraicGeometry.genus` `\leanok`. `\uses{def:Scheme_HModule, def:Scheme_toModuleKSheaf}` resolves correctly to `Cohomology_StructureSheafModuleK.tex`.
  - "What this iteration does and does not" (line 67) is honest about what the definition gives vs.\ what proving Serre finiteness would give. Informational, no action.

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `def:IsAlbanese`, `thm:IsAlbanese_unique`, `def:Jacobian`, the four `Theorem*` blocks (`Jacobian_grpObj`, `Jacobian_smooth_genus`, `Jacobian_proper`, `Jacobian_geomIrred`), and `thm:nonempty_jacobianWitness` are all present with `\leanok`. Cross-references resolve.
  - `thm:IsAlbanese_unique` (line 38): blueprint prose says "uniquely isomorphic by an isomorphism" but the Lean target `AlgebraicGeometry.IsAlbanese.unique` returns `∃! e, h₂.ofCurve = h₁.ofCurve ≫ e` — existence of a unique *morphism*, not an isomorphism. The Lean proof internally computes the iso (`g ≫ h = 𝟙` and `h ≫ g = 𝟙`) but throws it away. Statement-vs-implementation mismatch. **must-fix-this-iter**.
  - `JacobianWitness` is named (line 53, line 152) but has no `\structure` / `\def` block — a reader has no way to know the structure's field names from the blueprint alone. **must-fix-this-iter**.
  - `IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` (the three direct projection helpers in `AlgebraicJacobian/Jacobian.lean:67,72,78`) are not declared in the blueprint despite being the implementation route for the three protected `Jacobian.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` of `AbelJacobi.tex`. **must-fix-this-iter** (these are part of the protected surface; the blueprint must document them or explicitly route through `IsAlbanese`).
  - `thm:nonempty_jacobianWitness` (line 138) is the single deferred existence hypothesis. The proof's three-route exposition (Pic-scheme A; symmetric-powers B; genus-0 rigidity C) is well-organized and honest about each route's Mathlib gap. This is by-design *not* a closure target this iter, so the "no detailed proof" is expected — but the writer dispatch this iter should add a `\structure JacobianWitness` block immediately above this theorem so the existential type is documented.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` (line 10) is stated and proved with `\leanok` on both. Proof sketch lists the Mathlib ingredients (separatedness from properness, equaliser closedness, geometric irreducibility, reducedness, smoothness ⇒ regularity ⇒ reducedness, group-object structure on $Y$). Marked as "the only sorry-blocking lemma in the project that is provable from current Mathlib alone" — directive does not list `AlgebraicJacobian/Rigidity.lean` in the iter-118 prover surface, but this chapter is in good shape if a prover round is dispatched later.

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` are all present with `\leanok`, plus three classical-description remarks. Lean targets resolve. Proof of `thm:exists_unique_ofCurve_comp` (line 75) correctly explains both the Lean closure (project Albanese-witness universal-property field) and the classical Picard-scheme / Stein-factorisation / rigidity route as context.
  - **Partial** because all three protected declarations in the chapter's Lean target file (`AlgebraicJacobian/AbelJacobi.lean:51,62,82`) are formalised by *projecting* the corresponding helper of `IsAlbanese` (i.e. `IsAlbanese.ofCurve`, `IsAlbanese.comp_ofCurve`, `IsAlbanese.exists_unique_ofCurve_comp`). These three intermediate helpers are not blueprinted in `Jacobian.tex` (see that chapter's notes). The implementation route is therefore not fully traceable through the blueprint — a writer dispatch to add the three `IsAlbanese.*` projection blocks to `Jacobian.tex` closes the loop for this chapter as well.

## Cross-chapter notes

- `Jacobian.tex` defines the existential `\thm:nonempty_jacobianWitness` returning a `JacobianWitness C` but `JacobianWitness` itself is never blueprinted as a `\structure`. `AbelJacobi.tex`'s three protected declarations and `Jacobian.tex`'s four protected instance theorems all rely on field projections from this undocumented carrier. A single `\structure JacobianWitness` block plus three `\def IsAlbanese.{ofCurve, comp_ofCurve, exists_unique_ofCurve_comp}` blocks in `Jacobian.tex` cover both gaps.
- `Differentials.tex` / `thm:smooth_iff_locally_free_omega` is currently a forward-direction-only mathematical truth dressed up as an iff. None of the iter-118 active downstream chapters (`Jacobian.tex`, `AbelJacobi.tex`) actually *consume* the converse direction — the iter-118 prover surface uses smoothness as input (via `[SmoothOfRelativeDimension n f]` instances) and not local freeness as input — so demoting the iff to a forward implication does NOT change any active downstream proof obligation. Safe refactor.
- Off-disk chapters `Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex` are on disk but not `\input`-ed from `blueprint/src/content.tex`. Their Lean counterparts (`AlgebraicJacobian/Modules/Monoidal.lean`, `AlgebraicJacobian/Picard/{Functor,FunctorAb,LineBundle}.lean`) were deleted in iter-117. They are historical artifacts that the blueprint render does not see — they introduce no cross-reference into the active blueprint (no `\input` line in `content.tex`; no active chapter cites a label inside them). Recommendation: delete or move to a `historical/` subdirectory in a single dedicated housekeeping iter (informational, NOT a must-fix-this-iter item — they cannot mislead any prover because they are not part of the active blueprint render).

## Strategy-modifying findings (if any)

None. The Differentials iff-demotion is a chapter rewrite, not a strategy change — the active downstream surface in `Jacobian.tex` and `AbelJacobi.tex` consumes the *forward* direction (smoothness ⇒ local freeness, via the relative dimension hypothesis on the curve) and not the converse. The chapter as rewritten still supports `def:genus`'s dimension hypothesis on the Jacobian unchanged. STRATEGY.md update not required.

## Severity summary

- **must-fix-this-iter**:
  - `Differentials.tex` / `thm:smooth_iff_locally_free_omega`: iff is mathematically false in converse direction; demote to forward implication. (`complete: partial`, `correct: false`.) **Blocks prover dispatch on `AlgebraicJacobian/Differentials.lean`.**
  - `Differentials.tex` proof prose: two `[verified]`-tagged Mathlib references are wrong (`AlgebraicGeometry.isSmoothOfRelativeDimension_iff` → `smoothOfRelativeDimension_iff`; `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` → `IsStandardSmooth.free_kaehlerDifferential` instance route). **Blocks prover dispatch on `AlgebraicJacobian/Differentials.lean`** until rewritten.
  - `Jacobian.tex` / `thm:IsAlbanese_unique`: Lean statement is strictly weaker than blueprint prose (returns ExistsUnique on a morphism, not on an iso). (`correct: partial`.) Even though the Lean target is not in the iter-118 prover surface (it's already `\leanok`-closed), the prose/Lean drift is a correctness issue that a writer must reconcile.
  - `Jacobian.tex`: `JacobianWitness` structure has no `\structure` / `\def` block, despite being load-bearing for all four protected `Jacobian.*` instances and `thm:nonempty_jacobianWitness`. (`complete: partial`.)
  - `Jacobian.tex`: three `IsAlbanese.*` projection helpers (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp` in the `IsAlbanese` namespace at `Jacobian.lean:67,72,78`) are unblueprinted but are the direct implementation route for the protected `AbelJacobi.Jacobian.*` family. (`complete: partial` on `Jacobian.tex`; cascades to `complete: partial` on `AbelJacobi.tex`.)

- **soon**:
  - `Cohomology_MayerVietoris.tex` / `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: six labelled transient sorries plus one budget-deferred sub-step in `BasicOpenCech.lean`. **NOT in the iter-118 active prover surface** (`BasicOpenCech.lean` is not among the 10 active files in the directive), so partial-status does not affect this iter's gate. A future iter that promotes any of those declarations into the active surface will need to address them first.
  - Off-disk historical chapters (`Modules_Monoidal.tex`, `Picard_Functor.tex`, `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`): not rendered, no active blueprint reference. Recommend dedicated cleanup or `historical/` move, not blocking.

- **informational**:
  - Iteration-numbered section labels in `Cohomology_StructureSheafModuleK.tex` (e.g. `sec:HModule_finite_zero_iter038`) are historical artifacts; harmless.

### Hard-gate findings (per directive)

Per the dispatcher's hard-gate rule, with `complete: partial` and `correct: false` on `Differentials.tex`:

- `AlgebraicJacobian/Differentials.lean` **must be deferred** from iter-118's active prover surface until a `blueprint-writer` dispatch this iter (a) demotes `thm:smooth_iff_locally_free_omega` to a forward implication and updates the Lean target's stated signature accordingly, and (b) corrects the two wrong `[verified]`-tagged Mathlib references in the proof prose.

With `complete: partial` on `Jacobian.tex`:

- `AlgebraicJacobian/Jacobian.lean` is currently `\leanok` on all six statement-blocks (the four protected instances, the existential `nonempty_jacobianWitness`, and `IsAlbanese.unique`); the single remaining sorry is the deferred existential hypothesis `nonempty_jacobianWitness`. The chapter's `complete: partial` is from *missing blueprint coverage* (the `JacobianWitness` structure and the three `IsAlbanese.*` projection helpers), not from a misformed Lean target. **A `blueprint-writer` dispatch this iter is required** before any new prover round on `Jacobian.lean` (none planned per directive), but the existing project state is not unsafe — the deferral applies to future prover work.

With `complete: partial` on `AbelJacobi.tex` (cascaded from the `IsAlbanese.*` gap in `Jacobian.tex`):

- `AlgebraicJacobian/AbelJacobi.lean` is fully `\leanok`-closed; the chapter's partial status is documentary only. No prover round on this file is planned for iter-118 per directive. The same `blueprint-writer` dispatch that adds the `IsAlbanese.*` blocks to `Jacobian.tex` closes this chapter's loop too.

Overall verdict: blueprint is **functionally sound** for the iter-118 active prover surface *minus* `Differentials.lean`, which must be deferred this iter. A focused `blueprint-writer` dispatch on `Differentials.tex` (iff demotion + two Mathlib name corrections) plus `Jacobian.tex` (`JacobianWitness` structure block + three `IsAlbanese.*` projection blocks) clears every must-fix-this-iter finding and unblocks the deferred prover lane next iter.
