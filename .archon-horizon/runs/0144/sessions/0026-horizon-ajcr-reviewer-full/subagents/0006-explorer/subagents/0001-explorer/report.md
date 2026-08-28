Let
`b := Spec.map (CommRingCat.ofHom (algebraMap K L)) : Spec L ⟶ Spec K`.

**Available Quotient Interface**

- [GaloisQuotientDescent.lean:28](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:28) assumes fields `K,L`, `[Algebra K L] [FiniteDimensional K L] [IsGalois K L]`, an `L`-scheme `f : X ⟶ Spec L`, a strict action `ρ : SemilinearGalAction K L X f`, and a proposed projection `q : X ⟶ Y`.

- [galoisQuotientUniversal_of_equivariant:215](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:215) takes
  `e : pullback g b ≅ X`,
  `e.hom ≫ f = pullback.snd g b`,
  `e.inv ≫ pullback.fst g b = q`, and
  `∀ γ, (ρ.act γ).hom ≫ q = q`.
  It concludes, for every `T,t,h` over `Spec K/L` with `h` equivariant,
  ```lean
  ∃! v : {v : T ⟶ Y // v ≫ g = t},
    pullbackBaseChange K L g t v.1 v.2 ≫ e.hom = h
  ```
  Thus it proves the quotient universal property but does not construct `Y`, `g`, `q`, or `e`.

- [galoisQuotientWitnessOfInvariantProjection:234](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:234) adds
  `(pullbackSemilinearGalAction K L g).IsEquivariant ρ e.hom`
  and packages the above data as
  `GaloisQuotientWitnessWithProjection ρ Y g q`.

- [galoisQuotientUniversal_of_kernelPair:97](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:97) is the lower-level effectivity theorem. It only needs the kernel-pair equality; the actual descent is performed by `EffectiveEpi.desc` at [line 148](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:148). The finite/Galois hypotheses are omitted from this theorem; they are used by [kernelPair_eq_of_equivariant:36](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientDescent.lean:36) to obtain that equality from invariance.

**Concrete Scheme Construction**

- [StableAffineOpen:47](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:47) contains
  `U : X.Opens`, `affine : IsAffineOpen U`, and `stable : ρ.IsStableOpen U`.

- [quotientChart:85](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:85) is
  `Spec (SemilinearAction.invariantsSubalgebra K L Γ(X,U))`.
  [quotientGlueData:809](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:809) glues all such charts, and [gluedQuotient:853](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:853) returns a `Scheme`.

- [isGaloisQuotient_glued:1626](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:1626) proves
  ```lean
  [FiniteDimensional K L] [IsGalois K L] [HasStableAffineCover K L ρ] →
  IsGaloisQuotient ρ (gluedQuotientMap ρ)
  ```

- [hasGaloisQuotient_of_orbitsInAffineOpen:1635](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:1635) is the existence producer:
  ```lean
  [FiniteDimensional K L] [IsGalois K L] [ρ.OrbitsInAffineOpen] →
  HasGaloisQuotient ρ
  ```
  Its witness is `⟨gluedQuotient ρ, gluedQuotientMap ρ, isGaloisQuotient_glued ρ⟩`.

- [gluedQuotientOver:1643](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GaloisQuotientOverlap.lean:1643) has type
  `Over (Spec (CommRingCat.of K))`. It requires only finite/Galois hypotheses, but without the stable-cover/orbit hypothesis there is no theorem identifying this object as the quotient.

**Action And Orbit Encoding**

- The required action is a strict `SemilinearGalAction K L X f`: its `act` field is `(L ≃ₐ[K] L) →* Aut X`, with each automorphism covering the corresponding automorphism of `Spec L` ([SemilinearAction.lean:116](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/SemilinearAction.lean:116)).

- `ρ.OrbitsInAffineOpen` means
  ```lean
  ∀ x : X, ∃ U : X.affineOpens,
    ∀ γ : L ≃ₐ[K] L, (ρ.act γ).hom.base x ∈ U.1
  ```
  ([SemilinearAction.lean:141](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/SemilinearAction.lean:141)). It automatically produces `HasStableAffineCover K L ρ`.

**Remaining Bridge Gap**

Neither target file mentions `Representable`, presheaves, or sheaves. They do not turn representability after scalar extension into representability over `K`. A consumer must still construct:

1. the finite Galois extension `L/K`;
2. the representing `L`-scheme and its strict semilinear action;
3. `ρ.OrbitsInAffineOpen` (or `Scheme.FiniteInAffine X`, which implies it);
4. a separate identification of the original functor with the functor represented by `gluedQuotientOver`.

Thus quotient effectivity itself is present and sorry-free; the missing interface is upstream descent data/action/orbit production and the downstream representability comparison.
