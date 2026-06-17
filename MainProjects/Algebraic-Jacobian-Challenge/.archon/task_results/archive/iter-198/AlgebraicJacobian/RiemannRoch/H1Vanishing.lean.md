# AlgebraicJacobian/RiemannRoch/H1Vanishing.lean

## Session summary

- **Lane H HARD BAR MET via Route H-2.** 1 sorry closed (3 → 2) on the
  inner iso path of `Scheme.skyscraperSheaf_eq_pushforward_const` (L851
  in original file). The closure introduces 4 new axiom-clean
  project-local declarations + replaces the inner-iso `sorry` with a
  direct construction.
- Built axiom-clean: `alphaConstToSkyPUnit` (L831),
  `betaSkyToConstPUnit` (L859),
  `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` (L905),
  `Scheme.skyscraperSheaf_iso_constantSheaf_punit` (L924).
- Both `Scheme.skyscraperSheaf_iso_constantSheaf_punit` and
  `Scheme.skyscraperSheaf_eq_pushforward_const` verified
  axiom-clean via `lean_verify`: only `{propext, Classical.choice,
  Quot.sound}`.
- Build GREEN, sorry count 3 → 2 in this file (file-local), no axiom
  regression.

## Summary

- **Declarations added (axiom-clean)**: 4
  - `alphaConstToSkyPUnit` (presheaf morphism `(Functor.const).obj A → skyscraperPresheaf PUnit.unit A`)
  - `betaSkyToConstPUnit` (presheaf morphism `skyscraperPresheaf PUnit.unit A → ((constantSheaf).obj A).val`)
  - `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` (composition lemma)
  - `Scheme.skyscraperSheaf_iso_constantSheaf_punit` (the inner iso)
- **Sorries closed**: 1 (the `hinner_iso` sorry at original L851/855)
- **Sorries remaining in file**: 2 (L138 `IsFlasque.constant_of_irreducible`
  non-empty branch; L613 `IsFlasque.injective_flasque` j_! gap)
- **Sorry count delta**: 3 → 2 (−1) in this file.

## alphaConstToSkyPUnit (L831)
- **Approach:** Define a natural transformation pointwise:
  at op U with `PUnit.unit ∈ U`, use `eqToHom` (both sides equal `A`);
  at op U with `PUnit.unit ∉ U`, use `IsTerminal.from` to the terminal
  in `ModuleCat kbar`.
- **Result:** RESOLVED — axiom-clean.

## betaSkyToConstPUnit (L859)
- **Approach:** Define pointwise:
  at op U with `PUnit.unit ∈ U`, compose `eqToHom` (to lift
  `skyscraperPresheaf.obj` to `A`) with `(toSheafify).app U` (the
  sheafification unit at op U).
  at op U with `PUnit.unit ∉ U`, observe `U.unop = ⊥` (using
  `Opens.eq_bot_or_top` for `IndiscreteTopology` of `PUnit`), then both
  sides are terminal — use `TopCat.Sheaf.isTerminalOfEqEmpty` + `from`.
  Naturality on the non-trivial restriction is via `toSheafify`'s own
  naturality.
- **Result:** RESOLVED — axiom-clean.

## alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify (L905)
- **Approach:** Per-open case analysis. `PUnit.unit ∈ U.unop` case
  reduces to `eqToHom_trans_assoc`; the `⊥` case is closed via
  `IsTerminal.hom_ext` since both sides land in a terminal.
- **Result:** RESOLVED — axiom-clean.

## Scheme.skyscraperSheaf_iso_constantSheaf_punit (L924)
- **Approach:** Iso built as a `{ hom, inv, hom_inv_id, inv_hom_id }`
  record. `hom = ⟨betaSkyToConstPUnit A⟩`; `inv = ⟨sheafifyLift α⟩`.
  `inv_hom_id` (i.e. `α-lift ≫ β = 𝟙` on `(constantSheaf).obj A`) via
  `sheafify_hom_ext` + the composition identity.
  `hom_inv_id` (i.e. `β ≫ α-lift = 𝟙` on `skyscraperSheaf`) via
  `toSheafify_sheafifyLift` for the `PUnit.unit ∈ U` branch and
  `TopCat.Sheaf.isTerminalOfEqEmpty.hom_ext` for the `⊥` branch.
- **Result:** RESOLVED — axiom-clean. The `change` tactic is used
  twice to bridge the `↑(of PUnit.{u + 1})` vs `PUnit.{u + 1}` defeq
  mismatches that `rw` cannot bridge syntactically (one of the two
  `change` instances was flagged by the linter as not changing the
  goal — kept for documentation; could be removed in a polish pass).

## Scheme.skyscraperSheaf_eq_pushforward_const (L1059)
- **Approach:** The body now reads:
  Step 1 (axiom-clean): outer sheaf-level equality via
  `ObjectProperty.FullSubcategory.ext` + Mathlib's
  `skyscraperPresheaf_eq_pushforward`.
  Step 2 (NEW iter-197): the inner iso is provided by
  `⟨Scheme.skyscraperSheaf_iso_constantSheaf_punit kbar A⟩`,
  replacing the iter-196 `sorry`.
  Step 3: compose via `eqToIso hsky_eq` and `mapIso`.
