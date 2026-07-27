/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.RigidPushforwardP1Sheaf
import AlgebraicJacobian.Picard.RigidPushforwardFiberChart
import AlgebraicJacobian.Picard.SchematicSupport

/-!
# The rank identity: the pushforward stalk rank is the fibre `h⁰`

`AlgebraicGeometry.Adelic.P1RankIdentity`
(`Picard/RigidPushforwardP1Sheaf.lean` §6) is the last open half of **leaf 3**
of the `Scheme.HasRigidPushforward` gate factorization
(`Picard/RigidPushforwardGate.lean`; `Picard/RigidPushforwardFrontier.lean`,
item 2 of "what remains").  It says that for a finitely presented `M` on
`ℙ¹_A` *whose two-term Čech complex already satisfies the conclusions of the
algebraic engine* — `H⁰ = ker d` finite projective over `Γ(Spec A, ⊤)`, and the
formation of `H⁰` commuting with arbitrary base change — the pointwise rank of
the pushforward sections is the fibre invariant,
`sectionsRankAtStalk (p_* M) t = p.fiberH0 M t`.

This file proves it: `AlgebraicGeometry.Adelic.p1RankIdentity_proved`.

The `ℙ¹` consumer is a one-line specialisation of a general theorem,
`AlgebraicGeometry.rank_pushforward_eq_fiberH0`, whose statement mentions no
projective line at all: it holds for any quasi-compact quasi-separated
`p : X ⟶ Spec R` carrying a bundled two-chart affine cover
`𝒰 : X.AffineCoverMVSquare`, and any quasi-coherent `M`.  That generality is
deliberate, but it should not be oversold: the theorem is available to any
family that *already carries* a two-affine Mayer–Vietoris cover of its total
space, and the campaign's curve `C_A` is not known to be one — that is exactly
why the curve side routes through `HasFiniteMapToP1` and
`rigidPushforwardLocallyFree_of_p1Engine` instead
(`Picard/RigidPushforwardTransfer.lean`).  What the generality does buy is that
this leaf is independent of `ℙ¹`: it carries content whatever `ℙ¹_k` turns out
to be, so it is not evidence about the `IsIntegral (ℙ¹_k)` leaf, and should not
be read as such.

## The route, in six steps

Write `d := 𝒰.moduleSectionDiffBase p M` for the base-linear two-term Čech
differential, `κ(t)` for the residue field at `t : Spec R`, and `X_t`, `M_t`
for the scheme-theoretic fibre and its induced module.

1. **Sheaf condition on the base.**
   `Scheme.Modules.pushforwardTopEquivBaseSections` followed by
   `Scheme.AffineCoverMVSquare.globalSectionsEquivKerModuleSectionDiffBase`
   gives `Γ(Spec R, p_* M) ≃ₗ[Γ(Spec R, ⊤)] ker d`.  So the engine's
   finiteness and projectivity of `ker d` *are* finiteness and projectivity of
   the pushforward sections.
2. **`Module.rankAtStalk_eq`.**  For a finite projective — hence flat — module,
   the stalk rank at `t` is `finrank κ(t) (κ(t) ⊗_R Γ(Spec R, p_* M))`.  This
   is the only step that consumes `hfin` and `hproj`.
3. **The engine's base-change conclusion at `B = κ(t)`.**  Bijectivity of
   `AlgebraicJacobian.TwoTerm.kerBaseChange` at `B = Γ(Spec κ(t), ⊤)` turns
   `κ(t) ⊗ ker d` into `ker (d ⊗ κ(t))`.
4. **The fibre-chart comparison.**  `exists_fiberChartTensorEquiv`
   (`Picard/RigidPushforwardFiberChart.lean` §5) together with its restriction
   naturality `fiberChart_smul_baseMap_res` (§6) identifies the whole
   `κ(t)`-base-changed Čech square with the Čech square of the induced cover
   `𝒰.preimage (p.fiberι t)` of `X_t`, hence `ker (d ⊗ κ(t))` with `ker d_t`
   (`finrank_ker_baseChange_residueField` below).
5. **Sheaf condition on the fibre.**  The same
   `globalSectionsEquivKerModuleSectionDiffBase`, now for the fibre cover,
   turns `ker d_t` into `Γ(X_t, M_t)`.
6. **`fiberH0` by definition.**  `Scheme.Hom.fiberH0 p M t` *is*
   `finrank κ(t) Γ(X_t, M_t)` for the `κ(t)`-structure
   `Scheme.Hom.fiberSectionsModule`; only the scalars have to be transported
   along `Scheme.ΓSpecIso (κ(t))`.

Steps 2, 3 and 6 live over different but isomorphic scalar rings — `R` versus
`Γ(Spec R, ⊤)`, and `κ(t)` versus `Γ(Spec κ(t), ⊤)` — which is why the file
opens with three transport bricks:

