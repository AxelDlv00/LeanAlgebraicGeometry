## 1. Roadmap subtree `AJCR.w4-rep`

`horizon roadmap list --focus AJCR.w4-rep` returns 72 items (43 `done`, 6 `active`, 15 `pending`, 5 `blocked`, 3 `rejected`). Full per-item status/title dump is reproducible from `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.w4-rep*.yaml`.

**CLI warnings printed:** exactly one — `⚠ Roadmap has 10 active items (recommended maximum 8)`. **No parent/child disagreement warning is emitted by the CLI**, but disagreements exist:

- `AJCR.w4-rep.datum.dat-d.ddr.certificate` is **`blocked`** while 8 of its 18 children are `done` (`away-assemble`, `chart-avoid`, `chart-trace`, `confine-open`, `field-size`, `pull-transport`, `sep-nogo`, `zar-gate`).
- `AJCR.w4-rep.datum.dat-c` is `pending` while its child `c9-chartlocus` is `active`.
- `field-size` is `done` but its **title still reads** "the one remaining human decision" and its milestone is still `w4-gate` (`AJCR.w4-rep.datum.dat-d.ddr.certificate.field-size.yaml:1-8`). Body was rewritten 2026-07-26 to "ANSWERED… not a human decision after all"; the title was not.

**Done items with zero recorded evidence (empty `summary`, no pins):** `dat-d.dd4`, `dat0`, `dat2`, `dat3`, `rigid.re0`–`re5` — 10 of 43.

**Done items whose evidence I could corroborate as rooted Lean** (decl found, module reachable from `AlgebraicJacobian.lean`): `chart-trace` (`Picard/DivSchemeCertZarChartTrace.lean:80,106`, `DivSchemeCertZarSwallow.lean:156`, `DivSchemeCertZarC1.lean:123,131` — note the summary transliterates `chart₀`→`chart0`, so a literal grep of the roadmap text fails), `confine-open`, `sep-nogo`, `pull-transport`, `away-assemble`, `zar-gate`, `divrep.sep` (`Picard/DivRepClassifyZarSep.lean:352`), `c9a` (`Pic0ChartLocusClass.lean:123`), `dat-a`, `dat-p`, `dat1`, `dat4`, `dat5`, `dd1`.

