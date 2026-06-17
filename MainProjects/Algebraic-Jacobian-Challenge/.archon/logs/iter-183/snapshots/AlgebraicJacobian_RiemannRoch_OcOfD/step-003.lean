/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RiemannRoch.WeilDivisor
import AlgebraicJacobian.RiemannRoch.OCofP

/-!
# The invertible sheaf `𝒪_C(D)` of a Weil divisor (RR.2_*)

This file is the **RR.2_*** satellite sub-build chapter for the project's
headline `genusZero_curve_iso_P1` (the "smooth proper geometrically
irreducible genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma in
`AlgebraicJacobian.AbelianVarietyRigidity`).

Together with `RR.1` (`WeilDivisor.lean`), `RR.2`
(`RRFormula.lean`), `RR.3` (`OCofP.lean`), and `RR.4`
(`RationalCurveIso.lean`), the present chapter forms the four-stage
sub-build closing the project's headline **RR bridge**.

The Hartshorne IV.1.3.5 chain consumed by `genusZero_curve_iso_P1` of
`AbelianVarietyRigidity.lean` relies on the invertible-sheaf functor
`𝒪_C(-) : Div(C) → 𝐒𝐡(C, 𝐌𝐨𝐝_k̄)` sending a Weil divisor
`D = Σᵢ nᵢ · [Pᵢ]` to its associated invertible sheaf `𝒪_C(D)` on `C`.

This file hosts the four pinned declarations of the chapter
`RiemannRoch_OcOfD.tex`:

1. `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` — the invertible sheaf
   `𝒪_C(D)` of a Weil divisor `D` on a smooth proper curve `C / k̄`,
   realised as Hartshorne's subsheaf of the function-field constant
   sheaf `K_C` (II §6 p. 144). Replaces the iter-174 typed-`sorry`
   placeholder currently living at `RiemannRoch/RRFormula.lean:168`.
2. `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_zero` — the zero
   divisor `D = 0` gives the structure sheaf `𝒪_C(0) = 𝒪_C`.
3. `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_singlePoint` — the
   closed-point specialisation `𝒪_C([P]) = lineBundleAtClosedPoint P`
   of `RR.3` (`OCofP.lean`).
4. `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_ses_single_add` — the
   Hartshorne IV.1.3 inductive-step short exact sequence
   `0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0` consumed by Lane H's
   `RRFormula` induction.

## Status (iter-183 Lane K file-skeleton)

This file is the **iter-183 Lane K** file-skeleton: each declaration
carries the intended substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/RiemannRoch_OcOfD.tex`).
All bodies are `sorry`; the iter-184+ closure follows the recipe in
chapter §"Sheaf-property correctness" (subsheaf-of-`K_C` per-open
constraint set, identity-on-`K(C)` restrictions, sheaf property via
stalk-locality of the order conditions). The construction is
`noncomputable`.

**3-tier disclosure** (per iter-181 vocabulary): each of the four
declarations is a **Tier-3 honest typed sorry** — the body is a
substantive mathematical construction (Hartshorne subsheaf-of-`K_C`)
whose closure is iter-184+ work; the types encode genuine claims about
the invertible sheaf, its specialisations, and its SES additivity.

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_OcOfD.tex`.
Source: Hartshorne, *Algebraic Geometry*, II §6 pp. 144–145 (definition of
`ℒ(D)`; Propositions 6.13, 6.15, 6.18; Remark 6.17.1) and IV §1 p. 296
(the `D ↝ D + [Y]` SES). Stacks Project tags 02RW (Weil divisors),
0AUW (sheaf `𝒪_X(D)`), 0BE3 (degree-zero of a principal divisor).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopCat
open scoped Classical

namespace AlgebraicGeometry

/-! ## §1. The invertible sheaf `𝒪_C(D)` of a Weil divisor -/

namespace Scheme.WeilDivisor

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]

/-- **The invertible sheaf `𝒪_C(D)` of a Weil divisor `D` on a smooth
proper curve `C / k̄`** (Hartshorne II §6 p. 144, definition of `ℒ(D)`).

