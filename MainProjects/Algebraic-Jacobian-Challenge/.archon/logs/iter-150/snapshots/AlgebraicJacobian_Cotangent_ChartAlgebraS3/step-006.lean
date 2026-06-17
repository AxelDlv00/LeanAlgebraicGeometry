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
substantive content (~80–150 LOC).

## Iter-150 prover-lane status (HYBRID part (B) attempted; consumer-blocked)

The iter-150 PROGRESS recipe instructed HYBRID part (B) closure: add
`[CharZero k]` to the signature, derive `PerfectField k` via
`PerfectField.ofCharZero`, then route smooth ⇒ formally smooth ⇒
`PerfectField k` + `IsReduced` ⇒ `IsGeometricallyReduced k Γ`. The local
closure is blocked by two issues:

(a) Consumer compatibility: `constants_integral_over_base_field`
    (`ChartAlgebra.lean:L431`) invokes this lemma without `[CharZero k]`
    in scope. Inflating this signature breaks the consumer's `(b.1)` branch;
    coordinated iter-151+ writer round needed on `ChartAlgebra.lean` to
    propagate `[CharZero k]` (or to rewire `(b.1)` per analogist's
    recommendation).

(b) Mathlib gap: even with `[PerfectField k]`, the bridge
    `Algebra.IsSeparable k F` ⇒ `Algebra.IsGeometricallyReduced k F`
    is NOT a Mathlib instance (despite being mathematically true:
    F ⊗ \bar k splits as ∏ \bar k for separable F/k). Closure requires
    either (a) the iter-149 Stacks 0334 + 04QM scheme-morphism bridge,
    OR (b) a project-internal `Algebra.IsSeparable.isGeometricallyReduced`
    lemma (~30–50 LOC via primitive element + minimal polynomial
    splitting in `\bar k`).

The mathlib-analogist's iter-150 cross-domain consult
(`analogies/h1cotangent-vanishing-iter150.md` § "Top suggestion") in
fact recommends DROPPING (S3.sep.1) from the M2.a critical path
entirely; the consumer's (b.1) branch can close directly via
`PerfectField + Algebra.IsAlgebraic ⇒ Algebra.IsSeparable` without
the geometrically-reduced intermediate, once `[CharZero k]` is in
scope. (S3.sep.1) remains a Mathlib-PR-grade lemma for the general
over-`k` formulation. -/
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

## Body status (iter-150 prover lane — HYBRID-DEFERRED)

-- HYBRID-DEFERRED: post iter-150 HYBRID pivot, this lemma is deferred
-- indefinitely as upstream-Mathlib-PR work, NOT on the project's M2.a
-- critical path. The mathlib-analogist's iter-150 cross-domain consult
-- (`analogies/h1cotangent-vanishing-iter150.md` § "Consumer reformulation
-- over `\bar k`") flagged that for `rigidity_over_kbar` (the M2.a
-- consumer) the base field IS `\bar k`, so the `[IsAlgClosed k]` route
-- via `IsAlgClosed.algebraMap_bijective_of_isIntegral` collapses
-- `constants_integral_over_base_field` in ~15 LOC without consuming
-- (S3.pi.*) at all. The user-gate question on `[IsAlgClosed kbar]`
-- addition to `rigidity_over_kbar` (HYBRID part (A)) is open as of
-- iter-150; iter-152+ schedule may flip on user response.
--
-- The iter-149 closure path (~150–250 LOC Čech-equaliser + flat-tensor
-- chase of Stacks Tag 02KH) remains documented below as fallback for
-- the over-`k` formulation if the HYBRID part (A) user gate closes NO.

Structured `sorry`. The closure is the Čech-equaliser + flat-tensor
exchange chase of Stacks Tag 02KH (≅ 150–250 LOC) plus the reassembly
of affine-intersection flat-base-change isomorphisms. Iter-149 PARTIAL
is acceptable per the plan; iter-150+ closure is the path (b)
dominant cost (DEFERRED indefinitely per HYBRID pivot). -/
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

## Body status (iter-150 prover lane)

Structured `sorry`. The closure path:

  (1) `F ⊗_k \bar k` is finite-dim over `\bar k` (`FiniteDimensional` propagates
      under tensor product).
  (2) Finite-dim ⇒ Artinian ring (`IsArtinianRing.of_finite`).
  (3) `IsGeometricallyReduced k F` ⇒ `IsReduced (F ⊗_k \bar k)`.
  (4) Artinian + reduced ⇒ product of fields
      (`IsArtinianRing.equivPi` to a product of local Artinian factors,
      each of which is a field by the reduced hypothesis).
  (5) Each factor is finite-dim over `\bar k`; algebraic closedness of
      `\bar k` forces each factor to be `\bar k` itself.
  (6) Therefore `F ⊗_k \bar k ≅ \bar k^r` where `r = #embeddings F → \bar k`
      and `r = [F : k]`; this equality is the criterion for separability
      of a finite field extension.

Step (4) is the dominant cost; steps (1)–(3) and (5)–(6) are mechanical.

## Iter-150 prover-lane partial progress (HYBRID part (B) attempted)

The iter-150 PROGRESS recipe instructed the prover to add `[CharZero k]` /
`[PerfectField k]` to this signature and discharge by
`Algebra.IsAlgebraic.isSeparable_of_perfectField`. This works
LOCALLY (~3 LOC body) but breaks the iter-149 consumer
`constants_integral_over_base_field` (`ChartAlgebra.lean:L457`),
which calls this lemma without `[PerfectField k]` in scope:

  exact Algebra.IsSeparable.of_isGeometricallyReduced_of_finite k _

