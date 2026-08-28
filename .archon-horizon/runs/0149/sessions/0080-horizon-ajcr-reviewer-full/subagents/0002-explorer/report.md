## Progress

- The requested live path, `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Challenge.lean`, does not exist. The legacy project’s git tree/history contains no such file.
- The canonical original is [`references/challenge.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/references/challenge.lean:50), with literal sorries at:
  - `genus` 51–54
  - `Jacobian` 57–60
  - `Jacobian` group instance 67–69
  - `smoothOfRelativeDimension_genus` 71–74
  - properness instance 76–78
  - geometric irreducibility instance 80–82
  - `ofCurve` 86–89
  - `comp_ofCurve` 91–95
  - `exists_unique_ofCurve_comp` 97–107
- The current legacy project instead splits the surface across:
  - [`Genus.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus.lean:41)
  - [`Jacobian.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean:922)
  - [`AbelJacobi.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelJacobi.lean:60)
- Current legacy root imports are `Genus` at `AlgebraicJacobian.lean:53`, `Jacobian` at `:62`, and `AbelJacobi` at `:63`; no current legacy module imports `AlgebraicJacobian.Challenge`.
- The current legacy public Jacobian/Abel-Jacobi declarations have no literal `sorry`, but transitively depend on five named sorry leaves:
  - `FGAPicRepresentability.lean:955–963`
  - `Pic0Et.lean:170–175`
  - `Pic0Et.lean:223–228`
  - `Jacobian.lean:548–551`
  - `Jacobian.lean:690–697`
  The two `picSharp` leaves at `Jacobian.lean:443–447` and `:640–648` are conditional and do not feed the headline witness.

## Rebuild Interface

- [`PicRepDatum.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/PicRepDatum.lean:89) defines fields `J`, `rep`, and `lft`; no `sorry`/`axiom`.
- [`JacobianData.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianData.lean:87) defines fields `J`, `rep`, `locallyOfFiniteType`, and `quasiCompact`; no `sorry`/`axiom`.
- [`JacobianDataHandoff.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/JacobianDataHandoff.lean:39) converts `PicRepDatum k k C` to `JacobianData C`, but requires an actual `QuasiCompact d.J.hom` input. Its field/equivalence lemmas are `rfl`.
- The only concrete `PicRepDatum` producer found is `picRepDatumSepClosed` under `[IsSepClosed k]` (`Pic0SepClosedJacobianData.lean:138–143`). There is no arbitrary-field `jacobianData C` producer and no finite-separable-stage producer.
- A datum describes `d.J`; it does not identify `d.J` with `Jacobian C`. Existing docs explicitly reserve `jacobianData C` and the equality `Jacobian C := (jacobianData C).J` for an absent DAT-J producer.
- Downstream data theorems are conditional: `AbelSourceData` is an explicit structure (`AbelSource.lean:90–104`), and universal-property descent needs explicit existence/base-change hypotheses (`Albanese/DescentUniqueness.lean:118–124`).

## Boundary Blocker

Both projects use the same Lake package/library name, `AlgebraicJacobian`, and neither declares the other as a dependency. More importantly, Rebuild’s `PicRepDatum` import cone reaches Rebuild `Challenge` through:

`PicRepDatum → Pic0SigmaSheaf → PicEtCoverBridge → Pic0ZariskiSheaf → Pic0Functor → DegreeZero → RelPicDegree → … → RiemannRoch.ChiCurve → Challenge`.

So `Challenge.lean` cannot import `PicRepDatum`/`JacobianData` to discharge its own declarations without an import cycle. Importing the sibling package would also collide on module/namespace identities. A downstream theorem can consume the data, but cannot retroactively fill the `Challenge` declarations. A clean integration would require a genuine cycle-free interface extraction/namespace/package refactor, not a one-line root import.

Rebuild root reachability is already present: `Challenge` at `AlgebraicJacobian.lean:168`, `JacobianData` at `:246`, `PicRepDatum` at `:261`, and `JacobianDataFromPicRepDatum` at `:789` (which transitively reaches the handoff). No direct extra root import is needed. No files were edited or built.
