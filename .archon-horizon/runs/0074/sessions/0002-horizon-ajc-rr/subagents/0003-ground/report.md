All work is complete; nothing in flight. Everything below rests on reads and kernel checks that already finished.

## (a) VERIFIED

### Item 2 (scope) — corrected version is CORRECT; your consequence is accurate but UNDERSTATED

The version in the brief you handed me (`cbebbc2fe`) was overstated, and your self-correction fixed the right thing. Reading the corrected code independently:

- `IsAffineOpen U` is load-bearing and used **exactly once**, at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean:234` (`chartRing_isFractionRing hU` inside `chartAlg_eq_top_of_isField`). Verified by reading, not inferred.
- `not_chart_finite_top_of_isAffine` at `ChartFinitenessRefuted.lean:396` elaborates and is axiom-clean (`[propext, Classical.choice, Quot.sound]`).
- The collapse does **not** reach `⊤` without affineness. I ran `exact?` on the goal `¬ Module.Finite k (sectionSub k ⊤ 0)` for (i) a bare integral/regular-codim-1 `X` with a prime divisor and (ii) an `X` carrying an `AffineCoverMVSquare` (whose `cover : U₁ ⊔ U₂ = ⊤` does *not* make `⊤` affine, since `AffineCoverMVSquare` at `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean:51-63` asserts affineness only of `U₁`, `U₂`, `U₁ ⊓ U₂`). Both failed to close. So non-affineness is genuinely what protects the `⊤` binders.
- The three consumer files carry **no** `IsProper` binder. Confirmed by grep: the only `IsProper` occurrences in `RiemannRoch/Adelic/` are in `ResidueField.lean:690,707,732` and `FiniteMapToP1.lean`, none in `GlobalGeneration.lean` / `LedgerClosure.lean` / `SectionBounds.lean`.

**Where your corrected claim is understated.** The published theorem only kills the binder at `D = 0`. Two extensions compile and are stated nowhere:

```lean
-- the ∀ D form dies on affine X, not just the D = 0 instance
example [IsAffine X] [Nonempty (X : Type u)] (P : X.PrimeDivisor) :
    ¬ (∀ D : X.WeilDivisor, Module.Finite k (sectionSub k (⊤ : X.Opens) D)) := by
  intro h; exact not_chart_finite_top_of_isAffine k P (h 0)
```

plus the same for every **effective** `D`, via `Module.Finite.of_injective (Submodule.inclusion (sectionSub_mono k ⊤ hD))`. Both elaborated cleanly. So the affine-case vacuity covers the `∀ D` top binders at `GlobalGeneration.lean:431,460,670`, `LedgerClosure.lean:356`, `ResidueField.lean:543,848` — not merely the single-divisor ones at `GlobalGeneration.lean:253,381` and `SectionBounds.lean:266,284,302,408`.

Verdict: **confirmed** for the corrected claim, and your "vacuous at the affine members, fine at a proper curve" reading is accurate. The docstring at `ChartFinitenessRefuted.lean:78-90` is honest about it.

### Item 1 — CONFIRMED, step by step

Each link verified by reading:
1. Ring structure: `chartAlg` at `ChartFinitenessRefuted.lean:213` over carrier `sectionSub k U 0`; `mul_mem'` is `sectionSub_mul_mem_zero:192`, which correctly uses `order_mul_of_ne_zero` with both zero cases split off. Sound.
2. Contains `Γ(X,U)`: `algebraMap_chart_mem_sectionSub_zero:179` via `order_algebraMap_chart_nonneg:166`, which routes through the stalk scalar tower and mathlib `HeightOneSpectrum.valuation_le_one` (`:147-160`). Needs **no** affineness — correct, the tower exists for any open containing the point.
3. `k`-finite domain → field: `fieldOfFiniteDimensional` at `:272`.
4. Field between `Γ(X,U)` and its fraction field is everything: `chartAlg_eq_top_of_isField:232`.

**`IsConstantField` is not doing hidden work.** It is required merely to *write* `sectionSub` at all — its `smul_mem'` at `AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean:489-499` consumes `order_algebraMap_eq_zero`. And it is discharged **unconditionally** for any integral, locally-Noetherian, regular-in-codim-1 `k`-scheme by `GateInstances.isConstantField_functionField:132` — no properness, no `B0`. So it is satisfied on the real curves and is not smuggling in the collapse.

**`Nonempty U` is sufficient.** It is verbatim `chartRing_isFractionRing`'s binder (`Adelic/Substrate.lean:267-269`); I applied it directly and it typechecked.

**The ring claim is not trivial.** `exact?` could not prove `sectionSub k U 0 = ⊤`, so the carrier is genuinely a proper order-nonneg subring and the collapse has content.

