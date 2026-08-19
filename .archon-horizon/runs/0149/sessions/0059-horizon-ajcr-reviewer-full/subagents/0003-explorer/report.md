Audit result at `fafc249cc6`:

```
AJCR rank-one cone (closed, direct source contains no `sorry`)
canonicalRankOneAbelIso
  Pic0RankOneCanonicalEvaluation.lean
  = canonicalRankOneEvaluationDivisorData.rankOneAbelIso
      (`rankOneAbelIso`, Pic0RankOneAbelInverse.lean)
  -> `picRankOneOpenSigmaIso`
  -> translated open charts
  -> `pic0_sepClosed_representableBy`
      (Pic0SepClosedRepresentable.lean)

sep-closed packaging only
pic0_sepClosed_representableBy
  -> picRepDatumSepClosed : PicRepDatum k k C
  -> jacobianDataSepClosed : JacobianData C
      (Pic0SepClosedJacobianData.lean)
```

`PicRepDatum` is a real three-field structure (`J`, `rep`, `lft`) in `Picard/PicRepDatum.lean`; `JacobianData` adds `quasiCompact` in `Picard/JacobianData.lean`. The handoff `PicRepDatum.toJacobianData` is definitional and axiom-free in `Picard/JacobianDataHandoff.lean` (currently being relocated from `JacobianDataFromPicRepDatum.lean`). It is only a conditional wrapper: arbitrary-field `PicRepDatum k k C` and QC are not produced.

There is no declaration named `pic0_representableBy` in either project. The nearest arbitrary-field result is the conditional
`pic0RepresentableBy_finiteGaloisDescent` in `Picard/Pic0FiniteGaloisRepresentable.lean`; it requires both:
- finite-level `rep : (pic0TypeFunctor C_L).RepresentableBy J`;
- `[OrbitsInAffineOpen (pic0SemilinearGalActionOfRepresentableBy C rep)]`.

`Pic0FiniteStageStableAffineCover.lean` only repackages that theorem under extra immersion/projectivity or algebraically-closed connected/irreducible hypotheses. It does not supply finite-level representability or an unconditional orbit certificate. Thus the shortest honest AJCR terminal route still requires finite-stage universal-equivalence descent plus orbit-affineness, then LFT/QC descent, then `PicRepDatum.toJacobianData`.

AJCR `Challenge.lean` is independent of that cone: it still has direct `sorry`s for `Jacobian`, group/dimension/proper/geometric instances, Abel map and pointing law, Albanese property, functor laws, and base-change statements (notably lines 99, 108, 113, 120, 127, 132, 140, 158, 168-170, 260, 271, 284, 296). A direct import would also create the known cycle through `Pic0Functor -> ... -> ChiCurve -> Challenge`.

AJC has a separate headline path:
`picardJacobianWitness` (`Jacobian.lean:848`) uses `Pic0SchemeEt`, not AJCR’s `JacobianData`. Its primary hazard is the unique real seam `Scheme.fgaPicardRepresentability` (`Picard/FGAPicRepresentability.lean:955`, `sorry` at 963), propagated by the unconditional `instHasPicSchemeEt`. The remaining headline leaves are also sorry-backed:
`Scheme.Pic0Et.geometricallyReduced`, `Scheme.Pic0Et.universallyClosed`,
`smoothOfRelativeDimension_genus_pic0Et` (`Jacobian.lean:548`), and
`isAlbanese_pic0Et` (`Jacobian.lean:690`).
Therefore conditional wrappers around `HasPicSchemeEt` are `sorryAx`-reachable, not terminal producers.

Recent commits improved phase-7 glue/right-leg/naturality and moved the handoff into challenge-free `JacobianDataHandoff.lean`; none changed the blocker list. In particular, no new finite-level `RepresentableBy`, universal Picard equivalence descent, unconditional orbit condition, arbitrary-field `pic0_representableBy`, `jacobianData`, or Challenge-headline rewiring landed. Note the shared worktree currently has staged deletions of `Pic0CriticalPath.lean`, `Pic0FiniteGaloisRepresentable.lean`, and `Pic0GaloisInvariantMatch.lean`; they are not a completed replacement and should not be interpreted as closing the route.