For a Weil divisor `D = Σ_Q n_Q · [Q] ∈ Div(C)` on a smooth proper
geometrically irreducible curve `C / k̄`, the invertible sheaf
`𝒪_C(D) := ℒ(D)` is the sub-`𝒪_C`-module of the function-field constant
sheaf `𝒦_C ≅ K(C)` (Hartshorne Proposition 6.15: on an integral scheme
the sheaf of total quotient rings is the constant sheaf at the function
field) defined section-wise on each open `U ⊆ C` as
`Γ(U, 𝒪_C(D)) = { f ∈ K(C) | f = 0 ∨ ord_Q(f) ≥ −n_Q ∀ prime divisor Q
∈ U }`, with restriction along `V ⊆ U` given by the identity on `K(C)`.

The signature returns a `Sheaf (Opens.grothendieckTopology C.left.toTopCat)
(ModuleCat.{u} kbar)`: the same `ModuleCat k̄`-flavoured sheaf carrier used
by the project's `Scheme.HModule` cohomology pipeline (so that `H⁰` and
`H¹` of `𝒪_C(D)` are accessible via
`Scheme.HModule kbar (sheafOf D) 0/1`).

**iter-183 Lane K status** — Tier-3 honest typed sorry. The iter-184+
body recipe (per chapter `RiemannRoch_OcOfD.tex` §"Sheaf-property
correctness"): per-open `Submodule kbar K(C)` cut out by the order
conditions (the closure proofs reduce to `Ring.ordFrac`-multiplicativity
and the non-archimedean inequality of the DVR valuation at each prime
divisor); presheaf functor via the identity-on-`K(C)` restriction; sheaf
property via gluing-by-stalks (stalk-locality of the order conditions at
each prime divisor). The construction parallels the project's existing
`Scheme.toModuleKPresheaf` / `toModuleKPresheaf_isSheaf` template in
`AlgebraicJacobian/Cohomology/StructureSheafModuleK/`.

**Coordination with `RRFormula.lean:168`.** The iter-174 typed-`sorry`
placeholder `Scheme.WeilDivisor.sheafOf` in `RRFormula.lean` is
slated to be retired (Lane H) by re-export of this declaration. Both
files compile in isolation; cross-imports are coordinated by Lane H.

Blueprint reference: `def:sheafOf` (Hartshorne II §6 p. 144;
Propositions 6.13, 6.15; Remark 6.17.1). -/
noncomputable def sheafOf (_D : C.left.WeilDivisor) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) :=
  sorry

/-! ## §2. Immediate corollaries -/

/-- **Sheaf of the zero divisor is the structure sheaf**
(chapter `RiemannRoch_OcOfD.tex`, Lemma `sheafOf_zero`).

At `D = 0` the coefficient `n_Q = 0` at every prime divisor `Q`, so the
section condition of `sheafOf` reduces to the standard
"non-negative-order = regular" identification of the structure sheaf on
an integral scheme (Hartshorne II §6 immediately before Proposition 6.11).
Both sides are sub-`𝒪_C`-modules of `𝒦_C` with identity restriction
maps, so the equality of presheaves promotes to an equality of sheaves
of `ModuleCat k̄`-modules.

**iter-183 Lane K status** — Tier-3 honest typed sorry. The body closes
on iter-184+ closure of `sheafOf` together with the standard `Γ(U, 𝒪_C)`
identification.

Blueprint reference: `lem:sheafOf_zero`. -/
lemma sheafOf_zero :
    sheafOf (C := C) (0 : C.left.WeilDivisor) = Scheme.toModuleKSheaf C := by
  sorry

/-- **Sheaf at a single closed point is the line bundle of `RR.3`**
(chapter `RiemannRoch_OcOfD.tex`, Lemma `sheafOf_singlePoint`).

For a closed point `P ∈ C` viewed as a Weil divisor `[P] ∈ Div(C)` via
`Scheme.WeilDivisor.ofClosedPoint`, the invertible sheaf `𝒪_C([P])` of
`sheafOf` agrees on the nose with the closed-point line bundle
`lineBundleAtClosedPoint P` of `RR.3` (`OCofP.lean`).

