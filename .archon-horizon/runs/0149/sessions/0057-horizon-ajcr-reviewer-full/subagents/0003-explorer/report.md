Read-only audit complete. No repository or Horizon-state edits.

**Established, kernel-clean Rebuild chain**

- [`Pic0RankOneCanonicalEvaluation.lean:250`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:250) constructs `canonicalRankOneEvaluationDivisorData`; [`:259`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259) exposes `canonicalRankOneAbelIso`.
- [`Pic0RankOneAbelInverse.lean:181`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean:181) defines
  ```lean
  PicRankOneEvaluationDivisorData.rankOneAbelIso
    (E : PicRankOneEvaluationDivisorData pi) :
    rankOneDivisorLocus … ≅ rankOneLocus …
  ```
  using the proved automatic inverse law at `:169`; this is not a remaining gate.
- [`Pic0SepClosedRepresentable.lean:426`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426) defines
  ```lean
  pic0_sepClosed_representableBy :
    Σ J, (pic0TypeFunctor C).RepresentableBy J
  ```
  under the ambient smooth/proper/geometrically-irreducible and `[IsSepClosed k]` assumptions. Producers are `picRankOneOpen_isOpen`, `picRankOneTranslatedChart_isOpenImmersion`, pointwise coverage, and `pic0RepresentableByOfCharts` at `:421`.
- [`Pic0SepClosedJacobianData.lean:138`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:138) packages it as `picRepDatumSepClosed`; [`:146`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:146) produces the genuine `jacobianDataSepClosed`.

**Finite-Galois endpoint**

[`Pic0FiniteGaloisRepresentable.lean:35`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35) proves the honest conditional theorem:
```lean
pic0RepresentableBy_finiteGaloisDescent
  (rep : RepresentableBy Pic0(C_L) J)
  [FiniteDimensional K L] [IsGalois K L]
  [pic0SemilinearGalActionOfRepresentableBy C rep |>.OrbitsInAffineOpen] :
  RepresentableBy Pic0(C) (gluedQuotientOver ...)
```
It rests on the real quotient equivalence in [`Pic0FiniteGaloisDescent.lean:129`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisDescent.lean:129) and invariant comparison. It has no `sorry`; it deliberately does **not** manufacture `rep`, an orbit-affineness instance, or a finite level.

There is no declaration named `pic0_representableBy` in either project. It remains a desired arbitrary-field endpoint, not an existing theorem to fill.

**Data handoff**

- [`PicRepDatum.lean:89`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:89): fields `J`, `rep : RepresentableBy Pic0(C') J`, `lft`.
- [`JacobianData.lean:87`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianData.lean:87): adds `quasiCompact`.
- [`JacobianDataHandoff.lean:39`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataHandoff.lean:39) converts `PicRepDatum k k C` plus `QuasiCompact` to `JacobianData C`; it is a consumer, not a general producer.

**Shortest remaining honest cone**

```text
finite-stage GluePackage
  + global glued-scheme base-change/naturality
  + finite-level universal Pic0 natural equivalence
  -> actual rep : RepresentableBy Pic0(C_L) P.gluedOver
  + finite Galois L/K
  + OrbitsInAffineOpen
  -> pic0RepresentableBy_finiteGaloisDescent
  -> PicRepDatum K K C (+ lft, qc)
  -> JacobianData K C
  -> frozen Challenge declarations
```

The nearest concrete work is the finite-stage global comparison: [`Pic0FiniteStageGluingDiagramIso.lean:88`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:88) now gives an overlap isomorphism, but no `gluingOverlapIso` projection/naturality consumers exist. This is a nonvacuous next endpoint. It still precedes the indispensable universal-equivalence descent, so it cannot by itself create finite-level `rep`.

Orbit-affineness also has only conditional producers: [`Pic0FiniteStageOrbitAffine.lean:76`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:76), `:107`, and `:131` require respectively algebraic-closed irreducibility, algebraic-closed connectedness, or a projective-space immersion. None supplies these hypotheses for the actual finite-stage Picard object.

**Challenge boundary**

[`Challenge.lean:96`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:96) still has the frozen `Jacobian := sorry`; all headline fields remain `sorry`-backed: group object `:107`, smoothness `:112`, properness `:119`, geometric irreducibility `:126`, Abel map `:131`, Albanese property `:152`, functor map/laws `:165`, and base-change datum/coherences `:256`, `:265`, `:274`, `:291`.

The import boundary is real: the root [`AlgebraicJacobian.lean:168`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian.lean:168) imports `Challenge` before importing the Picard cone. Some intended Jacobian-discharge routes explicitly cannot use `riemann_inequality_curve`, because its Challenge import closes the cycle; see [`JacobianDataAbelSquare.lean:171`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataAbelSquare.lean:171).

The sibling AJC headline is not a substitute: [`Jacobian.lean:848`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean:848) assembles `picardJacobianWitness`, but its own documentation names five unresolved obligations at `:825-832`, and its source retains `sorry` leaves (e.g. `:447`, `:551`, `:648`, `:697`). Its étale Picard functor is also not definitionally the Rebuild `pic0TypeFunctor`.

Recommendation: advance the finite-stage global overlap/base-change comparison first; it is the shortest real next unit. Do not claim arbitrary-field `pic0_representableBy`, `PicRepDatum`, or the Challenge headline until it yields an actual finite-level natural `RepresentableBy` witness and the orbit-affineness hypothesis is discharged.
