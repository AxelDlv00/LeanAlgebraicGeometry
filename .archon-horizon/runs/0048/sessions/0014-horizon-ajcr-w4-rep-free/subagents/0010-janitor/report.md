Hygiene checkpoint complete. All three warnings addressed; the roadmap one is cleared, two stand with reasons.

## Found first: a live, armed reversion

Before any hygiene work, the mandated index check was already failing. `I-0366` was real and **still armed**:

```
D  MainProjects/.../AlgebraicJacobian/Picard/JacobianDataCharts.lean
```

The file was in HEAD (275 lines) and byte-identical on disk, but absent from the shared index. Any bare `git commit` would have published the deletion and un-rooted round 5's work. I verified `diff HEAD:<path> <path>` was empty, then repaired with a **path-scoped** `reset` rather than the `read-tree HEAD` you suggested — a whole-index reset could have discarded run 0046's staging while it is live.

**It came back twice more.** That is not a lane misbehaving: the §1 CAS recipe moves the ref via `update-ref` without touching the shared index, so *every* CAS commit by *any* lane re-stales it, and `git status` reports the drift as staged changes — including staged deletions for files the commit added. I documented this as a new §1b in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/protocol-concurrent-lanes.md`, since the previous three incidents each rediscovered it. Final check: clean.

## 1. Inbox — memory 14 → 12, non-protection 34 → 33

`I-0350` and `I-0356` were **already archived** by run 0046's janitor before I started, so those two bullets were done.

| Item | Action |
|---|---|
| `I-0347` | **Corrected in the body.** Its point 4 ended "UNTRIED CHEAP OPTION: relax the partitions to a joint ⨆ pieces = top" — that is **refuted** (`joint-cover` is a `rejected` leaf). Left in comments only, it would have sent a lane down a dead route. Point 6 also updated. |
| `I-0360` | Absorbed into `I-0347` as point 7, then archived. Its one open question is answered by ADDENDUM 4. |
| `I-0357` | Reclassified `memory` → `issue` — it is uncommissioned work, not a durable fact, and should never have charged the memory cap. |
| `I-0320` | Trimmed ~60 → ~25 lines; both appended layers were restating `I-0360`. |
| `I-0346` | **Restructured, not closed.** The standing human question now leads; the answered math half and the refuted option are marked as resolved history below it. Splitting would have added an item and worsened the other warning. |
| `I-0364` | Owned to `ajc-optimize`. Note: **ownership does not reduce the advisory count.** |

**The memory warning still stands at 12, and I recommend leaving it.** Each remaining item is the sole record of a dead end costing a session to re-derive: `I-0065`/`I-0076` are "never re-add / the variance is backwards" corrections; `I-0330`/`I-0359` are measurements; `I-0349`/`I-0354`/`I-0362` are process rules that keep catching real errors; the rest are the certificate cluster. I could reach 10 only by deleting genuine records. Run 0046's janitor had independently DM'd this task (`I-0371`) asking for exactly this consolidation — I replied there with the same reasoning.

Non-protection stands at 33 because three new items (`I-0369`, `I-0370`, `I-0371`) were filed *during* this pass.

## 2. Roadmap — warning cleared, 10 → 8

**Your read was exactly right, and it is now on the record.** The 10 were: 2 `AJC.*` (untouched), plus a single nested spine `AJCR.jacobian → w4-rep → datum → dat-d → ddr → divrep → divrep.lift` where each parent was `active` only because a descendant was.

The one genuine anomaly was `AJCR.w4-rep.datum.dat-c.c9-chartlocus` — demoted to `pending`. Nothing under it was in progress or *could* be: `c9a` done, `c9b` blocked (CERT-Σ-gated), and `chart-u` cannot start because `w4-datb-worksheet.md` §1.6 co-signs it with amendments the DAT-C lane never acknowledged. Its parent `dat-c` was already `pending`.

Separately, a live lane moved `divrep.lift` to `done` during the pass, shortening the spine. Together: **8 active, warning gone.**

## 3. Status consistency — clean, with one caveat I did not touch

No `done`-parent-with-open-children and no all-children-terminal-with-open-parent anywhere in `AJCR.w4-rep`. The only flag was `c9-chartlocus`, fixed above.

**Not fixed, deliberately:** `I-0370` (filed by Ground mid-pass) reports that commit `fa61add70` rewrote worksheet §7.1 to say L2 and L9 moved, and no roadmap row was touched. That is a real mismatch but resolving it means judging mathematical claims — ambiguous, so I left it as your call.

## 4. `informal/` index — created

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/README.md` did not exist. It does now: all **76** files, one line each, grouped by wave, with `CURRENT` / `LANDED` / `SUPERSEDED-BY`. Verified mechanically — every file is covered, every reference resolves.

Your specific question is answered at the top: the DD-R authority chain is **`dat-d-worksheet.md` → `spec-dd-r.md` (+ADDENDUM 4) → `w4-ddr9-worksheet.md`**, each naming the one above as its BINDING parent. That is taken from the files' own declarations, not inferred from dates. `SUPERSEDED-BY` is recorded only where a file says so in writing; I flagged in the header that `CURRENT` means "no evidence of supersession found", not "audited line by line".

## 5. Docstring hygiene — the rule held, but found its mirror image

All three files pass `I-0349`: `JacobianDataCharts.lean` **8/8** bullets real, `DivRepGlobalClassify.lean` **3/3** plus parenthetical (including the tricky `DivRepAffinePullback.equiv` vs `DivRepGlobalData.equiv` resolution). `Curve/P1Aut.lean` exists but has no bullet list.

**The real defect is an omission.** `JacobianDataCharts.lean` lists `ofCharts` (:182) and omits `ofChartsOfCompactSpace` (:209) — which the file's own "What remains" says is the form the classical construction needs, because the classical atlas is *not* finitely indexed. That is `I-0368`'s stale "finite atlas" claim carried a second time, in Lean. Recorded on both items. I did not edit it (no `.lean` edits).

Two more, filed as comments not new items: `Curve/P1Aut.lean` is **unrooted** and contains no automorphism of ℙ¹ despite its title (added to `I-0361`, whose headline count is also stale — it is now **125** unrooted, not 93); and the project README understated that gap, which I fixed. The missing-`LICENSE` lead is a false alarm — it exists at workspace root, which is the repo root.

Committed as `afa4f417c` (three doc paths only, verified), still an ancestor of HEAD.
