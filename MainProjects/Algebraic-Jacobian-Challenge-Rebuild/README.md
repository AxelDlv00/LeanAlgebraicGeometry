# AlgebraicJacobian (rebuild)

<!-- archon:readme -->

## Project

A **from-scratch rebuild** of the Lean 4 + Mathlib formalization of the **Jacobian of a smooth,
proper, geometrically irreducible curve** over a field (Christian Merten's AI challenge, inspired by
Kevin Buzzard's Riemann-surface version). By a smooth curve we mean a geometrically irreducible,
smooth scheme of relative dimension one over a field.

This project supplies the missing definitions (`genus`, `Jacobian`, the Abel–Jacobi map `ofCurve`)
and theorems (the Jacobian is smooth of relative dimension equal to the genus, proper, geometrically
irreducible, and is the Albanese variety of the curve, characterized by the universal property
`exists_unique_ofCurve_comp`). It targets the **extended** challenge: additionally, the Jacobian is
**functorial** in the curve (`Jacobian.functor`) and **commutes with base change of fields**
(`baseChangeIso` with identity and cocycle coherences, and Abel–Jacobi compatibility
`baseChange_ofCurve`), which makes the construction canonical.

It is rebuilt rather than continued: the goal is a cleaner, more general, mathlib-idiomatic
infrastructure and a shorter, clearer path to the conclusion. The existing project
`MainProjects/Algebraic-Jacobian-Challenge` may be **read** when genuinely blocked, but nothing is
copied from it — every declaration is rewritten. The rebuild is driven by its Archon Horizon task,
which carries the full charter (target, constraints, working model, and phases).

## Structure

- `AlgebraicJacobian/Challenge.lean` — the single, reviewable **statement file**: every signature a
  reviewer must trust, and nothing else. Agents own the proofs, never these signatures.
- `AlgebraicJacobian/` — the infrastructure that discharges the statement (added as the rebuild
  proceeds; the 500-line-per-file house rule and its current over-limit set are tracked and
  re-measured in inbox `I-0220`; layout mirrors the mathematical structure of the paper).
- `AlgebraicJacobian.lean` — the library root import list, and the index of what is actually
  checked: `lake build`'s default target is this module, so a new file is **not** elaborated by a
  bare `lake build` until it is imported here. Add the import, or check the file explicitly by
  module name. Reachability is a moving target while parallel lanes add files and imports:
  measure it **transitively** from the current root rather than quoting a stale count. See roadmap
  row `AJCR.w4-rep.build-reach` for the triaged list, and check the root before trusting a "landed"
  claim.
- `informal/` — 79 design worksheets, brick specs, and recon dumps (~32k lines). **Start from
  [`informal/README.md`](informal/README.md)**, which says what each file is for and which are
  superseded; several are pinned to routes that have since been abandoned.
- `blueprint/` — a clean **mathematical** blueprint (no Lean code in the prose; nodes carry `\lean{}`
  and `\source{}` anchors). Build with `leanblueprint pdf` / `leanblueprint web`.
- `archon-protected.yaml` — the mathematician-owned signatures agents must not modify.

## Acceptance review (measured 2026-08-22)

The following matrix is the acceptance boundary, measured against implementation HEAD
`340206c19ec68bebc9e7878472d0168849f190d0` (run 0149 implementation checkpoint, baseline
`3b3ac81f3a3cf123fb66ec9957afcaad9a702ba1`). The canonical ledger has a review-only
metadata tail through `16b35b635b` after this implementation delta; that tail does not
change the implementation source evidence. Review metadata from this session now reaches
`00b70eb221`; run 0149 session 0104 is active and has not landed a newer committed source
delta.
A declaration with a `(rep : ...)` binder is
an input consumer, never an unconditional producer.

| Declaration / role | Carrier and base | Exact consumer | Root and axioms | Remaining dependency |
| --- | --- | --- | --- | --- |
| `canonicalRankOneAbelIso` (producer) | `rankOneDivisorLocus ... ≅ rankOneLocus ...` over `k` | `pic0_sepClosed_representableBy` uses it directly in `Pic0SepClosedRepresentable.lean:201,208` | Source-rooted through `Pic0CriticalPath` and `AlgebraicJacobian`; narrow `#print axioms`: `propext, Classical.choice, Quot.sound` | None on this edge; this is the canonical specialization, not the parameterized `(E)` consumer |
| `pic0_sepClosed_representableBy` (producer, `[IsSepClosed k]`) | `J : Over (Spec k)` and `RepresentableBy J` for `pic0TypeFunctor C` | `picRepDatumSepClosed` takes the exact `.1/.2` | Source-rooted; narrow probe gives the same axiom set, but a fresh critical-root import is blocked at `GluePackage.olean` | Descent from the separably closed field is still required |
| `picRepDatumSepClosed` (producer, sep-closed) | `PicRepDatum k k C`, with exactly the preceding `J` and `rep` | `jacobianDataSepClosed` is `toJacobianData` on that datum | Source-rooted; narrow probe gives the same axiom set | No arbitrary-field producer and no Challenge consumer |
| `jacobianDataSepClosed` (producer, sep-closed) | `JacobianData C`, same `J`/`rep` plus QC | No consumer in `Challenge.lean` | Source-rooted; narrow probe gives the same axiom set | Must be replaced/transported by the original-field datum |
| `pic0RepresentableBy_finiteGaloisDescent` (consumer) | quotient carrier over `K`, from a finite-level `J/L` | `picRepDatum_finiteGaloisDescent`, then `jacobianData_finiteGaloisDescent` | Source-rooted and narrow-axiom-clean, but has `(rep : ...)` and `OrbitsInAffineOpen` | A binder-free `RepresentableBy P.gluedOver` producer and exact-carrier orbit/projectivity |
| finite-stage PicRep/JD wrappers (consumers) | `P.gluedOver` over `K`, preserving their input `rep` | No unconditional downstream consumer | Narrowly green; all bind `(rep :)` (and often `(hproj :)`) | Do not count as a producer or as the capstone |
| `pic0_representableBy` (required producer) | Original-field `C/K` | None exists at this HEAD | Absent, hence unrooted | Universal finite-stage/Yoneda representation, then orbit/projectivity |
| `Challenge.Jacobian` (statement boundary) | Standalone `C` | No `JacobianData` handoff | Root-imported at `AlgebraicJacobian.lean:168`, but `#print axioms` includes `sorryAx` | Wire the same original-field datum without creating an import cycle |

### Run 0149 classification

From baseline through implementation HEAD `340206c19e`, there are 266 commits: 120 touch
Lean and 146 are metadata/churn. The exhaustive classification is **0 acceptance edges closed, 82 consumed
direct prerequisites, 10 conditional downstream consumers, 11 compile/performance splits, and
163 metadata/churn**. Subsequent review-only commits are excluded from this substantive count.
The two newest consumed prerequisites are `7fabbbdedd` (the universal
finite-atlas class package) and `340206c19e` (the explicit-argument repair of the finite-family
common-stage helper).
The conditional set is `0feb6f0, da36a03, 5ee5a7f, 7d861b2, 50453c8, 9ea2b87, eb16127,
3914ddc, 4490448, c23dfeb`. The performance set is `bc7ee92, 11ef35, 1f320ae, 5be243c,
d0260ae, 17a00fb, 335af85, beac527, fe860d9, b7ddc93, 5adee30`. The
`exists_finSubext_relPic_tensorStage_finite` theorem is a finite-stage feeder, not an endpoint.
The initial `dd4ac3c67a` version failed at `IsAffineHom (?m i)`; `340206c19e` supplies explicit
arguments and algebra instances. Fresh Lake plus independent compiled probes now report only
`propext, Classical.choice, Quot.sound`. Reverted/quarantined attempts and root-only
import/check commits remain metadata, not acceptance evidence.

### Organization and convergence

The last canonical source-root measurement (at the implementation checkpoint) has 1,143 local
modules and 3,105 local edges; the
library root reaches 1,109, leaving 34 unrooted, with no syntactic import cycle. The
critical cone is `GlueDataFace -> PreSnd -> OverlapIsoSnd -> GluedComparison`.
A current hgraph cache reports 12,995 nodes / 5,548 edges for Rebuild (752 stale nodes) and
9,483 / 6,804 for the sibling AJC (281 stale nodes); those generated counts are not a fresh
Lean-root measurement. The graph labels many glue declarations `lean_ok`, but a narrow
`import AlgebraicJacobian.Picard.Pic0CriticalPath` currently stops at the missing
`Pic0FiniteStageGluePackage.olean`. The cache has `GlueDataFace.olean`,
`GlueDataAssembly.olean`, and the active continuation has additionally produced
`Pic0FiniteStageTransitionModels.olean` and `Pic0FiniteStageTripleTransitionModels.olean`.
Its tracked `+GluePackage:olean` attempt reached 9361/9370 before the 1800-second cap
(exit 124); `GluePackage`, top `PreSnd`, `OverlapIsoSnd`, and `GluedComparison` artifacts
are absent. `Pic0CriticalPath.lean` is 1,120 lines with 87
imports, over the 500-line house rule (I-0220 tracks 27 over-limit files); this is
organization/compile risk, not an acceptance edge. The ten-file PreSnd split is primarily a
compile-performance choice. The older DivSchemeRedesign family and other one-lemma files
outside the root are unconsumed routes, not progress toward the headline.

The strategy converges through the canonical rank-one -> separably closed representer ->
same-carrier sep-closed datum. It does **not** yet converge at the requested arbitrary-field
acceptance chain. Stop adding `(rep :)` wrappers, further rank-one refinements, unconsumed
DivScheme fragments, root-only checks, and cosmetic file consolidation.

The next package signatures, in dependency order, are:

1. `pic0RepresentableBy_finiteStageGlue (P : Pic0FiniteStageGluePackage Ck F) ... : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver`, with explicit `Ck`/base-change compatibility and a natural `homEquiv`/`homEquiv_comp`, and no `(rep :)` binder.
2. `pic0FiniteStage_isProjective (P : Pic0FiniteStageGluePackage Ck F) ... : P.gluedMap.IsProjective` (or the exact-carrier `FiniteInAffine` theorem), so the existing orbit lemma applies to that same carrier.
3. `pic0_representableBy (C : Over (Spec K)) ... : Sigma J, (pic0TypeFunctor C).RepresentableBy J`, immediately followed by `PicRepDatum`/`JacobianData` projections from the same `J` and `rep`, then a Challenge handoff.

The measured ledger range through `16b35b635b` is 282 commits; the 16-commit tail is review,
dashboard, and run-lifecycle metadata, not a new acceptance edge. Subsequent review commits
through `00b70eb221` likewise add no implementation edge. The active 0149 continuation
has scratch compiler work but no newer committed source delta. The next checkpoint is a fresh
narrow/native check of the four-module glue cone, root reach and `#print axioms`, followed by a
committed binder-free producer and the same-carrier capstone.
`Pic0FiniteStageUniversalClass.lean` is committed in `7fabbbdedd` and remains a consumed
universal-class prerequisite, not a `RepresentableBy` producer.

### Current implementation checkpoint (2026-09-02)

The stabilized finite-stage cone now exports the verified affine, gluing, pinned-chart, and
global structure-map projections (`affineBaseChangeIso_hom_structureMap`,
`baseChangeGluingIso_hom_p2`, `chartRingBaseChangeIso_hom_structureMap`, and
`finiteStageBaseChangeIso_hom_structureMap`). The latter promotes the glued comparison to an
isomorphism in `Over (Spec k)`. `Pic0FiniteStageBaseChangedRepresentable.lean` consequently
provides `finiteStageBaseChangeOverIso` and the binder-free
`pic0RepresentableBy_finiteStageBaseChange` for the scalar extension of a finite-stage glued
object to the separably closed field. This is a post-base-change result, not the required
`pic0RepresentableBy_finiteStageGlue` over the field of definition: descent of the universal
Picard class and its Yoneda equivalence on the same carrier is still absent, followed by the
finite-in-affine/Galois and original-field `PicRepDatum`/`JacobianData` handoff to `Challenge`.
The companion `Pic0FiniteStageStableGeometry.lean` now exports unconditional stable-package
`locallyOfFiniteType_gluedMap` and `quasiCompact_gluedMap` instances; it supplies the geometric
inputs for later descent but does not itself prove orbit affineness or projectivity.

## Sources

The shared workspace-root [`references/`](../../references/) library (indexed by
`references/manifest.yaml`) backs the blueprint. Read a source before citing it with `\source{...}`.

## How to build

```bash
lake build           # compile (olean cache shared via ../../.lake-packages)
```
