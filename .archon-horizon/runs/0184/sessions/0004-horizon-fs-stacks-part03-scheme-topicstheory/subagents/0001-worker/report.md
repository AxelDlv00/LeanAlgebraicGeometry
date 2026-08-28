I could not complete the full Euler-characteristic identity in the bounded attempt: it requires constructing and composing four exact sequences, and `Cohomology.lean` was still unavailable due its quotient-notation errors.

I added and validated the strongest small API available:

- finite ambient modules imply finite-length periodic cohomology;
- exact complexes imply finite-length cohomology;
- finite cohomology lengths are below `⊤`;
- `lengthDifference = 0 ↔ evenLength ≤ oddLength`.

The `tsub_eq_zero_iff_le` identity was independently kernel-checked. The root agent should stage the shared `PeriodicLength.lean` after repairing `Cohomology.lean`.
