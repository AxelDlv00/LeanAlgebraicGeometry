# AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean

**Iter-183 Lane I CRITICAL — Pin 2 wrapper body LANDED. 5th-consecutive
sig-only streak BROKEN.**

## Sorry projection

Entering: 3 sorries (L290 typed-sorry def `Hom.poleDivisor`; L342 Pin 2
wrapper body `morphism_degree_via_pole_divisor`; L438 Pin 3 body
`iso_of_degree_one`).

Exiting: 3 sorries (L290 typed-sorry def `Hom.poleDivisor` unchanged;
**L321 NEW named helper `Hom.poleDivisor_degree_eq_finrank`** Tier-3
honest sorry; **L482 Pin 3 body `iso_of_degree_one`** unchanged).

Net: Pin 2 wrapper body closed (sorry-free assembly); 1 named helper
added (Tier-3, body iter-184+). Sorry count: **3 → 3 (CRITICAL ITER
SUCCESS — body lands, count flat by construction)**.

## morphism_degree_via_pole_divisor (Pin 2 wrapper, L342 → now sorry-free)

### Attempt 1

- **Approach**: Per iter-183 directive (Lane I primary target), close
  via the witness `D := Scheme.Hom.poleDivisor φ` (the typed-sorry def
  from iter-182 plan-phase refactor), `rfl` on the equality `D = poleDivisor φ`
  (definitional), and a single named helper sorry for the degree identity.
- **Result**: RESOLVED. Pin 2 wrapper body collapses to
  ```
  ⟨Scheme.Hom.poleDivisor φ, rfl,
    Hom.poleDivisor_degree_eq_finrank φ _hφ_non_const⟩
  ```
  a 3-tuple constructor matching the `∃ D, D = poleDivisor φ ∧ degree D = ...`
  output shape. Both `rfl` (definitional equality) and the helper call
  typecheck immediately.
- **Disclosure tier**: Tier-2 modulo `Hom.poleDivisor` def body
  (iter-184+) and the new helper `Hom.poleDivisor_degree_eq_finrank`
  (iter-184+). When both upstreams close, the wrapper auto-upgrades to
  Tier-1 axiom-clean.

## Hom.poleDivisor_degree_eq_finrank (NEW named helper, L321)

### Attempt 1

- **Approach**: Introduce the named Tier-3 honest sorry per iter-183
  directive (Lane I primary target sub-decomposition). Signature:
  ```
  theorem Hom.poleDivisor_degree_eq_finrank
      ... (φ : C ⟶ ProjectiveLineBar kbar)
      (_hφ_non_const : ∀ Q, φ ≠ toUnit C ≫ Q)
      [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
      Scheme.WeilDivisor.degree (Scheme.Hom.poleDivisor φ) =
        (Module.finrank ... : ℤ) := sorry
  ```
- **Result**: PARTIAL (statement only; body iter-184+ per directive
  "Off-target: ... Scheme.Hom.poleDivisor body L290 (iter-184+ via
  `Ideal.sum_ramification_inertia` ~80-150 LOC)").
- **Disclosure tier**: Tier-3 honest sorry (substantive content) with
  explicit body-recipe disclosure in docstring referencing
  `analogies/ratcurveiso-pin2.md` Decision 2 (verdict PROCEED).
- **Body recipe (iter-184+)**: pick affine open `Spec A ⊂ ℙ¹` containing
  `∞`; preimage `Spec B ⊂ C` is finite over `Spec A` (non-constancy +
  smooth proper curves ⟹ finite); both `A → B` are Dedekind extensions
  and `Σ_{Q above P} e(Q|P) · f(Q|P) = [Frac B : Frac A] = [K(C) : K(ℙ¹)]`
  identifies the pole-divisor degree with the function-field degree
  (Hartshorne II.6.9 specialised to Dedekind bases via
  `Ideal.sum_ramification_inertia` in
  `Mathlib.NumberTheory.RamificationInertia.Basic`).

## Off-target (per iter-183 directive)

- `Hom.poleDivisor` body L290: iter-184+ via
  `Ideal.sum_ramification_inertia`, ~80-150 LOC. **Not touched.**
- `iso_of_degree_one` body L482 (Pin 3): iter-184+ via
  `analogies/ratcurveiso-pin3.md` Decision 2 (Hartshorne I.6.12 chain
  or `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` route).
  **Not touched.**

## Helper budget

Iter-183 directive: budget = 3 (named degree-identity helper + 2 reserve
for projection / coercion). **Used: 1** (the named helper
`poleDivisor_degree_eq_finrank`). 2 reserve unused (not needed —
wrapper assembly is direct via the existential's `⟨_, rfl, _⟩` shape).

## Axiom verification

- `morphism_degree_via_pole_divisor` axioms: `{propext, sorryAx,
  Classical.choice, Quot.sound}` — `sorryAx` present (transitive through
  the typed-sorry def `Hom.poleDivisor` and the typed-sorry helper
  `Hom.poleDivisor_degree_eq_finrank`). Expected per 3-tier disclosure;
  Tier-2 modulo both upstream sorries.
- `Hom.poleDivisor_degree_eq_finrank` axioms: same set. Expected
  Tier-3 direct sorry.

## Build status

`lake build AlgebraicJacobian.RiemannRoch.RationalCurveIso` → GREEN.
3 sorries reported in the file; matches expectation.

## Blueprint coordination

Blueprint `chapters/RiemannRoch_RationalCurveIso.tex` is up-to-date
(iter-182 plan-phase writer updated Pin 2 + Pin 3 prose). The new
helper `Hom.poleDivisor_degree_eq_finrank` is an internal Lean
refactoring artifact (not a new \lean{...} pin); it is the natural
sub-decomposition of `lem:degree_via_pole_divisor` per the chapter's
own "Sub-build note" paragraph. **No blueprint marker action needed**
this iter (Tier-3 helper body still iter-184+; `\leanok` on
`morphism_degree_via_pole_divisor` should remain WITHHOLD via
`sync_leanok` because the proof transitively uses `sorryAx`).

## Critical escalation

**Route 2d 5-consecutive-sig-only-iter streak: BROKEN.** Lane I body
landed this iter (Pin 2 wrapper sorry-free, new named typed-sorry
helper introduced). Iter-184 plan-phase need NOT trigger the
TO_USER.md escalation pathway for Route 2d.

## Iter-184+ continuation

- **Primary**: close `Hom.poleDivisor` body L290 via the project-bespoke
  Weil-divisor pullback construction on `[∞] ∈ Div(ℙ¹)`. ~80-150 LOC
  per `analogies/ratcurveiso-pin2.md`.
- **Companion**: close `Hom.poleDivisor_degree_eq_finrank` body L321
  via `Ideal.sum_ramification_inertia` (closing this helper auto-
  upgrades the Pin 2 wrapper to Tier-1 axiom-clean modulo the def body).
- **Off-path**: Pin 3 body L482 via `analogies/ratcurveiso-pin3.md`
  Decision 2 (separable sub-build).
