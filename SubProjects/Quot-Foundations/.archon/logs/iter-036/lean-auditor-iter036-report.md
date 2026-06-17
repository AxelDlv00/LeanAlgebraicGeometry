# Lean Audit Report

## Slug
iter036

## Iteration
036

## Scope
- files audited: 3 (per directive)
- files skipped (per directive): all other project .lean files — directive restricted scope to FlatBaseChange.lean, GrassmannianCells.lean, QuotScheme.lean

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`base_change_mate_extendScalars_inner_value_counit` (L1997–2032) — CONFIRMED non-trivial, axiom-clean.** Statement: `(extendScalars ψ).map (base_change_mate_inner_value ψ φ M) ≫ (extendRestrictScalarsAdj ψ.hom).counit.app (…) = (base_change_mate_regroupEquiv ψ φ M).inv`. Non-trivial: it equates an algebraic composition (extension of scalars of the inner affine value, post-composed with the algebraic extend/restrict counit) to the inverse of the regrouping equivalence. Proof: `ext x` → `simp only [ModuleCat.extendScalars, ModuleCat.extendRestrictScalarsAdj]` → `change` → `erw [ExtendRestrictScalarsAdj.counit_app]` → `rw [ExtendScalars.map']` → `erw [Counit.map_apply_one_tmul]` → `exact congrArg _ rfl`. No sorry, no axiom. Fully closes step (b) of the Seam-3 plan.
  - **Sorry inventory — 4 sorries, as follows:**
    1. **L1700 — `base_change_mate_fstar_reindex_legs_conj` (root crux).** The conjugate-side discharge of the variable-legs reindex. Extensive proof plan at L1682–1699: apply `conjugateEquiv.injective`, lift locked components via `conjugateEquiv.surjective`, close by three isolated legs (conj-2b, conj-2c proved, conj-2d the cross-layer Seam-1 transport). Active in-progress work; "last authorized conjugate round (PROGRESS.md tripwire)" annotation at L1698. **Root of the sorry dependency chain.**
    2. **L2167 — `base_change_mate_gstar_transpose` (Seam-3 crux).** The `(g^* ⊣ g_*)` counit-conjugate coherence. Very detailed scaffold at L2062–2166. Two remaining pieces: step (a) inner reindex `Γ_R(θ_in) = ρ` (must be reproven inline, not cited from the sorry-backed `base_change_mate_fstar_reindex`); step (b) generator close — **now closed** by the new `base_change_mate_extendScalars_inner_value_counit`. Transitively depends on sorry 1 via `base_change_mate_fstar_reindex_legs`. Also depends on the landed `huce` counit transport `base_change_mate_gstar_counit_transport` (L1951–1989, proved axiom-clean).
    3. **L2348 — `affineBaseChange_pushforward_iso` (downstream, off the critical path).** Explicitly described as a "remaining multi-hundred-LOC build" for the restriction-compatibility of `pushforwardBaseChangeMap`. Proof comment L2323–2347 correctly identifies the affine reduction plan. Gated on sorry 2 (via `pushforward_base_change_mate_cancelBaseChange` → `base_change_mate_generator_trace` → `base_change_mate_section_identity` → `base_change_mate_gstar_transpose`). Not independently closeable until sorry 2 is discharged.
    4. **L2370 — `flatBaseChange_pushforward_isIso` (downstream, off the critical path).** Proof comment L2362–2369 explicitly says "deferred to a later iteration" and sketches the Stacks 02KH Čech-complex strategy. No tactic chain attempted. Gated on sorry 3 and on absent Čech-cohomology infrastructure. Not on the critical path.
  - **Critical path**: sorry 1 (`_legs_conj`) is the single root. Closing it closes sorry 2, which unlocks sorry 3. Sorry 4 is further gated on missing Čech infrastructure and is not a near-term obligation.
  - **L184–246 — Stale development narrative.** A long multi-paragraph comment block documenting the carrier-instance wall obstacle encountered in iters 234–241 and its resolution. The final line confirms the resolution is correct ("UPDATE (resolved): `pushforward_spec_tilde_iso` ... is now fully proved, no sorry"). The surrounding historical narrative (four intermediate-update paragraphs describing failed attempts and pivots) is no longer current state documentation — it is development log that belongs in a git commit message or PROGRESS archive, not in source code. Stale; does not mislead about the current proof, but adds ~60 lines of noise.
  - **L2089 — Minor comment accuracy.** `base_change_mate_gstar_transpose`'s proof plan calls `base_change_mate_fstar_reindex_legs_conj`'s sorry "a dead sorry." From the `gstar_transpose` proof perspective this is defensible (the inline approach deliberately avoids that code path), but "dead" could be misread as "abandoned." The sorry is actually the active root crux being worked on in `_legs_conj`. A reader of the `gstar_transpose` scaffold alone would get an inaccurate picture of the project's pending work.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **E1 — `existence_chart_factorization` (L1559–1574): CONFIRMED faithful and axiom-clean.** Statement exactly captures what E1 should say: for any `Spec K ⟶ scheme d r` over a field `K`, the image point factors through some affine chart `ι I` via a ring map `MvPolynomial … ℤ →+* K`. Proof: `ι_jointly_surjective`, `IsOpenImmersion.lift`, `Spec.preimage`. No sorry, no axiom.
  - **E2 — `existence_minimal_valuation` (L1583–1606): CONFIRMED faithful and axiom-clean.** Statement captures the valuative minimality: for a valuation ring `R` and fraction field `K`, among the minors `minorDet d r I.1 J'.1 I.2 J'.2` pulled back by `f`, there exists a `J` achieving the minimum valuation (and nonzero, witnessed by `minorDet_self` giving `v 1 = 1`). Uses `Finite.exists_max`. No sorry, no axiom.
  - **E3 — `existence_lift_transitionPreMap_minorDet_mul` (L1619–1629): CONFIRMED faithful and axiom-clean.** Statement: for rings with `IsUnit (f (minorDet I J))`, the localization lift of `transitionPreMap d r I J (minorDet J K)` times `f (minorDet I J)` equals `f (minorDet I K)`. This is the ratio core for E3 (triangle of minors). Proof: short application of `transitionPreMap_minorDet_mul` with `congrArg` + `map_mul` + `IsLocalization.Away.lift_eq`. No sorry, no axiom.
  - **L1609–1617 — Honest in-progress comment.** Notes that the remaining step — that free entries `x^J_{p,q}` are, up to sign, cofactor minors via column-substituted identity expansion — is open for E3-full. This is an accurate description of outstanding work, not an excuse-comment.
  - **`isSeparatedToSpecZ` (L1357): `set_option maxHeartbeats 3200000` + `set_option backward.isDefEq.respectTransparency false` — legitimate.** The separatedness proof involves `MvPolynomial` localization diamonds where instance-synthesis and defeq-checking are genuinely expensive. Both options are scoped to this one theorem.
  - **`theGlueData` (L1141)** and all transition/cocycle components read as correct structural code. The `affineChart` definition at L56 uses `MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ`, which is the correct free variable ring for the Plücker chart complement.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: 4 flagged (scaffold sorries)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`gammaPullbackImageIso` (L1668–1673): CONFIRMED real construction.** Definition applies `mapIso` of `(Scheme.Modules.restrictFunctorIsoPullback f).symm.app M` under the evaluation functor. No sorry, no `eqToIso` placeholder. The iso is the functorial image of the natural iso `restrictFunctorIsoPullback`, which is a genuine Mathlib construction.
  - **`gammaPullbackImageIso_hom_naturality` (L1678–1682): CONFIRMED real proof.** One-liner `(((Scheme.Modules.restrictFunctorIsoPullback f).symm.app M).hom.mapPresheaf).naturality i.op`. No sorry. Correctly invokes presheaf naturality.
  - **`gammaPullbackTopIso` (L1688–1691): CONFIRMED real construction with justified `eqToIso`.** The `eqToIso (by rw [Scheme.Hom.image_top_eq_opensRange])` transport is across the provable equality `f ''ᵁ ⊤ = f.opensRange`, established by a one-step rewrite. This is standard usage of `eqToIso` for a genuine definitional equation, not a fake placeholder.
  - **Scaffold sorries (4): `hilbertPolynomial` (L123), `QuotFunctor` (L161), `Grassmannian` (L198), `Grassmannian.representable` (L225).** All are `:= sorry` bodies on substantive definitions/claims. All are explicitly annotated "iter-176 file-skeleton" with "iter-177+ refinement work" planned. They are acknowledged scaffolds, not hidden sorries, but by the strict criterion `:= sorry` on a load-bearing claim qualifies as must-fix. The four downstream uses of `Grassmannian` in the file (`Grassmannian.representable`, the QuotScheme functor representability argument) are gated on these bodies.
  - **`overRestrictEquiv` (L930)** and **`isLocalizedModule_basicOpen_descent_of_cover` (L1626)** are fully proved axiom-clean. The `set_option maxHeartbeats 2000000` + `set_option synthInstance.maxHeartbeats 800000` + `set_option backward.isDefEq.respectTransparency false` blocks throughout are legitimate for heavy `IsRightAdjoint`/`HasSheafify` synthesis over the slice site.
  - **`annihilator_isLocalizedModule_eq_map` (L362):** fully proved, non-trivial localization argument. No issues.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/QuotScheme.lean:123` — `hilbertPolynomial := sorry`. `:= sorry` body on load-bearing definition. Why must-fix: it is used (or should be used) downstream in the Hilbert polynomial / flattening stratification chain; no actual polynomial is defined.
- `AlgebraicJacobian/Picard/QuotScheme.lean:161` — `QuotFunctor := sorry`. `:= sorry` body on the central functor the whole file is building toward. Why must-fix: every representability argument downstream of this definition is vacuous until it exists.
- `AlgebraicJacobian/Picard/QuotScheme.lean:198` — `Grassmannian := sorry`. `:= sorry` body on the Grassmannian scheme as a functor. Why must-fix: `Grassmannian.representable` and the morph to Quot depend on this existing.
- `AlgebraicJacobian/Picard/QuotScheme.lean:225` — `Grassmannian.representable := by sorry`. `:= sorry` on load-bearing representability claim. Why must-fix: representability is the keystone of the Quot scheme construction; a sorry body here makes the whole affine representability argument notional.

*Note on all four QuotScheme scaffold sorries*: these are explicitly annotated "iter-176 file-skeleton" items — the project knows they are scaffolds, not buried defects. The must-fix classification is strict-criteria-based, not a finding of malpractice. The relevant question is whether iter-177+ refinement is actively scheduled; if so, these are blocked tasks, not technical debt.

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1700` — `base_change_mate_fstar_reindex_legs_conj` proof body is `sorry`. This is the **root crux** of the entire FlatBaseChange sorry chain. Steps (a)–(d) of the conjugate discharge plan are documented at L1682–1699. Sorries at L2167, L2348, L2370 all ultimately descend from this. Active in-progress proof obligation with a clear route.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2167` — `base_change_mate_gstar_transpose` proof body ends in `sorry`. Seam-3 crux. Step (b) is now closed by the new `base_change_mate_extendScalars_inner_value_counit`. Step (a) (inline reproof of `Γ_R(θ_in) = ρ` without citing sorry-backed `base_change_mate_fstar_reindex`) and the dictionary cancellation matching `huce`'s factors remain. `set W` did not fold the `ε_g` argument — noted in L2165. Depends on root crux L1700 being closed first.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184–246` — Stale historical development narrative. A 60-line multi-paragraph comment block documenting the carrier-instance wall and recovery steps of iters 234–241. The final line states "resolved"; the narrative surrounding it is no longer current state. Stale development log in source code; should be pruned (moved to git history or PROGRESS archive).

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2348` — `affineBaseChange_pushforward_iso` proof ends in `sorry`. Downstream of L2167; gated on multi-hundred-LOC affine restriction-compatibility build (Stacks 02KH Step 2) which depends on gstar_transpose closing. Off the critical path. Proof comment accurately describes the plan.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2370` — `flatBaseChange_pushforward_isIso` proof ends in `sorry`. Explicitly "deferred to a later iteration." Full strategy (Čech complex + flatness) described at L2362–2369 but not started. Gated on absent Čech-cohomology infrastructure. Off the critical path.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2089` — Minor comment accuracy: the sorry in `base_change_mate_fstar_reindex_legs_conj` is called "a dead sorry" from within the `base_change_mate_gstar_transpose` scaffold. This is accurate from `gstar_transpose`'s proof perspective (that code path is deliberately bypassed) but could mislead a reader about the project's active work. The sorry is in fact the root crux, not dead.

---

## Excuse-comments (always called out separately)

None found. No file contained `-- TODO replace with real def`, `-- placeholder`, `-- temporary`, `-- wrong but works`, `-- will fix later`, or equivalent admissions that a definition is intentionally incorrect.

The QuotScheme scaffold annotations ("iter-176 file-skeleton", "iter-177+ refinement work") are planning notations, not admissions of wrongness — the scaffolds are structurally correct placeholders with known obligations.

---

## Severity summary

- **must-fix-this-iter**: 4 — all in QuotScheme.lean; `:= sorry` bodies on load-bearing definitions (acknowledged scaffolds, but strict-criteria-must-fix)
- **major**: 3 — FlatBaseChange.lean: root sorry L1700, gstar_transpose sorry L2167, stale comment block L184–246
- **minor**: 3 — FlatBaseChange.lean: downstream affineBaseChange sorry L2348, flatBaseChange sorry L2370, comment-accuracy note L2089
- **excuse-comments**: 0

**Overall verdict**: The codebase is in honest working order. The three verified focus declarations — `base_change_mate_extendScalars_inner_value_counit` (non-trivial, axiom-clean), E1/E2/E3 (faithful, axiom-clean), and the `gammaPullbackImageIso` family (real constructions) — all pass. The sorry inventory in FlatBaseChange.lean is exactly 4 as stated, with a clear dependency chain rooted at `base_change_mate_fstar_reindex_legs_conj` (L1700); sorries 3 and 4 are off the critical path until sorry 2 is closed. No excuse-comments, no weakened definitions, no unauthorized axioms. The 4 must-fix items in QuotScheme.lean are acknowledged scaffolds, not hidden defects, but meet the strict threshold.
