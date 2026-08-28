Survey complete. Findings below.

## Q1 — AJCR `AlgebraicJacobian/Albanese/` (24 files, 7327 lines, **0 real sorries**)

All 24 files are flat in one directory. Line counts / grep-hits for the token `sorry` (every hit is prose inside a docstring — I read each line; there is not one code-position `sorry`):

`Milne33CMEquidim` 495/0, `CodimOneStalkRegularity` 468/0, `Milne33Pullback` 433/0, `CodimOneSmoothReduced` 404/0, `PolePurityLocal` 399/0, `Milne33KernelGen` 391/0, `Milne33Transport` 390/0, `Milne33Rows` 382/0, `DifferenceMap` 379/0, `Milne33Diagonal` 356/0, `Milne33TransportLocal` 329/0, `CodimOneMatsumura` 309/0, `Thm32RationalMapExtension` 293/2(prose), `Milne33Substeps` 265/0, `PolePurity` 252/0, `CodimOneMilne31` 252/1(prose), `RationalMapProd` 251/0, `Milne33RowSection` 244/0, `CodimOneDVRStalk` 230/1(prose), `Milne33` 206/0, `CodimOneIndeterminacy` 180/2(prose), `RationalMapPrecomp` 176/0, `CodimOneExtensionUnique` 122/0, `RationalMapFunctionField` 121/0.

**AJCR has no symmetric-power work at all.** The only `Sym` hits in the whole directory are two prose mentions of "symmetric-product rational map `C^{(g)} ⇢ A`" (`Thm32RationalMapExtension.lean:27,243`). There is no `SymPow*`, no `permDiagram`/`permAut`/`permEnd`/`permAlgHom`, no `PiTensorProduct`, no `HasColimit`, no glue data, and no Abel-Jacobi map in AJCR's Albanese leg. AJCR is entirely the codim-one-extension / Milne-3.3 / rational-map lane; **AJC is strictly ahead on symmetric powers, and AJCR has nothing AJC lacks there.**

AJCR does have scheme gluing, but in its Picard leg, not Albanese: `AlgebraicJacobian/Picard/GrassmannianGlue.lean:320`

```lean
noncomputable def glueData (k : Type u) [Field k] (d r : ℕ) : Scheme.GlueData.{u} where
```

with the colimit consumed at `Picard/GrassmannianScheme.lean:95` via `Limits.Multicoequalizer.desc (glueData k d r).diagram …`. That is a worked example of "assemble a scheme from charts", with no group action.

For contrast, AJC's `Albanese/` is 36 files / 15664 lines with **6 real sorries, all in `AlbaneseUP.lean`**: `abelJacobi` (:415), `SymmetricPower` (:462), `symmetricPowerAVMap` (:507), `symmetricPowerToJacobian` (:544), `descentThroughBirationalSigma` (:601), `albanese_eq_iff_symmetricPower_eq` (:638).

## Q2 — `SubProjects/Albanese`

It exists and is an **older snapshot of AJC's Albanese leg** (8 files / 7698 lines in `AlgebraicJacobian/Albanese/`), not an independent line of work: `AuslanderBuchsbaum` 3219, `CodimOneExtension` 1768, `SmoothPrimeRegularity` 768, `PolePurity` 616, `AlbaneseUP` 539, `Thm32RationalMapExtension` 337, `CoheightBridge` 236, `StandardSmoothDimension` 215. Real code sorries: `AlbaneseUP.lean` 7 (`bundle` at :183, then :250, :300, :335, :373, :417, :458) and `CodimOneExtension.lean:1721` — 8 total in the Albanese dir; ~98 grep-hits project-wide, mostly prose plus `GmScaling.lean:770` and `AuslanderBuchsbaum` typed sorries. **No scheme-level quotient-by-finite-group and no symmetric power**: its `AlbaneseUP.lean:273` `SymmetricPower` is a sorry-bodied carrier with the docstring "Mathlib `b80f227` has no formalised symmetric power". No other SubProject (Cech-Cohomology, GR-Quot-Closure, Line-Bundle-Comparison-Iso, Picard-IdentityComponent, RelatedPapersFormalisation) mentions Albanese or symmetric powers.

## Q3 — quotient of a scheme by a finite group action: **AJC already has the engine, in its Picard leg**

This is the headline. Mathlib has nothing: `Mathlib/AlgebraicGeometry/` has no file for quotients by group actions, and the only `MulAction` occurrences there are elliptic-curve coordinate changes and `ValuativeCriterion`. But AJC's own tree has a **sorry-free finite-Galois-quotient engine**, and the Albanese leg does not consume it.

`MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean` (550 lines, 0 sorries) — `FiniteGaloisQuotient.lean:103`:

```lean
noncomputable def toSpecAut : G →* Aut (Spec (CommRingCat.of A)) :=
```

Group acting on a ring by ring automorphisms ⟹ acts on `Spec A` by scheme **automorphisms** (`γ ↦ Spec (γ⁻¹ • ·)`; inversion forced by contravariance + the `Aut` law). Also `SemilinearGalAction` (:155), `IsStableOpen` (:189), `OrbitsInAffineOpen` (:184), `HasStableAffineCover` (:203), and the quotient predicate + gate:

```lean
def IsGaloisQuotient (ρ : SemilinearGalAction K L X f) {Y : Scheme.{u}}
    (g : Y ⟶ Spec (CommRingCat.of K)) : Prop :=      -- :374
class HasGaloisQuotient [FiniteDimensional K L] [IsGalois K L]
    (ρ : SemilinearGalAction K L X f) [ρ.OrbitsInAffineOpen] : Prop where   -- :393
```

`Picard/FiniteGaloisQuotientAffine.lean:473` — the affine case is a **theorem, proved**:

```lean
theorem isGaloisQuotient_spec :
    IsGaloisQuotient (specSemilinearGalAction K L A)
      (Spec.map (CommRingCat.ofHom (algebraMap K (invariantsSubalgebra K L A))))
```

i.e. `Spec (A^Γ) ⟶ Spec K` is the quotient, with the equivariant base-change iso and the universal `T`-points property for **all** schemes `T` (globalized by gluing along an affine cover of `T`).

`Picard/GaloisQuotientGlue.lean` (433 lines, 0 sorries) is the gluing lane in progress: the section-level action `sectionsMulSemiringAction` (:176), `isSemilinear_sections` (:316), the scheme-level restriction `restrict` (:374), and the Spec-functoriality bridge `actRes_isoSpec_hom_toSpecAut` (:415). Its opening audit records that **affineness of overlaps is not required** (integral `π_U` with orbits as fibres), which is the classical SGA I V.1.8 route.

`Albanese/StableAffineCoverGroup.lean:151` is the bare-action stable-cover theorem:

```lean
variable {G : Type u} [Group G] [Finite G] {X : Scheme.{u}} (act : G →* Aut X)
theorem exists_stable_affineOpen_of_orbits (h : OrbitsInAffineOpen act) (x : X) :
    ∃ U : X.Opens, IsAffineOpen U ∧ x ∈ U ∧ IsStableOpen act U
```

Note the binder: `act : G →* Aut X` — **exactly the `Equiv.Perm (Fin n) →* Aut (C^n)` shape of your residue (2)**, and the proof uses only `map_one`/`map_mul` (norm `∏_g g(s)`, no averaging, so char-free).

Mathlib support that the engine rests on: `Mathlib/RingTheory/Invariant/Basic.lean` (`Algebra.IsInvariant`, `IsInvariant.isIntegral`, `exists_smul_of_under_eq` = transitivity on primes over a prime of the invariants), plus `Mathlib/AlgebraicGeometry/Gluing.lean` (`Scheme.GlueData`, `IsLocallyDirected.glueData`) and `Scheme.Cover.glueMorphisms`.

**Correction to your CONTEXT.** "`permAut` is never shown invertible / `permEnd` lands in `End`" is accurate as far as it goes — I confirmed `MonObj.permAut` (`Albanese/GrpObjFoldSum.lean:146`) is a bare morphism `(∏ᶜ fun _ : Fin n => C) ⟶ (∏ᶜ fun _ : Fin n => C)` and `SymPowColimit.permEnd` (:101) lands in `End`, and there is no `permAut_comp`/`IsIso` lemma anywhere in AJC. But the framing "AJC has no `→* Aut` producer" understates the position twice: (i) `permAut C σ` is *manifestly* invertible with inverse `permAut C σ⁻¹` — the composition law is one `Pi.hom_ext` + `permAut_π`, already written inside `permEnd.map_mul'` (`SymPowColimit.lean:107-112`); upgrading `permEnd` to `Equiv.Perm (Fin n) →* Aut (C^n)` is a mechanical repackaging of code that exists, not new mathematics. (ii) `StableAffineCoverGroup.lean:51`'s own scope note says the theorem "has no producer" for `S_n` — that note is what generated your residue (2), and the missing producer is precisely that repackaging. AJC's `Albanese/SymPowColimit.lean:490` also already records `HasCoproducts Scheme` as available.

## Q4 — mathlib at rev `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`