* **Brick A** (`tensorAddHomOfRingEquiv`, `tensorAddHomOfRingEquiv_tmul`,
  `finrank_tensor_eq_of_ringEquiv`): `Module.finrank S (S ⊗[R] N)` is unchanged
  by a compatible pair of ring isomorphisms `σ : R ≃+* R'`, `τ : S ≃+* S'`
  together with a `σ`-semilinear additive equivalence `e : N ≃+ N'`.  Pure
  commutative algebra; `LinearEquiv.finrank_eq` cannot be used because the
  scalar rings on the two sides are different objects, and no mathlib
  counterpart was found.
* **Brick B** (`specResidueFieldRingEquiv`,
  `appLE_fromSpecResidueField_apply`): the residue field `κ(t)` of `Spec R`
  versus `Γ(Spec κ(t), ⊤)`, and the identification of the global-sections map
  of `fromSpecResidueField t` with the residue map.  This was factored out of
  a `have` currently buried inside
  `exists_point_appLE_fromSpecResidueField_of_isMaximal`
  (`Picard/RigidPushforwardFiberChart.lean` §9).
* **Brick C** (`finrank_ker_baseChange_residueField`) is step 4.  §7 of
  `Picard/RigidPushforwardFiberChart.lean` proves the same commuting square,
  but keeps it internal and exports only a surjectivity corollary, so it had
  to be re-derived here on *kernels*.

## What the general theorem does — and does not — need

Recorded honestly, because it changes what the consumers must supply:

* `rank_pushforward_eq_fiberH0` **does not use surjectivity of `d`**.  The
  `hsurj` argument of `P1RankIdentity` is consequently unused in
  `p1RankIdentity_proved`.  It is *not* implied by the other hypotheses —
  do not delete it from a downstream statement on that reading.  (Take
  `d = 0 : M₀ →ₗ M₁` with `M₁ ≠ 0` flat: then `ker d = M₀`, `d.baseChange B = 0`,
  and `kerBaseChange d B` is the identity of `B ⊗ M₀`, bijective for every `B`,
  while `d` is not surjective.)  The accurate claim is only that this proof
  does not need it.  `hsurj` stays in the `Prop` because that `Prop` is pinned
  by the gate, and its producer
  (`p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_p1TrivialConstants`)
  hands out all four conclusions at once anyway.
* It **does not need `[Algebra.FiniteType k A]`**, nor properness, nor finite
  presentation of `M`.  The hypotheses actually used are `QuasiCompact p`,
  `QuasiSeparated p`, quasi-coherence of `M`, and `IsAffineHom (p.fiberι t)`
  (which is what makes the induced fibre cover a two-chart *affine* cover).

## Why the projectivity hypothesis is load-bearing

`hproj` is not decoration: dropped, the statement is **false**, and its
consumers become vacuous.  Stated precisely, because the distinction has been
got wrong here once already — the counterexample below witnesses the necessity
of `hproj` **alone**.  In it `hsurj`, `hfin` and `hbc` all *hold*:
`H¹(ℙ¹_k, 𝒪) = 0` so the Čech differential is surjective; `Γ = A/(x) = k` is
cyclic hence finite over `A = k[x]`; and everything in the two-term complex is
killed by `x`, so both `B ⊗ ker d` and `ker (d ⊗ B)` are `B/xB` and
`kerBaseChange` is the canonical isomorphism for every `B`.  `hfin` and `hbc`
are not separately witnessed here: they are what `Module.rankAtStalk_eq` and
step 3 respectively *consume*.  The counterexample recorded at
`Picard/RigidPushforwardP1Sheaf.lean`:567-576 is `A = k[x]` with
`M = 𝒪_{ℙ¹_A}/x = coker(𝒪 --x--> 𝒪)`, which is finitely presented.  Then
`Γ(ℙ¹_A, M) = A/(x) = k` is a *torsion* `A`-module, so `Module.rankAtStalk` at
`t = (x)` takes its junk value `0`; but the fibre is `ℙ¹_k` with
`M_t = 𝒪_{ℙ¹_k}`, so `p.fiberH0 M t = 1`.  What excludes it is exactly
`Module.Projective` — `k` is not a projective `k[x]`-module — which is the
hypothesis that licenses `Module.rankAtStalk_eq` in step 2.  `Module.Finite` is
needed by the same lemma, and the `kerBaseChange` bijectivity is what makes
step 3 an isomorphism rather than a one-way comparison map.

`Module.finrank` returns the junk value `0` in the infinite-dimensional case,
and it does so on *both* sides of the identity: `sectionsRankAtStalk` is a
`Module.rankAtStalk`, and `fiberH0` is a `Module.finrank` over `κ(t)`.  So a
priori the equality could hold vacuously as `0 = 0`.  Under the hypotheses it
cannot: `ker d` is `Module.Finite` over `Γ(Spec R, ⊤)`, so `κ(t) ⊗ ker d` is a
finite-dimensional `κ(t)`-vector space, and steps 3–6 are a chain of honest
`κ(t)`-semilinear isomorphisms, whence `Γ(X_t, M_t)` is finite-dimensional too
and both sides are genuine dimensions.

