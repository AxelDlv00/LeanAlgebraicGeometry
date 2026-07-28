Hygiene pass complete. Nothing this lane claimed about its own bookkeeping was lost.

## Actually broken (one item, workspace-level)

**Commit provenance: confirmed missing, but it is not this lane's error.** Filed as **I-0608**. `.archon-horizon/vcs/workspace.git/hooks/prepare-commit-msg` is what stamps the `Archon-*` trailers, and git runs that hook **only from `git commit`**. The `commit-tree` + `update-ref` CAS route this lane used (to dodge the shared-index race of I-0568/I-0572) fires no hooks, so it cannot be stamped. Measured: last 200 ledger commits are **104 stamped / 96 not**; commits dated today are **232 / 381** — and of the last 120, the 75 unstamped ones touch AJCR (59) and AJC (9), i.e. spread across lanes in both projects. The CLI's own `workspace[NNNN rN] … integrate …` commits are always stamped, which is what makes the survivors *look* like a per-lane property. Proof of mechanism: my own README commit went through `git commit` and came out fully stamped. The real cost is that `.claude/skills/project-git/SKILL.md` presents the trailer query as the reliable way to find what a previous agent did; it returns blank for most of today's work, which is exactly how the false "this lane produced nothing" finding arose. Fix is in the CAS publish path, not in any lane. I explicitly recommended **against** retro-stamping history with eight live pids on one shared branch.

## Checked clean

- **This lane's trail, all present.** `AJC.rr.ledger` exists, `status: done`, `owner: ajc-rr`, `parent: AJC.rr`. Roadmap comments landed (`AJC.rr/C-0009`, `AJC.rr.principal/C-0007`) — no I-0579 flag-drop here. Task comments: **14 on disk**, two from this session (`C-0013`, `C-0014`); `task show --json` reports `comments: 0`, which is I-0586 and not a loss. All 10 commits `8dc29faff`..`d7bdd5456` verified present with matching subjects.
- **Stale index: 2 → 0.** Both were AJCR paths (`Picard/JacobianDataFromPicRepDatum.lean`, `Tangent/DualNumberCarrierReduction.lean`), then re-armed minutes later as a *different* AJCR file. All hash-identical HEAD vs disk, so phantom. I did **not** reset (AJCR paths, 4 AJCR lanes live, protocol 1b forbids it); my `git commit` re-seeded the index and it self-cleared to 0. Numstat confirms my commit touched README only.
- **Collection warnings**: the 18-active-rows and memory-cap warnings are covered by I-0509/I-0556 — not re-triaged. `AJC.jacobian.assembly` and `AJC.picrep` are both already-triaged deliberate mismatches (see `roadmap/comments/AJC.jacobian.assembly/C-0006`, and I-0605).
- Root-cause verified for the docs fix: `AlgebraicJacobian.lean` has **zero** `RiemannRoch.Ledger` lines and nothing outside `Ledger/` references it. Scratch probes at the AJC root are untracked and ignored (I-0577 correctly archived).

## Changed

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/README.md` — commit `f800213a0`. The file's own rule says the no-rooting grace period "ends at the commit"; 41 committed files violate it. Said so at the rule, and added `Ledger/` to the layout list, which omitted it. Docs only.
- **`AJC.rr.ledger`**: summary carried stale counts (38 files/~9.4k) against **41 files / 9877 lines** measured at HEAD; three figures (35/38/40) were circulating. Corrected, and pinned all 10 commits — the row had **zero** pinned commits despite being `done`.
- **I-0583**: keep both, don't merge blindly. Its check 2 duplicates I-0576, but checks 1/3/4 are unique. Recorded that I-0576's C-0002 *corrects* I-0583's "3 real collisions" — only the `Ext` lemma actually blocked; a source-text scan over-reports.
- **I-0576**: **not archivable.** Its residual ("open until someone adds the import line") is live at HEAD, but now duplicated by I-0600. Left the close decision to `ajc-pic0av`, which filed it.
- **I-0460**: headline refuted by events — it says AJCR "is not portable into AJC", and a byte-identical 41-file port just landed. The reasoning survives (the *Adelic* layer resists on carrier grounds; the port went to a new sibling directory). Pointed to I-0601.
- **I-0579**: found a third member of the silent-flag family live — `inbox add --body-file` **exits 0, prints the full banner, and creates nothing**. Worse than `roadmap set --strategy`, which at least fails. Caught only by listing item ids afterwards.
- **I-0572**: the phantoms have **migrated to AJCR**, so the mechanism isn't tied to the AJC ledger port — it follows whichever lane last published via CAS.

## Left alone deliberately

The 18-active/memory-cap warnings (structural per I-0509/I-0556); the `AJC.jacobian.assembly` and `AJC.picrep` mismatches (owners' deliberate decisions, and I-0605 already escalates picrep to the human); the AJCR index reset (another lane's staging); `AJC.rr.principal`'s `pending` status (the leaf at `WeilDivisor.lean:1214` has no `IsAlgClosed` binder, so it is strictly stronger than what was proved — a real gap, not bookkeeping); `Algebraic-Jacobian-Challenge-Rebuild` entirely; all Lean source.

Counts: inbox open **76 → 77** (+1 = I-0608; nothing archivable was found, and I did not chase the cap). Staged deletions **2 → 0**. Roadmap warnings **3 → 3**, all three pre-triaged. Verified every comment landed on disk per I-0609, rather than trusting the CLI's success line.
