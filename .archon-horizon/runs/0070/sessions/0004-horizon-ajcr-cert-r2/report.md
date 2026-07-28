Everything landed and rooted in HEAD. Work is complete for this session.

## Summary

Continued the R2 widening lane (human decision I-0492). The predecessor session built the widened `DivFamZarAff` but left it as an **island** — nothing mapped into it, so every chart-typed certificate the tree already owned was formally unreachable from the widened predicate. This session closed that, then discharged the cert-collapse leaf. Two commits, two new files, both sorry-free; root build green at 9149 jobs.

## Progress
- `Picard/DivisorFamilyAffCompare.lean`: new, 282L, 0 sorries — `DivisorAdaptation.isCertified_toAff` migrates a chart-typed certificate to the widened cover, **all seven clauses**, giving `isLocallyCertifiedAff_of_isLocallyCertified`, `DivFamZar.toAff`, and `picClass_toAff` (the Picard class is unchanged, so DAT-C reads the same class from either value). (c1) is `rfl` at the relabelled index; the glued clauses go along `piCongrLeft.symm`.
- `Picard/DivisorFamilyAffGlue.lean`: new, 335L, 0 sorries — cert-collapse discharged. `isCertified_of_swallowedBy_of_c1` produces all seven clauses from (c1) plus the rank datum; the five glued hypotheses of `isCertified_of_swallowedBy` are not needed on a straddling cover, because the difference arrow is there identically **zero**. Includes `ovlColengthDiagEquiv`, the node's "one technical lemma still needed".
- `Picard/DivisorFamilyAffZar.lean`: three stale docstring claims corrected — it advertised three declarations of which **none existed**; two now do, and the third (`IsFibrewiseFiniteSupport`) never did, so obligation I-0492 4(i) is repointed at where it genuinely lives.
- Roadmap `away-kerspan`: summary rewritten — unblocked for straddling covers, still open in general. Left `blocked` rather than flipped, since that is the honest status.

## Issues
The independent audit (I-0541) passes all three I-0521 checks plus clause parity 7/7 and the `SwallowedBy`-is-a-hypothesis check. It also caught a live error in my then-uncommitted glue file (I-0540) and correctly predicted that its `hovl` hypothesis was derivable — I implemented that, which is why the capstone needs no flatness input; both are resolved and I-0540 is archived.

One qualification I posted rather than leave to be found: **I-0492 4(i) is an assumption of this lane, not a theorem.** It is explicit and visible in signatures as the protection demands, but nothing in the tree produces `hfib` or `SwallowedBy`. That is correct per clause 2 (use Stacks 0B8B, don't re-derive), but whoever builds a `DivFamZarAff` from actual geometry owes both.

The inbox remains over budget (44 open) and the roadmap over-active; the janitor I dispatched never returned. I archived what my own work resolved (I-0521, I-0540) and left the rest, which belongs to other live lanes.

## Why I stopped
The objective is substantively complete and now independently verified, so I did **not** leave the task open for lack of review as the predecessor did. I also did not mark it `done`: the lane's endpoint is reachable and certified, but producing a `DivFamZarAff` from real geometry still requires the two relocated obligations, and that is outside what this task's files can supply.

## Next
The remaining lane work is the seed-side discharge of `hfib` and `SwallowedBy` — the only inputs left between `DivFamZarAff` and a geometric divisor family. `CertifiedDivisorFamily → CertifiedDivisorFamilyAff` packaging is bookkeeping on landed pieces and nothing downstream needs it.
