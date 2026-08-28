I have gathered sufficient search results across all seven areas. Here's the availability report at this workspace's mathlib pin:

## 1. Invariants of a group action on a ring

- EXISTS `FixedPoints.subring : Subring B` — `Mathlib/Algebra/Algebra/Subalgebra/Operations.lean:98`
- EXISTS `FixedPoints.subsemiring : Subsemiring B'` — same file, line 90
- EXISTS `FixedPoints.subfield` (used e.g. in `Mathlib/FieldTheory/Fixed.lean`, e.g. line 107, 129) — for a field `F` with `MulSemiringAction M F`
- EXISTS instance `SMulCommClass G (FixedPoints.subring B G) B` — `Subalgebra/Operations.lean:102`
- ABSENT `FixedPoints.toAlgHom` — no match found by that name
- EXISTS the Noether-integrality result, but under a different name: `Algebra.IsInvariant.isIntegral [Finite G] : Algebra.IsIntegral A B` — `Mathlib/RingTheory/Invariant/Basic.lean:179`. This requires the hypothesis class `Algebra.IsInvariant A B G` (defined same file, ~line 15-30: "every fixed point of `B` lies in the image of `A`"), which for `A = FixedPoints.subring B G` is basically automatic/definitional. There's also `IsGaloisGroup.ringEquivFixedPoints : A ≃+* FixedPoints.subsemiring B G` in `Mathlib/FieldTheory/Galois/IsGaloisGroup.lean:142`.
- ABSENT anything literally named `FixedPoints.isIntegral` or `isIntegral_of_fixedPoints`.
- No `Module.Finite`-of-invariants (full Noether finite-generation theorem for polynomial rings) was found; only the integrality half (`Algebra.IsInvariant.isIntegral`) exists. Searches for "Noether invariant theory," "module finite invariants," turned up nothing on-point in mathlib — this appears ABSENT.

## 2. Localization vs invariants

ABSENT. No lemma of the form `(A^G)_b ≃ (A_b)^G` was found. Searches surfaced only generic `IsLocalization.Away` material (base change, tensoring, etc.) and Frobenius-element material (`IsArithFrobAt.exists_of_isInvariant`, `Mathlib/RingTheory/Frobenius.lean:219`) — none state the localization/invariants compatibility.

## 3. Categorical: limit of `SingleObj G ⥤ CommRingCat` as fixed points

EXISTS, but only at `Type`-level, not yet ring-level:
- `CategoryTheory.Limits.SingleObj.Types.sections.equivFixedPoints : J.sections ≃ MulAction.fixedPoints M (J.obj (SingleObj.star M))` — `Mathlib/CategoryTheory/Limits/Shapes/SingleObj.lean:62`
- `CategoryTheory.Limits.SingleObj.Types.colimitEquivQuotient` (dual statement for colimits/orbits) — same file, line 104

These are for `J : SingleObj M ⥤ Type u`. No `CommRingCat`-specific specialization identifying the limit of a `SingleObj G ⥤ CommRingCat` diagram as `FixedPoints.subring` was found — you'd have to compose with `CommRingCat.limitCommRing` (`Mathlib/Algebra/Category/Ring/Limits.lean:417`) yourself. `CategoryTheory.Action` category and `Rep` exist but no direct "FixedPoint functor" bridging to `CommRingCat`.

## 4. Quotients of schemes by a finite group

ABSENT everywhere searched (mathlib, AJC, AJCR). No `quotient scheme`, no `SymmetricPower scheme` giving GIT/geometric quotients, no categorical-quotient-of-schemes construction. What exists:
- `AlgebraicGeometry.Scheme.GlueData` / `GlueData.gluedScheme` (generic gluing machinery, not group-quotient specific) — `Mathlib/AlgebraicGeometry/Gluing.lean`
- In-project: `AJC/Picard/FiniteGaloisQuotient.lean` and `AJC/Picard/GaloisQuotientGlue.lean` define `SemilinearGalAction`, `IsGaloisQuotient`, `HasGaloisQuotient` (a project-specific notion of Galois quotient for affine/glued schemes under a finite Galois group action) — these are workspace-local constructions, not mathlib.
- `AJC/Albanese/SymPowColimit.lean` has `symPowData_affineAlgebra` (line 457) whose docstring explicitly states: "morally `(Under k)ᵒᵖ` is affine `k`-schemes ... and the carrier is `Spec` of the invariant subring of the `n`-fold tensor power — but **neither bridge is built here**." This confirms the Spec-of-invariants-as-quotient bridge is a known, explicitly-flagged gap in the project itself.

## 5. divFunctor and friends in AJC / AJCR

- EXISTS `AlgebraicGeometry.Scheme.PicScheme.divFunctor` in AJC:
  ```
  noncomputable def divFunctor {k : Type u} [Field k] (C : Over (Spec (.of k))) :
      (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u+1) := DivFunctor C.hom
  ```
  `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:216-219`
- EXISTS a *different* `divFunctor` in AJCR (degree-`n`, Zariski-family flavored):
  ```
  noncomputable def divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u where
    obj T := divFamZar C π n T.unop
    map g := ↾divFamZar.map C π n g.unop ...
  ```
  `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyZarFunctor.lean:45`
