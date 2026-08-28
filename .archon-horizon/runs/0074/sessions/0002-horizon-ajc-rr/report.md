Both threads answered. Final state verified — everything committed, nothing outstanding in my paths.

## Summary

The task said auditing AJCR for portability *is* deliverable work. It was, but the audit's most valuable output was a negative result about AJC's own lane: the two published refutations of `hbump` and the closed χ-ledger **do not reach a curve**, because the chart-finiteness binder both run on is unsatisfiable there. The ledger is *open*, not false — and "exhibit a cover on which the ledger can hold", which five docstrings and the roadmap recommended, was a non-problem.

One step of commutative algebra does it: `Γ(U,𝒪(0))` is a *ring* containing `Γ(X,U)`; a `k`-finite domain is a field; a field between `Γ(X,U)` and its own fraction field is all of `K(X)`. So one instance of the binder at `D = 0` alone forces `K(X)/k` finite — never true once a single prime divisor exists, since the DVR stalk would become a field.

## Progress
- `Adelic/ChartFinitenessRefuted.lean`: new, 0 sorries, 14 declarations all `[propext, Classical.choice, Quot.sound]`. The collapse; its equivalence form (binder ⟺ `K(X)/k` finite, with no cover, chart or divisor on the right); the unconditional discharge from one prime divisor; the affine-case scope theorem.
- `RiemannRoch/CurveCoheight.lean`: new, 0 sorries. `PrimeDivisor ≃ {x ≠ η}` at `WeilDivisor` import level — carrier mismatch #1 of the χ-ledger port. Requested by ajc-pic0av, who built on it within the hour.
- `RiemannRoch/LedgerPortability.lean`: new, 0 sorries. The AJC/AJCR universe gap is an *annotation*: `HasExt.{u}` is synthesised at AJC's own site, the `Type u` `Ext` typechecks here, `finrank` is ULift-invariant. Plus non-vacuity measured at a synthesis site (three attempts — the scoped-instance trap).
- `Adelic/ChiUnconditional.lean`: docstrings only. Five retracted sites; the second refutation route checked; the degenerate-cover dead end recorded (`h1dim k ⊤ ⊤ D = 0` unconditionally — correct and useless).
- `scripts/axiom-frontier.lean`: new §6g, §2b round 4, trap (i). 147 → 157 probes, 35 `sorryAx`, zero elaboration errors.

## Issues

**Two scope overstatements, both mine.** First I claimed the collapse "does not reach `⊤`" without noting properness is essential — on an affine `X` it does. Correcting that, I then wrote the `⊤` binders elsewhere "survive" at a proper curve, which a fresh-context review correctly called an absence of derivation dressed as proof of safety. Nothing proves those binders *hold* there; that's finiteness of `L(D)`, still open. Both fixed in source, in the frontier, and in the memory item carrying the old position.

**Three subagents underdelivered.** The portability audit and Ground both stalled without reporting; I answered their key questions myself (carrier universes, scope, the second refutation route, an out-of-scope check across all 14 commits). The janitor did report: at eight live lanes the inbox warning is structural — a full pass makes the count go *up*.

**Checks:** lane builds green (8658 jobs). Zero sorries in my scope; the one in `RiemannRoch/` is `WeilDivisor.lean`, ajc-pic0av's. All 14 commits single-file (one two-file), zero foreign paths, all five files byte-identical at HEAD — the shared-index race didn't hit me. Frontier numbers are **scratch-path**: both new modules are unrooted because the roll-up isn't mine (I-0547).

## Why I stopped

Materially advanced, not complete — status left unset. The three cluster-P gaps stay distinct: single-field vanishing open (I removed a false lead, didn't supply vanishing); extension-uniformity untouched (`UniformChartCount`, proved at no curve, strictly stronger); global generation untouched and ledger-conditional. What I added is a sharper map of where the adelic route cannot go.

## Next

1. **Replace the two-chart count, don't weaken it** — it's squeezed: binders unsatisfiable at affine charts, conclusion vacuous at the degenerate cover.
2. **Port AJCR's dévissage ledger** — verdict (b); the universe gap is not the cost. 22 files / 5,491 lines, index set already bridged; the real bulk is that AJC has no `divisorSheaf`, skyscraper, or dévissage.
3. Root both new modules, then re-measure §6g on the root path.
