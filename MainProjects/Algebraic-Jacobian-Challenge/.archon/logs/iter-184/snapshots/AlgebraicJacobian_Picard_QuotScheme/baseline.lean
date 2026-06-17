/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The Quot scheme (A.2.b)

This file is the **A.2.b** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the
Grothendieck–Altman–Kleiman Quot-scheme construction
`Quot^{Φ,L}_{E/X/S}` — a projective `S`-scheme representing the functor of
`T`-flat coherent quotients of `E_T` on `X_T = X ×_S T` with Hilbert
polynomial `Φ` on every fiber — together with the in-project sub-build for
the Grassmannian *scheme* (Mathlib at the pinned commit carries only a
linear-algebra Grassmannian).

## Status (iter-176 Lane H file-skeleton — re-dispatch)

iter-175 Lane H died to the Anthropic session-limit reset window without
ever calling `Write` (the file was never created). iter-176 re-dispatches
the file-skeleton verbatim. Each of the six blueprint-pinned declarations
carries the *intended* substantive type signature (matching the
`\lean{...}` pin in `blueprint/src/chapters/Picard_QuotScheme.tex`) with a
`sorry` body. The bodies are iter-177+ work; the substantive proofs are
deep (Nitsure §5: boundedness ⟶ Grassmannian embedding ⟶ flattening
stratification ⟶ valuative criterion).

The 6 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.hilbertPolynomial` (def, ~5 LOC) — the
   **Hilbert polynomial function** `s ↦ Φ_{F,s} ∈ ℚ[λ]` of a coherent
   sheaf `F` on `X` over a finite-type `π : X ⟶ S` with respect to a
   line bundle `L`. Encoded as a function `S → Polynomial ℚ`.

2. `AlgebraicGeometry.Scheme.QuotFunctor` (def, ~6 LOC) — the **Quot
   functor** `Quot^{Φ,L}_{E/X/S} : (Sch/S)^op ⥤ Set` sending an
   `S`-scheme `T ⟶ S` to the set of equivalence classes
   `⟨F, q⟩` of pairs `(F, q)` with `F` a `T`-flat coherent sheaf on
   `X_T`, `q : E_T ↠ F` a surjection, and `F|_{X_t}` having Hilbert
   polynomial `Φ` at every `t ∈ T`.

3. `AlgebraicGeometry.Scheme.Grassmannian` (def, ~5 LOC) — the
   **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
   rank-`d` quotients of a locally free `O_S`-module `V`.

4. `AlgebraicGeometry.Scheme.Grassmannian.representable` (theorem, ~8 LOC)
   — the **representability of the Grassmannian** by a smooth projective
   `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`, equipped with
   the Plücker closed embedding into `ℙ_S(⋀^d V)`.

5. `AlgebraicGeometry.Scheme.QuotScheme` (theorem, ~10 LOC) — the
   **Grothendieck–Altman–Kleiman representability theorem** for the Quot
   functor: for a noetherian `S`, a projective `π : X ⟶ S`, a relatively
   very ample `L` on `X`, a coherent `E`, and `Φ ∈ ℚ[λ]`, the functor
   `Quot^{Φ,L}_{E/X/S}` is representable by a projective `S`-scheme.

6. `AlgebraicGeometry.flatBaseChangeCohomology` (theorem, ~10 LOC) — the
   **flat base-change theorem of cohomology** (Stacks tag 02KH): for a
   cartesian square with `g` flat and `f` quasi-compact quasi-separated,
   the canonical base-change map `g* (f_* F) ⟶ f'_* ((g')* F)` is an
   isomorphism. The current scaffold encodes the `i = 0` direct-image
   form (substantive content of (ii) of the Stacks 02KH statement); the
   `R^i f_*` form for `i ≥ 1` requires the higher-direct-image
   infrastructure not present at the pinned commit.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `hilbertPolynomial` returns `Polynomial ℚ` keyed by `s : S`, not
  `Unit`; the Hilbert polynomial is a non-trivial invariant of the
  coherent sheaf at the fiber over `s`.
- `QuotFunctor` and `Grassmannian` return contravariant functors into
  `Type u` — substantive presheaves of sets, not constant functors.
- `Grassmannian.representable` and `QuotScheme` package the
  `Functor.RepresentableBy` Yoneda-bijection structure: existence of a
  scheme `Y` together with a `RepresentableBy Y` witness — substantive
  content (a representable functor is determined by its representing
  object up to canonical isomorphism, and the witness is the data of
  that isomorphism family).
- `flatBaseChangeCohomology` produces a `Nonempty (... ≅ ...)` of an
  isomorphism between two `S'`-modules built via the pullback/pushforward
  bifunctor; the iso is non-trivial (it is `Stacks 02KH` content, not
  the identity-on-the-same-object iso `Iso.refl _`).

