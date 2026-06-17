# Lean Audit Report

## Slug
iter256

## Iteration
256

## Scope
- files audited: 3 (directive-specified scope; all three read in full)
- files skipped: 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (non-standard elaboration option)
- **excuse-comments**: 0 flagged
- **notes**:
  - **sorry count**: 1, at L259 (Step-4 residual of `dual_restrict_iso`). This is a genuine deferred residual: Steps 1–3 and H1 are concrete `refine` arms using named closed lemmas; the final arm is the open sub-lemma `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`. The module header accurately describes it as "PARTIAL (Step-4 residual)." The sorry has not silently broadened.
  - **`homOfLocalCompat` (L516)**: confirmed CLOSED — no sorry anywhere in the proof body. The proof uses `hbridge` (`erw [ModuleCat.restrictScalars.smul_def']` + `simp [Scheme.Opens.ι_appIso]`) and `hfl_native` to close the f-leg linearity, exactly as described. The step-by-step proof structure is coherent and complete.
  - **`dual_isLocallyTrivial` (L335)**: three-step chain `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` compiles and is axiom-clean modulo the `dual_restrict_iso` Step-4 sorry. This is transitive on the identified residual, not a new gap.
  - **`dualUnitIsoGen` (L108), `presheafDualUnitIso` (L266), `dual_unit_iso` (L277)**: all appear to be sorry-free and axiom-clean.
  - **L444 `set_option backward.isDefEq.respectTransparency false`**: scoped to `homOfLocalCompat`. Non-standard option that relaxes transparency during backwards elaboration. Legitimate when standard transparency blocks instance synthesis; no red-flag usage detected. The closed proof justifies it. Flagged as a minor practice note.
  - **Heavy planner strategy/roadmap comment blocks** embedded inside declaration docstrings (e.g., L163–232 in `dual_restrict_iso`, L289–334 in `dual_isLocallyTrivial`, L466–514 in `homOfLocalCompat`): these are planning artifacts, not excuse-comments — they accurately describe mathematical obstacles and do not admit that code is wrong. However they will accumulate staleness as the proof progresses (the iter-230 WARM-CONTEXT WARNING about `overSliceSheafEquiv` at L204 is currently accurate but will become stale once Step-4 closes). Flagged as minor (future maintenance burden).

---

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 1 flagged (status block sorry-count mismatch)
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **sorry count**: 2 (L715 = `exists_tensorObj_inverse`; L2188 = `pullbackTensorMap_restrict`). Confirmed by grep.
  - **Status block inaccuracy (L41–54, "ONE tracked typed-sorry residual")**: The status comment claims exactly one sorry — `exists_tensorObj_inverse`. But `pullbackTensorMap_restrict` at L2138 (added this iteration as a scaffold) also carries a `sorry` (L2188). The status block was not updated when the new decl was added. **A downstream planner reading L41–54 will believe there is only one outstanding sorry in this file, which is false.** Severity: major.
  - **`exists_tensorObj_inverse` (L693, sorry at L715)**: well-documented long-standing residual. The body comment (L697–714) accurately describes the two remaining bridges (C = `dual_isLocallyTrivial`, A = `homOfLocalCompat`) and the dead-end shortcut. No broadening detected.
  - **`pullbackTensorMap_restrict` (L2138, sorry at L2188)**: the statement is a genuine composition-coherence identity — `pullbackTensorMap (h ≫ f) = pullbackComp.inv ≫ pullback(h).map(ptm f) ≫ ptm h ≫ tensorObjIsoOfIso(pullbackComp)` — not vacuous, not a restatement. The ROADMAP comment (L2147–2187) correctly identifies why the `pullbackObjUnitToUnit_comp` mirror does not transfer (the 4-fold composite is not an adjunction transpose) and sketches the genuine four-square route. The "scaffolded with a typed sorry + roadmap" description in the directive is accurate.
  - **`pullbackTensorMap_natural` (L2007)**: closed, no sorry.
  - **`picCommGroup`, `picMul`, `picInv`, `PicGroup`, etc.** (L787 onwards): sorry-free, axiom-clean appearance. No concerns.

---

### AlgebraicJacobian/Picard/LineBundleCoherence.lean

