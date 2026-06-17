# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (4, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `PresheafOfModules.stalkLinearMap` — the `R.stalk x`-linear stalk map of a
    `PresheafOfModules` morphism (new section `StalkLinearMap`).
  - `PresheafOfModules.stalkLinearMap_germ` — its germ characterisation.
  - `PresheafOfModules.stalkLinearMap_bijective_of_isIso` — bijectivity from Ab-stalk iso.
  - `PresheafOfModules.stalkLinearEquivOfIsIso` — bundled `≃ₗ[R.stalk x]` version.
- **Declarations blocked (0 new):** the lone target `isLocallyInjective_whiskerLeft_of_W`
  (L411) remains a typed `sorry`; its body comment now carries the corrected decomposition.
- **sorry count: 4 → 4** (unchanged): L411 `isLocallyInjective_whiskerLeft_of_W` (target,
  route-(e) residual), L901 `tensorObj_restrict_iso`, L1009 `exists_tensorObj_inverse`,
  L1049 `addCommGroup_via_tensorObj` (all three off-path, untouched). **No new sorries.**

## Step 0 — make-or-break existence check (RESOLVED: negative, must build)
Searched Mathlib for an off-the-shelf `MorphismProperty.IsMonoidal` on the module
sheafification localizer / monoidal `SheafOfModules` / `IsLocalization` glue.
- `Mathlib/CategoryTheory/Sites/Monoidal.lean`: `(J.W (A := A)).IsMonoidal` exists but only
  for a **fixed** monoidal-closed `A` (`Cᵒᵖ ⥤ A`), via internal-hom adjunction — needs
  `MonoidalClosed A`. **Inapplicable**: `PresheafOfModules R` (varying ring) is not `Cᵒᵖ ⥤ A`,
  and `MonoidalClosed (PresheafOfModules R)` is verified-absent.
- `Mathlib/CategoryTheory/Sites/Point/IsMonoidalW.lean`: `(J.W (A := A)).IsMonoidal` via enough
  points — again fixed `A`. **Inapplicable** for the same reason; it IS the technique to port.
- No monoidal `SheafOfModules`; module-sheaf `Localization.lean` has no `IsMonoidal`.
- **Verdict:** no collapse available — `(J.W).IsMonoidal` for the module localizer must be built.

## KEY CORRECTION to PROGRESS.md / recipe (high value for planner)
PROGRESS.md and `analogies/ts-monoidalloc214.md` state "no `PresheafOfModules`
stalk/fiber/point infra (only `…/Presheaf/ColimitFunctor.lean`)". **This is WRONG.**
`Mathlib/Algebra/Category/ModuleCat/Stalk.lean` (Andrew Yang, 2026) already supplies, for
`X : TopCat`, `R : X.Presheaf CommRingCat`, `M : PresheafOfModules (R ⋙ forget₂ _ _)`:
- `instance : Module (R.stalk x) ↑(TopCat.Presheaf.stalk M.presheaf x)` (the stalk module);
- `PresheafOfModules.germ_smul` (germ / scalar compatibility).
Plus `Presheaf/ColimitFunctor.lean` has `colimitFunctor : PresheafOfModules R ⥤ ModuleCat cR.pt`.
This substantially de-risks ingredient (d.1): the module stalk does NOT need to be built.

## isLocallyInjective_whiskerLeft_of_W (L411, target) — PARTIAL (d.1 core built)
- **Approach:** route (e) stalkwise. A `J.W`-morphism `g` is a stalkwise iso, so
  `(F ◁ g)_x = id_{F_x} ⊗_{R_x} g_x` is an iso for arbitrary `F` (flatness-free). Needs
  (d.1) module-`J.W` ⟺ stalkwise-iso, and (d.2) stalk ⊗ commutation.
- **Built this iter (d.1 core, axiom-clean):** `stalkLinearMap` (germ-chase via
  `germ_exist` + `germ_res_apply` + `germ_smul` + `stalkFunctor_map_germ_apply` +
  `toPresheaf_map_app_apply`), `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`,
  `stalkLinearEquivOfIsIso`. These package the R_x-linear stalk equivalence the
  `id ⊗ g_x` step consumes.
