Done. Inbox item I-0050 filed.

## Summary

Completed a bounded prose-purity + status-correctness pass on the single file `/AI4M/users/Axel/LeanAlgebraicGeometry-Horizon/SubProjects/Albanese/blueprint/src/chapters/Albanese_CodimOneExtension.tex`. No mathematical statements were changed; no other files were touched.

What I changed (rendered prose + a few stale `%` comments):

- **Purged all rendered project-history tokens** — commit hashes (`b80f227`), `iter-NNN` references, "axiom-clean since iter-", "removed as dead code", and bare Lean filenames (`StandardSmoothDimension.lean`) used as narrative — replacing each with timeless phrasing or deleting the clause.
- **Corrected the now-false status claims** — every passage asserting Stacks 00OF is missing / that the general-point 00OE case "remains open, gated on 00OF" / that the regular-stalk route is blocked now instead states that regularity holds at *every* prime, Serre-free, via the trdeg–height route (`thm:standard_smooth_regular_at_prime`, `subsec:smooth_prime_regularity`) citing Stacks 00TT. I also removed the unnecessary "localise a regular local ring" (00OF) step from the `localRing_dvr_of_codim_one` proof so it uses direct per-point regularity.
- **Deleted the pure formalization-status blocks** — the `\paragraph{Mathlib API state (commit b80f227)}` itemize, the `\paragraph{Cascade to consumers}` residual-sorries itemize, the "two remaining post-Stage-6 gaps" paragraph, and the `\paragraph{Mathlib readiness audit}` itemize.
- **Reframed narrative** — the Stage-5/6 intro paragraphs and the "(superseded decomposition)" subsection now read as timeless math rather than staged formalization history.

Integrity checks: **no `\label`, `\lean`, or `\uses` was altered or removed** (the one `\lean{...}` inside a deleted range was in a `%` comment, not an active pin). Environment `\begin`/`\end` counts balance at 96/96, and all cross-reference targets I introduced (`thm:standard_smooth_regular_at_prime`, `subsec:smooth_prime_regularity`, `subsec:stage6_subgap_decomposition`) resolve.

Reported as inbox item **I-0050** (`--kind info --author ground`, scoped to project Albanese, title line "[bp-tidy T6] CodimOne history/status purge").

One note for you: I left the lemma node *titles* that read "[Stage 1 --- …]", "[Stage 5a --- …]" etc. untouched, since altering a node's title risks touching its statement — these are internal enumeration labels, not history/hash/filename tokens, so they fall outside the purge scope and the hard constraints.
