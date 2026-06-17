/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RiemannRoch.WeilDivisor
import AlgebraicJacobian.RiemannRoch.OcOfD

/-!
# The Riemann–Roch formula in genus zero (RR.2)

This file is the **RR.2** file-skeleton sub-build chapter for the project's
headline `genusZero_curve_iso_P1` (the "smooth proper geometrically
irreducible genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma in
`AlgebraicJacobian.AbelianVarietyRigidity`).

The Hartshorne IV.1.3.5 chain for the genus-`0` ↦ `ℙ¹` classification routes
through:

- `RR.1` (`RiemannRoch_WeilDivisor.tex` / `WeilDivisor.lean`): the Weil
  divisor group `Div(C)` and the degree map `deg : Div(C) → ℤ`.
- **`RR.2` (this file, `RiemannRoch_RRFormula.tex`)**: the Riemann–Roch
  dimension formula `ℓ(D) = deg(D) + 1` in genus `0` (with `deg D ≥ 0`),
  via the auxiliary Euler-characteristic identity
  `χ(𝒪_C(D)) = deg(D) + 1 − g`.
- `RR.3` (`RiemannRoch_OcOfD.tex`, future): the invertible sheaf
  `𝒪_C(D)`, the linear-equivalence isomorphism `𝒪_C(D) ≅ 𝒪_C(D')` for
  `D ∼ D'`, and the `H¹`-vanishing input
  `H¹(C, 𝒪_C(D)) = 0` for `deg D ≥ 0` on a genus-`0` curve.
- `RR.4` (`RiemannRoch_RationalIsoP1.tex`, future): the "two-section
  ⇒ `Proj.fromOfGlobalSections` ⇒ `≅ ℙ¹`" classification.

## Status (iter-174 Lane F file-skeleton)

This file is the **iter-174 Lane F** file-skeleton: each of the four pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/RiemannRoch_RRFormula.tex`). The
Euler-characteristic carrier definition is concrete (a one-line subtraction
of `H⁰` and `H¹` `Module.finrank`s, mirroring the `genus` definition of
`AlgebraicJacobian.Genus`); the remaining pins carry `sorry` bodies whose
closure is iter-175+ work after the sibling chapters `RR.3`
(`RiemannRoch_OcOfD.tex`) and `RR.4` (`RiemannRoch_RationalIsoP1.tex`) land.

The 4 pinned declarations are:

1. `AlgebraicGeometry.Scheme.eulerCharacteristic` — Euler characteristic
   `χ(𝓕) = dim_{k̄} H⁰(C, 𝓕) − dim_{k̄} H¹(C, 𝓕)` of a `ModuleCat k̄`-valued
   sheaf on `C` (the curve specialisation of the alternating sum, since
   `H^i = 0` for `i ≥ 2` on a one-dimensional scheme by Grothendieck
   vanishing).
2. `AlgebraicGeometry.Scheme.WeilDivisor.l` — the `ℓ`-invariant
   `ℓ(D) = dim_{k̄} H⁰(C, 𝒪_C(D))` of a Weil divisor `D`.
3. `AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`
   — the Euler-characteristic identity `χ(𝒪_C(D)) = deg(D) + 1 − g` for
   every `D ∈ Div(C)` on a smooth proper geometrically irreducible curve
   `C / k̄` of genus `g = g(C)`.
4. `AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero`
   — the Riemann–Roch formula in genus `0`: `ℓ(D) = deg(D) + 1` for any
   Weil divisor `D ∈ Div(C)` with `deg D ≥ 0` on a smooth proper
   geometrically irreducible curve `C / k̄` with `g(C) = 0` (threading
   the `H¹`-vanishing of `𝒪_C(D)` explicitly as a named premise until
   `RR.3` lands).

## Note on `𝒪_C(D)` (the invertible sheaf of a divisor)

The chapter's proof of `eulerCharacteristic_eq_degree_plus_one_minus_genus`
and the statement of `l_eq_degree_plus_one_of_genus_zero` both reference
the line bundle `𝒪_C(D)` of a Weil divisor `D`. Mathlib `b80f227` ships no
`Scheme.lineBundleOfDivisor` (the closest is `WeierstrassCurve.lineBundle`
in the elliptic-curve formalisation), and the project-side construction of
`𝒪_C(D)` is queued for `RR.3` (`RiemannRoch_OcOfD.tex`). To keep the type
signatures of pins 2–4 substantive in the iter-174 skeleton, we expose a
**typed-`sorry` placeholder**
`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` that pairs each divisor with
the `ModuleCat k̄`-valued sheaf carrier `𝒪_C(D)` is intended to occupy. The
iter-175+ closure of `RR.3` replaces this placeholder's body with the
honest invertible-sheaf construction; the present pins consume it only
through its `H⁰` and `H¹` cohomology, so the consumer signatures are
substantive in the type sense (each asserts an arithmetic identity on the
finiteness-of-`H^*` outputs).

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_RRFormula.tex` (Hartshorne
IV.1 verbatim quotes; 4 pins).
Source: Hartshorne, *Algebraic Geometry*, IV §1 (pp. 294–297), Theorem 1.3
(Riemann–Roch) and Example 1.3.5 (genus-`0` specialisation). Stacks Project
tags 0BSC (Euler characteristic on a curve), 0AYO (Riemann–Roch).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The Euler characteristic of a coherent sheaf on a curve -/

