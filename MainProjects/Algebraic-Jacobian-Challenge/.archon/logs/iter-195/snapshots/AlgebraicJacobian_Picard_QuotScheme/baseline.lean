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

/-- **Project-side base linear map for `pullback_app_isoTensor`** (iter-185
Lane F substantive step).

Built from the unit of the `pullback ⊣ pushforward` adjunction at the
`V`-section level: the unit produces a morphism of `𝒪_X`-modules
`N ⟶ (pushforward g).obj ((pullback g).obj N)`, and evaluating its
underlying `PresheafOfModules`-val at `V` gives a `Γ(X, V)`-linear map
`Γ(N, V) →ₗ[Γ(X, V)] Γ((pushforward g).obj ((pullback g).obj N), V)`.
By `pushforward_obj_obj` (definitional), the codomain is the same data as
`Γ((pullback g).obj N, g ⁻¹ᵁ V)` with `Γ(X, V)` acting through restriction
of scalars along `g.app V`.

This `let`-only construction is axiom-clean (no `sorry`); it captures
exactly Step 1 of the Tilde-isoTop body plan documented in the consumer's
docstring. The substantive bijectivity claim (Stacks 02KE / 01HQ algebraic
flat-base-change content) is encapsulated separately in
`pullback_app_isoTensor_isBaseChange`, allowing the consumer iso to
discharge cleanly via `IsBaseChange.equiv.symm`. -/
private noncomputable def pullback_app_isoTensor_unitAtV
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) (V : X.Opens) :
    Γ(N, V) →ₗ[Γ(X, V)]
      Γ((Scheme.Modules.pushforward g).obj ((Scheme.Modules.pullback g).obj N), V) :=
  (((Scheme.Modules.pullbackPushforwardAdjunction g).unit.app N).val.app (.op V)).hom

/-- **Step 2 of the Tilde-isoTop route** (iter-186 Lane F): the `Γ(X, V)`-linear
base map for the affine-open section formula.

Combining the axiom-clean unit `pullback_app_isoTensor_unitAtV` with the
presheaf-restriction `((pullback g).obj N).presheaf.map (homOfLE e).op` (from
the larger open `g ⁻¹ᵁ V` to the smaller open `U`) gives a `Γ(X, V)`-linear
map
`Γ(N, V) →ₗ[Γ(X, V)] Γ((pullback g).obj N, U)`,
where the `Γ(X, V)`-action on the target is via the algebra map
`(g.appLE V U e).hom : Γ(X, V) ⟶ Γ(Y, U)`.

The codomain of `unitAtV`,
`Γ((pushforward g).obj ((pullback g).obj N), V)`, is definitionally equal
to `Γ((pullback g).obj N, g ⁻¹ᵁ V)` by `pushforward_obj_obj` (rfl), which is
what makes the composition with the presheaf restriction typecheck.

`Γ(X, V)`-linearity uses the defining decomposition
`g.appLE V U e = g.app V ≫ Y.presheaf.map (homOfLE e).op`
(definitional from `AlgebraicGeometry.Scheme.Hom.appLE`): linearity in the
source over `Γ(X, V)` is inherited from `unitAtV` (via `g.app V`),
linearity in the target's restriction-of-scalars action is the
`Γ(Y, g ⁻¹ᵁ V)`-linearity of the presheaf-restriction map, and the two
chain definitionally to give `Γ(X, V)`-linearity.

