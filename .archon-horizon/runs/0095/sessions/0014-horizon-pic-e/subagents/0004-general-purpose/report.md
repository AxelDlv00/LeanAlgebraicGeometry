The `janitor` address isn't reachable from this session, so I'll return the condensed findings here instead.

# Documentation audit (read-only, nothing edited)

Everything below re-measured 2026-07-31. "Ledger HEAD" = `main` in `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git`, the repo that actually tracks project sources.

## 1. Broken links/paths: none

All relative links resolve in all five docs (26 targets checked in the AJC README, 8 in the Rebuild README, 12 in the workspace README). All cited inbox ids, roadmap row ids, and the four cited commit shas exist.

## 2. Claimed vs actual

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md`
- :36 heading "measured 2026-07-30" vs bullets saying 2026-07-31
- :38 "361 modules, 191,855 lines" → **362 modules, 192,446 lines**
- :61-63 "357 of 361 in the root cone" → **358 of 362** (the named set of 4 unrooted modules is correct, and all 4 are at ledger HEAD)
- :218-220 "proof-level, 1073 pinned declarations across 1078 marks" → **1102 across 1107**; "statement-level, 1560 across 1567" → **1579 across 1586** (ran the script's own step-1 extractor). The "do not delete those 34" instruction is pinned to a superseded domain.
- :244 "RiemannRoch/Ledger/ (56 files)" → **64**
- :247 "Partly rooted (37 of 56); the remaining 19 are outside the root cone" → **62 of 64 rooted, 2 unrooted**. Contradicts the same file's :60-67. Same line says "see inbox I-0600" while :65 says I-0600 is closed (confirmed archived).

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/TO_USER.md`
- :30-31 "probes 162 declarations, 108 clean and 54 carrying sorryAx" → probe now carries **215** `#print axioms` lines
- :47 "the tree's 28 sorry carriers" → **26** (zero are instances, so that part holds)
- :76-77 "reaches 98 project modules" → **141 of 362** (same stale 98/187 in `scripts/axiom-frontier.lean`'s header)
- :78-79 "Pic0.smooth and Pic0.proper are still sorry" → **false at HEAD**; `Pic0AbelianVariety.lean:1287` and `:1551` both carry real proof terms, the sorries moved to `geometricallyReduced`/`universallyClosed`. The AJC README :151-152 already states the corrected reading.

`/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md`
- :19 "2 of 824 library modules" → **829** (the 16 sorries and "18 root-unreachable" are exactly right)
- :19 "a further 60 sorry in tracked scratch_*/ScratchPicC files" → **62** in the 4 scratch dirs (66 incl. top-level probes); dir is `ScratchPicCR6`, not `ScratchPicC`; and they are **not tracked** — zero paths matching "cratch" exist at ledger HEAD
- :20 "31 in 13 of 374 modules" → **26 in 11** under `AlgebraicJacobian/` (31/13 only if you count 3 sorried `scripts/*.lean`); "361 modules / 191,855 lines" → **362 / 192,446**; "374 counted paths" → **375**
- :78 "69 files still consume the old DivFamZar" → **70** (the 48 `DivisorFamilyAff*` files, 21 `DivFamZarAff` mentions, and the single outside-cone `Pic0ChartHonestAff.lean` all verified exact)
- :166 "115 of 361 modules" → 115 correct, **362**
- :179 "138 warnings / 24 sorry notices" → inconsistent with the file's own sorry counts; needs a build, unverified

`/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/README.md`
- :36 "Of 824 .lean files" → **829** (the 18 unreachable and their enumeration at :37-39 are exactly right)
- :43 "79 design worksheets" → **77** `.md` worksheets (79 entries; one is a `.txt`, one is the README itself)

Verified correct, leave alone: AJC README :87 (215 probe lines) and :111 (115 bare imports); Rebuild README :31-32 (27 files over 500 lines); roadmap :174 (248 = 190 + 58 heartbeat overrides) and all six subproject sorry rows including the per-module splits at :218-227 and :242.

## 3. Stray files

Workspace root: `/home/axel/LeanAlgebraicGeometry-Horizon/rev_probe_p3h.lean`

AJC top level — 38 probe `.lean` files (`GroundProbe*.lean` ×6, `Probe3`, `Probe4`, `alb_probe1`, `p4probe`, `scratch_FbcDef`, `probe_wrrev_genphi5`, `probe_p3_hcov1-5`, `probe_p4_{action,axioms,idcomp,iso,mul,mul2}`, `rr_probe{1,2,3,_curvegen,_p1h1}`, `zz_probe_names`, `zz_wr_probe1-9`), plus the empty dir `Probe/` and `/home/axel/.../Algebraic-Jacobian-Challenge/archon/task_results/blueprint-clean-bc255.md`

Rebuild top level — `AuditProbe3.lean`, `BaseChangeIdProbe.lean`, `ExplicitIdIsoProbe.lean`, `FstSimpProbe.lean`, `ImportProbe.lean`, `Pic0IdentityMapProbe.lean`, `Pic0MIdEqProbe.lean`, `Pic0ThetaCocycleProbe.lean`, `Pic0ThetaIdMinimalProbe.lean`, `PullbackIdProbe.lean`, `probe_p4_audit.lean`, plus dirs `ScratchPicCR6/`, `scratch_p4r6/`, `scratch_p4r6_audit/`, `scratch_w7/` (84 `.lean`, 62 sorries)

Inside the Rebuild library: `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/ScratchChartLocal.lean` (Scratch-named, root-unreachable, absent from ledger HEAD) and `.../informal/ledger-index-stale-run0071-s0016.txt`

All top-level probes and scratch dirs are untracked and gitignored — local litter, not a ledger problem. Knock-on: the Rebuild `.gitignore:37-38` still instructs a lane to `git rm --cached` 83 scratch paths in HEAD; there are now zero.

One routing note: I tried to reply to `janitor` via SendMessage and the address was not reachable from this session, so the findings are here rather than delivered to that agent.
