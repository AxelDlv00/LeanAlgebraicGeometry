# Refactor Directive

## Slug
m1-bridge-iter122

## Problem

The iter-121 strategic pivot opens milestone **M1 (the bridge between the
presheaf-form section module of `relativeDifferentialsPresheaf` and the
algebra-Kähler module on an affine chart)**. The blueprint chapter
`blueprint/src/chapters/Differentials.tex` § "Bridge: presheaf form ↔
algebra-Kähler form on an affine chart (milestone M1)" states the bridge
as Theorem~`thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` and
the load-bearing auxiliary `lem:appLE_isLocalization`, with full
mathematical content.

The Lean side currently lacks these declarations. Per the iter-121
plan, iter-122 introduces them with `sorry` bodies so that the
subsequent prover lane has a concrete Lean target to attack.

## Mathematical justification

The bridge identifies, on an affine chart `V ⊆ f ⁻¹ᵁ U` with `U ⊆ S`
and `V ⊆ X` affine opens, the section module of the relative cotangent
presheaf on `V` with the appLE-algebra Kähler module:

```
((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) ≃ₗ[Γ(X, V)] Ω[Γ(X, V) ⁄ Γ(S, U)]
```

The proof goes through four steps (per blueprint M1.a–M1.e):

- M1.a: the multiplicative set `M := {g ∈ A : appLE(g) ∈ B^×}` is a
  submonoid of `A := Γ(S, U)`.
- M1.b: the canonical algebra map `A → A_colim` (where `A_colim` is the
  inverse-image-presheaf colimit ring `((TopCat.Presheaf.pullback _ f.base).obj S.presheaf).obj (.op V)`) exhibits `A_colim` as the localization of `A` at `M`, i.e. `IsLocalization M A_colim`.
- M1.c: `Subsingleton (Ω[A_colim ⁄ A])` — a two-line consequence of
  `Algebra.FormallyUnramified.of_isLocalization` and the existing
  `Algebra.FormallyUnramified.subsingleton_kaehlerDifferential` instance
  (NOT a Mathlib gap).
- M1.d: the canonical surjection `Ω[B ⁄ A] → Ω[B ⁄ A_colim]` is a
  `B`-linear equivalence (zero kernel via the second fundamental exact
  sequence + M1.c).
- M1.e: assemble — compose M1.d's inverse with the `rfl`-identification
  `relativeDifferentialsPresheaf_obj_kaehler`.

This refactor introduces the **scaffolding** for the M1 work (three new
declarations, two with `sorry` bodies, one as a `def` with no sorry).
The prover lane in the same iter will then target the largest sorry
(M1.b, `appLE_isLocalization`).

## Changes Requested

### File: `AlgebraicJacobian/Differentials.lean`

Add the following declarations after `relativeDifferentialsPresheaf_obj_kaehler`
(currently at L58–L64) and before `smooth_locally_free_omega` (currently
at L91), inside the `namespace AlgebraicGeometry.Scheme` block. The
existing `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`,
and `smooth_locally_free_omega` declarations remain unchanged.

**Imports required** (add to the import block at L6–L11):

```
import Mathlib.RingTheory.Unramified.Basic
import Mathlib.RingTheory.Localization.Basic
```

(check via `lean_diagnostic_messages` that these imports do not
introduce circular-dependency or universe issues — if they do, the
relevant Mathlib material may be available transitively via
`Mathlib.RingTheory.Kaehler.Basic` already imported; verify before
adding new imports).

#### New declaration 1: `IsAffineOpen.appLE_unitSubmonoid` (M1.a, NO sorry)

This declares the submonoid `M ⊆ Γ(S, U)` of elements whose appLE-image
in `Γ(X, V)` is a unit. Must be in the `AlgebraicGeometry.IsAffineOpen`
namespace per the mathlib-analogist iter-121 finding.

The submonoid's underlying carrier is a set; closure under `1` and
`mul` follow because `appLE` is a ring homomorphism (sends 1 to 1, and
preserves products), and the product of two units in `Γ(X, V)^×` is a
unit.