The agreement is by unfolding both definitions: at `D = [P]`, the order
conditions of `sheafOf` (`ord_Q(f) ≥ 0` for `Q ≠ P`, `ord_P(f) ≥ −1`)
are exactly those characterising sections of `lineBundleAtClosedPoint P`
(via `lineBundleAtClosedPoint_globalSections_iff` of `OCofP.lean`).

**iter-183 Lane K status** — Tier-3 honest typed sorry. Closes on
iter-184+ closure of both `sheafOf` and `lineBundleAtClosedPoint`.

Blueprint reference: `lem:sheafOf_singlePoint`. -/
lemma sheafOf_singlePoint (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1) :
    sheafOf (C := C) (ofClosedPoint P hP) =
      lineBundleAtClosedPoint (C := C) P hP hPcoh := by
  sorry

/-- **Short exact sequence for `D ↝ D + [P]`** (Hartshorne IV.1.3
inductive step, p. 296; chapter `RiemannRoch_OcOfD.tex`, Lemma
`sheafOf_ses_single_add`).

For a Weil divisor `D ∈ Div(C)` and a prime divisor `P` of `C`
(equivalently, a closed point on a smooth curve), the inclusion
`𝒪_C(D) ↪ 𝒪_C(D + [P])` of sub-`𝒪_C`-modules of `𝒦_C` fits into a short
exact sequence
`0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0`
in `Sh(C, 𝐌𝐨𝐝_k̄)`, where `k(P)` is the skyscraper sheaf at `P` with
stalk `k̄`.

The statement bundles the existence of a `ShortComplex` whose `X₁ ↦ X₂`
arm matches `sheafOf D ↪ sheafOf (Finsupp.single P 1 + D)` and that is
`ShortExact` (mono + epi + exact). The third term `X₃` is the
skyscraper `k(P)` — encoded here as a (nonempty) isomorphism class with
`Mathlib`'s `skyscraperSheaf` (decidability of `P.point ∈ U` supplied
classically). Lane H's `RRFormula` consumes this sequence via
χ-additivity to derive `χ(𝒪_C(D + [P])) = χ(𝒪_C(D)) + 1`.

**iter-183 Lane K status** — Tier-3 honest typed sorry. The iter-184+
body recipe (per chapter `RiemannRoch_OcOfD.tex` §"Immediate
corollaries", Beat 1 + Beat 2): build the ideal-sheaf SES
`0 → 𝒪_C(−[P]) → 𝒪_C → k(P) → 0`, tensor with `𝒪_C(D + [P])` (which is
locally free of rank 1, hence the tensor is exact), and identify the
three terms via `𝒪_C(−[P]) ⊗ 𝒪_C(D + [P]) ≅ 𝒪_C(D)` (Hartshorne 6.13(b)),
`𝒪_C ⊗ 𝒪_C(D + [P]) ≅ 𝒪_C(D + [P])` (tensor unit), and
`k(P) ⊗ 𝒪_C(D + [P]) ≅ k(P)` (rank-1 stalk at `P`).

The argument `D` carries the underlying `Finsupp` type rather than
`Scheme.WeilDivisor` so that the `Finsupp.single P 1 + D` term elaborates
cleanly (the addition is in the unambiguous Finsupp instance); the result
is consumed via the definitional equality `WeilDivisor = (PrimeDivisor →₀
ℤ)`, matching the pattern of `Scheme.eulerCharacteristic_sheafOf_single_add`
in `RRFormula.lean`.

Blueprint reference: `lem:sheafOf_ses_single_add` (Hartshorne IV.1, p. 296). -/
theorem sheafOf_ses_single_add
    (D : C.left.PrimeDivisor →₀ ℤ) (P : C.left.PrimeDivisor) :
    ∃ S : CategoryTheory.ShortComplex
        (Sheaf (Opens.grothendieckTopology C.left.toTopCat)
          (ModuleCat.{u} kbar)),
      S.ShortExact ∧
      S.X₁ = sheafOf (C := C) D ∧
      S.X₂ = sheafOf (C := C) (Finsupp.single P 1 + D) ∧
      Nonempty (S.X₃ ≅ skyscraperSheaf (C := ModuleCat.{u} kbar)
        P.point (ModuleCat.of kbar kbar)) := by
  sorry

end Scheme.WeilDivisor

end AlgebraicGeometry