/-- **Euler characteristic of a `ModuleCat k`-valued sheaf on a smooth proper
curve `C / k̄`.**

On a curve (one-dimensional scheme), Grothendieck vanishing
(Hartshorne III.2.7) gives `H^i(C, 𝓕) = 0` for `i ≥ 2`, so the classical
alternating sum
`χ(𝓕) = Σ_{i ≥ 0} (-1)^i dim_{k̄} H^i(C, 𝓕)` collapses to the two-term
expression
`χ(𝓕) = dim_{k̄} H⁰(C, 𝓕) − dim_{k̄} H¹(C, 𝓕)`.

This is the definition we ship. Coherence of `𝓕` on the proper `k̄`-scheme
`C` guarantees that both `H⁰` and `H¹` are finite-dimensional `k̄`-vector
spaces (Serre's coherent-cohomology finiteness theorem, the same
finiteness backing `AlgebraicGeometry.genus`), so the two `Module.finrank`s
are honest natural numbers and the difference is a well-defined integer.

The `Module k̄`-valued cohomology pipeline is the project's
`Scheme.HModule` (iter-009), the same wrapper used by
`AlgebraicGeometry.genus`.

Blueprint reference: `def:eulerChar_curve`
(Hartshorne IV.1 p. 295, displayed inside the proof of Theorem 1.3). -/
noncomputable def Scheme.eulerCharacteristic
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom]
    (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar)) : ℤ :=
  (Module.finrank kbar (Scheme.HModule kbar F 0) : ℤ)
    - (Module.finrank kbar (Scheme.HModule kbar F 1) : ℤ)

/-! ## §2. The invertible sheaf `𝒪_C(D)` of a Weil divisor (sibling chapter)

The honest construction of `𝒪_C(D)` lives in the sibling chapter `RR.3`
(`RiemannRoch_OcOfD.tex`, `AlgebraicJacobian/RiemannRoch/OcOfD.lean`),
where the locally-principal ideal sheaves of closed points are glued
into an invertible `𝒪_C`-module. **iter-183 Lane K** opened that file
with the typed-`sorry` pin `Scheme.WeilDivisor.sheafOf` plus the three
immediate corollaries `sheafOf_zero`, `sheafOf_singlePoint`, and
`sheafOf_ses_single_add`. **iter-183 Lane H** (this file) retires the
former local `sheafOf` typed-`sorry` placeholder (previously at L168 in
the iter-174 skeleton) by importing `OcOfD.lean`; downstream pins (the
`ℓ`-invariant, the χ-identity, the genus-`0` Riemann–Roch formula) now
reference the chapter's canonical `sheafOf` directly. -/