Recommended signature shape (you may adjust to match Mathlib's idioms):

```lean
namespace AlgebraicGeometry.IsAffineOpen

/-- The submonoid of "good" elements in `Γ(S, U)`: those whose image
under the appLE algebra map `Γ(S, U) → Γ(X, V)` is a unit in `Γ(X, V)`.
This is the multiplicative set at which `Γ(S, U) → A_colim` is a
localization (cf. `appLE_isLocalization`). -/
def appLE_unitSubmonoid {X S : Scheme.{u}} (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) : Submonoid Γ(S, U) where
  carrier := { g | IsUnit ((Scheme.Hom.appLE f U V e).hom g) }
  one_mem' := by
    -- `appLE.hom 1 = 1` (ring hom preserves 1), and `1` is a unit
    sorry
  mul_mem' := by
    -- `appLE.hom (a * b) = appLE.hom a * appLE.hom b`, and product of
    -- units is a unit
    sorry

end AlgebraicGeometry.IsAffineOpen
```

NOTE: The two `sorry`s above are for the *closure-property obligations*
of the submonoid (`one_mem'`, `mul_mem'`). These are 1-line tactic
closures each (`by simp`, `simp only [map_one]; exact isUnit_one`,
`simp only [map_mul]; exact ha.mul hb`, etc.). The intent is that the
prover closes these in the same prover lane as the surrounding M1.a
work. Sorry trajectory contribution: +2 (will close to 0 in iter-122
prover lane).

ALTERNATIVE: if you can close these obligations inline during the
refactor without prover assistance (single-line tactic each), do so —
the submonoid is M1.a "closed" in that case. The prover then targets
only `appLE_isLocalization` (M1.b). Use your judgement.

#### New declaration 2: `IsAffineOpen.appLE_isLocalization` (M1.b, WITH sorry)

The main M1.b statement: the canonical map from `Γ(S, U)` to the
inverse-image presheaf colimit ring `A_colim` exhibits the latter as
the localization of `Γ(S, U)` at the submonoid `appLE_unitSubmonoid f hU hV e`.

The "canonical map" is the cocone leg of `((TopCat.Presheaf.pullback _ f.base).obj S.presheaf).map (.op V)` at the open `U`-translate-to-X. This is the structure provided by `relativeDifferentialsPresheaf`'s construction in `AlgebraicGeometry.Scheme.Differentials.lean:49–52`. You will need to expose / name the colimit ring's algebra structure over `Γ(S, U)` so the `IsLocalization` predicate type-checks; declaring it via `letI : Algebra Γ(S, U) A_colim := ...` inside the theorem body is acceptable.

Recommended signature shape:

```lean
namespace AlgebraicGeometry.IsAffineOpen

/-- The inverse-image presheaf colimit ring at `V` is the localization
of `Γ(S, U)` at the submonoid `appLE_unitSubmonoid f hU hV e`. -/
theorem appLE_isLocalization {X S : Scheme.{u}} (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    -- Need to expose: the colim ring is an `Algebra Γ(S, U) A_colim`,
    -- and the algebra map satisfies the IsLocalization predicate.
    -- Final signature TBD by the refactor agent based on what type-checks;
    -- the core claim is "IsLocalization (appLE_unitSubmonoid ...) A_colim".
    sorry := sorry

end AlgebraicGeometry.IsAffineOpen
```

Type-checking note: the colim ring `A_colim` (as a `CommRingCat` or
`Type` term) is

```lean
((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)
```

You may need to introduce an abbreviation or `letI`-binding to make the
`IsLocalization` predicate's signature compactly statable.

#### New declaration 3: `relativeDifferentialsPresheaf_equiv_kaehler_appLE` (bridge, WITH sorry)

The bridge theorem itself: the section module of `relativeDifferentialsPresheaf` over `V` is
`Γ(X, V)`-linearly equivalent to the appLE-algebra Kähler module
`Ω[Γ(X, V) ⁄ Γ(S, U)]`. Per the mathlib-analogist iter-121 finding,
packaged as a `LinearEquiv` (not `ModuleCat.Iso`, not natural iso of
`PresheafOfModules`).

Recommended signature shape:

```lean
namespace AlgebraicGeometry.Scheme

/-- The bridge: the section module of `relativeDifferentialsPresheaf` over
an affine `V ⊆ f ⁻¹ᵁ U` is `Γ(X, V)`-linearly equivalent to the
appLE-algebra Kähler module `Ω[Γ(X, V) ⁄ Γ(S, U)]`. -/
theorem relativeDifferentialsPresheaf_equiv_kaehler_appLE
    {X S : Scheme.{u}} (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U) Γ(X, V) :=
      (Scheme.Hom.appLE f U V e).hom.toAlgebra
    ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) ≃ₗ[Γ(X, V)]
      (CommRingCat.KaehlerDifferential.{u}
        ((Scheme.Hom.appLE f U V e).hom)) := sorry

end AlgebraicGeometry.Scheme
```

The right-hand side uses `CommRingCat.KaehlerDifferential ((Hom.appLE ...).hom)`
to match the statement of `smooth_locally_free_omega` (currently
`Ω[Γ(X, V) ⁄ Γ(S, U)]`, which is notation for the same Kähler module
under the `algebraize` tactic's algebra structure). Verify the
types match before finalising.

Adjust the signature shape if the precise type of `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` doesn't unify cleanly with the Kähler-module type; in the worst case, an `Iso` in `ModuleCat (Γ(X, V))` is acceptable as a fallback, but prefer `LinearEquiv` per the analogist.

### File: `blueprint/src/chapters/Differentials.tex`

DO NOT modify the blueprint. The plan agent has applied the iter-122
inline corrections already; the refactor agent should match the
declarations to the existing blueprint structure, not the other way
around.

If the blueprint's exact name / namespace / signature doesn't match
what type-checks in Lean (e.g. an extra implicit binder is needed, or
a typeclass argument is missing), document the divergence in the
"Notes for Plan Agent" section of your refactor report; the plan agent
will reconcile via a follow-up blueprint update next iter.

## Affected Files

- `AlgebraicJacobian/Differentials.lean` — primary target.
- `AlgebraicJacobian.lean` — top-level imports; verify nothing breaks.
- All other `.lean` files — no expected breakage (the new declarations
  are additive; no existing signature changes).

## Expected Outcome

After the refactor:

- `AlgebraicJacobian/Differentials.lean` compiles.
- One new `def` (`appLE_unitSubmonoid`) lands; sorry count contribution 0
  or 2 (depending on whether the closure properties are closed inline).
- Two new `theorem`s land with `sorry` bodies (`appLE_isLocalization`,
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE`).
- Project sorry trajectory: 1 → 3 (or 1 → 5 if the submonoid closure
  obligations remain `sorry`'d).
- No protected declaration signatures are touched.
- `archon-protected.yaml` is unchanged (no protected declarations
  affected).
- The blueprint `\lean{...}` hints
  (`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`,
  `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`)
  resolve to the new declarations.

The subsequent prover lane in iter-122 will target the largest sorry
(`appLE_isLocalization`, M1.b). Per the strategy this is a 2–3 iter
piece estimated at 100–250 LOC; iter-122 prover lane PARTIAL is the
expected outcome.

## Mathlib name verification (iter-122)

- `Algebra.FormallyUnramified.of_isLocalization` — already verified
  iter-121 (`Mathlib.RingTheory.Unramified.Basic`).
- `IsLocalization.of_le` — already verified iter-121
  (`Mathlib.RingTheory.Localization.Defs`).
- `IsLocalization.lift` — already verified
  (`Mathlib.RingTheory.Localization.Basic`).
- `IsLocalization.ringHom_ext` — already verified
  (`Mathlib.RingTheory.Localization.Basic`).
- `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen` — already
  verified iter-121 (`Mathlib.AlgebraicGeometry.AffineScheme`).
- `KaehlerDifferential.exact_mapBaseChange_map` — already verified
  iter-121 (`Mathlib.RingTheory.Kaehler.Basic`).
- `KaehlerDifferential.map_surjective` — already verified iter-121
  (`Mathlib.RingTheory.Kaehler.Basic`).
- `LinearEquiv.ofBijective` — Mathlib core.

If any of these fails to resolve in the actual `b80f227` snapshot
during refactor work, document in the report and the plan agent will
revise the directive.
