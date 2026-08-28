## Verdict

The §5 chain is **sound**. Every step's typeclass requirements are genuinely available at its call site, there are no `sorry`s anywhere in the chain, and all headlines are axiom-clean (`propext, Classical.choice, Quot.sound` only). The one thing I'd flag is a **docstring overclaim**, not a soundness bug (item 6 below).

## 1. The chain, verbatim signatures

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1Constants.lean`

- **:404** `Scheme.module_finite_snd_top_baseChange {X : Scheme.{u}} (iX : X ⟶ Spec (CommRingCat.of k)) [CompactSpace X] [QuasiSeparatedSpace X] (hfin : letI := (iX.appTop).hom.toAlgebra; Module.Finite Γ(Spec (CommRingCat.of k), ⊤) Γ(X, ⊤)) (A : Type u) [CommRing A] [Algebra k A] : letI := ((pullback.snd iX (Spec.map (CommRingCat.ofHom (algebraMap k A)))).appTop).hom.toAlgebra; Module.Finite Γ(Spec (CommRingCat.of A), ⊤) Γ(pullback iX (Spec.map …), ⊤)` — plus file-level `variable {k : Type u} [Field k]` (:394).
- **:442** `Adelic.isIntegral_p1Over_left_of_geometricallyIntegral [GeometricallyIntegral ((p1Over k).hom)] : IsIntegral ((p1Over k).left)`
- **:466** `Adelic.p1Cech_h0_fg_of_isIntegral [IsIntegral ((p1Over k).left)] (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A] (M : (pullback (p1Over k).hom (Spec.map …)).Modules) [M.IsFinitePresentation] : … .FG` (elaborated `#check` confirmed identical).
- **:506** `Adelic.p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral` — same binders plus `hflat : Scheme.CoherentSheafFlat …`.

Supporting instances, all in §2 of the same file: `isProper_p1Over_hom` (**:173**), `compactSpace_p1Over_left` (**:179**), `quasiSeparatedSpace_p1Over_left` (**:183**).

Downstream links:
- `AlgebraicJacobian/Picard/P1SectionsFinite.lean:914` `Scheme.AffineCoverMVSquare.fg_ker_ringSectionDiffBase_of_module_finite_top (V : X.AffineCoverMVSquare) (p : X ⟶ S) (hfin : letI := ((p.appLE ⊤ ⊤ le_top).hom).toAlgebra; Module.Finite Γ(S, ⊤) Γ(X, ⊤)) : (LinearMap.ker (V.ringSectionDiffBase p)).FG` — note the algebra structure is via `appLE ⊤ ⊤`, **not** `appTop`; the caller bridges this correctly at :489-498 with `Scheme.Hom.appLE_eq_app`.
- `AlgebraicJacobian/Picard/P1SectionsFinite.lean:1175` `Adelic.p1Cech_h0_fg_of_structure_h0_fg [Algebra.FiniteType k A] (M …) [M.IsFinitePresentation] (hS0 : … .FG) : … .FG`. This is where `Algebra.FiniteType k A` is consumed (it derives `IsNoetherianRing A` at :1206).
- `AlgebraicJacobian/Picard/SectionRingUniversal.lean:206` `globalSectionsBaseChangeAlgEquiv` — the H⁰ flat base change, hypotheses only `[CompactSpace X] [QuasiSeparatedSpace X]`.

## 2. The mathlib lemma — verbatim, and instance availability

`/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/Morphisms/Proper.lean:154`:

```
theorem finite_appTop_of_universallyClosed (f : X ⟶ (Spec <| .of K))
    [IsIntegral X] [UniversallyClosed f] [LocallyOfFiniteType f] :
    f.appTop.hom.Finite
```
Elaborated: `∀ {X : Scheme} (K : Type u_1) [Field K] (f : X ⟶ Spec (CommRingCat.of K)) [AlgebraicGeometry.IsIntegral X] [UniversallyClosed f] [LocallyOfFiniteType f], (CommRingCat.Hom.hom (Scheme.Hom.appTop f)).Finite`. `K` and `f` are explicit — matching the call `finite_appTop_of_universallyClosed k (p1Over k).hom` at :484.