Sources: Stacks 02KG (cohomology and base change, at `i = 0`), 00NX (finite
projective = finite locally free), 01XJ; Mumford, *Abelian Varieties*, II §5;
EGA III 7.7, 7.9.9; Kleiman, *The Picard scheme* (FGA Explained), §5.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct

namespace AlgebraicGeometry

open Scheme

/-! ## §1 (Brick A). Tensor transport across a pair of ring isomorphisms -/

/-- **Semilinear transport of a tensor product along a pair of ring
isomorphisms.**  Given ring isomorphisms `σ : R ≃+* R'` and `τ : S ≃+* S'`
which intertwine the two algebra maps (`hστ`), and an additive equivalence
`e : N ≃+ N'` which is `σ`-semilinear (`he`), this is the additive map
`S ⊗[R] N →+ S' ⊗[R'] N'` determined by `s ⊗ₜ n ↦ τ s ⊗ₜ e n`.

It is the comparison map exhibiting `S ⊗[R] N` and `S' ⊗[R'] N'` as the same
module up to the change of scalars `τ`. -/
noncomputable def tensorAddHomOfRingEquiv
    {R R' : Type u} [CommRing R] [CommRing R']
    {S S' : Type u} [CommRing S] [CommRing S'] [Algebra R S] [Algebra R' S']
    {N N' : Type u} [AddCommGroup N] [Module R N] [AddCommGroup N'] [Module R' N']
    (σ : R ≃+* R') (τ : S ≃+* S')
    (hστ : ∀ r : R, τ (algebraMap R S r) = algebraMap R' S' (σ r))
    (e : N ≃+ N') (he : ∀ (r : R) (n : N), e (r • n) = σ r • e n) :
    TensorProduct R S N →+ TensorProduct R' S' N' :=
  TensorProduct.liftAddHom
    (AddMonoidHom.mk'
      (fun s => AddMonoidHom.mk' (fun n => τ s ⊗ₜ[R'] e n)
        (fun n₁ n₂ => by simp [TensorProduct.tmul_add]))
      (fun s₁ s₂ => by ext n; simp [TensorProduct.add_tmul]))
    (fun r s n => by
      change τ (r • s) ⊗ₜ[R'] e n = τ s ⊗ₜ[R'] e (r • n)
      rw [he, Algebra.smul_def, map_mul, hστ, ← Algebra.smul_def, TensorProduct.smul_tmul])