namespace Scheme.WeilDivisor

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]

/-! ## §3. The `ℓ`-invariant of a Weil divisor -/

/-- **The `ℓ`-invariant of a Weil divisor `D` on a smooth proper curve
`C / k̄`.**

By definition,
`ℓ(D) := dim_{k̄} H⁰(C, 𝒪_C(D)) ∈ ℕ`,
the `k̄`-dimension of the space of global sections of the invertible sheaf
`𝒪_C(D)` associated to `D`. Finiteness of `ℓ(D)` is a consequence of the
coherent-cohomology finiteness theorem on a proper `k̄`-scheme
(Hartshorne II.5.19 / III.5.2), the same input that backs the finiteness
of `genus C`.

The classical *complete linear system* `|D|` has `k̄`-projective dimension
`ℓ(D) − 1`; the chapter never uses this projective interpretation —
`ℓ(D)` is the only quantity consumed by the Hartshorne IV.1.3.5 chain.

Blueprint reference: `def:l_invariant` (Hartshorne IV.1 p. 295,
"We denote `dim_k H⁰(X, 𝒪(D))` by `l(D)`"). -/
noncomputable def l (D : C.left.WeilDivisor) : ℕ :=
  Module.finrank kbar (Scheme.HModule kbar (sheafOf (C := C) D) 0)

end Scheme.WeilDivisor

/-! ## §4. The χ-identity: `χ(𝒪_C(D)) = deg(D) + 1 − g`

The bridge from the structural Euler characteristic to the arithmetic
degree of a divisor. Hartshorne IV.1 Theorem 1.3 reduces Riemann–Roch to
this identity; the proof is the inductive `D ↔ D + [P]` step (additivity
of χ on the closed-point short exact sequence, with base case `D = 0`
giving `χ(𝒪_C) = 1 − g` from `dim H⁰(C, 𝒪_C) = 1` and the definition of
the genus). The closure of the body is iter-175+ work after the
`Euler-characteristic additivity on a short exact sequence`-style
project-side helper is supplied and the `RR.3` sheaf `𝒪_C(D)` has a
body.

**Iter-181 Lane H factoring.** Both Hartshorne IV.1.3 inputs (the base
case `χ(𝒪_C) = 1 − g` and the inductive step `χ(𝒪_C(D + Y)) = χ(𝒪_C(D))
+ n`) intrinsically reference the body of `Scheme.WeilDivisor.sheafOf`,
which is still a typed-`sorry` placeholder waiting on the sibling
chapter `RR.3` (`RiemannRoch_OcOfD.tex`). We therefore factor the proof
into two named substantive helper lemmas (3-tier disclosure: **honest
named-sorry helpers** — each helper has a substantive type encoding a
nontrivial mathematical claim about the `sheafOf` line bundle whose
closure is downstream of the `RR.3` body):

1. `eulerCharacteristic_sheafOf_zero` — base case `χ(sheafOf 0) = 1 − g`,
   which on closure of `RR.3` reduces to `sheafOf 0 = toModuleKSheaf C`
   plus the Hartshorne I.3.4 input `dim_{k̄} H⁰(C, 𝒪_C) = 1` plus the
   definition of the genus.
2. `eulerCharacteristic_sheafOf_single_add` — inductive step
   `χ(sheafOf (Finsupp.single Y n + D)) = χ(sheafOf D) + n` for any
   `Y : C.left.PrimeDivisor` and `n : ℤ`. On closure of `RR.3` this
   reduces to the Hartshorne IV.1.3 SES additivity argument iterated
   `|n|` times (with sign for `n < 0`).

The main theorem then closes by induction on the `Finsupp`-structure of
`D : C.left.WeilDivisor` (via `Finsupp.induction`), using the two
helpers and the additivity of `Scheme.WeilDivisor.degree`. -/

/-- **Hartshorne I.3.4 bridge** (Lane H helper A — iter-183).
On a smooth proper geometrically irreducible curve `C / k̄`, the global
sections of the structure sheaf form a one-dimensional `k̄`-vector space:
`dim_{k̄} H⁰(C, 𝒪_C) = 1`.

