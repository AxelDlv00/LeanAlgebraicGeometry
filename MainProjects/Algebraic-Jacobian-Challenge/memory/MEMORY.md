# Historical memory index

Iteration-era notes preserving investigation context.  File locations and
open-goal claims may be obsolete; each entry below is tagged **LIVE** or
**SUPERSEDED** as of 2026-07-27.  For current status use `horizon roadmap list
--focus AJC.jacobian` and the project inbox.

## Live

- **LIVE** — [Genus split removed → uniform Pic⁰](genus-split-removed-uniform-pic0.md)
  — 2026-06-23: `genusZeroWitness`/`positiveGenusWitness` collapsed into the uniform
  `picardJacobianWitness` (`J = Pic⁰`), and most dedicated genus-zero infrastructure
  was deleted.  The most load-bearing note here: it is what explains the 47
  superseded notes in `../analogies/`.  The dual-purpose `WeilDivisor.lean` still
  needs the bounded Route-C carve tracked by task `T13` and inbox `I-0106`; retain
  its codimension-one `PrimeDivisor`/`RationalMap.order` substrate.

- **LIVE** — [DualInverse naturality wall](dualinverse-naturality-wall.md) —
  iter-306: three naturality sorries need the absent `restrictScalarsLaxε`
  ε-`NatTrans` (mathlib has no equivalent), but `left_inv`/`right_inv` bypass it via
  `hom_ext` → per-component, closeable with existing ε-cancellation lemmas.
  Architectural, and `DualInverse.lean` is still open.

- **LIVE** — [Čech leaf-2 reduced to FlatBaseChange frontier](cech-leaf2-reduced-to-flatbasechange.md)
  — iter-304: leaf-2 plumbing is axiom-clean; the whole residual is the cosimplicial
  iso `e`, i.e. `FlatBaseChange.lean`'s still-open pushforward base-change iso.  Also
  records the reusable `.X i` defeq/`erw` trick for alternating-complex
  `isoOfComponents`.  Still true — `cechComplex_baseChange_iso` remains open.

## Superseded

- **SUPERSEDED** — [D3′ split landed](d3-split-landed.md) — a refactor progress log
  (line numbers, "build GREEN 8627 jobs").  Every concrete claim is now stale: the
  build is 8,723 jobs, and `PullbackTensorComp.lean` no longer exists — that tail
  now lives in `Picard/TensorObjSubstrate/PullbackTensorIso.lean` and
  `PullbackTensorMapIso.lean`.

- **SUPERSEDED** — [iter-225 blueprint audit findings](ts225-blueprint-audit.md) —
  both action items are executed: the dual infrastructure was built, and the pin
  inconsistency it flagged is resolved in favour of
  `Scheme.RationalMap.extend_to_av` (9 hits), while the old
  `rationalMap_to_av_extends` has zero hits anywhere in the tree.
