Confirmed independently: the sibling's port exists, 178 lines, sorry-free, and genuinely a different proof (line-bundle triviality on a one-point space, not Čech vanishing). The idea transferred across projects within the hour — which is what the cross-project thread exists for.

Final state: everything committed, index clean, worktree identical to HEAD, root build green at 9152 jobs.

## Summary

Advanced Wave 5's **T4** — the lane's flagged-risk item, and the block every remaining Wave-5 target funnels through — from one opaque residue both projects were staring at to **one surjectivity statement with all its inputs already landed**. Six commits, all sorry-free, root build green at **9152 jobs, exit 0**, axiom probes clean (`propext`, `Classical.choice`, `Quot.sound`; no `sorryAx`).

## Progress

- `informal/w5-t4-worksheet.md`: +§6, §6.6, §6.7 — worksheet written before every Lean edit, as the task binds for T4. Split clause (iii) into (iii-a)/(iii-b)/(iii-c), then split (iii-c) again.
- `Tangent/RelPicPointTest.lean` (new, 152L, 0 sorries): `picFromBase` is **trivial at any one-point test object**, so `relPic C T ≃* CechPic (C ⊗ T)` at both ends of the ε-restriction — plus the compatibility square intertwining `relPicMap` with `CechPic.map`.
- `Tangent/TwoChartCechPic.lean` (new, 460L, 0 sorries): **(iii-a)** `twoChartClass` and **(iii-b)** `twoChartClass_injective` — the two-chart Čech Ȟ¹ of units embeds in the Picard group, scheme-general. Plus the (iii-c1) substrate and the left-inverse lemma pinning its target.
- Coordination: posted to both threads; answered ajc-rr's direct question about finiteness binders (checked all 20 files — my binder is global H¹, not chart sections, so their vacuity finding doesn't reach Wave 5); three memories written.

Two findings worth naming. The `picFromBase` collapse my own worksheet had priced as commutative algebra is **topological** — a one-point space has no cover with a nontrivial overlap — and the lemma had been in the project's own `Pic.lean` all along. And I shipped that reduction with a claim that was true but *unusable*: an isomorphism of the groups at each end of a map says nothing about the map, and the consumer computes a kernel. `381a8050a` adds the square; I caught it by asking what a reviewer would ask, before the reviewer did.

## Issues

- **Two background helpers (a diff reviewer and a janitor) never reported.** My verification therefore rests on my own kernel build and axiom probes, not independent review — the fresh-context check the skill requires before a terminal `done` claim did not complete. That is a reason I am not claiming completion, and the next session should not treat these files as externally audited.
- Three roadmap consistency warnings persist (16 active items; two AJC parent/child mismatches). They concern the sibling project's rows; I dispatched the janitor rather than edit another lane's state.

## Why I stopped

**Partly advanced, not complete.** The numeral `dim T₀(d.J) = g` still needs (iii-c1)'s cohomology relation plus (iii-c2). I stopped rather than start (iii-c1) because it is bounded by `subst` bookkeeping repeated four times and the LSP import cache went stale mid-probe from a sibling's build — pushing on meant risking a half-proved declaration left uncommitted, which this workspace loses. S1 remains a hypothesis by design; S3 unstarted; **P1 untouched and still gated on the DD freeze**, as instructed.

## Next

(iii-c1): prove the normalization for **abstract** chart indices with pair values passed as arguments — the shape that worked for (iii-b) — then instantiate. The normalizing 0-cochain is machine-verified to construct but deliberately *not* in the tree; §6.7 separates what landed from what was only probed, so nothing there should be over-trusted. Then (iii-c2), which is assembly from three landed inputs rather than construction.
