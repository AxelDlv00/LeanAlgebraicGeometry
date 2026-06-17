# Recommendations — after iter-038 (for the iter-039 plan agent)

## 1. HIGH — fix the QUOT blueprint direction prose (planner-owned half)
`def:gamma_image_ring_equiv` in `Picard_QuotScheme.tex` had its `% LEAN TYPE` pin corrected and a
`% NOTE:` added by the review agent, but the **displayed informal math**
`\[\sigma_V : \Gamma(O_Y, j''V) \to \Gamma(O_U, V)\]` still reads image→source. The Lean (correctly,
per the lvb-quot checker) is **source→image** `Γ(U,V) ≃+* Γ(Y, j''ᵁV)`. Flip the displayed `\sigma_V`
direction so prose matches Lean. Review-agents cannot rewrite informal prose; this is yours.

## 2. HIGH (fragility) — guard the `rfl` in `gammaPullbackImageIso_hom_semilinear`
lean-auditor `iter038` flagged the final `rfl` (QuotScheme.lean ~line 1840) as an unguarded
definitional equality (`a •_restrict m = σ_V a •_M m`) that would break with a future
`commRingCatIsoToRingEquiv` Mathlib change, producing a mystery type-mismatch. It is honest and
axiom-clean now. Consider (next time this file is touched) replacing the bare `rfl` with an explicit
rewrite chain through `commRingCatIsoToRingEquiv` / `appIso` so the dependency is named, not implicit.
Not blocking; log as a hardening task.

## 3. Coverage debt (1-to-1 Lean↔blueprint) — `archon dag-query unmatched` = 13 nodes
Every Lean decl must have a blueprint entry. New-this-iter substantive public decls needing a block:
- **`AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq`** (GrassmannianCells.lean:1866) — the
  top-triangle K-point identity `Spec.map g ≫ ι_J = Spec.map f ≫ ι_I` for `g = f' ∘ θ̃_{I,J}`. Depends
  on `Scheme.GlueData.glue_condition`, `chartTransition_comp_chartIncl`, `IsLocalization.Away.lift_comp`.
  Add `lem:gr_existence_chart_kpoint_eq` and wire it as a `\uses` of `lem:gr_existence_lift`. (Also
  flagged major by lvb-gr-iter038.)
- Private GR helpers (clear on sync as private, low priority): `liftToBaseOfMemRange`,
  `algebraMap_comp_liftToBaseOfMemRange`, `det_one_updateCol`, `rotMid`, `transitionInvImageMatrix`,
  `transitionInvPair`.
- QUOT private/aux helpers (pre-existing debt, low priority): `descent_overlap_agree`,
  `descent_smul_eq_zero`, `descent_surj`, `iSup_basicOpen_subtype_eq_top`, `res_comp`,
  `isIso_unitToPushforwardObjUnit_of_isIso'`.

## 4. Stale `scaffold` markers (Lean comments — prover/scaffolder domain)
lean-auditor flagged stale `scaffold` archon-marker labels on the now-complete E4/E5 section headers in
GrassmannianCells.lean. Per the recurring memo (scaffold-keyword-same-line filter), stale `scaffold`
keywords can mis-drop or mis-keep objectives. Ask the next GR prover (or a cleanup pass) to strip the
`scaffold` keyword from the E4/E5 section comments now that those sections are done.

## 5. Lane status & next prover assignments

### GR — properness lane CLOSED ✅ (do NOT re-assign)
`isProper` / `lem:gr_proper` is proven axiom-clean: **Gr(d,r) proper over ℤ**. There is nothing
further attemptable in GrassmannianCells.lean's properness chain. Pivot GR effort to the separate
**GR-quot / GR-repr** lanes (different files / chapters) if those are the next strategic target.

### QUOT — gap1 Hfr assembly, open critical path
The semilinearity wall (objectives 1+2) is done. The named keystone
`isLocalizedModule_basicOpen_descent` is blocked on the **multi-stage Hfr assembly**. The prover left a
precise 6-step decomposition in `task_results/AlgebraicJacobian/Picard/QuotScheme.md`:
- **Critical path = step 1**: slice presentation ↔ scheme-pullback `IsIso fromTildeΓ` transport —
  Mathlib-absent, flagged in-file (QuotScheme.lean:726–728). **This likely needs its own blueprint
  section + a sub-decomposition (effort-breaker) BEFORE a prover round.** Do NOT send a prover at the
  whole `Hfr` in one go.
- Steps 3–6 are mechanical once the per-stage `σ_V`'s are composed; bridges (I)/(II)
  (`isLocalizedModule_of_ringEquiv_semilinear`, `isLocalizedModule_restrictScalars_powers_algebraMap`)
  + this iter's `gammaImageRingEquiv` / `gammaPullbackImageIso_hom_semilinear` make 4–6 a verbatim
  application.

### FBC — KEEP the conjugate route; iter-039 PROOF round (tripwire-scheduled, NOT a consult)
No prover ran on FBC this iter (the iter-037 tripwire fired correctly → plan cycle ran a cross-domain
mathlib-analogist; verdict **KEEP** — the mate coherence is irreducible, the residual is a PROOF not a
refactor). progress-critic `iter038` returned FBC STUCK with a must-fix: **iter-039 must dispatch a
prover on `conj-2b`/`conj-2d`** (the two ready frontier sub-lemmas + the reframing), NOT another
analogist consult, NOT a structural refactor. strategy-critic `iter038` CHALLENGE ("execute the re-cut,
don't re-consult") points the same way. The FBC `gstar_transpose` / `_legs_conj` cluster has carried a
sorry for 6+ iters — do NOT re-assign a bare assembly/section round on `_legs_conj`; the iter-039 round
must target the decomposed conj-2b/conj-2d frontier nodes specifically.

## 6. Reusable proof patterns discovered (this iter)
- **Term-mode glue through the Scheme-category instance diamond**: keyed `rw`/`Category.assoc`/
  `Spec.map_comp` fail to match on `Spec.map (ofHom …)` over `MvPolynomial`/`Localization.Away`; use
  `congrArg (· ≫ h)` / `congrArg (f ≫ ·)` / `(Category.assoc _ _ _).symm` / `(Spec.map_comp _ _).symm`
  / `calc`. `clear_value` does not help; the `set`-let is not the root cause.
- **Valuative-criterion fillers are data** → `noncomputable def` returning `sq.LiftStruct`, not
  `theorem` (`fac_right` into terminal `Spec ℤ` = `specZIsTerminal.hom_ext`).
- **`erw` for `ConcreteCategory.hom (Hom.app ψ V)` coercion** when `rw`'s syntactic match misses.
- **Corestrict-to-base via `RingEquiv.ofBijective (algebraMap R K).rangeRestrict`** (surjective +
  `IsFractionRing.injective`) for "image lands in the base ring's range" lifts.
