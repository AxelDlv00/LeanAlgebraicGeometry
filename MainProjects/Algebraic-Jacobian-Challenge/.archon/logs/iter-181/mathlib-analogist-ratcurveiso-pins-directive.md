# mathlib-analogist directive (iter-181, slug: ratcurveiso-pins)

## Mode

api-alignment

## Background

`AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` carries 2 long-deferred Pins (Pin 2, Pin 3) that gate the genus-0 RR.4 chain (rational curve over `k̄` ⟹ isomorphic to `ℙ¹`) and downstream `WeilDivisor.principal_degree_zero` (non-constant branch). The pins have been STUCK by deferral across iter-179 + iter-180 (no consult dispatched, no in-project alternative attempted). I need to know whether Mathlib has either of these pieces, or a near-equivalent the project can consume directly.

## The two pins

### Pin 2 — `morphism_degree_via_pole_divisor`

**Mathematical content**: For a non-constant morphism `f : C → ℙ¹` between smooth proper curves over an algebraically closed field, the **degree of `f`** (in the sense of `deg(f) := [K(C) : f^*K(ℙ¹)]`, the field extension degree) equals the **degree of the pole divisor `f^*∞`** (the pullback of the closed point `∞ ∈ ℙ¹`, taken as a Weil divisor on `C`).

This is **Hartshorne II.6 Proposition 6.9** (also II.6.9.1), specialised to the codomain `ℙ¹`. Equivalent / nearby Stacks: 0BE5, 0BCM, 0AYL.

**Project-side type signature** (in `RationalCurveIso.lean`): the Lean lemma asserts `Scheme.degree f = (Scheme.WeilDivisor.pullback f ∞).degree` (or similar — please verify by reading the file).

**What I need from you**:
1. Search Mathlib (`Mathlib/AlgebraicGeometry/...`) for any of:
   - `Scheme.Hom.degree`, `Morphism.degree`, `FunctionField.transcendenceDegree`, `RingHom.localizationDegree`
   - the multiplicativity-of-degree formula
   - "ramification" / "branched cover" combinatorial degree
   - Hartshorne II.6.9 Lean port
2. Verify: does Mathlib currently expose any of (a) `Scheme.degree` for a morphism between smooth proper curves over a field, (b) the pullback of a Weil divisor `f^*D`, (c) the equality of degrees?
3. If yes → name the exact declaration(s) and how the project's Lean signature should be re-aligned (or expressed as a thin wrapper).
4. If no → name the closest Mathlib infrastructure that exists and would let the project build the degree map / multiplicativity in ~50–150 LOC. Is `RingTheory.Ideal.Norm` / `FractionalIdeal.norm` close enough?

### Pin 3 — `iso_of_degree_one`

**Mathematical content**: A morphism `f : C → ℙ¹` between smooth proper curves over an algebraically closed field with **`deg(f) = 1`** is an **isomorphism**. This is **Stacks tag 0AVX** (or the equivalent Hartshorne IV.2 — birational morphism of complete curves is iso). 

Equivalent formulations: (a) `deg(f) = 1 ⟹ [K(C) : K(ℙ¹)] = 1 ⟹ f^* : K(ℙ¹) → K(C)` is an iso of fields ⟹ `f` is birational ⟹ since `C` and `ℙ¹` are smooth proper, `f` is an iso (Zariski's main theorem / Hartshorne III.11.4 for the projective case).

**Project-side type signature** (in `RationalCurveIso.lean`): roughly `f : C ⟶ ℙ¹ → deg f = 1 → IsIso f`.

**What I need from you**:
1. Search Mathlib for any of:
   - `Scheme.Hom.isIso_of_deg_one`, `Morphism.isIso_of_birational`
   - `IsBirational ⟹ IsIso` for smooth proper schemes / curves
   - Zariski's main theorem (Mathlib has `ZariskiMainTheorem`?)
   - `Hartshorne.III_11_4` or analogues
2. Verify: does Mathlib expose any of (a) `IsBirational` for scheme morphisms, (b) the smooth-proper-curve "birational ⟹ iso" lemma, (c) the closed-immersion-via-degree-1 path?
3. If yes → name the lemma(s) + how the project's signature aligns.
4. If no → name the closest infrastructure (e.g. `Quasi-finite + proper + birational ⟹ iso` should exist in Mathlib in some form even if not specialised to curves) and a ~50–100 LOC strategy.

## Output format

Per pin: ALIGN_WITH_MATHLIB (Mathlib has it, project must use it) / PROCEED (project's own bespoke build is acceptable; no Mathlib alternative) / GAP (Mathlib doesn't have it but the closest infra needs ~K LOC; recommend project build). Include verbatim Mathlib decl names + file paths when available.

If both pins return GAP, the iter-182 planner has to make a "axiomatise" vs "in-tree build" decision and your report frames that decision.

Persistent file: write recipes to `analogies/ratcurveiso-pin2.md` (Pin 2) and `analogies/ratcurveiso-pin3.md` (Pin 3). Report under `task_results/mathlib-analogist-ratcurveiso-pins.md`.

## Write domain

`task_results/**`, `analogies/**`.
