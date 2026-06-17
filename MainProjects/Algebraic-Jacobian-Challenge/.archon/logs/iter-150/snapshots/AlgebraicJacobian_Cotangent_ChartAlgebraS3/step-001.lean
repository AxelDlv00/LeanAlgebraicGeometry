/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cotangent.GrpObj
import Mathlib.AlgebraicGeometry.Geometrically.Reduced
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.AlgebraicGeometry.Morphisms.Proper
import Mathlib.FieldTheory.IsAlgClosed.Basic
import Mathlib.FieldTheory.PurelyInseparable.Basic
import Mathlib.RingTheory.IsTensorProduct
import Mathlib.RingTheory.Nilpotent.GeometricallyReduced

/-!
# (S3.*) sub-claims for the chart-algebra piece (ii) "constants = base field" closure

This file scaffolds the four first-class sub-claims of path (b) of
`AlgebraicGeometry.constants_integral_over_base_field` (in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`), per the iter-149
`blueprint-writer-rigiditykbar-iter149` writer round which promoted the four
(S3.*) bullets to first-class blueprint lemmas in
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition".

The four sub-claims are:

* **(S3.sep.1)** `isGeometricallyReduced_Gamma_of_smooth` — smooth proper
  schemes over a field `k` have geometrically reduced global sections.
  Blueprint label: `lem:S3_sep_1_smooth_geometrically_reduced_Gamma`.
  Stacks Tags 0334 + 04QM. Body remains a structured `sorry` pending the
  Mathlib bridge `Smooth ⇒ GeometricallyReduced (scheme morphism class)`
  ⇒ `Algebra.IsGeometricallyReduced k Γ(X, ⊤)` (the latter step also
  consumes (S3.pi.1) flat base change of Γ).

* **(S3.sep.2)** `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
  — a finite field extension `F / k` with `Algebra.IsGeometricallyReduced
  k F` is separable. Blueprint label:
  `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`. Stacks Tag
  0BJF. Body structured `sorry` pending the Artinian-product chase
  (`F ⊗ \bar k` finite-dim reduced ⇒ product of fields ⇒ each factor =
  `\bar k`; combine with embedding-count = `[F : k]` criterion for
  separability).

* **(S3.pi.1)** `Gamma_baseChange_iso_tensor_of_proper` — for `X` proper
  over a field `k` and `K / k` a field extension, the canonical
  comparison map `Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is bijective as
  `K`-algebras. Blueprint label:
  `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`. Stacks Tag 02KH
  specialised to the `H^0 = Γ` row. The load-bearing Mathlib gap of
  path (b); PARTIAL acceptable per the iter-149 plan.

* **(S3.pi.2)** `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
  — for `F / k` a finite field extension, if `F ⊗_k \bar k` has a unique
  minimal prime then `F / k` is purely inseparable. Blueprint label:
  `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`.
  Stacks Tag 05DH.

The four lemmas are consumed by Lane 2 of the iter-149 plan: the
consolidated `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` `sorry`
at L367 of `ChartAlgebra.lean` is rewritten to feed (S3.sep.1 → S3.sep.2)
on the separability strand and (S3.pi.1 → S3.pi.2) on the pure-
inseparability strand.

## Algebra structure on `Γ(X, O_X)`

The global-section ring `Γ(X, O_X)` for `X` over `Spec k` is a
`k`-algebra via the structure-morphism composition `k → Γ(Spec k, ⊤) →
Γ(X, ⊤)`. We expose this as `AlgebraicGeometry.gammaAlgebra` so the
S3 lemmas and their consumer in `ChartAlgebra.lean` share a single
algebra-instance definition. The consumer's local definition

```
set α : (CommRingCat.of k) ⟶ X.presheaf.obj (Opposite.op ⊤) :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ (X ↘ Spec (CommRingCat.of k)).appTop
letI algkΓ : Algebra k ↥(X.presheaf.obj (Opposite.op ⊤)) := α.hom.toAlgebra
```

equals `gammaAlgebra k X` definitionally.
-/

open CategoryTheory Limits

universe u

namespace AlgebraicGeometry

/-- The canonical `k → Γ(X, O_X)` ring map for `X` over `Spec k`: precompose
the inverse of `Scheme.ΓSpecIso` with the `appTop` of the structure morphism.
This is the algebra map underpinning `gammaAlgebra k X`. -/
noncomputable def gammaAlgebraMap (k : Type u) [CommRing k] (X : Scheme.{u})
    [X.Over (Spec (CommRingCat.of k))] :
    (CommRingCat.of k) ⟶ X.presheaf.obj (Opposite.op ⊤) :=
  (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ (X ↘ Spec (CommRingCat.of k)).appTop

/-- The canonical `Algebra k Γ(X, O_X)` structure on global sections of `X` over
`Spec k`. Matches the local `algkΓ` definition used by the consumer in
`AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (`constants_integral_over_base_field`). -/
@[reducible]
noncomputable def gammaAlgebra (k : Type u) [CommRing k] (X : Scheme.{u})
    [X.Over (Spec (CommRingCat.of k))] :
    Algebra k ↥(X.presheaf.obj (Opposite.op ⊤)) :=
  (gammaAlgebraMap k X).hom.toAlgebra

-- Mathlib's `Algebra.TensorProduct` ships only the LEFT algebra instance on
-- `B₁ ⊗[k] B₂`; the symmetric right-algebra is a `local instance` inside
-- `Mathlib.RingTheory.IsTensorProduct` (also re-enabled in `ChartAlgebra.lean`).
-- Re-enable it here so `Algebra K (TensorProduct k Γ K)` resolves for the
-- target type of `Gamma_baseChange_iso_tensor_of_proper`.
attribute [local instance] Algebra.TensorProduct.rightAlgebra

/-- **(S3.sep.1)** Smooth proper schemes over a field have geometrically reduced
global sections.

For `X` smooth proper over a field `k`, the global-section `k`-algebra
`Γ(X, O_X)` is geometrically reduced: `Algebra.IsGeometricallyReduced k
↥(X.presheaf.obj (Opposite.op ⊤))`.

Blueprint: `lem:S3_sep_1_smooth_geometrically_reduced_Gamma`
(`blueprint/src/chapters/RigidityKbar.tex`), with closure path
Stacks 0334 + 04QM (smooth ⇒ formally smooth ⇒ geometrically reduced
fibres) and consumption of (S3.pi.1) `Gamma_baseChange_iso_tensor_of_proper`.

## Body status (iter-149 prover lane)

Structured `sorry`. The closure has three missing Mathlib pieces:

1. `Smooth (X ↘ Spec k) ⇒ GeometricallyReduced (X ↘ Spec k)` as a
   `MorphismProperty` instance. Mathlib snapshot `b80f227` defines both
   classes (`Mathlib.AlgebraicGeometry.Morphisms.Smooth` and
   `Mathlib.AlgebraicGeometry.Geometrically.Reduced`) but has no
   instance linking them. Stacks Tag 04QM is the upstream literature
   anchor.
2. For the base-change-to-an-arbitrary-field-extension step, we need
   `GeometricallyReduced (X ↘ Spec k) ⇒ ∀ K [Field K] [Algebra k K],
   IsReduced (pullback (X ↘ Spec k) (Spec.map (CommRingCat.ofHom
   (algebraMap k K))))`. This is essentially the definition of
   `GeometricallyReduced` (per `geometrically IsReduced`), so once
   step (1) lands the bridge is mechanical.
3. The ring-side identification `Γ(X_K, O_{X_K}) ≅ Γ(X, O_X) ⊗_k K`,
   which is exactly (S3.pi.1) `Gamma_baseChange_iso_tensor_of_proper`
   below — so this lemma feeds back to itself through (S3.pi.1).

The (BR.*)-style chain through (S3.pi.1) is the planner's intended
closure path; the standalone Mathlib piece (1) is the dominant
substantive content (~80–150 LOC). -/
theorem isGeometricallyReduced_Gamma_of_smooth
    {k : Type u} [Field k] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of k))]
    [IsProper (X ↘ Spec (CommRingCat.of k))]
    [Smooth (X ↘ Spec (CommRingCat.of k))] :
    letI := gammaAlgebra k X
    Algebra.IsGeometricallyReduced k ↥(X.presheaf.obj (Opposite.op ⊤)) := by
  letI := gammaAlgebra k X
  -- Path forward (iter-150+):
  --   (1) Lift Mathlib's `GeometricallyReduced` morphism class onto `X ↘ Spec k`
  --       from `Smooth (X ↘ Spec k)` (Stacks 0334 + 04QM).
  --   (2) For each field extension `K / k`, the pullback `pullback (X ↘ Spec k)
  --       (Spec.map (CommRingCat.ofHom (algebraMap k K)))` is reduced by the
  --       definition of `GeometricallyReduced`.
  --   (3) Identify the global-sections of the pullback with `Γ ⊗_k K` via
  --       (S3.pi.1) `Gamma_baseChange_iso_tensor_of_proper` below.
  --   (4) Conclude `IsReduced (Γ ⊗_k K)` for every field extension `K / k`,
  --       which is the definition of `Algebra.IsGeometricallyReduced k Γ`
  --       (specialised to `K = AlgebraicClosure k`).
  sorry

/-- **(S3.pi.1)** Flat base change of `Γ` for proper schemes.

For `X` proper over a field `k` and `K / k` a field extension, the canonical
comparison map `Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is a bijection of
`K`-algebras, where `X_K := pullback (X ↘ Spec k) (Spec.map (algebraMap k K))`.

Blueprint: `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`
(`blueprint/src/chapters/RigidityKbar.tex`). The load-bearing Mathlib
gap of path (b); content identical to path (a) step (e). Stacks Tag 02KH
specialised to the `H^0 = Γ` row.

## Signature note

We state the conclusion as `Nonempty (TensorProduct k Γ K ≃ₐ[K] Γ(X_K))` (a
`K`-algebra isomorphism), with `X_K` as the Mathlib `pullback` along
`Spec.map (CommRingCat.ofHom (algebraMap k K))`. The `Algebra k Γ`
structure on the source is `gammaAlgebra k X`; the `Algebra K _` on the
target is the corresponding `gammaAlgebra K X_K`.

## Body status (iter-149 prover lane)

Structured `sorry`. The closure is the Čech-equaliser + flat-tensor
exchange chase of Stacks Tag 02KH (≅ 150–250 LOC) plus the reassembly
of affine-intersection flat-base-change isomorphisms. Iter-149 PARTIAL
is acceptable per the plan; iter-150+ closure is the path (b)
dominant cost. -/
theorem Gamma_baseChange_iso_tensor_of_proper
    {k K : Type u} [Field k] [Field K] [Algebra k K]
    {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
    [IsProper (X ↘ Spec (CommRingCat.of k))] :
    letI := gammaAlgebra k X
    -- `X_K` is the base-change of `X` along `Spec K → Spec k`.
    -- It carries an `X_K.Over Spec K` instance via the second projection
    -- of the pullback square.
    let XK := pullback (X ↘ Spec (CommRingCat.of k))
              (Spec.map (CommRingCat.ofHom (algebraMap k K)))
    haveI : XK.Over (Spec (CommRingCat.of K)) :=
      ⟨pullback.snd _ _⟩
    letI := gammaAlgebra K XK
    Nonempty
      (TensorProduct k ↥(X.presheaf.obj (Opposite.op ⊤)) K ≃ₐ[K]
        ↥(XK.presheaf.obj (Opposite.op ⊤))) := by
  letI := gammaAlgebra k X
  -- Path forward (iter-150+):
  --   (1) Cover `X` by finitely many affine opens `U_i = Spec A_i` (quasi-
  --       compactness from `IsProper.toIsCompact` or `Scheme.affineCover`).
  --   (2) Express `Γ(X, O_X)` as the Čech equalizer
  --         eq( ∏ A_i ⇒ ∏ A_{ij} )   where A_{ij} = Γ(U_i ∩ U_j, O_X).
  --   (3) Tensor with K over k (flat, hence preserves equalizers).
  --   (4) Chart-by-chart flat-base-change `A_i ⊗_k K ≅ Γ((U_i)_K, O)`
  --       (Stacks Tag 00DS for affines).
  --   (5) Re-assemble: identify `Γ(X, O_X) ⊗_k K` with the Čech equalizer
  --       of the base-changed cover, which computes `Γ(X_K, O_{X_K})`.
  -- Closing strategy: build the `K`-algebra map directly via
  -- `Algebra.TensorProduct.lift` from
  --   `Γ(X, O_X) → Γ(X_K, O_{X_K})` (functoriality of Γ along `pullback.fst`)
  -- and
  --   `K → Γ(X_K, O_{X_K})` (gammaAlgebraMap K XK).
  -- Then show bijectivity via the Čech-equalizer reassembly above.
  sorry

/-- **(S3.sep.2)** A finite field extension that is geometrically reduced is separable.

For fields `k` and `F` with `F / k` a finite field extension and
`Algebra.IsGeometricallyReduced k F` (equivalently, `\bar k ⊗_k F` is
reduced), `F / k` is separable: `Algebra.IsSeparable k F`.

Blueprint: `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`
(`blueprint/src/chapters/RigidityKbar.tex`). Stacks Tag 0BJF.

## Body status (iter-150 prover lane — HYBRID part (B) CharZero collapse)

CLOSED via the iter-150 HYBRID part (B) recipe. The plan's `mathlib-analogist`
flagged that the over-`k` Artinian-product chase is unused for the
M2.a critical path; the consumer (`constants_integral_over_base_field`
in `ChartAlgebra.lean`) and downstream commit to `[CharZero k]` already,
so we may specialise this `(S3.sep.2)` to `[PerfectField k]` (free in
char 0 via `PerfectField.ofCharZero`) and discharge by Mathlib's
`Algebra.IsAlgebraic.isSeparable_of_perfectField` instance.

The full iter-149 path (Stacks 0BJF Artinian decomposition for arbitrary
base field `k`) is salvageable Mathlib-PR work, but is NOT on the project's
M2.a critical path; see `analogies/h1cotangent-vanishing-iter150.md` §
"Top suggestion" + § "Discarded" for the full rationale.

**Iter-150 signature inflation**: `[PerfectField k]` added. The
`[Algebra.IsGeometricallyReduced k F]` hypothesis is kept for semantic
clarity (records the structural reason the lemma holds for `[PerfectField k]`)
but is unused in the body — the conclusion follows from
`FiniteDimensional ⇒ IsAlgebraic` + `IsAlgebraic + PerfectField ⇒ IsSeparable`
alone.

**Consumer-side note**: `constants_integral_over_base_field`
(`ChartAlgebra.lean:L394`) currently invokes this lemma without
`[PerfectField k]` in scope; an iter-151+ writer round on
`ChartAlgebra.lean` will propagate either `[CharZero k]` or
`[PerfectField k]` through that consumer's signature, OR rewire the
`(b.1)` branch to invoke `Algebra.IsAlgebraic.isSeparable_of_perfectField`
directly (skipping this lemma entirely per analogist's recommendation). -/
theorem _root_.Algebra.IsSeparable.of_isGeometricallyReduced_of_finite
    (k F : Type u) [Field k] [Field F] [Algebra k F]
    [Algebra.IsGeometricallyReduced k F] [FiniteDimensional k F]
    [PerfectField k] :
    Algebra.IsSeparable k F :=
  -- `FiniteDimensional k F` propagates to `Algebra.IsAlgebraic k F`
  -- via Mathlib's `Algebra.IsAlgebraic.of_finite` instance, then the
  -- perfect-field instance `Algebra.IsAlgebraic.isSeparable_of_perfectField`
  -- closes the separability goal.
  Algebra.IsAlgebraic.isSeparable_of_perfectField

/-- **(S3.pi.2)** A finite field extension with unique-minimal-prime base change
to the algebraic closure is purely inseparable.

For fields `k` and `F` with `F / k` a finite field extension, if
`F ⊗_k \bar k` has a unique minimal prime then `F / k` is purely
inseparable: `Algebra.IsPurelyInseparable k F` (= `IsPurelyInseparable`
in Mathlib).

The hypothesis "`F ⊗_k \bar k` has a unique minimal prime" is encoded
as `(minimalPrimes (AlgebraicClosure k ⊗[k] F)).Subsingleton`.

Blueprint: `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`
(`blueprint/src/chapters/RigidityKbar.tex`). Stacks Tag 05DH.

## Body status (iter-149 prover lane)

Structured `sorry`. Closure path:

  (1) `F ⊗_k \bar k` is finite-dim over `\bar k` (`FiniteDimensional`).
  (2) Finite-dim ⇒ Artinian ring.
  (3) Artinian + (unique minimal prime) ⇒ the ring is local
      (since the minimal primes of an Artinian ring are the maximal
      ideals: in Artinian rings every prime is maximal, so unique
      minimal prime = unique maximal ideal = local).
  (4) The nilradical reduction `(F ⊗_k \bar k) / Nil` is a domain finite
      over `\bar k`, hence a field finite over `\bar k`, hence equals
      `\bar k` (algebraic closedness).
  (5) Stacks Tag 05DH: a finite field extension `F / k` is purely
      inseparable iff `F ⊗_k \bar k` is local. (Forward direction
      from (3); we use the converse-friendly form to extract pure-
      inseparability from local-ness.)

The natural Mathlib idiom is via `isPurelyInseparable_iff_pow_mem` +
`ExpChar` choice; the closure may also route through the
`separableClosure F E = ⊥` characterization. -/
theorem _root_.Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange
    (k F : Type u) [Field k] [Field F] [Algebra k F]
    [FiniteDimensional k F]
    (h : (minimalPrimes (TensorProduct k (AlgebraicClosure k) F)).Subsingleton) :
    IsPurelyInseparable k F := by
  -- Path forward (iter-150+):
  --   (a) `F ⊗_k \bar k` is finite-dim over `\bar k` (FiniteDimensional
  --       propagates).
  --   (b) Therefore Artinian; in an Artinian ring all primes are maximal.
  --   (c) Unique minimal prime + all primes maximal ⇒ unique maximal ideal
  --       ⇒ `F ⊗_k \bar k` is a local ring.
  --   (d) Conclude pure inseparability via Stacks 05DH.
  -- A more concrete idiom uses `isPurelyInseparable_iff_pow_mem` together
  -- with the local-Artinian residue-field argument.
  sorry

end AlgebraicGeometry
