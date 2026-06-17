# Session 38 (iter-038) — Review Summary

## Metadata
- **Iteration:** 038 · **Session:** session_38 · **Prover model:** claude-opus-4-8
- **Lanes:** 2 import-independent prover lanes — **GR** (GrassmannianCells.lean) and **QUOT**
  (QuotScheme.lean). FBC ran NO prover this iter (the iter-037 tripwire fired; the plan cycle
  dispatched a cross-domain mathlib-analogist on the FBC route — decision: **KEEP**, residual is a
  PROOF not a refactor, scheduled as the iter-039 FBC prover round).
- **Sorry counts (active, real bodies):** GR 0 → 0; QUOT 4 → 4 (all 4 pre-existing protected
  iter-176 scaffold stubs at lines 126/165/201/228 — new code adds zero sorry); FBC 4 (untouched).
- **Builds:** both touched modules `lake build` GREEN (8317 jobs each; GrassmannianCells 35s). All
  8 new declarations `lean_verify` = `{propext, Classical.choice, Quot.sound}`.
- **blueprint-doctor:** 0 structural findings. **sync_leanok** (iter 38, sha `f0327d2`): +13 `\leanok`,
  0 removed (chapters: FlatBaseChange / GrassmannianCells / QuotScheme).
- **leandag:** gaps=0, unmatched=13 (coverage debt — see recommendations §coverage).

## Headline: Grassmannian properness CLOSED
The entire GR valuative-criterion existence arc landed axiom-clean this iter. The assigned objective
was E4 (`existence_lift`); the prover went well past it because E1–E3 + the cheap valuative-criterion
ingredients were already in place. **`AlgebraicGeometry.Grassmannian.isProper` (`lem:gr_proper`) is
proven: `Gr(d,r)` is proper over `ℤ`, axiom-clean.** The GR properness lane is now complete; GR-quot /
GR-repr are separate lanes in other files.

## GR lane — GrassmannianCells.lean (6 axiom-clean decls, properness closed)

### `existence_chart_kpoint_eq` (line 1866) — top-triangle K-point identity (NEW helper)
- Geometric core `Spec.map g ≫ ι_J = Spec.map f ≫ ι_I` for `g = f' ∘ θ̃_{I,J}`, via
  `Scheme.GlueData.glue_condition`, `chartTransition_comp_chartIncl`, `IsLocalization.Away.lift_comp`.
- **Recurring dead-end (confirmed again):** keyed `rw` / `Category.assoc` / `Spec.map_comp` FAIL on
  compositions led by `Spec.map (CommRingCat.ofHom …)` over heavy `MvPolynomial`/`Localization.Away`
  objects — *"Did not find an occurrence of the pattern"* even when the subterm prints verbatim (the
  Scheme-category instance diamond, same as `chartTransition'_fac` @914). Both assoc orientations and
  `clear_value` failed (the `set`-let on `f'` is not the root cause). **Fix = term mode:**
  `(Category.assoc _ _ _).symm`, `(Spec.map_comp _ _).symm`, `congrArg (· ≫ h)`, `congrArg Spec.map`,
  `congrArg (f ≫ ·)`, `calc`. The glue step specifically used `congrArg (Spec.map (ofHom f') ≫ ·) hglue`.

### `existence_lift` (line 1920) — E4 (assigned objective)
- First attempt as `theorem` → *"type of theorem `existence_lift` is not a proposition"* (it produces
  `sq.LiftStruct`, **data**). Fix: `noncomputable def`. Filler `ℓ := Spec.map g' ≫ ι_J`; `fac_left`
  (top triangle) via `existence_chart_kpoint_eq` + term-mode `calc`; `fac_right` (bottom triangle)
  via `specZIsTerminal.hom_ext _ _` (both legs into terminal `Spec ℤ`).

### `valuativeExistence_toSpecZ` (line 2017) — E5
- `intro S`; chain E1 `existence_chart_factorization` → E2 `existence_minimal_valuation` → E3
  `existence_factor_through_valuationRing` → E4, packaged `⟨⟨…⟩⟩` (`CommSq.HasLift`). **API note:** E2
  needs `(R := S.R)` explicitly (R only appears in `ValuationRing.valuation R K`, not inferable from f).

### `isProper` (line 2042) — E6 keystone `lem:gr_proper`
- One-liner: `isProper_of_valuativeExistence d r (valuativeExistence_toSpecZ d r)`.

### `liftToBaseOfMemRange` / `algebraMap_comp_liftToBaseOfMemRange` (private, 1977/1990)
- Corestrict `φ : A → K` with image in `(algebraMap R K).range` to `A → R` via
  `RingEquiv.ofBijective (algebraMap R K).rangeRestrict` (surjective + `IsFractionRing.injective`).

## QUOT lane — QuotScheme.lean (2 axiom-clean decls, gap1 semilinearity wall closed)

### `gammaImageRingEquiv` (line ~1815) — open-immersion structure-sheaf ring iso σ_V
- `σ_V := (j.appIso V).commRingCatIsoToRingEquiv.symm`, oriented **source → image**
  (`Γ(X,V) ≃+* Γ(Y, j ''ᵁ V)`).
