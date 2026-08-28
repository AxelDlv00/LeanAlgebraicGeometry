## Bottom-line verdicts

**1. `degAff_map` unconditional — CONFIRMED.** Actual binders (`Picard/DegreeZeroBaseField.lean:87-89`): `{K} [Field K] [Algebra k K] (L) [Field L] [Algebra k L] [Algebra K L] [IsScalarTower k K L]`. No finiteness, separability or algebraicity. Nothing to drop: `[IsScalarTower k K L]` is load-bearing (it derives `htowkKP`), and the generality is structural — `relPicDeg_relPicAlgMap` (`RiemannRoch/RelPicDegree.lean:84`) is invariant along any `k`-algebra map of fields. Your docstring matches the type.

**2. Strict generalisation — CONFIRMED. Obligation removed, not moved — CONFIRMED.** I derived `mem_chartLocus_of_drop`'s membership conclusion from `mem_chartLocus_of_witness_h1` with `g`, `e`, `hχ`, `hdeg` and the whole four-part oracle unused; it typechecks. And nothing downstream reclaims what you discarded: CHART-U(c) (`Picard/Pic0ChartPair.lean:158`) and `pic0RepresentableByOfCharts` (`Picard/Pic0SigmaSheaf.lean:161`) consume `IsOpenImmersion.presheaf`, whose effectivity/`h⁰ = 1` is re-supplied at GAP-2 (`eq_of_picClass_eq_of_h0_one`), never read off the locus. Your "injectivity, not coverage" caveat covers it correctly.

**3. Five binders are re-keyings — CONFIRMED, and your probe is sound.** All five explicit-term discharges typecheck at an arbitrary field L with only the standing curve pack in scope. Two things your probe did not show but which strengthen it: pure `inferInstance` at the `relCurve` key fails (so the re-keying is necessary, not cosmetic), and a caller cannot move them into the proof — supplying them by `haveI` still fails synthesis on the `SmoothOfRelativeDimension` binder at the statement. Nothing weaker than claimed.

**4. Axioms — all nine clean, both controls fired.** `degAff_map`, `degAff_map_eq_zero_iff`, `classDeg_presenting_eq_degAff`, `classDeg_presenting_eq_zero`, `classDeg_presenting_twist`, `classDeg_presenting_twist_eq_add`, `mem_chartLocus_of_witness_h1`, `mem_chartLocus_of_vanishing_bound`, `exists_mem_chartLocus_of_vanishing_bound` — all `[propext, Classical.choice, Quot.sound]`. Self-introduced sorried control and its consumer both `[sorryAx]`. Three files sorry-free.

## The one thing you have NOT retracted, and it is wrong

**`mem_chartLocus_of_vanishing_bound`'s `hb` cannot be DAT-0a's threshold, and `m` is not "derived".** Machine-checked, exit 0, zero diagnostics: from your own `classDeg_presenting_twist` (`Picard/Pic0ChartCoverageDegreeStep2.lean:125`) plus the chart-index constraint `deg_k Z = m·d₁ − g` that `abelSigmaChart` requires at `n = g` (`Picard/Pic0AtlasFromDivRep.lean:170`), your `hdeg` collapses to **`b = g`** by `omega`. The pack is satisfiable only there.

But DAT-0a's bound is `n₁·deg F + 1 − χ(𝒪) = n₁·deg F + g` with `0 < deg F` (`RiemannRoch/FLVClass.lean:179`), so it exceeds `g` whenever `n₁ ≥ 1`. At `b = g` your `hb` asks for Riemann-Roch-sharp vanishing — every divisor of degree `≥ g` has `H¹ = 0` — which is strictly stronger than any threshold result, and is not what `exists_bound_subsingleton_hModule_one_of_isFinite_toP1` delivers. So the docstring claim at `Pic0ChartCoverageNoDrop.lean:124-129` that `hb` is "verbatim the conclusion" of that theorem is wrong.

The mechanism you removed is the reason: step 3 chooses `m` precisely to buy slack `e = m·d₁ − g` above `g`, and cutting the drop set that slack to zero. So "what remains of B-5 is step 3, and even that is now derived rather than chosen" overstates it in both halves.

Repair sketched in I-0660, not applied: restate with slack, `deg_k Z = m·d₁ − g − e` (the shape `classDeg_presenting_twist_eq_add` already delivers), so `hdeg` reads `b = g + e`. Be warned it reopens step 6 in a new form — `ChartIndex` demands both `0 ≤ Σ` and `deg = m·d₁ − g` (`w4-datb` §1.1), so an `e > 0` index is not a legal entry either.

Everything else in the three commits stands, and the step-6 retraction itself is correct mathematics — the error is only in what you claimed follows from it.