This is the Hartshorne~I.3.4 statement "for any projective variety `X`
over an algebraically closed field `k`, `H⁰(X, 𝒪_X) ≅ k`" specialised to
the project's `ModuleCat k̄`-flavoured cohomology pipeline
(`Scheme.HModule kbar (Scheme.toModuleKSheaf C) 0`). The closure lives
in the project's `Cohomology_StructureSheafModuleK` chapter (the H⁰
bridge from the constant-sheaf adjunction) and is gated on the
remaining cohomology-API work in that file.

**iter-183 Lane H status** — Tier-3 honest typed sorry. Body iter-184+
via the `Cohomology_StructureSheafModuleK` H⁰-bridge. -/
private theorem Scheme.finrank_H0_toModuleKSheaf_eq_one
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left] :
    Module.finrank kbar
        (Scheme.HModule kbar (Scheme.toModuleKSheaf C) 0) = 1 := by
  -- Step 1: H⁰-bridge LinearEquiv chain (existing project infrastructure).
  -- `HModule kbar (toModuleKSheaf C) 0` is identified, step by step, with
  -- the underlying global-sections ring `C.left.presheaf.obj (op ⊤)` via:
  --   `HModule_zero_linearEquiv`         -- Ext₀ ≃ Hom from constant sheaf;
  --   `constantSheafGammaHom_linearEquiv` -- constant-sheaf-Γ adjunction;
  --   `homFromOne_linearEquiv`            -- Hom-from-`k` evaluation at `1`;
  --   `SheafGammaObj_linearEquiv_top`     -- `Sheaf.Γ` reads the top section.
  let LE1 :=
    Scheme.HModule_zero_linearEquiv kbar (Scheme.toModuleKSheaf C)
  let LE2 :=
    AlgebraicGeometry.Scheme.constantSheafGammaHom_linearEquiv kbar
      (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.of kbar kbar)
      (Scheme.toModuleKSheaf C)
  let LE3 :=
    AlgebraicGeometry.Scheme.homFromOne_linearEquiv kbar
      ((Sheaf.Γ (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)).obj (Scheme.toModuleKSheaf C))
  let LE4 :=
    AlgebraicGeometry.Scheme.SheafGammaObj_linearEquiv_top kbar
      (Scheme.toModuleKSheaf C)
  let LE := ((LE1.trans LE2).trans LE3).trans LE4
  rw [LE.finrank_eq]
  -- Step 2: `(toModuleKSheaf C).obj.obj (op ⊤)` is definitionally
  -- `ModuleCat.of kbar (C.left.presheaf.obj (op ⊤))` (per `toModuleKPresheaf_obj`),
  -- so we transport to the global-sections ring and apply
  -- `Module.finrank_of_bijective_algebraMap` + `IsAlgClosed.algebraMap_bijective_of_isIntegral`.
  -- Convert the ModuleCat coercion to the underlying global sections ring.
  change Module.finrank kbar
      (C.left.presheaf.obj
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))) = 1
  -- Module-finiteness via the iter-044 Stein input.
  haveI hFin : Module.Finite kbar
      (C.left.presheaf.obj
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))) :=
    AlgebraicGeometry.Scheme.module_finite_globalSections_of_isProper kbar C
  -- Integrality of `C.left` propagates to the global sections being a domain
  -- (`IsIntegral.component_integral`), with the nonempty side-condition
  -- discharged from `IsIntegral.nonempty`.
  haveI hNECurve : Nonempty C.left.toTopCat :=
    AlgebraicGeometry.IsIntegral.nonempty
  -- `component_integral` requires `[Nonempty ↥↑U]` for the open `U = ⊤`; supply
  -- it inline via the curve nonemptiness, sidestepping the `↥↑` / `↑↑` coercion
  -- spelling mismatch that defeats `haveI`-based instance registration.
  haveI hDom : IsDomain
      (C.left.presheaf.obj
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))) :=
    @AlgebraicGeometry.IsIntegral.component_integral
      C.left _ (⊤ : TopologicalSpace.Opens C.left.toTopCat)
      ⟨⟨hNECurve.some, Set.mem_univ _⟩⟩
  -- `Module.Finite kbar A` → `Algebra.IsIntegral kbar A` (auto-instance).
  -- Then `IsAlgClosed` + integrality + domain ⇒ algebraMap is bijective ⇒ finrank = 1.
  exact Module.finrank_of_bijective_algebraMap
    (IsAlgClosed.algebraMap_bijective_of_isIntegral (k := kbar)
      (K := C.left.presheaf.obj
        (Opposite.op (⊤ : TopologicalSpace.Opens C.left.toTopCat))))

