/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.ExtensionUniformity

/-!
# The base divisor exists over every field, at every genus — the residue of
extension-uniformity is a degree bound and nothing else

`UniformBaseDivisor C d` (`Ledger/ExtensionUniformity.lean`) is the single remaining input of
extension-uniform `H¹` vanishing
(`Ledger/GenusFieldInvariance.uniformVanishing_of_uniformBaseDivisor`).
It asks for **one** degree bound `d`, chosen before any field, such that over every
extension `κ/k` some divisor of degree `≤ d` already has vanishing `H¹`.

Its two clauses have very different costs, and this file separates them, because the project's
own index for the gap does not.

* **The existence clause is FREE, at every genus.**  `exists_base_subsingleton_baseChangeField`
  below: for **every** field extension `κ/k` there is a divisor `D₀` on `C_κ` with
  `H¹(𝒪(D₀)) = 0`.  Three curve binders, no genus hypothesis, no hypothesis on `κ/k`, one term.
* **The degree clause is the whole residue.**  Nothing here bounds `deg_κ D₀` as `κ` varies, and
  that — not the production of a vanishing divisor — is what `UniformBaseDivisor` still needs.

## Why this is a re-pricing and not a restatement

`Ledger/GenusFieldInvariance.lean:426-430` prices the gap as a missing **production from
geometry**: "For `UniformBaseDivisor` none [no producer] does: it is a `def` with consumers and
no producer anywhere in AJC", concluding "the gap is not a missing consumer or a carrier mismatch
— it is a missing production from geometry, and that is the form the next attempt should take."
That paragraph then records its own partial refutation: `Ledger/VanishingFieldDescent.lean`
produced `UniformBaseDivisor C 0`, but only under `Subsingleton (H¹(𝒪_C))`, which
`subsingleton_hModule_one_iff_genus_eq_zero` shows is exactly `genus C = 0`.  So the standing
picture is that `genus C ≥ 1` still awaits a production from geometry.

That is measured here and it is wrong in a way worth naming: **the production from geometry
already exists, at every genus.**  `Ledger/FiberBound.exists_base_subsingleton_of_isFinite_toP1`
produces a vanishing divisor from a finite dominant `π : Y ⟶ ℙ¹`, and on AJC's curve the `π` and
both cohomology finiteness binders are theorems of the project
(`Ledger/MapToP1.exists_isFinite_isDominant_toP1`, `Ledger/ChiCurve.lean`) — with no genus
hypothesis anywhere in that chain.  Applying it at `Scheme.baseChangeField C κ`, whose three
curve binders are witnessed by `ExtensionUniformity` §1, gives the existence clause over every
`κ` outright.

The genus-0 restriction of `VanishingFieldDescent` is therefore a property of **that route** —
transporting the vanishing of the *unit* sheaf by faithful flatness, which forces the witness to
be the zero divisor and hence `H¹(𝒪_C)` itself to vanish — and not a property of the obligation.
The obligation never needed the unit sheaf.

## What remains open, stated exactly

One bound on one integer.  The divisor produced at `C_κ` is `n₀(κ) • F_κ`, where `F_κ` is the
fibre divisor of the finite dominant map to `ℙ¹_κ` and `n₀(κ)` is a Noetherian stabilisation
index of the fibre-lattice chain (`Ledger/FiberVanishing.lean`), re-run at each base field.  So
`deg_κ (n₀(κ) • F_κ) = n₀(κ) · deg_κ F_κ`, and `UniformBaseDivisor C d` follows from a uniform
bound on that product.  Nothing in this file bounds it, and the honest statement of the gap is
that product rather than "a missing production from geometry".

The reason the bound is not free from the vanishing theorems already in the tree: the degree
threshold of `Ledger/DegreeVanishing.subsingleton_hModule_one_of_deg_ge` is
`deg D₀ + 1 − χ(𝒪)`, i.e. it is stated *relative to a base divisor already in hand*, so using it
to bound `deg D₀` is circular.  Breaking the circle needs an absolute large-degree vanishing
theorem — Serre duality's `deg ≥ 2g − 1`, which this workspace does not have — or a bound on the
stabilisation index in terms of `genus C`, which is base-field-invariant
(`Ledger/GenusFieldInvariance.genus_baseChangeField_curve`).

## Contents

