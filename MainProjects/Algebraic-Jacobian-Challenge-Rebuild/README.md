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

## Acceptance review (measured 2026-08-21)

The following matrix is the acceptance boundary, measured against canonical ledger HEAD
`dd4ac3c67a0a4e6903d480eca9791ffea3c8ea3e` (run 0149, baseline
`3b3ac81f3a3cf123fb66ec9957afcaad9a702ba1`). A declaration with a `(rep : ...)` binder is
an input consumer, never an unconditional producer.

| Declaration / role | Carrier and base | Exact consumer | Root and axioms | Remaining dependency |
| --- | --- | --- | --- | --- |
| `canonicalRankOneAbelIso` (producer) | `rankOneDivisorLocus ... ≅ rankOneLocus ...` over `k` | `pic0_sepClosed_representableBy` uses it directly in `Pic0SepClosedRepresentable.lean:201,208` | Rooted through `Pic0CriticalPath` and `AlgebraicJacobian`; narrow `#print axioms`: `propext, Classical.choice, Quot.sound` | None on this edge; this is the canonical specialization, not the parameterized `(E)` consumer |
| `pic0_sepClosed_representableBy` (producer, `[IsSepClosed k]`) | `J : Over (Spec k)` and `RepresentableBy J` for `pic0TypeFunctor C` | `picRepDatumSepClosed` takes the exact `.1/.2` | Rooted via `Pic0CriticalPath`; same axiom set | Descent from the separably closed field is still required |
| `picRepDatumSepClosed` (producer, sep-closed) | `PicRepDatum k k C`, with exactly the preceding `J` and `rep` | `jacobianDataSepClosed` is `toJacobianData` on that datum | Rooted; same axiom set | No arbitrary-field producer and no Challenge consumer |
| `jacobianDataSepClosed` (producer, sep-closed) | `JacobianData C`, same `J`/`rep` plus QC | No consumer in `Challenge.lean` | Rooted; same axiom set | Must be replaced/transported by the original-field datum |
| `pic0RepresentableBy_finiteGaloisDescent` (consumer) | quotient carrier over `K`, from a finite-level `J/L` | `picRepDatum_finiteGaloisDescent`, then `jacobianData_finiteGaloisDescent` | Rooted and axiom-clean, but has `(rep : ...)` and `OrbitsInAffineOpen` | A binder-free `RepresentableBy P.gluedOver` producer and exact-carrier orbit/projectivity |
| finite-stage PicRep/JD wrappers (consumers) | `P.gluedOver` over `K`, preserving their input `rep` | No unconditional downstream consumer | Narrowly green; all bind `(rep :)` (and often `(hproj :)`) | Do not count as a producer or as the capstone |
| `pic0_representableBy` (required producer) | Original-field `C/K` | None exists at this HEAD | Absent, hence unrooted | Universal finite-stage/Yoneda representation, then orbit/projectivity |
| `Challenge.Jacobian` (statement boundary) | Standalone `C` | No `JacobianData` handoff | Root-imported at `AlgebraicJacobian.lean:168`, but `#print axioms` includes `sorryAx` | Wire the same original-field datum without creating an import cycle |

### Run 0149 classification

From baseline through `dd4ac3c67a`, there are 262 ledger commits: 118 touch Lean and 144 are
metadata/churn. The exhaustive Lean-touching classification is **0 acceptance edges closed,
80 consumed direct prerequisites, 10 conditional downstream consumers, 11 compile/performance
splits, and 17 metadata/churn**; including the 144 non-Lean commits gives 161 metadata/churn.
The conditional set is `0feb6f0, da36a03, 5ee5a7f, 7d861b2, 50453c8, 9ea2b87, eb16127,
3914ddc, 4490448, c23dfeb`. The performance set is `bc7ee92, 11ef35, 1f320ae, 5be243c,
d0260ae, 17a00fb, 335af85, beac527, fe860d9, b7ddc93, 5adee30`. The latest
`dd4ac3c67a` theorem, `exists_finSubext_relPic_tensorStage_finite`, is one of the 80
consumed finite-stage feeders; it is not an endpoint. Reverted/quarantined attempts and
root-only import/check commits remain metadata, not acceptance evidence. A fresh narrow Lake
check shows that `dd4ac3c67a` does not elaborate: the call to the single-class helper leaves
`IsAffineHom (?m i)` stuck, and the LSP path inserted `sorryAx`. The single-class helper itself
has only the standard three axioms. Thus this consumed feeder is not kernel-clean evidence.

### Organization and convergence

At exact HEAD, the Rebuild import graph has 1,143 local modules and 3,105 local edges; the
library root reaches 1,109, leaving 34 unrooted. The graph is syntactically acyclic. The
critical unrooted cone is `GlueDataFace -> PreSnd -> OverlapIsoSnd -> GluedComparison`;
the top `GlueDataFace`, `PreSnd`, `OverlapIsoSnd`, and `GluedComparison` artifacts are absent
from the current native cache. `Pic0CriticalPath.lean` is itself rooted, but its 86 direct
imports and 1,109 lines make it an index, not proof of root certification. The ten-file
PreSnd split is primarily a compile-performance choice; it is a correctness risk only while
the composition is unrooted. The older DivSchemeRedesign family and other one-lemma files
outside the root are unconsumed routes, not progress toward the headline.

The strategy converges through the canonical rank-one -> separably closed representer ->
same-carrier sep-closed datum. It does **not** yet converge at the requested arbitrary-field
acceptance chain. Stop adding `(rep :)` wrappers, further rank-one refinements, unconsumed
DivScheme fragments, root-only checks, and cosmetic file consolidation.

The next package signatures, in dependency order, are:

1. `pic0RepresentableBy_finiteStageGlue (P : Pic0FiniteStageGluePackage Ck F) ... : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver`, with explicit `Ck`/base-change compatibility and a natural `homEquiv`/`homEquiv_comp`, and no `(rep :)` binder.
2. `pic0FiniteStage_isProjective (P : Pic0FiniteStageGluePackage Ck F) ... : P.gluedMap.IsProjective` (or the exact-carrier `FiniteInAffine` theorem), so the existing orbit lemma applies to that same carrier.
3. `pic0_representableBy (C : Over (Spec K)) ... : Sigma J, (pic0TypeFunctor C).RepresentableBy J`, immediately followed by `PicRepDatum`/`JacobianData` projections from the same `J` and `rep`, then a Challenge handoff.

The next checkpoint is a fresh narrow/native check of the four-module glue cone, root reach and
`#print axioms`, followed by a committed binder-free producer and the same-carrier capstone.
The active lane's uncommitted `Pic0FiniteStageUniversalClass.lean` is intentionally not counted.

## Sources

The shared workspace-root [`references/`](../../references/) library (indexed by
`references/manifest.yaml`) backs the blueprint. Read a source before citing it with `\source{...}`.

## How to build

```bash
lake build           # compile (olean cache shared via ../../.lake-packages)
```
