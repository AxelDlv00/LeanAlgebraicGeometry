# iter-077 review — capstone NOT closed; 2-lane split mis-converged; no verified sorry closed

## Overall Progress
- Verified inline sorries: **1 → 1** (no net change). Frozen `cech_computes_higherDirectImage` (CHDI:780) remains a documented `sorry` by design.
- Solved (verified): **0**. Partial: 1 (`isQuasicoherent_pullback_opens`, closed but unverified). Blocked: 2 (capstone seam; frozen CHDI:780).
- Two prover-touched files; **neither is verified to compile**. `CechToHigherDirectImage.lean` is **definitively broken** (ill-typed line 207). `CechTermAcyclic.lean` green claim is unverified (stale oleans) and contested (auditor: 2 type-direction bugs).
- Prover builds: 0. Review-build verification impossible: **2 GB review sandbox** (cannot cold-build Mathlib — unlike iter-076's 512 GiB env). `sync_leanok` iter=77 sha 24c070e +0/−0.

## What happened
The iter-077 plan dispatched 2 PARALLEL lanes on the correct sibling `…_of_affineCover` while the DEEP lane was *simultaneously changing a shared public signature*:
- DEEP lane correctly found `cechTerm_pushforward_acyclic`'s planned signature is **mathematically false** (needs `[S.IsSeparated]`/affine-diagonal-of-S + an `hres` `HasInjectiveResolutions` family; doubled-origin counterexample) and amended it.
- Assembly lane was written against the OLD signature ⇒ its call (`:207`) is ill-typed (missing `hres`, missing `[S.IsSeparated]` instance). The capstone's own signature is therefore also incomplete.
- Result: the lanes do not fit; the capstone is not closed.

## Subagent findings (read reports for detail)
- `lean-auditor-iter077` — BLOCKED, 4 must-fix: `CechTermAcyclic:99` extraneous `.symm` (`isRightAcyclic_of_iso`, wrong iso direction); `CechTermAcyclic:668` missing `.symm` (`pushPullObj_opens_pushforward_acyclic`); `CechToHDI:207` missing explicit `hres`; `CechToHDI:197` missing `[S.IsSeparated]`. +1 major (RestrictOverBridge ~210 LOC dup of QcohRestrictBasicOpen, write-domain-forced), 3 minor.
- `lean-vs-blueprint-checker-cechterm` — must-fix: `lem:cech_term_pushforward_acyclic` blueprint statement FALSE (omits the 3 hyps); + bridge/`higherDirectImage_affineHom_acyclic` coverage debt; misleading `\uses`.
- `lean-vs-blueprint-checker-cechtohdi` — must-fix: line-207 ill-typed; blueprint statement omits `[S.IsSeparated]`; `hres` undocumented; `PProd` note.

## Markers (manual)
- Added `% NOTE:` to `lem:cech_term_pushforward_acyclic`, `lem:cech_computes_cohomology_affineCover` (both statements FALSE/incomplete without `[S.IsSeparated]`+`hres`), and `lem:cechAugmented_to_acyclicResolutionInput` (`PProd` not `Prod`).
- **No `\leanok` overrides** — nothing is verifiably complete; sync correctly left the new decls unmarked.

## Coverage debt
- `archon dag-query unmatched` = 29 `lean_aux` (28 in CechTermAcyclic, 1 in CechToHDI) → listed in `session_77/recommendations.md`. gaps=0; blueprint-doctor clean.

## Hand-off
Sequence next iter: (1) independent full build of `CechTermAcyclic.lean` to settle the 2 auditor bugs + confirm signature; (2) amend capstone signature + line-207 call ([S.IsSeparated]+hres); (3) align blueprint statements; (4) THEN re-dispatch the assembly prover. Do NOT parallelise a producer mid-signature-change with its consumer again. Frozen CHDI:780 stays user-owned (do not dispatch).

## Subagent skips
- (none — both highly-recommended review subagents dispatched: lean-auditor + lean-vs-blueprint-checker ×2.)