Instance audit at the call site (I compiled each as a standalone `inferInstance` example — all four succeed):
- `IsIntegral ((p1Over k).left)` — **the scheme-level `AlgebraicGeometry.IsIntegral`, correct one** (`X` in the mathlib lemma is inferred from `f`'s source, which is `(p1Over k).left`). Supplied as the theorem's own instance binder, i.e. it is the assumed anchor, not derived.
- `UniversallyClosed ((p1Over k).hom)` — **derived instance**, via `isProper_p1Over_hom` (:173) and `class IsProper : Prop extends IsSeparated f, UniversallyClosed f, LocallyOfFiniteType f` (mathlib Proper.lean:42), whose parents are instance projections.
- `LocallyOfFiniteType ((p1Over k).hom)` — same source. Both verified by `inferInstance`.
- `CompactSpace`/`QuasiSeparatedSpace` on `(p1Over k).left` — instances at :179/:183, verified.

`IsProper (ℙ(n;S) ↘ S)` is **project-local**, not mathlib: `AlgebraicJacobian/Picard/ProjectiveSpace.lean:160`, `MorphismProperty.pullback_fst` from `IsProper (terminal.from (Proj ℤ[Xᵢ]))`. Sorry-free (confirmed by the axiom check).

No gap here. The docstring claim "whose only non-properness hypothesis is `IsIntegral X`" is exactly right.

## 3. Base-change step — right morphism, no hidden hypotheses

Yes, applied to the right morphism. `ℙ(n;S)` is defined as `pullback (terminal.from S) (terminal.from (Proj (homogeneousSubmodule n (ULift ℤ))))` (`ProjectiveSpace.lean:70`), so `(p1Over k).left = ℙ¹_k = Proj ℤ[X₀,X₁] ×_ℤ Spec k`, and `pullback (p1Over k).hom (Spec.map (algebraMap k A))` is genuinely `ℙ¹_A`, with `pullback.snd` its structural morphism to `Spec A`. That `pullback.snd` is exactly the `p` fed to `fg_ker_ringSectionDiffBase_of_module_finite_top` at :487-488, and `p1BaseChangeCoverSquare A` is an `AffineCoverMVSquare` on that same pullback scheme (the structure carries a load-bearing `cover : U₁ ⊔ U₂ = ⊤` field, `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:63`).

**Extra hypotheses needed by the base-change step: none.** `module_finite_snd_top_baseChange` needs no `Algebra.FiniteType k A`, no flatness, no noetherianity. Concretely:
- `Module.Finite.base_change R S M` (:427) is unconditional.
- The flatness is inside `globalSectionsBaseChangeAlgEquiv`, which calls `isIso_pushoutSection_of_isQuasiSeparated_of_flat_right`; the `Flat` instance is discharged automatically over a field base by mathlib `Mathlib/AlgebraicGeometry/Morphisms/Flat.lean:110`: `instance (priority := low) [Subsingleton Y] [IsIntegral Y] : Flat f`. So "flatness is free over `Spec k`" is a real, machine-checked instance, not hand-waving.
- One type-level detail handled correctly: `hfin0 : ((p1Over k).hom.appTop).hom.Finite` is `RingHom.Finite`, which unfolds to the `letI …toAlgebra; Module.Finite` shape `module_finite_snd_top_baseChange` expects — accepted definitionally.

`Algebra.FiniteType k A` in the §5 headline is *not* needed for base change; it enters only at `p1Cech_h0_fg_of_structure_h0_fg` (P1SectionsFinite.lean:1175, used at :1206 for `IsNoetherianRing A`). Correctly placed.

## 4. Sorries and axioms

`grep sorry` on `RigidPushforwardP1Constants.lean`: **zero hits**. Also zero in `P1SectionsFinite.lean`, `StructureSheafPushforward.lean`, `SectionRingUniversal.lean`, `ProjectiveSpace.lean`, `RigidPushforward.lean`. (The package has 25 sorries elsewhere — `Jacobian.lean`, `QuotRepresentability.lean`, `SerreFiniteness.lean`, `FGAPicRepresentability.lean:259`, etc. — none in this cone, as the axiom check proves.)

Scratch file `/tmp/audit_ajc_p1integral.lean`, run with `lake env lean`:

```
'AlgebraicGeometry.Adelic.p1Cech_h0_fg_of_isIntegral' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.isIntegral_p1Over_left_of_geometricallyIntegral' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Scheme.module_finite_snd_top_baseChange' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1Cech_h0_fg_of_structure_h0_fg' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Scheme.AffineCoverMVSquare.fg_ker_ringSectionDiffBase_of_module_finite_top' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.finite_appTop_of_universallyClosed' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Scheme.globalSectionsBaseChangeAlgEquiv' depends on axioms: [propext, Classical.choice, Quot.sound]
'AlgebraicGeometry.Adelic.p1Cech_h0_baseChange_of_fibrewise_h1_vanishing' depends on axioms: [propext, Classical.choice, Quot.sound]
```

I also confirmed (`/tmp/audit_ajc_anchor.lean`) that the anchor is genuinely open — both fail to synthesize:
```
failed to synthesize instance of type class AlgebraicGeometry.IsIntegral (p1Over k).left
failed to synthesize instance of type class GeometricallyIntegral (p1Over k).hom
```

## 5. The mathematical question

**Is `IsIntegral (ℙ¹_k)` true for every field `k`? Yes — every field, including finite and non-algebraically-closed ones.** In this encoding `ℙ¹_k = Proj ℤ[X₀,X₁] ×_{Spec ℤ} Spec k = Proj k[X₀,X₁]`. It is covered by `D₊(X₀) ≅ Spec k[X₁/X₀]` and `D₊(X₁) ≅ Spec k[X₀/X₁]`, each `Spec` of a polynomial ring over a field, hence integral (so irreducible and reduced); their intersection `D₊(X₀X₁) = Spec k[t,t⁻¹]` is nonempty. Reducedness is local, so `ℙ¹_k` is reduced; a space covered by two irreducible opens with nonempty intersection is irreducible; and it is nonempty. Hence integral by mathlib's `isIntegral_of_irreducibleSpace_of_isReduced`. Nothing in this argument uses algebraic closedness, perfectness, or infiniteness of `k` — it only uses that `k[X₀,X₁]` is a domain. So the anchor is a true statement, not a disguised extra assumption.

**Is it genuinely weaker than `GeometricallyIntegral ((p1Over k).hom)`? As a hypothesis, yes, strictly.** Mathlib's `GeometricallyIntegral f` (`Mathlib/AlgebraicGeometry/Geometrically/Integral.lean:40`) says `X ×_Y Spec K` is integral for *every* field-valued point `Spec K ⟶ Y`. The forward implication is the file's :442 lemma, backed by mathlib `GeometricallyIntegral.isIntegral_of_subsingleton [GeometricallyIntegral f] [Subsingleton S] [IsIntegral S] : IsIntegral X` (Integral.lean:96) — both side conditions are legitimately discharged at :445-449. The converse is false in general: `Spec ℂ ⟶ Spec ℝ` is integral but `Spec (ℂ ⊗_ℝ ℂ) ≅ Spec (ℂ × ℂ)` is not. Caveat for honest reporting: *for the specific scheme ℙ¹_k both are true*, so "strictly weaker" describes the strength of the remaining proof obligation, not a difference in truth value. The practical gain is real though — discharging the §5 anchor means proving irreducible + reduced for one scheme, versus quantifying over all field extensions.

**Does mathlib have it?** No. There is **no** `IsIntegral`/`IrreducibleSpace`/`IsReduced` result for `Proj` anywhere in `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/` (grep is empty; leansearch returns only generic `IsIntegral` criteria). The closest prior art is the **affine** analogue, which mathlib does have in full: `Mathlib/AlgebraicGeometry/AffineSpace.lean:399` `instance [IrreducibleSpace S] : IrreducibleSpace 𝔸(n; S)`, `:409` `instance [IsReduced S] : IsReduced 𝔸(n; S)`, `:418` `instance : GeometricallyIntegral (𝔸(n; S) ↘ S)`, `:422` `instance [IsIntegral S] : IsIntegral 𝔸(n; S)`. That file is a directly usable template for closing the anchor on the Proj side.

## 6. The one thing to fix (documentation, not soundness)

`RigidPushforwardP1Constants.lean:386-389` and `:75` claim the §5 anchor is "strictly weaker than `P1HasTrivialConstants k`" (i.e. than `Γ(ℙ¹_k,𝒪) = k`). Read as an implication that is **false in general**: `Γ(X,𝒪) = k` does not imply `X` integral (e.g. a double line in `ℙ²` has `H⁰ = k` but is non-reduced), and conversely `X` integral proper over `k` only gives `Γ(X,𝒪)` a finite field *extension* of `k` (e.g. `ℙ¹_ℂ` as an `ℝ`-scheme). The two anchors are logically incomparable. What *is* true and is what the §5 route actually exploits: the downstream consumer needs only `Module.Finite`, not bijectivity, and `IsIntegral + proper` supplies finiteness via `finite_appTop_of_universallyClosed`. The `GeometricallyIntegral ⇒ IsIntegral` comparison at :388/:442 is fully correct; only the `P1HasTrivialConstants` comparison is loose.
