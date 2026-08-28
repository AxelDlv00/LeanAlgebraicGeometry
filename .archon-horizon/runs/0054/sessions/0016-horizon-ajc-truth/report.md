Fourteen commits landed, working tree clean, all checks green. Writing the final report.

## Summary

Two figures this task had published about itself were wrong, and one of them survived its own retraction. Session 0014 correctly retracted three fabricated `\leanok` findings and diagnosed the cause — its audit intersected the blueprint marks with the probe's own 126-declaration output instead of joining over every mark. But the **sibling** figure one paragraph below, "there are eleven statement-level marks on sorry carriers", is that same intersection. The real count is 34, and the sentence carrying the wrong number is the one telling readers *not* to delete those marks.

The one mathematical advance: `Pic0.smooth` is not the theorem its docstring plans. Mathlib's **public** `smooth_of_grpObj` already does the translation argument over an arbitrary field, so the whole obligation is `GeometricallyReduced (Pic0Scheme C).hom` — and supplying that discharges `Pic0.smooth` outright, axiom-clean.

## Progress

- `scripts/axiom-frontier.lean`: `\leanok` check now measures both mark positions under one reconciliation identity; private pins decided via `Lean.collectAxioms` instead of declared undecidable; "exactly two instances" re-derived by declaration keyword. Elaborates at 126/84/42, exit 0.
- `scripts/leanok-audit.sh`: **new**. The audit is one command with three live checks, exit non-zero on failure. Every wrong number this check published came from a recipe transcribed into a comment and drifting from the code beside it.
- `AlgebraicJacobian/Jacobian.lean`: leaf B's docstring corrected — it claimed `Pic0.smooth` needs smoothness-at-identity plus translation. Sorries unchanged at 3 (the three leaves).
- `blueprint/.../Picard_FGAPicRepresentability.tex`: the intro told readers the Quot route *is* the chapter's headline theorem; that theorem's Lean pin is `Classical.choice` over a predicate and proves neither route. Two lualatex passes, zero errors, zero undefined refs, 625 pages.
- `README.md`, `TO_USER.md`, roadmap (`AJC.maintenance.blueprint`, `AJC.jacobian.reachability`): corrected figures, `Pic0.smooth` reduction recorded.
- hgraph: resynced (1941/4656/6751); 13 probe nodes documented as stale *by construction*.
- Inbox: I-0487, I-0488 (memory), I-0489 (CLI defect, to human), I-0372 comment C-0005, I-0391 reply.

Measured: proof-level 1078 marks/1073 pins = 930 public + 143 private, sorryAx **0**; statement-level 1567/1560 = 1372 + 188, sorryAx **34**. Root build green at 8,746 jobs. 98/187 modules reachable, 0 unrooted. 26 carriers = 17 theorem + 7 def + 2 instance.

## Issues

- **A review caught a defect of mine, now fixed** (I-0490, commit `b02d29d5e`): I ran the hgraph resync *before* my last Jacobian.lean edits, leaving two nodes mirroring the pre-correction docstring. Exactly the Lean-vs-graph drift this task exists to eliminate, produced by me. Lesson: sync last — a derived artifact regenerated before the final source edit is stale in a way that looks identical to up-to-date, since neither the totals nor the warning count move.
- **My own extractor had a sixth domain bug.** It matched the review's answer (34) exactly while measuring 1552 pins against their 1560. `re.search` keeps only the first `\lean{}` macro; two `Picard_QuotScheme` nodes carry several. Agreement on the answer was not reassurance — the 8 pins happened to be clean.
- 33 hgraph pin warnings (7 deliberate TODO placeholders) and 43 open inbox items remain, both pre-existing and filed; left standing deliberately.
- The `inbox show I-0372` defect persists — filed as I-0489 rather than absorbed.
- The ground reviewer I dispatched did not deliver a consolidated report before I stopped; it filed I-0490 directly. Its other claim-by-claim verdicts are **not checked** — I verified claims A, B, C and E myself instead, by re-running each.

## Why I stopped

**Partly advanced; status left unset**, so it returns to the queue. The three objectives verify as met and all focused checks are green, but the bar is the headline claiming what the graph supports, and the graph still supports five open obligations. No mathematics closed: the `Pic0.smooth` result reduces an obligation rather than discharging one, and the sorry count is unchanged at 26. I-0372 remains open with neither branch chosen — part 2 of it (the abandoned-route prose) is now done, part 1 (the rational point) is still the human's.

## Next

1. `Pic0.smooth` is now the cheapest of the five obligations by some distance: three `haveI`s and one `exact` in Lean, with the mathematics entirely reducedness of `Pic⁰_{C/k̄}` — Cartier in characteristic 0. Details in I-0487.
2. `Pic0.proper` is untouched by any of this; its Chevalley–Rosenlicht route stands.
3. The 34 statement-level marks will grow as `Picard_QuotScheme` and `Cohomology_CechHigherDirectImage` take landings. Re-run `scripts/leanok-audit.sh` rather than quoting the number.
