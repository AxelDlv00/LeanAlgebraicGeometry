# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Iter-197 Lane E — three new helpers + structural advance on consumer #1

### `Proj.basicOpenIsoSpec_inv_app_top` (NEW, axiom-clean)

**Statement**: `(Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv.app ⊤ = (Proj.basicOpen 𝒜 f).topIso.hom ≫ (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫ (Scheme.ΓSpecIso _).inv`

#### Attempt 1
- **Approach**: Convert `basicOpenIsoSpec.inv` to `inv basicOpenIsoSpec.hom` via `IsIso.inv_eq_of_hom_inv_id`, then use `Scheme.Hom.inv_appTop` and substitute `basicOpenIsoSpec_hom` + `basicOpenToSpec_app_top`.
- **Result**: FAILED — motive issues with `IsIso` typeclass dependent on the term being rewritten.

#### Attempt 2 (RESOLVED)
- **Approach**: `cancel_mono` on `(basicOpenIsoSpec.hom).appTop` (iso ⟹ mono). After cancellation, both sides reduce to `𝟙 Γ((basicOpen 𝒜 f).toScheme, ⊤)` via three sequential `Iso.{hom_inv_id,inv_hom_id}_assoc` applications.
- **Result**: RESOLVED (~15 LOC).
- **Key insight**: `Scheme.Hom.comp_appTop` reverses composition order; pair with `(basicOpenIsoSpec).hom_inv_id` (not `inv_hom_id`) to get the `(.hom ≫ .inv).appTop = 𝟙.appTop = 𝟙` chain right.

### `Proj.awayι_app_basicOpen` (NEW, axiom-clean)

**Statement**: `(Proj.awayι 𝒜 f f_deg hm).app (Proj.basicOpen 𝒜 f) = (Proj.basicOpenIsoAway 𝒜 f f_deg hm).inv ≫ (Scheme.ΓSpecIso _).inv ≫ (Spec _).presheaf.map (eqToHom (preimage = ⊤)).op`

This is the **Proj-side port of `IsAffineOpen.fromSpec_app_self`** (`Mathlib/AlgebraicGeometry/AffineScheme.lean:560-564`).

#### Attempt 1
- **Approach**: `rw [Proj.awayι_eq_specMap_fromSpec]` then evaluate via `comp_app` + `fromSpec_app_self`.
- **Result**: FAILED — `rw` of `Proj.awayι` triggers a **motive-not-type-correct** failure because the goal's `app` codomain depends on the value of `awayι` (the eqToHom proof references `awayι ⁻¹ᵁ basicOpen = ⊤`).

#### Attempt 2
- **Approach**: Use `conv_lhs => rw [...]` to restrict the rewrite to LHS only.
- **Result**: FAILED — the LHS still has `Scheme.Hom.app awayι _` whose TYPE depends on `awayι`.

#### Attempt 3
- **Approach**: Switch to `appLE` form to avoid dependent-type motive issues.
- **Result**: FAILED — `appLE U V e`'s `e : V ≤ f ⁻¹ᵁ U` still has `f` in its type.

