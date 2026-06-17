# Mathlib Analogist Report

## Mode
api-alignment

## Slug
lane-e-projappiso

## Iteration
189

## Question

For Lane E (`iotaGm_chart1_composition_isOpenImmersion` in
`AlgebraicJacobian/AbelianVarietyRigidity.lean:252-439`): does Mathlib
at b80f227 expose `(Proj.awayι _).appIso ⊤` as a usable identity, and
if not, what is the cleanest Mathlib-aligned recipe for the residual
fact `r_1.appTop ((ΓSpecIso _).inv isLocElem) = (ΓSpecIso k̄).inv 1`,
where `r_1 ≫ Proj.awayι (X 1) = onePt.left` and `onePt.left =
Proj.fromOfGlobalSections 𝒜 (evalIntoGlobal v=(1,1)) hφ`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| `iotaGm_onePt_chart1_factor` packaging (∃ vs def) | ALIGN_WITH_MATHLIB | critical |
| `(Proj.awayι _).appIso ⊤` simp lemma | NEEDS_MATHLIB_GAP_FILL (partial) | informational |
| `lift_app` vs `morphismRestrict` route | DIVERGE_INTENTIONALLY (lift_app preferred) | informational |

## Section 1: Mathlib `Proj.appIso` / `IsOpenImmersion.lift_app` API survey at b80f227

**`IsOpenImmersion.lift_app` exists.**
File: `Mathlib/AlgebraicGeometry/OpenImmersion.lean:696`.
```lean
theorem lift_app {X Y U : Scheme.{u}} (f : U ⟶ Y) (g : X ⟶ Y) [IsOpenImmersion f] (H)
    (V : U.Opens) :
    (lift f g H).app V = (f.appIso V).inv ≫ g.app (f ''ᵁ V) ≫
      X.presheaf.map (eqToHom <| app_eq_invApp_app_of_comp_eq_aux _ _ _ (lift_fac ..).symm V).op
```
No `lift_appTop` specialization. Instantiate at `V = ⊤`.

**`Scheme.Hom.appIso`** (`Mathlib/AlgebraicGeometry/OpenImmersion.lean:190`):
```lean
def appIso (U) : Γ(Y, f ''ᵁ U) ≅ Γ(X, U)
```
For `f = Proj.awayι (X 1)` and `U = ⊤`:
- `f ''ᵁ ⊤ = f.opensRange = Proj.basicOpen 𝒜 (X 1)` (by `Proj.opensRange_awayι`, line 199).
- So `appIso ⊤ : Γ(Proj 𝒜, basicOpen 𝒜 (X 1)) ≅ Γ(Spec(Away 𝒜 (X 1)), ⊤) ≅ Away 𝒜 (X 1)`.
- The directive's `appIso ⊤ : Γ(Proj 𝒜, ⊤) ≅ ...` reading is incorrect —
  the `Γ(Y, ⊤)` side comes from `f ''ᵁ ⊤`, NOT plain `⊤`.

**No direct simp lemma for `(Proj.awayι _).appIso ⊤`** identifying it
with `Proj.basicOpenIsoAway`. Grepped
`.lake/packages/mathlib/Mathlib/AlgebraicGeometry/{ProjectiveSpectrum,Morphisms,OpenImmersion}*`
for `awayι.*appIso|appIso.*awayι|awayι_app_basicOpen|awayι_appIso_top`
— zero matches.

**Related Mathlib pieces that bridge the gap** (each verified with
`lean_local_search`):

- `AlgebraicGeometry.Proj.opensRange_awayι` (`Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:199`):
  `(Proj.awayι 𝒜 f f_deg hm).opensRange = Proj.basicOpen 𝒜 f`.
- `AlgebraicGeometry.Proj.basicOpenIsoAway` (line 179):
  `CommRingCat.of (Away 𝒜 f) ≅ Γ(Proj 𝒜, basicOpen 𝒜 f)` via `awayToSection`.