- **DIRECTION choice (load-bearing):** opposite the blueprint pin `Γ(Y,j''ᵁV) ≃+* Γ(U,V)`, but this
  is the direction that makes the semilinearity statement typecheck (`a : Γ(X,V)`) and feeds bridge
  (I) `isLocalizedModule_of_ringEquiv_semilinear` verbatim. The lvb-quot checker confirmed source→image
  is the correct direction for downstream use; the blueprint is the side in error. **Review agent
  corrected the `% LEAN TYPE` pin + added a `% NOTE:` for the planner to flip the displayed prose.**

### `gammaPullbackImageIso_hom_semilinear` (line ~1825) — semilinearity wall
- `hom (a • x) = σ_V a • hom x`. Proof: `simp only [gammaPullbackImageIso, Functor.mapIso_hom,
  Functor.comp_map, Scheme.Modules.toPresheaf_map, evaluation_obj_map, mapPresheaf_app]`, then
  `erw [Scheme.Modules.Hom.app_smul]`, then `rfl`. **`erw` (not `rw`) required**: the goal carries an
  explicit `ConcreteCategory.hom (Hom.app ψ V)` coercion `rw`'s syntactic match misses but `erw`'s
  defeq match handles. The final `rfl` closes `a •_restrict m = σ_V a •_M m` because the
  `restrictFunctor` module structure is `restrictScalars` along `(j.appIso V).inv`, so the action is
  *definitionally* `(j.appIso V).inv a •_M m` and `σ_V a = commRingCatIsoToRingEquiv.symm a =
  (j.appIso V).inv a`. **Auditor MAJOR:** this `rfl` (line ~1840) encodes an unguarded defeq that would
  produce a mystery type-mismatch under a future `commRingCatIsoToRingEquiv` Mathlib change — accepted
  and honest now, but fragile.

### `isLocalizedModule_basicOpen_descent` (NOT added) — gap1 keystone, blocked
- Deliberately NOT stubbed (a `sorry` for `Hfr` is forbidden). The prover handed off a precise 6-step
  `Hfr` decomposition (in `task_results/.../QuotScheme.md`). **Critical path = step 1**: slice
  presentation ↔ scheme-pullback `IsIso fromTildeΓ` transport (Mathlib-absent, flagged in-file at
  lines 726–728). Steps 3–6 are mechanical now that the per-stage σ_V's + bridges (I)/(II) +
  semilinearity (this iter) are all in hand.

## Review-subagent dispositions (all 3 dispatched; reports archived in logs/iter-038/)
- **lean-auditor `iter038`** (both files): 4 must-fix / 1 major / 2 minor.
  - The 4 must-fix are the **pre-existing iter-176 protected scaffold stubs** in QuotScheme
    (126/165/201/228) — honest substantive-type skeletons with explicit iter-177+ gating, flagged only
    by the strict no-sorry rule, NOT new dead code.
  - **MAJOR**: the `rfl` at QuotScheme:~1840 in `gammaPullbackImageIso_hom_semilinear` is an unguarded
    definitional equality (fragile to a future `commRingCatIsoToRingEquiv` change). → recommendations.
  - Minor: GrassmannianCells duplicated `letI hinj` (private, contained); stale `scaffold`
    archon-marker labels on the now-complete E4/E5 section headers.
  - GrassmannianCells.lean otherwise fully clean; all 6 new decls honest + axiom-clean.
- **lean-vs-blueprint-checker `gr-iter038`**: 0 must-fix, 1 major — public theorem
  `existence_chart_kpoint_eq` has no `\lean{...}` blueprint block (coverage debt). All pinned decls
  axiom-clean, no sorry, statements match.
- **lean-vs-blueprint-checker `quot-iter038`**: 0 Lean red flags; 1 major **blueprint-side** —
  `def:gamma_image_ring_equiv` direction error (Lean has the correct source→image; blueprint stated
  image→source). Partially fixed this review (pin + NOTE); the displayed prose flip is the planner's.

## Blueprint markers updated (manual)
- `Picard_QuotScheme.tex`, `def:gamma_image_ring_equiv`: corrected the `% LEAN TYPE` pin direction to
  `Γ(U, V) ≃+* Γ(Y, j ''ᵁ V)` (source→image, matching the built `gammaImageRingEquiv`) and added a
  `% NOTE (review iter-038):` flagging the load-bearing direction + asking the planner to flip the
  displayed `\[\sigma_V\]` prose.
- No `\mathlibok` added (no new Mathlib re-export decls this iter). No stale `\notready` to strip.

## Key findings / patterns
- **Term-mode glue is mandatory through the Scheme-category instance diamond** (heavy
  `Spec.map (ofHom …)` over `MvPolynomial`/`Localization.Away`): keyed `rw`/`Category.assoc`/
  `Spec.map_comp` silently fail to match; use `congrArg`/`.symm`/`calc`. Now confirmed across
  `chartTransition'_fac`, `existence_chart_kpoint_eq`, and `existence_lift`.
- **Lift-structure deliverables are data**: a valuative-criterion filler returning `sq.LiftStruct`
  must be `noncomputable def`, not `theorem`.
- **`erw` for ConcreteCategory coercion matching**: when a goal carries `ConcreteCategory.hom (Hom.app
  ψ V)`, `rw` misses the syntactic match; `erw` + defeq closes it.

## Recommendations
See `recommendations.md`. Next iter: FBC-A conj-2b/conj-2d prover round (iter-039, tripwire-scheduled);
QUOT Hfr step-1 (slice↔pullback transport) — likely needs blueprint section + sub-decomposition first;
GR properness lane is done (consider pivoting GR effort to GR-quot/GR-repr lanes).
