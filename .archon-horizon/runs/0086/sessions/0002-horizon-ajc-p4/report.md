Everything durable is at HEAD: three Lean files, and the roadmap row with `owner` absent (released) and the three-obligation text. Nothing of mine is dirty.

The row reached HEAD via another lane's integrate sweep (`adf9fddc7`) rather than my own commit — the same shared-index mechanism I filed as I-0892, this time in my favour. Worth noting since I had just been blocked by the deletion guard on the very same file.

## Progress

- `Picard/PointRankSemicontinuity.lean`: new, 2 theorems, 0 sorries, axiom-clean. `isOpen_pointRank_le` — `{s | pointRank S F s ≤ e}` is open for `F` finitely presented quasi-coherent on locally noetherian `S`, **no flatness**; plus `isClosed_le_pointRank`, the superlevel form milestone B6 consumes.
- `Picard/PointRankSemicontinuityWitness.lean`: new, 2 theorems, 0 sorries, axiom-clean. Non-vacuity on the campaign's own datum — fires on `(π_A)_* L` for `L` merely *locally trivial* on `C_A`, no h¹ hypothesis.
- `Picard/FiberH0Comparison.lean`: new, 1 theorem, 0 sorries, axiom-clean. `fiberRank_gammaTop_eq_fiberH0` — the fibre-h⁰ comparison with `hproj` **and** `hfin` removed.
- Roadmap `AJC.picrep.semicontinuity`: created, claimed, and released with the refuted route and three remaining obligations recorded.

**Which item, and why fourth-most-important.** Campaign milestone B5, targeting `Scheme.HasH0Semicontinuity` — kernel-confirmed to have *no instance*, so its consumers currently prove nothing about any curve. It gates four milestones (B4, B6, J1, J4), and its stated prerequisite B3 already exists as a genuine axiom-clean unconditional instance for the AJC curve. That is the category the brief ranks above both "unblocks three others" and "merely nearest". No collision: p1 took D2′, p2 took P5.

**State: advanced, gate open, obligations named.** I did not close, weaken, move, or delete `HasH0Semicontinuity`. Three obligations remain, and I found the third only by asking for adversarial review of my own work:

- (a) `hbc` without h¹-vanishing — not free; `A = ℤ`, `d = ·2`, `B = ℤ/2` refutes it with both terms flat.
- (b) finite-dimensionality of `ker d` — `finrank` is junk `0` infinite-dimensionally on both sides, and the original's defence against a vacuous `0 = 0` ran entirely through the `hfin` I dropped.
- (c) a carrier bridge: my `Ideal.fiberRank` conclusion is **not the same term** as `Scheme.Modules.pointRank` — `rfl` fails, different ring and prime — and the only in-tree lemma relating them carries the `Flat`+`Finite` binders this work drops.

## Issues

- **The gate's prescribed route is refuted** (I-0884). `SemicontinuityH0.lean:55-57/:86-92` and `TwoTermFiniteFree.lean:12` both point a future lane at the B3 two-term minors. That cannot work: the bridge carries `hproj`, which the file itself proves load-bearing, and finite projective forces the rank *locally constant* — strictly stronger than the semicontinuity wanted. The prescription inverts the difficulty.
- **`FiberH1Vanishing` has no producer**, so every B3 *lemma* gated on it has never been applied to concrete data (the project records this at `RigidPushforwardP1Witness.lean:50,:264`). B3's *gate* is genuine and axiom-clean — the distinction matters for costing B3-gated work.
- **Two of my own docstrings overclaimed** (I-0949), corrected in `c5f4b684f`. The Lean was never wrong; the prose was.
- **I caused an I-0889 revert and repaired it** (I-0892, `ccbd747fd`): explicit-pathspec `add` then bare `commit` shipped four of review-ajcr's rows as a rollback. `add` bounds staging, not the commit. review-ajcr confirmed their rows are intact.
- **A stale `index.lock` blocked eight commit attempts** while other lanes committed normally (I-0946) — other tooling writes through its own index file. Removed only after four independent staleness checks.

## Why I stopped

Partly advanced, and I am not reporting it as complete: the gate has no instance and three named obligations stand. What is done is sorry-free, kernel-verified, axiom-clean, and non-vacuously witnessed on real curve data. Final build of all three modules: EXIT=0, no errors, no sorry warnings from my files. Claim released so the next lane can take it without re-deriving the chart-locus argument or retrying the refuted route.

## Next

Attack (a) via the lead recorded in the file: `TwoTermFiniteReplacement.h0_bijective` holds for *every* algebra with **no** surjectivity hypothesis, and `exists_twoTermFiniteReplacement` needs only noetherian + flat + f.g. cohomology. It compares the H⁰s of the replacement and original complexes rather than one map's `kerBaseChange`, so it does not immediately give `hbc` — whether it can be made to is the open question. (c) is likely cheapest: a `ΓSpecIso` transport of the kind steps 2 and 6 already perform by hand. Also free: the review showed the non-vacuity witness can be made fully concrete (curve, `A`, `L` instantiated rather than quantified).
