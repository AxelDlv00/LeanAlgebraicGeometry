# Recommendations — next plan iter (post-iter-077)

## CRITICAL — verify prover infra before any proving assumptions
- The config fix (`roles.prover` fable→opus) did NOT make the prover run in iter-077: `prover.durationSecs:0`, `parallel.jsonl` = `failed:3`, `logs/iter-077/provers/` EMPTY. Same instant-death fingerprint as iters 068–076.
- Most likely the prover role is resolved at iter-START, so the fix takes effect iter-078. **Do not assume it works** — after iter-078's prover phase, check `logs/iter-078/provers/*.jsonl` exist and `meta.json prover.durationSecs > 0`.
- **If iter-078 STILL shows `durationSecs:0` / empty `provers/` on opus:** the fable role was not the (sole) cause; the failure is in the prover-dispatch path itself. Surface to user (TO_USER already flags this) — no further prover dispatches will land value until resolved. Do NOT keep re-dispatching prove lanes into a broken pipe.

## HIGH — fix tensorPowAdd scaffold strategy comment before SNAP prove lane
`SectionGradedRing.lean` (lean-auditor snap-scaffold, 2 MAJOR — comment defects, plan/scaffolder-owned):
- L1649: `(toPresheaf L)` is wrong Lean. `PresheafOfModules.toPresheaf` = ab-group forgetful functor; correct is `(toPresheafOfModules X).obj L`. A prover copying the comment will misfire.
- Step (b) (left-whisker) construction is undescribed — it needs the same shape as step (d); the comment omits it. Either re-dispatch `lean-scaffolder snap-tensor2` to repair the comment, or have the plan agent patch it directly.
- `tensorObjAssoc` (L1604) is clean; minor caveat — no `isIso_sheafification_whiskerLeft_unit` exists, so segment-3 must go via braiding-conjugation (only path).

## READY-to-prove (HARD GATE cleared this iter; send the moment prover infra is confirmed live)
- **GlueDescent.lean** — `Picard_GlueDescent.tex` complete+correct. 2 sorries: L1170 (`glueOverlapBaseChangeIso` pushforwardCongr component) + L1207 (`isIso_glueRestrictionHom` body, explicit inverse via η/pushforward/β⁻¹, (C1)/(C2) triangles). Detailed sketches in-chapter.
- **GrassmannianQuot.lean** — `Picard_GrassmannianQuot.tex` +6 Nitsure §5 inverse blocks now cover sorries L2066/L2147/L2160/L2249. Complete+correct (fastpath).
- **SectionGradedRing.lean** — `tensorObjAssoc`, `tensorPowAdd` scaffolded (fix comment first, above).

## MEDIUM
- **SNAP `sectionMul_coherent` (`lem:sectionMul_coherent`, frontier-ready)** — scaffolder SKIPPED it: blocked on a PUBLIC `moduleUnit`; only `private unitModule` exists. Plan agent should arrange a public unit (rename/expose) before scaffolding/proving this. Tracked since iter-067.
- **QuotScheme `representable`** — blueprint-reviewer iter077 flagged as under-delivering (must-fix correctness, non-blocking). Queue a blueprint-writer pass on `Picard_QuotScheme.tex` when a writer slot frees.

## Coverage debt (LOW, standing — not new this iter)
- `archon dag-query unmatched` = 104 `lean_aux` nodes, all proved/no-sorry, all pre-existing prover helpers (iters ~060–067) with no blueprint entry. None created this iter (no prover ran). The planner should schedule blueprint back-fill (one chapter or an aux-appendix) for the largest clusters (`AlgebraicGeometry.Grassmannian.*`, `Scheme.Modules.uTensorEquiv*`). Re-run the query for the live list; do not block proving on this.

## Do NOT
- Do not treat iters 068–077 as evidence about the MATH (no prover ran in any of them). The GR/SNAP/GlueDescent routes have NOT been falsified — they are simply un-attempted since iter-067.
- Do not re-dispatch a strategy-critic / progress-critic purely on the 068–077 window — zero trajectory data there.
