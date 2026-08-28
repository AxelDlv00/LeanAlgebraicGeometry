Pass complete. Here is the report.

## Archived (4), each with successor cited in a comment

All four were genuinely consumed — verified at HEAD by blob/file measurement, not by reading reports. None was archived to reduce a number.

- **I-0577** (8 committed axiom-probe files at AJC root) — repair landed. `ls-tree -r HEAD | grep -iE 'probe|scratch'` returns only AJCR's real `ScratchChartLocal.lean` and an informal `.md`; AJC's project root holds exactly one tracked `.lean`. Removal commit `81bf9891c` by the owning lane. Durable half also in place: `.gitignore:26 '*Probe*.lean'` now prevents re-sweeping. Successors: I-0572 (recurring hazard), I-0442/I-0423 (the endorsed technique).
- **I-0590** (`scratch_smooth.lean` tracked + staged-deleted) — neither tracked nor on disk; `DupProbe.lean` likewise gone. Its correction that `LedgerResidueWeights.lean` never existed is preserved in the archive note. Successors: I-0577, I-0572.
- **I-0546** (`roadmap set --strategy` silently ignored) — a run-0071 comment said "archiving this one" and **the archive never executed**; item sat open ~3h. Absorbed into **I-0579**, which records the merge from its side.
- **I-0578** (TO_USER.md falsely claimed `pullback_preservesFiniteLimits` proved) — fixed at `fccd39dcd`; line 39 now says demoted, *not* proved, still reports `sorryAx`. A prior pass verified it and wrote "completed" but **never archived it**. No residual ask.

## Deliberately left

- **All same-day memories from the 8 live lanes.** 43 open vs a cap of 10; per I-0556 the cap was written for a workspace filing a few lessons a week. Archiving verified content to hit it would destroy it.
- **I-0576, I-0600** — I-0576's *defect* is closed, but its residual is live: I confirmed `AlgebraicJacobian.lean` has **zero** `RiemannRoch.Ledger` imports and no importer outside `Ledger/`, so the 40-file cone is still unrooted. I-0600's ask has not landed.
- **I-0538 / the two AJC roadmap warnings** — reported, not flipped, as you asked:
  - `AJC.jacobian.assembly`: **intentional and self-documented.** Its summary says in capitals that the status mismatch is deliberate and "must not be fixed" — it is the assembly step resting on five open obligations, not a container. It was already reverted `done → pending` at 06:35 after I-0543's propagation bug set it. Warning should survive.
  - `AJC.picrep`: **a genuine inconsistency, but not mine to resolve.** Its `done` was never a decision — I-0543 shows it propagated automatically from `ajc-etale-pic`'s terminal status at 06:04:16. `.quot` and `.serre` summaries both open "OFF-PATH, retained not revived"; `.tensor` has no such disclaimer. Four passes have triaged this; I-0556 forbids a fifth. Needs a human or a `AJC.picrep`-scoped lane.

## Liveness verdict: correct as-is, zero orphans

Measured, not assumed. 18 active rows, 8 live lanes: **14 held directly** by a running task, **4 active ancestors** (`AJC.jacobian`, `AJCR.jacobian` north stars, plus the `AJCR.w4-rep → .datum → .dat-d` spine). **Zero orphans.** Sixth consecutive pass reaching this conclusion. The floor is ~(lanes + spine depth), so the limit of 8 is unreachable at this fleet width; the threshold is what is mis-set.

Inverse drift worth noting: `ajc-rr` and `ajcr-charts` are running but hold **no** active row (all their refs are `pending`/`done`/`blocked`). That is the opposite asymmetry from the one the warning describes.

## My lane's trail: reads correctly, no duplication

I-0494 comments are coherent, including the two self-retractions. **I-0603 is not a duplicate** — I-0602 and I-0584 are the same *family* ("trace what the body consumes") but different objects; I-0603's content (no `CurveDivisor` base change exists, transport the class) is distinct. **I-0564 was archived at 11:48 by another lane** during my pass, correctly, since I-0604 supersedes its operative rule while keeping its diagnosis.

## Two things I filed

- **I-0609** (memory) — a janitor comment announcing a state change is not the state change. Three items sat open after being declared closed; `archive` takes no `--note`, so the comment is the half that silently succeeds. Write the state change first.
- **I-0611** (issue) — **and this one you should read.** My single-line README commit landed as **six files**, dropping `import AlgebraicJacobian.Tangent.DualNumberChartPic` from the AJCR root and reverting 167 lines of three other lanes' work. I repaired it (`3f41bec5a`, `a1ef4d59c`); the *next* commit by an unrelated lane republished byte-identical stale blobs; that lane repaired it too (`f66a27e88`). Staging explicit paths does **not** prevent the commit from carrying whatever the shared index already holds — so protocol 4a is insufficient and per-commit repair does not converge. Currently clean: all six paths match disk at HEAD and the dropped import is back, verified by blob comparison.

## Docs

Workspace README is accurate and correctly cites live issues. Refreshed one stale figure in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` (688 → 690 `.lean` files); I independently confirmed the load-bearing number, **68 transitively unreachable** from the root (622 reachable), plus its 78-worksheet and 17-oversized-file claims.

## Counts

Open non-protection **99 → 99** (a real measurement, not a null result): I archived 4 and 4 arrived from other lanes mid-pass (I-0605 through I-0608), plus my own 2. Memory 43. Per I-0509's absorbed rule, count arrivals rather than totals — at 8 live lanes the number goes up while you work. No `protection` was touched.

One caveat on the CLI: `horizon inbox list` showed **70** open while the store holds **102**, because audience filtering hides 32 items. I worked directly against the store for that reason. That is I-0505's defect, still open and still worth its slot.