- `AlgebraicGeometry.Proj.basicOpenToSpec_app_top` (line 143):
  `(basicOpenToSpec 𝒜 f).app ⊤ = (ΓSpecIso _).hom ≫ awayToSection 𝒜 f ≫ basicOpen.topIso.inv`.
- `AlgebraicGeometry.Proj.awayι_preimage_basicOpen` (line 304):
  `awayι 𝒜 f f_deg hm ⁻¹ᵁ basicOpen 𝒜 g = PrimeSpectrum.basicOpen (Away.isLocalizationElem f_deg g_deg)`.
- `AlgebraicGeometry.Proj.fromOfGlobalSections_morphismRestrict` (line 493):
  the restriction of `fromOfGlobalSections` to a basic open is
  `(isoOfEq _).hom ≫ toBasicOpenOfGlobalSections`.
- `AlgebraicGeometry.Proj.fromOfGlobalSections_resLE` (line 502): same idea,
  cleaner resLE form.

## Section 2: Project-side path that aligns with Mathlib

The iter-188 6-step recipe is **structurally sound**; iter-188's failure
was not a recipe defect but a **packaging defect upstream**: the `r_1`
in `iotaGm_onePt_chart1_factor` is hidden inside an `∃`, so the
consumer cannot directly use the `IsOpenImmersion.lift` characterization
needed by `lift_app`. Iter-188's "attempt 2" rediscovered `h_range` via
`cancel_mono`, which works but duplicates ~30-40 LOC already proven in
`iotaGm_onePt_chart1_factor` body (lines 122-163).

**Aligned refactor (recommended, do this in iter-190)**:

1. **Refactor `iotaGm_onePt_chart1_factor`** (file
   `AlgebraicJacobian/AbelianVarietyRigidity.lean:106-163`) into:
   - `iotaGm_onePt_chart1_range : Set.range (ProjectiveLineBar.onePt kbar).left ⊆ Set.range (Proj.awayι ... (X 1) ...)` (lemma — moves out the range-containment body, lines 129-162).
   - `iotaGm_r_1 : noncomputable def ... := IsOpenImmersion.lift (Proj.awayι ...) onePt.left iotaGm_onePt_chart1_range` (the explicit lift).
   - `iotaGm_r_1_fac : iotaGm_r_1 ≫ Proj.awayι ... = onePt.left := IsOpenImmersion.lift_fac _ _ _` (the equation, free).
   - Keep `iotaGm_onePt_chart1_factor : ∃ r_1, ...` as a derived wrapper if any consumer still wants the existential form.

2. **Refactor `iotaGm_chart1_composition_isOpenImmersion`** to consume
   `iotaGm_r_1` and `iotaGm_r_1_fac` directly (replacing the `obtain ⟨r_1, h_r_1⟩` pattern in `iotaGm_isOpenImmersion`). This makes
   `r_1` and the lift identity inline-accessible for `simp [iotaGm_r_1, IsOpenImmersion.lift_app]`.

3. **The helper `r_1_appTop_isLocElem_eq_one`** (Section 4 below) can
   then call `IsOpenImmersion.lift_app` directly, bypassing the
   `cancel_mono` machinery.

## Section 3: Verified Mathlib lemmas to call

All verified with `lean_local_search` and direct file reads at the
project's pinned commit:

