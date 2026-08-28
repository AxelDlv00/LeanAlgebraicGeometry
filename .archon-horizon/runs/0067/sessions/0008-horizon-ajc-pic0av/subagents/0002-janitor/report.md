Hygiene pass done.

## The dispatch trigger: already answered, do not re-triage

Per I-0556, I checked whether an equivalent pass had already run. It had, three times over — and the trigger you were given is one of the warnings that memory item exists to stop.

- **Roadmap active count (18 active / max 8)** — answered by I-0509, five separate derivations of the same verdict. I re-ran only the liveness precondition: `horizon ps` shows eight lanes holding live pids, so the premise still holds. No re-derivation, no demotions.
- **Inbox non-protection count (was 67 at your dispatch, 50 when I started)** — answered by I-0551. The count is below the fleet's arrival rate, not a backlog.
- **This lane specifically** had already dispatched janitors in sessions 0004 and 0006 of run 0067. I read both reports and built on them rather than restarting.

## Archived (6, all with a self-explaining rationale comment)

| id | kind | why |
|---|---|---|
| I-0539 | issue | into I-0565, which says in its own title that it supersedes this item's "what is missing" list; two of its three missing declarations have landed |
| I-0534 | issue | `ClassDegreePinned` (IdentityComponent.lean:1550) + the acceptance test at :1581 are the exact characterisation it demanded; false docstrings gone |
| I-0498 | memory | into I-0567, which **refutes its own recommendation** — it said an upstream PR was the only cheap route; the "private" proof was transcribed verbatim into `Picard/GroupSchemeSmoothAlgClosed.lean`, 0 sorries |
| I-0512 | memory | its load-bearing claim ("`IsCompatible` has no producer") is now false — `IsChartClause.isCompatible` landed; successor is I-0560 |
| I-0549 | issue | `permAut_swap_ne_id` (SymPowColimit.lean:304) makes its central worry a *checked* statement; `hproj` is now `colimit.w`, free at every n |
| I-0568 | issue | reproducer returned 0 staged deletions — **but see the correction below** |

## One thing I got wrong, and corrected in the same pass

I archived I-0568 on a single zero reading of the staged-deletion count. It re-armed minutes later with `RiemannRoch/Ledger/GenusBridge.lean`, exactly as the newly-arrived I-0572 says it does — the condition is per CAS commit, not per session. I left it archived (I-0572 is the open successor; reopening would give two rows for one condition) and recorded the method rule: **a zero on a re-arming condition is indistinguishable from a fix.** Archive against a change in the mechanism, not the count.

## Roadmap: both mismatches deliberately left

Neither is drift, and both were already documented. What I added is one thing no prior pass checked:

- **`AJC.jacobian.assembly`** — verified the assembly is still genuinely open (`Jacobian.lean:48-70` still lists the same five obligations; `Picard/Pic0Et.lean` still carries sorries at :175 and :228). `done` would be false. The concrete fix (add the five obligations as child rows) has now been proposed by two lanes and deferred by three passes; I declined it too and named why so a fourth pass need not re-derive it: **the row has no `owner` field, so "whoever holds the headline" is not a resolvable address.**
- **`AJC.picrep`** — I read the three pending children's own summaries, and they split across two different resolutions: `.quot` and `.serre` both say *"OFF-PATH, retained not revived… not of the committed Milne–Kollár route"*, which per thread I-0538's own text argues for `rejected`/re-parented; only `.tensor` supports reopening the parent. So it is not one verdict over three rows. Route decision, left to an owner.

## Fixed directly

- `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md` (committed `ee71aa306`) — the module denominator was **210; the tree is 252**. Re-measured with a comment-stripping census: AJC is 28 terms in 11 of 252, bare-`import Mathlib` is 89 of 252 not 81 of 210, and the Rebuild is 16 not 17 (`DivRepAffPullClause.lean` is now sorry-free).
- `/home/axel/LeanAlgebraicGeometry-Horizon/.claude/skills/horizon/SKILL.md` — told sessions to keep "status/strategy" current, but `roadmap set` has **no `--strategy` flag**. That wording is what sent a lane to a non-existent option. Not committable: `.claude/` is untracked in the ledger.
- Removed two probe comments I accidentally left on I-0538 while testing CLI behaviour, and replaced one with the real finding.

## Filed, not fixed

- **I-0577** (new) — eight `*Probe*.lean` axiom-probe scratch files are **committed** at the AJC project root, outside any `lean_lib` target, so they are permanently unelaborated files that look like source. `.gitignore` covers no such pattern. `git rm` on another lane's tracked files is outside my write set. The ajc-fbc lane has already replied correcting the ninth file's provenance.
- **I-0546** — its primary claim does not reproduce: `roadmap set --strategy` exits **2** and applies nothing. Likely a stdout/stderr misread, the same confusion I-0482 C-0001 corrected once before. Left open for the doc half, which I then fixed.
- **I-0531** — reproduced with three `lake env lean` probes. Confirmed shadowing, and **both files are already co-rooted in `AlgebraicJacobian.lean`**, which the item understates. But co-importing does *not* error — contrast I-0576, where the same collision class hard-failed. The silent symptom is the dangerous one, and it means I-0576's proposed pre-port scan cannot rely on the root build failing.
- **I-0533** — confirmed still present: `free_of_cyclic_mod_eps` has zero consumers and neither file is imported by `Pic0AbelianVariety.lean`, while its prose still claims clauses (i)/(ii) closed.

## Counts

| | before | after |
|---|---|---|
| CLI open non-protection | 50 | 55 |
| CLI open memory | 28 | 32 |
| store open (all) | 72 | 74 |

Six archived, and the number went **up**. Nine items arrived from four lanes during the pass (I-0567 through I-0576). That is I-0509's arrival-rate rule reproducing for the seventh time: at eight live lanes a hygiene pass makes the count go up. The caps are not reachable while the fleet runs at this width, and the honest report line is that both warnings are intentional. Left standing deliberately.
