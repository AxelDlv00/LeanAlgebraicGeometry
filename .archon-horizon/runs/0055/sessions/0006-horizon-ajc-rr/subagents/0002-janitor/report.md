`ajc-gate` closed the basechange row while I worked, so that warning is resolved and the active count is now 7. Final state confirmed.

## Summary

The hygiene pass is done. Both roadmap warnings you were seeing are now resolved or documented as chosen, and the inbox is down 7 items — though a concurrent janitor and three live teams moved the numbers under me, which is itself the finding worth your attention.

## What changed

Inbox, before/after: **46 open (45 non-protection, 20 memory) → 39 open (38 non-protection, 19 memory, 6 conversations, 0 info)**.

I archived four items, each with a conclusion comment recording what I verified in source:
- **I-0420** — the "exact remaining frontier … four named leaves" claim. Fixed at HEAD: `Picard/RigidPushforwardGate.lean:295` now says "*This is no longer the frontier*", and `scripts/axiom-frontier.lean:308` calls it a factorisation of historical interest.
- **I-0421** — the `k[x]` counterexample overstatement. `Picard/RigidPushforwardRank.lean:116` now scopes it to `hproj` alone and says `hfin`/`hbc` are "not separately witnessed".
- **I-0422** — the wrong binder-count recipe. `RigidPushforwardAffineDescent.lean` correction 2 now gives measured counts (three / one / seven) and flags its own earlier draft as wrong.
- **I-0435** — folded into **I-0416** rather than kept. It is the second half of the same procedure (a passing probe over a hypothesis *bundle* proves the bundle sufficient, not the member you credit); `I-0416` now carries the full three-step check before the word "discharged".

## What I left open, deliberately

- **I-0074** untouched, as instructed.
- **I-0426**, **I-0427** — your DMs awaiting reply. I-0426 was already archived by ajc-truth after they rooted `ResidueField.lean` and re-measured your 12 declarations clean; I-0427 is still open for ajc-gate.
- **I-0418** — already archived by ajc-truth, after your RESOLVED comment. Nothing for me to do.
- **I-0394** — **you archived this yourself at 13:04**, with a comment saying the upstream residual-ledger binder restriction landed (commit `4caf08e02`, `exists_bound_subsingleton_h1Mod_of_residualLedger`). I verified that theorem exists at `BoundedVanishing.lean:341` and left your closure alone. Your task brief asked me to leave it open, so flagging the discrepancy rather than reverting.
- **I-0429** — I did **not** close it, but its central claim is now false and I said so: `Picard/RigidPushforwardP1Witness.lean` supplies both missing instances, so `hasRigidPushforward_p1Over := inferInstance` type-checks. It stays open on one narrow point — **that module is the only one of 185 not reachable from `AlgebraicJacobian.lean`** (184 rooted, measured by transitive import closure). Until it is rooted, the non-vacuity evidence that `RigidPushforwardGammaBaseChange.lean:253` cites is not kernel-covered from the root.
- **I-0432** — kept, not merged. It is not a duplicate of I-0397 (leaf hypotheses) or I-0412 (the misranking); its nearest sibling is I-0416, and it is the *opposite* defect — binders that two things construct, not zero. I verified both scoped instances are live in the same namespace and cross-referenced I-0434, which reports that `ResidueField.lean`'s docstring names the wrong activation mechanism for exactly this diamond.

## Roadmap and tasks

- **Active items: 9 → 7.** `ajc-gate` closed `AJC.picrep.rigidpushforward.basechange` mid-pass, which killed the parent/child mismatch. I had already verified independently that `rigidPushforwardGammaBaseChange_proved` (`RigidPushforwardGammaBaseChange.lean:189`) carries only the three curve hypotheses and that no `sorry` exists anywhere in `Picard/RigidPushforward*.lean`; that measurement is on **I-0431** for the record, along with the rooting caveat.
- **`AJC.jacobian.assembly` stays `pending` with its one `done` child** — the warning is chosen and now documented twice (your own comment at 21:26, plus the earlier C-0001). I did not touch your comments on `AJC.rr` / `AJC.rr.principal`, and `AJC.rr.principal` remains `pending`.
- **Task queue is healthy**: 11 open against a cap of 12, and all three `running` tasks have live pids (run 0053/0054/0055, ~6h39m each). No stale-running condition.

## Two things you should know

**A concurrent janitor from run 0054 was draining the same queue at the same moment.** It archived I-0385, I-0414, I-0415 and I-0428 in the same two minutes I archived I-0420 — my comment there landed seconds after theirs saying substantially the same thing. Two teams doing the same correct cleanup and duplicating each other. I recorded this on **I-0387** with the arithmetic, because it upgrades that item's case: the caps do not just produce ignorable noise, they cause each team to dispatch a janitor and the janitors then collide.

**Three of my CLI writes timed out** against `.archon-horizon/locks/workspace-commit.lock` (held by run 0053's live pid). Two landed anyway after the timeout, one (`roadmap comment AJC.jacobian.assembly`) did not and left no trace — exactly the partial-write symptom in memory I-0408. Worth verifying your own writes this session landed by reading the store, not the command output.

I left `MainProjects/Algebraic-Jacobian-Challenge/README.md` alone: its counts had drifted (185 modules / 130,736 lines / 23 `sorry` measured), but another session was editing the file while I read it, so I did not fight a live writer. The file already tells readers to re-measure, and it now correctly describes the rigid-pushforward gate as discharged.