| Lemma | File:line | Use |
|---|---|---|
| `AlgebraicGeometry.IsOpenImmersion.lift_app` | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:696` | Expand `r_1.app ⊤` |
| `AlgebraicGeometry.IsOpenImmersion.lift_uniq` | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:643` | Identify `r_1 = lift _ _ _` from `h_r_1` (only needed if NOT refactoring per Section 2) |
| `AlgebraicGeometry.IsOpenImmersion.lift_fac` | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:640` | The lift's defining equation |
| `AlgebraicGeometry.Scheme.Hom.appIso` (defn) | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:190` | The iso type |
| `AlgebraicGeometry.Scheme.Hom.appIso_inv_app` | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:224` | `(f.appIso U).inv ≫ f.app (f ''ᵁ U) = eqToHom`-shape — invert the appIso |
| `AlgebraicGeometry.Scheme.Hom.app_appIso_inv` | `Mathlib/AlgebraicGeometry/OpenImmersion.lean:210` | The dual: `f.app U ≫ (f.appIso (f ⁻¹ᵁ U)).inv = homOfLE` |
| `AlgebraicGeometry.Proj.opensRange_awayι` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:199` | Rewrite `awayι ''ᵁ ⊤` |
| `AlgebraicGeometry.Proj.basicOpenIsoAway` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:179` | The iso `Away 𝒜 f ≅ Γ(Proj 𝒜, basicOpen)` |
| `AlgebraicGeometry.Proj.basicOpenIsoSpec` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:164` | The iso `basicOpen ≅ Spec(Away)` |
| `AlgebraicGeometry.Proj.basicOpenToSpec_app_top` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:143` | Connect `basicOpenIsoSpec.hom.app ⊤` to `awayToSection` |
| `AlgebraicGeometry.Proj.awayι_preimage_basicOpen` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:304` | `awayι ⁻¹ᵁ basicOpen g = PrimeSpectrum.basicOpen (isLocalizationElem)` (auxiliary) |
| `AlgebraicGeometry.Proj.fromOfGlobalSections_morphismRestrict` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:493` | Identify `onePt.left ∣_ basicOpen 𝒜 (X 1)` with `toBasicOpenOfGlobalSections` |
| `AlgebraicGeometry.Proj.fromOfGlobalSections_resLE` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:502` | Cleaner resLE variant of the above |
| `AlgebraicGeometry.Proj.toBasicOpenOfGlobalSections` (defn) | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:371` | Unfold to expose `IsLocalization.map` underlying ring map |
| `AlgebraicGeometry.Proj.fromOfGlobalSections_preimage_basicOpen` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:457` | `fromOfGlobalSections ⁻¹ᵁ basicOpen 𝒜 r = X.basicOpen (f r)` (needed for iso-of-eq plumbing in toBasicOpen) |
| `AlgebraicGeometry.Scheme.Hom.comp_appTop` | `Mathlib/AlgebraicGeometry/Scheme.lean:390` | `(f ≫ g).appTop = g.appTop ≫ f.appTop` |
| `HomogeneousLocalization.Away.isLocalizationElem` (defn) | `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:877` | `Away.mk 𝒜 hf e (g^d) ...` — exposes `isLocElem = X_0 / X_1` |
| `AlgebraicGeometry.ProjectiveSpectrum.Proj.awayToSection_apply` | `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Scheme.lean:616` | Pointwise formula for `awayToSection`: `IsLocalization.map` chase |

**Confirmed NOT in Mathlib at b80f227 (do NOT call)**:
- `IsOpenImmersion.lift_appTop` — does not exist as a separate lemma.
- `Proj.awayι_app_basicOpen` / `Proj.awayι_appIso_top` — no direct simp
  lemma identifying `(Proj.awayι _).appIso ⊤` with `basicOpenIsoAway`.
  Must be derived from `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι` plus
  `basicOpenToSpec_app_top`.

## Section 4: Concrete `r_1_appTop_isLocElem_eq_one` helper signature

Assuming the Section 2 refactor (which exposes `iotaGm_r_1` as a `def`),
the helper signature is:

```lean
private lemma r_1_appTop_isLocElem_eq_one (kbar : Type u) [Field kbar] :
    (iotaGm_r_1 kbar).appTop ((Scheme.ΓSpecIso _).inv.hom
      (HomogeneousLocalization.Away.isLocalizationElem
        (𝒜 := projectiveLineBarGrading kbar)
        (f := (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar))
        (g := (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar))
        (MvPolynomial.isHomogeneous_X kbar 1)
        (MvPolynomial.isHomogeneous_X kbar 0))) =
    (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom 1
```

