# Iter-018 plan — recover the noop-lost iter-017 prover phase; dispatch 4 parallel lanes

## Entering state (verified)

**iter-017's prover phase never ran.** `logs/iter-017/meta.json` shows
`planValidate.status = "failed_all_noop"`, `objectivesDispatched = 0`, with both proposed lanes
(`CechBridge.lean`, `FreePresheafComplex.lean`) in `objectivesNoop`. Root cause (confirmed by
reading `sorry_count.py`): the noop filter drops any objective naming an *existing* `.lean` file with
*zero* open sorries unless the objective line bearing the `.lean` path also contains a scaffold
keyword. iter-017's lines said "build, bottom-up" (no keyword) → both dropped → no provers, no review.

So no Lean code changed since iter-016's prover phase. What iter-017 DID land (all intact): the Ab
reconciliation, the `def:cover_structure_presheaf` O_𝒰 block, the L1 redesign to the section-complex
form (`def:qcoh_sections_localized` + `lem:section_cech_homology_exact` + re-signed
`lem:cech_acyclic_affine`), the `CechBridge.lean` skeleton, and `blueprint-reviewer iter017`'s
whole-blueprint HARD-GATE clear (all 3 chapters complete+correct, 0 must-fix).

Ground truth this iter: `CechAcyclic.lean` 1 sorry (line 109, old relative-form `CechAcyclic.affine`);
`FreePresheafComplex.lean` 0 sorries (skeleton + `cechFreePresheafComplex`); `CechBridge.lean` 0
sorries (skeleton); `HigherDirectImagePresheaf.lean` does not exist. `CechAcyclic.lean` does NOT
import `PresheafCech.lean` (where `sectionCechComplex` lives); nothing imports `CechAcyclic.lean`
(so re-signing it is downstream-safe).

## Decision made

### D1 — Re-dispatch the 2 noop-lost P3b lanes + open P3 (L1) + P5a = 4 parallel lanes, keyword-fixed.
- **Why 4 lanes**: the standing parallelism directive; all four are blueprint-gate-clear (the
  consolidated chapter, cleared by `blueprint-reviewer iter017`) and mutually independent files.
  Lanes 1–2 (FreePresheafComplex quasiIso, CechBridge hom-id) are the immediate frontier that
  unblocks `injective_cech_acyclic` → the whole P3b bridge. Lane 3 (P3 L1) is the STUCK route's
  structural corrective. Lane 4 (P5a 01XJ leaf) is P3/P3b-independent and route-confirmed.
- **The keyword fix** (the load-bearing change): every zero-sorry / new-file lane's first physical
  line (the one with the `.lean` path) now carries `does not yet exist`, which the noop regex
  matches. I verified all 4 lanes are KEPT by re-running `filter_noop_objectives` against the actual
  PROGRESS.md (FreePresheafComplex/CechBridge/HigherDirectImagePresheaf exempt via keyword;
  CechAcyclic kept because it has a sorry). This is what iter-017 missed.
- **Why P3 is NOT a churning re-run** (the progress-critic's iter-017 STUCK route): the corrective the
  critic mandated — a Mathlib API consult — was done in iter-017 (`mathlib-analogist l1bridge`),
  returned NOT-FEASIBLE-as-one-lane, and DROVE the Q4 redesign (re-sign to the absolute section
  complex + decompose L1 into `qcohSectionsAwayLocalized` + `sectionCech_homology_exact`). Lane 3 is
  the execution of that structural redesign — a new statement, new sub-decls, a new import — not
  another helper round on the old relative-form wall. This is exactly the sanctioned response to STUCK.
- **Why no refactor subagent for the P3 re-sign**: CechAcyclic.lean already carries a sorry, so the
  lane is dispatchable as-is (no noop risk), and the new section-complex signatures are intricate
  (`sectionCechComplex` wants a `PresheafOfModules`; the quasi-coherent `F` is a `(Spec R).Modules`).
  A mathlib-build prover with LSP is better positioned to get those signatures right while building
  bottom-up than a refactor agent inserting a guessed signature. The prover adds the import itself.
- **Cheapest reversal signal**: if a lane's prover reports the build-new-decl target is mis-specified
  (signature can't typecheck against the existing complexes), next iter re-scopes that one lane; the
  other three are independent and unaffected.

### Q4 re-sign validated (strategy-critic iter018: SOUND)
The Q4 decision (re-sign `cech_acyclic_affine` from the relative pushforward complex to the absolute
`sectionCechComplex`) was made in iter-017 *without* a strategy-critic pass and is load-bearing, so I
dispatched a fresh-context strategy-critic this iter. Verdict **SOUND**, confirmed line-for-line
against the Stacks sources: (a) the standard-cover Čech-vanishing lemma is itself absolute (no `f`,
no pushforward) and proved by localise-at-prime + contracting homotopy — the relative form genuinely
cannot take this route; (b) 02KG→01EO consumes the absolute `Č•(𝒰,F)`, no gap; (c) the separate P5a
supply of relative acyclicity (via 01XJ + absolute 02KG) is the canonical minimal decomposition, and
the "simpler" affine-pushforward-exactness shortcut is a mirage (it sits downstream of 02KG in Stacks).
0 CHALLENGE/REJECT. Its one must-fix (STRATEGY.md format DRIFTED — per-iter narrative leaked into
table cells and Routes/Open-questions prose) is cleared this iter: stripped all `iter-NNN` refs and
"DONE/EXECUTING/pending next iter" tenses, compressed the grown cells (`grep` confirms 0 leaks).

## Subagent skips

- blueprint-reviewer: HARD GATE freshly cleared by `blueprint-reviewer iter017` (all 3 chapters
  complete+correct, 0 must-fix) and NO chapter prose edited since — this iter only added a
  `% archon:covers HigherDirectImagePresheaf.lean` metadata line (the P5a leaf block it covers was
  already audited complete+correct). All 4 active lanes map to the already-cleared consolidated chapter.
- progress-critic: the prior iter (017) ran NO prover phase (plan-validate `failed_all_noop`) — there
  is no new trajectory data to assess. The still-live iter-017 P3 STUCK verdict is being acted on this
  iter via the structural redesign (section-complex re-sign + L1 decomposition), not another helper round.
- blueprint-clean: no blueprint prose edited this iter (only a covers metadata line); nothing to clean.

## Notes for next iter
- Coverage debt: lanes will create new helpers (currently `unmatched` debt = 0). Bundle the new
  helpers into the relevant `\lean{...}` lists next iter.
- If lane 3 leaves the `qcohSectionsAwayLocalized` 01I8 globalisation gap open, that is the genuine
  Mathlib brick (`QCoh(Spec R) ≃ Mod R`) — keep it as the explicit next mathlib-build sub-step, not a
  bare deferred sorry.
