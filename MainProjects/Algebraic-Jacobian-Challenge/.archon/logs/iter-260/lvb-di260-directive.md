# lean-vs-blueprint-checker directive — iter-260 — DualInverse

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(consolidated chapter; declares `% archon:covers` for this file. The relevant
labels are around `dual_restrict_iso` / `sliceDualTransport`.)

## What changed this iter
The prover reduced `sliceDualTransport` by one step
(`refine LinearEquiv.toModuleIso ?_`) but then determined route-(1) (consume the
shared-root `restrictOverIso`/`unitOverIso`) is STRUCTURALLY INSUFFICIENT: those
are sheaf-object isos of `restrict`/`unit` that say nothing about `dual`/internal
hom, whereas the reduced goal's content is that the dual commutes with slice
reindexing — which would need the deliberately-avoided `MonoidalClosed`
structure. Typed `sorry`s retained (2→2). The prover recommends route-(2): a
sectionwise build (leg A `homLocalSection`-style reindexing across
`f.opensFunctor` ∘ leg B `restrictScalarsRingIsoDualEquiv`).

## Report
- blueprint → Lean: does the chapter's `dual_restrict_iso` / `sliceDualTransport`
  sketch still claim route-(1) (shared-root consumer) works? If so, that prose is
  now WRONG and the chapter must be updated to the route-(2) sectionwise build —
  flag as MUST-FIX with the specific lines.
- Lean → blueprint: is the chapter detailed enough to guide a route-(2) build, or
  is it too thin (missing the leg-A reindexing / leg-B ring-iso-dual decomposition)?
- Flag any `\lean{...}` name mismatches.