* `exists_base_subsingleton_curve` — over `k`, at every genus: a divisor with vanishing `H¹`.
* `exists_base_subsingleton_baseChangeField` — the same over every extension `κ/k`.
* `uniformBaseDivisor_of_exists_deg_le` — the residue isolated: a per-field vanishing divisor of
  *bounded degree* gives `UniformBaseDivisor`.  Recorded so the degree clause is the only thing a
  consumer has to supply, and deliberately **not** advertised as progress: it is the definition
  with the existence clause discharged, which is exactly what the two theorems above buy.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))

section BaseDivisor

variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]

/-- **A divisor with vanishing `H¹` exists on the curve, at every genus** (★★).

Three curve binders and nothing else: no genus hypothesis, no vanishing hypothesis, no finite
map supplied by the caller.  The `π : C ⟶ ℙ¹` and both cohomology finiteness binders that
`Ledger/FiberBound.exists_base_subsingleton_of_isFinite_toP1` asks for are discharged here from
the curve itself (`Ledger/MapToP1.exists_isFinite_isDominant_toP1`,
`Ledger/ChiCurve.moduleFinite_hModule_zero`).

This is the existence clause of `UniformBaseDivisor` over the base field.  It is stated because
the project's index for that gap (`Ledger/GenusFieldInvariance.lean:426-430`) prices it as a
missing production from geometry restricted to `genus C = 0`; the production exists at every
genus, and only the degree bound is missing.  See the module docstring. -/
theorem exists_base_subsingleton_curve :
    letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
    haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
    ∃ D₀ : C.left.CurveDivisor,
      Subsingleton (Sheaf.HModule (C.left.divisorSheaf k D₀) 1) := by
  letI : C.left.Over (Spec (CommRingCat.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  obtain ⟨π, hfin, hdom, hcomp⟩ := exists_isFinite_isDominant_toP1 (k := k) (C := C)
  haveI := hfin
  haveI := hdom
  exact exists_base_subsingleton_of_isFinite_toP1 π hcomp

/-- **The existence clause of `UniformBaseDivisor`, over every field extension** (★★): for every
`κ/k`, finite or infinite, separable or not, there is a divisor on `C_κ` whose `H¹` vanishes.

One term: `exists_base_subsingleton_curve` at `Scheme.baseChangeField C κ`, whose three curve
binders are the instances of `Ledger/ExtensionUniformity.lean` §1.  Per the standing lesson that
class stability under base change witnesses nothing until an **object** carrying the base-changed
instances is exhibited in the spelling the consumer elaborates against (`FiberBound.lean` §
"SUPERSEDED"), this is stated at `C_κ` itself rather than as a stability claim.

What it does **not** give, and the whole of what `UniformBaseDivisor` still needs: any bound on
`CurveDivisor.deg κ D₀` as `κ` varies.  The witness is `n₀(κ) • F_κ` with `n₀(κ)` a Noetherian
stabilisation index re-run at each base field. -/
theorem exists_base_subsingleton_baseChangeField (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ D₀ : (Scheme.baseChangeField C κ).left.CurveDivisor,
      Subsingleton
        (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D₀) 1) :=
  exists_base_subsingleton_curve (Scheme.baseChangeField C κ)

omit [IsProper C.hom] in
/-- **The residue isolated**: `UniformBaseDivisor C d` from a *degree-bounded* per-field vanishing
divisor.

This is deliberately recorded as bookkeeping rather than progress.  It is `UniformBaseDivisor`'s
definition with the existence clause supplied by
`exists_base_subsingleton_baseChangeField` — so the only thing a producer still has to exhibit
is the inequality `CurveDivisor.deg κ D₀ ≤ d`, uniformly in `κ`.  Stating it separates the two
clauses at the type level, which is what stops the next attempt from re-deriving the existence
half. -/
theorem uniformBaseDivisor_of_exists_deg_le {d : ℤ}
    (h : ∀ (κ : Type u) [Field κ] [Algebra k κ],
      letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
        .ofHom (Scheme.baseChangeField C κ).hom
      haveI : SmoothOfRelativeDimension 1
          ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
        inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
      ∃ D₀ : (Scheme.baseChangeField C κ).left.CurveDivisor,
        Subsingleton
            (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D₀) 1)
          ∧ Scheme.CurveDivisor.deg κ D₀ ≤ d) :
    UniformBaseDivisor C d :=
  fun κ _ _ => h κ

end BaseDivisor

end AlgebraicGeometry
