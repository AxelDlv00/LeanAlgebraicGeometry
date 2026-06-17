# AlgebraicJacobian/AbelianVarietyRigidity.lean — iter-183 Lane E

## Status entering / exiting

- **Entering**: 2 sorries (L110 helper `iotaGm_isOpenImmersion` body + L402
  off-target `genusZero_curve_iso_P1`).
- **Exiting**: **3 sorries** (L105 `iotaGm_onePt_chart1_factor`,
  L195 `iotaGm_chart1_composition_isOpenImmersion`, L535
  `genusZero_curve_iso_P1`).
- `lake env lean` **GREEN**, no errors. Only the 3 expected
  `declaration uses sorry` warnings.

## Outcome: STRUCTURAL ADVANCE (per iter-183 helper budget = 2)

Refactored the iter-182 single-sorry helper `iotaGm_isOpenImmersion`
body into structural assembly of **two named sub-task helpers**, per
the iter-183 directive ("Helper budget = 2; target Tier-1 for sub-task
(b)/(f) bodies"). The parent `iotaGm_isOpenImmersion` body is now
**sorry-FREE** — its body is pure structural composition using the
helpers. Sorries propagate from helpers via `sorryAx`.

## iotaGm_isOpenImmersion (L283, parent)

### Attempt 1
- **Approach**: Refactor body into clean structural assembly of two
  named sub-task helpers (sub-task b + sub-task f), per
  `analogies/intersection-ring-cross01.md` Decision 4 recipe.
- **Result**: RESOLVED — body is now 12 LOC of structural composition:
  - `rw [Over.lift_left]` + `simp only [Over.comp_left, ...]`
    + `change` to expose `pullback.lift _ _ _ ≫ glueMorphisms`.
  - `obtain ⟨r_1, h_r_1⟩ := iotaGm_onePt_chart1_factor kbar`
    (sub-task b).
  - `have hfact` reduces the LHS via `← Cover.ι_glueMorphisms` for
    chart `1 : Fin 2` + `(pullback.lift_fst _ _ _).symm`. Result:
    `pullback.lift _ _ _ ≫ glueMorphisms = section ≫ gmScalingP1_chart 1`.
  - `have := iotaGm_chart1_composition_isOpenImmersion r_1 h_r_1`
    (sub-task f) + `rwa [← hfact] at this`.
- **Key insight**: Direct `rw [hfact]` on the goal fails due to
  elaboration mismatch (a `pullback.lift` metavariable issue
  with `OverClass.asOver_hom` simp lemma firing). Workaround:
  apply the helper, get the matching IsOpenImmersion fact, then
  `rwa [← hfact] at this` does the reverse rewrite cleanly.
- **Lemmas verified existing**: `Over.lift_left`,
  `pullback.lift_fst`, `Scheme.Cover.ι_glueMorphisms`.

## iotaGm_inner_lift_compat (L130, new aux helper)

### Attempt 1
- **Approach**: Term-mode proof using `(Category.assoc _ _ _).trans`
  composed with `congrArg ((Gm).hom ≫ ·) (Over.w _)` and `simp` for
  the trivial `(𝟙_).hom = 𝟙 _ ≫ Gm.hom` collapse.
- **Result**: RESOLVED axiom-clean. The `Over.w` rewriter fails
  tactic-mode due to `(ProjectiveLineBar kbar).hom` being recognized
  as `X ↘ S` (the `OverClass.asOver_hom` simp form) rather than
  `Over.hom`. Term-mode `congrArg` bypasses this.
- **Tactic trap recorded**: `rw [Over.w]` and `simp [Over.w]` BOTH fail
  on this kind of goal because the underlying elaboration replaces
  `(asOver X S).hom` with `X ↘ S` (via the `@[simps! hom left]`
  generation on `OverClass.asOver`). Use term-mode `congrArg` with
  `Over.w` or `aesop_cat` as fallback.

## iotaGm_chart1_section (L137, new section def)

### Attempt 1
- **Approach**: Define the section explicitly as the nested
  `pullback.lift` over the outer pullback `(cover).X 1 = pullback q
  (awayι (![X 0, X 1] 1))` with compatibility derived from
  `pullback.lift_fst` and `h_r_1`.
- **Result**: RESOLVED axiom-clean. The outer compatibility proof
  closes via `simp [pullback.lift_fst, ← h_r_1, Category.assoc]; rfl`.
- **Key insight**: Plain `rw [pullback.lift_fst]` fails (elaboration
  metavariable issue on inferring the inner pullback's `f g`); use
  `simp [pullback.lift_fst, ← h_r_1, Category.assoc]` followed by
  `rfl`. The `rfl` closes a `Proj.awayι (![X 0, X 1] 1) = (cover.f 1)`
  defeq (the `cover.f 1` unfolds to that `Proj.awayι` form).

## iotaGm_onePt_chart1_factor (L105, sub-task b helper — sorry)

### Attempt 1
- **Approach 1 (initial)**: Provide explicit `r_1 := Spec.map (CommRingCat.ofHom (eval at u=1 ∘ chartIso))`
  then chase factorisation via `fromOfGlobalSections_morphismRestrict`.
- **Result**: PARTIAL — abandoned in favour of `IsOpenImmersion.lift`.
- **Approach 2 (committed)**: Use `IsOpenImmersion.lift` against the
  open immersion `Proj.awayι (![X 0, X 1] 1) _ _`. The factorisation
  equation `r_1 ≫ awayι = onePt.left` becomes
  `IsOpenImmersion.lift_fac _ _ _` automatically.
- **Result**: STRUCTURAL — residual sorry collapses to JUST the range
  containment `Set.range onePt.left ⊆ Set.range (awayι (X 1))`.
- **Next step (iter-184+)**: Close the range containment via
  (i) `opensRange_awayι` identifies range as `(D₊(X 1) : Set _)`;
  (ii) `fromOfGlobalSections_preimage_basicOpen` identifies the
  preimage of `D₊(X 1)` under `onePt.left = fromOfGlobalSections _ _ _`
  with `(Spec k̄).basicOpen (evalIntoGlobal v (X 1)) =
  (Spec k̄).basicOpen 1 = ⊤`. ~10-15 LOC.
- **Lemmas verified existing**: `IsOpenImmersion.lift`,
  `IsOpenImmersion.lift_fac` (Mathlib
  `AlgebraicGeometry/OpenImmersion.lean:636-641`),
  `Proj.opensRange_awayι`,
  `Proj.fromOfGlobalSections_preimage_basicOpen`.

## iotaGm_chart1_composition_isOpenImmersion (L195, sub-task f helper — sorry)

### Attempt 1
- **Approach**: Decompose `section ≫ gmScalingP1_chart 1` as three
  open immersions:
  - `Spec(GmRing) → Spec(MvPoly Unit kbar)` (localization at `t`, via
    `IsOpenImmersion.of_isLocalization` — Mathlib `Scheme.isOpenImmersion_SpecMap_localizationAway`).
  - `Spec(MvPoly Unit kbar) ≅ Spec(Away 𝒜 (X 1))` (via
    `Spec.map homogeneousLocalizationAwayIso.symm`, an iso).
  - `Spec(Away 𝒜 (X 1)) → ℙ¹` (via `Proj.awayι (X 1)`, instance).
- **Result**: STRUCTURAL TYPED SORRY. The full equality chain
  unfolding `gmScalingP1_chart 1 = (cover_X_iso 1).hom ≫ Spec.map (chart-ring map) ≫ Proj.awayι X_1`
  plus the `pullback.lift_fst/snd` projections of the section is
  ~30-60 LOC. iter-184+ closure target.
- **Strategy comment**: The composition `section ≫ gmScalingP1_chart 1`
  realises the canonical inclusion `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹`
  sending `λ ↦ [λ : 1]`. Each of the three factor open immersions is
  a Mathlib instance; the residual work is establishing the EXPLICIT
  equality of the composed section with this 3-step chain.

## genusZero_curve_iso_P1 (L535, off-target)

UNCHANGED — gated on Riemann-Roch (Lane I + RR.4 chain). No iter-183
work here.

## Sorry budget summary

- Iter-183 net effect on this file: 2 → 3 sorries (+1). Acceptable
  per iter-183 plan helper budget = 2 (both helpers may carry sorries
  this iter; iter-184+ targets axiom-clean closure).
- Parent `iotaGm_isOpenImmersion` body is now sorry-FREE; sorryAx
  propagates only via the two sub-task helpers.

## Disclosure tier

- `iotaGm_onePt_chart1_factor` — **Tier-3** (honest direct sorry on
  range containment, explicit witness via `IsOpenImmersion.lift`).
- `iotaGm_chart1_composition_isOpenImmersion` — **Tier-3** (honest
  direct sorry on the 3-step open-immersion equality, explicit
  section def provided).
- `iotaGm_inner_lift_compat`, `iotaGm_chart1_section` — **Tier-1**
  (axiom-clean) supporting helpers.
- `iotaGm_isOpenImmersion` — **Tier-2 modulo upstream** (body
  sorry-free assembly; lifts to Tier-1 once both sub-tasks close).

## Recommendations for iter-184+

1. **Sub-task (b)** is now bottle-necked to just the range containment
   (~10-15 LOC). Two Mathlib lemmas (`opensRange_awayι` +
   `fromOfGlobalSections_preimage_basicOpen`) bridge it. **Easy
   iter-184 win.**

2. **Sub-task (f)** is the harder one: ~30-60 LOC unfolding
   `gmScalingP1_chart 1` and chasing `pullback.lift_fst/snd`.
   Iter-184+ ETA reasonable.

3. **Once both close**, the parent `iotaGm_isOpenImmersion` becomes
   Tier-1 axiom-clean transitively, retroactively making
   `iotaGm_range_isOpen` + `iotaGm_isDominant` axiom-clean too.

## Tooling traps recorded

- `rw [Over.w f]` fails on goals containing `(asOver X S).hom`
  because the `@[simps! hom left]` simp on `OverClass.asOver`
  generates a lemma `asOver_hom : (asOver X S).hom = X ↘ S` that
  elaboration applies eagerly. Fix: use term-mode `congrArg
  ((g ≫ ·) (Over.w _))` or `aesop_cat`.

- `rw [hfact]` fails on a hypothesis `hfact : f ≫ g = h` when the
  goal contains `f ≫ g` but the pattern matching fails (likely due
  to the same `Over.hom` elaboration mismatch). Workaround:
  `have := lemma_using_h; rwa [← hfact] at this`.

- `pullback.lift_fst` rewrites can fail when implicit pullback args
  contain metavariables. Workaround: `simp [pullback.lift_fst, ...]`
  with the relevant rewrite chain, often followed by `rfl` to close
  on defeq (e.g. `(![X 0, X 1] 1) = X 1`).
