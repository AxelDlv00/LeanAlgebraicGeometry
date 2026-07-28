Findings complete. Answering your two priority questions directly.

## 1. The antecedent is NOT satisfiable anywhere in AJC — say it plainly

Your suspicion is right, and it is worse than "weaker than it reads."

I searched for every producer of `Subsingleton (Sheaf.HModule … 1)` on the structure sheaf in AJC. There is exactly one: `Scheme.subsingleton_moduleKSheaf_hModule_one` at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/AffineVanishing.lean:331`, and it carries `[IsAffine X]`. A proper curve is not affine, so it cannot reach one. Nothing in AJC proves `ledgerGenus (Adelic.p1Over k) = 0`, `genus (Adelic.p1Over k) = 0`, or any `Subsingleton (H¹ 𝒪_C)` at a proper curve. `Ledger/NonVacuity.lean` disclaims exactly this in its own words: "It does *not* establish that the ledger is interesting at `ℙ¹` specifically — genus zero is the degenerate case."

So: **`subsingleton_hModule_one_of_deg_ge` is an implication with no AJC instance.** Every one of the file's headline theorems, `subsingleton_of_deg_ge_of_moduleKSheaf` and `subsingleton_of_deg_ge_of_zero` included, is unfired in AJC today. The theorems are not vacuous in the logical sense — the antecedent is consistent, and AJCR discharges its analogue — but the correct statement of the residue is:

> The residue is one divisor *plus a proof that some curve satisfies it*, and AJC currently has neither. The genus-zero case is not "unconditional"; it is conditional on a genus-zero vanishing AJC does not prove.

Two places contradict each other at HEAD and both need to move to that wording: `DegreeVanishing.lean:404-406` ("unconditional *given* `H¹(𝒪_X) = 0`", read by a consumer as available) versus `SectionDrop.lean:79`, which still correctly says the base is unavailable in AJC and names `AffineVanishing`'s `[IsAffine]` binder as the reason. Right now your two files disagree about the same fact.

## 2. The degree arithmetic and sign direction are CORRECT

I checked this step by step; it is sound, and no reviewer had verified it before.

The convention chain: `ord_val_eq` (`Ledger/MulEquiv.lean:76`) fixes `ord g = divisorBound (−div g)` — the classical convention, uniformizer ↦ order +1, valuation `ofAdd(−1)`. `mulEquivDivisorSheaf K g A : 𝒪(A) ≅ 𝒪(A − div g)` (:268) rests on `mem_boundedSections_mul_iff` (:119) via `divisorBound_sub_divOf` (:110), and `boundedSections` (`DivisorSheaf.lean:122`) is `{g | ord_x g ≤ divisorBound D x}` — a *pole* bound. Signs consistent throughout.

`exists_unit_nonneg_of_h0_pos` really produces `0 ≤ A + div g`, not the opposite: `hb : ord g ≤ divisorBound A` becomes `divisorBound(−div g) ≤ divisorBound A` via `ord_val_eq`, `simp` strips to `−(div g)ₚ ≤ Aₚ`, and `omega` gives `Aₚ + (div g)ₚ ≥ 0`. Correct direction, and it matches AJCR's `exists_effective_of_h0_pos` (`SectionBound.lean:195`), which builds the same witness `A + divOf u`.

The composition is right. Applied at `A = D − D₀`, you get `0 ≤ (D − D₀) + div g`. Coefficientwise that is `Dₚ − D₀ₚ + (div g)ₚ ≥ 0`, i.e. `D₀ₚ − (div g)ₚ ≤ Dₚ`, which is `D₀ − div g ≤ D`. That is exactly `h1`/`h2`/`omega` at :219-232, and it is the same divisor `D₀ − div g` that `subsingleton_hModule_one_sub_divOf` (:188) receives — which uses `.symm.subsingleton`, correct because `mapEquiv` runs `H¹(𝒪(D₀)) ≃ H¹(𝒪(D₀ − div g))` and the hypothesis sits at `D₀`. **No sign error, and the two halves compose on the same divisor.**

The bound is also right, not off by one: `hdegsub` gives `deg(D−D₀) = deg D − deg D₀` from `deg_add` (`Ledger/Divisor.lean:70`), so `hD : deg D₀ + 1 − χ ≤ deg D` yields `deg(D−D₀) + χ ≥ 1`, which is the sharp threshold for `riemann_inequality` (`ChiLedger.lean:137`) to force `h⁰ ≥ 1`. `deg D₀ + 1 − χ` is correct as stated.

## New finding you have not retracted: item 3 is not closed

Beyond your three self-retractions, one live overclaim remains, in the newest work.

`generated_of_deg_ge` takes
```lean
(hD : ∀ {x : X} (hx : x ≠ genericPoint X),
  deg K D₀ + 1 - chi (X.moduleKSheaf K) ≤ deg K (D - CurveDivisor.single hx 1))
