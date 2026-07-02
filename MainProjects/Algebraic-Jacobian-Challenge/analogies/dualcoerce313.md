# Analogy: punching through `ModuleCat.Hom.hom'` to fire `PresheafOfModules.naturality_apply`

## Mode
api-alignment

## Slug
dualcoerce313

## Iteration
313

## Question
The lone residual sorry in BOTH `sliceDualTransport.left_inv` (L860) and `.right_inv` (L920) is a
`φ`/`ψ`-naturality crux whose `M₁.map g z` is buried behind the `ModuleCat.Hom.hom'` field
projection + an `AddEquiv.refl.toLinearEquiv` collapse-leg, so `naturality_apply` won't fire by
name. What is Mathlib's idiom to expose such a `ModuleCat`/`PresheafOfModules` map application so
`PresheafOfModules.naturality_apply` applies?

## Project artifact(s)
- `…/DualInverse.lean`:920 — `right_inv` residual sorry (goal carries `.hom'`).
- `…/DualInverse.lean`:860 — `left_inv` residual sorry (mirror).

## TL;DR (the recipe — VERIFIED)

**You do NOT manually `change`/`conv` to expose `M₁.map g`.** `PresheafOfModules.naturality_apply`
is stated in **`ConcreteCategory.hom` form**, which is *reducibly defeq* to the raw `.hom'` field.
So `erw` matches it against the `.hom'`-spelled goal **up to defeq** and unifies the
`AddEquiv.refl`-collapse-legs + `M.val.map` scaffolding with `M₁.map ?g` automatically, emitting
`?g : W ⟶ A` as a fresh goal. The one prerequisite is to first peel the outer
`(restrictScalars _).map (ψ.app A)` wrapper with `ModuleCat.restrictScalars.map_apply` (also
`ConcreteCategory.hom` form, so also `erw`-able).

**right_inv (L920) — one shot, VERIFIED to fire:**
```lean
erw [ModuleCat.restrictScalars.map_apply, PresheafOfModules.naturality_apply]
```
Leaves exactly two clean goals:
1. main: `(Y.presheaf.map (eqToHom ⋯)).hom ((restr 𝟙_).map ?g ((ψ.app W).hom z)) = (ψ.app W).hom z`
   — the unit `M₂ = 𝟙_` cancellation (fact (b): `Y.presheaf.map (eqToHom) ∘ (𝟙_).map g = id`,
   a thin-poset / `eqToHom_trans` `Subsingleton.elim` collapse).
2. `?g : W ⟶ op (Over.mk (homOfLE ⋯))` — the thin-poset slice morphism. Supply it CHEAPLY
   (an `Over.homMk … |>.op` on the poset, mirroring the CLOSED template at L143); do NOT build it
   with `(by subsingleton)` / `hPW ▸ le_rfl` inside a rewrite term — that TIMED OUT (800k heartbeats).

## Decisions identified

### Decision: how to fire a `ConcreteCategory.hom`-stated lemma at a `.hom'`-spelled goal

- **Root cause (verified).** Current Mathlib `ModuleCat.Hom` has a single raw field
  `hom' : ↑M →ₗ[R] ↑N`; `ModuleCat.Hom.hom f` is defined as `ConcreteCategory.hom f`, and for
  `ModuleCat` the `ConcreteCategory.hom` field literally *is* `.hom'`. So `f.hom'`,
  `ConcreteCategory.hom f`, and `ModuleCat.Hom.hom f` are all **reducibly defeq but distinct head
  constants**. After the prior `simp only` / `erw [εInv_apply]` / functor-`.map`/`ofHom` unfolding,
  the goal head is the raw `.hom'`. `rw`/`simp only` match heads syntactically → fail
  ("pattern not found" / "unused"). Reproduced at L920.
- **The discriminator (verified, new this iter).** `erw` bridges the defeq gap **only for lemmas
  whose LHS is in `ConcreteCategory.hom` form**, NOT for lemmas in `ModuleCat.Hom.hom` form:
  - `ModuleCat.restrictScalars.map_apply` (LHS = `ConcreteCategory.hom ((restrictScalars f).map g) x`)
    → `erw` FIRES. ✓ (both sorries)
  - `PresheafOfModules.naturality_apply` (LHS = `ConcreteCategory.hom (f.app Y) (ConcreteCategory.hom
    (M₁.map g) x)`) → `erw` FIRES. ✓ (right_inv)
  - `ConcreteCategory.comp_apply`, `ConcreteCategory.id_apply` (LHS in `ConcreteCategory.hom`) →
    `erw`-able in principle, but did NOT match the *collapse-leg composite* here (it is `ofHom … ≫
    ofHom …`, head still `.hom'`, see left_inv note).
  - `ModuleCat.hom_comp`, `ModuleCat.hom_ofHom` (LHS = `ModuleCat.Hom.hom (f ≫ g)` etc.) →
    `erw` FAILS ("did not find `ModuleCat.Hom.hom (?f ≫ ?g)`"). The extra `ModuleCat.Hom.hom`
    indirection is one unfold too deep for `erw`'s pattern matcher to bridge. ✗