/-- **χ-additivity at a closed-point skyscraper extension** (Lane H sub-helper —
iter-185).

Substantive packaging of the three Hartshorne IV.1.3 inputs into a single
named Tier-3 typed sorry, scoped to the precise SES shape consumed by
`Scheme.eulerCharacteristic_sheafOf_succ`. Given:

* a short exact sequence `0 → F → G → H → 0` of `ModuleCat kbar`-valued sheaves
  on the curve `C` (`hSE : S.ShortExact`),
* an isomorphism witness identifying `S.X₃` with the closed-point skyscraper
  `skyscraperSheaf P.point (ModuleCat.of kbar kbar)` (`h13`),

we conclude `χ(S.X₂) = χ(S.X₁) + 1`.

The body bundles:

1. χ-additivity on a short-exact sequence of coherent sheaves: from the long
   exact sequence of cohomology
   `H⁰(F) → H⁰(G) → H⁰(H) → H¹(F) → H¹(G) → H¹(H) → H²(F) → ...`
   together with Grothendieck vanishing on a curve (`H^i = 0` for `i ≥ 2`),
   apply the finite-rank alternating-sum identity to get
   `χ(G) = χ(F) + χ(H)`.
2. Iso-invariance of `Scheme.eulerCharacteristic`: `S.X₃ ≅ k(P)` lifts to
   `Module.finrank` equalities on each `HModule` carrier, so χ transports
   across the iso witness.
3. χ of the closed-point skyscraper: `H⁰(C, k(P)) ≅ kbar` (the stalk at `P`)
   gives finrank 1, and `H¹(C, k(P)) = 0` (skyscraper cohomology vanishes
   above degree 0), so `χ(k(P)) = 1`.

**iter-185 Lane H status** — Tier-3 honest typed sorry. The body assembly
depends on (a) the project-side LES carrier for `ModuleCat kbar`-valued
sheaves (queued downstream of `Cohomology/MayerVietorisCore.lean`), and
(b) the project-side skyscraper-cohomology bridge (currently unsupplied at
Mathlib `b80f227` for the `ModuleCat`-flavoured constant-sheaf-Γ setup; the
existing `instIsHModuleHomFinite_toModuleKSheaf` template would lift). -/
private theorem Scheme.eulerCharacteristic_of_shortExact_skyscraper
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (S : CategoryTheory.ShortComplex
      (Sheaf (Opens.grothendieckTopology C.left.toTopCat)
        (ModuleCat.{u} kbar)))
    (_hSE : S.ShortExact)
    (P : C.left.PrimeDivisor)
    [∀ (U : TopologicalSpace.Opens C.left), Decidable (P.point ∈ U)]
    (_h13 : Nonempty (S.X₃ ≅ skyscraperSheaf (C := ModuleCat.{u} kbar)
      P.point (ModuleCat.of kbar kbar))) :
    Scheme.eulerCharacteristic C S.X₂
      = Scheme.eulerCharacteristic C S.X₁ + 1 := by
  sorry