Axiom-clean, all `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.

### Item 3 — CONFIRMED, not an overcorrection

I went looking for the alternate route. The only other refutation in the tree is `LedgerClosure.not_bump_of_notMem_overlap` at `AlgebraicJacobian/RiemannRoch/Adelic/LedgerClosure.lean:547`, and it takes `hchiAdd` as an **explicit hypothesis**. Its only producer is `ChiLedger.chi_add:988`, which requires the four unconstructed exactness data (`window`, `connect`, `twist`, `htwist` at `:991-997`) — the gate the lane does not build. `chi_add_eq_residueDeg:1055` additionally needs `hPV : P.point ∈ U₀ ⊓ U₁` plus `hsurj`. So no curve-reaching `¬hbump` exists, and "open, not refuted" is right.

Corroborating: the chart-family binders `Module.Finite k (sectionSub k U₀/U₁ D)` appear **only** in `ChiUnconditional.lean` (lines 160-635) and nowhere else in `AlgebraicJacobian/`. The blast radius is exactly what you reported.

### Item 6 — CONFIRMED clean for this session's commits

Per-commit `git show --numstat` (full paths) on all 11 commits of this run — your 9 plus `1885c212d` and `b4d38fa91`, which were not in your brief — touched only:
- `AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean`
- `AlgebraicJacobian/RiemannRoch/CurveCoheight.lean`
- `AlgebraicJacobian/RiemannRoch/LedgerPortability.lean`
- `AlgebraicJacobian/RiemannRoch/Adelic/ChiUnconditional.lean`
- `scripts/axiom-frontier.lean`

No `WeilDivisor.lean`, no `Picard/**`, no `Jacobian.lean`/`AbelJacobi.lean`, no `Cohomology/**`, no `AlgebraicJacobian.lean`, no blueprint. Your note is right: `WeilDivisor.lean:1268` (the reference to your file), the root-import entries, and `CurveDivisorIndexBridge.lean` were all landed by `ajc-pic0av` under `Archon-Task: ajc-pic0av` (`d0f8f68d3`, `0f2c9ddb0`).

### Items 5 and 7, and cluster-P separation

**Item 5 — one real problem, not the one you asked about.** `finrank_uLift:82` and `hasExt_lower_of_scheme:108` are real and clean. `extLowerUniverse:97` is a `def` returning `Type u`, so "it elaborates" establishes that the lower universe is *available* to AJC — weaker than the header's framing implies, but it is the fact the audit needs, so not an overclaim. The actual issue: **`LedgerPortability.lean` has zero importers.** It is not in `AlgebraicJacobian.lean` and nothing in the tree imports it — verified by grep. That is the exact I-0362 invisible state your own root-import commit message calls out as having cost a lane. It elaborates and is axiom-clean only because I imported it explicitly in a scratch file.

**Item 7 — accurate.** No new overstatement in the five rewritten `ChiUnconditional.lean` docstrings; the "unconditional in exactness data only" scoping is correct throughout.

**Cluster-P gaps kept distinct — yes.** `ChartFinitenessRefuted.lean:119-123` and `UniformChartVanishing.lean:36-40` keep single-field vanishing (open; this file removes a false lead), extension uniformity (`UniformChartCount:69`, `b` quantified before `κ`, strictly stronger), and global generation (ledger-conditional) separate. No blurring.

### Second durable issue

`scripts/axiom-frontier.lean:1015-1022` is **stale**: it still says `ChartFinitenessRefuted` and `CurveCoheight` "are NOT yet in the root roll-up" and asks someone to root them and re-measure. `0f2c9ddb0` rooted both at 15:54, before your last two commits. The §6g measurement caveat should be retired and the numbers re-measured on the root path.

## (b) Inferred but not verified

- That the AJC curve of interest is non-affine (hence the `⊤` binders are genuinely safe there). I verified properness is *absent* as a binder in the three consumer files, and that `not_chart_finite_top_of_isAffine` needs `IsAffine X`; I did not trace the concrete AJC curve to a proof that its `⊤` is non-affine.
- That older `ajc-rr` commits from *previous* runs stayed in scope. I verified this session's 11 commits explicitly; the aggregate path listing over 30 grep-matched commits was truncated, so earlier runs are unchecked.

## (c) Not reached

- No root build, by instruction. All checks were narrow `lake env lean` on scratch files, now deleted.
- I did not audit the AJCR-side port cost figures in `LedgerPortability.lean:55-59` (22 files / 5,491 lines etc.) against the sibling repo.

## Highest-value next action

Root `LedgerPortability.lean` (request on I-0547/I-0493) and retire the stale §6g rooting caveat in the same pass. The mathematics is converging and the retraction is honest — including a scope error you found and fixed yourself before I got to it. What is now out of sync is bookkeeping, and the unrooted file is the single item that could silently become invisible work.

One housekeeping note: 13 untracked scratch `.lean` files (`GroundProbe*.lean`, `Probe3/4.lean`, `ReviewAx*.lean`, `ReviewProbe*.lean`) sit in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/` from prior sessions, none gitignored. Clutter only. I removed my own six.
