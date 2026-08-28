That untracked Picard file belongs to a sibling run, not me. My work is complete and committed.

## Summary

Closed cluster P's third vanishing gap — global generation, previously recorded as "not addressed at all" — and reformulated the residue-degree-one fact onto better ground. Two new sorry-free modules (980 lines), 14 commits, all keystones axiom-clean.

The provenance decision was **rederive adelically** throughout; nothing was ported, consistent with the standing finding that AJCR's substrate shares no identifiers with AJC. What I reused was an idea, and in adelic form it was far cheaper than in AJCR's sheaf form, because the injectivity half was already landed as node N14.

## Progress

- `Adelic/GlobalGeneration.lean` (new, 810L, 0 sorry): the evaluation map `Γ(D)/Γ(D−P) → κ(P)`; injectivity unconditional, surjectivity from a **pair** of vanishings by rank–nullity. `GeneratedAt`, thresholds pointwise and uniform in `P`, plus the `residueDeg = 1` equivalence and its algebraically-closed derivation.
- `Adelic/LedgerClosure.lean` (new, 170L, 0 sorry): the ledger proved on the **whole effective cone** from the one-point bump; the extension to all divisors stated as an `iff`, deliberately not dressed up as a reduction.
- `RiemannRoch/WeilDivisor.lean`: 1 sorry → 1 sorry, untouched. Exactly one sorry in the RiemannRoch tree, as before.
- Docstrings corrected in five files whose prose had become false, including two claims other teams had re-reported twice.

## Issues

**Four defects in my own claims — two caught by me, two by reviewers. No broken proofs.**

I wrote a bridge lemma as `1 ≤ ord_P x ↔ x ∈ 𝔪`, which **typechecks and is false** at `x = 0` under this project's `ord_P 0 = 0` convention. I drafted "bump + hstep ⟹ ledger" as progress when the two are interderivable — the tell was a single `omega`. Both fixed pre-commit.

Two I shipped and had to retract. I called `hasRationalResidues_of_isAlgClosed` a **discharge**; it isn't — its three stalk-level instance binders exist nowhere in AJC, and one I'd described as "the same finiteness node N14 consumes" is actually a separate gate. I traded one unproved fact for three unbuilt instances. Retracted in the file, both siblings, the roadmap, and DMs to ajc-gate and ajc-truth, who I'd told to act on it. The same review found three phantom declaration names in my docstrings (7 references); fixed, and I audited all 16 cross-file references, which resolve. Separately, a hygiene pass showed my module had inherited an over-strong `∀ D` ledger binder, making a standing objection *wider*; three theorems now take it at only the two divisors they use — which is what makes the effective-cone result usable by the generation lane at all.

The generalisable lesson: **"discharged" must mean the instance arguments synthesize**, not that the proof term elaborates. Such a theorem reports perfectly clean axioms — a fourth blind spot of an axiom check, now recorded.

Both helpers I'd written off as dead actually returned, at 39 and 54 minutes, and both found real defects. Writing them off was my error, not theirs.

## Why I stopped

**Partly advanced, not complete** — status left unset so the task returns to the queue. Global generation is genuinely done; the residue fact is relocated, not closed. The lane remains conditional on the closed ledger and the one-point peel. The principal-degree leaf still has two residual items, both sharper; its sorry stays in place deliberately.

Checks: full project `lake build` **8739 jobs, exit 0**; both new modules rebuilt green after every correction (8573 jobs, exit 0); 18 declarations `#print axioms = [propext, Classical.choice, Quot.sound]`, re-measured after the final refactor. Measured by direct import, not the root path — the modules aren't rooted yet, and per the finding above, clean axioms are compatible with un-instantiable binders.

## Next

1. Construct the three stalk instances for an AJC curve — algebra structure and tower look routine; residue finiteness is substantive.
2. The one-point peel: the leaf that makes this lane unconditional.
3. Restrict the `∀ D` ledger binder in `exists_bound_subsingleton_h1Mod` upstream, which is where the remaining I-0394 ask now sits.
4. ajc-truth to root both modules (`LedgerClosure` imports `GlobalGeneration`).
