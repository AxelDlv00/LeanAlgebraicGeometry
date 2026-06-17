# Mathlib-analogist directive — G1-core affine descent

## Mode: api-alignment

## Question
We must build, axiom-clean, the following Mathlib-absent foundation (Stacks tag 01HA / Hartshorne II.5.2):

`theorem Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent {R : CommRingCat}
  (M : (Spec R).Modules) [M.IsQuasicoherent] (f : R) :
  IsLocalizedModule (Submonoid.powers f)
    ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE (le_top : basicOpen f ≤ ⊤)).op).hom`

i.e. for a quasi-coherent sheaf of modules `M` on `Spec R`, the section restriction
`Γ(M,⊤) → Γ(M,D(f))` exhibits `Γ(M,D(f))` as `(powers f)⁻¹ Γ(M,⊤)`.

The currently-planned route is the explicit finite-cover + flat-equalizer descent:
1. Refine the `QuasicoherentData` cover to basic opens; finite subcover by `CompactSpace (PrimeSpectrum R)`;
   the `g_a` generate the unit ideal, and each `M.over (basicOpen g_a)` has a `SheafOfModules.Presentation`.
2. On each `D(g_a) ≅ Spec R_{g_a}`, the presentation + `isIso_fromTildeΓ_of_presentation` ⟹
   `M|_{D(g_a)} ≅ tilde N_a`, `N_a = Γ(M, D(g_a))` over `R_{g_a}`.
3. Sheaf equalizer `Γ(M,⊤) → ∏ N_a ⇉ ∏ Γ(M, D(g_a g_b))`; localize at `powers f`; exact since
   localization is flat ⟹ matches the equalizer for `Γ(M, D(f))`. Hence `Γ(M,⊤)_f ≅ Γ(M,D(f))`.
4. Conclude `IsLocalizedModule (powers f)`.

The prover (iter-026) reports **step 1 is the heaviest unknown** — extracting a *finite basic-open
presentation cover* from `M.QuasicoherentData`, using the `Scheme.Modules` site / `over` /
`pushforward` API (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`, `Quasicoherent.lean`) — and is itself
a full-session build. The prior consult (`analogies/quot-qcoh-affine-globalization.md`) established that
all routes funnel through this G1-core and that the global-`Presentation` route (Route A) is strictly
harder.

## What I need from you
Search Mathlib for the most economical realisation, specifically:

1. **Is there a shorter affine descent than the explicit finite-equalizer route?** In particular, does
   Mathlib's `Scheme.Modules` / `QuasicoherentData` / `Tilde` / `SheafOfModules` API already provide, or
   make cheap, any of:
   - a direct `IsQuasicoherent M → IsIso M.fromTildeΓ` (or its components on basic opens) on an affine
     scheme — confirm/deny it exists (the iter-026 grep found none);
   - a `QuasicoherentData → (finite) basic-open Presentation cover` helper, or a localization/`over`
     API that hands the per-basic-open presentation directly without manual cover refinement;
   - a `Module.Flat`/`IsLocalization` lemma that localizes a *finite equalizer/limit of modules* in one
     step (e.g. `IsLocalization.exact`, flat-preserves-equalizer, `Module.Flat.lTensor_*`), so step 3 is
     a single lemma application rather than a hand-built diagram chase.
2. **Is the `over`/site machinery the right Mathlib idiom**, or is there a more direct Mathlib path from
   `M.IsQuasicoherent` to the section-localization conclusion (e.g. via the stalk description of QC
   sheaves, `TopCat.Presheaf` localization, or the `Spec`-`Γ` adjunction)?
3. If the explicit-equalizer route IS the only realistic path, **confirm that** and give the cleanest
   Mathlib lemma names for each of steps 1–4 so the prover can target named ingredients.

## Output
Per the api-alignment format: whether Mathlib has a shorter idiom, the cost of the explicit route vs any
alternative, and the concrete lemma names (with `[verified]`/`[expected]` tags) for the chosen route.
Persist the route map to `analogies/g1core-affine-descent.md`. This decides whether we dispatch the QUOT
prover at step 1 of the explicit route this iter or pivot to a shorter one.
