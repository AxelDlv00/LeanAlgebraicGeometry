# Orientation — AJCR.picard (rebuild étale-plus lane)

- Useful context: brick 3 (Kleiman 2.5(1) projection step) landed and is Ground-verified — `Over.prPullback_injective` in `Picard/Separatedness.lean`, plus the reusable `CechPic.mk_eq_one_iff`/`mk_injective` (`Picard/RefinementInjectivity.lean`). Axiom-clean (`propext, Classical.choice, Quot.sound`), full build green (8568 jobs), blueprint `sec:Separatedness I` (12 nodes, all `\leanok`, keystone carries `\source{kleiman-picard}`).

- Next actionable piece per the design (`informal/wave3-picard-design.md` §4.4 "Item-5 plan"): the dictionary `(Spec R).CechPic ≃* CommRing.Pic R` — mathlib `CommRing.Pic`/`Pic.mk_eq_iff`/`mk_eq_one_iff` confirmed present in `.lake-packages/mathlib/Mathlib/RingTheory/PicardGroup.lean`, so only the Čech↔module direction and descent-datum extraction are project-side. Then the (C1) assembly, then the Zariski-sheaf-on-affines corollary and Layer-2 `picEt` (file 12, per the 13→12 lane order).

- Consistency note: the highest-value open core for `AJCR.picard` remains Layer-2 `picEt` over `Over (Spec k)`, gated on the sheaf-on-affines corollary of (C1) (`I-0140`) — not yet attempted; the descent-datum extraction from the cocycle-level lift is flagged in the design as the genuinely delicate step, worth budgeting a full session for.

- Environment: `AJCR.picard` is `active`; `AJCR.jacobian` north star (`Challenge.lean`) is still a `⟨sorry⟩` scaffold. Pre-existing hygiene only — `show`-linter warnings in `Pic.lean`/`RelPic.lean`; leandag shows the new nodes as "isolated" because proof-level `\uses` don't create edges in this workspace (engine behavior, not a blueprint bug).