## Mathlib status

Mathlib (master `b80f227`) provides:
- `AlgebraicGeometry.Scheme.Modules` (the category `X.Modules`),
- `Scheme.Modules.pullback`, `Scheme.Modules.pushforward` (the
  pullback–pushforward adjunction at level `i = 0`),
- `CategoryTheory.IsPullback` for cartesian squares,
- `CategoryTheory.Functor.RepresentableBy` for representable functors,
- `AlgebraicGeometry.Flat`, `AlgebraicGeometry.QuasiCompact`,
  `AlgebraicGeometry.QuasiSeparated`, `AlgebraicGeometry.IsProper`,
  `AlgebraicGeometry.LocallyOfFiniteType`, `AlgebraicGeometry.IsLocallyNoetherian`
  (morphism / object property predicates), and
- `Polynomial` for `ℚ[λ]`.

Mathlib does NOT provide (at the pinned commit):
- a Grassmannian *scheme* (only a linear-algebra Grassmannian
  as a finite-rank-quotient variety),
- a `IsProjective` morphism property,
- the Quot/Hilbert functor or its representability,
- `R^i f_*` higher direct images on `Scheme.Modules`,
- Castelnuovo–Mumford `m`-regularity,
- Snapper's Lemma for the polynomial property of Euler characteristics.

The current file-skeleton uses `IsProper π` as the structural stand-in
for "projective `π`" (every projective morphism is proper; the
restriction is harmless in the Route A consumer setting where `π` comes
from a smooth proper curve, which is automatically projective).
iter-177+ refinement: once Mathlib gains an `IsProjective` morphism
property, the hypothesis tightens.