#### Attempt 4 (RESOLVED)
- **Approach**: Use `change` (definitional unfolding) to replace `Proj.awayι 𝒜 f f_deg hm` with `(Proj.basicOpenIsoSpec 𝒜 f f_deg hm).inv ≫ (Proj.basicOpen 𝒜 f).ι` (this IS the definition in Mathlib's `Proj.awayι`, see `ProjectiveSpectrum/Basic.lean:189-190`). Then `Scheme.Hom.comp_app` + `Scheme.Opens.ι_app_self` + `Scheme.Hom.app_eq` on `ι_preimage_self` + our `Proj.basicOpenIsoSpec_inv_app_top` helper. Close the eqToHom cascade by `aesop_cat`.
- **Result**: RESOLVED (~10 LOC body).
- **Key insight**: `change` sidesteps the motive issue because it works up to defeq, not equality rewriting.

### `Proj.awayι_appIso_top_inv` (NEW, axiom-clean)

**Statement**: `((Proj.awayι 𝒜 f f_deg hm).appIso ⊤).inv = (Scheme.ΓSpecIso _).hom ≫ (Proj.basicOpenIsoAway 𝒜 f f_deg hm).hom ≫ (Proj 𝒜).presheaf.map (eqToHom (image_top_eq_opensRange.trans opensRange_awayι)).op`

#### Attempt 1
- **Approach**: Rewrite `appIso.inv` via `Iso.eq_inv_comp` after computing `.hom` via `appIso_hom`.
- **Result**: FAILED — `Iso.eq_inv_comp` pattern doesn't match `α.inv = expr`.

#### Attempt 2 (RESOLVED)
- **Approach**: Use `Iso.comp_hom_eq_id` (`f ≫ α.hom = 𝟙 ↔ f = α.inv`). Apply `Eq.symm`, then `.mp`, then `appIso_hom` + `Scheme.Hom.app_eq` (to bridge `awayι ''ᵁ ⊤` and `basicOpen 𝒜 f`) + `Proj.awayι_app_basicOpen`. Close residual `eqToHom` cascade via `slice_lhs` + `Functor.map_comp` + `eqToHom_trans`, then `basicOpenIsoAway.hom_inv_id_assoc` and `Iso.hom_inv_id`.
- **Result**: RESOLVED (~22 LOC body).
- **Key insight**: After the rewrites, the goal has 4 `presheaf.map(eqToHom).op` factors (2 from Proj-side, 2 from Spec-side); combine each pair into a single `eqToHom_refl = 𝟙` via `slice_lhs`. Then the iso pairs cancel by chained `hom_inv_id_assoc`.

### `kbarChart1Ring_specMap_fac` (line ~378, PARTIAL — sorry remains at line 432)

**Status**: structural advance landed; substantive residual reduced from `Proj.appIso` evaluation (iter-188—194 STUCK) to `onePt.left.app(D₊(X_1))` evaluation (a strictly smaller, project-side residual).

#### Attempt iter-197
- **Approach**: After `rw [← iotaGm_r_1_fac]; congr 1; refine ext_of_isAffine ?_`, the goal becomes `Spec.map(kbarChart1Ring).appTop = iotaGm_r_1.appTop`. Apply `unfold iotaGm_r_1; simp only [Scheme.Hom.appTop]; rw [IsOpenImmersion.lift_app, Proj.awayι_appIso_top_inv]`. This substitutes our new helper for the `(awayι.appIso ⊤).inv` factor.
- **Result**: PARTIAL — the `Proj.appIso` evaluation (iter-188—194 substantive blocker) is now CLOSED via the helper substitution. The remaining residual is a ring-map equation involving `onePt.left.app(awayι ''ᵁ ⊤) = onePt.left.app(D₊(X_1))`, which requires substantive project-side reasoning about `Proj.fromOfGlobalSections.app` (`onePt.left` is constructed as `Proj.fromOfGlobalSections evalIntoGlobal _` per the project's `Genus0BaseObjects/Points.lean`).
- **Next step**: Apply `Proj.fromOfGlobalSections_morphismRestrict` (Mathlib `ProjectiveSpectrum/Basic.lean:493`) or `Proj.fromOfGlobalSections_toSpecZero` (line 512) plus the project-specific `pointOfVec` evaluation. Estimated ~50-100 LOC.

### `iotaGm_chart1_appIso_eval` (line ~542, UNTOUCHED iter-197 — sorry remains at line ~640)

Shares substantive content with `kbarChart1Ring_specMap_fac`'s residual (per the iter-194 prover note in the body). The same helper-substitution strategy applies, but the residual evaluation differs slightly because the consumer has `pullbackSpecIso` and other iso-chain factors above the `Proj.appIso` step.

## Summary

**Sorry count**: 3 → 3 (NO net closure; structural advance via three new axiom-clean helpers).

**Sorries closed**: 0.

**Sorries with structural advance**:
- `kbarChart1Ring_specMap_fac` (L432): residual reduced from "Proj.appIso evaluation" to "onePt.left.app(D₊(X_1)) evaluation". The substituting of `Proj.awayι_appIso_top_inv` is real progress; the chain after it is strictly smaller in surface.

**Sorries untouched**:
- `iotaGm_chart1_appIso_eval` (L640): same structural advance available via the new helpers; not applied iter-197 due to time/context budget.
- `genusZero_curve_iso_P1` (L1002): standing deferral (RR bridge, gated).

**New axiom-clean helpers** (3):
1. `Proj.basicOpenIsoSpec_inv_app_top` — closed form for `basicOpenIsoSpec.inv.app ⊤`.
2. `Proj.awayι_app_basicOpen` — Proj-side port of `IsAffineOpen.fromSpec_app_self`.
3. `Proj.awayι_appIso_top_inv` — closed form for `((awayι).appIso ⊤).inv`.

All three follow the iter-195 mathlib-analogist recipe `lane-e-proj-appiso-pivot` (ANALOGUE_FOUND verdict). The blueprint sub-lemmas `lem:basicOpenIsoSpec_inv_app_top`, `lem:awayi_app_basicOpen`, `lem:awayi_appIso_top_inv_apply_isLocElem` are now formally proven (modulo `\lean{...}` hint name matches — see blueprint cross-ref below).

**Blueprint cross-ref**: the blueprint's third helper is named `lem:awayi_appIso_top_inv_apply_isLocElem` (point-value form). I instead built the morphism-level form `Proj.awayι_appIso_top_inv` (cleaner; produces the same point-value evaluation via `congr` on the resulting equation). The blueprint's `\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv_apply_isLocElem}` hint should be updated to `\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv}` (review-agent task; provers don't edit blueprint).

## Why I stopped

**Partial progress**.

Closed 0 sorries (HARD BAR missed). Built 3 new axiom-clean helpers that mirror the iter-195 analogist recipe, plus applied 2 of them to consumer #1 (`kbarChart1Ring_specMap_fac`) to reduce its substantive residual from "Proj.appIso evaluation" (iter-188—194 STUCK) to "onePt.left.app(D₊(X_1)) evaluation" (strictly smaller, project-side).

Stopped at the project-specific `Proj.fromOfGlobalSections.app` evaluation. This requires reasoning about how `onePt.left = Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) (evalIntoGlobal ![1, 1]) _` evaluates its `app` on the open `D₊(X_1)`. The Mathlib lemma `Proj.fromOfGlobalSections_morphismRestrict` gives the morphism-level restriction, but we need the `app`-level evaluation. The project's `Points.lean` has `Proj.fromOfGlobalSections_toSpecZero` but not the analogous `_app_basicOpen` evaluator. Building it is ~50-100 LOC of project-side work, requires understanding the `evalIntoGlobal` / `pointOfVec` infrastructure. Out of scope for this helper-building iter.

Consumer #2 (`iotaGm_chart1_appIso_eval`) also reachable via the same helper-substitution; not attempted iter-197 due to time budget (consumer #1's reduction already demonstrates the structural progress).

**HARD BAR not met**, but the underlying blocker (Mathlib-side `Proj.appIso` evaluation, the 9-iter STUCK signal) is now FORMALLY RESOLVED via the new helpers. The remaining residual is project-side, with a clear path forward.

**Build status**: GREEN. 3 sorries (same count as iter-196 entry). 0 axioms introduced. Real progress: 3 new helpers + structural advance on consumer #1.
