Read-only search complete; no source edits.

- `Mathlib/AlgebraicGeometry/Sites/Fpqc.lean:109-125`
  - `instance {X Y : Scheme} (f : X ⟶ Y) [QuasiCompact f] [Surjective f] [Flat f] : EffectiveEpi f`
  - fppf variant replaces `QuasiCompact` with `LocallyOfFinitePresentation`.
- `Mathlib/CategoryTheory/EffectiveEpi/Basic.lean`
  - `EffectiveEpi.desc`, `EffectiveEpi.fac`, `EffectiveEpi.uniq`: descend morphisms equalizing kernel-pair relations. They do not descend schemes, objects, or universal elements.
- `Mathlib/AlgebraicGeometry/Sites/Representability.lean:192-208`
  - `Scheme.LocalRepresentability.representableBy`
  - `Scheme.LocalRepresentability.isRepresentable`
  - Requires a Zariski sheaf, relatively representable open-immersion charts, and local surjectivity; not an fpqc/Galois object-descent theorem.
- `Mathlib/CategoryTheory/Sites/Descent/{DescentData,IsStack,Precoverage}.lean`
  - General `Pseudofunctor.DescentData`, `toDescentData`, `IsStack.isEquivalence_toDescentData`, and `IsStackFor.essSurj`.
  - No Scheme-valued stack instance exists in mathlib, so these cannot be instantiated for Picard representers directly.
- Project-local `AlgebraicJacobian/Descent/AlgebraDescent.lean`
  - `Algebra.DescentDatum.comparison_bijective`, `descentEquiv`, `descentEquiv_naturality`: effective faithfully-flat descent of commutative algebras only.
- Existing `pic0RepresentableBy_finiteGaloisDescent` already descends a finite-level `RepresentableBy`, but requires `[OrbitsInAffineOpen]`.
- `pic0RepresentableBy_of_baseChangeObjectIso` only transports an existing representation across an explicit representing-object isomorphism.

Finite-stage audit:

- `Pic0FiniteStageGluePackage` and `Pic0FiniteStageGeometry` provide only finite-type and quasi-compact structure morphism results.
- `Pic0FiniteStageOrbitAffine` gives orbit affineness only under algebraic-closed plus irreducible/connected hypotheses, or an explicit projective-space immersion. Its projective wrapper requires `hproj : P.gluedMap.IsProjective`.
- No unconditional `IsProjective`/`IsProper` result exists for the package.

Conclusion: **No**, existing APIs do not eliminate the first missing producer: finite-stage universal Picard `RepresentableBy`/natural-equivalence descent remains absent. Unconditional arbitrary-field `OrbitsInAffineOpen` also remains unavailable.
