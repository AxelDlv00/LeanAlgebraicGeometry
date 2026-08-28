Review complete. Findings below.

## Verdict: progressing, with one substantive over-claim

The work is real and it is not churn. ~1400 lines landed across three new modules in one session, all sorry-free, all kernel-checked, all `#print axioms` = `[propext, Classical.choice, Quot.sound]` (I re-ran this myself on the keystones in a fresh environment). No new `sorry`/`axiom`/`native_decide`/`admit` anywhere under `AlgebraicJacobian/RiemannRoch/**` — the one at `WeilDivisor.lean:1194` is the only one and is untouched. The class-invariance and degree/drop legs are genuinely unconditional mathematics and genuinely new to AJC. The three-gap discipline is maintained consistently in every docstring I read, and the ajc-gate notification (`I-0382`) is if anything more careful than it had to be.

The problem is the headline theorem. It is dressed as a reduction and is a re-indexing.

## Findings, most severe first

**1. `hbase` + `hpeel` are jointly equivalent to the conclusion on the cone** (`BoundedVanishing.lean:290`). I proved this in Lean:

`(∀ D' ≥ D₀, Subsingleton (H1Mod k U₀ U₁ D'))  ↔  (hbase ∧ hpeel)`

The `←` direction is `subsingleton_h1Mod_peel`; the `→` direction is three lines — `hbase` is the instance at `D' = D₀`, and `hpeel` falls out of `subsingleton_h1Mod_iff` by taking `y = 0`. So the session's earlier fix (a draft where `hpeel` subsumed `hbase`) addressed the wrong version of the question: both hypotheses are load-bearing individually, and their conjunction is still cone-vanishing. What the theorem actually contributes is converting the order condition `D' ≥ D₀` into the degree condition `b ≤ deg_k D`, through the effective representative and the multiplication isomorphism. That is worth having and it is correctly proved — it just is not what `BoundedVanishing.lean:11-27` describes. Note `exists_bound_subsingleton_h1Mod_of_pointPeel` (`:432`, landed later in the session) *is* a real reduction: the one-point bump `Peel E (1·P + E)` is strictly weaker than cone-vanishing. That should be the headline.

**2. `hledger` is far stronger than claimed, and probably unsatisfiable as stated.** Also machine-checked: from `hledger` alone, `0 < χ(0) + deg_k D` forces `0 < finrank k Γ(⊤,𝒪(D))`, and `deg_k D < -χ(0)` forces `FiniteDimensional k (Ȟ¹(D))` with `0 < h¹(D)` — because `finrank` of an infinite-dimensional space is `0`. So "the vanishing lane stays independent of the finiteness gates" (`:29-34`) is true of the `Subsingleton` conclusion shape only, not of any theorem taking `hledger`. Worse, it is quantified over *all* divisors while `chi_telescope_list` and the session's own `chi_divisorOfList_eq_degK` only reach list-effective ones. No use site needs the `∀ D` form (each consumes one or two instances); weakening it would strengthen every conclusion and remove a hypothesis nobody can discharge.

**3. §4 of `SectionBounds.lean` (`:485-494`) undercounts the residue of the open sorry.** The stated reason for *leaving* the sorry is correct — substituting would import the unproved ledger. But the "exactly two items" list buries the closed ledger for a cover of `C` inside the "instance plumbing" bullet, and item (1) is not the residue-field fact it is described as: `residueDeg k P` is `finrank k (localStepTgt k P 1)`, and the identification `localStepTgt k P 1 ≅ 𝒪_P/𝔪_P` is asserted in `ChiLedger.lean:539,623-625` docstrings and proved nowhere (no `ResidueField` reference exists under `RiemannRoch/`). The composition is machine-checked; the reduction is not.

**4. Minor.** `BoundedVanishing.lean:42` lists `subsingleton_h1Mod_of_linearEquivalence` — no such declaration exists (the real one is `subsingleton_h1Mod_of_shift`, `:206`). `hle` in `ell_le_ell_add_residueDeg` (`SectionBounds.lean:272`) is derivable from `hstep` + `hoff`. `subsingleton_h1Mod_iff` (`:101`) is a genuine iff, not trivial. Root imports are in place (`AlgebraicJacobian.lean:172-174`); the unrooted-module scan flags only `Picard.RigidPushforwardFrontier`, which is another task's.

Note the session is still writing: `BoundedVanishing.lean` currently differs from ledger HEAD by an uncommitted `exists_degK_ge` (`:455`), which answers the vacuity-of-`b` question — divisors above any threshold do exist, since residue degrees are positive, no rational point needed. That one is sound.

## Filed

Issues `I-0393` (hypothesis equivalence), `I-0394` (`hledger` strength), `I-0396` (§4 overstatement), `I-0398` (dangling docstring reference + redundant hypotheses); memory `I-0399` (check the *conjunction* against the goal, not just each hypothesis for load-bearingness). No files edited.

Relevant paths: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean`, `.../Adelic/SectionBounds.lean`, `.../Adelic/ClassInvariance.lean`, `.../RiemannRoch/WeilDivisor.lean`.