Result: signature inflation deferred to iter-151+ when a coordinated
write round on `ChartAlgebra.lean` can propagate `[CharZero k]` /
`[PerfectField k]` through the consumer's signature (or rewire the (b.1)
branch to invoke `Algebra.IsAlgebraic.isSeparable_of_perfectField`
directly per `analogies/h1cotangent-vanishing-iter150.md` §
"Top suggestion"). The body remains a structured `sorry` with the
iter-149 Stacks 0BJF Artinian-product closure path documented above. -/
theorem _root_.Algebra.IsSeparable.of_isGeometricallyReduced_of_finite
    (k F : Type u) [Field k] [Field F] [Algebra k F]
    [Algebra.IsGeometricallyReduced k F] [FiniteDimensional k F] :
    Algebra.IsSeparable k F := by
  -- HYBRID part (B) collapse (LOCAL one-liner, blocked by consumer compatibility):
  --
  --   haveI : PerfectField k := inferInstance  -- requires `[PerfectField k]` in sig
  --   exact Algebra.IsAlgebraic.isSeparable_of_perfectField
  --
  -- Path forward (iter-150+ Artinian path, when iter-151+ coordination not done):
  --   (a) Promote `Algebra.IsGeometricallyReduced k F` to
  --       `IsReduced (AlgebraicClosure k ⊗[k] F)` (this is the class field
  --       `isReduced_algebraicClosure_tensorProduct`, available as an instance).
  --   (b) Use `IsArtinianRing` of the finite-dim `\bar k`-algebra.
  --   (c) Decompose as product of fields, each = `\bar k`.
  --   (d) Apply the embedding-count = degree criterion for separability,
  --       e.g.\ via `Algebra.IsSeparable.of_natSepDegree_eq_finrank` or
  --       (more elementary) `Algebra.IsSeparable.of_finrank_eq_natSepDegree`.
  sorry

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

## Body status (iter-150 prover lane — HYBRID-DEFERRED)

-- HYBRID-DEFERRED: post iter-150 HYBRID pivot, this lemma is deferred
-- indefinitely as upstream-Mathlib-PR work, NOT on the project's M2.a
-- critical path. The mathlib-analogist's iter-150 cross-domain consult
-- (`analogies/h1cotangent-vanishing-iter150.md` § "Consumer reformulation
-- over `\bar k`") flagged that for `rigidity_over_kbar` (the M2.a
-- consumer) the `[IsAlgClosed kbar]` collapse (HYBRID part (A))
-- descopes (S3.pi.2) along with (S3.pi.1). The user-gate question is
-- open as of iter-150; iter-152+ schedule may flip on user response.

Structured `sorry`. Closure path (kept as documented fallback for the
over-`k` formulation if HYBRID part (A) user gate closes NO):

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

/-! ## Iter-150 HYBRID part (B) helper lemmas

The two helper lemmas below realise the iter-150 PROGRESS recipe for
HYBRID part (B) — the `[PerfectField k]` / `[CharZero k]` collapse — as
new lemmas with stronger hypotheses. They are NOT (yet) wired into
`constants_integral_over_base_field` in `ChartAlgebra.lean`, since that
consumer's signature does not carry `[CharZero k]` and the prover's
write domain is restricted to `ChartAlgebraS3.lean` this iter. Iter-151+
writer round on `ChartAlgebra.lean` will wire these in (and the
(b.1) branch will collapse to `~5` LOC per analogist's recommendation),
either by (i) propagating `[CharZero k]` through
`constants_integral_over_base_field`'s signature, or (ii) rewiring the
(b.1) branch to invoke `Algebra.IsAlgebraic.isSeparable_of_perfectField`
directly without the geometrically-reduced intermediate.
-/

/-- **(S3.sep.2) HYBRID part (B) variant.** For `k` a perfect field
(automatic in characteristic 0 via `PerfectField.ofCharZero`) and `F / k`
a finite-dimensional field extension, `F / k` is separable.

This is the iter-150 HYBRID part (B) CharZero collapse of (S3.sep.2):
under `[PerfectField k]`, the `IsGeometricallyReduced k F` hypothesis is
redundant (`FiniteDimensional ⇒ IsAlgebraic` + `IsAlgebraic + PerfectField
⇒ IsSeparable` discharges the conclusion in 1 line). Available for
iter-151+ rewiring of `constants_integral_over_base_field` (Lane 2).

The general-`k` formulation
`Algebra.IsSeparable.of_isGeometricallyReduced_of_finite` above remains
the Stacks-0BJF Mathlib-PR-grade target (~50–100 LOC Artinian-product
chase) for the general formulation. -/
theorem _root_.Algebra.IsSeparable.of_finite_of_perfectField
    (k F : Type u) [Field k] [Field F] [Algebra k F]
    [FiniteDimensional k F] [PerfectField k] :
    Algebra.IsSeparable k F :=
  -- `FiniteDimensional k F` propagates to `Algebra.IsAlgebraic k F` via
  -- Mathlib's `Algebra.IsAlgebraic.of_finite` instance, then the
  -- perfect-field instance `Algebra.IsAlgebraic.isSeparable_of_perfectField`
  -- closes the goal.
  Algebra.IsAlgebraic.isSeparable_of_perfectField

end AlgebraicGeometry