private theorem Scheme.eulerCharacteristic_sheafOf_succ
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.PrimeDivisor →₀ ℤ) (Y : C.left.PrimeDivisor) :
    Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) (Finsupp.single Y 1 + D))
      = Scheme.eulerCharacteristic C
          (Scheme.WeilDivisor.sheafOf (C := C) D) + 1 := by
  classical
  -- Unpack the Hartshorne IV.1.3 closed-point SES from `RR.3`
  -- (Lane K typed-sorry `OcOfD.sheafOf_ses_single_add`):
  --   0 → 𝒪_C(D) → 𝒪_C(single Y 1 + D) → k(Y) → 0
  obtain ⟨S, hSE, hX1, hX2, h13⟩ :=
    Scheme.WeilDivisor.sheafOf_ses_single_add (C := C) D Y
  -- Apply the packaged χ-additivity-with-skyscraper helper to convert the SES
  -- into an arithmetic identity at the χ level.
  have hχ :=
    Scheme.eulerCharacteristic_of_shortExact_skyscraper C S hSE Y h13
  -- Rewrite the X₁/X₂ identifications back to `sheafOf` to obtain the goal.
  rw [hX1, hX2] at hχ
  exact hχ

/-- **Base case of the χ-identity** (iter-183 Lane H): on a smooth
proper geometrically irreducible curve `C / k̄`, the Euler characteristic
of the structure-sheaf-side line bundle `sheafOf 0` is `1 − g(C)`.

The proof rewrites `sheafOf 0 = toModuleKSheaf C` (the chapter
`RiemannRoch_OcOfD.tex` `sheafOf_zero` lemma), unfolds the
two-term `eulerCharacteristic`, and combines `dim H⁰(C, 𝒪_C) = 1`
(`Scheme.finrank_H0_toModuleKSheaf_eq_one`) with the definitional
unfold `genus C = dim H¹(C, 𝒪_C)`.

**iter-183 Lane H status** — body assembled axiom-clean modulo
`OcOfD.sheafOf_zero` (Lane K typed sorry) and the H⁰ bridge typed
sorry; both gated on iter-184+ infrastructure. -/
private theorem Scheme.eulerCharacteristic_sheafOf_zero
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left] :
    Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) (0 : C.left.WeilDivisor))
      = 1 - (AlgebraicGeometry.genus C : ℤ) := by
  rw [Scheme.WeilDivisor.sheafOf_zero (C := C)]
  unfold Scheme.eulerCharacteristic
  rw [Scheme.finrank_H0_toModuleKSheaf_eq_one C]
  simp [AlgebraicGeometry.genus]

/-- **Inductive step of the χ-identity** (iter-183 Lane H): on a smooth
proper geometrically irreducible curve `C / k̄`, the Euler characteristic
of `sheafOf` transports across the elementary modification
`D ↦ Finsupp.single Y n + D` with arithmetic increment `n`. The argument
`D` carries the underlying `Finsupp` type rather than `Scheme.WeilDivisor`
so that the `Finsupp.single Y n + D` term elaborates cleanly; the result
is consumed via the definitional equality `WeilDivisor = (PrimeDivisor →₀
ℤ)`.

The body inducts on `n : ℤ` via `Int.induction_on`:
- `n = 0`: `Finsupp.single Y 0 = 0`, so `single Y 0 + D = D`.
- `n = k + 1` (positive direction): rewrite
  `single Y (k+1) + D = single Y 1 + (single Y k + D)`
  via `Finsupp.single_add`, apply
  `Scheme.eulerCharacteristic_sheafOf_succ`, then the inductive
  hypothesis.
- `n = -(k+1)` (negative direction): apply
  `Scheme.eulerCharacteristic_sheafOf_succ` to
  `D' := single Y (-(k+1)) + D` and simplify; the LHS `single Y 1 + D'`
  rewrites to `single Y (-k) + D` via `Finsupp.single_add` and
  arithmetic, giving the identity backwards from the inductive
  hypothesis at `-k`.

