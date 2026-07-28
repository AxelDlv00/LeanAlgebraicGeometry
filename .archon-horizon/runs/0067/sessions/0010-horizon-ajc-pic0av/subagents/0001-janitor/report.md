Delivering the report now, at ~32 minutes.

## 1. Yes — these warnings were already triaged today, including by run 0067 itself

Both roadmap mismatches have been triaged repeatedly. Do not commission a sixth pass.

**AJC.jacobian.assembly** — triaged eight times (I-0411, now archived). Verdict every time: `done` would be wrong. I re-measured rather than trusting it. `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` carries three `sorry` terms at lines **820, 1102, 1332**; 1102 sits inside `geometricallyReduced` (:1096) which `smooth` (:1254) consumes, and 1332 inside `universallyClosed` (:1326) which `proper_of_universallyClosed` (:1295) consumes. The witness is genuinely unpackaged. The row summary already says the mismatch is deliberate.

**AJC.picrep** — triaged five times in thread I-0538 (C-0001..C-0004 plus a reply). **Run 0067, your own lane, wrote C-0004 at 09:53** and it is the sharpest analysis in the thread. It was escalated to you as **I-0605** and is waiting on you, not on a janitor.

I-0556's warning was accurate: the dispatch fans one janitor per lane at the same warning.

## 2. What I changed on the roadmap

I did not touch either status, because per I-0543 the `AJC.picrep` `done` was never a decision — it propagated automatically from task `ajc-etale-pic`'s terminal status into all four of its `roadmap_refs` at 06:04:16, and that task is now `done` and cannot answer. Reopening or rejecting rows is a route decision.

What was in scope was a **false claim** in the `AJC.picrep` summary: it still read "THE RATIONAL POINT REMAINS AN OPEN HUMAN DECISION (I-0372) ... both routes carry it identically." Protection I-0491 closed I-0372 and `hasRationalPoint_of_curve` was deleted as false. I replaced that with the correct state and appended a DO-NOT-RE-TRIAGE block recording the converged split (`.quot`/`.serre` self-describe as off-path so want `rejected`/re-parenting; `.tensor` alone is evidence the parent is premature) and pointing at I-0605. Read back from disk: 3412 chars, landed.

`AJC.jacobian.assembly` needed no edit — its summary already documents the deliberate mismatch and enumerates the obligations correctly.

## 3. Root cause of the "janitor did not return" pattern

`horizon inbox comment` **hard-rejects bodies over 1200 characters**, exit 2, and the error prints as the last line after ~25 lines of banner and synchronizer digest. Any caller that pipes to `tail`, `head`, or `>/dev/null` sees a success-shaped banner. I lost a comment to it and caught it only by listing the comments directory.

This explains four items that sat open while their own comments announced closure — one for eight hours across two lanes. The reading was janitor carelessness; it is wrong. A long triage comment is exactly what trips the cap, so the note and the follow-up died together. Filed as **I-0612** [persistent], with evidence added to **I-0609** (as C-0002, within cap).

## 4. Archived: 5 items, each verified at HEAD first

- **I-0546** — no `--strategy` flag exists (`roadmap set --help` shows only `--summary`/`--summary-file`); I-0579 carries the defect.
- **I-0577**, **I-0590** — `git ls-tree -r HEAD` returns **zero** probe/scratch paths; AJC `.gitignore:26-27` carry `*Probe*.lean` and `/scratch_*.lean`.
- **I-0578** — `TO_USER.md:37-42` now says `pullback_preservesFiniteLimits` "is *not* proved" and "still reports `sorryAx`"; the false claim is gone.
- **I-0564** — superseded by I-0604; successor lemmas confirmed at `Picard/Pic0ChartTwistSplit.lean`.

Each read back from the on-disk `status:` field.

## 5. A binding human protection is invisible to the lanes it binds

Reconciling the counts exposed something worse than backlog. The warning counts **99** open items on disk; `inbox list --status open` returns **78** for my lane (**not** pagination — `--limit 500` still returns 78). The 21 invisible ones split as 8 AJCR-scoped, 7 `audience=human`, 2 empty, 4 task-addressed.

Among them: **protection I-0492**, `[persistent] HUMAN DECISION, BINDING (2026-07-28)` on DivFamZar, status open, author human — absent from both `inbox list --kind protection` and the REQUIRED-protections digest. The differentiator is `scope.projects` (I-0491 → AJC, I-0492 → AJCR); the YAML is otherwise identical. The digest announces "2 active protections", not "2 of 3 visible to you", so an AJCR lane bound by I-0492 has no way to learn it exists. That is I-0505's finding with the mechanism named. Filed as **I-0610** with two asks.

## 6. Counts

| | Start | End |
|---|---|---|
| Open non-protection (disk) | 96 | 98 |
| Open memory | 50 | 51 |
| Roadmap active | 18 | 18 |

I archived 5 and 7 arrived from other lanes mid-pass (I-0606..I-0612, five of them mine or filed while I worked). **The number went up, and at eight live lanes that is arithmetic, not failure** — I-0552's measurement reproduced exactly.

**Residual left deliberately:** the 18 active roadmap rows are correct — `horizon ps` shows eight live runs, and the rows are ancestor spines plus the leaves those lanes hold (I-0509). The memory cap of 10 is unreachable when eight fresh-context lanes are *designed* to produce findings; what survives is mostly `[persistent]` and distinct. `task list` emits no warnings; no orphaned `running` task. Protections I-0491, I-0074, I-0492 untouched. No Lean file edited, no subagents spawned.

**The two things needing you, not a janitor:** I-0605 (the picrep route decision) and I-0610 (the hidden protection — a correctness issue, not tidiness).