(The `(ΓSpecIso _).inv.hom isLocElem` form is the section-shape; the
RHS is the section-shape of `1`.)

**Skeleton body** (~60-80 LOC realistic, NOT 30-50; the directive
underestimated):

```lean
private lemma r_1_appTop_isLocElem_eq_one (kbar : Type u) [Field kbar] :
    (iotaGm_r_1 kbar).appTop ((Scheme.ΓSpecIso _).inv.hom
      (Away.isLocalizationElem _ _)) =
    (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom 1 := by
  -- Step 1: unfold `iotaGm_r_1` to expose the explicit `lift`.
  unfold iotaGm_r_1
  -- Step 2: rewrite r_1.app ⊤ via `lift_app` at V = ⊤.
  rw [IsOpenImmersion.lift_app]
  -- After lift_app, the goal has the form:
  --   ((awayι).appIso ⊤).inv ≫ onePt.left.app (awayι ''ᵁ ⊤) ≫ presheaf.map (eqToHom).op
  -- evaluated on (ΓSpecIso).inv isLocElem.
  -- Step 3: rewrite `awayι ''ᵁ ⊤ = awayι.opensRange = Proj.basicOpen 𝒜 (X 1)`.
  simp only [TopologicalSpace.Opens.map_top, Proj.opensRange_awayι, ...]
  -- Step 4: identify `(awayι).appIso ⊤ .inv (isLocElem in Γ(Spec(Away), ⊤))`
  --         with `basicOpenIsoAway.hom (isLocElem in Away)`.
  -- Use `awayι = basicOpenIsoSpec.inv ≫ basicOpen.ι` (definition) +
  -- `basicOpenToSpec_app_top` + `basicOpenIsoAway = asIso awayToSection`.
  -- This is the genuinely hard part — ~20-30 LOC.
  rw [show (Proj.awayι _ _ _ _).appIso ⊤ =
        (Proj.basicOpenIsoAway _ _ _ _).symm.trans
        ((Proj.basicOpen _ _).topIso.symm)  -- modulo eqToHom for opensRange
      from ?_]
  -- Step 5: evaluate `onePt.left.app (Proj.basicOpen 𝒜 (X 1))` using
  -- `fromOfGlobalSections_morphismRestrict`. The restriction of `onePt.left`
  -- to `basicOpen 𝒜 (X 1)` is `(isoOfEq).hom ≫ toBasicOpenOfGlobalSections`.
  -- Unfold `toBasicOpenOfGlobalSections` to expose the `IsLocalization.map`
  -- underlying ring map.
  rw [Proj.fromOfGlobalSections_morphismRestrict ...]
  unfold Proj.toBasicOpenOfGlobalSections
  -- Step 6: `IsLocalization.map _ (evalIntoGlobal v) _` sends
  -- `[X_0 / X_1] ↦ (evalIntoGlobal v X_0) / (evalIntoGlobal v X_1)`.
  -- With `v = (1, 1)`, both numerator and denominator evaluate to
  -- `(ΓSpecIso k̄).inv.hom 1`, giving the quotient `1`.
  -- Discharge via `IsLocalization.map_mk'` (or similar) + `MvPolynomial.eval_X`.
  simp [IsLocalization.map_mk', Away.isLocalizationElem, Away.mk,
    HomogeneousLocalization.algebraMap_apply, MvPolynomial.eval_X, ...]
