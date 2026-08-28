Both counts verified as landed in the store. The scoped pass is done.

## What changed

Inbox: **40 → 34** open non-protection, **21 → 19** open memory. All writes verified by reading `.archon-horizon/inbox/local/items/*.yaml` back — two of my first attempts silently failed under lock contention (run 0054 live), so every write below was re-checked on disk.

**Archived (6), each with a conclusion comment first:**
- `I-0433`, `I-0434` — the two docstring-defect threads your lane filed against itself. Both asks are consumed in source: `SectionBounds.lean:508-517` now carries the explicit retraction of "`LocallyOfFiniteType` synthesizes from smoothness" and names `[IsProper]` as the real supplier; `ResidueField.lean:111-129` now explains the instance-diamond protection by namespace separation (with the `rfl`-both-ways evidence) instead of the wrong "opens only" mechanism.
- `I-0427` — your DM to `ajc-gate`. Question (1) answered, its `LocallyOfFiniteType` correction retracted both on the wire and in the tree, and superseded by `I-0443`.
- `I-0404` — `ajc-gate`'s chart-ring freeness thread. Fully answered both directions; initiating task is `done`.
- `I-0380`, `I-0432` — folded into `I-0442`, which already held the reconciled six-mode numbering. Their detection recipes (the `leakProbe`/`leakControl` pair; the `functionFieldAlgebra` vs `overStalkAlgebra` diamond and the "is a cross-file identity that ought to be `rfl` actually `rfl`" test) are copied into a comment there, so nothing is lost. This was the only genuine duplicate-subject cluster in the memory set — I read all 21.

**Correcting comments, no deletion (5):** `I-0412`, `I-0384`, `I-0416`, `I-0442`, `I-0387`. `I-0394` and `I-0399` were already archived before this pass, so no action was needed there.

## Cluster-P lane, for you to reconcile

`Adelic.chi_eq_of_bump` verified present and sorry-free. Three items described the closed ledger as an open gap and are now annotated rather than deleted:

- `I-0412` said "extension uniformity is the genuinely hard one and is still untouched" — stale. Its heuristic and the finite-field caveat ($\sup_P [\kappa(P):k]$ does not exist over a finite field) stand.
- `I-0384`'s closing paragraph said extension uniformity "is not currently STATABLE" — stale for the ledger. What survives: the cover data still is not transported by `CurveBaseChange.lean`, so a bound quantified over *field extensions* still needs the base-changed cover. The ledger no longer does.
- `I-0416` (`[persistent]`, kept) was earned on `hasRationalResidues_of_isAlgClosed` relocating three binders; that relocation has since become a real discharge via `residueFieldIsoBase`.

**The one thing I would act on:** `I-0441` is worse than filed, and I extended it. `chi_eq_of_bump` has no blueprint or graph node at all, while the nearest existing node `def:adelic_chi_ledger` (`RiemannRoch_Adelic.tex:1508`) only *defines* the ledger quantities. So the blueprint still states a weaker mathematical position than your tree proves, on the lane's central identity — a reader concludes the extension past the effective cone is open. Blueprint files are outside your write set, so it stays an ask.

## Warnings that remain, deliberately

- **19 memory / 34 non-protection.** Above the advisory caps (10/30) and staying there. I archived only on consolidation and consumption; the remaining 19 are distinct subjects. `I-0074` untouched and the only open protection. I also corrected suggestion 2 in `I-0387`: `commands/inbox.py:255` computes health from the unfiltered `inbox.list_items()`, so `inbox own --mine` would tidy visible lists but not reduce the warning — that needs a code change in `AdvisoryHealthLimits`, not a convention.
- **`AJC.jacobian.assembly: every sub-item is done.`** Exactly as `I-0411` documents: flipping it to `done` would be wrong (the witness is not packaged; `I-0074` records four sorries in `FGAPicRepresentability.lean`, and the rational-point hypothesis is false as stated pending the human decision in `I-0372`). Not your row, and I changed nothing. Note `I-0386`: whoever repairs it must set the roadmap row directly, since `task set --status done` rewrites `roadmap_refs` rows.
- **`I-0440`** (`ajc-gate` → `ajc-truth`): all four asks look consumed — `RigidPushforwardP1Witness` is imported at `AlgebraicJacobian.lean:102`, and neither false comment block survives. I left the evidence as a comment and did not close it; it is not my thread.

No task-health warnings fire. Workspace and AJC READMEs are current and concise; no doc edits were needed.
