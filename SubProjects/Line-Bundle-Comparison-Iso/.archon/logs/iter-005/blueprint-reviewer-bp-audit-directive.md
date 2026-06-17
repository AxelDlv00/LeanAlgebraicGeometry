# Blueprint Reviewer Directive

## Slug
bp-audit

## Strategy snapshot

Goal: build the comparison-isomorphism substrate on line bundles for the A.1.c.sub slice of the Jacobian challenge, with zero inline `sorry` in the dependency cones of the three seed declarations and kernel-only axioms.

Phases & estimations:

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|-------|--------|-----------|-----|-------------------|-------|
| D3′ comparison iso (`TensorObjSubstrate.lean`) | ACTIVE | ~3–5 | ~120–300 | `CategoryTheory.conjugateEquiv` (mates) + project `_whiskerLeft` helper to build; sheafification adjunction | Sq1 mate-calculus is the hard step; D4′ chart-chase after |
| DUAL dual-inverse (`DualInverse.lean`) | ACTIVE | ~3–5 | ~100–250 | `PresheafOfModules.restrictScalarsLaxε`, `leftAdjointUniq` | `dual_restrict_iso` Step-4 `isoMk` naturality chase + A-bridge glue |
| Consumer assembly (`RelPicFunctor.lean`) | BLOCKED | ~1–2 | ~30–80 | — | gated on both routes closing (`exists_tensorObj_inverse`) |

Route summary:
- D3′: comparison iso on tensor objects, centered on `sheafificationCompPullback_comp` and `pullbackTensorMap_restrict`.
- DUAL: dual inverse chain, centered on `sliceDualTransport`, `sliceDualTransportInv`, and `dual_restrict_iso`.
- Consumer: `RelPicFunctor.lean` waits on both routes and should not be treated as ready prover work yet.

## References

- `challenge.lean.ref`: original challenge statements for merge-back.
- `stacks-modules.md` -> `stacks-modules.tex`: Stacks ch.17, invertible modules / Picard group.
- `kleiman-picard.md` -> `kleiman-picard.pdf` / `-src/*.tex`: Kleiman Picard functor and sheafification route A source.
- `fga-explained.md` -> `fga-explained.pdf`: FGA Explained companion source, Kleiman Picard chapter.

## Focus areas

- `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`: audit the recent `dual_restrict_iso` / internal-hom / downstream inverse prose for correctness, completeness, and exact `\uses{...}` wiring.
- `blueprint/src/chapters/Picard_RelPicFunctor.tex`: audit the provisional-scaffolding disclaimer, the `addCommGroup` / sheafification blocks, and the downstream gating language.
- `blueprint/src/chapters/Picard_LineBundlePullback.tex`: verify the route-boundary prose and that the set-valued relative Picard chapter still matches the Lean targets.

## Known issues

- Treat `\leanok` as sync-managed only; do not flag marker churn as a manual content edit.
- The two active chapters were edited recently; check their `\uses{...}` and citation anchors closely.
- Make sure every `\mathlibok` anchor, if present, names a real Mathlib declaration and is not overstated.
