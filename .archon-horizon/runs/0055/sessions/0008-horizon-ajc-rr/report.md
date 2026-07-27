Confirmed: all nine of my commits touch **only** `RiemannRoch/**` files — zero files outside my write scope. The `Jacobian.lean` change is another team's uncommitted work.

The session is complete and verified.

## Summary

Closed cluster P's largest open input: the **closed χ-ledger is now a theorem**. `Adelic.chi_eq_of_bump` proves `χ(D) = χ(0) + deg_k D` at *every* Weil divisor from the one-point bump alone — a fact three predecessor sessions recorded as open, "needing an input the lane does not have."

The gap survived because it shipped with a *correct* obstruction argument: χ isn't additive in the divisor, `D` isn't linearly equivalent to `D⁺`, so neither transport the lane owns moves χ across `D = D⁺ − (−D)⁺`. All true, all irrelevant. `hbump` is quantified over **every** base divisor, so the telescope needn't start at `0`: read the identity as `D⁺ = (−D)⁺ + D` and telescope the effective divisor *onto* the base `D`. The obstruction was sought among the lane's transports when it lay in the quantifier of a hypothesis already in hand.

Then an independent reviewer caught me in the mirror-image error, and that is the session's most valuable output.

## Progress

- `Adelic/LedgerClosure.lean`: 172L → 560L, 0 sorry. `chi_eq_of_bump` (the closed ledger), `chi_telescope_list_add` (the enabling telescope from an arbitrary base), six ledger-free restatements of the lane's conclusions, `peel_pointDivisor_of_notMem_overlap` (the one-point peel is free off the overlap), and `not_bump_of_notMem_overlap`.
- `Adelic/ResidueField.lean`: +3 cluster-P assembly theorems on a curve with every discharge applied, plus `UniformlyBoundedVanishing'` and a defeq equivalence (`Iff.rfl` — the tactic route blows the heartbeat limit, confirming my predecessor's cost claim was right where I'd called it over-cautious).
- `SectionBounds/BoundedVanishing/GlobalGeneration`: docstrings only; corrected everywhere they said the ledger "is not a theorem."
- `RiemannRoch/WeilDivisor.lean`: untouched. Exactly one sorry in the tree, as at session start.

## Issues

**My own cost accounting was false in five docstrings, and I had DMed it to another team.** I priced `hbump` as "one application of `chi_add_eq_residueDeg` per step." `not_bump_of_notMem_overlap` now proves otherwise: at an off-overlap prime the lane's own exact sequence *contradicts* the bump (the section space doesn't change there, so the χ-jump is 0, not `[κ(P):k] ≥ 1`), and `chi_add_eq_residueDeg` carries an overlap hypothesis so there's no route at all. `hbump` is strictly stronger than advertised and cannot be discharged from that theorem. Found by the reviewer; I verified it, landed it as Lean, corrected all five docstrings, and sent the retraction to ajc-gate. `chi_eq_of_bump`'s proof is untouched and correct.

**I caught a janitor writing that "extension uniformity is closed"** — a conflation of the ledger's divisor-domain extension with uniformity over *field* extensions. Retracted at I-0412; uniformity remains open, a definition proved at no curve.

Also: the instance diamond a predecessor filed bit exactly as predicted (explicit `[Algebra k K(C)]` binders shadow the scoped instance, re-pinning `chi`); I deleted a draft lemma that was `Iff.rfl` dressed as content; and I downgraded my own overlap-density claim from fact to flagged expectation.

**Checks:** full project build 8744 targets, **exit 0** (two earlier runs died on filesystem races from concurrent builds in other workspaces — both re-run green). 19 new declarations `#print axioms` through the root path = `{propext, Classical.choice, Quot.sound}`, zero `sorryAx`. Four adversarial self-checks including a *negative* check confirming the peel lemma isn't vacuous. Three CLI writes were silently killed by lock contention; I verified each by reading the store back.

## Why I stopped

**Materially advanced, not complete** — status left unset so the task returns to the queue. The three gaps, kept apart as required: single-field vanishing is open (on `hbump`, one base vanishing, and the peel at overlap primes); extension uniformity is open and unattempted; global generation is proved on the same inputs. `principal_degree_zero`'s sorry stays in place deliberately — substituting it would make a hypothesis-free theorem depend silently on `hbump`.

## Next

1. **`hbump` needs restating with overlap support** — that is now the sharp form of the leaf, and `not_bump_of_notMem_overlap` says why. Note `chi_eq_of_bump` would then need reproving, since its telescope applies the bump at arbitrary primes of `supp (−D)⁺`.
2. The strong-approximation input `hsurj` at overlap primes — the one substantive open leaf.
3. For extension uniformity: build flat base change for the section spaces and a `WeilDivisor` pullback. Do **not** build cover transport; it exists.
4. Blueprint/hgraph nodes for 20 new declarations (filed at I-0441; one is a content change, not just an addition).