- **Two residual gaps to close the sorry (precise):**
  1. **(d.1-bridge)** For the topological site, `(Opens.grothendieckTopology X).W
     ((toPresheaf _).map f) ↔ ∀ x, IsIso ((stalkFunctor Ab x).map ((toPresheaf _).map f))`.
     Routes: (a) `HasEnoughPoints (Opens.grothendieckTopology X)` (EXISTS:
     `Mathlib/Topology/Sheaves/Points.lean:67`) + `ObjectProperty.…W_iff`
     (`Sites/Point/Conservative.lean:109`) — but `presheafFiber ≅ TopCat.Presheaf.stalk`
     is the Mathlib TODO (Points.lean L18-22), still absent; (b) `WEqualsLocallyBijective`
     + `Topology/Sheaves`: `locally_surjective_iff_surjective_on_stalks` (LocallySurjective.lean:80)
     and `app_injective_iff_stalkFunctor_map_injective` / sheaf-level
     `isIso_iff_stalkFunctor_map_iso` (Stalks.lean:512/652), bridging the site's
     `Presheaf.IsLocallyInjective/Surjective J` to the topological `TopCat.Presheaf` versions.
     Est. ~80–150 LOC.
  2. **(d.2)** Natural iso `(F ⊗ᵖ_R M).presheaf.stalk x ≅ F_x ⊗_{R.stalk x} M_x` identifying
     `(F ◁ g)_x` with `LinearMap.lTensor F_x (stalkLinearMap g x)`. "Tensor commutes with the
     filtered colimit defining the stalk" over the **varying** ring — genuinely Mathlib-absent,
     the largest piece (~150–250 LOC). Once it lands: `stalkLinearMap_bijective_of_isIso` +
     `LinearEquiv.lTensor` finish flatness-free.
- **Restructure required:** this lemma is stated over a GENERAL site `C` (no stalks exist there).
  It must be **specialised to `C = Opens X`** (or add `[HasEnoughPoints J]` + topological
  hypotheses). The decl is **UNPROTECTED** (not in `archon-protected.yaml`), and the only
  consumer chain (`W_whiskerLeft/Right_of_W` → `tensorObj_assoc_iso`) already runs over
  `Opens.grothendieckTopology X`, so specialising is compatible. NB under route (e) the
  hand-assembled `tensorObj_assoc_iso` is to be superseded by `LocalizedMonoidal` anyway.
- **Dead ends (do NOT retry):** section-level injectivity-alone (needs Tor₁/flatness);
  `MonoidalClosed (PresheafOfModules R)` route (absent); the fixed-base `Sites/Monoidal.lean`
  / `IsMonoidalW.lean` instances (varying ring ≠ `Cᵒᵖ ⥤ A`).

## Informal agent
Called `archon-informal-agent.py --provider auto` (MOONSHOT key set) → **HTTP 401 Invalid
Authentication** (key invalid). Treated as unavailable; proceeded on on-disk Mathlib analysis.

## Why I stopped
**Partial progress.** 4 axiom-clean declarations added (the d.1 R_x-linear-stalk-map core:
`stalkLinearMap` + 3 companions), verified `{propext, Classical.choice, Quot.sound}`. The
target sorry is NOT closed: it requires the (d.1-bridge) site-`W`↔stalk characterisation and
(d.2) stalk-⊗ commutation over a varying ring — multi-iteration infrastructure (d.2 genuinely
Mathlib-absent). Per mathlib-build mode this is expected incremental progress, NOT the PROGRESS.md
"Reversal"/bottom-out trigger (a route exists; the module stalk turned out to be present in
Mathlib, de-risking d.1). I did not attempt d.1-bridge/d.2 to completion this session because
each is a bounded-but-large build that cannot be finished axiom-clean now, and partial versions
would introduce forbidden sorries.

## Next step (planner)
1. Specialise `isLocallyInjective_whiskerLeft_of_W` to `Opens X` (unprotected) — or split a
   topological-site variant — to gain access to the stalk machinery.
2. Build (d.1-bridge) from `WEqualsLocallyBijective` + the TopCat stalk criteria, then (d.2)
   from `germ_exist` + filtered-colimit-tensor. Assemble with the 4 bricks now present.
3. Then package `(J.W).IsMonoidal` and instantiate `Localization.Monoidal.LocalizedMonoidal`
   (Step B), retiring the hand-assembled associator.

## Blueprint markers (for review agent)
- `lem:islocallyinjective_whisker_of_W` (`isLocallyInjective_whiskerLeft_of_W`): still has
  `sorry` — proof NOT `\leanok`. The new bricks (`stalkLinearMap` etc.) are not blueprint-pinned;
  plan agent may wish to record them as the d.1 ingredients under `sec:tensorobj_route_e`.
