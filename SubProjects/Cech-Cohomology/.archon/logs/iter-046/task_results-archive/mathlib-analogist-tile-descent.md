# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tile-descent

## Iteration
046

## Question
(1) Is there a Mathlib-idiomatic way to supply `Module R` / `SMul R` / `IsScalarTower R R_g` on a
carrier whose *type* mentions `Spec` (so any `letI`/`haveI`/`have` hoists to a noncomputable aux def
and fails codegen in a `theorem`), without the giant inline `@…` term? (2) Is the
`modulesSpecToSheaf.obj` carrier the wrong one — would phrasing the whole descent on the F-side
carrier `F.val.obj (op W)` avoid W1/W2 entirely?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Manual `letI`/inline install of base-ring instance on `Spec` carrier | ALIGN_WITH_MATHLIB | critical |
| Carrier choice: F-side vs tile vs restriction-of-scalars wrapper | ALIGN_WITH_MATHLIB | critical |
| Descent lemma's own arg-shape (`[Module R M] [IsScalarTower R A M]` as args) | PROCEED | informational |

## Must-fix-this-iter

- **Stop installing instances by hand.** `QcohTildeSections.lean:1003-1066`'s `letI`/`have`/inline-`@`
  approach is the divergence that *is* the W1/W2/W3 blocker. An instance is data; a `letI`/`have`
  whose `Spec`-noncomputable value leaks into a later type gets lifted into an auxiliary `def`
  generated without `noncomputable` → codegen failure (W1). Align with Mathlib's
  restriction-of-scalars idiom so `Module R`, `Module R_g`, and `IsScalarTower R R_g` are all found
  by `inferInstance` from the carrier's *type*, never bound in the body.

  **The carrier where all three are structural** is the bundled
  `(ModuleCat.restrictScalars (algebraMap R R_g)).obj (tile-section)`:
  - `Module R` — structural (it is a `ModuleCat R` object; `RestrictScalars.obj'`,
    `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings:66-68,85`).
  - `Module R_g` — Mathlib instance (`…ChangeOfRings:110-112`).
  - `IsScalarTower R R_g` — one **Prop** instance (no codegen ⇒ no W1) via
    `IsScalarTower.of_algebraMap_smul` (`Mathlib.Algebra.Algebra.Tower:94`) fed by the rfl
    `ModuleCat.restrictScalars.smul_def'` (`…ChangeOfRings:124-127`).
  - Final transport `σ.restrictScalars R ⇝ ρ`: `IsLocalizedModule.of_linearEquiv` /
    `…of_linearEquiv_right` (`Mathlib.Algebra.Module.LocalizedModule.Basic:544,560`, both instances)
    along the identity-on-elements `R`-equivs (equiv content = the proven `tile_scalar_compat'`).

- **F-side carrier alone is NOT the fix** (answer to Q2). `F.val.obj (op W)` makes `Module R`
  structural but loses structural `Module R_g` — the symmetric form of the same wall. The descent
  needs *both* rings on one carrier; only the restriction-of-scalars wrapper achieves that. Do not
  re-state `isLocalizedModule_powers_restrictScalars_of_algebraMap` on the F-side section types.

## Ranked recommendation (the directive's (a)/(b)/(c))

1. **(a) Bundled restriction-of-scalars / structural-instance reshape — ADOPT.** Wrap the tile section
   in `ModuleCat.restrictScalars (algebraMap R R_g)` so the three instances are structural; add the
   one-line `IsScalarTower` Prop instance; transport with `of_linearEquiv(_right)`. Cost: ~1 helper
   instance + an `eqToLinearEquiv`/`show` to stage the final defeq (also the lever for W3). Most
   Mathlib-idiomatic — `Mathlib.Algebra.Algebra.RestrictScalars`'s docstring (`:60-77`) describes this
   exact situation and prescribes exactly this.
2. **(b) F-side-carrier reshape — REJECT as a standalone fix.** Symmetric wall (loses `Module R_g`).
   Subsumed by (a). Only the structure-sheaf `R`-action being native is genuinely true here, but that
   half was never the missing one.
3. **(c) Inline giant `@…` term — FALLBACK ONLY.** Avoids the `letI` lift but does nothing for W3 and
   is fragile to elaboration order. Use only if (a) hits an unexpected unification snag.

## Informational

- The descent lemma `isLocalizedModule_powers_restrictScalars_of_algebraMap`
  (`QcohTildeSections.lean:663-703`) is **already** the Mathlib-preferred shape: it takes the
  base-ring `[Module]`/`[IsScalarTower]` as *arguments*, mirroring `IsLocalizedModule.of_restrictScalars`
  (`…LocalizedModule.Basic:702`, the ascent it is the converse of), which likewise assumes all such
  instances ambiently and never installs them. Keep it verbatim (axiom-clean). The whole problem is
  the call site, not the lemma.
- Architecturally, `modulesSpecToSheaf` + the hand-rolled `Module R`-on-sections plumbing re-implement
  a slice of `SheafOfModules.restrictScalars` / `PresheafOfModules.restrictScalars`
  (`…ModuleCat.Sheaf.ChangeOfRings:36`, `…ModuleCat.Presheaf.ChangeOfRings:52`). Those are *not* a
  drop-in here (the descent crosses spaces `Spec R_g` vs `Spec R`, whereas those functors fix the
  ringed space), so per-section `ModuleCat.restrictScalars` is the correct granularity — but it is
  worth a `% NOTE` that the project's section-level `R`-module machinery parallels a Mathlib sheaf API.

## Persistent file
- `analogies/tile-descent-instance-shape.md` — full diagnosis, citations, and the signature-level
  starting shape captured for future iters.

Overall verdict: the wall is a manual-instance-installation anti-pattern — align with Mathlib's
restriction-of-scalars idiom (`ModuleCat.restrictScalars`-wrapped tile carrier + structural
instances + `IsLocalizedModule.of_linearEquiv` transport) and W1/W2 dissolve, leaving only W3 as a
staging/`show` problem.
