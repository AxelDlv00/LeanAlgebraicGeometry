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

**The second route is the live one, and `finrank_stabilisationAmbient_eq_h1` below is the
measurement that makes it concrete.**  `n₀(κ)` is produced by
`Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top` from a monotone chain `Aₙ` inside
`N = 𝒪(D)(V₀ ⊓ V₁)`, and the quotient it stabilises in is *exactly* `H¹(𝒪(D + n·F))` — so at
`D = 0` the ambient has dimension `genus C_κ = genus C`, the same number for every `κ`.  If the
chain strictly increased until it reached the top, `n₀ ≤ genus C` would follow at once and the
degree clause would close with `d := genus C · deg_κ F_κ`.

What is missing is **strictness**: a monotone chain in a `g`-dimensional space may repeat a term
without having reached `⊤`, and nothing in the tree rules that out for `Aₙ`.  So the honest
statement of the remaining obligation is either strictness of `n ↦ Aₙ` below the top, or any other
argument bounding `n₀` by a base-field-invariant quantity.  This is *not* claimed here, and the
bound `n₀ ≤ genus` must not be cited as available.

## HOW MUCH OF THIS IS NEW: almost none of it, and that is the honest label

A fresh-context audit of this module (2026-07-29) established, and this file records rather than
hides, that **it adds no new mathematics**:

* Both existence theorems **derive at the parent commit** — no new lemma, instance or import was
  needed. `exists_base_subsingleton_curve`'s proof is `Ledger/FiberBound.lean`'s
  `exists_bound_subsingleton_hModule_one_curve` with the final `exact` renamed to
  `exists_base_subsingleton_of_isFinite_toP1`; the instance prologue is identical.
* `uniformBaseDivisor_of_exists_deg_le` is **the identity**: its hypothesis is *definitionally*
  `UniformBaseDivisor C d` (`Iff.rfl` closes the equivalence), and its body is η-expansion. Its
  earlier description as "bookkeeping" was too generous — it separates the two clauses only
  typographically, since they were already conjuncts at `ExtensionUniformity.lean:356`.
* The re-pricing conclusion was **already in the tree**: `ExtensionUniformity.lean`'s
  `UniformBaseDivisor` docstring already said a `D₀` is supplied per field with no control of its
  degree.

What the round contributes is therefore the *correction of a downstream index that contradicted
that sentence* (`GenusFieldInvariance.lean` priced the residue as a missing production from
geometry confined to genus 0) and `finrank_stabilisationAmbient_eq_h1`, which locates the actual
obstruction. Read the theorems as a named restatement, not as progress on the degree clause —
that clause is untouched.

**One clause of the audit does not hold, and it is worth recording because it is the reason these
statements are not simply redundant.** The audit called the pre-existing
`ExtensionUniformity.vanishing_baseChangeField` (a *threshold* `b` past which every `D` of degree
`≥ b` has vanishing `H¹`) *strictly stronger*, hence this module a weakening. It does not imply
these statements without an extra input: extracting "some `D₀` vanishes" from a threshold needs a
divisor of degree `≥ b` to exist, i.e. `exists_deg_ge`, whose hypothesis is a non-generic point of
positive residue degree — and no closed point of `C` is available for free (verified: the
existential over `C.left` does not close). The two statements are therefore incomparable inputs,
not a chain, which is exactly why the existence clause needed stating at all.

## Contents

* `exists_base_subsingleton_curve` — over `k`, at every genus: a divisor with vanishing `H¹`.
* `exists_base_subsingleton_baseChangeField` — the same over every extension `κ/k`.
* `uniformBaseDivisor_of_exists_deg_le` — the residue isolated: a per-field vanishing divisor of
  *bounded degree* gives `UniformBaseDivisor`.  Recorded so the degree clause is the only thing a
  consumer has to supply, and deliberately **not** advertised as progress: it is the definition
  with the existence clause discharged, which is exactly what the two theorems above buy.
* `finrank_stabilisationAmbient_eq_h1` — where the next attempt should start: the space in which
  `n₀` is chosen has dimension `h¹(𝒪(D + n·F))`, so at `D = 0` it has dimension the *genus*,
  which is base-field-invariant.  A strictness argument for the chain would therefore bound `n₀`
  by `genus C` uniformly in `κ` and close the degree clause.  Strictness is **not** proved here
  and is the one missing step; see the declaration's docstring.
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

**This is the IDENTITY, not even bookkeeping — established by a fresh-context audit,
2026-07-29.**  Its hypothesis is *definitionally* `UniformBaseDivisor C d` (`Iff.rfl` closes the
equivalence) and its body `fun κ _ _ => h κ` is η-expansion.  An earlier version of this docstring
called it "bookkeeping rather than progress", which was still too generous: the two clauses were
already conjuncts at `ExtensionUniformity.lean:356`, so this separates them typographically and in
no other sense.

Kept, rather than deleted, only as a signpost — a reader after the degree clause can see from the
statement that the vanishing half is discharged by `exists_base_subsingleton_baseChangeField` and
that `CurveDivisor.deg κ D₀ ≤ d` is all that remains.  Do not cite it as content. -/
theorem uniformBaseDivisor_of_exists_deg_le {d : ℤ}
    (h : ∀ (κ : Type u) [Field κ] [Algebra k κ],
      -- the per-field vanishing divisor, with its degree bounded — the open clause
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

/-! ## Where the degree clause should be attacked

One measurement, isolating the quantity a bound on `n₀` would have to control. -/

section Stabilisation

open Scheme

attribute [local instance] Scheme.functionFieldOverModule Scheme.overModule

variable {K : Type u} [Field K] {Y : Scheme.{u}} [IsIntegral Y]
  [Y.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))]
  (π : Y ⟶ P1 K) [IsDominant π] [IsAffineHom π]

/-- **The stabilisation happens in a space of dimension `h¹`** — the measurement that says where
the degree clause should be attacked.

`n₀` is produced by `Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top` applied to the
fibre-lattice chain `Aₙ` inside the fixed ambient `N = 𝒪(D)(V₀ ⊓ V₁)`.  This records that the
quotient it stabilises in is *exactly* the twisted `H¹`, so its dimension is `h¹(𝒪(D + n·F))` —
and at `D = 0` that is `h¹(𝒪) = genus`, **the same number over every base field**
(`Ledger/GenusFieldInvariance.genus_baseChangeField_curve`).

So a bound `n₀ ≤ genus C` would close the degree clause of `UniformBaseDivisor` with
`d := genus C · deg_κ F_κ`, uniformly in `κ`.

**It does not follow from this, and the gap is precisely strictness.**  A monotone chain in a
`g`-dimensional space can repeat a term without having reached `⊤`, so bounded dimension alone
bounds nothing; one needs `Aₙ ⊊ Aₙ₊₁` while `Aₙ ≠ ⊤`.  Nothing in the tree proves that for the
fibre lattice.  Stated as a `finrank` identity and nothing more, so that the reduction is visible
without any part of it being asserted. -/
theorem finrank_stabilisationAmbient_eq_h1 (D : Y.CurveDivisor) (n : ℕ) :
    Module.finrank K
        (divisorSections K D (fiberChart₀ π ⊓ fiberChart₁ π) ⧸ fiberLatticeOverlap π D n)
      = Sheaf.h1 (Y.divisorSheaf K (D + n • fiberWeilDivisor π)) :=
  (LinearEquiv.finrank_eq (fiberLatticeH1Equiv π D n)).symm

end Stabilisation

end AlgebraicGeometry
