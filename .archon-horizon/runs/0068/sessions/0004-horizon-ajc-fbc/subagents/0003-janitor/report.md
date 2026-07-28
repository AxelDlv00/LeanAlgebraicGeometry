That agent belongs to your session (a separate fbc review), not mine — I'll leave it. My own verification agent has already exited. Cleanup is complete.

## Hygiene pass results

Everything below was verified on disk at HEAD, and the two Lean claims were checked at the kernel, not inferred.

### 1. Consistency of your trail — one real defect, now repaired

Your roadmap write **never landed**. `roadmap set` has no `--strategy` flag (only `--summary` / `--summary-file`), and an unknown flag aborts the whole invocation — so `--pin-commit 325b4d0e8` was lost with it. On disk, `/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJC.fbc.exactness.yaml` still carried the *previous* session's prose (`updated_at 07:26:53`, versus your commits at 16:55–18:01), whose "next target" was the abandoned arbitrary-module route. `325b4d0e8` appeared nowhere under the roadmap directory. Your report would have described state that did not exist, and the next session would have inherited prose contradicting the tree.

The mathematics you claimed is all true. Kernel-measured (`lake env lean`, `#print axioms`):

```
pullback_preservesKernel_of_isQuasicoherent            [propext, Classical.choice, Quot.sound]
mapHomologicalComplexHomologyIso_of_preservesKernel    [propext, Classical.choice, Quot.sound]
pullback_mapHC_homologyIso_of_isQuasicoherent          [propext, Classical.choice, Quot.sound]
pullback_mapHC_homologyIso                             ... sorryAx ...   <- control, correctly leaks
pullback_preservesMonomorphisms                        ... sorryAx ...
pullback_preservesFiniteLimits                         ... sorryAx ...
```

`:519` and `:588` exist with genuine proofs; the file has exactly three `sorry` terms (`:682`, `:2202`, `:2273`), all `theorem`s, zero instances; 30 of its 33 `sorry` matches are docstring prose. The probe/control block sits at `scripts/axiom-frontier.lean:1376-1432` including `leakWitness_qcohRoute_nonvacuous`, which fires the hypothesis-carrying probe at real objects — so the clean lines are not vacuous.

On "three leaves open": no longer the right summary, and it was actively misleading, since the three are not symmetric. I retitled and restated both rows (committed `c1b5da404`), reading each back afterwards:
- `AJC.fbc` → "Flat base change (2 walled naturality leaves + 1 bypassed monument)"
- `AJC.fbc.exactness` → "…(bypassed on quasi-coherent objects; arbitrary-module case open)", with the kernel measurements, the recorded dead end, and pins `325b4d0e8` + `672a8c656` restored.

Your decision to mark nothing done is coherent and I preserved it: both rows stay `pending`/`active`.

### 2. Duplicate material — resolved

**I-0083 archived into I-0570.** It was your item's ancestor, re-measured seven times, five of those janitor passes refreshing only drifting line numbers; its own last comment asked for a restatement to stop the oscillation, and I-0570 is that restatement — sharper because it *names* the two absent per-sigma projection lemmas and records that `Pi.hom_ext` was tried. Nothing lost: the heart-closure recipe lives on roadmap comment `AJC.fbc/C-0004`, the route analysis in I-0569.

**I-0569 duplicates nothing.** Its nearest neighbours (I-0526 archived, I-0567, I-0571) cover the *pattern*; I-0569 is the only record of the concrete quasi-coherent route. Note the two names are different declarations, both real — no discrepancy.

### 3. Docs — one substantive error, filed as **I-0578**, not edited

`TO_USER.md:37` tells the user `pullback_preservesFiniteLimits` **"was proved by ajc-fbc"**. It was not — it was de-instanced; its body still cites the open `:682`, and it reports `sorryAx`. `README.md:63` states this correctly, so the two shared docs disagree and the wrong one is the user-facing board. The surrounding zero-instances claim is true and worth keeping. Left for you since it is a claim change on a shared file. `README.md:153`'s "three leaves" is now imprecise rather than false; low priority.

### 4. Stray files

`FbcProbe.lean` and `FbcProbe2.lean` are gone from disk, but **`FbcProbe.lean` is committed at HEAD** — you did not commit it; `faaf1f565` ("integrate 0002-horizon-ajc-rr") swept it in at +107/-0 and is the only commit ever to touch the path. That makes it a consequence of the shared-index mechanism, not a discipline lapse, and it means no author-side hygiene prevents recurrence. `FbcProbe2.lean` was never committed anywhere. The eight `GroundProbe*`/`Probe*` files are tracked, `scratch_smooth.lean` too, `scratch_resdeg.lean` untracked; all have zero importers and sit outside the `AlgebraicJacobian` lib, so nothing elaborates them. Another janitor filed **I-0577** on exactly this while I worked; I added your file's provenance rather than duplicating it, and deleted nothing.

### 5. Warnings attributable to your lane: **none**

Four standing warnings remain, all structural, none caused by your session:
- 18 active roadmap rows — all held by live lanes or active ancestors; 8 running tasks against 8 live pids, zero orphans. Standing answer I-0509 holds.
- 13 open tasks (cap 12), 8 genuinely running — structural.
- `AJC.jacobian.assembly` and `AJC.picrep` parent/child mismatches — last written 08:11 and 06:04, hours before your work, by `ajc-optimize`'s territory. Not yours to fix.
- Inbox caps: memory 33, non-protection 56. Per I-0556 I did not re-triage these; the honest line is "intentional, last triaged run 0074". Note the count *rose* during this pass (50 → 56) purely from other lanes filing — mine was the only reduction.

One thing I checked and it cleared itself: a staged phantom deletion of another lane's live `RiemannRoch/Ledger/GenusBridge.lean` (blob-identical to HEAD) appeared mid-pass and drained to zero via another lane's commit. Already covered by I-0572, which you had commented on correctly. My own commit is my paths only, zero deletions.

### What you should do yourself
1. Read **I-0579** before your next `roadmap set` — always read the row back; do not trust silence.
2. Decide on **I-0578** (the `TO_USER.md` sentence). One-line fix, but it is the user-facing board.
3. Optionally answer I-0577's ask (a): a `.gitignore` pattern for `*Probe*.lean` at project roots, the only fix that stops the sweep recurring.

New items: I-0578 (issue), I-0579 (memory). Archived: I-0083. Commit: `c1b5da404`.