This is axiom-clean; the substantive bijectivity claim is encapsulated in
`pullback_app_isoTensor_baseMap_isBaseChange` (iter-186 Lane F helper #2). -/
private noncomputable def pullback_app_isoTensor_baseMap
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules)
    {U : Y.Opens} {V : X.Opens} (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
      Module.compHom _ (g.appLE V U e).hom
    Γ(N, V) →ₗ[Γ(X, V)] Γ((Scheme.Modules.pullback g).obj N, U) := by
  letI algInst : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI modInst : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  -- The presheaf restriction map (Γ(Y, g ⁻¹ᵁ V)-linear; the source's
  -- underlying type matches the codomain of `unitAtV` definitionally).
  let restr := (((Scheme.Modules.pullback g).obj N).presheaf.map (homOfLE e).op).hom
  -- The Γ(X, V)-linear adjunction unit at the V section.
  let unit := pullback_app_isoTensor_unitAtV g N V
  refine
    { toFun := fun x => restr (unit x)
      map_add' := ?_
      map_smul' := ?_ }
  · intro x y
    change restr (unit (x + y)) = restr (unit x) + restr (unit y)
    rw [unit.map_add]
    exact restr.map_add _ _
  · intro r x
    change restr (unit (r • x)) = (g.appLE V U e).hom r • restr (unit x)
    -- `unit.map_smul` is over `Γ(X, V)`; the codomain action equals the
    -- `Γ(Y, g ⁻¹ᵁ V)`-action via `g.app V` (definitional from
    -- `Scheme.Modules.pushforward`). Then `restr` is `Γ(Y, g ⁻¹ᵁ V)`-linear
    -- (via `Scheme.Modules.map_smul` applied to the Y-side). The chain
    -- gives action through
    -- `Y.presheaf.map (homOfLE e).op ∘ g.app V = g.appLE V U e` (definitional
    -- from `Scheme.Hom.appLE`).
    rw [unit.map_smul]
    exact ((Scheme.Modules.pullback g).obj N).map_smul (homOfLE e) _ _

/-- **Spec-level pullback-of-tilde formula** (iter-187 Lane F NAMED HELPER,
project-side typed-sorry).

For a ring map `φ : A ⟶ B` of commutative rings, the module-sheaf pullback
along `Spec.map φ : Spec B ⟶ Spec A` sends `tilde M` to (the `tilde` of)
the base-change module `M ⊗_A B` on `Spec B`. This is the substantive
Mathlib gap (Stacks tag 01HQ / 0BJ8): the "pullback of tilde = tilde of
base change" identification.

Direct LSP searches (iter-187 analogist, `quotscheme-isbasechange-tilde.md`)
confirm Mathlib (pinned commit `b80f227`) has no such lemma; the only
pullback formula at all is `pullbackObjFreeIso` on *free* sheaves
(`PullbackFree.lean:122`), too restrictive for general modules.

This declaration is the project-side named pin capturing the Mathlib gap.
Its `Nonempty` form sidesteps the noncomputable / data choice issue: the
substantive content is the *existence* of the iso (Stacks 01HQ). The
body (~115-200 LOC) is iter-188+ sub-build work via naturality of
`tilde.adjunction` + the Spec-level base change formula. -/
private theorem pullback_tildeIso
    {A B : CommRingCat.{u}} (φ : A ⟶ B) (M : ModuleCat.{u} A) :
    letI : Algebra A B := φ.hom.toAlgebra
    letI : Algebra Γ(Spec A, ⊤) Γ(Spec B, ⊤) :=
      ((Spec.map φ).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI : Module Γ(Spec A, ⊤)
        Γ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M), ⊤) :=
      Module.compHom _ ((Spec.map φ).appLE ⊤ ⊤ le_top).hom
    Nonempty {iso : (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
        tilde (ModuleCat.of B (TensorProduct A B M)) //
      -- Canonical Spec base-change iso identity (Stacks 01HQ / 0BJ8): the
      -- iso, evaluated at ⊤-sections, sends the canonical pullback-section
      -- image of `tilde.toOpen M ⊤ m` (built via the adjunction-unit base map
      -- `pullback_app_isoTensor_baseMap` on `tilde M`) to `tilde.toOpen … ⊤`
      -- applied to `1 ⊗ₜ m`. This characterizes the iso as the canonical
      -- "pullback of tilde = tilde of base change" identification.
      ∀ (m : M),
        (Scheme.Modules.Hom.app iso.hom ⊤).hom
            (pullback_app_isoTensor_baseMap (Spec.map φ) (tilde M) le_top
              ((tilde.toOpen M ⊤).hom m)) =
          (tilde.toOpen (ModuleCat.of B (TensorProduct A B M)) ⊤).hom
            (1 ⊗ₜ[A] m)} := by
  letI : Algebra A B := φ.hom.toAlgebra
  letI : Algebra Γ(Spec A, ⊤) Γ(Spec B, ⊤) :=
    ((Spec.map φ).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI : Module Γ(Spec A, ⊤)
      Γ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M), ⊤) :=
    Module.compHom _ ((Spec.map φ).appLE ⊤ ⊤ le_top).hom
  -- iter-188+ body: build the iso via tilde fully-faithfulness on the
  -- essential image (Stacks 01HQ / 0BJ8 algebraic content). See analogist
  -- file `analogies/quotscheme-isbasechange-tilde.md`.
  -- iter-195+ Σ-pair refactor: the iso now carries the canonical Spec
  -- base-change section-level identity so that consumers (Beck-Chevalley
  -- intertwining at `_sectionLinearEquiv`) can trace `iso.hom (1 ⊗ₜ m)`.
  exact sorry

/-- **Pushforward preserves quasi-coherence** (Stacks tag 01XJ) — project-side
helper named pin (iter-187 Lane F).

For a quasi-compact quasi-separated morphism `f : X ⟶ S` of schemes, the
pushforward of a quasi-coherent sheaf is quasi-coherent. Required to thread
`[IsQuasicoherent]` through the consumer chain: at the call site
`canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`, the
argument `N := (pushforward f).obj F` is fed into `pullback_app_isoTensor`,
which (per the iter-187 analogist verdict) requires `[N.IsQuasicoherent]`;
this helper produces the instance from `[F.IsQuasicoherent]` + qcqs `f`.

The body is a typed sorry; the substantive content is Stacks 01XJ (the
adjoint-functor proof: pushforward is right adjoint to pullback;
right adjoints preserve coherent / quasi-coherent stuff under qcqs
finiteness conditions). Mathlib gap at the pinned commit; ~30 LOC. -/
private theorem pushforward_isQuasicoherent
    {X S : Scheme.{u}} (f : X ⟶ S)
    [QuasiCompact f] [QuasiSeparated f]
    (F : X.Modules) [F.IsQuasicoherent] :
    ((Scheme.Modules.pushforward f).obj F).IsQuasicoherent := by
  -- Stacks 01XJ: pushforward of quasi-coherent along qcqs preserves qc.
  -- Mathlib gap at pinned commit b80f227. ~30 LOC body.
  exact sorry

/-- **Step 1 pin (Stacks 01I8)**: quasi-coherent sheaf on an affine open is
`tilde` of its sections.

iter-189 Lane F unbundling (per `analogies/lane-f-isbasechange.md`
Decision 4): pinned as a separately-named typed sorry parallel to
`pullback_tildeIso` (Step 2). This breaks the iter-186/187/188 STUCK
pattern in which Steps 1, 2, 3 were bundled into the single body sorry
of `_sectionLinearEquiv`.

For a quasi-coherent sheaf `N` on `X` and an affine open `V ⊆ X`, the
pullback of `N` along `IsAffineOpen.fromSpec : Spec Γ(X, V) ⟶ X` is
canonically isomorphic to `tilde Γ(N, V)` on `Spec Γ(X, V)`.

iter-190+ body work (~20–40 LOC): extract a `Presentation` of
`(N|_V).overSpec` from `[N.IsQuasicoherent]` (using `hV.isoSpec`
transport), then apply `isIso_fromTildeΓ_of_presentation`. The Mathlib
gap is the per-affine-open presentation extraction (Mathlib's
`QuasicoherentData` ships per-cover-element presentations, not on a
chosen affine open). -/
private theorem tildeIso_of_isQuasicoherent_isAffineOpen
    {X : Scheme.{u}} (N : X.Modules) [N.IsQuasicoherent]
    {V : X.Opens} (hV : IsAffineOpen V) :
    letI : Algebra Γ(X, V) Γ(Spec Γ(X, V), ⊤) :=
      (hV.fromSpec.appLE V ⊤
        (le_of_eq hV.fromSpec_preimage_self.symm)).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback hV.fromSpec).obj N, ⊤) :=
      Module.compHom _
        (hV.fromSpec.appLE V ⊤
          (le_of_eq hV.fromSpec_preimage_self.symm)).hom
    Nonempty {iso : (Scheme.Modules.pullback hV.fromSpec).obj N ≅
        tilde (ModuleCat.of Γ(X, V) Γ(N, V)) //
      -- Canonical iso identity (Stacks 01I8 — `step1 = (asIso fromTildeΓ).symm`):
      -- iso.inv at ⊤-sections sends `tilde.toOpen Γ(N, V) ⊤ s` to the canonical
      -- pullback-section image of `s` produced by `pullback_app_isoTensor_baseMap`
      -- (the adjunction-unit-based base map). This characterizes the iso as the
      -- inverse of the `fromTildeΓ` counit at the affine open V.
      ∀ (s : Γ(N, V)),
        (Scheme.Modules.Hom.app iso.inv ⊤).hom
            ((tilde.toOpen (ModuleCat.of Γ(X, V) Γ(N, V)) ⊤).hom s) =
          pullback_app_isoTensor_baseMap hV.fromSpec N
            (le_of_eq hV.fromSpec_preimage_self.symm) s} := by
  letI : Algebra Γ(X, V) Γ(Spec Γ(X, V), ⊤) :=
    (hV.fromSpec.appLE V ⊤
      (le_of_eq hV.fromSpec_preimage_self.symm)).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback hV.fromSpec).obj N, ⊤) :=
    Module.compHom _
      (hV.fromSpec.appLE V ⊤
        (le_of_eq hV.fromSpec_preimage_self.symm)).hom
  -- iter-190+ body: Stacks 01I8 via QC-on-affine ⟺ tilde-on-affine.
  -- iter-195+ Σ-pair refactor: the iso now carries the canonical
  -- `iso.inv = (asIso fromTildeΓ).symm` section-level identity so that
  -- consumers (Beck-Chevalley intertwining) can trace through the iso.
  -- See `analogies/lane-f-isbasechange.md` Decision 3 row 1
  -- (NEEDS_MATHLIB_GAP_FILL).
  exact sorry