- **outdated comments**: 1 flagged (missing `#check` probes)
- **suspect definitions**: 1 flagged (`chart_free_rank_one` near-restatement)
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **sorry count**: 5 (L102, L119, L133, L142, L157) — all 5 stub declarations, as stated in the file header. This is the correct count for a file-skeleton.
  - **`exists_trivializing_cover` (L96)**: substantive — repackages the pointwise ∀x∃U into an indexed family with an explicit cover supposition `iSup U = ⊤`. Not a restatement.
  - **`chartPresentation` (L116)**: substantive — takes a single-chart trivialisation isomorphism and must produce a `(M.over U).Presentation` (a finite free presentation datum). Non-trivial build.
  - **`isFinitePresentation` (L130)**: substantive — the main theorem.
  - **`isFiniteType` (L139)**: thin but substantive — corollary of `isFinitePresentation`. The docstring says "finite type **and quasi-coherent**" but the type conclusion is only `M.IsFiniteType`, not `IsQuasicoherent`. Minor docstring overclaim.
  - **`chart_free_rank_one` (L153) — NEAR-RESTATEMENT**: The conclusion type is:
    ```
    ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
      Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)
    ```
    `IsLocallyTrivial M` is defined (checked: `LineBundlePullback.lean:115`) as exactly:
    ```
    ∀ x : X, ∃ U : X.Opens, x ∈ U ∧ IsAffineOpen U ∧
      Nonempty (M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf)
    ```
    The conclusion is **literally** `hM x`. The proof would be `exact hM x` (or `intro x; exact hM x` at most). This declaration adds no content over the hypothesis. The blueprint pin is `lem:lbc_rank_flat`, and the docstring claims "free of rank one ... in particular flat" but neither "rank" nor "flat" appears in the type. The type is solely the pointwise unfolding of `IsLocallyTrivial`. **Severity: major** — a blueprint-pinned declaration whose Lean type does not capture the stated mathematical content (rank-one free, flat). The body should either be `exact hM x` and acknowledged as trivial, or the type should be strengthened to include an explicit rank/flatness predicate.
  - **Missing `#check` probes (L62–63 docstring)**: The module header says "probed by the `#check` commands at the end of this file" (referring to the site-instance de-risk check for `HasSheafCompose` / `HasWeakSheafify` / `WEqualsLocallyBijective`). The file ends at L164 with no `#check` commands present. Either the probes were planned but not added, or the docstring is stale. Minor inaccuracy.

---

## Must-fix-this-iter

None. No excuse-comments on any declaration, no weakened-wrong definitions (the `chart_free_rank_one` type is mathematically correct, just trivial — it's sorry-bodied and not yet load-bearing), no parallel Mathlib APIs, no `axiom`-based workarounds.

---

## Major

- `TensorObjSubstrate.lean:41–54` — Status block says "ONE tracked typed-sorry residual" (`exists_tensorObj_inverse`) but the file has TWO sorry bodies (L715 and L2188 = `pullbackTensorMap_restrict`). A planner reading the header will miscount the file's open proof obligations. The status block was not updated when `pullbackTensorMap_restrict` was scaffolded this iteration.

- `LineBundleCoherence.lean:153–157` — `chart_free_rank_one` conclusion is a near-restatement of `IsLocallyTrivial M x`. The blueprint pin name `lem:lbc_rank_flat` and the declaration docstring both claim flatness and rank-one content, but neither appears in the type. If the blueprint chapter expects a statement with an explicit rank/flatness predicate (e.g., `Module.Free`/`Module.rank`/`Module.Flat` at the stalk or affine level), the type must be corrected before the body is filled — a sorry body here will close under the trivial proof `exact hM x`, silently cementing the wrong type.

---

## Minor

- `TensorObjSubstrate/DualInverse.lean:444` — `set_option backward.isDefEq.respectTransparency false` scoped to `homOfLocalCompat`. Non-standard elaboration option; legitimate in context but should be removed if the proof can be restructured to avoid it.

- `TensorObjSubstrate/DualInverse.lean` (various) — Large planner strategy / roadmap comment blocks embedded inside declaration docstrings (L163–232, L289–334, L466–514). Currently accurate but will accumulate staleness as the proof progresses. Recommend extracting into `informal/` or separate comments when the corresponding sub-lemmas close.

- `LineBundleCoherence.lean:62–63` — Docstring claims "`#check` commands at the end of this file" but no such commands exist. Stale documentation.

- `LineBundleCoherence.lean:135–142` — `isFiniteType` docstring says "finite type **and quasi-coherent**" but the theorem type proves only `M.IsFiniteType`, not `IsQuasicoherent`. Minor docstring overclaim.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 4
- **excuse-comments**: 0 (none)

Overall verdict: three files are structurally sound; all sorrys are genuine deferred residuals with accurate documentation, except that `TensorObjSubstrate.lean`'s status header undercounts the file's open sorrys by one (the newly-scaffolded `pullbackTensorMap_restrict`), and `LineBundleCoherence.lean`'s `chart_free_rank_one` statement is a pointwise restatement of `IsLocallyTrivial` rather than the rank/flatness content its blueprint pin name implies.