- **Result:** RESOLVED — axiom-clean (verified by `lean_verify`).

## IsFlasque.constant_of_irreducible (L138 — not closed)
- **Status:** NOT ADDRESSED iter-197 (this was the **Route H-1**
  alternative; Route H-2 was selected and successfully closed).
- **Approach 1 (Route H-1 sketch):** Build `Full` + `Faithful` instances
  for `(constantSheaf J D)` on irreducible spaces, then use the
  resulting iso `A ≅ ((constantSheaf).obj A).val.obj (op U)` for
  non-empty `U`.
- **Approach 2 (Direct analogue of H-2):** Generalize
  `Scheme.skyscraperSheaf_iso_constantSheaf_punit` to arbitrary
  irreducible spaces — this is substantially harder because irreducible
  spaces have potentially many opens; the PUnit-specific shortcut
  (`Opens.eq_bot_or_top` via `IndiscreteTopology`) does not apply.
- **Next step:** Try Approach 1; alternatively, find a Mathlib lemma
  about constantSheaf's stalks on irreducible spaces and use the
  stalk-based iso check `isIso_iff_stalkFunctor_map_iso`.

## IsFlasque.injective_flasque (L613 — not closed)
- **Status:** NOT ADDRESSED iter-197 (standing Tier-3 gap; requires
  Mathlib's `j_!` extension-by-zero functor, ~100-150 LOC).
- **Next step:** Standing deferral, gated on Mathlib upstream.

## Why I stopped

- **Real progress**: 4 new axiom-clean declarations added (1 sorry
  closed). The Lane H **Route H-2** HARD BAR is met (the iter-196
  `sorry` at L855 is now replaced with a constructive iso). The
  cascade-impact: `Scheme.skyscraperSheaf_eq_pushforward_const` is
  fully axiom-clean for the first time (was carrying a transitive
  `sorryAx` via `hinner_iso`).
- **Partial progress on PUSH-BEYOND**: I did not attempt
  `IsFlasque.constant_of_irreducible` (non-empty branch, Route H-1)
  this iter. The reason is technical: that closure requires the
  generalization of the PUnit-specific iso machinery (above) to
  arbitrary irreducible spaces, which the simple
  `Opens.eq_bot_or_top` shortcut on `IndiscreteTopology` does NOT
  enable. A fresh approach is needed: either Full+Faithful instances
  for constantSheaf on irreducible spaces (a Mathlib gap), or a
  stalk-based argument via `isIso_iff_stalkFunctor_map_iso` (requires
  computing constant-sheaf stalks on irreducible spaces). The
  blueprint chapter labels this as the "Route A: preferred — Mathlib
  upstreaming candidate" path.
- **Dead end**: do NOT retry the iter-196 approach of "providing
  Full+Faithful for constantSheaf on irreducible spaces" without first
  establishing one of the following Mathlib helpers (none exist in
  snapshot `b80f227`):
  1. A `Sheaf.IsConstant` instance for sheaves on irreducible spaces
     with a specified non-empty open identification.
  2. A `stalkFunctor`-based iso bridge for `presheafToSheaf`.

### Suggested iter-198 follow-up

If Lane H continues, try the stalk-based approach. On an irreducible
space `X` with non-empty `U`, the constant sheaf has stalks `A` at
every point of `U`. A restriction map between two non-empty opens
induces identity-on-stalks (after the canonical
`stalkFunctor`-iso `A ≅ stalk`). By
`TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`, this implies the
restriction is iso (in particular surjective). Note that this would
recover H-1 by a strictly different route than the one currently
sketched in the blueprint chapter (which says "Route A: Full+Faithful
constantSheaf"). The new route avoids the F+F gap entirely.

### Lean style / polish notes

- One `change` tactic at L972 is flagged by the unused-tactic linter
  as not changing the goal. Kept for documentation clarity (it makes
  the proof state explicit at that step); could be removed in a polish
  pass.
- `simp [skyscraperPresheaf, h]` is used in two places for inline
  eqToHom proofs; the `flexible` linter prefers `simp only`, but the
  current usage is local to bind elaborations and is harmless.

### Blueprint marker recommendations

`\lean{...}` pin for the new `Scheme.skyscraperSheaf_iso_constantSheaf_punit`
in `RiemannRoch_H1Vanishing.tex` is the blueprint's
`lem:skyscraperSheaf_iso_constantSheaf_punit` block (already exists
per iter-196 writer). `\leanok` should now apply to it (the deterministic
sync between prover and review phases handles this).

`Scheme.skyscraperSheaf_eq_pushforward_const` should likewise be
upgraded from "statement-block `\leanok` (typed sorry)" to
"proof-block `\leanok`" by the deterministic sync (it now compiles
sorry-free).

The H-2 closure narrows the iter-198 Lane H residual to:
- `IsFlasque.constant_of_irreducible` non-empty branch
- `IsFlasque.injective_flasque` (j_! gap — standing deferral)