- **Why this beats the directive's feared `change`/`conv`.** The defeq unification that a manual
  `change` would have to spell out by hand (collapse-legs ≡ `M₁.map g`) is performed *for free* by
  `erw [naturality_apply]`; the slice morphism `g` it cannot guess is handed back as a goal.
- **Gap**: divergent-equivalent (tactic idiom). Mathlib's own `SheafOfModules`/`PresheafOfModules`
  pushforward-naturality lemmas (`SheafOfModules.pushforwardCongr₂_*_app_val_app_hom_apply`,
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.PushforwardContinuous`) mix `.hom'` and
  `ConcreteCategory.hom`/`ModuleCat.Hom.hom` exactly like this goal — the spelling churn is intrinsic
  to Mathlib's API, not a project defect.
- **Verdict**: PROCEED (use the `erw [restrictScalars.map_apply, naturality_apply]` recipe).

### Decision: why left_inv (L860) needs one MORE reduction than right_inv

- **Verified asymmetry.** On left_inv the same `erw [restrictScalars.map_apply,
  PresheafOfModules.naturality_apply]` peels `φ.app A` (restrictScalars leg fires) but
  `naturality_apply` does NOT fire ("pattern `ConcreteCategory.hom (M₁.map ?g) ?x` not found").
  Reason: there `M₁ = restr M.val` (NO pushforward), so `M₁.map g` unfolds to a *bare* `M.val.map`
  with **no** `restrictScalars`/`β` collapse-legs — whereas the goal's inner argument still carries
  the `AddEquiv.refl … .toLinearEquiv.symm ≫ …` collapse legs (they come from the dual's pushforward
  construction). In right_inv `M₁ = restr (pushforward β M.val)`, whose `.map g` *does* unfold to
  `collapse ∘ M.val.map`, so the defeq matched. Net: the collapse-leg pair is **absorbed by defeq in
  right_inv but is genuinely extra in left_inv**.
- **Fix for left_inv.** Clear the genuine identity collapse-legs first (`ofHom α.symm ≫ ofHom α`
  with `α = (AddEquiv.refl _).toLinearEquiv` = `LinearEquiv.refl`, composite = `𝟙`), then
  `erw [naturality_apply]` against the bare `M.val.map`. Also the outer `εrel⁻¹` there is still in
  `RingEquiv.ofBijective …·.symm` form (not yet a presheaf map) — convert it with the existing
  `presheafMap_ofBijective_symm` (file L238) as the L856 comment already anticipates; this does not
  block `naturality_apply` (it acts on the inner `φ.app A`) but is needed for the final close.
- **Verdict**: PROCEED.

## Recommendation
Replace the L920 (`right_inv`) sorry with
```lean
erw [ModuleCat.restrictScalars.map_apply, PresheafOfModules.naturality_apply]
```
then discharge (1) the unit `(Y.presheaf.map eqToHom) ∘ (𝟙_).map g = id` cancellation
(thin-poset `Subsingleton.elim` / `eqToHom`-collapse) and (2) the `?g : W ⟶ op (Over.mk (homOfLE ⋯))`
slice morphism, built CHEAPLY as an `Over.homMk … |>.op` (mirror L143), NOT via heavy
`subsingleton`/`▸` inside a rewrite (that timed out). For L860 (`left_inv`): same idiom, but first
collapse the residual `ofHom refl.symm ≫ ofHom refl` identity legs and convert the outer
`εrel⁻¹` via `presheafMap_ofBijective_symm`, then `erw [ModuleCat.restrictScalars.map_apply,
PresheafOfModules.naturality_apply]` fires identically. The governing rule for the whole DUAL
file: **lemmas stated with `ConcreteCategory.hom` bridge the `.hom'` field via `erw`; lemmas stated
with `ModuleCat.Hom.hom` (`hom_comp`, `hom_ofHom`) do NOT — prefer the `ConcreteCategory.*` /
element-form (`*_apply`) lemmas.**
