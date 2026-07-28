Both threads now have my posts. Final state confirmed clean.

## Summary

Executed human decision I-0492: `DivFamZar`'s cover pieces are now **arbitrary affine opens**, not basic opens of a fixed pair of pinned `P¹` charts. Eleven commits, nine new Lean files, all sorry-free; full root build green (`lake build AlgebraicJacobian`, 9143 jobs, exit 0).

The structural key: the old `FinCoverData` conflated three independent things — an affine open cover, a chart assignment, and the chart-wise partitions of unity. Only the first is used by the certificate layer. Separating them made this a new-file job rather than a 30-file rewrite. The cover became `AffCoverData` (joint cover, no `π` argument at all), the chart assignment became a separate optional `ChartTyping` needed only by the Θ-layer, and the partitions were deleted.

## Progress
- `DivisorFamilyAffCover.lean`: new, 0 sorries — `AffCoverData` + `flat_sections_of_flat_hom`, the one new commutative-algebra input (the old route needed pinned-chart *freeness*, unavailable for a general affine open).
- `DivisorFamilyAffAdaptation.lean`: new, 0 sorries — `AffAdaptation` + `IsCertified`, clauses (c1)–(c4) verbatim.
- `DivisorFamilyAffPerPiece.lean`: new, 0 sorries — the per-piece layer transports. Sharper than asked: swallow-or-miss and the clopen-trace argument mention neither adaptation nor cover, so they are stated for a **bare open set**.
- `DivisorFamilyAffZar.lean`: new, 0 sorries — `IsLocallyCertifiedAff`, `DivFamZarAff`.
- `DivisorFamilyAffCollapse.lean`: new, 0 sorries — cert-collapse; the I-0340 refutation now kernel-checked.
- `DivisorFamilyAffSwallow.lean`: new, 0 sorries — swallow-adapt via a straddling piece; chart-principality no longer needed.
- `DivisorFamilyAffAssemble.lean`: new, 0 sorries — cert-assemble; (c1) produced, (c2)/(c3)/(c4) hypotheses.
- `DivisorFamilyAffReindex.lean`: new, 0 sorries — the equalizer transport.
- `informal/spec-dd-r.md`: ADDENDUM 5.

Both relocated obligations are visible in signatures, neither inside a `LocalEquations`.

## Issues
Two corrections to my own published claims. I told the team thread the reindexing transport needed ~100 lines; it needed none — arrange the reindexed data to be definitionally the original at the relabelled index and it is `rfl`, since reindexing acts diagonally on the pair index. And `p1-aut` carried status `done` with no pinned commit, contradicting I-0492's "stays pending"; corrected and flagged rather than assumed.

`away-kerspan` is **confirmed a real obligation, not an artifact** — cert-collapse was tried first as its node instructed, and the vanishing diagonal forces (c4) to imply flatness of the diagonal overlap colengths.

## Why I stopped
Objective substantively achieved, but I did **not** mark the task done: all three subagents I dispatched (work-reviewer, consumer survey, janitor) went quiet without returning, so the required fresh-context review never happened. The material builds and is sorry-free but is self-checked only. I filed **I-0521** naming the three places to check first — `flat_sections_of_flat_hom` (everything (c1)-flat rests on it, and I hit one real type mismatch there), clause-by-clause identity of `IsCertified`, and that `SwallowedBy` is genuinely a hypothesis at every use site.

## Next
Complete I-0521's checks, then flip `ajcr-cert-r2` to done. The `CertifiedDivisorFamily → CertifiedDivisorFamilyAff` packaging is bookkeeping on landed pieces; nothing downstream needs it.