- EXISTS `AlgebraicGeometry.Scheme.PicScheme.HasDivFunctor` class in AJC (`FGAPicRepresentability.lean:199`) — docstring flags it as **vacuous** ("does not mention `C` at all... carries no mathematical content").
- EXISTS `AlgebraicGeometry.Scheme.DivFunctorDeg`, `divFunctorDegι`, `AlgebraicGeometry.Scheme.PicScheme.divFunctorDeg` (degree-`d` subfunctors) in `AJC/Picard/DivDegree.lean:480,500,660`.
- EXISTS `AlgebraicGeometry.Scheme.CurveDivisor` (AJCR, `RiemannRoch/BpfSpanCore.lean`) and `X.WeilDivisor`/`X.PrimeDivisor` (AJC, `RiemannRoch/Adelic/*`) as divisor types, plus `pointDivisor`.
- EXISTS `AlgebraicGeometry.Scheme.PicScheme.instHasAbelMap`/`HasAbelMap`, `abelDivTrans`, `abelDeg_eq`, `AlgebraicGeometry.abelDivTrans` — Abel map machinery in both projects (AJC `FGAPicRepresentability.lean:682`, `DivDegree.lean:701`; AJCR `Picard/DivSchemeAbel.lean`).
- ABSENT `Hilbert scheme`, `Div^n` as a literal name, `AbelJacobi` (no matches; search only surfaced unrelated `jacobiTheta`/`jacobiSum` analytic number theory lemmas).

## 6. Spec fully-faithful, ΓSpec adjunction, AffineScheme equivalence

All EXIST in mathlib:
- `AlgebraicGeometry.Spec.fullyFaithfulToLocallyRingedSpace : Spec.toLocallyRingedSpace.FullyFaithful` — `Mathlib/AlgebraicGeometry/GammaSpecAdjunction.lean:510`
- `AlgebraicGeometry.ΓSpec.locallyRingedSpaceAdjunction : Γ.rightOp ⊣ Spec.toLocallyRingedSpace` — same file, line 328 (plus `ΓSpec.adjunction`, `ΓSpec_adjunction_homEquiv_eq` referenced at lines 413/497)
- `AlgebraicGeometry.AffineScheme.equivCommRingCat : AffineScheme ≌ CommRingCatᵒᵖ` — `Mathlib/AlgebraicGeometry/AffineScheme.lean:217`
- `CategoryTheory.Over.opEquivOpUnder : Over (op X) ≌ (Under X)ᵒᵖ` — `Mathlib/CategoryTheory/Comma/Over/Basic.lean:1405`
- `AlgebraicGeometry.AffineScheme.hasColimits`/`hasLimits : HasColimits/HasLimits AffineScheme` — `AffineScheme.lean:227,231`
- `Over.forget` creating colimits: no generic `Scheme`-level instance found by that exact search, but `AlgebraicGeometry` instance `CreatesColimitsOfShape (Discrete J) (MorphismProperty.Over.forget P ⊤ S)` exists in `Mathlib/AlgebraicGeometry/LimitsOver.lean:119`, and generically `CategoryTheory.Over` instance `HasColimits (Over X)` given `HasColimits C` — `Mathlib/CategoryTheory/Limits/Over.lean:48`.
- `HasCoproducts Scheme`: no directly-named instance found; `AlgebraicGeometry.Scheme.Modules` has `HasColimits X.Modules` (line 51 of `Modules/Sheaf.lean`) but that's the sheaf-of-modules category, not `Scheme` itself. I did not find a mathlib instance giving `Scheme` arbitrary coproducts — treat as unverified/likely ABSENT for `Scheme` (mathlib is known to lack general Scheme colimits beyond gluing-based constructions).

## 7. Finite group acting on a scheme, Spec-of-invariants-as-quotient

ABSENT in mathlib. No `MulAction G X` instance for `X : Scheme`, no `IsInvariant` (Scheme-level; the `Algebra.IsInvariant` from item 1 is ring-level only), no `Scheme.quotient`. This is exactly the gap the project's own `SymPowColimit.lean:457` docstring calls out as unbuilt. The only scheme-level, group-action infrastructure that exists is workspace-local: AJC's `SemilinearGalAction`/`HasGaloisQuotient` (`Picard/FiniteGaloisQuotient.lean`, `Picard/GaloisQuotientGlue.lean`), which handles the *affine* Galois-quotient case via `specOverEquivAlgHom`/`affineGaloisQuotientHomEquiv` but is not a general scheme-quotient construction and is not in mathlib.

Files referenced (absolute paths):
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/RingTheory/Invariant/Basic.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/Algebra/Algebra/Subalgebra/Operations.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/FieldTheory/Fixed.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/FieldTheory/Galois/IsGaloisGroup.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Limits/Shapes/SingleObj.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/GammaSpecAdjunction.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/AlgebraicGeometry/AffineScheme.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib/Mathlib/CategoryTheory/Comma/Over/Basic.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/DivDegree.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyZarFunctor.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/SymPowColimit.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FiniteGaloisQuotient.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/GaloisQuotientGlue.lean`