**No n-ary coproduct ≅ tensor power result, in any form.** `PiTensorProduct` is mentioned **nowhere** in `Mathlib/Algebra/Category/`, `Mathlib/AlgebraicGeometry/`, or `Mathlib/CategoryTheory/` (verified by grep across all three trees). So the comparison in your residue (3) is genuinely absent upstream.

Binary case, `Mathlib/Algebra/Category/Ring/Constructions.lean`: `pushoutCocone` (:43), `pushoutCocone_inl/inr/pt` (:55/:60/:65), `pushoutCoconeIsColimit` (:71), `isPushout_tensorProduct` (:112), and for the absolute coproduct over `ℤ` — `coproductCocone` (:190), `coproductCoconeIsColimit` (:207), `coproductColimitCocone` (:226). `Mathlib/Algebra/Category/CommAlgCat/Monoidal.lean`: `binaryCofan` (:33) with `binaryCofanIsColimit` (:40) — the tensor product as *fibered* coproduct in `CommAlgCat R` — plus `MonoidalCategory` (:55), `BraidedCategory` (:85), and `CartesianMonoidalCategory (CommAlgCat R)ᵒᵖ` (:99). `Mathlib/Algebra/Category/Ring/Under/Limits.lean` has only the **limit/product** side (`piFan`, `tensorProductFanIsLimit`, equalizers, `PreservesFiniteProducts (tensorProd R S)`) — no cofan.

Categories with colimits: `HasColimits (CommAlgCat R)` at `Mathlib/Algebra/Category/CommAlgCat/Basic.lean:215`; `HasColimits CommRingCat` at `Ring/Colimits.lean:588`; `HasColimits RingCat` at `:287`. `AlgCat` has only filtered colimits (`AlgCat/FilteredColimits.lean:89`). So the n-ary coproduct *exists* abstractly in `CommAlgCat R` — what is missing is only its identification with `⨂[R] i, A i`.

Algebra structure on `PiTensorProduct` — `Mathlib/RingTheory/PiTensorProduct.lean` (this is the file):
`instOne` :34, `instMul` :61, `instSemiring` :150, **`instAlgebra R' (⨂[R] i, A i)` :154**, `instRing` :235, `instCommSemiring` :252, **`instCommRing` :310**, `tprodMonoidHom` :116, `constantBaseRingEquiv : (⨂[R] _ : ι, R) ≃ₐ[R] R` :271. And the three declarations that *are* the n-ary coproduct universal property in algebra form:

```lean
def singleAlgHom [DecidableEq ι] (i : ι) : A i →ₐ[R] ⨂[R] i, A i                    -- :192
def liftAlgHom {S : Type*} [Semiring S] [Algebra R S] (f : MultilinearMap R A S)
    (one : f 1 = 1) (mul : ∀ x y, f (x * y) = f x * f y) : (⨂[R] i, A i) →ₐ[R] S    -- :207
theorem algHom_ext {S : Type*} [Finite ι] [DecidableEq ι] [Semiring S] [Algebra R S]
    ⦃f g : (⨂[R] i, A i) →ₐ[R] S⦄
    (h : ∀ i, f.comp (singleAlgHom i) = g.comp (singleAlgHom i)) : f = g            -- :221
```

`singleAlgHom` = the cofan legs, `liftAlgHom` = descent, `algHom_ext` = uniqueness (`@[ext high]`, needs `[Finite ι]`). Assembling `IsColimit` for the n-ary cofan in `Under R`/`CommAlgCat R` from these three is bookkeeping, not mathematics — the only real content is turning a family of `AlgHom`s into the `MultilinearMap` that `liftAlgHom` wants.

**`PiTensorProduct.reindexAlgEquiv` does not exist.** Only the linear version, `Mathlib/LinearAlgebra/PiTensorProduct.lean:677`:

```lean
def reindex (e : ι ≃ ι₂) : (⨂[R] i : ι, s i) ≃ₗ[R] ⨂[R] i : ι₂, s (e.symm i)
```

with `reindex_tprod` :685, `reindex_comp_tprod` :691, `lift_comp_reindex` :696. Upgrading it to an `AlgEquiv` is what AJC already did by hand: `Albanese/SymPowTensorAction.lean:111` `permAlgHom`, :151 `permAlgEquiv`, :182 `permMulSemiringAction`, :239 `symTensorPowSubalgebra`, and the two colimit statements `hasColimit_actionDiagram_op_symTensorPow` (:335) / `hasColimit_actionDiagramUnder_op_symTensorPow` (`SymPowInvariantsUnder.lean:274`). So residue (3) is the *comparison* only; AJC's side of it is built and the mathlib side has the universal property but not the categorical packaging.