**iter-183 Lane H status** — body sorry-free assembly modulo the
`_succ` typed-sorry helper. Once `_succ` closes iter-184+, this lemma
upgrades to Tier-1. -/
private theorem Scheme.eulerCharacteristic_sheafOf_single_add
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.PrimeDivisor →₀ ℤ) (Y : C.left.PrimeDivisor) (n : ℤ) :
    Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) (Finsupp.single Y n + D))
      = Scheme.eulerCharacteristic C
          (Scheme.WeilDivisor.sheafOf (C := C) D) + n := by
  refine Int.induction_on (motive := fun m : ℤ =>
      Scheme.eulerCharacteristic C
          (Scheme.WeilDivisor.sheafOf (C := C) (Finsupp.single Y m + D))
        = Scheme.eulerCharacteristic C
            (Scheme.WeilDivisor.sheafOf (C := C) D) + m) n ?_ ?_ ?_
  · -- n = 0
    simp
  · -- positive step: motive (↑k) → motive (↑k + 1)
    intro k ih
    have hsplit :
        (Finsupp.single Y ((k : ℤ) + 1) + D : C.left.PrimeDivisor →₀ ℤ)
          = Finsupp.single Y 1 + (Finsupp.single Y (k : ℤ) + D) := by
      rw [show ((k : ℤ) + 1) = (1 + (k : ℤ)) from by ring,
        Finsupp.single_add, add_assoc]
    have hstep := Scheme.eulerCharacteristic_sheafOf_succ
      C (Finsupp.single Y (k : ℤ) + D) Y
    have h1 : Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C)
          (Finsupp.single Y ((k : ℤ) + 1) + D))
        = Scheme.eulerCharacteristic C
            (Scheme.WeilDivisor.sheafOf (C := C)
              (Finsupp.single Y 1 + (Finsupp.single Y (k : ℤ) + D))) :=
      congrArg (fun e => Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) e)) hsplit
    linarith [h1, hstep, ih]
  · -- negative step: motive (-↑k) → motive (-↑k - 1)
    intro k ih
    have hsplit :
        (Finsupp.single Y (-(k : ℤ)) + D : C.left.PrimeDivisor →₀ ℤ)
          = Finsupp.single Y 1 +
              (Finsupp.single Y (-(k : ℤ) - 1) + D) := by
      rw [← add_assoc, ← Finsupp.single_add]
      congr 2
      ring
    have hpred := Scheme.eulerCharacteristic_sheafOf_succ
      C (Finsupp.single Y (-(k : ℤ) - 1) + D) Y
    -- hpred: χ(sheafOf (single Y 1 + (single Y (-k-1) + D))) = χ(sheafOf (single Y (-k-1) + D)) + 1
    -- Combine via hsplit and congr 1 to bridge dot-notation vs full-name display:
    have key : Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) (Finsupp.single Y (-(k : ℤ)) + D))
        = Scheme.eulerCharacteristic C
            (Scheme.WeilDivisor.sheafOf (C := C)
              (Finsupp.single Y 1 + (Finsupp.single Y (-(k : ℤ) - 1) + D))) :=
      congrArg (fun e => Scheme.eulerCharacteristic C
        (Scheme.WeilDivisor.sheafOf (C := C) e)) hsplit
    -- ih: χ(sheafOf (single Y (-k) + D)) = χ(sheafOf D) + (-k)
    -- key: χ(sheafOf (single Y (-k) + D)) = χ(sheafOf (single Y 1 + (single Y (-k - 1) + D)))
    -- hpred: χ(sheafOf (s Y 1 + (s Y (-k-1) + D))) = χ(sheafOf (s Y (-k-1) + D)) + 1
    -- Goal: χ(sheafOf (single Y (-k - 1) + D)) = χ(sheafOf D) + (-k - 1)
    linarith [key, hpred, ih]

/-- **Euler-characteristic identity for `𝒪_C(D)` on a smooth proper curve
of genus `g`.**

For every Weil divisor `D ∈ Div(C)`,
`χ(𝒪_C(D)) = deg(D) + 1 − g(C)`.