/-- **Value of the transport map on a pure tensor**: `tensorAddHomOfRingEquiv`
sends `s ⊗ₜ n` to `τ s ⊗ₜ e n`. -/
lemma tensorAddHomOfRingEquiv_tmul
    {R R' : Type u} [CommRing R] [CommRing R']
    {S S' : Type u} [CommRing S] [CommRing S'] [Algebra R S] [Algebra R' S']
    {N N' : Type u} [AddCommGroup N] [Module R N] [AddCommGroup N'] [Module R' N']
    (σ : R ≃+* R') (τ : S ≃+* S')
    (hστ : ∀ r : R, τ (algebraMap R S r) = algebraMap R' S' (σ r))
    (e : N ≃+ N') (he : ∀ (r : R) (n : N), e (r • n) = σ r • e n) (s : S) (n : N) :
    tensorAddHomOfRingEquiv σ τ hστ e he (s ⊗ₜ[R] n) = τ s ⊗ₜ[R'] e n :=
  TensorProduct.liftAddHom_tmul _ _ s n

/-- **The rank of a base-changed module is invariant under a compatible pair of
ring isomorphisms.**  If `σ : R ≃+* R'` and `τ : S ≃+* S'` intertwine the two
algebra maps and `e : N ≃+ N'` is `σ`-semilinear, then
`Module.finrank S (S ⊗[R] N) = Module.finrank S' (S' ⊗[R'] N')`.

This is the transport `LinearEquiv.finrank_eq` cannot provide, since it insists
on a *fixed* scalar ring, whereas here the two sides are ranks over the
literally different rings `κ(t)` and `Γ(Spec κ(t), ⊤)` (respectively `R` and
`Γ(Spec R, ⊤)` underneath).  No mathlib counterpart was found. -/
theorem finrank_tensor_eq_of_ringEquiv
    {R R' : Type u} [CommRing R] [CommRing R']
    {S S' : Type u} [CommRing S] [CommRing S'] [Algebra R S] [Algebra R' S']
    {N N' : Type u} [AddCommGroup N] [Module R N] [AddCommGroup N'] [Module R' N']
    (σ : R ≃+* R') (τ : S ≃+* S')
    (hστ : ∀ r : R, τ (algebraMap R S r) = algebraMap R' S' (σ r))
    (e : N ≃+ N') (he : ∀ (r : R) (n : N), e (r • n) = σ r • e n) :
    Module.finrank S (TensorProduct R S N) = Module.finrank S' (TensorProduct R' S' N') := by
  have hστ' : ∀ r' : R', τ.symm (algebraMap R' S' r') = algebraMap R S (σ.symm r') := by
    intro r'; have := hστ (σ.symm r'); rw [σ.apply_symm_apply] at this
    rw [← this, τ.symm_apply_apply]
  have he' : ∀ (r' : R') (n' : N'), e.symm (r' • n') = σ.symm r' • e.symm n' := by
    intro r' n'; apply e.injective
    rw [e.apply_symm_apply, he, σ.apply_symm_apply, e.apply_symm_apply]
  set f := tensorAddHomOfRingEquiv σ τ hστ e he with hf
  set g := tensorAddHomOfRingEquiv σ.symm τ.symm hστ' e.symm he' with hg
  have hgf : ∀ z : TensorProduct R S N, g (f z) = z := by
    intro z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [map_add, map_add, h₁, h₂]
    | tmul s n => rw [hf, hg, tensorAddHomOfRingEquiv_tmul, tensorAddHomOfRingEquiv_tmul,
        τ.symm_apply_apply, e.symm_apply_apply]
  have hfg : ∀ z' : TensorProduct R' S' N', f (g z') = z' := by
    intro z'
    induction z' using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [map_add, map_add, h₁, h₂]
    | tmul s' n' => rw [hf, hg, tensorAddHomOfRingEquiv_tmul, tensorAddHomOfRingEquiv_tmul,
        τ.apply_symm_apply, e.apply_symm_apply]
  have hsmul : ∀ (s : S) (z : TensorProduct R S N), f (s • z) = τ s • f z := by
    intro s z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul s₀ n =>
      rw [TensorProduct.smul_tmul', hf, tensorAddHomOfRingEquiv_tmul,
        tensorAddHomOfRingEquiv_tmul, smul_eq_mul, map_mul, TensorProduct.smul_tmul',
        smul_eq_mul]
  exact finrank_eq_of_ringEquiv_addEquiv τ
    (AddEquiv.ofBijective f ⟨Function.LeftInverse.injective hgf,
      Function.RightInverse.surjective hfg⟩) hsmul

/-! ## §2 (Brick B). The residue field of `Spec R` versus `Γ(Spec κ(t), ⊤)` -/

/-- **The residue field at a prime, as the global sections of its spectrum.**
The canonical ring isomorphism `κ(t) ≃+* Γ(Spec κ(t), ⊤)` between the algebraic
residue field `t.asIdeal.ResidueField` of the prime `t` and the global sections
of the spectrum of the scheme-theoretic residue field `(Spec R).residueField t`,
assembled from `Scheme.Spec.residueFieldIso` and `Scheme.ΓSpecIso`. -/
noncomputable def specResidueFieldRingEquiv (R : CommRingCat.{u}) (t : Spec R) :
    t.asIdeal.ResidueField ≃+* Γ(Spec ((Spec R).residueField t), ⊤) :=
  ((Scheme.Spec.residueFieldIso R t).symm ≪≫
    (Scheme.ΓSpecIso ((Spec R).residueField t)).symm).commRingCatIsoToRingEquiv

/-- **Global sections of the residue-field point is the residue map.**  Under
the identifications `Γ(Spec R, ⊤) ≅ R` (`Scheme.ΓSpecIso`) and
`κ(t) ≅ Γ(Spec κ(t), ⊤)` (`specResidueFieldRingEquiv`), the ring map induced on
global sections by `(Spec R).fromSpecResidueField t : Spec κ(t) ⟶ Spec R` is the
residue map `algebraMap R κ(t)`.

This is the `happ` step currently buried inside
`exists_point_appLE_fromSpecResidueField_of_isMaximal`
(`Picard/RigidPushforwardFiberChart.lean` §9), exported here because it is
exactly the compatibility hypothesis `hστ` of
`finrank_tensor_eq_of_ringEquiv`. -/
theorem appLE_fromSpecResidueField_apply (R : CommRingCat.{u}) (t : Spec R)
    (x : Γ(Spec R, ⊤)) :
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom x
      = specResidueFieldRingEquiv R t
          (algebraMap R t.asIdeal.ResidueField
            ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv x)) := by
  have hnat : ∀ {A B : CommRingCat.{u}} (φ : A ⟶ B),
      (Spec.map φ).appTop = (Scheme.ΓSpecIso A).hom ≫ φ ≫ (Scheme.ΓSpecIso B).inv := by
    intro A B φ
    rw [← Category.assoc, ← Scheme.ΓSpecIso_naturality φ, Category.assoc,
      Iso.hom_inv_id, Category.comp_id]
  have hfac : ((Spec R).fromSpecResidueField t).appTop =
      (Scheme.ΓSpecIso R).hom ≫ CommRingCat.ofHom (algebraMap R t.asIdeal.ResidueField) ≫
        (Scheme.Spec.residueFieldIso R t).inv ≫
        (Scheme.ΓSpecIso ((Spec R).residueField t)).inv := by
    rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField R t,
      Scheme.Hom.comp_appTop, hnat, hnat]
    simp only [Category.assoc, Iso.inv_hom_id_assoc]
    rfl
  have hLE : ((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top =
      ((Spec R).fromSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
  rw [hLE, hfac]
  simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_ofHom]
  rfl

/-! ## §3 (Brick C). The fibre-chart Čech square, concluded on kernels -/

section BrickC

variable {X Y : Scheme.{u}}

set_option maxHeartbeats 1600000 in
-- Heartbeat headroom: the statement carries six `letI` module structures, so
-- matching the three chart comparisons against the Čech square forces large
-- `isDefEq` checks.  Measured: this is the only declaration in the file that
-- exceeds the default budget (`synthInstance.maxHeartbeats` is never hit).
/-- **The fibre-chart Čech square, read on kernels.**  Let `f : X ⟶ Y` be a
family over an affine base, `𝒰` a bundled two-chart affine cover of `X`, `M` a
quasi-coherent module on `X`, and `t : Y` a point whose fibre inclusion is
affine.  Then the `κ(t)`-base change of the base-linear Čech differential of
`𝒰` and the Čech differential of the induced two-chart cover of the fibre `X_t`
have kernels of the same `κ(t)`-dimension:
`finrank κ(t) (ker (d ⊗ κ(t))) = finrank κ(t) (ker d_t)`.

This is Stacks 02KG at `i = 0` in its two-term Čech guise: the chart comparison
`exists_fiberChartTensorEquiv` identifies `κ(t) ⊗_{Γ(Y,⊤)} Γ(M, W)` with
`Γ(M_t, W_t)` on each of the three charts `U₁`, `U₂`, `U₁ ⊓ U₂`, and
`fiberChart_smul_baseMap_res` says these identifications commute with
restriction, hence with the difference map.  §7 of
`Picard/RigidPushforwardFiberChart.lean` proves the same square but keeps it
internal, exporting only a surjectivity corollary, so it is re-derived here in
the form the rank computation needs. -/
theorem finrank_ker_baseChange_residueField
    (𝒰 : X.AffineCoverMVSquare) (f : X ⟶ Y) [IsAffine Y]
    (M : X.Modules) [M.IsQuasicoherent] (t : Y) [IsAffineHom (f.fiberι t)] :
    letI : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
      ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI := f.baseSectionsModule M 𝒰.U₁
    letI := f.baseSectionsModule M 𝒰.U₂
    letI := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₁)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₂)
    letI := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
      ((𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂)
    Module.finrank Γ(Spec (Y.residueField t), ⊤)
        (LinearMap.ker ((𝒰.moduleSectionDiffBase f M).baseChange
          Γ(Spec (Y.residueField t), ⊤)))
      = Module.finrank Γ(Spec (Y.residueField t), ⊤)
        (LinearMap.ker ((𝒰.preimage (f.fiberι t)).moduleSectionDiffBase
          (f.fiberToSpecResidueField t) (f.fiberModule t M))) := by
  letI aAB : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) :=
    ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI mA1 := f.baseSectionsModule M 𝒰.U₁
  letI mA2 := f.baseSectionsModule M 𝒰.U₂
  letI mA0 := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI nB1 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₁)
  letI nB2 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₂)
  letI nB0 := (f.fiberToSpecResidueField t).baseSectionsModule (f.fiberModule t M)
    ((𝒰.preimage (f.fiberι t)).U₁ ⊓ (𝒰.preimage (f.fiberι t)).U₂)
  obtain ⟨⟨Θ₁, hΘ₁⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_U₁
    (𝒰.isAffineOpen_U₁.preimage (f.fiberι t))
  obtain ⟨⟨Θ₂, hΘ₂⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_U₂
    (𝒰.isAffineOpen_U₂.preimage (f.fiberι t))
  obtain ⟨⟨Θ₀, hΘ₀⟩⟩ := exists_fiberChartTensorEquiv f t M 𝒰.isAffineOpen_inf
    (𝒰.isAffineOpen_inf.preimage (f.fiberι t))
  haveI : (f.fiberModule t M).IsQuasicoherent := Scheme.Hom.fiberModule_isQuasicoherent f t M
  -- K-linearity of the three chart comparisons
  have hsm1 : ∀ (c : Γ(Spec (Y.residueField t), ⊤))
      (z : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁)),
      Θ₁ (c • z) =
        ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ 𝒰.U₁) le_top).hom c • Θ₁ z := by
    intro c z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul b x =>
      rw [TensorProduct.smul_tmul', hΘ₁, hΘ₁, smul_eq_mul, map_mul, mul_smul]
      rfl
  have hsm2 : ∀ (c : Γ(Spec (Y.residueField t), ⊤))
      (z : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₂)),
      Θ₂ (c • z) =
        ((f.fiberToSpecResidueField t).appLE ⊤ (f.fiberι t ⁻¹ᵁ 𝒰.U₂) le_top).hom c • Θ₂ z := by
    intro c z
    induction z using TensorProduct.induction_on with
    | zero => simp
    | add z₁ z₂ h₁ h₂ => rw [smul_add, map_add, map_add, h₁, h₂, smul_add]
    | tmul b x =>
      rw [TensorProduct.smul_tmul', hΘ₂, hΘ₂, smul_eq_mul, map_mul, mul_smul]
      rfl
  -- the commuting Čech square (copied from FiberChart §7)
  have hsquare : ∀ w : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
      (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)),
      Θ₀ ((𝒰.moduleSectionDiffBase f M).baseChange Γ(Spec (Y.residueField t), ⊤) w) =
        (𝒰.preimage (f.fiberι t)).moduleSectionDiff (f.fiberModule t M)
          (Θ₁ (TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
              Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) w).1,
           Θ₂ (TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
              Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) w).2) := by
    intro w
    induction w using TensorProduct.induction_on with
    | zero =>
      simp only [map_zero, Prod.fst_zero, Prod.snd_zero]
      exact (map_zero _).symm
    | add w₁ w₂ ih₁ ih₂ =>
      simp only [map_add, Prod.fst_add, Prod.snd_add]
      rw [ih₁, ih₂]
      exact (map_add _ _ _).symm
    | tmul b p =>
      obtain ⟨x₁, x₂⟩ := p
      rw [LinearMap.baseChange_tmul, hΘ₀ b _]
      simp only [TensorProduct.prodRight_tmul, hΘ₁, hΘ₂,
        Scheme.AffineCoverMVSquare.moduleSectionDiffBase_apply,
        Scheme.AffineCoverMVSquare.moduleSectionDiff_apply]
      have e₁ := fiberChart_smul_baseMap_res f t M
        (inf_le_left : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₁) (le_refl (f.fiberι t ⁻¹ᵁ (𝒰.U₁ ⊓ 𝒰.U₂)))
        ((f.fiberι t).preimage_mono (inf_le_left : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₁)) b x₁
      have e₂ := fiberChart_smul_baseMap_res f t M
        (inf_le_right : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₂) (le_refl (f.fiberι t ⁻¹ᵁ (𝒰.U₁ ⊓ 𝒰.U₂)))
        ((f.fiberι t).preimage_mono (inf_le_right : 𝒰.U₁ ⊓ 𝒰.U₂ ≤ 𝒰.U₂)) b x₂
      rw [map_sub, smul_sub]
      exact congrArg₂ (· - ·) e₁.symm e₂.symm
  -- the comparison of the two Čech degree-0 terms
  set PR := TensorProduct.prodRight Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
      Γ(Spec (Y.residueField t), ⊤) Γ(M, 𝒰.U₁) Γ(M, 𝒰.U₂) with hPR
  set Φ : TensorProduct Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤)
        (Γ(M, 𝒰.U₁) × Γ(M, 𝒰.U₂)) ≃+
      (Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₁) ×
        Γ(f.fiberModule t M, (𝒰.preimage (f.fiberι t)).U₂)) :=
    PR.toAddEquiv.trans (Θ₁.prodCongr Θ₂) with hΦdef
  have hΦ : ∀ w, Φ w = (Θ₁ (PR w).1, Θ₂ (PR w).2) := fun w => rfl
  have hmem : ∀ w, (𝒰.moduleSectionDiffBase f M).baseChange
        Γ(Spec (Y.residueField t), ⊤) w = 0 ↔
      (𝒰.preimage (f.fiberι t)).moduleSectionDiffBase
        (f.fiberToSpecResidueField t) (f.fiberModule t M) (Φ w) = 0 := by
    intro w
    have hs : (𝒰.preimage (f.fiberι t)).moduleSectionDiffBase
          (f.fiberToSpecResidueField t) (f.fiberModule t M) (Φ w)
        = Θ₀ ((𝒰.moduleSectionDiffBase f M).baseChange
            Γ(Spec (Y.residueField t), ⊤) w) := (hsquare w).symm
    rw [hs]
    constructor
    · intro h; rw [h]; exact map_zero _
    · intro h; exact Θ₀.injective (h.trans (map_zero _).symm)
  set j : LinearMap.ker ((𝒰.moduleSectionDiffBase f M).baseChange
        Γ(Spec (Y.residueField t), ⊤)) ≃+
      LinearMap.ker ((𝒰.preimage (f.fiberι t)).moduleSectionDiffBase
        (f.fiberToSpecResidueField t) (f.fiberModule t M)) :=
    { toFun := fun z => ⟨Φ z.1, (hmem z.1).mp (LinearMap.mem_ker.mp z.2)⟩
      invFun := fun y => ⟨Φ.symm y.1, by
        refine LinearMap.mem_ker.mpr ((hmem (Φ.symm y.1)).mpr ?_)
        rw [Φ.apply_symm_apply]
        exact LinearMap.mem_ker.mp y.2⟩
      left_inv := fun z => Subtype.ext (Φ.symm_apply_apply z.1)
      right_inv := fun y => Subtype.ext (Φ.apply_symm_apply y.1)
      map_add' := fun z₁ z₂ => Subtype.ext (map_add Φ z₁.1 z₂.1) } with hjdef
  refine finrank_eq_of_ringEquiv_addEquiv (RingEquiv.refl _) j ?_
  intro c z
  refine Subtype.ext ?_
  change Φ (c • z.1) = _
  rw [hΦdef]
  change (Θ₁ (PR (c • z.1)).1, Θ₂ (PR (c • z.1)).2) = _
  rw [map_smul]
  exact Prod.ext (hsm1 c (PR z.1).1) (hsm2 c (PR z.1).2)

end BrickC

/-! ## §4. The assembly: the stalk rank of `p_* M` is the fibre `h⁰` -/

variable {R : CommRingCat.{u}} {X : Scheme.{u}}

/-- **The pushforward stalk rank is the fibre `h⁰`.**  Let `p : X ⟶ Spec R` be
quasi-compact and quasi-separated, `𝒰` a bundled two-chart affine cover of `X`,
`M` a quasi-coherent module on `X`, and `t : Spec R` a point whose fibre
inclusion `p.fiberι t` is affine.  If the Čech `H⁰`, i.e.
`ker (𝒰.moduleSectionDiffBase p M)`, is finite (`hfin`) and projective
(`hproj`) over `Γ(Spec R, ⊤)`, and its formation commutes with arbitrary base
change (`hbc`: `AlgebraicJacobian.TwoTerm.kerBaseChange` bijective over every
`Γ(Spec R, ⊤)`-algebra `B`), then

`sectionsRankAtStalk ((Modules.pushforward p).obj M) t = p.fiberH0 M t`.

This is the general form of leaf 3's rank identification — no projective line
occurs, so it is equally available for a curve `C_A ⟶ Spec A`.  Surjectivity of
the Čech differential is *not* required — this proof does not use it (it is
*not* implied by `hbc`; see the module docstring).  Nor is finite presentation
of `M`, properness of `p`, or any finiteness of `R`.  Of the three hypotheses
that do occur, `hproj` is genuinely necessary (module docstring, counterexample);
`hfin` and `hbc` are consumed by `Module.rankAtStalk_eq` and by step 3
respectively, and are not separately witnessed.

Sources: Stacks 02KG at `i = 0`, 00NX; Mumford, *Abelian Varieties*, II §5. -/
theorem rank_pushforward_eq_fiberH0
    (p : X ⟶ Spec R) (𝒰 : X.AffineCoverMVSquare) (M : X.Modules)
    [M.IsQuasicoherent] [QuasiCompact p] [QuasiSeparated p]
    (t : PrimeSpectrum R) [IsAffineHom (p.fiberι t)]
    (hfin :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      Module.Finite Γ(Spec R, ⊤) (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
    (hproj :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      Module.Projective Γ(Spec R, ⊤) (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
    (hbc :
      letI := p.baseSectionsModule M 𝒰.U₁
      letI := p.baseSectionsModule M 𝒰.U₂
      letI := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
      ∀ (B : Type u) [CommRing B] [Algebra Γ(Spec R, ⊤) B],
        Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange
          (𝒰.moduleSectionDiffBase p M) B)) :
    sectionsRankAtStalk ((Scheme.Modules.pushforward p).obj M) t = p.fiberH0 M t := by
  letI m1 := p.baseSectionsModule M 𝒰.U₁
  letI m2 := p.baseSectionsModule M 𝒰.U₂
  letI m0 := p.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
  letI mT := p.baseSectionsModule M (⊤ : X.Opens)
  haveI := hfin
  haveI := hproj
  letI n1 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₁)
  letI n2 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₂)
  letI n0 := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    ((𝒰.preimage (p.fiberι t)).U₁ ⊓ (𝒰.preimage (p.fiberι t)).U₂)
  letI nT := (p.fiberToSpecResidueField t).baseSectionsModule (p.fiberModule t M)
    (⊤ : (p.fiber t).Opens)
  letI aRK : Algebra Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤) :=
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  have e0 : Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens))
      ≃ₗ[Γ(Spec R, ⊤)] LinearMap.ker (𝒰.moduleSectionDiffBase p M) :=
    (Scheme.Modules.pushforwardTopEquivBaseSections p M) ≪≫ₗ
      (𝒰.globalSectionsEquivKerModuleSectionDiffBase p M)
  haveI : Module.Finite Γ(Spec R, ⊤)
      Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) := Module.Finite.equiv e0.symm
  haveI : Module.Projective Γ(Spec R, ⊤)
      Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) :=
    Module.Projective.of_equiv e0.symm
  haveI := module_finite_top_of_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) ‹_›
  haveI := module_projective_top_of_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) ‹_›
  haveI : Module.Flat R Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)) :=
    Module.Flat.of_projective
  have step1 : sectionsRankAtStalk ((Scheme.Modules.pushforward p).obj M) t
      = Module.finrank t.asIdeal.ResidueField
          (t.asIdeal.Fiber Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens))) :=
    Module.rankAtStalk_eq _
  -- STEP 2, now via the two new bricks
  have step2 : Module.finrank t.asIdeal.ResidueField
        (t.asIdeal.Fiber Γ((Scheme.Modules.pushforward p).obj M, (⊤ : (Spec R).Opens)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (TensorProduct Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤)
            (LinearMap.ker (𝒰.moduleSectionDiffBase p M))) := by
    refine finrank_tensor_eq_of_ringEquiv
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm
      (specResidueFieldRingEquiv R t) ?_ e0.toAddEquiv ?_
    · intro r
      have h := appLE_fromSpecResidueField_apply R t
        ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv.symm r)
      rw [RingEquiv.apply_symm_apply] at h
      exact h.symm
    · intro r n
      rw [smul_gammaSpecTop ((Scheme.Modules.pushforward p).obj M) r n]
      exact e0.map_smul _ _
  have hbcK := hbc Γ(Spec ((Spec R).residueField t), ⊤)
  have step3 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (TensorProduct Γ(Spec R, ⊤) Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker (𝒰.moduleSectionDiffBase p M)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker (((𝒰.moduleSectionDiffBase p M).baseChange
            Γ(Spec ((Spec R).residueField t), ⊤)))) :=
    LinearEquiv.finrank_eq (LinearEquiv.ofBijective _ hbcK)
  have step4 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (LinearMap.ker (((𝒰.moduleSectionDiffBase p M).baseChange
          Γ(Spec ((Spec R).residueField t), ⊤))))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          (LinearMap.ker ((𝒰.preimage (p.fiberι t)).moduleSectionDiffBase
            (p.fiberToSpecResidueField t) (p.fiberModule t M))) :=
    finrank_ker_baseChange_residueField 𝒰 p M t
  have step5 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        (LinearMap.ker ((𝒰.preimage (p.fiberι t)).moduleSectionDiffBase
          (p.fiberToSpecResidueField t) (p.fiberModule t M)))
      = Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
          Γ(p.fiberModule t M, (⊤ : (p.fiber t).Opens)) :=
    (LinearEquiv.finrank_eq ((𝒰.preimage (p.fiberι t)).globalSectionsEquivKerModuleSectionDiffBase
      (p.fiberToSpecResidueField t) (p.fiberModule t M))).symm
  have step6 : Module.finrank Γ(Spec ((Spec R).residueField t), ⊤)
        Γ(p.fiberModule t M, (⊤ : (p.fiber t).Opens))
      = p.fiberH0 M t := by
    letI := p.fiberSectionsModule t (p.fiberModule t M)
    refine finrank_eq_of_ringEquiv_addEquiv
      (Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv
      (AddEquiv.refl _) ?_
    intro r m
    change r • m = _
    rw [Scheme.Hom.baseSectionsModule_smul_def]
    change _ = ((p.fiberResidueMap t).hom
      ((Scheme.ΓSpecIso ((Spec R).residueField t)).commRingCatIsoToRingEquiv r)) • m
    congr 1
    simp only [Scheme.Hom.fiberResidueMap, CommRingCat.hom_comp, RingHom.comp_apply]
    have hLE : (p.fiberToSpecResidueField t).appLE ⊤ ⊤ le_top
        = (p.fiberToSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
    rw [hLE]
    congr 1
    have h1 := congrArg (fun φ : Γ(Spec ((Spec R).residueField t), ⊤) ⟶
        Γ(Spec ((Spec R).residueField t), ⊤) => φ.hom r)
      (Scheme.ΓSpecIso ((Spec R).residueField t)).hom_inv_id
    simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_id,
      RingHom.id_apply] at h1
    exact h1.symm
  rw [step1, step2, step3, step4, step5, step6]

/-! ## §5. The consumer: `P1RankIdentity` -/

namespace Adelic

open Scheme

variable {k : Type u} [Field k]

/-- **Leaf 3's rank half is closed: `P1RankIdentity k A` holds.**  For every
`k`-algebra `A` and every finitely presented `M` on `ℙ¹_A` whose two-term Čech
complex satisfies the algebraic engine's conclusions, the pointwise rank of
`p_* M` at `t : Spec A` is the fibre invariant `p.fiberH0 M t`.

Specialisation of `rank_pushforward_eq_fiberH0` to
`p = pullback.snd : ℙ¹_A ⟶ Spec A` with the two-chart cover
`p1BaseChangeCoverSquare A`.  The surjectivity hypothesis of `P1RankIdentity`
is not used — it is subsumed by the base-change hypothesis — and
`[Algebra.FiniteType k A]` is not assumed. -/
theorem p1RankIdentity_proved (A : Type u) [CommRing A] [Algebra k A] :
    P1RankIdentity k A := by
  intro M hfp hsurj hfin hproj hbc t
  haveI := hfp
  exact rank_pushforward_eq_fiberH0
    (pullback.snd (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))
    (p1BaseChangeCoverSquare A) M t hfin hproj hbc

end Adelic

end AlgebraicGeometry