```

Stages 4 and 5 are the bulk of the LOC (each ~15-25 lines, including
the eqToHom shuffles between `Γ(Proj 𝒜, basicOpen)`, `Γ(basicOpen, ⊤)`,
and `Away 𝒜 f` views). Stage 6 is short (~5-10 lines) provided the
`IsLocalization.map` simp set fires.

**Alternative (avoid Section 2 refactor)**: keep
`iotaGm_onePt_chart1_factor` as `∃` and use `IsOpenImmersion.lift_uniq`
to derive `r_1 = IsOpenImmersion.lift (awayι _) onePt.left (iotaGm_onePt_chart1_range)`.
Adds ~5 LOC up front (the `lift_uniq` rewrite) but requires
`iotaGm_onePt_chart1_range` to be **extracted as its own lemma** from
the current `iotaGm_onePt_chart1_factor` body — which is the same
refactor as Section 2 step 1 in disguise. So both routes converge.

## Section 5: STRICT verdict

**PROCEED with iter-188 recipe corrected per Section 4 — but FIRST do
the Section 2 refactor.**

The iter-188 recipe (`cancel_mono` on `awayι` + `IsOpenImmersion.lift_app`
chain) is structurally sound. It failed not because of a recipe defect
but because:

1. `iotaGm_onePt_chart1_factor` packages `r_1` in an `∃`, hiding the
   `IsOpenImmersion.lift` form that `lift_app` needs.
2. Mathlib at b80f227 lacks a direct simp lemma for
   `(Proj.awayι _).appIso ⊤` ↔ `basicOpenIsoAway`. The 6-step recipe
   compresses ~25-30 LOC of `basicOpenIsoSpec.inv` / `basicOpenToSpec_app_top`
   chase into a single "Step 1" — which is what blew the iter-188 attempt budget.

Neither blocker is Mathlib-upstream-blocking; both can be resolved
**project-side** in iter-190 with the refactor + helper recipe described
above.

The **structural issue** (3 iters lost rediscovering the recipe) is
real and worth surfacing: the iter-186 / 187 / 188 cycle would have been
shorter if iter-186 had landed `iotaGm_onePt_chart1_factor` as a `def`
plus paired lemmas from the start. **For future** Lane E / Lane F / etc.
helpers built on `IsOpenImmersion.lift`, recommend the def-plus-lemma
pattern as a project convention.

## Must-fix-this-iter

- `iotaGm_onePt_chart1_factor` (file
  `AlgebraicJacobian/AbelianVarietyRigidity.lean:106-163`) should be
  refactored to a `noncomputable def iotaGm_r_1` + `lemma iotaGm_r_1_fac`
  + extracted range-containment lemma. The `∃` packaging is a
  divergent-with-cost vs the Mathlib `IsOpenImmersion.lift` idiom:
  consumers cannot directly invoke `lift_app` without re-deriving the
  range proof via `cancel_mono`. Cost: ~30-40 LOC of redundant
  plumbing per consumer (already paid once in iter-188 attempt 2).

## Informational

- `(Proj.awayι _).appIso ⊤` lacks a direct simp lemma in Mathlib at
  b80f227. A small (~5-10 LOC) Mathlib PR adding
  `Proj.awayι_appIso_top` (or `Proj.awayι_app_basicOpen` for the
  point-direction analogue) — derived from `basicOpenToSpec_app_top`
  plus the definition of `awayι` — would generalize this work. Not
  blocking iter-190; flag as a downstream optimization once
  Lane E lands.
- The `lift_app` vs `morphismRestrict` routes are
  divergent-equivalent. Either reaches `r_1.appTop isLocElem = 1`.
  `lift_app` is closer to the open-immersion universal property
  vocabulary; `morphismRestrict` (via `fromOfGlobalSections_morphismRestrict`)
  is closer to the `onePt.left = fromOfGlobalSections` shape. Project's
  iter-186 choice of `lift_app` is fine.

## Persistent file
- `analogies/lane-e-projappiso.md` — design-rationale captured for future iters.

Overall verdict: PROCEED with iter-188 recipe corrected per Section 4 — but first refactor `iotaGm_onePt_chart1_factor` to expose `r_1` as a `def` (Section 2). Realistic helper budget ~60-80 LOC; the directive's 30-50 LOC target is optimistic given the `appIso` plumbing required.
