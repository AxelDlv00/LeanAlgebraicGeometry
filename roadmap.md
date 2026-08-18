# Lean Algebraic Geometry Roadmap

This file is the concise public view. The structured Horizon roadmap is authoritative:

```bash
horizon roadmap list --max-depth 1
horizon roadmap list --focus AJCR.review-plan
```

The workspace has two registered main projects. Material under `SubProjects/` is supporting or
historical infrastructure, not a separate roadmap portfolio.

## Workspace Priorities

| Project | Status | Objective |
| --- | --- | --- |
| `Algebraic-Jacobian-Challenge-Rebuild` | active | Complete the reviewer-driven rank-one and finite-Galois route to `pic0_representableBy`, then construct `JacobianData`. |
| `Algebraic-Jacobian-Challenge` | pending | Maintain the companion Picard-scheme route and provide reusable descent and geometric infrastructure. |

## AJCR Current Route

The current route replaces the older Wave 4-7 plan. Completed foundations remain available in
the codebase, but new work is organized only by the following phases.

| Phase | Status | Deliverable |
| --- | --- | --- |
| 0 | done | Pinned baseline, critical root, route guard, and reproducible audits. |
| 1 | done | Endgame contracts, canonical curve spelling, and anti-vacuity harnesses. |
| 2 | done | Arbitrary-degree divisor representability spine, capped behind stable interfaces. |
| 3 | done | Public rank-one Picard and divisor loci with unconditional openness. |
| 4 | done | Canonical family-level rank-one Abel isomorphism on arbitrary tests. |
| 5 | done | Translated rank-one cover over a separably closed field. |
| 6 | done | Kernel-checked representability of `Pic^0` over the separable closure. |
| 7 | active | Descend the representative and universal Picard equivalence to the original field. |
| 8 | pending | Build the final Jacobian package and discharge the protected challenge statements. |

### Phase 7: Finite-Galois Descent

| Item | Status |
| --- | --- |
| Finite-stage affine atlas and `Scheme.GlueData` | done |
| Global glued-scheme base-change isomorphism | active |
| Universal Picard element and natural-equivalence descent | pending |
| Original-field filtered-colimit bridge for `Pic^0` | pending |
| Stable affine cover via orbit containment or quasi-projectivity | pending |
| Assemble and consume `pic0_representableBy` | pending |

### Phase 8: Jacobian Capstone

| Item | Status |
| --- | --- |
| Reuse the pinned `JacobianData` and representation interfaces | done |
| Construct the original-field `PicRepDatum` | pending |
| Instantiate the geometric properties of the representing scheme | pending |
| Complete Abel-Jacobi and the universal mapping property | pending |
| Complete functoriality, field base change, and cocycle coherence | pending |
| Verify the critical root, full builds, axioms, and protected headlines | pending |

## AJC Companion Route

The companion project retains its own structured roadmap at `AJC.jacobian`. Its completed
cohomology, Picard, graded, and descent infrastructure may be consumed by AJCR, but it is not
split into separate workspace subprojects on this board.

## Completion Standard

A roadmap item is `done` only when its declaration is root-reachable, consumed by the next public
interface, kernel-checked, axiom-audited, and covered by the relevant full build. Drafts,
root-unreachable wrappers, and hypothesis-shifted substitutes do not receive endpoint credit.
