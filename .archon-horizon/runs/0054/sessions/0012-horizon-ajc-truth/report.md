Everything is committed and verified. Final report:

## Summary

Published the axiom frontier at **126 probed / 84 clean / 42 `sorryAx`**, reproducible warning-free on a green root build; found and fixed the retracted "four obligations" claim in **seven** surviving carriers (including the probe file whose own §0b exists to prevent it, and once more written by me); factored the FGA assembly out of the rational point so branch (1) of I-0372 is a compiled definition; and re-aimed the last route-claim prose at Milne–Kollár. Three of my own published claims turned out to be wrong and were corrected where they were published.

## Progress

- `AlgebraicJacobian/Jacobian.lean`: new `picardJacobianWitnessOfHasRationalPoint` — the seven-field assembly under `[HasRationalPoint C]`; both existing witnesses are now one-line `haveI` specialisations, so the only difference between them is elaborator-checked rather than asserted in parallel docstrings. Sorry count unchanged at 3.
- `scripts/axiom-frontier.lean`: §0c (branch-(1) assembly), §6f (ajc-rr's root-path measurement, answering I-0463), trap (g) rewritten as a three-round history, and a third companion measurement — a mechanised `\leanok`-honesty join I ran verbatim from the header before committing.
- `blueprint/.../Jacobian.tex`: `def:picardJacobianWitnessOfHasRationalPoint` + `rem:pointed_witness_scope`; two proof-level `\leanok`s removed; both witness proofs now delegate instead of restating seven steps.
- `hgraph`: deleted 15 nodes the scanner invented from prose — two carried `lean_status: sorry`, i.e. nonexistent declarations counted as unproved carriers.
- README, TO_USER, campaign doc, roadmap (`reachability` summary rewritten, two off-path nodes demoted from `priority: high`).

## Issues

- **My session-0010 retraction of I-0449 was itself the error.** ajc-rr's I-0467 reinstated the finding unconditionally: `hbump` and the closed ledger are both refuted off one chart. I had inferred "not refutable" from "not refutable by that route" — the same inference error I was correcting, sign-flipped, made while accepting a correction. Memory I-0471.
- **Two proof-level `\leanok`s in my own chapter claimed proofs routing through sorries**, in the exact area session 0010 audited by reading and declared clean. Two more remain in `Picard_Pic0AbelianVariety.tex` (outside my write set) — `thm:pic0_smooth`'s body is literally `sorry`. Filed I-0473.
- **Ground caught me understating branch (2):** the étale functor is built and sorry-free in the Rebuild sibling. "Needs an input nobody has built" was literally true and misleading; corrected in four documents and on I-0372.
- The gate-drop miscount has now happened three times in two sessions (I-0469).
- hgraph's declaration regex is one defect with two faces (I-0452 + I-0472, consolidated): rejects real names with universe suffixes, accepts backticked prose as declarations.
- Inbox still over both advisory caps (20 memory / 44 open). The janitor I dispatched made partial progress then ended without a report — same as session 0010's. I archived only the 5 items my own work provably consumed.
- Ground's report file was also truncated; I recovered its findings from the two inbox items it filed first and verified each independently before acting.

## Why I stopped

**Partly advanced, not complete** — status left unset. The visibility, route-alignment, and reproducibility objectives are met. But the task's bar is the headline claiming what the graph supports, and the graph still supports five open obligations: `instHasPicScheme` is untouched, and the five protected declarations still route through the false leaf `hasRationalPoint_of_curve`. `picardJacobianWitnessOfHasRationalPoint` has no consumers among them, by design.

## Next

1. `Pic0.smooth` / `Pic0.proper` — nearest unowned work; over `k̄` they are two of five *true* obligations.
2. Drop the two proof-level `\leanok`s in `Picard_Pic0AbelianVariety.tex` (I-0473) — two characters each, and it removes the blueprint's most misleading claim.
3. Inbox hygiene needs a janitor that completes; two consecutive attempts have not.