**Done items whose evidence is in modules that are NOT in the build** (independently recomputed import closure from `AlgebraicJacobian.lean`: **624 modules on disk, 530 rooted, 94 unrooted** — corroborates `build-reach`'s 620/526/93 up to round-5 additions):

| item | claimed endpoint | module | rooted? |
|---|---|---|---|
| `...ddr.rdn` (done) | `pointwiseGeneratorSeed` / `isGenerator_pointwiseGeneratorSeed` | `Picard/DivSchemeSeedUnivPointwiseGenerator.lean:258,274` | **no** |
| `...ddr.coefficient-saturation` (done) | `exists_divUniversalHighWindowShiftedRelationTransitionOfLE_mem_relation_of_mem_readIdeal` | `Picard/DivSchemeHighWindowTransitionSaturation.lean:424` | **no** |
| `...ddr.quotient-bridge` (done) | `chartReadIdeal` | `Picard/DivSchemeRedesignChartReadIdeal.lean:75` + `DivSchemeHighWindowQuotientBridge` | **no** |
| `...ddr.koszul-flatness` (done) | named modules `…RelationKoszulConjugacy`, `…FibreModelInduction` | — | **no** |
| `...ddr.seed-fibre-models` (done) | `DivSchemeHighWindowFibreModelBase` | — | **no** |
| `...ddr.hw-foundation` (done) | `…H1`, `…Stage`, `…FibreWindow` | H1/Stage rooted; **FibreWindow not** | mixed |
| `...ddr.relation-tower`, `...ddr.fibre-koszul` (done) | no module named at all; the `DivSchemeHighWindowRelation*` / `Pencil*` families | — | **no** (38 of 94 unrooted are `DivSchemeHighWindow*`) |

So **7–8 of 43 `done` rows rest entirely on never-kernel-checked code**, and the `active` parent `...dat-d.ddr` repeats those claims verbatim in its summary. This is exactly what `build-reach` and open issue **I-0361** already state; my independent recount confirms it rather than adding to it.

## 2. The four requested items

Full YAML was read; key facts:

- **`AJCR.w4-rep.yaml`** (93 lines, `status: active`, `updated_at 2026-07-26T06:45`): a ~2.5 kB narrative summary framing 14 links L1–L14. Self-flagging: "TRUST CORRECTION AFFECTING EVERY ROW HERE. 93 of the tree's 619 modules … are NEVER kernel-checked" (`:62-66`); "MODULE DOCSTRINGS IN THIS TREE ANNOUNCE THEOREMS THE FILES DO NOT DECLARE, and roadmap rows have asserted the ABSENCE of declarations that exist" (`:77-79`). **Not updated by round 5**, so L2 is still recorded as "MISSING" and L9 as "exists but UNROOTED" — both now stale (see below). No comments added this round.
- **`dat-j.yaml`** (22 lines, `status: pending`, `milestone: w4-tail`, `author: ground`): 2-sentence summary — "DJ-0 compact-image qc is landed. DJ-1 Abel-image qc, DJ-2 JacobianData packaging, and the frozen Jacobian declarations remain gated on DAT-G/divRep." No pins, no comments, `updated_at 2026-07-26T06:43`. Round 5's `JacobianDataCharts.lean` work is DJ-2 territory and is **not reflected here**.
- **`...ddr.divrep.lift.yaml`** (58 lines, `status: active`, `priority: high`, provenance run 0048 session 0011 **round 4**, `updated_at 2026-07-26T16:48`). Target is `DivRepGlobalData.ofAffine`. **Verified: no `ofAffine` declaration exists anywhere in the tree.** `DivRepGlobalData` is at `Picard/DivRepKit.lean:68`. The forward half `pullGlobal` now exists at `Picard/DivRepGlobalLift.lean:102` (rooted, imported at `AlgebraicJacobian.lean:420`); `pullGlobal_classifyGlobal`/`classifyGlobal_pullGlobal` are at `Picard/DivRepGlobalClassify.lean:249,266` which is **unrooted and uncommitted** (mtime 07-27 00:52, after the last commit at 00:48).
- **`AJCR.build-reach` does not exist**; the id is **`AJCR.w4-rep.build-reach`** (150 lines, `status: pending`, `priority: high`, `kind: workspace`, pins `0b3ab49b8`, `b72270288`). It is the most evidence-dense row in the subtree and it is the one that *contradicts* the done rows above. Its own claim "DivRepKit … ANOTHER LANE OWNS IT AND IS ROOTING IT" is now satisfied — DivRepKit is rooted.

## 3. Commit `009637d06` — status inflation?

**It is not AJCR work.** Trailers: `Archon-Run: 0046`, `Archon-Session: 0086-horizon-ajc-optimize`, `Archon-Task: ajc-optimize`, `Archon-Projects: Algebraic-Jacobian-Challenge`. It touches only `AJC.*` items in the **sibling** project, nothing under `AJCR.w4-rep`.

Diff: **29 new item YAMLs + 29 history jsonl, 908 insertions, 0 deletions.** No existing item was modified.

Statuses actually set: **28 `done` + 1 `pending`** (`AJC.rr.principal`). The commit subject says "30 done sub-items" — **off by two**.

Evidence check on the claim "All 120 module paths named in the new summaries exist, and none of them is one of the 11 modules that still carry a `sorry` (24 in total)":

- 120 distinct paths cited; **119 resolve to real modules**, the 1 failure (`RiemannRoch/Adelic`) is a directory prefix in prose, not a module reference.
- **All 119 are rooted** in AJC (AJC has 165 modules, 165 rooted, 0 unrooted — unlike AJCR).
- Independent recount of real (comment-stripped) `sorry` tokens in AJC: **exactly 11 modules, 24 sorries** — the commit's numbers are exact.
- Exactly one cited module carries a sorry (`RiemannRoch/WeilDivisor.lean`), and it is cited by **`AJC.rr.principal`, which the commit correctly left `pending`, not `done`.**

**Verdict: not status inflation.** Every checkable assertion in the commit message holds. Two caveats: (a) the subject line count "30" is wrong; (b) `sorry`-freedom is not the same as verified — 33 of 164 AJC modules currently have no `.olean` under `.lake/build/lib/lean` (including `Picard/RigidPushforward.lean`, `ChartSectionsFinite.lean`, `SemicontinuityH0.lean`, `P1SectionsFinite.lean`, all cited by the `done` row `AJC.picrep.rigidpushforward`). Run 0046's import-hygiene campaign (`64e7bdabb`) is live and rewriting imports, so this is plausibly an in-flight rebuild rather than a stale-artifact problem; I did not run `lake build` to settle it.

## 4. `horizon task show ajcr-w4-rep-free` and round history

Status: **`running`** (session 0014 = round 5, started 2026-07-26T16:23, still live). `roadmap_refs` = `AJCR.w4-rep` + four certificate leaves (two of which, `tube-fibre` and `away-kerspan`, are now `rejected`/`blocked`); `inbox_refs` = `[I-0320]`.

`.archon-horizon/tasks/history/ajcr-w4-rep-free.jsonl` has **27 lines and contains no round content** — it is purely status transitions. **14 of them are `Horizon session ended without the agent recording a terminal status; returned to queued`**; no round has ever recorded a terminal status. The round-by-round content lives in `.archon-horizon/runs/0048/sessions/*/report.md`.

Round map (`meta.json` `round` field): 0002=r0, 0004=r1, 0006=r2, 0008=r3, 0011=r4, 0014=r5.

- **r0** (0002): 5 new sorry-free rooted files; proved `IsCertified` is unsatisfiable for a connected divisor meeting both charts. Escalated I-0333 to human. Cost $96.
- **r1** (0004): `DivSchemeCertZarConfine.lean`; `chart-avoid` answered NO. Report itself says "I ran an adversarial pass on my own conclusions and it overturned my positive half." Cost $72.
- **r2** (0006): 991 lines new Lean, 9 commits, full build green. Report states verbatim: **"The ground review's verdict was 'circling', and I think it is right on the strategy"**. Also self-reports "Zero of `Challenge.lean`'s fifteen sorries are closed." Cost $73.
- **r3** (0008): `report.md` contains only `You've hit your session limit · resets 1:30am`. One subagent. No report.
- **r4** (0011): `report.md` contains only `You've hit your session limit · resets 7:10pm`. **No written report exists for round 4.** Work did land in-session (7 recon subagents; commits `553321044`, `1e4ac5b52`, `ceba48264`, `d7e8348ce`, `8340df1ed`; created `divrep.lift` at 06:35). Cost $144 — the most expensive round, with no report. Its own finding I-0363: "7 recon agents… **21 of 21 refuters overturned something**… the recon read a moving tree."

**Answer to the specific question: no. The "circling" verdict is round 2's, from the `ground` subagent** at `runs/0048/sessions/0006-horizon-ajcr-w4-rep-free/subagents/0004-ground/report.md:3`: *"Circling — and now circling in a way that looks like progress, which is worse… the number of gates closed toward `Challenge.lean:99` is zero, same as run 0047 rounds 1–5."*

Rounds 3, 4 and 5 ran **no `ground` and no `work-reviewer` subagent at all** (r3: one `claude`; r4: 7 general-purpose + 1 blueprint; r5 so far: `claude`, `Explore`, `claude`). The circling verdict has not been re-tested since round 2.

## 5. Inbox — open items relevant to w4-rep

364 items total; **35 open** (20 issue, 13 memory, 1 hint, 1 protection). Open and directly bearing on representability, all still unaddressed:

- **I-0361** (issue) — unrooted code under load-bearing claims; names `...dat-d.ddr` explicitly. Corroborated above.
- **I-0362** (memory) — "a new module with no importer looks green and is invisible… it happened INSIDE run 0048." **Still happening: `DivRepGlobalClassify.lean` and `Pic0AtlasFromDivRep.lean` are on disk (07-27 00:52/00:54), unrooted, and uncommitted.**
- **I-0333** (issue, `--to human`, 3 comments) — the design decision on `IsCertified`. Round 1 answered `chart-avoid`; the item is still open.
- **I-0346** (issue) — field-size human question. Roadmap leaf `field-size` was flipped to `done` ("not a human decision after all") but **I-0346 was never closed**.
- **I-0349 / I-0354** (memory) — docstrings and worksheet-pinned names are not evidence.
- **I-0351, I-0352, I-0353, I-0355, I-0356, I-0357** — the six round-2 ground/work-reviewer findings. **All six still `open`, updated 2026-07-25T17:14–15, untouched by rounds 3–5.** I-0355 ("the divRep gate is mis-stated in three ways") and I-0356 ("the chart-avoid counterexample is off-stratum") were both partly actioned in text (`field-size` body, ADDENDUM 4) but the items were left open.
- **I-0348 / I-0359** — `Pic0ThetaCocycle.lean` has no build artifacts and hit 34.1 GB RSS at 4:58 without finishing; it holds the only real sorry outside `Challenge.lean`, and `w7-k1-worksheet.md` is ratified against it.
- **I-0363** (issue) — round-4 recon net result; explicitly says the seven front reports "are NOT reliable on their own."
- **I-0318** — Rebuild cannot be hgraph-synced; combined with build-reach's 626 `lean_ok` nodes over unrooted files.

## Bottom line

- `Challenge.lean:99` is still `sorry` (15 sorries in `Challenge.lean`, 36 in the project). Zero gates closed across rounds 0–4, matching the round-2 ground verdict.
- The single largest honesty defect in `AJCR.w4-rep` is **not** commit `009637d06` (which is a different project, and whose every checkable claim verified). It is that ~8 `done` DD-R rows and the `active` `...dat-d.ddr` summary rest on modules `lake build` never elaborates — already filed as I-0361 and `AJCR.w4-rep.build-reach`, both still open/pending.
- Second defect: `AJCR.w4-rep`'s master summary and `dat-j` are stale as of round 5. L9 is now rooted (`DivRepGlobalLift.lean`, `AlgebraicJacobian.lean:420`) and L2 has a conditional producer (`JacobianData.ofCharts`, `Picard/JacobianDataCharts.lean:182`); `fa61add70` records this in `informal/w4-rep-critical-path.md` but **no roadmap row was updated**. There is still no unconditional `jacobianData C` (grep for `def jacobianData` is empty) — `ofCharts` consumes the chart family `(f, hf)` whose leaf `c9b` is `blocked`.
- Live hygiene problem: the shared index has `MainProjects/…/Picard/JacobianDataCharts.lean` staged as **`D` (deletion)** while the file exists on disk — the same dirty-shared-index failure the round-0 report reported fixing.