The proof is Hartshorne IV.1 Theorem 1.3's reduction: induction on the
free-abelian-group structure of `Div(C)` on closed points, base case `D =
0` giving `χ(𝒪_C) = 1 − g` (the `dim H⁰(C, 𝒪_C) = 1` is the Hartshorne
I.3.4 input via the project's `H⁰`-bridge), and inductive step via
additivity of χ on the closed-point short exact sequence
`0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0`.

Blueprint reference: `thm:euler_char_eq_deg_plus_one_minus_genus`
(Hartshorne IV.1 Theorem 1.3, p. 295).

**Iter-181 Lane H status** — the main theorem is closed by induction on
the `Finsupp` structure of `D`, consuming the two `sheafOf`-side helper
sorries `eulerCharacteristic_sheafOf_zero` (base case) and
`eulerCharacteristic_sheafOf_single_add` (inductive step). The body
itself is honest; its `sorryAx`-transitivity is the inevitable
consequence of `sheafOf` still being a typed sorry waiting on `RR.3`. -/
theorem Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.WeilDivisor) :
    Scheme.eulerCharacteristic C (Scheme.WeilDivisor.sheafOf (C := C) D)
      = (Scheme.WeilDivisor.degree D) + 1 - (AlgebraicGeometry.genus C : ℤ) := by
  -- Unfold `WeilDivisor` to expose the underlying `Finsupp` structure so
  -- `Finsupp.induction` applies directly.
  unfold Scheme.WeilDivisor at D
  induction D using Finsupp.induction with
  | zero =>
    -- D = 0: χ(sheafOf 0) = 1 - g by helper 1, and degree 0 = 0.
    exact (Scheme.eulerCharacteristic_sheafOf_zero C).trans
      (by simp [Scheme.WeilDivisor.degree])
  | single_add Y n D' _hY _hn hD' =>
    -- D = single Y n + D': use helper 2 then the inductive hypothesis.
    rw [Scheme.eulerCharacteristic_sheafOf_single_add, hD']
    -- Goal: (degree D' + 1 - g) + n = degree (single Y n + D') + 1 - g.
    have hdeg : Scheme.WeilDivisor.degree
        ((Finsupp.single Y n + D' : C.left.WeilDivisor))
        = n + Scheme.WeilDivisor.degree D' := by
      change ((Finsupp.single Y n + D' : C.left.PrimeDivisor →₀ ℤ)).sum
          (fun _ z => z) = _
      classical
      rw [Finsupp.sum_add_index (fun _ _ => rfl) (fun _ _ _ _ => rfl)]
      simp [Finsupp.sum_single_index]
      rfl
    linarith

/-! ## §5. The Riemann–Roch formula in genus zero -/

/-- **Riemann–Roch in genus zero (Hartshorne IV.1 Example 1.3.5).**

Let `C` be a smooth proper geometrically irreducible curve over the
algebraically closed field `k̄` with `g(C) = 0`, and let `D ∈ Div(C)` with
`deg D ≥ 0`. Then
`ℓ(D) = deg(D) + 1`.

The proof specialises the χ-identity
`eulerCharacteristic_eq_degree_plus_one_minus_genus` to `g = 0`,
unfolds `χ` via `def:eulerChar_curve`, and absorbs the `H¹`-vanishing
hypothesis (named premise `_hH1`: `H¹(C, 𝒪_C(D)) = 0`, which is the
`H¹`-vanishing of a non-negative-degree invertible sheaf on a
genus-`0` curve, to be discharged by `RR.3` once `𝒪_C(D)` has a body and
the cohomology of `𝒪_{ℙ¹}(d)` is computed).

Blueprint reference: `thm:riemannRoch_genus_zero` (Hartshorne IV.1
Example 1.3.5, p. 297). -/
theorem Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.WeilDivisor) (_hg : AlgebraicGeometry.genus C = 0)
    (_hdeg : (0 : ℤ) ≤ Scheme.WeilDivisor.degree D)
    (_hH1 : Module.finrank kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) 1) = 0) :
    (Scheme.WeilDivisor.l (C := C) D : ℤ)
      = Scheme.WeilDivisor.degree D + 1 := by
  have h := Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus C D
  simp only [Scheme.eulerCharacteristic, _hg, _hH1,
    Nat.cast_zero, sub_zero] at h
  exact h

end AlgebraicGeometry
