# Mathlib Analogist Report

## Mode
api-alignment

## Slug
iter022-bridges

## Iteration
022

## Question
Two independent load-bearing Mathlib facts, verified BEFORE the GF and FBC prover lanes are dispatched:
1. **GF** — the ring-localization ↔ module-localization bridge identifying
   `LocalizedModule (Submonoid.powers g) C` with `Localization.Away (algebraMap A C g)` (step (4) of the
   `genericFlatnessAlgebraic` cascade).
2. **FBC** — existence + type-unification of `CategoryTheory.conjugateEquiv_counit_symm` (the counit dual
   of `unit_conjugateEquiv_symm`) for the live crux `base_change_mate_gstar_transpose` (Seam 3).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| GF: ring↔module localization bridge | ALIGN_WITH_MATHLIB (idiom exists, one-step) | informational (confirms route) |
| FBC: `conjugateEquiv_counit_symm` exists + direction | ALIGN_WITH_MATHLIB (confirmed verbatim) | informational (confirms route) |

Both load-bearing lemmas are CONFIRMED to exist in the current pinned Mathlib with types that unify with
the project goals. Neither lane needs a Mathlib gap-fill. Each has exactly one precision trap, pinned below.

## Informational

### GF — bridge CONFIRMED (`analogies/gf-localizedmodule-localization-away-bridge.md`)
- The one-step iso is
  `IsLocalizedModule.iso (Submonoid.powers g) (IsScalarTower.toAlgHom A C C_g).toLinearMap`
  `: LocalizedModule (powers g) C ≃ₗ[A] Localization.Away (algebraMap A C g)`
  (`Mathlib.Algebra.Module.LocalizedModule.Basic`), with the required `IsLocalizedModule` instance
  auto-supplied by `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`
  (`Mathlib.Algebra.Module.LocalizedModule.IsLocalization`). No hand-rolled `LocalizedModule.lift`
  uniqueness proof is needed; `IsLocalization.algEquiv` does NOT apply (LHS is a bare module, not a
  ring-localization object).
- **Two side-obligations** the prover must supply (both one-liners, both patterned in-file):
  1. `haveI : IsLocalization (Algebra.algebraMapSubmonoid C (powers g)) (Localization.Away (algebraMap A C g))`
     via `show … (Submonoid.map (algebraMap A C) (powers g)) …; rw [Submonoid.map_powers]; infer_instance`
     (`Submonoid.map_powers`, `Mathlib.Algebra.Group.Submonoid.Membership`; `Algebra.algebraMapSubmonoid`
     unfolds to `.map` by `rfl`, `Mathlib.Algebra.Algebra.Basic:138`).
  2. The composite `Algebra A C_g` + `IsScalarTower A C C_g`.
- **PRECISION TRAP (must-not-miss):** `IsLocalizedModule.iso` is only **`A`-linear**, but
  `free_localizationAway_of_away_tower` (`FlatteningStratification.lean:1701`) consumes freeness over
  `Localization.Away h` of `LocalizedModule (powers h) (LocalizedModule (powers g) C)` — it needs the
  bridge to respect the `A_g = Localization.Away g` structure. Upgrade with
  `LinearEquiv.extendScalarsOfIsLocalization (powers g) (Localization.Away g)`
  (`Mathlib.RingTheory.Localization.Module`) to get a `≃ₗ[A_g]` before transferring `Module.Free`.

### FBC — `conjugateEquiv_counit_symm` CONFIRMED (`analogies/fbc-conjugateequiv-counit-symm.md`)
- Exists VERBATIM at `Mathlib/CategoryTheory/Adjunction/Mates.lean:287`, signature exactly as the
  prover reported; it is the literal counit dual of `unit_conjugateEquiv_symm` (line 305, same section),
  which already closed the proven unit seam `base_change_mate_unit_value`.
- The composite-counit splitter `Adjunction.comp_counit_app` exists
  (`Mathlib/CategoryTheory/Adjunction/Basic.lean:590`), mirror of the `comp_unit_app` the unit seam used.
- **PRECISION TRAP (direction):** the directive's casual "`(conjugateEquiv adjL adjR).symm α =
  pullback_spec_tilde_iso ψ`" is, as a *morphism component*, the **`.inv`** — because
  `pullback_spec_tilde_iso` carries an extra OUTER `.symm` (def at line 696). The proven unit seam
  pinned the exact relation (`hpullinv`, lines 1041-1042):
  `((conjugateEquiv adjL adjR).symm (gammaPushforwardNatIso ψ).hom).app M = (pullback_spec_tilde_iso ψ M).inv`,
  closed by `rfl`. Use `.symm` (not forward `conjugateEquiv`) and identify with `.inv` (not `.hom`).
- Adjunction roles: `adj₁ := adjL` (geometric counit `ε_g` lands on `adj₁.counit`), `adj₂ := adjR`
  (algebraic `extendRestrictScalars` counit), `α := (gammaPushforwardNatIso ψ).hom`.

## Persistent files
- `analogies/gf-localizedmodule-localization-away-bridge.md` — GF bridge route + the two obligations +
  the `A_g`-linearity upgrade.
- `analogies/fbc-conjugateequiv-counit-symm.md` — FBC counit-seam lemma confirmation + the direction pin.

Overall verdict: both load-bearing Mathlib lemmas are confirmed to exist with unifying types — GF via
`IsLocalizedModule.iso` (+ `extendScalarsOfIsLocalization` for `A_g`-linearity), FBC via
`conjugateEquiv_counit_symm` (+ `comp_counit_app`); each prover lane may be dispatched, heeding the one
precision trap flagged per lane (GF: upgrade to `A_g`-linear; FBC: `.symm`→`.inv` direction).