/-- **Step 3 pin (transport)**: section-level transport for pullback along
the affine-open's `fromSpec` map.

iter-189 Lane F unbundling (per `analogies/lane-f-isbasechange.md`
Decision 4): pinned as a separately-named typed sorry parallel to
`pullback_tildeIso` (Step 2) and `tildeIso_of_isQuasicoherent_isAffineOpen`
(Step 1).

This pin captures the Step 3 transport content of the Tilde-isoTop route:
the top section of a sheaf pulled back along
`IsAffineOpen.fromSpec : Spec Γ(Y, U) ⟶ Y` is canonically `Γ(Y, U)`-linearly
identified with the section over `U` itself. Substantive content combines
`AlgebraicGeometry.tilde.isoTop` (Mathlib HAS) with the `hU.isoSpec`
transport (Mathlib gap at `b80f227`).

iter-190 closure (Lane F Step 3 HARD BAR): the body chains
`Scheme.Modules.restrictFunctorIsoPullback` (Mathlib's identification of the
`pullback` functor with the `restrict` functor along an open immersion;
applicable since `hU.fromSpec` carries `IsOpenImmersion` via
`IsAffineOpen.isOpenImmersion_fromSpec`) with the definitional
`Scheme.Modules.restrict_obj` (sections of `N.restrict f` over `V` equal
sections of `N` over `f ''ᵁ V`, by `rfl`) and the propositional
`Scheme.Hom.image_top_eq_opensRange` + `IsAffineOpen.opensRange_fromSpec`
to identify `hU.fromSpec ''ᵁ ⊤ = U`. -/
private theorem pullback_of_openImmersion_iso_restrict
    {Y : Scheme.{u}} (N : Y.Modules) {U : Y.Opens} (hU : IsAffineOpen U) :
    -- `Γ(Y, U)`-linear identification between the top section of the pullback
    -- (along `hU.fromSpec : Spec Γ(Y, U) ⟶ Y`) and `Γ(N, U)` itself. The
    -- module-action ring on the LHS is set up via the canonical algebra
    -- `Γ(Y, U) → Γ((Spec Γ(Y, U)), ⊤)`, which is the structure-sheaf
    -- equivalence on the affine scheme.
    letI : Algebra Γ(Y, U) Γ((Spec Γ(Y, U)), ⊤) :=
      (Scheme.ΓSpecIso _).inv.hom.toAlgebra
    letI : Module Γ(Y, U) Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) :=
      Module.compHom _ (Scheme.ΓSpecIso _).inv.hom
    Nonempty (Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) ≃ₗ[Γ(Y, U)]
      Γ(N, U)) := by
  letI algInst : Algebra Γ(Y, U) Γ((Spec Γ(Y, U)), ⊤) :=
    (Scheme.ΓSpecIso _).inv.hom.toAlgebra
  letI modInst : Module Γ(Y, U) Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) :=
    Module.compHom _ (Scheme.ΓSpecIso _).inv.hom
  -- Step 1: Identify pullback along `hU.fromSpec` with the restriction functor.
  -- Mathlib's `restrictFunctorIsoPullback` gives this for any open immersion;
  -- `hU.fromSpec` is an open immersion by `IsAffineOpen.isOpenImmersion_fromSpec`.
  have isoSheaf : (Scheme.Modules.pullback hU.fromSpec).obj N ≅ N.restrict hU.fromSpec :=
    ((Scheme.Modules.restrictFunctorIsoPullback hU.fromSpec).app N).symm
  -- Step 2: The image of ⊤ under hU.fromSpec equals U (Stacks 01HH-style bridge).
  have hImg : (hU.fromSpec ''ᵁ (⊤ : (Spec Γ(Y, U)).Opens) : Y.Opens) = U := by
    rw [Scheme.Hom.image_top_eq_opensRange]; exact hU.opensRange_fromSpec
  -- Step 3: section-level map from the iso, then the rfl identification
  -- `Γ(N.restrict hU.fromSpec, ⊤) = Γ(N, hU.fromSpec ''ᵁ ⊤)` (per
  -- `Scheme.Modules.restrict_obj`), then a presheaf restriction along the
  -- propositional equality `hU.fromSpec ''ᵁ ⊤ = U` to land in `Γ(N, U)`.
  -- Define the additive equivalence.
  let toFun : Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) → Γ(N, U) := fun x =>
    (N.presheaf.map (eqToHom hImg.symm).op).hom ((Scheme.Modules.Hom.app isoSheaf.hom ⊤).hom x)
  let invFun : Γ(N, U) → Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) := fun y =>
    (Scheme.Modules.Hom.app isoSheaf.inv ⊤).hom ((N.presheaf.map (eqToHom hImg).op).hom y)
  have left_inv : Function.LeftInverse invFun toFun := by
    intro x
    simp only [invFun, toFun, ← AddCommGrpCat.comp_apply, ← Functor.map_comp, ← op_comp,
      eqToHom_trans, eqToHom_refl, op_id, CategoryTheory.Functor.map_id,
      AddCommGrpCat.hom_id, AddMonoidHom.id_apply,
      ← Scheme.Modules.Hom.comp_app, isoSheaf.hom_inv_id, Scheme.Modules.Hom.id_app]
  have right_inv : Function.RightInverse invFun toFun := by
    intro y
    simp only [invFun, toFun, ← AddCommGrpCat.comp_apply, ← Scheme.Modules.Hom.comp_app,
      isoSheaf.inv_hom_id, Scheme.Modules.Hom.id_app,
      AddCommGrpCat.hom_id, AddMonoidHom.id_apply,
      ← Functor.map_comp, ← op_comp, eqToHom_trans, eqToHom_refl, op_id,
      CategoryTheory.Functor.map_id]
  have map_add' : ∀ x y, toFun (x + y) = toFun x + toFun y := by
    intro x y
    change (AddCommGrpCat.Hom.hom (N.presheaf.map (eqToHom hImg.symm).op))
      ((AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) (x + y)) =
      _ + _
    rw [show ((AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) (x + y)) =
      (AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) x +
      (AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤)) y from
      AddMonoidHom.map_add _ _ _]
    exact AddMonoidHom.map_add _ _ _
  let addEq : Γ((Scheme.Modules.pullback hU.fromSpec).obj N, ⊤) ≃+ Γ(N, U) :=
    { toFun := toFun
      invFun := invFun
      left_inv := left_inv
      right_inv := right_inv
      map_add' := map_add' }
  -- Upgrade to a `Γ(Y, U)`-LinearEquiv via the smul compatibility.
  refine ⟨addEq.toLinearEquiv ?_⟩
  -- Smul-compatibility:
  intro r x
  -- The LHS `r • x` is `Module.compHom`-action: `r • x = (ΓSpecIso _).inv.hom r • x`
  -- with the natural Γ(Spec Γ(Y, U), ⊤)-action on the pullback module sheaf at ⊤.
  -- Step A: Reduce r • x on the LHS to (ΓSpecIso).inv.hom r • x with natural action.
  change (AddCommGrpCat.Hom.hom (N.presheaf.map (eqToHom hImg.symm).op))
    ((AddCommGrpCat.Hom.hom (Scheme.Modules.Hom.app isoSheaf.hom ⊤))
      ((CommRingCat.Hom.hom (Scheme.ΓSpecIso _).inv) r • x)) = _
  -- Step B: Apply Hom.app_smul (Γ(Spec ⊤)-linearity of the SheafOfModules iso),
  -- which migrates the scalar through `Scheme.Modules.Hom.app isoSheaf.hom ⊤`.
  rw [Scheme.Modules.Hom.app_smul]
  -- Step C (iter-192 Lane F closure): the residual identity is the substantive
  -- Stacks 01HH-style ring compatibility:
  --   Y.presheaf.map (eqToHom hImg.symm).op
  --     ((hU.fromSpec.appIso ⊤).inv ((ΓSpecIso _).inv.hom r)) = r,
  -- combined with `Scheme.Modules.map_smul` to pull the algebra-map image
  -- through the presheaf restriction.
  --
  -- The recipe (per `analogies/lane-f-restrictscalars-smul.md`):
  -- Step A: aliasing-`let` `y : Γ(N, hU.fromSpec ''ᵁ ⊤)` to make the smul-unfold
  -- on the restrict-of-N section visible as a Y-side action via
  -- `restrictFunctor`'s definition (smul is `(appIso ⊤).inv.hom s` on Y-side).
  -- Step B: `Scheme.Modules.map_smul` to migrate the scalar through the
  -- presheaf restriction.
  -- Step C: the categorical key identity
  --   (ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫
  --     Y.presheaf.map (eqToHom hImg.symm).op = 𝟙 _
  -- via `appLE_appIso_inv` + `fromSpec_app_self` + `Hom.appLE` unfolding.
  -- Step A: aliasing-`let` to bring the Y-side smul into instance scope.
  set y : ↑Γ(N, hU.fromSpec ''ᵁ ⊤) := (Scheme.Modules.Hom.app isoSheaf.hom ⊤).hom x
    with hy
  -- Step A continued: the Γ(Spec _, ⊤)-smul on `y` (under its restrict-of-N
  -- view) is rfl-equal to the Y-side smul via `(hU.fromSpec.appIso ⊤).inv`.
  change (N.presheaf.map (eqToHom hImg.symm).op).hom
    (((hU.fromSpec.appIso ⊤).inv.hom ((Scheme.ΓSpecIso Γ(Y, U)).inv.hom r)) • y) =
    r • (N.presheaf.map (eqToHom hImg.symm).op).hom y
  -- Step B: migrate the Y-side scalar through `N.presheaf.map`.
  rw [Scheme.Modules.map_smul]
  -- Step C: reduce the scalar identity to the categorical key identity.
  congr 1
  -- Goal: (Y.presheaf.map (eqToHom hImg.symm).op).hom
  --        ((hU.fromSpec.appIso ⊤).inv.hom ((Scheme.ΓSpecIso _).inv.hom r)) = r.
  -- Build the key categorical identity:
  --   (ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫
  --     Y.presheaf.map (eqToHom hImg.symm).op = 𝟙 _.
  have e₀ : (⊤ : (Spec Γ(Y, U)).Opens) ≤ hU.fromSpec ⁻¹ᵁ U :=
    le_of_eq hU.fromSpec_preimage_self.symm
  -- Sub-key: `hU.fromSpec.appLE U ⊤ e₀ = (ΓSpecIso _).inv` (via fromSpec_app_self).
  have h_appLE : hU.fromSpec.appLE U ⊤ e₀ = (Scheme.ΓSpecIso Γ(Y, U)).inv := by
    simp [Scheme.Hom.appLE, hU.fromSpec_app_self, ← Functor.map_comp]
  -- Apply `appLE_appIso_inv` and combine.
  have h_combine :
      (Scheme.ΓSpecIso Γ(Y, U)).inv ≫ (hU.fromSpec.appIso ⊤).inv =
        Y.presheaf.map (homOfLE (le_of_eq hImg)).op := by
    rw [← h_appLE]
    exact Scheme.Hom.appLE_appIso_inv hU.fromSpec e₀
  -- Post-compose with `Y.presheaf.map (eqToHom hImg.symm).op` to collapse to 𝟙.
  have h_key :
      (Scheme.ΓSpecIso Γ(Y, U)).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫
        Y.presheaf.map (eqToHom hImg.symm).op = 𝟙 _ := by
    rw [← Category.assoc, h_combine, ← Functor.map_comp, ← op_comp]
    -- The composite `eqToHom hImg.symm ≫ homOfLE _ : U ⟶ U` in `Y.Opens` is `𝟙 U`
    -- by `Subsingleton` of the poset structure on `Opens Y`.
    simp
  -- Apply h_key elementwise to r.
  exact congr($h_key r)

/-- **Section-level LinearEquiv via the Tilde route** (iter-188 Lane F NAMED
HELPER, iter-189 unbundling refactor).

The substantive transport-and-intertwining helper: given a morphism `g : Y ⟶ X`
of schemes, a quasi-coherent module `N` on `X`, and affine opens
`V ⊆ X`, `U ⊆ Y` with `U ⊆ g⁻¹ V`, produces:
- a `Γ(Y, U)`-linear equiv between `TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V)`
  and `Γ((pullback g).obj N, U)`, and
- a proof that this equiv sends `1 ⊗ x` to `pullback_app_isoTensor_baseMap g N e x`
  (the Beck-Chevalley compatibility).

The construction follows the iter-187 analogist-licensed Tilde route
(`analogies/quotscheme-isbasechange-tilde.md`):
  Step 1: identify `N|_V ≅ tilde Γ(N, V)` on `Spec Γ(X, V)` using
    `[N.IsQuasicoherent]` (extract a presentation on the affine open
    after transporting via `hV.isoSpec`).
  Step 2: pull back via `Spec.map φ : Spec Γ(Y, U) ⟶ Spec Γ(X, V)`,
    where `φ = g.appLE V U e`; apply `pullback_tildeIso` to obtain
    `(pullback (Spec.map φ)).obj (tilde Γ(N, V)) ≅
      tilde (Γ(Y, U) ⊗ Γ(N, V))` on `Spec Γ(Y, U)`.
  Step 3: transport via `hU.isoSpec` back to `U`-sections of
    `(pullback g).obj N`.
  Step 4: evaluate at `⊤` via `tilde.isoTop` to extract the section-level
    linear equiv.
  Step 5: verify the intertwining via naturality of the adjunction unit
    (the Beck-Chevalley compatibility check; ~30-50 LOC).

The substantive Mathlib gap content (Stacks 01HQ "pullback of tilde =
tilde of base change", plus the affine-open / Spec transport) is
factored into the present helper's body as a typed sorry. Once
`pullback_tildeIso` lands axiom-clean (iter-189+ sub-build) and the
transport infrastructure is in place, this helper closes axiom-clean
in ~30-50 LOC. -/
private theorem pullback_app_isoTensor_baseMap_sectionLinearEquiv
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) [N.IsQuasicoherent]
    {U : Y.Opens} {V : X.Opens}
    (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
      Module.compHom _ (g.appLE V U e).hom
    Nonempty {f : TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) ≃ₗ[Γ(Y, U)]
                Γ((Scheme.Modules.pullback g).obj N, U) //
      ∀ x : Γ(N, V),
        f (1 ⊗ₜ[Γ(X, V)] x) = pullback_app_isoTensor_baseMap g N e x} := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  -- iter-189 Lane F unbundle (per `analogies/lane-f-isbasechange.md`
  -- Decision 4): three Mathlib gaps are now pinned as separately-named
  -- typed sorries; the body of `_sectionLinearEquiv` is reduced to
  -- compositional bookkeeping over the chain.
  --
  -- Step 1 (Stacks 01I8 — `tildeIso_of_isQuasicoherent_isAffineOpen`):
  --   `N|_{Spec Γ(X, V)} ≅ tilde Γ(N, V)`  on  `Spec Γ(X, V)`.
  -- Pulling back along `Spec.map φ : Spec Γ(Y, U) ⟶ Spec Γ(X, V)`
  -- (where `φ = g.appLE V U e`) and applying Step 2 (`pullback_tildeIso`,
  -- Stacks 01HQ) gives `(Spec.map φ)^* tilde Γ(N, V) ≅
  --   tilde (Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V))`.
  -- Identifying the two compositions via the commutative square
  -- `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec` and applying Step 3
  -- transport (`pullback_of_openImmersion_iso_restrict`) brings the
  -- section back to `U` itself. Evaluating tilde at `⊤` via
  -- `tilde.isoTop` extracts the section-level data; the underlying
  -- module of `tilde (Γ(Y, U) ⊗ Γ(N, V))` at `⊤` is exactly
  -- `Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V)`. The intertwining at `1 ⊗ x` (the
  -- Beck-Chevalley check) follows from naturality of the adjunction
  -- unit `pullback_app_isoTensor_unitAtV`.
  obtain ⟨⟨step1, _step1_apply⟩⟩ :=
    tildeIso_of_isQuasicoherent_isAffineOpen N _hV
  obtain ⟨⟨step2, _step2_apply⟩⟩ :=
    pullback_tildeIso (g.appLE V U e) (ModuleCat.of Γ(X, V) Γ(N, V))
  obtain ⟨step3⟩ :=
    pullback_of_openImmersion_iso_restrict
      ((Scheme.Modules.pullback g).obj N) _hU
  -- iter-193 Lane F: assemble the iso chain at the sheaf level.
  -- The commutative square `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec`
  -- (where `φ = g.appLE V U e`) comes from Mathlib's
  -- `IsAffineOpen.SpecMap_appLE_fromSpec`.
  have h_eq : _hU.fromSpec ≫ g = Spec.map (g.appLE V U e) ≫ _hV.fromSpec :=
    (IsAffineOpen.SpecMap_appLE_fromSpec g _hV _hU e).symm
  -- Sheaf-level iso chain (5-step compositional transport):
  --   (pullback hU.fromSpec).obj ((pullback g).obj N)
  -- = (pullback g ⋙ pullback hU.fromSpec).obj N                         [defeq]
  -- ≅ (pullback (hU.fromSpec ≫ g)).obj N             [pullbackComp]
  -- ≅ (pullback (Spec.map φ ≫ hV.fromSpec)).obj N    [pullbackCongr h_eq]
  -- ≅ (pullback (Spec.map φ)).obj ((pullback hV.fromSpec).obj N)
  --                                                   [(pullbackComp).symm]
  -- ≅ (pullback (Spec.map φ)).obj (tilde Γ(N, V))    [step1 (Stacks 01I8)]
  -- ≅ tilde (TensorProduct Γ(X,V) Γ(Y,U) Γ(N,V))     [step2 (Stacks 01HQ)]
  let composedIso :=
    ((Scheme.Modules.pullbackComp _hU.fromSpec g).app N ≪≫
      (Scheme.Modules.pullbackCongr h_eq).app N ≪≫
      ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e)) _hV.fromSpec).app N).symm ≪≫
      (Scheme.Modules.pullback (Spec.map (g.appLE V U e))).mapIso step1 ≪≫
      step2)
  -- iter-193 Lane F partial: the AddEquiv from sheaf-level `composedIso` at
  -- ⊤-sections is established below. The remaining residual (iter-194+) is:
  -- (a) chain `topAdd` with `tilde.isoTop.symm` to land in TensorProduct;
  -- (b) upgrade AddEquiv → Γ(Y, U)-LinearEquiv via Hom.app_smul + ΓSpecIso;
  -- (c) compose with `step3` to reach Γ((pullback g).obj N, U);
  -- (d) verify the Beck-Chevalley intertwining `1 ⊗ x ↦ baseMap g N e x`
  --     using naturality of the adjunction unit `pullback_app_isoTensor_unitAtV`.
  let topAdd :=
    { toFun := fun x => (Scheme.Modules.Hom.app composedIso.hom ⊤).hom x
      invFun := fun y => (Scheme.Modules.Hom.app composedIso.inv ⊤).hom y
      left_inv := fun x => by
        simp only [← AddCommGrpCat.comp_apply,
          ← Scheme.Modules.Hom.comp_app, composedIso.hom_inv_id,
          Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
      right_inv := fun y => by
        simp only [← AddCommGrpCat.comp_apply,
          ← Scheme.Modules.Hom.comp_app, composedIso.inv_hom_id,
          Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
      map_add' := fun x y =>
        (Scheme.Modules.Hom.app composedIso.hom ⊤).hom.map_add x y
      : Γ((Scheme.Modules.pullback _hU.fromSpec).obj ((Scheme.Modules.pullback g).obj N), ⊤) ≃+ _ }
  -- iter-194 Lane F LinearEquiv extraction (PUSH-BEYOND, axiom-clean):
  -- (a) Upgrade `topAdd` to a `Γ(Y, U)`-LinearEquiv via `Hom.app_smul` and the
  --     `Module.compHom _ (Scheme.ΓSpecIso _).inv.hom` recipe.
  -- (b) Compose with `(tilde.isoTop _).symm.toLinearEquiv` to land in the
  --     TensorProduct module (the underlying type is the same as
  --     `(modulesSpecToSheaf.obj (tilde _)).presheaf.obj (.op ⊤)`, and the
  --     `Γ(Y, U)`-module structures agree by `Module.compHom`/`restrictScalars`
  --     defeq).
  -- (c) Compose with `step3` to land in `Γ((pullback g).obj N, U)`.
  -- (d) Beck-Chevalley intertwining: typed sorry (see ARCHITECTURAL NOTE below).
  -- Introduce a local alias for the target ModuleCat to avoid Γ-notation
  -- ambiguity inside type ascriptions.
  let TR : ModuleCat (Γ(Y, U)) :=
    ModuleCat.of (Γ(Y, U)) (TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V))
  letI algSpecΓ : Algebra Γ(Y, U) Γ((Spec Γ(Y, U)), ⊤) :=
    (Scheme.ΓSpecIso _).inv.hom.toAlgebra
  letI modTilde : Module Γ(Y, U) Γ(tilde TR, ⊤) :=
    Module.compHom _ (Scheme.ΓSpecIso Γ(Y, U)).inv.hom
  -- We also need the same Module.compHom-instance on the source of `topAdd`,
  -- matching the one used by `step3` (it is set up there via a `letI` inside
  -- the theorem signature; we restate it here so it is in scope for `topLin`).
  letI modSrc : Module Γ(Y, U) Γ((Scheme.Modules.pullback _hU.fromSpec).obj
      ((Scheme.Modules.pullback g).obj N), ⊤) :=
    Module.compHom _ (Scheme.ΓSpecIso Γ(Y, U)).inv.hom
  -- Step (a): upgrade `topAdd` to Γ(Y, U)-linear via `Hom.app_smul`.
  let topLin : Γ((Scheme.Modules.pullback _hU.fromSpec).obj
        ((Scheme.Modules.pullback g).obj N), ⊤)
        ≃ₗ[Γ(Y, U)] Γ(tilde TR, ⊤) := by
    refine topAdd.toLinearEquiv ?_
    intro r x
    -- Module.compHom on both sides: r • _ = (ΓSpecIso _).inv.hom r • _.
    change (Scheme.Modules.Hom.app composedIso.hom ⊤).hom
      ((Scheme.ΓSpecIso _).inv.hom r • x) =
      (Scheme.ΓSpecIso _).inv.hom r • (Scheme.Modules.Hom.app composedIso.hom ⊤).hom x
    exact Scheme.Modules.Hom.app_smul composedIso.hom _ x
  -- Step (b): chain with `(tilde.isoTop _).symm.toLinearEquiv`.
  let toTensor : Γ((Scheme.Modules.pullback _hU.fromSpec).obj
        ((Scheme.Modules.pullback g).obj N), ⊤) ≃ₗ[Γ(Y, U)]
        TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) :=
    topLin.trans (tilde.isoTop TR).symm.toLinearEquiv
  -- Step (c): compose with `step3`.
  let f : TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) ≃ₗ[Γ(Y, U)]
          Γ((Scheme.Modules.pullback g).obj N, U) :=
    toTensor.symm.trans step3
  refine ⟨⟨f, ?_⟩⟩
  intro x
  -- Step (d): Beck-Chevalley intertwining at `1 ⊗ₜ x`.
  --
  -- ARCHITECTURAL NOTE (iter-194 Lane F finding). The intertwining
  -- `f (1 ⊗ₜ x) = baseMap g N e x` provably DEPENDS on the bodies of `step1`
  -- (Stacks 01I8) and `step2` (Stacks 01HQ): the LHS unfolds to
  -- `step3 (composedIso.inv.app ⊤ (toOpen TR ⊤ (1 ⊗ₜ x)))`, which traces
  -- through `step1.inv` and `step2.inv` evaluated at sections. Since `step1`
  -- and `step2` are currently `Nonempty (... ≅ ...)` typed-sorry pins, their
  -- isos are opaque (Classical.choice-style), so the LHS cannot be reduced
  -- to a closed form. The intertwining is therefore axiom-clean ONLY after
  -- (a) `step1`'s body lands (or its signature is strengthened to a Σ-pair
  -- carrying the canonical `step1 = (asIso fromTildeΓ).symm` identity), AND
  -- (b) `step2`'s body lands similarly with the canonical Spec base-change
  -- iso identity. Iter-195+ writer/refactor work: choose the signature
  -- strengthening path so `_sectionLinearEquiv` body fully axiom-cleans.
  --
  -- LINEAREQUIV PORTION (Steps a-c): axiom-clean. The construction
  -- `f = toTensor.symm ≪≫ₗ step3` is concretely built from the abstract
  -- iso chain + tilde.isoTop + Hom.app_smul upgrade.
  exact sorry

