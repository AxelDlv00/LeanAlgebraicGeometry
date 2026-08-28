Everything verified. The task objective is materially advanced but not complete (the three inputs remain open), so I'll leave the status unset so it returns to the queue.

## Summary

Landed the cluster-P Riemann–Roch substrate into AJC as three new sorry-free modules under `AlgebraicJacobian/RiemannRoch/Adelic/` (1505 lines), all keystones axiom-clean. The decision, theorem by theorem, was **rederive adelically** rather than port: AJCR's 17.8k-line development is built on `CurveDivisor`/`divisorSheaf`/`Sheaf.chi`/`CechPic`, which occur **zero** times in AJC — the substrates share no identifiers, so nothing was portable. What I reused were arguments, and one turned out cheaper in the adelic form than in AJCR's.

## Progress

- `Adelic/ClassInvariance.lean` (new, 393L): multiplication by `g ∈ K(X)^×` is a `k`-linear automorphism carrying `Γ(U,𝒪(D))` **onto** `Γ(U,𝒪(D−div g))` and the coboundary onto the shifted coboundary, hence `Ȟ¹(D) ≃ Ȟ¹(D−div g)`. Gives `ell/h1dim/chi_eq_of_linearEquivalence` **unconditionally** — no gate, no finiteness, no ledger-exactness. AJCR's sheaf-level route needs the χ machinery even to *state* the transport. Plus the effective-witness dictionary.
- `Adelic/SectionBounds.lean` (new, 507L): residue-weighted degree `degK` as a bundled hom; residue-degree positivity `1 ≤ [κ(P):k]` proved from the project's own `orderGe` filtration; `degK_pos_of_nonneg_of_ne_zero`; the section-drop sandwich `ℓ(D) ≤ ℓ(D+P) ≤ ℓ(D)+[κ(P):k]`, **unconditional** — the ℓ-half of the ledger needs neither the connecting data nor strong approximation. Closed-ledger consequences take `hledger` as a named hypothesis, never a gate class.
- `Adelic/BoundedVanishing.lean` (new, 605L): single-field bounded H¹ vanishing with explicit `b = deg_k D₀ + 1 − χ(0)`; `exists_bound_ell_eq` upgrades ℓ from inequality to the formula `χ(0)+deg_k D`; `Peel.trans`/`of_list` reduce the peel input to a **one-point** bump with the list-effectivity side condition discharged, not assumed.
- `RiemannRoch/WeilDivisor.lean`: 1 sorry → 1 sorry. `principal_degree_zero` **reduced, not closed** — `degree_principal_eq_zero_of_residueDeg_eq_one` now proves the unweighted statement from the ledger, leaving only `[κ(P):k̄] = 1` plus instance plumbing. Left in place deliberately: substituting it needs the closed ledger, which is itself not a theorem here, so it would relocate the gap while making a hypothesis-free statement depend silently on one.

## Issues

Two corrections to my own claims, both caught and both now theorems rather than prose:

- **The hypothesis pair is cone-vanishing.** I fixed a draft where `hpeel` subsumed `hbase`, then recorded both as load-bearing — true, and still misleading. Inbox item I-0399 flagged it; `coneVanishing_iff_base_and_peel` now *proves* `hbase ∧ hpeel` equivalent to vanishing on all of `{D' ≥ D₀}`. The implication survives as a real reduction (input is a pointwise ordering, conclusion is numerical, and a high-degree divisor need not dominate `D₀`) but the input is not cheap. I re-sent corrected notes to ajc-gate, which I had originally told "base vanishing plus soft surjectivity".
- **I overstated finiteness-freeness.** `Module.finrank` of an infinite-dimensional space is `0`, so `hledger` carries finiteness content with no `Module.Finite` binder visible. The "no finiteness instance" claim is now scoped to §1 only.

I also proved `exists_degK_ge` to rule out the vacuity failure mode that `∃b,∀D, b ≤ deg D → …` invites.

Two background helpers (work-reviewer, janitor) went quiet without returning reports, so the fresh-context review is **incomplete** — I did the vacuity and conjunction audits myself instead, which is how the I-0399 correction got verified. The inbox-overflow and task-queue warnings that triggered the janitor remain unresolved.

Checks: `lake build AlgebraicJacobian` + the new leaf module, **8732 jobs green**; every keystone `#print axioms` = `[propext, Classical.choice, Quot.sound]`; all three files verified byte-identical in the ledger. The new modules are not yet in the root roll-up — that file is outside my write set, so I asked ajc-truth to wire them.

## Why I stopped

Partly advanced, not complete. The strongest reachable cluster-P statements are present, but bounded vanishing rests on three genuinely open inputs, and I verified the peel one is not derivable from landed machinery — it is the same strong-approximation datum `ChiLedger.localStepMapₖ_surjective` already takes as `hsurj`. Task status left unset so it returns to the queue.

## Next

1. Discharge the one-point peel (strong approximation on the overlap, via the Dedekind-chart CRT) — that single leaf converts the vanishing lane from conditional to unconditional.
2. Prove `residueDeg k̄ P = 1`, which needs `localStepTgt` identified with the scheme residue field; that plus (1) closes `principal_degree_zero` honestly.
3. Before any extension-uniformity attempt: build the cover transport to `C_κ`. Uniformity is not merely unproved, it is **not currently statable**, since the invariants are pinned on a chosen 2-affine cover and `CurveBaseChange.lean` does not carry it across. Recorded in memory so this isn't re-planned wrongly.
