Audit complete. Filed I-1349, I-1350 (issues), I-1351 (memory). Probe files deleted; nothing in the project touched.

# VERDICT: real work, but the headline is a re-derivation and two docstring absence claims are FALSE

`Pic0ChartCoverageThreshold.lean` is not stuck and not churning — 6 declarations, 0 sorries, all axiom-clean `[propext, Classical.choice, Quot.sound]` against a `sorryAx`-firing control. But the *reason it matters*, as written, does not survive. The genuinely new content is one composition (the coverage-side plumbing), not the threshold, and the file's own framing gets its central absence claim backwards.

## Findings

**1. CONFIRMED — the docstring's claim (a) is FALSE. `relCurve C L ⟶ P1 L` is three `haveI`s away, and DAT-0a IS instantiable at L.**

Line 26 (`There is no relCurve C L ⟶ P1 L anywhere in this tree, so a lane trying to instantiate DAT-0a at a splitting field is trying to build a morphism the project does not have`) and lines 133-135 are false. Probe: `exists_isFinite_isDominant_toP1 (C := baseChangeBundle C L)` after installing `instSmoothOfRelativeDimensionSndLeft` / `instIsProperSndLeft` / `instGeometricallyIrreducibleSndLeft` (all landed in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/BaseChangeInstances.lean`) — **EXIT=0**. Full DAT-0a at L (`exists_bound_subsingleton_hModule_one_of_isFinite_toP1`, exists-b over `(C ⊗ overSpec k L).left`) — **EXIT=0**. The single extra binder `LocallyOfFiniteType` is `infer_instance` from base-changed smoothness — **EXIT=0**. The grep was for the arrow; the answer was an `exists_` producer quantified over curves. This false sentence is now propagated into `Pic0ChartCoverageIndexSlack.lean`, `Pic0ChartCoverageNoDrop.lean:47-57` (commit 65d8e29aea), I-1329, and the roadmap summary — in every case as *the half that stands*.

**2. CONFIRMED — claim 1 is a strictly weaker corollary of a lemma landed 2026-07-19.**

`subsingleton_h1_of_windowA_le_deg` (`AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean:259`, commit 596c82e906) is already the uniform, π-free, per-field-extension threshold, same `subsingleton_hModule_one_of_witness` peel, bound `windowA_choice·δ + g`. Probes: `windowA_choice π hπ ≤ windowM_choice π hπ g` via `Nat.find_le (windowBound_le_M_mul π hπ g)` hence `a·δ ≤ M·δ` — **EXIT=0**; `subsingleton_h1_of_ledger_bound` re-derived from it in three lines — **EXIT=0**. The new bound is *larger*, i.e. weaker.

**3. CONFIRMED — the coverage composite also goes through at the smaller landed parameter.** `mem_chartLocus_of_ledgerIndex` re-proved at `a·δ + g` from `mem_chartLocus_of_vanishing_bound` + `subsingleton_h1_of_windowA_le_deg` + `classDeg_presenting_twist` alone — **EXIT=0**, script identical modulo the constant. So even the composition is not tied to `windowN`; only the choice of constant is, and it is the worse choice.

**4. CONFIRMED — claim (b) is technically true but measures the wrong thing.** `windowN` and `subsingleton_hModule_one_of_witness` genuinely have zero occurrences in `Pic0Chart*` outside this session's three files. But `windowA` also has zero occurrences there, and *that* is the name carrying the equivalent fact. A name-scoped novelty check cannot see a same-content lemma under a different name.

## What SURVIVES your attacks

- **Vacuity of the conclusion: SURVIVES.** `Subsingleton (HModule (divisorSheaf L D) 1)` for arbitrary `D` is not synthesizable — `infer_instance` fails (typeclass heartbeat timeout, no instance path). Not vacuous.
- **Bound reachability: SURVIVES.** Constructed an explicit witness: `windowTransportDivisor C L π (M + g)` has `deg = (M+g)·δ ≥ M·δ + g` by `one_le_windowδ`, and the file's own theorem then applies to it — **EXIT=0**. Hypothesis inhabited, conclusion a real instance.
- **`hχ` load-bearing: SURVIVES, with a sharpening.** `chi_moduleKSheaf C` forces `χ = 1 − genus C`, so `hχ` is exactly `g = genus C`; it is not removable, but it *is* dischargeable at `g := genus C` by `chi_moduleKSheaf C` with no hypothesis — **EXIT=0**. So it is load-bearing as a *binder*, free as an *obligation*.
- **Overstated/understated generality: SURVIVES.** Claim 1 needs the `relCurve`/base-change carrier for `windowN` and `chi_relCurve`; it does not generalise away. The author already applied this test correctly to `genus_eq_zero_of_ledgerParam_eq_genus`, relocating it to abstract `Y/K`.
- **Axiom cleanliness: SURVIVES.** All six declarations `[propext, Classical.choice, Quot.sound]`, control firing `sorryAx` in the same file.
- **Claims (c): SURVIVES.** No antecedent of `pic0RepresentableByOfCharts` is closed; `hb_forces_h0_eq_one` is untouched. Correctly and repeatedly stated.

## On your reduction question (`hZ` vs `(hb, hdeg)`) — it is a restatement, not a weakening

`hZ` is the chart-legality constraint `deg_k Z = m·d₁ − n` at the *specific* `n = M·δ + g`. Probe: `hZ` together with the general legality constraint at parameter `n` forces `(n : ℤ) = M·δ + g` — **EXIT=0**. So `hZ` does not make anything more available; it *pins* the chart parameter to the same number `ledger_forces_b_eq_n` derives from `hdeg`. The theorem is `mem_chartLocus_of_vanishing_bound` with a number substituted, plus the free `hb`. That is a legitimate composition and worth having in Lean, but calling it "BOTH numeric inputs DISCHARGED" oversells: the numbers were not eliminated, they were fixed, and a divisor `Z` of prescribed degree is still assumed (the docstring at line 302-305 says this correctly).

Also worth noting: the author's own `genus_eq_zero_of_ledgerParam_eq_genus` proves the delivered parameter equals `g` only when `g = 0` — an honest, well-stated limit. But it is stated at `M·δ+g`; at the smaller landed `a·δ+g` it needs re-deriving, and that is where a next lane should test whether the parameter gap is as wide as claimed.

## Files

- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartCoverageThreshold.lean` (audited; lines 26, 133-135 false)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeSeedUnivFibre.lean:259` (the duplicated lemma)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/MapToP1.lean:126` and `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/BaseChangeInstances.lean` (the producers that refute the absence claim)
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartCoverageNoDrop.lean:47-57` and `.../Pic0ChartCoverageIndexSlack.lean:64-89` (where the false sentence was propagated)
