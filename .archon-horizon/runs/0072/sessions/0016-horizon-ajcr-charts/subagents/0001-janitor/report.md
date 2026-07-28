Hygiene pass done. Everything below was filed to the inbox as I established it (I-0757 through I-0761), so nothing depends on this message surviving.

## 1. Armed index — found a real revert, twice

The check fired both directions of the protocol §1b test, and the repair had to be done **twice** in one pass.

Pass 1 (HEAD `b207018c9`) had `D MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartPlusFibreTower.lean` staged, plus two staged modifications. The staged root-import diff would have dropped **two** imports (`Tangent.EpsArrowIdentification`, `Picard.Pic0ChartPlusFibreTower`), un-rooting both modules. Pass 2 (HEAD had advanced to `62dbd06c0` mid-pass) re-armed with three staged mods dropping `-import AlgebraicJacobian.Picard.Pic0ChartLocusPlusFibre`.

In both cases disk and HEAD agreed byte-for-byte and only the index dissented — so the staged side was unambiguously stale, and `git add --` on exactly those paths was the safe repair. Verified `diff --cached --name-status HEAD` empty after each. No staged additions of any sibling project's paths (`--diff-filter=A` count 0), so nothing of another project was armed for publication. The only other deletion workspace-wide was `.archon-horizon/runs/0074/process.json` (infra, not mine, not touched).

Final state at close: no `^D` anywhere, staged-vs-HEAD empty.

## 2. Your commit `121390af6` — verified, with one wrinkle

Ancestor of `refs/heads/main`: yes. Touches only paths under `MainProjects/Algebraic-Jacobian-Challenge-Rebuild`: yes. All three authored paths byte-match the on-disk worktree: yes, three-for-three.

The wrinkle: its root-file diff has two plus lines, not the one expected. `+import AlgebraicJacobian.Tangent.EpsArrowIdentification` is not yours — that file did not exist in `121390af6~1` and was added by `45a871c7b`, which is a *descendant* of your commit. So at your commit the root imported a module git did not yet have. Healed at HEAD; no repair needed. Filed as I-0758 because the mechanism matters: staging the root import file publishes a sibling lane's in-flight module *by name* even when the staged-additions check is clean.

## 3. Root-import integrity

Worktree diff of `AlgebraicJacobian.lean` vs HEAD is empty. All 22 AJCR modules added by integrate commits in the last 20 commits are rooted.

## 4. Boundary — two roadmap rows are stale on your result

`AJCR.w4-rep.datum.dat-c.c9-chartlocus` (pending) and `...c9-chartlocus.chart-u` (**active**) both still say CHART-U(b) reduces to "a cechPicClass base-change identity", and chart-u's bullet list still asserts hplus is "strictly more than IsChartDatumPlusFibre asks". `isChartDatumPlusFibreAt_of_isScalarTower` now exists at `AlgebraicJacobian/Picard/Pic0ChartPlusFibreTower.lean:112` and is consumed at `:222`, so that pricing is false at HEAD. Reported (I-0760), not edited — and I flagged that chart-u was already reopened once on a too-generous reading, so it should not be re-closed on my note alone. I-0749 is stale for the same reason. I-0492 untouched.

## 5. Docs fixed directly

The project README's reachability figures were 42 minutes old and wrong three ways: 737 files (actually 742), 17 unreachable (actually 18), and "all 17 under `Picard/`" (one is under `Tangent/`). Corrected at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`.

The new unreachable file is worth your attention: `AlgebraicJacobian/Tangent/TwoChartKernelComparison.lean`, 207 lines, **untracked**, unrooted, and carrying one `sorry`. Invisible to git, to `lake build`, and to any sorry census, and a sweep could lose it outright. Left untouched per the do-not-force-add discipline — it looks like live lane work (mtime inside the window HEAD moved).

## Counts, before → after

Open non-protection 136 → 136, memory 91 → 91, roadmap active 21 → 21. I archived one item (I-0713, armed deletion of `DivisorFamilyAffAwayRep.lean` — verified gone at HEAD, file rooted, nothing lost) and filed five, so the net is flat. Per I-0641/I-0509/I-0551 the standing liveness answer still applies: four lanes are live (runs 0068, 0071, 0072, 0073), so I did not re-triage. I-0753's `ScratchChartLocal.lean` is unchanged and still live.

One caveat on my own work: `horizon inbox` has no `reply` subcommand, so my intended resolution note on I-0713 did not land — the archive itself did, verified off the open list. The resolution detail is captured in I-0757/I-0759 instead.