/-- **Substantive `IsBaseChange` claim** for the affine-open section formula
(iter-187 Lane F — analogist-informed refactor; iter-188 closes axiom-clean
via the named section-LinearEquiv helper).

Per iter-187 analogist verdict (`analogies/quotscheme-isbasechange-tilde.md`):
the iso comes from the named Spec-level helper `pullback_tildeIso`
combined with `TensorProduct.isBaseChange` + `IsBaseChange.of_equiv`; the
substantive Mathlib gap (Stacks tag 01HQ / 0BJ8: "pullback of tilde =
tilde of base change") is *factored* into the standalone helper
`pullback_tildeIso` above.

The hypothesis `[N.IsQuasicoherent]` is added per analogist Decision 3:
the Tilde-route strictly requires `N|_V ∈ essImage tilde` on
`Spec(Γ(X, V))`, which follows from quasi-coherence + `hV.isoSpec`.

**iter-188 closure**: body assembled via the named helper
`pullback_app_isoTensor_baseMap_sectionLinearEquiv` (which packages the
LinearEquiv with the intertwining property) combined with
`IsBaseChange.of_equiv`. The body itself is axiom-clean; the residual
Mathlib gap (Stacks 01HQ transport) is fully localized in the named
helper's typed sorry. -/
private theorem pullback_app_isoTensor_baseMap_isBaseChange
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) [N.IsQuasicoherent]
    {U : Y.Opens} {V : X.Opens}
    (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
      Module.compHom _ (g.appLE V U e).hom
    haveI : IsScalarTower Γ(X, V) Γ(Y, U) Γ((Scheme.Modules.pullback g).obj N, U) :=
      .of_algebraMap_smul fun _ _ ↦ rfl
    IsBaseChange Γ(Y, U) (pullback_app_isoTensor_baseMap g N e) := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  haveI : IsScalarTower Γ(X, V) Γ(Y, U) Γ((Scheme.Modules.pullback g).obj N, U) :=
    .of_algebraMap_smul fun _ _ ↦ rfl
  -- Extract the section-level LinearEquiv with its intertwining property
  -- from the named helper. The substantive Mathlib-gap content
  -- (Stacks 01HQ transport) is fully localized inside the helper.
  obtain ⟨equiv, hApp⟩ := pullback_app_isoTensor_baseMap_sectionLinearEquiv g N _hU _hV e
  -- Apply `IsBaseChange.of_equiv`: from an equiv `TensorProduct R S M ≃ N`
  -- that intertwines the canonical `m ↦ 1 ⊗ m` with `f`, conclude
  -- `IsBaseChange S f`.
  exact IsBaseChange.of_equiv equiv hApp

/-- **Combined Tilde-isoTop content**: the IsBaseChange witness `.equiv.symm`
gives the desired affine-open section formula iso.

iter-187 Lane F: `[N.IsQuasicoherent]` hypothesis added per analogist
Decision 3 — required by the Tilde route and natural for the Stacks 02KH
consumer chain. -/
private theorem pullback_app_isoTensor_isBaseChange
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) [N.IsQuasicoherent]
    {U : Y.Opens} {V : X.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    Nonempty (Γ((Scheme.Modules.pullback g).obj N, U) ≃ₗ[Γ(Y, U)]
      TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V)) := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  haveI : IsScalarTower Γ(X, V) Γ(Y, U) Γ((Scheme.Modules.pullback g).obj N, U) :=
    .of_algebraMap_smul fun _ _ ↦ rfl
  -- iter-186 Lane F Step 2 (DONE axiom-clean): baseMap built above.
  -- iter-187+ Lane F Step 3+4: the IsBaseChange Prop carries the
  -- Tilde-isoTop substantive content in
  -- `pullback_app_isoTensor_baseMap_isBaseChange`. Once that closes,
  -- `.equiv.symm` axiom-cleans this theorem.
  exact ⟨(pullback_app_isoTensor_baseMap_isBaseChange g N hU hV e).equiv.symm⟩

