Pass complete. Everything verified on disk.

## The three warnings

**All three are covered by standing answers that still hold. I re-measured, did not re-litigate.**

1. **Inbox 127 open / 92 non-protection** — I-0641 and I-0509 apply unchanged. 8 live lanes, no lane hoarding. I applied I-0625's test (grep the open set for a live instance) to every memory item matching SUPERSEDED/RETRACTED/DUPLICATE: **all seven matches are rules *about* retraction with live instances today** — one of them, I-0656, I acted on during this very pass. Archiving any of them would have destroyed load-bearing rules. Net change: **127 → 124 non-protection** via three `complete`s, all conversations whose residual action I discharged first.

2. **Task queue 13** — I-0648 is exact and still correct. 8 `running` matches the 8 live pids one-for-one; the 5 `queued` are 2 charters (`T16`, `rebuild`) plus `ajc-truth`, `ajcr-w4-rep-free` (refs the active `AJCR.w4-rep`), `ajc-optimize`. **13 is still the right number.**

3. **Roadmap 18 active** — liveness cross gives **9 held directly by live lanes + 9 active ancestors of those, zero orphans**. One apparent leftover, `AJC.fbc`, has an empty `owner` field but is held by the live `ajc-fbc` lane through `roadmap_refs`. Owner-field-only triage would have wrongly demoted it.

## What I changed

Docs only, all in my lane's project, all verified on disk:

- `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/informal/w5-t4-worksheet.md` — three retractions moved to where the claims live (§6.22's SUPERSEDED-IN-PART box, its two withdrawn closing claims struck in place, §6.14's "`Algebra k[ε] k` does not exist" and its invented diamond reason). These were the open residual actions of I-0664 and I-0634. Net +13 lines, additive.
- `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/README.md` — root-reachability figures re-measured: 710/70 → **711/71** (38 `DivSchemeHighWindow` still correct). The other three numbers in that README (78 worksheets, ~29k lines, 19 over-limit files) verified exact.
- Inbox: completed **I-0664**, **I-0634**, **I-0662** (verified fixed at HEAD by `ajcr-charts`), each with a comment saying what discharged it. Delta comment on **I-0638** rather than a new item.

## One live hazard caught and repaired

While re-verifying my worksheet edit, `diff HEAD -- <path>` went from `21 8` to **empty**. My lane had committed at `edd4d9af4` in between, and the shared index then held the pre-edit blob: `diff --cached` showed `8 21`, and blob-level `show HEAD:<path>` had 3 markers against `show :<path>` with **0**. That is I-0656's armed condition — the next `write-tree` would have reverted all three retractions. Cleared with `reset -q HEAD -- <path>`; index-vs-HEAD now empty, disk untouched, markers intact. Recorded on I-0656 as the third confirmation, with the added tell: a diff that *was* non-empty and is now empty means either "someone committed it" or "the index ate it", and one `--cached` diff separates them. `grep` of the disk stayed happy throughout and would not have caught it.

## Your two specific checks

4. **Staged deletions: clean.** Zero `^D` in the ledger repo (`.archon-horizon/vcs/workspace.git`), and zero unstaged deletions too. The workspace root `.git` shows only untracked entries; the project has no repo of its own. Nothing to repair, no other lane's paths involved.

5. **Your three rows are all present with their summaries.** `AJCR.w5-av.t4` active (4088 chars), `.t5` active (1161), `.t3` pending (1966), parent `AJCR.w5-av` pending (3238). **No child contradicts its parent.** The parent is `pending` with 10 done / 3 pending / 2 active / 1 blocked children, which is coherent. I re-read t4's summary against worksheet §6.23: its "T4 STILL OWES" list already carries the post-retraction shape (scheme-object identifications **plus** (iii-c2-aff-geo) = two named statements), so the row did not need editing — only the worksheet did.

## What survives, and why

- **All three count warnings still fire** (92 non-protection, 59 memory, 13 tasks, 18 active). They are structural at an 8-wide fleet, per the standing answers. Shrinking them further costs live findings.
- **The CLI's count and `inbox list` disagree** (127 vs 94). Not a bug in either: the warning counts the whole store, `list` filters by audience/scope, so 33 items addressed to other lanes' tasks or scoped to the sibling project are invisible to my read path. This is I-0482's divergence; worth knowing before anyone tries to reconcile the two numbers.
- **Two structural roadmap warnings remain**, both `Algebraic-Jacobian-Challenge` rows: `AJC.picrep` done with `.tensor` pending (narrowed from three children — `.quot`/`.serre` are now `rejected`), and `AJC.jacobian.assembly` pending with its only child done. Both need real adjudication about deliverables I don't own, so I filed on I-0638 rather than guessing.
- **I-0665 and I-0630 left open deliberately** — both name residual gaps at (3) that are genuinely unclosed, not consumed.
- One uncommitted doc change remains on disk (`README.md`, 2/2); your worksheet edits are already committed at `edd4d9af4`.