## References

Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex` (~900 LOC,
6 pins + 4 sub-lemmas). Source: Nitsure, "Construction of Hilbert and
Quot Schemes", §§1, 5 (FGA Explained Ch. 5, arXiv:math/0504020 pp. 5–35);
Grothendieck, FGA TDTE-IV; Stacks Project tag 02KH (flat-base-change of
cohomology).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Hilbert polynomial of a coherent sheaf

For a finite-type morphism `π : X ⟶ S` with `S` noetherian and a coherent
sheaf `F` on `X` whose schematic support is proper over `S` (here encoded
as plain `X.Modules` for the file-skeleton), the per-fiber Hilbert
polynomial is the function

`s ↦ Φ_{F,s} ∈ ℚ[λ],   Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗m})`.

Snapper's Lemma ensures this is a polynomial in `m`; the proof requires
graded-Euler-characteristic infrastructure and is not stated here.

Blueprint reference: `def:hilbert_polynomial` (Nitsure §1; cf. Hartshorne
III.5.2). -/

/-- The **Hilbert polynomial** of a coherent sheaf `F` on `X` over `S` at
the fiber over `s ∈ S` with respect to a line bundle `L` on `X`.

Encoded as a function `s ↦ Φ_{F,s} ∈ ℚ[λ]`. The defining formula

`Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗ m})
            = Σ_i (-1)^i dim_{κ(s)} H^i(X_s, F|_{X_s} ⊗ L_s^{⊗m})`

is a polynomial in `m` by Snapper's Lemma; the polynomial coefficients
depend on `s` through the fiber `F|_{X_s}`. When `F` is `S`-flat the
function `s ↦ Φ_{F,s}` is locally constant on `S`.

iter-177+: the body unfolds to the graded-Euler-characteristic
construction once `χ` of a coherent sheaf on a noetherian scheme +
Snapper's polynomial-eventually-property are in scope. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def hilbertPolynomial {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) :
    Polynomial ℚ :=
  sorry

/-! ## §2. The Quot functor

The Quot functor `Quot^{Φ,L}_{E/X/S}` sends an `S`-scheme `T ⟶ S` to the
set of equivalence classes `⟨F, q⟩` of pairs `(F, q)` where
- `F` is a coherent sheaf on `X_T = X ×_S T` whose schematic support is
  proper over `T` and which is `T`-flat,
- `q : E_T ↠ F` is a surjective `O_{X_T}`-linear homomorphism,
- the fiberwise Hilbert polynomial of `F|_{X_t}` with respect to `L|_{X_t}`
  equals `Φ` at every `t ∈ T`.

Two pairs `(F, q)` and `(F', q')` are equivalent iff `ker(q) = ker(q')`.

The Hilbert scheme is the special case `E = O_X`:
`Hilb^{Φ,L}_{X/S} = Quot^{Φ,L}_{O_X/X/S}`.

Blueprint reference: `def:quot_functor` (Nitsure §1; FGA Explained Ch. 5). -/

/-- The **Quot functor** `Quot^{Φ,L}_{E/X/S}` of coherent quotients of `E`
on `X ×_S -` with Hilbert polynomial `Φ`.

Encoded as a contravariant functor `(Over S)ᵒᵖ ⥤ Type u`, sending an
`S`-scheme `T → S` (i.e. an object of `Over S`) to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` of a `T`-flat coherent
sheaf `F` on `X ×_S T` with proper support and a surjection
`q : E_T ↠ F` whose fiberwise Hilbert polynomial is `Φ`, modulo
`ker(q) = ker(q')`. Functoriality is pullback of the quotient along
`X ×_S T' ⟶ X ×_S T`.

iter-177+: the body packages the on-objects / on-morphisms data using the
`Scheme.Modules.pullback` bifunctor on the relative product
`X ×_S T`, with the equivalence relation `ker(q) = ker(q')` quotiented
out via `Setoid` / `Quotient`. For the iter-176 file-skeleton the body
is a typed `sorry`. -/
noncomputable def QuotFunctor {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _E : X.Modules)
    (_Φ : Polynomial ℚ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

end Scheme

/-! ## §3. The Grassmannian scheme

Since Mathlib carries no Grassmannian *scheme*, we encode it here as a
contravariant functor on `Over S` together with a representability
statement. The construction proceeds by gluing `binom(r, d)` affine
charts `U^I ≅ A^{d(r-d)}_S` along the Plücker cocycle, yielding a smooth
projective `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`,
equipped with a tautological rank-`d` quotient
`π* V ↠ U` and the Plücker closed embedding into `ℙ_S(⋀^d V)`.

Blueprint references: `def:grassmannian_scheme`,
`thm:grassmannian_representable` (Nitsure §1 Exercise (2),
"Construction of Grassmannian"; FGA Explained Ch. 5). -/

namespace Scheme

/-- The **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
rank-`d` quotients of a locally free `O_S`-module `V` of rank `r ≥ d`.

Encoded as the functor sending an `S`-scheme `T → S` to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` with
`q : V_T ↠ F` a surjection of `O_T`-modules and `F` locally free of
rank `d`, modulo `ker(q) = ker(q')`. Concretely
`Grass(V, d) = Quot^{d, O_S}_{V/S/S}` (the Quot functor for `X = S`,
`E = V`, constant Hilbert polynomial `d`).

iter-177+: the body re-exports `QuotFunctor (𝟙 S) (?) V Φ_d`, where
`Φ_d : Polynomial ℚ` is the constant polynomial `d`. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def Grassmannian {S : Scheme.{u}} [IsLocallyNoetherian S]
    (_V : S.Modules) (_d : ℕ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

/-- **Representability of the Grassmannian.**

For a noetherian scheme `S`, a locally free `O_S`-module `V` of rank `r`,
and `1 ≤ d ≤ r`, the Grassmannian functor `Grass(V, d)` of
`Grassmannian` is representable by a smooth projective `S`-scheme
`Gr_S(V, d) ⟶ S` of relative dimension `d(r-d)`, equipped with a
tautological rank-`d` quotient `π* V ↠ U`. The determinant line bundle
`det(U)` is relatively very ample, giving a Plücker closed embedding
`Gr_S(V, d) ↪ ℙ_S(⋀^d V)`.

We package the conclusion as the existence of a representing
`Y : Over S` together with a `Functor.RepresentableBy Y` witness for
`Grassmannian V d`; the additional projective / smooth / Plücker
structure is implicit in the construction and is iter-177+ refinement
work (once the proof body lands).

iter-177+: the body follows Nitsure §1 "Construction of Grassmannian":
glue the `binom(r, d)` affine charts `U^I ≅ A^{d(r-d)}_S` along the
Plücker cocycle, verify separatedness via the diagonal cut, verify
properness by the DVR valuative criterion, build the tautological
quotient `U`, exhibit the Plücker embedding via the determinant line
bundle. For the iter-176 file-skeleton the body is a typed `sorry`. -/
theorem Grassmannian.representable {S : Scheme.{u}} [IsLocallyNoetherian S]
    (V : S.Modules) (d : ℕ) :
    ∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y) := by
  sorry

/-! ## §4. Representability of the Quot scheme

Grothendieck–Altman–Kleiman: for a noetherian `S`, a projective
`π : X ⟶ S`, a relatively very ample `L` on `X`, a coherent
`E` on `X`, and `Φ ∈ ℚ[λ]`, the Quot functor `Quot^{Φ,L}_{E/X/S}` is
representable by a *projective* `S`-scheme.

The proof has four steps (Nitsure §5):
1. **Boundedness** via Castelnuovo–Mumford `m`-regularity (uniform across
   fibers of `π` and across coherent quotients of `E_s` with Hilbert
   polynomial `Φ`).
2. **Grassmannian embedding**
   `α : Quot^{Φ,L}_{E/X/S} ↪ Grass(W ⊗_{O_S} Sym^r V, Φ(r))`
   for `r ≥ m`, sending `⟨F, q⟩ ↦ ⟨(π_T)_* F(r), (π_T)_*(q(r))⟩`.
3. **Locally closed in Grassmannian** via the flattening stratification
   applied to the universal cokernel on the Grassmannian, producing the
   stratum `T_0^Φ`.
4. **Closed embedding** by the valuative criterion of properness for
   DVRs.

The reduction to the universal case `X = ℙ(V)`, `E = π*W` is recorded as
`lem:quot_reduction_to_pi_star_W` in the blueprint chapter.

Blueprint reference: `thm:quot_representable` (Nitsure §5; FGA Explained
Ch. 5; Grothendieck, FGA TDTE-IV). -/

/-- **Representability of the Quot scheme** (Grothendieck, Altman–Kleiman).

Let `S` be a noetherian scheme, `π : X ⟶ S` a projective morphism (here
encoded as a proper `LocallyOfFiniteType` morphism; the projectivity
upgrades once `IsProjective` lands in Mathlib), `L` a line bundle on `X`
(relatively very ample), `E` a coherent `O_X`-module, and
`Φ ∈ ℚ[λ]`. Then the Quot functor `Quot^{Φ,L}_{E/X/S}` of `QuotFunctor`
is representable by an `S`-scheme.

We package the conclusion as the existence of `Q : Over S` together with
a `Functor.RepresentableBy Q` witness for `QuotFunctor π L E Φ`; the
*projectivity* of `Q ⟶ S` (and the universal quotient
`q^univ : π^*_Q E ↠ F^univ` on `X ×_S Q^{Φ,L}`) is implicit in the
construction (Plücker-embedded into a projective Grassmannian over `S`)
and is iter-177+ refinement work.

iter-177+: the body follows the four-step Nitsure §5 proof
(boundedness ⟶ Grassmannian embedding ⟶ flattening stratification ⟶
valuative-criterion closed embedding); the sub-lemmas live in
`lem:quot_boundedness`, `lem:quot_alpha_injective`,
`lem:quot_valuative_criterion`, and the existential reduction in
`lem:quot_reduction_to_pi_star_W`. For the iter-176 file-skeleton the
body is a typed `sorry`. -/
theorem QuotScheme {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (π : X ⟶ S) [LocallyOfFiniteType π] [IsProper π]
    (L E : X.Modules) (Φ : Polynomial ℚ) :
    ∃ (Q : Over S), Nonempty ((QuotFunctor π L E Φ).RepresentableBy Q) := by
  sorry

end Scheme

/-! ## §5. Cohomology and base change

The Quot construction uses cohomology-and-base-change in two places: the
boundedness step (Nitsure §5 "Use of m-Regularity") and the Grassmannian
embedding (Nitsure §5 "Embedding Quot into Grassmannian"). We record the
relevant statement as a named theorem so the Lean encoding can cite it
directly.

The Stacks 02KH form is the statement for higher direct images
`R^i f_*` on quasi-coherent sheaves; for the iter-176 file-skeleton we
state the `i = 0` form on `Scheme.Modules`, which is the substantive
content of `lemma-flat-base-change-cohomology(ii)` of Stacks 02KH. The
`R^i` form is iter-177+ work after higher-direct-image infrastructure
is in scope.

Blueprint reference: `thm:flat_base_change_cohomology` (Stacks 02KH). -/

/-! ### Flat base change of cohomology (Stacks tag 02KH, `i = 0` form)

Let
```
   g'
X' ───→ X
│       │
f'      f
↓       ↓
S' ───→ S
   g
```
be a cartesian square of schemes with `g` flat and `f` quasi-compact
quasi-separated. Let `F` be a sheaf of `O_X`-modules. Then the canonical
base-change map `g* (f_* F) ⟶ f'_* ((g')* F)` is an isomorphism in
`S'.Modules`.

(The full Stacks 02KH statement covers all higher direct images
`R^i f_* F` for `i ≥ 0`; the `i = 0` form encoded here is the
substantive content of `lemma-flat-base-change-cohomology(ii)` of
Stacks 02KH, with the `i ≥ 1` form post-iter-177 work after the
higher-direct-image bifunctor lands.)

iter-177 (Lane QS-FLAT): the body constructs the canonical base-change
natural transformation via the mate equivalence of the
`pullback ⊣ pushforward` adjunction (Mathlib's `mateEquiv` of
`Scheme.Modules.pullbackPushforwardAdjunction`), then exhibits the iso
via the `canonicalBaseChangeMap_isIso` helper. The deep mathematical
content (Stacks tag 02KH / 02KE / 00H8) lives entirely in the helper;
it reduces affine-locally to: for a flat ring map `A → B` and an
`A`-algebra `R`, the canonical map `B ⊗_A H^i(X, F) → H^i(X_B, F_B)`
is an iso for any quasi-coherent `F` (the `i = 0` form is what we use).
The helper remains a typed `sorry` pending the affine-local reduction
+ algebraic flat base change; this is iter-178+ body work after
quasi-compact open-cover Mayer-Vietoris infrastructure is in scope. -/

/-- The canonical base-change natural transformation `g* (f_* -) ⟶ f'_* ((g')* -)`
associated to a cartesian square
```
     g'
X' ─────→ X
│         │
f'        f
↓         ↓
S' ─────→ S
     g
```
in `Scheme`. Constructed as the *mate* (Beck–Chevalley transform)
under the `pullback ⊣ pushforward` adjunctions on sheaves of modules
of the canonical 2-isomorphism
`pullback g ⋙ pullback f' ≅ pullback f ⋙ pullback g'` coming from
`g' ≫ f = f' ≫ g`.

This natural transformation always exists (no flatness needed). The
content of the flat base-change theorem (Stacks tag 02KH) is the
*isomorphism* claim under the hypotheses
`[QuasiCompact f] [QuasiSeparated f] [Flat g]`; that claim is the
helper `canonicalBaseChangeMap_isIso`. -/
noncomputable def canonicalBaseChangeMap
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) :
    Scheme.Modules.pushforward f ⋙ Scheme.Modules.pullback g ⟶
      Scheme.Modules.pullback g' ⋙ Scheme.Modules.pushforward f' :=
  CategoryTheory.mateEquiv
      (Scheme.Modules.pullbackPushforwardAdjunction f)
      (Scheme.Modules.pullbackPushforwardAdjunction f')
      (((Scheme.Modules.pullbackComp f' g) ≪≫
        Scheme.Modules.pullbackCongr sq.w.symm ≪≫
        (Scheme.Modules.pullbackComp g' f).symm).hom)

/-- **Trivial bridge** (pushforward of pullback at sections — rfl).

The section of `(pushforward f').obj ((pullback g').obj F)` over an
open `U ⊆ S'` identifies definitionally with the section of
`(pullback g').obj F` over `f' ⁻¹ᵁ U`, by `Scheme.Modules.pushforward_obj_obj`.
Factored as a separate (closed) lemma to document step (3) of the
intended-body plan in
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` cleanly. -/
private lemma pushforward_pullback_section_eq_pullback_section
    {X X' S' : Scheme.{u}} (f' : X' ⟶ S') (g' : X' ⟶ X)
    (F : X.Modules) (U : S'.Opens) :
    Γ((Scheme.Modules.pushforward f').obj ((Scheme.Modules.pullback g').obj F), U) =
      Γ((Scheme.Modules.pullback g').obj F, f' ⁻¹ᵁ U) := rfl

/-! ### Project-side typed-sorry: affine-open section formula for `Scheme.Modules.pullback`

The load-bearing Mathlib gap for `_of_isAffineBase` is the affine-open
section formula identifying

  `Γ((pullback g).obj N, U)  ≃  Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V)`

for any compatible affine pair `(V ⊆ X, U ⊆ Y)` of a morphism `g : Y ⟶ X`
of schemes and a sheaf of `O_X`-modules `N`. The pullback functor
`Scheme.Modules.pullback g` is built as `SheafOfModules.pullback` via the
partial-adjoint machinery and has NO closed-form `pullback_obj_obj` simp
lemma (cf. `analogies/quotscheme-pullback-affine-section.md` table for the
mathlib survey). We introduce the typed-sorry def below as the
project-side `BUILD_PROJECT_HELPER` declaration the analogy file recommends;
the body (~120–200 LOC) is iter-184+ work via the `Tilde` route on Spec
+ promotion to a general affine open in `Y`.

iter-183 Lane F PIVOT (helper budget #1): the def adds a single named
project-side sorry (Tier-3, direct sorry on a substantive type) that
captures the algebraic content the consumer
`_of_isAffineBase` is waiting on. -/

/-- **Affine-open section formula for the module pullback** (project-side
typed sorry; load-bearing Mathlib gap).

For a morphism of schemes `g : Y ⟶ X`, a sheaf of `O_X`-modules `N`, and a
compatible pair of affine opens `V ⊆ X`, `U ⊆ Y` with
`U ⊆ g ⁻¹ᵁ V`, the sections of the pullback `(Scheme.Modules.pullback g).obj N`
over `U` identify with the algebraic tensor product
`Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V)`. The `Γ(X, V)`-algebra structure on `Γ(Y, U)`
is the one induced by the ring map `g.appLE V U e : Γ(X, V) →+* Γ(Y, U)`.

iter-183 Lane F PIVOT: typed sorry. The body (~120–200 LOC) carries the
substantive Stacks 01HQ / 01I8 content: on `Spec R`, `tilde M` realizes
`Γ(tilde M, ⊤) = M` (`AlgebraicGeometry.Modules.Tilde.isoTop`), and the
analogous `(pullback g).obj (tilde N) ≅ tilde (Γ(Y, U) ⊗_{Γ(X, V)} N)`
identification at Spec rings is then promoted to the general affine open
in `Y` via the affine-open compatibility of `Scheme.Modules.pullback`'s
adjunction.

Consumer: `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
applies this to `(N := (Scheme.Modules.pushforward f).obj F)`, `V := ⊤ : S.Opens`,
and `U := U`, then composes with `Module.Flat.isBaseChange`'s `IsBaseChange.equiv`
on the flat ring map `Γ(S, ⊤) →+* Γ(S', U)`. -/
noncomputable def Scheme.Modules.pullback_app_isoTensor
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules)
    {U : Y.Opens} {V : X.Opens}
    (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    Γ((Scheme.Modules.pullback g).obj N, U) ≃ₗ[Γ(Y, U)]
      TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  exact sorry

/-- **Affine-base case of flat base change at affine opens** (Stacks tag 00H8 / 02KE).

Specialization of `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` to
the case where the *base* `S` is affine, so we may take `V := ⊤ : S.Opens`
as the (trivially affine) compatible open: every affine `U ⊆ S'` satisfies
`U ≤ (Opens.map g.base).obj ⊤ = ⊤`. The body of this helper captures the
substantive algebraic step of Stacks 02KE / 00H8 (i.e. the actual application
of `Module.Flat.isBaseChange` after the section-vs-tensor-product
identification): on the affine ring map `Γ(S, ⊤) → Γ(S', U)` (flat by
`Flat.flat_appLE` applied to `Flat g`), the algebraic flat base change of
`Module.Flat.isBaseChange` produces a linear iso
`Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f⁻¹⊤) ≃ Γ((g')*F, f'⁻¹U)` that agrees with the
canonical Beck–Chevalley section map under the section-vs-tensor-product
identification of `(pullback g).obj _`'s `U`-section — now packaged as
the typed-sorry def `Scheme.Modules.pullback_app_isoTensor`.

iter-183 Lane F PIVOT (consumer of the iter-183 typed-sorry def): the body
is a structured assembly consuming `Scheme.Modules.pullback_app_isoTensor`
+ `Module.Flat.isBaseChange`. The residual gap is the *Beck–Chevalley
compatibility* claim (the BC arrow agrees with the iso composition under
the canonical algebra identifications); we leave a single inline
`sorry` for that compatibility step. The Stacks 02KE algebraic content is
fully encapsulated in `pullback_app_isoTensor` (LHS) and in
`Module.Flat.isBaseChange` + `IsBaseChange.equiv` (RHS). -/
private theorem canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [IsAffine S]
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) (U : S'.Opens) (_hU : IsAffineOpen U) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) := by
  -- Take `V := ⊤ : S.Opens`, affine via `[IsAffine S]`.
  have hV : IsAffineOpen (⊤ : S.Opens) := isAffineOpen_top S
  -- Every `U : S'.Opens` automatically satisfies `U ≤ g ⁻¹ᵁ ⊤`.
  have e : U ≤ g ⁻¹ᵁ (⊤ : S.Opens) := le_top
  -- Algebra structure on the affine ring map `Γ(S, ⊤) →+* Γ(S', U)`.
  letI algInst : Algebra Γ(S, ⊤) Γ(S', U) := (g.appLE (⊤ : S.Opens) U e).hom.toAlgebra
  -- LHS: identify the section of the pullback as a tensor product via
  -- the new typed-sorry `pullback_app_isoTensor` applied to
  -- `(N := (pushforward f).obj F)`. The output is
  --   `Γ(S', U) ⊗_{Γ(S, ⊤)} Γ((pushforward f).obj F, ⊤)
  --  = Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f ⁻¹ᵁ ⊤)`
  -- (the last identification by `pushforward_obj_obj`).
  let _isoLHS := Scheme.Modules.pullback_app_isoTensor g
    ((Scheme.Modules.pushforward f).obj F) _hU hV e
  -- RHS: by `pushforward_obj_obj`, the section of the pushforward at U
  -- identifies with `Γ((pullback g').obj F, f' ⁻¹ᵁ U)`. The algebraic
  -- Stacks 02KE iso provided by `Module.Flat.isBaseChange` /
  -- `IsBaseChange.equiv` on the flat ring map `Γ(S, ⊤) →+* Γ(S', U)`
  -- (flat by `Flat.flat_appLE`) and the module `Γ(F, f ⁻¹ᵁ ⊤)` yields
  --   `Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f ⁻¹ᵁ ⊤) ≃ Γ((g')*F, f' ⁻¹ᵁ U)`.
  -- The residual gap is the Beck–Chevalley compatibility: the BC arrow
  -- equals `_isoLHS` composed with this algebraic iso under the
  -- `pushforward_obj_obj`-rfl identification. This compatibility is
  -- the iter-184+ closure (substantive content fully encapsulated in
  -- `pullback_app_isoTensor` + `Module.Flat.isBaseChange`).
  sorry

/-- **Affine-open form of flat base change** (Stacks tag 00H8 / 02KE).

Restriction of `canonicalBaseChangeMap_app_app_isIso` to the case where the
open `U ⊆ S'` is affine. The general (non-affine base `S`) case factors into:
(i) the affine-base specialization
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`, which
captures the substantive Stacks 02KE algebraic content via
`Module.Flat.isBaseChange`; and
(ii) a base-side Mayer-Vietoris descent step (refining `U` along an affine
cover `(V_α)_α` of `S` into pieces `U ∩ (Opens.map g.base).obj V_α`, applying
(i) on each, and gluing via `QuasiSeparated f`).

iter-181 Lane F: helper-with-substantive-Mathlib-gap. The body is a typed
`sorry` carrying the *intended* base-side Mayer-Vietoris reduction; the
algebraic Stacks 02KE content is delegated to
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`.
Concretely the body would:
  1. Choose a finite affine cover `(V_α)_α` of `S` whose union covers
     `g.base '' U.carrier` (using quasi-compactness of `U`).
  2. Refine `U` into pieces `W_α := U ⊓ (Opens.map g.base).obj V_α`,
     each affine when intersected with the affine open `(g)⁻¹ V_α`.
  3. On each piece, restrict the morphism `g` to `g|_{(g)⁻¹ V_α} :
     (g)⁻¹ V_α ⟶ V_α` (still flat) and apply the affine-base helper to
     conclude iso at `W_α`.
  4. Descend along the cover `(W_α)_α` of `U` via Mayer-Vietoris on the
     quasi-separated `f` (the intersection `W_α ∩ W_β` is quasi-compact). -/
private theorem canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) (U : S'.Opens) (_hU : IsAffineOpen U) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) := by
  -- Stacks 02KE / 00H8, H⁰ form. The substantive algebraic content lives in
  -- `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
  -- (the `[IsAffine S]` specialization), which delegates to
  -- `Module.Flat.isBaseChange` on the flat ring map `Γ(S, ⊤) → Γ(S', U)`
  -- modulo the section-vs-tensor-product identification (Mathlib gap).
  --
  -- The reduction from general `S` to `[IsAffine S]` (the base-side
  -- Mayer-Vietoris on a finite affine cover of `S`) is the second
  -- Mathlib-shaped step, sketched in this lemma's docstring (steps 1–4).
  -- That descent is not yet built in this file; it would need a base-side
  -- analogue of `canonicalBaseChangeMap_app_app_isIso_of_affineCover`
  -- (which handles target-side `S'` descent), reframed for the base `S`.
  -- Until that descent lemma is introduced (iter-182+), the body carries
  -- a typed `sorry`; the algebraic Stacks 02KE step is properly factored
  -- into the named affine-base helper above.
  sorry

/-- **Open-cover gluing for the section-wise flat base change**
(Mayer-Vietoris reduction, Stacks 02KH(ii) corollary).

If the section of the canonical base-change map is an iso over *every*
affine open `V ⊆ S'`, then it is an iso over every open `U ⊆ S'` as well.
This is the standard Mayer-Vietoris descent argument for a morphism of
quasi-coherent sheaves on the base: pick an affine cover of `U`, the
morphism is an iso on each chart, hence iso on `U` by gluing along the
intersections (which are quasi-compact thanks to `QuasiSeparated f`).

iter-180 Lane F: helper-with-substantive-Mathlib-gap. The body is a typed
`sorry` carrying the *intended* descent argument. Required ingredients
(not yet in scope at the pinned Mathlib commit):
* the basis property of affine opens (`Scheme.affineOpenCover`);
* iso-on-basis ⟹ iso-on-open for sheaves of modules
  (`Modules.isIso_iff_isIso_basis`, project-side helper);
* a Mayer-Vietoris on pushforwards via `QuasiSeparated f`. -/
private theorem canonicalBaseChangeMap_app_app_isIso_of_affineCover
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules)
    (h_affine : ∀ V : S'.Opens, IsAffineOpen V →
        IsIso (((canonicalBaseChangeMap sq).app F).app V))
    (U : S'.Opens) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) := by
  -- Mayer-Vietoris descent. Substantive Mathlib gap. Intended body:
  --   1. Pick an affine cover `(V_i)_{i ∈ I}` of `U` with each `V_i` affine
  --      open (using `Scheme.affineOpenCover` restricted to `U`).
  --   2. On each chart `V_i ⊆ U`, the iso `h_affine V_i hV_i` gives an
  --      iso of sections.
  --   3. Both `(pullback g).obj ((pushforward f).obj F)` and
  --      `(pushforward f').obj ((pullback g').obj F)` are sheaves of
  --      `O_{S'}`-modules; their sections over `U` are recovered as the
  --      equaliser of the sections over the cover.
  --   4. By compatibility of `(canonicalBaseChangeMap sq).app F` with
  --      restriction (naturality of the natural transformation), the
  --      affine-local isos assemble into an iso on `U` (using
  --      `TopCat.Sheaf.hom_ext` / Mayer-Vietoris on quasi-separated `f`).
  -- This is the "sheaves are determined by their sections on a basis"
  -- principle, applied to a natural transformation. The required general
  -- form (`Sheaf.Hom.isIso_iff_isIso_on_basis`) is not in scope at the
  -- pinned Mathlib commit; it is the project-side sub-build owed by
  -- `chap:Picard_QuotScheme` Section §5 alongside the affine-open piece.
  -- (The dependence on `QuasiSeparated f` enters in step 3 above: it
  -- ensures intersections of preimages are quasi-compact, so the affine
  -- step applies to the cover refinements.)
  sorry

/-- **Section-wise form of flat base change** (Stacks tag 02KH(ii)).

For every open `U` of `S'`, the section over `U` of the canonical base-change
map `(pullback g).obj ((pushforward f).obj F) ⟶ (pushforward f').obj ((pullback g').obj F)`
is an isomorphism.

This is the substantive content of Stacks 02KH(ii) (the `i = 0` form), and
splits cleanly into two named substantive Mathlib gaps:
* `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` — the affine case
  via algebraic flat base change `Module.Flat.isBaseChange` (Stacks 00H8 /
  02KE);
* `canonicalBaseChangeMap_app_app_isIso_of_affineCover` — the descent from
  affine opens to arbitrary opens via Mayer-Vietoris on the quasi-separated
  morphism `f`.

The body of this theorem composes the two helpers cleanly; the substantive
content has been factored into the helper bodies. -/
theorem canonicalBaseChangeMap_app_app_isIso {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) (U : S'.Opens) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) :=
  -- Composition of the two named substantive helpers: the affine-open case
  -- via `Module.Flat.isBaseChange`, then the Mayer-Vietoris descent.
  canonicalBaseChangeMap_app_app_isIso_of_affineCover sq F
    (fun V hV => canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen sq F V hV)
    U

/-- **Flat base-change is an isomorphism** (Stacks tag 02KH, `i = 0`).

The canonical base-change natural transformation `canonicalBaseChangeMap`
is an isomorphism at every coherent sheaf `F` under the hypotheses
`[QuasiCompact f]`, `[QuasiSeparated f]`, `[Flat g]`.

The proof reduces section-wise via `Scheme.Modules.Hom.isIso_iff_isIso_app`
to the section-form helper `canonicalBaseChangeMap_app_app_isIso`,
which captures Stacks 02KH(ii) — the substantive algebraic content
(`Module.Flat.isBaseChange` on each affine open + Mayer-Vietoris for
quasi-separated `f`). -/
theorem canonicalBaseChangeMap_isIso {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) :
    IsIso ((canonicalBaseChangeMap sq).app F) :=
  Scheme.Modules.Hom.isIso_iff_isIso_app.mpr
    (fun U => canonicalBaseChangeMap_app_app_isIso sq F U)

theorem flatBaseChangeCohomology {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) :
    Nonempty ((Scheme.Modules.pullback g).obj
                ((Scheme.Modules.pushforward f).obj F) ≅
              (Scheme.Modules.pushforward f').obj
                ((Scheme.Modules.pullback g').obj F)) :=
  -- Build the canonical Beck-Chevalley base-change map and wrap it in `asIso`
  -- using the iso-claim from `canonicalBaseChangeMap_isIso`.
  ⟨@asIso _ _ _ _ _ (canonicalBaseChangeMap_isIso sq F)⟩

end AlgebraicGeometry