/-- **Affine-open section formula for the module pullback** (iter-185 Lane F:
PIVOT — body discharges via `pullback_app_isoTensor_isBaseChange`).

Closes axiom-clean given the named substantive helper above. The pre-iter-185
unnamed body sorry has been *replaced* by the named typed sorry inside
`pullback_app_isoTensor_isBaseChange`, plus the axiom-clean construction of
the underlying base linear map in `pullback_app_isoTensor_unitAtV`.

iter-187 Lane F: `[N.IsQuasicoherent]` hypothesis added (analogist
Decision 3). -/
noncomputable def Scheme.Modules.pullback_app_isoTensor
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) [N.IsQuasicoherent]
    {U : Y.Opens} {V : X.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    Γ((Scheme.Modules.pullback g).obj N, U) ≃ₗ[Γ(Y, U)]
      TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  -- iter-185 Lane F substantive step: body closes via the named helper
  -- `pullback_app_isoTensor_isBaseChange` (typed sorry on the algebraic
  -- Stacks 02KE / 01HQ content). The `unitAtV` linear map factoring
  -- through the adjunction is built axiom-clean as
  -- `pullback_app_isoTensor_unitAtV`. Iter-186+ closes the helper body
  -- via the Tilde-isoTop route.
  exact (pullback_app_isoTensor_isBaseChange g N hU hV e).some

/-- **Affine-base case of flat base change at affine opens** (Stacks tag 02KH).

Specialization of `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` to
the case where the *base* `S` is affine, so we may take `V := ⊤ : S.Opens`
as the (trivially affine) compatible open: every affine `U ⊆ S'` satisfies
`U ≤ (Opens.map g.base).obj ⊤ = ⊤`.

iter-187 Lane F (analogist-informed REFACTOR, per
`analogies/quotscheme-isbasechange-tilde.md` Decision 1): the
prior iter-186 framing routed through `Module.Flat.isBaseChange`,
which is a **category mistake** — that Mathlib lemma is a *consumer*
of `IsBaseChange` (it propagates flatness *across* a given IsBaseChange
witness, Stacks 00H8 in the conclusion direction), NOT a producer.
The corrected route uses `pullback_app_isoTensor g' …` directly: the
section-level iso is `(pullback_app_isoTensor g' …).symm`, and the
residual gap is *Beck–Chevalley compatibility* (the canonical BC arrow
agrees with the section-formula iso under the `pushforward_obj_obj`-rfl
identification) plus the section-vs-tensor-product Tilde-isoTop content
(now factored into `pullback_tildeIso`).

iter-187 Lane F adds `[F.IsQuasicoherent]` per analogist Decision 3:
this is the standard Stacks 02KH hypothesis on the input sheaf `F`. Via
`pushforward_isQuasicoherent` (named project-side helper for Stacks
01XJ), it propagates to `((pushforward f).obj F).IsQuasicoherent`, which
is what `pullback_app_isoTensor` needs.

The body's substantive content is now fully encapsulated in
`pullback_app_isoTensor` (LHS) and in `pullback_tildeIso` (the genuine
Mathlib gap). The Beck-Chevalley compatibility residual is iter-188+
~30-50 LOC of route-stitching. -/
private theorem canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [IsAffine S]
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) [F.IsQuasicoherent]
    (U : S'.Opens) (_hU : IsAffineOpen U) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) := by
  -- Take `V := ⊤ : S.Opens`, affine via `[IsAffine S]`.
  have hV : IsAffineOpen (⊤ : S.Opens) := isAffineOpen_top S
  -- Every `U : S'.Opens` automatically satisfies `U ≤ g ⁻¹ᵁ ⊤`.
  have e : U ≤ g ⁻¹ᵁ (⊤ : S.Opens) := le_top
  -- Algebra structure on the affine ring map `Γ(S, ⊤) →+* Γ(S', U)`.
  letI algInst : Algebra Γ(S, ⊤) Γ(S', U) := (g.appLE (⊤ : S.Opens) U e).hom.toAlgebra
  -- Quasi-coherence propagates to the pushforward under qcqs `f` (Stacks
  -- 01XJ), pinned in `pushforward_isQuasicoherent`.
  haveI : ((Scheme.Modules.pushforward f).obj F).IsQuasicoherent :=
    pushforward_isQuasicoherent f F
  -- LHS: identify the section of the pullback as a tensor product via
  -- the typed-sorry `pullback_app_isoTensor` applied to
  -- `(N := (pushforward f).obj F)`. The output is
  --   `Γ(S', U) ⊗_{Γ(S, ⊤)} Γ((pushforward f).obj F, ⊤)
  --  = Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f ⁻¹ᵁ ⊤)`
  -- (the last identification by `pushforward_obj_obj`).
  let _isoLHS := Scheme.Modules.pullback_app_isoTensor g
    ((Scheme.Modules.pushforward f).obj F) _hU hV e
  -- RHS: the section formula iso from `pullback_app_isoTensor g' …`
  -- applied to the *base-changed* sheaf, plus the Beck–Chevalley
  -- compatibility check. The substantive Mathlib gap content is in
  -- `pullback_tildeIso` (Stacks 01HQ).
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
    (F : X.Modules) [F.IsQuasicoherent]
    (U : S'.Opens) (_hU : IsAffineOpen U) :
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
    (F : X.Modules) [F.IsQuasicoherent]
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
    (F : X.Modules) [F.IsQuasicoherent] (U : S'.Opens) :
    IsIso (((canonicalBaseChangeMap sq).app F).app U) :=
  -- Composition of the two named substantive helpers: the affine-open case
  -- via `pullback_app_isoTensor` + `pullback_tildeIso`, then the
  -- Mayer-Vietoris descent (iter-187 Lane F: corrected framing — the
  -- prior `Module.Flat.isBaseChange` citation was a category mistake).
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
    (F : X.Modules) [F.IsQuasicoherent] :
    IsIso ((canonicalBaseChangeMap sq).app F) :=
  Scheme.Modules.Hom.isIso_iff_isIso_app.mpr
    (fun U => canonicalBaseChangeMap_app_app_isIso sq F U)

theorem flatBaseChangeCohomology {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g)
    [QuasiCompact f] [QuasiSeparated f] [Flat g]
    (F : X.Modules) [F.IsQuasicoherent] :
    Nonempty ((Scheme.Modules.pullback g).obj
                ((Scheme.Modules.pushforward f).obj F) ≅
              (Scheme.Modules.pushforward f').obj
                ((Scheme.Modules.pullback g').obj F)) :=
  -- Build the canonical Beck-Chevalley base-change map and wrap it in `asIso`
  -- using the iso-claim from `canonicalBaseChangeMap_isIso`.
  ⟨@asIso _ _ _ _ _ (canonicalBaseChangeMap_isIso sq F)⟩

end AlgebraicGeometry
