# Cohomology/HigherDirectImage.lean

NEW file scaffolded this iter (it did not previously exist). Compiles cleanly
(`lake env lean` exit 0); only the 3 expected `sorry` warnings.

All four blueprint declarations (`Cohomology_HigherDirectImage.tex`) are present
with honest types matching their `\lean{...}` names:

- `AlgebraicGeometry.higherDirectImage` (`def:higher_direct_image`) — **no sorry**;
  defined as `((pushforward f).rightDerived i).obj F`.
- `AlgebraicGeometry.higherDirectImage_isQuasiCoherent`
  (`lem:higher_direct_image_quasi_coherent`) — `sorry`.
- `AlgebraicGeometry.higherDirectImage_affine_eq_zero`
  (`lem:higher_direct_image_affine_vanishing`) — `sorry`.
- `AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso`
  (`thm:flat_base_change_higher`) — `sorry`.

## def:higher_direct_image — higherDirectImage (no sorry)
### Attempt 1
- **Approach:** `((pushforward f).rightDerived i).obj F` (Stacks: `Rⁱf_*` = `i`-th
  right derived functor of `f_*`).
- **Result:** RESOLVED (definition compiles), but required carrying
  `[HasInjectiveResolutions X.Modules]` as a hypothesis.
- **Key finding:** `rightDerived` needs `HasInjectiveResolutions X.Modules`, which
  needs `EnoughInjectives X.Modules`. `Abelian X.Modules` IS in Mathlib
  (`Scheme.Modules.instAbelian`) but `EnoughInjectives`/`IsGrothendieckAbelian` for
  `X.Modules` (= `SheafOfModules` over a sheaf of rings) is NOT — the Mathlib
  Grothendieck-abelian instance `CategoryTheory.Sheaf.instIsGrothendieckAbelian` is
  only for `Sheaf J A` (fixed value category), not `SheafOfModules R`. See Gap 0 in
  `informal/higherDirectImage.md`.
- **Design decision:** carried `[HasInjectiveResolutions X.Modules]` (and
  `[HasInjectiveResolutions X'.Modules]` for base change) as an explicit honest
  hypothesis. Deliberately did NOT introduce a sorried `EnoughInjectives` instance
  (that would silently contaminate every downstream consumer and break "clean
  compile" checks). Statements are conditional; the hypothesis can be dropped once a
  `mathlib-build` lane proves `IsGrothendieckAbelian X.Modules`.

## lem:higher_direct_image_affine_vanishing — higherDirectImage_affine_eq_zero (sorry)
### Attempt 1
- **Approach:** considered an abstract derived-functor vanishing argument.
- **Result:** FAILED (no abstract route). `pushforward f` is NOT exact on the full
  module category `X.Modules` even for affine `f` (it is exact only on
  quasi-coherent sheaves), so `IsZero (rightDerived i)` does not follow from
  exactness of the functor. The genuine proof (Stacks 02KG) needs the explicit
  description `Rⁱf_*F = sheafify(V ↦ Hⁱ(f⁻¹V, F|…))` plus affine-cohomology
  vanishing — both absent from Mathlib for `Scheme.Modules` (Gap 1). Statement
  correctly requires `hF : F.IsQuasicoherent` and `1 ≤ i` (the blueprint hypothesis;
  the vanishing is false for non-quasi-coherent `F`). Stated as `IsZero (…)`.
- **Next step:** build Gap 1 (mathlib-build), then this is a few lines.

## lem:higher_direct_image_quasi_coherent — higherDirectImage_isQuasiCoherent (sorry)
- **Approach:** Stacks 02KE induction principle (affine base via affine vanishing +
  q.c. of `f_*`; inductive step via relative Mayer–Vietoris).
- **Result:** sorry — needs Gap 1 (explicit description) + Gap 2 (relative
  Mayer–Vietoris for `Scheme.Modules`), both absent from Mathlib.

## thm:flat_base_change_higher — flatBaseChange_higherDirectImage_isIso (sorry)
- **Approach:** Stacks 02KH `i ≥ 1`: reduce to affine flat `A → B`; Čech complex
  base change + spectral sequence.
- **Result:** sorry — needs Gap 3 (Čech-to-cohomology / spectral sequence for
  `Scheme.Modules`). Stated as `Nonempty (g^*(Rⁱf_*F) ≅ Rⁱf'_*(g'^*F))` (iso
  EXISTENCE) because the canonical higher base-change map (the `i ≥ 1` analogue of
  `FlatBaseChange.pushforwardBaseChangeMap`) is not yet constructed. This is a real,
  non-degenerate iso statement between distinct objects — NOT a `Nonempty (Iso.refl)`
  placeholder.

## Summary
- **Sorry count: 0 → 3** (new file; all 3 are honest scaffolds of deep theorems).
- **Closed:** the `def:higher_direct_image` obligation is fully discharged (no sorry).
- **Open (3), all blocked on missing Mathlib infrastructure documented in
  `informal/higherDirectImage.md`:**
  - `higherDirectImage_affine_eq_zero` — Gap 1.
  - `higherDirectImage_isQuasiCoherent` — Gaps 1 + 2.
  - `flatBaseChange_higherDirectImage_isIso` — Gap 3 (+ higher base-change map).
- Adjacent sorries beyond the assigned scaffold: none in this file beyond the 4
  blueprint decls.

## Why I stopped
**Partial progress.** Real code progress: created the file from scratch, fully
discharged the `def:higher_direct_image` obligation (the definition compiles with
no sorry/axiom), and scaffolded the three theorems with honest, blueprint-faithful
types (correct quasi-coherence hypotheses, correct `1 ≤ i`, correct cartesian-square
shape). The three theorem bodies remain `sorry`.

These three are NOT "frontier-ready": each requires infrastructure verified absent
from Mathlib for `Scheme.Modules` — the explicit `Rⁱf_* = sheafify(V ↦ Hⁱ(…))`
description, affine higher-cohomology vanishing, relative Mayer–Vietoris, and
Čech-to-cohomology spectral sequences (Gaps 1–3 in `informal/higherDirectImage.md`).
I checked for an abstract derived-functor route to affine vanishing and found none
(`pushforward f` is not exact on all `O_X`-modules). The informal agent was
unavailable (`MOONSHOT_API_KEY` set but returns HTTP 401; no other key present), so
the gaps were confirmed via `lean_leansearch`/`lean_local_search`/`#synth` probes
and documented precisely for the plan agent to assign in `mathlib-build` mode.

This matches the assigned objective ("scaffold the 4 decls; prove frontier-ready
ones if reached; leave the deep theorem as sorry"): none of the three were reachable
without the documented large mathlib-builds.

## Blueprint markers (for review agent / sync_leanok)
- `def:higher_direct_image` — ready for `\leanok` (definition present, no sorry).
- The three lemma/theorem blocks remain unmarked (sorry bodies); the deterministic
  `sync_leanok` pass will leave them unmarked.
