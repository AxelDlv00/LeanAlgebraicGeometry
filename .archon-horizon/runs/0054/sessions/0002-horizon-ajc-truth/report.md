I've completed the work and left the task status unset so it returns to the queue. Final report:

## Summary

Established the project's real axiom frontier as a reproducible artifact, wired the headline theorem to the infrastructure that is supposed to support it, and re-aimed blueprint, roadmap, hgraph and docs at the Milne–Kollár route the Lean tree actually pursues. A fresh-context review caught me overstating my own central result; that correction is committed too.

The substantive finding: "sorry-free" was being claimed on evidence that cannot detect the leak. `#print axioms` on a theorem that *quantifies over* a sorry-bodied gate reports clean axioms, because the caller discharges the hypothesis. `Pic0.geometricallyIrreducible`, `.isSeparated` and `.locallyOfFiniteType` are all clean as stated and all pick up `sorryAx` the moment a call site must synthesise `HasPicScheme`. The probe measures this with `leakProbe_*`/`leakControl_*` pairs — identical conclusions and proof terms, differing only in whether Lean runs `instHasPicScheme`.

## Progress

- `scripts/axiom-frontier.lean`: new; 60 declarations, ~12s warm, zero errors. Covers the headline, both sorry-bodied instances, the Picard/Pic⁰/cohomology/Riemann-Roch/Albanese keystones, and both sibling teams' claims.
- `AlgebraicJacobian/Jacobian.lean`: `picardJacobianWitness` no longer a bare `sorry`; built from `Scheme.Pic0Scheme C`. Headline reachability 8 → 96 modules. Three named leaves replace the opaque sorry.
- `AlgebraicJacobian.lean`: five previously unrooted modules added; project went 164 → 170 reachable of 172.
- `blueprint/.../Picard_FGAPicRepresentability.tex`: names both routes and both rational-point formulations; new `rem:smooth_proper_quotient_hypothesis` grounds the route choice in the Hironaka counterexample.
- `blueprint/.../Jacobian.tex`: witness proof split into three lemmas matching the Lean leaves; six false `\leanok` removed.
- `blueprint/.../Picard_Pic0AbelianVariety.tex`: `\leanok` removed from `thm:pic0_smooth`/`thm:pic0_proper`, which claimed formalized over `sorry` bodies.
- `README.md`, `TO_USER.md`, `informal/pic-representability-campaign.md`: route of record, the axiom caveat, the open decision.
- Roadmap `AJC.picrep{,.quot,.serre,.assembly}`, `AJC.jacobian.reachability`; three hgraph node comments.

Verification: `lake build AlgebraicJacobian` green, 8728 jobs, exit 0. Blueprint PDF 616 pages, zero undefined references.

## Issues

- **I corrected a wrong claim of my own.** I first wrote that four witness fields were "the landed theorems"; `Pic0.smooth` and `Pic0.proper` are themselves `sorry`-bodied, so the witness rests on **five** obligations, not three. My own probe output had already printed this. Fixed in five artifacts.
- **Leaf A is false as stated.** `hasRationalPoint_and_geometricallyIntegral` asserts a `k`-rational point, which a smooth proper geometrically integral curve need not have. It is a deliberate gap marker — but it means the cone below `picardJacobianWitness` currently rests on an inconsistent hypothesis, and the leaf must be *replaced*, never proved. Said so in the docstring and blueprint.
- `horizon graph sync --blueprint` without `--lean` emits 2261 bogus warnings (Lean side empty). With both: 33, all pre-existing. Recorded as memory.
- Inbox memory count is 11 vs advisory 10; left deliberately rather than archive a live false-belief guard, with reasoning filed.

## Why I stopped

Partly advanced, not complete — status left unset so it returns to the queue. Two things genuinely remain:

1. The root roll-up is one step short **by choice**: ajc-gate's `RigidPushforwardFiberChart` and `RigidPushforwardP1Sheaf` compile green but are untracked in the ledger, so rooting them would break a clean checkout. I backed those two imports out and flagged it. Their claim that `RigidPushforwardGate` transitively pulls them is wrong — both sit above it.
2. I-0372's rational-point decision is unmade, and I was instructed not to make it. Both branches are now recorded in five places with neither assumed.

## Next

- Add the two imports once ajc-gate commits those files.
- Split leaf A: only the rational-point half is a decision. Geometric integrality follows via `Smooth ⟹ GeometricallyReduced`, which sibling AJCR proves in mathlib generality — a portable brick, and an upstreaming candidate.
- `Pic0.smooth`/`Pic0.proper` are the two nearest unproved obligations under the headline and belong to no current task.
