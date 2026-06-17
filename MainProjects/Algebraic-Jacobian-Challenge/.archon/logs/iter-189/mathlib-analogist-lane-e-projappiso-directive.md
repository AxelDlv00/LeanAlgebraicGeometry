# Mathlib Analogist Directive

## Slug
lane-e-projappiso

## Mode
api-alignment

## Context

Lane E (`AbelianVarietyRigidity.lean`) — closing
`iotaGm_chart1_composition_isOpenImmersion` requires computing
`r_1.appTop ((ΓSpecIso _).inv isLocElem)` in the situation:

- `𝒜 = ℙ¹` graded ring (= `MvPolynomial (Fin 2) kbar`-style graded
  structure used by `Proj 𝒜` for the projective line).
- `Proj.awayι (X 1) : Spec (Away 𝒜 (X 1)) ⟶ Proj 𝒜` — chart-1 affine
  open immersion (basic open `D₊(X 1) ⊆ Proj 𝒜`).
- `onePt : Spec kbar ⟶ Proj 𝒜` factored as
  `onePt.left = r_1 ≫ Proj.awayι (X 1) _ _` via
  `h_r_1 : r_1 ≫ Proj.awayι (X 1) _ _ = onePt.left`.
- `r_1 : Spec kbar ⟶ Spec (Away 𝒜 (X 1))`.
- `isLocElem : Γ(Proj 𝒜, ⊤) = kbar` (the structure-sheaf top global
  section, identified with `1 ∈ kbar`).

**Goal (verbatim Lane E pinch point)**: prove
`r_1.appTop ((ΓSpecIso _).inv isLocElem) = (ΓSpecIso k̄).inv 1`.

**The blocker iter-188 verified (HARD)**: 3 attempts failed.

Iter-188 attempted (and FAILED):

1. **`simp` default** advances `comp_appTop` to a 6-factor product
   chain but does not close.
2. **`cancel_mono` rewrite to explicit lift form**
   `r_1 = IsOpenImmersion.lift (Proj.awayι _) onePt.left h_range`
   requires re-establishing the `h_range` factorization proof
   (already in `iotaGm_onePt_chart1_factor` at lines 106-163; code
   duplication).
3. **`MvPolynomial.ringHom_ext`** after `CommRingCat.hom_ext` does
   not unify — the LHS chain has many `.c.app` factors that don't
   directly expose the `MvPolynomial Unit kbar →+* GmRing kbar` ring
   map.

**Critical insight from iter-188 forensics**:
`(Proj.awayι _).appTop : Γ(Proj 𝒜, ⊤) → Γ(Spec(Away 𝒜 (X 1)), ⊤) =
Away 𝒜 (X 1)` has image **equal to the degree-0 part = `kbar`**.
But `isLocElem = X 0 / X 1` is **NOT** in that image (it's the
chart coordinate, not a scalar). So `h_r_1`-via-cancellation
`(Proj.awayι).appTop ≫ r_1.appTop = onePt.left.appTop` cannot
evaluate `r_1.appTop (isLocElem)` directly.

The substantive computation likely requires
`IsOpenImmersion.lift_app` applied to `f = Proj.awayι (X 1)`,
`V = ⊤`:

```
(IsOpenImmersion.lift f g H).app V
  = (f.appIso V).inv ≫ g.app (f ''ᵁ V) ≫ presheaf.map (eqToHom _).op
```

Specifically `(Proj.awayι _).appIso ⊤ : Γ(Spec(Away 𝒜 (X 1)), ⊤) ≅
Γ(Proj 𝒜, D₊(X 1))`. The `appIso` hom maps `isLocElem ↦ [X 0 / X 1]
∈ Γ(Proj 𝒜, D₊(X 1))`, and `onePt.left.app D₊(X 1)` applied to
`[X 0 / X 1]` evaluates to `v(X 0) / v(X 1)` with `v = (1, 1)`
(the canonical k-rational point of ℙ¹), giving `1`.

## Question (api-alignment mode)

Look at Mathlib at b80f227 (project is pinned to this commit) and
report:

1. **Does Mathlib have `(Proj.awayι (X i)).appIso ⊤` accessible as
   a usable identity for downstream computation?** Specifically, is
   the `appIso` API on `IsOpenImmersion` (in
   `Mathlib.AlgebraicGeometry.Morphisms.OpenImmersion` and downstream
   files) the canonical idiom for evaluating an
   `IsOpenImmersion.lift`-form morphism's `appTop` on a global
   section?

2. **What is the cleanest Mathlib-aligned recipe** for the
   computation `r_1.appTop (isLocElem) = 1`? Specifically:
   - Is there an existing `IsOpenImmersion.lift_appTop` lemma (or
     equivalently, `IsOpenImmersion.lift_app` specialized at `V = ⊤`)?
   - Does `Proj.appIso` of `awayι` admit a `simp`-friendly form that
     unfolds `(Proj.awayι (X 1)).appIso ⊤` into a concrete `HomogeneousLocalization`-flavoured
     iso?
   - Is the evaluation `(onePt.left.app D₊(X 1)) ([X 0 / X 1]) = 1`
     directly computable via `Proj.fromOfGlobalSections` machinery,
     or does it require a manual `MvPolynomial.eval₂Hom`-style chase?

3. **Dead ends already ruled out (do NOT recommend)**:
   - `Spec.preimage` on `r_1` — `r_1` is opaque modulo lift
     characterization; gives only composite ring map, not individual
     factors.
   - Recomputing `r_1.appTop` from `h_r_1` alone — image-mismatch on
     `(Proj.awayι).appTop` makes this structurally impossible.
   - `MvPolynomial.ringHom_ext` after `CommRingCat.hom_ext` —
     iter-188 attempt 3 verified does not unify.

4. **Recommend a project-side helper signature** `r_1_appTop_isLocElem_eq_one`
   that the iter-190 prover could close in ~30-50 LOC. Name the
   specific Mathlib lemmas the helper would call (verified at
   b80f227 only — do not list lemmas you cannot confirm with
   `lean_local_search` / `lean_loogle`).

5. **Is there a structural API mismatch in the project's path?** The
   Lane E recipe has been documented since iter-186 and never tested
   until iter-188. Iter-188 verified the documented recipe (6-step
   `r_1_appTop_isLocElem_eq_one` helper via cancel_mono on Proj.awayι
   + IsOpenImmersion.lift_appTop chain) is structurally impossible
   as written. Is there a Mathlib-aligned alternative shape
   (e.g. evaluation via `Spec.preimage_appIso` or `Proj.glueData.U_appIso`
   per-open-evaluation) that would have worked from the start?

## Project-side declarations to consider

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` around L252-L500
  (the `iotaGm_chart1_composition_isOpenImmersion` body).
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean` — `onePt` definition
  + characterization.
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — `ProjectiveLineBar`
  ambient definitions.

## Expected report sections

- Section 1: Mathlib `Proj.appIso` / `IsOpenImmersion.lift_app` API survey at b80f227.
- Section 2: Project-side path that aligns with Mathlib.
- Section 3: Verified Mathlib lemmas to call (with `lean_local_search` / `lean_loogle` corroboration).
- Section 4: Concrete `r_1_appTop_isLocElem_eq_one` helper signature recommendation.
- Section 5: STRICT verdict — PROCEED with this iter-188 recipe corrected per Section 4, or ALIGN WITH MATHLIB via structural pivot, or BLOCKED-MATHLIB-UPSTREAM (recommend Mathlib PR).
