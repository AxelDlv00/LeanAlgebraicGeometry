Zero real sorry terms in `RiemannRoch/` — the earlier counts were the word in docstrings ("sorry-free"). Everything is verified and committed.

## Summary

Landed `RiemannRoch/Ledger/SectionDrop.lean` — the cluster-P section-drop and H¹-vanishing layer on the ported χ-ledger carrier: 506 lines, 19 theorems, sorry-free, kernel-checked, **15/15 axiom-clean including at the synthesis site**. The mathematical point was sitting in plain sight: the dévissage quotient is a *skyscraper*, so `H¹(sky) = 0`, so the six-term slice already in `ChiSlice.lean` makes `H¹(𝒪(D−x)) ↠ H¹(𝒪(D))` a theorem rather than a hypothesis.

A fresh-context review then falsified two of my claims, and correcting them **inverted the session's conclusion**: the base vanishing is not an open problem, it is an unported one — which makes the next step cheaper than I had reported, not harder.

## Progress
- `RiemannRoch/Ledger/SectionDrop.lean`: new, 0 sorries. Two-sided section drop `h⁰(𝒪(D−x)) ≤ h⁰(𝒪(D)) ≤ h⁰(𝒪(D−x)) + [κ(x):K]`; the drop **identity** (h⁰ gain + h¹ loss = residue degree exactly); H¹ vanishing upward-closed along any `D₀ ≤ D`; exact Riemann–Roch on the order-cone; `exists_bound_of_cofinal_vanishing`, reducing degree-threshold vanishing to one named cofinality hypothesis.
- `scripts/ajcrr-sectiondrop-axioms.lean`: new probe, **run**. All 15 declarations report `[propext, Classical.choice, Quot.sound]`, zero `sorryAx`. The three `probe_*_curve` lines are the ones that matter — measured where `ChiCurve` actually constructs both `Module.Finite` binders, not at the declaration.
- The peel chain needs **no finiteness**: 11 of 19 declarations `omit` both cohomology binders. The linter found that, not me. Hence `Subsingleton (H¹ …)` rather than `h¹ = 0`, which is vacuously true for infinite-dimensional H¹.

## Issues
**Two retractions of my own claims** (I-0623, verified against AJCR source before accepting, fixed at `b7383a4d5`):
1. My peel chain **re-derives** AJCR `FLVClass.lean`'s `peel_single`/`peel_nsmul_single`/`peel_effective`. I searched `SectionBound.lean`, found the weaker `finrank` inequality, and generalised one file to a project.
2. I reported the base vanishing "open at every curve, ℙ¹ included" and had committed a docstring measuring it. `FLVVanishing.lean:302` proves it on this carrier; my measurement was confined to AJC's own subtree.

**Rooting:** remeasured from the root *file* — closure 251 modules. `ChiLedger`/`ChiCurve`/`ChiSlice` are now in the root cone (side effect of another lane's leaf close), so I-0600's "41 files unrooted" is stale. `SectionDrop` is out, but its incremental cone is one file. I landed it without a root import because the roll-up is off-limits to me; declared on I-0624 rather than left for a janitor. My clean axiom lines are therefore scratch-path.

**Self-inflicted noise:** a stray `test-length-probe` comment on I-0493 while diagnosing silent comment failures (cause: the 1200-char limit). No comment-delete exists; C-0080 disavows it in place.

**Checks:** LSP clean throughout. Kernel check passed; every commit after it was machine-verified docstring-only (230 code lines byte-identical), so the claim holds at HEAD. Zero name collisions across AJC, AJCR, mathlib. Eight commits, all single-file, zero deletions, zero foreign paths; `WeilDivisor.lean` untouched; `RiemannRoch/` has zero real sorry terms.

## Why I stopped
Materially advanced, not complete — status left unset. `AJC.rr` stays `pending` deliberately, with a comment explaining why the "every sub-item is done" warning must not be followed: extension-uniformity has nothing landed against it.

## Next
1. **Port AJCR's fibre-divisor / finite-map-to-ℙ¹ layer** (`FLVVanishing.lean:302`) — now the highest-value item, and a port rather than a proof. `exists_bound_of_cofinal_vanishing` is already shaped to consume it: a tower `D + n·F` is exactly a cofinal family. Asked the AJCR lanes for its incremental cone on I-0495 rather than guessing it myself.
2. **Root `SectionDrop`** — one import line, zero other modules pulled in.
3. **Extension-uniformity** remains the genuine open problem; nothing this session touched it.
