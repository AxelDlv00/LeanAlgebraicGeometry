Read-only audit complete; no files or Horizon state changed.

- `Pic0FiniteStageGlueData.olean` is no longer absent. It was built at `2026-08-21 13:34:54` after the Reflection artifact.
- The first missing artifact is `Pic0FiniteStageGlueDataFace.olean`.
- The existing build is active, not wedged: PID `152833` is running `lake build ...Pic0FiniteStageGluingOverlapIsoPreSnd`; child PID `156329` is compiling [Pic0FiniteStageGlueDataFace.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGlueDataFace.lean:85) at about 98% CPU. At 14:25 +08 it had accumulated about 26 minutes CPU with no diagnostics.
- `PreSnd.olean` is absent because that build has not yet passed its upstream Face dependency.

The narrowest current unit is `pic0FiniteStageAffineTripleTransition_fac`, lines 85–199. It is already root-reachable through `Pic0CriticalPath -> GluePackage -> Assembly -> Face`, with existing `#check` and `#print axioms` at [Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:795). No root edit is needed for Face.

Do not start another build while the current compiler is active. After it returns successfully:

```bash
lake build AlgebraicJacobian.Picard.Pic0FiniteStageGluingOverlapIsoSnd
lake build AlgebraicJacobian.Picard.Pic0FiniteStageGluedComparison
```

Then import `Pic0FiniteStageGluedComparison` from the root, add checks and axiom scans for `gluingOverlapIso_pre_snd`, `gluingOverlapIso_snd`, `gluingGluedIso`, and `finiteStageBaseChangeIso`, and run:

```bash
lake build AlgebraicJacobian.Picard.Pic0CriticalPath
```

If Face needs intervention, split its right square proof at lines 141–160 and left square proof at lines 165–184 into separately cached modules; leave the final `conjugateAlgHom_face_of_squares` application at lines 185–199 in Face.

If compilation reaches `gluingOverlapIso_pre_snd` and stalls, avoid another `apply`/`exact`/`simpa` rewrite: six such variants already failed. The bounded next experiment is a tiny generic module containing an extensionality lemma with `X`, `Y`, `Z`, `W`, `f`, `g`, `[HasPullback f g]`, and both morphisms explicit, then instantiate it using the already-built fst/snd projection theorems.
