The pass is done. All four roadmap warnings persist by deliberate decision, each now documented on its row.

## What I changed, each verified by read-back

**Inbox archives — 6, all confirmed from the on-disk `status:` field, not from a comment:**
- `I-0563` → absorbed into `I-0617` (your item). Same incident, same carrier, one step earlier: it says *diff the API by name*; yours says a name-level diff reads as complete when one face is missing.
- `I-0572` → absorbed into `I-0611`. `I-0572` argued index staleness; `I-0611`'s comment trail supersedes that with the double-HEAD-read race, corroborated by two other lanes.
- `I-0579` → absorbed into `I-0612`, which already names all three members of the accepts-and-drops family.
- `I-0576` → absorbed into `I-0600`. Its own last comment, by the lane it was filed against, said exactly this: defect fixed, only the rooting residual kept it open, `I-0600` is now that tracker.
- `I-0596` → its ask has landed: all three `SymPowInterface.lean` sites now carry the terminal-object qualification, and both cited lemmas exist (`SymPowColimit.lean:329`, `:353`). Noted on `I-0592`.
- Counts: store-open **109 → 107**, non-protection **106 → 104**, memory **54 → 53**. Six archived, four arrived during the pass (`I-0618`–`I-0621`). Arrivals nearly matched removals; that is the real finding, not the count.

**Your two items:**
- `I-0565` — **left open**, agreeing with your read. Half (b) is discharged; half (a), the subordinate Stacks 0B8B input, is open and out of scope by human decision `I-0492` clause 2. Out of scope is not discharged, and this is the only place (a) is stated with its consumer named.
- `I-0617` — **kept, not absorbed**, and it absorbed `I-0563` instead. It is not related to `I-0592` at all (that one is about `symPowData_affine` prose in AJC Albanese). I re-measured its own check: `DivFamZarAff` appears in 8 files, all `Picard/DivisorFamilyAff*.lean`, nothing outside that cone.

**Docs (4 files, stale counts against disk):** AJC README 210 modules/140,213 lines → 257/153,196, and Ledger 41 → 42 files; rebuild README 690 files/68 unrooted → 693/624 reachable/69; `roadmap.md` DivisorFamilyAff nine files → 23, DivFamZar consumers 32 → 42, and the AJC module ratio qualified as drifted. I did not touch the root `README.md` — it has another lane's uncommitted edits.

## Roadmap: all three "fixes" were wrong to make

- **AJC.rr** — do not close. Its own summary keeps three gaps apart and gap 2, extension uniformity, is open: `Adelic.UniformlyBoundedVanishing` is a predicate proved at no curve, and `UniformlyBoundedVanishing'` is an `Iff.rfl` restatement. The warning means a *missing child*, not a stale parent. Filing that leaf belongs to `ajc-rr`.
- **AJC.jacobian.assembly** — the summary already forbids this in as many words: "that status mismatch is deliberate and must not be fixed." Its five obligations are open statements, including the project's central `sorry`. This warning is permanent by design; I recorded that so it stops being re-triaged.
- **AJC.picrep** — reported, not guessed. Two readings both fit disk. What decides it is whether `.tensor` is still an input to the chosen étale route (`.quot` and `.serre` plausibly belong to the abandoned one). Needs `ajc-etale-pic` or `ajc-truth`.
- **18 active rows** — fifth liveness cross, fifth all-legitimate: 13 held directly by the 8 live lanes, 6 active ancestors, **zero orphans**. The count rose to 19 mid-pass when `ajc-fbc` activated its own row, then settled back. Nothing to demote. Recorded on `I-0509`, plus a method note: prefix-matching ids is not the ancestor test, walk `metadata.parent` (mine reported two false orphans until I fixed it).

## Tasks

Seven `running` tasks, all mapping to a live run pid via `runs/<id>/run.yaml` `focus.tasks`. **Zero orphans.** The 13-open-task warning is arrival-driven, not stale.

## Needs a human or tooling decision

- **`I-0621`, filed this pass:** every horizon mutation calls `_load()` over the whole collection before touching one row, and `inbox_item_from_dict` assumes a dict. A sibling lane's half-written YAML makes `yaml.safe_load` return `None` and the unrelated write dies with `AttributeError` naming no file. It cost me one failed `inbox archive`. Worse, one `roadmap comment` printed the identical traceback **and landed** (`C-0040`), so the traceback is not a reliable failure signal either. Fix: skip-and-warn on an unparseable item, and name the path.
- **A fourth accepts-and-drops member**, noted on `I-0612`: `inbox comment --agent <name>` exits 2 with `No such option: --agent` and writes nothing, yet the `horizon-inbox` skill instructs dispatched subagents to pass exactly that on comments (it is valid only on `inbox add`). The skill's own guidance trips the defect on the call a janitor makes most.
- **Load conditions made this pass slow, and that is a real hazard:** load average 81, 23 concurrent `lake build`s. Single `inbox archive` calls took 4–11 minutes in state `D`; two were killed by a 120s wrapper timeout while the underlying process was alive and later landed. Do not re-issue a timed-out mutation — read the status field first or you double-apply.
- **`I-0612`'s cap bit me twice**, at 1266 and 1236 chars, on the comments documenting the archives. Both retries landed after trimming.

Nothing committed, per your constraint; the four doc edits are uncommitted in the worktree. No Lean file, and nothing under `AlgebraicJacobian/` or `informal/`, was touched. Your `AJCR.w4-rep.datum.dat-d.ddr.certificate` subtree is untouched and still `active`.
