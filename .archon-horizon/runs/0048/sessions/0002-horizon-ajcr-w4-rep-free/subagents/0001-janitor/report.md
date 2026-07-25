Hygiene pass complete. Both FIRED warnings were resolved; one re-fired from concurrent lanes after my pass.

## What I changed

**Inbox — memory warning cleared (12 → 10 open memory items)**
- **Archived `I-0323`** (support-separated adaptations no-go). It is genuinely superseded: its partition-of-unity obstruction is the special case of `I-0327`'s piece-free necessity theorem, and `I-0327` supplies the positive replacement it lacked. Before archiving I **copied its one unique claim onto `I-0327`** as a comment — the second no-go (`divUniversalHighWindowKernelSyzygySpans_iff_flat_quotient`, `DivSchemeHighWindowSyzygy.lean:298`: kernel-spanning ⟺ the sought flatness, which is why gate 2 of `I-0308` cannot be attacked by a better `L`), plus the still-usable positive half `isCertified_of_separated`. Roadmap leaf `…certificate.sep-nogo` cites `I-0323`; archived items stay retrievable, and I said so in the archive comment.
- **Re-kinded `I-0074` `memory` → `protection`** (not archived, body untouched). Its run-0008 state snapshot is already flagged as history by yesterday's audit; what remains load-bearing is two standing "do NOT" constraints (don't close `picardJacobianWitness` for pointless curves; don't reintroduce a global `instHasSmoothProperQuotient` / prove `smoothProperQuotient` as stated). Those are a soft freeze, so they now render in the Protected section — more visible, and out of the memory budget. Revert with `inbox edit I-0074 --kind memory`.
- **`I-0209` and `I-0320` kept open** — both are still standing protections, not subsumed. `I-0209`'s prohibition (never repair a certificate by localizing the *pieces*; the `k[u]` counterexample) is orthogonal to `I-0327`'s necessity theorem, and `I-0320`'s rule ("check the consumer's predicate") is actively contested by `AJCR.w4-rep.build-reach`, so archiving it would hide a live dispute.

**Inbox — working-set warning (33 → 30 non-protection, at the cap)**
- **Archived `I-0325`** (goal-changing `show` at `DivSchemeCertZarPointwise.lean:70`) after **absorbing it into `I-0309`**, which already tracks the same Rebuild lint class. The lint is *not* fixed — I verified it is still on disk, as are the ten `show`s in `Picard/Pic.lean`. I also corrected `I-0309`: `Challenge.lean` now has 15 deliberate protected `sorry`s (not 13), and those can never be discharged, so they must not gate the item; and I noted that `I-0319` is the *AJC* ledger, a different measurement.

**`I-0324` — audited, deliberately kept open, not re-kinded.** Your recon lead was mistaken on one point: **no roadmap leaf cites `I-0324`**. `…certificate.leak-image` (rejected) cites `I-0209`; `build-reach` cites `I-0320`. And the item is not consumed — the fix at `AlgebraicJacobian.lean:326-329` is real but tower-local, while `build-reach` measures ~95 still-unreachable modules (487 root imports vs 390 files in `Picard/` alone). I recorded all of this as a comment; the item stays as the rule's home and the inbox counterpart of `build-reach`.

**Roadmap** — no parent/child disagreement warnings fired, before or after; I also checked the subtree by hand and it is coherent (every `active` parent has open children; `rejected` children are excluded from progress, which is why `certificate` reads 4/9 over 11 leaves). One real drift fixed: `AJCR.w4-rep.datum.dat-c`'s summary still named `DD-R.koszul-flatness` (done) as the active focus gating C6-C9; it now names the certificate lane and records that `c9-chartlocus` is the one row independent of DD-R. Change logged as a roadmap comment.

**Other** — `horizon ps --clean` reaped a stale process marker for the dead run `0047`.

**Docs** — commit `3fbb61ed7` (private index; only my two files staged, per `I-0157`):
- `/home/axel/LeanAlgebraicGeometry-Horizon/roadmap.md`: verified every factual claim (per-project `sorry` counts 16/24/0/0/0/11/16/1 and the uniform `v4.31.0` toolchain are all exact, including "15 protected + 1 in the root-unreachable `Pic0ThetaCocycle.lean`"); updated only the Wave-4 line to say the gate is now a chart-design condition.
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`: it asserted "no file exceeds 500 lines" as fact; **14** files do. Now states the house limit and points at `I-0220`, whose count I refreshed from twelve to fourteen.
- Workspace `README.md` read in full; no drift found.

## Before / after

| Check | Before | After my pass | Now |
|---|---|---|---|
| open memory | **12 ⚠** | 10 ✓ | 10 ✓ |
| open non-protection | **33 ⚠** | 30 ✓ | **32 ⚠** |
| roadmap hierarchy / active (cap 8) | clean / 8 | clean / 8 | clean / 8 |
| open tasks (cap 12) | 12, no warning | 12 | 12 |
| stale run markers | 1 (`0047`) | 0 | 0 |

## Warnings I left, and why

- **Working set back at 32.** Three teams filed four items during this hour: `I-0331` (work-reviewer, sep-nogo status), `I-0332` (cross-team convergence `info`), `I-0333` (`--to human`, design decision on `IsCertified`), `I-0334` (Ground checkpoint: "(c1) ⇒ leak-free is asserted everywhere but proved nowhere"). All are minutes old and consequential; archiving any to hit 30 would be exactly the "shorten the list" move the brief forbids. The cap is advisory and the churn is healthy.
- **Task queue at 12/12 with zero headroom** — no warning fires, but the next queued task trips it. Both `running` tasks are genuinely live (`ajc-optimize`/0046, `ajcr-w4-rep-free`/0048). Cheapest reductions when you want headroom: the `AJCR.w4-rep` task is queued while its whole roadmap subtree is being worked under `ajcr-w4-rep-free`, and `T12` is `failed` while `T15` restates its objective.

## For your decision (I did not act)

1. **`away-assemble` and `flattening-fallback` changed under me at 14:04** (`rejected → done`, `rejected → pending`) by another `horizon` writer. Both new summaries justify the change, so I left them — but `away-assemble` is now a `done` leaf whose summary says "nothing is left to compose here".
2. **`I-0331` asks you to re-label `sep-nogo`** from `done` to a refutation status. Combined with (1), three of the certificate lane's closed leaves (`sep-nogo`, `away-assemble`, plus the rejected `tube-fibre`/`leak-image`) are closed by refutation or supersession, so `certificate · 4/9 done` reads as more constructive progress than exists. That is a lane-owner call, not a janitor's.
3. **`I-0334` (Ground) claims the keystone `(c1) ⇒ leak-free` is proved nowhere in Lean**, which would demote ChartTrace/Swallow/Conn from a design refutation to a statement about one sufficient-condition assembler — and `I-0333` escalates the resulting design question to the human. Worth reading before the next certificate edit; it bears directly on `I-0327`, which you asked me to protect.
