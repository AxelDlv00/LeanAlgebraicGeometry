Verified clean: scratch removed, all four commits in the ledger, all six files byte-identical to HEAD, and `WeilDivisor.lean` untouched by any of my commits (respecting the ajc-pic0av boundary).

## Summary

`UniformBaseDivisor` has a producer. The residue r6 left — a `def` with consumers and, by its own producer/consumer test, none — is now produced from geometry, at genus 0.

The step was one r6 had in hand and did not take. A field extension κ/k is **faithfully flat** (via `instOfNontrivialOfFree`; not a direct instance, synthesis fails), so `κ ⊗[k] −` *reflects* as well as preserves triviality, and r6's `h1CokₗBaseChangeField` upgrades from an isomorphism of modules to an **equivalence of vanishing statements**, both directions, no hypothesis on κ/k. Not a corollary of `genus_baseChangeField`: that is an identity of `finrank`s, and `finrank` reads 0 on infinite-dimensional spaces, so a dimension equality cannot decide `Subsingleton` either way. The descent half — a vanishing proved over *any* extension, however large, comes back down to k — has no analogue in this workspace.

**Provenance: rederived in AJC's abstractions, not ported.** The audit r6 named as its next step is done and decides against porting: AJCR *has* the content (`subsingleton_h1_windowN` + `deg_windowN`, κ-independent degree) but uniform **by construction of the statement** — its π is bound at `P1 k`, pinning every constant to k — not by a theorem, and neither `UniformBaseDivisor` nor `UniformVanishing` occurs there at all. Cone measured exactly: 88 files for `GluedSheafH0BaseChange`, 139 for `WindowFieldTransport`, across two carrier boundaries with zero overlap either way (`AffineCoverMVSquare` 37 files in AJC / 0 in AJCR; `baseChangeField` 11/0; `AffineTwoCover` 0/19; `relCurve` 0/280). Not hard next door, not portable either.

## Progress
- `Ledger/VanishingFieldDescent.lean`: new, 384 lines, 0 sorries, 10 declarations — the vanishing iff on both carriers, cover-discharged form, the scope theorem, the producer, and the `UniformVanishing` producer plus genus-form corollaries.
- `scripts/ajcrr-vanishingfielddescent-axioms.lean`: new, 174 lines, 30 `#print axioms` — 26 declarations clean at *synthesis* sites, both controls firing `sorryAx`, exit 0.
- `Ledger/FiberBound.lean`, `Ledger/ExtensionUniformity.lean`, `Ledger/GenusFieldInvariance.lean`, `Ledger/SectionsFieldBaseChange.lean`: docstring-only (declaration lines byte-identical, verified).
- Kernel: `lake build` 8700 jobs exit 0 throughout. Three `sorry` warnings pre-existing in `Picard/`.

## Issues

**Five prose defects in my own work, found by fresh-context review.** The mathematics survived unchanged; every finding was a claim about it.

- **The load-bearing claim was prose.** "`Subsingleton H¹(𝒪_C)` *is* `genus C = 0`" was asserted at three sites and proved nowhere, while every scope statement rested on it. Now `subsingleton_hModule_one_iff_genus_eq_zero`. The directions are not symmetric: `→` (the scope-limiting one) needs no finiteness; `←` needs `moduleFinite_genus_carrier`.
- **"Unconditional" was false, twice — and survived the caveat added to kill it.** Commit `3b4048af9` existed to admit the producer has no exhibited instance; it corrected "first instance" → "first producer" and left "first **unconditional** instance" standing two lines up. That is how a caveat fails.
- **Two phantom declaration names**, in the module docstring's own summary list — my lane's fourth occurrence. Structural fix: the probe now prints axioms for every cited name, so a phantom cannot survive a green run.
- **A fifth copy of a withdrawn claim**, in `SectionsFieldBaseChange.lean` — a file no correction pass had opened. Found only by grepping the claim's *text* (I-0742).
- "Five consumers" was re-asserted across two files; actually three.

**My producer is not known to be non-vacuous, and I found that myself before the review.** AJC discharges `Subsingleton H¹(𝒪_C)` at **no curve** — no `Subsingleton H¹(𝒪_{ℙ¹})`, no `genus (p1Over k) = 0` (confirmed independently). So it is a true implication with no exhibited instance. The missing brick is elementary and scoped on I-0746; the obstacle is structural — `LaurentChartData` carries span-of-powers for the two charts but not integer powers on the overlap.

**Both background subagents stalled at exactly 191 bytes** (I-0677, as r6 hit with all four of its own). I re-ran the review synchronously; the janitor did deliver (I-0751).

**Concurrency: the shared index was armed to delete files twice**, both times spanning another lane's AJCR paths (six, then three). All verified present on disk and byte-identical to HEAD, then cleared. Ninth instance, reported on I-0656. Also flagged 90 uncommitted lines of ajc-fbc's on `axiom-frontier.lean` — left untouched.

**Rootedness:** the whole `Ledger` chain is outside the root import cone — pre-existing, one import line outside my scope.

## Why I stopped

Materially advanced, not complete — status left unset. Items 1 and 3 unchanged. Item 2 is **open at genus ≥ 1**, the case that matters, and its ceiling is now measured: the comparison is stated at the *unit* module, so AJC has no divisor-level base change to reach `d > 0`. Genus 0 is reduced to one named elementary brick but is **not** an instance. `UniformVanishing C` is not proved for the challenge curve. Global generation untouched and still not uniform over extensions.

## Next
1. **General-module `h1CokₗBaseChangeField`** — the brick for genus ≥ 1.
2. **`h¹(𝒪_{ℙ¹}) = 0`** (I-0746) — converts the genus-0 implication into an instance.
3. Root the `Ledger` chain: one import line.