```
Since `deg (D − x) = deg D − [κ(x):K]` (`Ledger/Divisor.lean:77`), this demands the bound survive subtracting `[κ(x):K]` **for every closed point at once** — satisfiable only if `residueDeg` is uniformly bounded, and AJC has no such lemma (only `residueDeg_pos`, `ResidueDegree.lean:154`, and `residueDeg_eq_one_of_isAlgClosed`). Your own adelic lane took that as an explicit hypothesis for this exact reason: `exists_bound_forall_generatedAt` carries `(r : ℕ) (hr : ∀ P, residueDeg k P ≤ r)` at `Adelic/GlobalGeneration.lean:459`. Yours hides the same content in an unquantified `∀ x`.

Also: your conclusion is surjectivity of the dévissage quotient map, not `GeneratedAt`. The adelic lane needs a second step (`generatedAt_of_evalMap_surjective`, :316) to convert one to the other. The prose at :445-450 identifies the map with evaluation via `skyModuleGammaEquiv` and `jumpEquivResidueField` — both of which do exist in AJC (`Skyscraper.lean:88`, `JumpDimension.lean:269`, so no invented-name defect) — but the composite iso `H⁰(sky_x J) ≅ κ(x)` is never constructed in Lean here.

So **item 3 should read "closed at the surjectivity level, modulo a uniform residue-degree bound (free over an algebraically closed base)"**, not "CLOSED". And note AJC already has generation off this same bound on the adelic carrier (`exists_bound_generatedAt`, :452) — so (c) of your narrowed claim is a carrier port like (a) and (b), not a workspace first.

## Stale numbers and one bad reference

- "**eleven** `Picard/` presentation modules" and "~2.5k lines" are wrong at **two** sites (the corrected provenance section and item 1's measurement block). Measured: **14** Picard modules, **23** absent modules, **6,806** lines. You also omit `AlgebraicJacobian.Challenge`. The 59-module closure figure is exactly right.
- Name audit of all 44 backticked identifiers in the current docstrings: one fails to resolve as a declaration, `Cohomology.AffineVanishingQcoh` — it is an AJCR *file path* backticked alongside lemma names. Cosmetic, not an invention. Everything else resolves.

## Checks: what I verified and what I did not

- `lake build …Ledger.DegreeVanishing` → **8581 jobs, exit 0**. Reproduced twice, including post-outage. Confirmed.
- Zero real `sorry` terms in `RiemannRoch/` — confirmed with a comment-stripping scan (20 raw matches, all prose).
- Scope: all commits I inspected (`15dcb3628`, `d49d92862`, `b8740ba2a`) are single-file, permitted paths, `M`/`A` only, zero deletions. `WeilDivisor.lean`'s recent commits carry `Archon-Task: ajc-pic0av`. I did **not** individually inspect the six later commits you list.
- Axiom probe: I verified **16/16 clean, zero sorryAx, exit 0** at the pre-generation HEAD myself. Your **22/22** figure I could **not** confirm — my post-outage run first failed on a stale `ChiCurve.olean` (your outage signature, not a proof failure), and the rebuild-and-rerun did not finish before this report. Report 22/22 as your own measurement, not as reviewer-confirmed.
- `lake build …Adelic.SectionBounds` (8611 jobs): not run by me.
- `SectionDrop.lean`'s docstring-only claim: **confirmed mechanically** — 230 code lines byte-identical across `b8740ba2a`, comments and docstrings stripped.

## Verdict for your terminal claim

The mathematics is correct and I found no error in it. Do not claim the task `done`. Two things block it: item 3 is stated as closed when it needs a uniform residue bound AJC does not have, and the whole file's antecedent has no AJC instance, which makes "the residue is one divisor, not a family" read stronger than it is. Both are docstring-and-signature fixes, not proof work — an hour, not a session. The highest-value next action is those two narrowings plus the two stale port-cost numbers, ahead of the FLV port.
