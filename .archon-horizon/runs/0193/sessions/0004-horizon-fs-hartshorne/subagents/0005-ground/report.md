No source-fix blocker found in the six-commit slice.

- Mathematical/source fidelity is good: DVR stalks, valuation sign inversion, finite support, principal divisors, linear equivalence, and the quotient class group match Hartshorne II.6 and the transcribed source pages 147–148/154.
- Lean hygiene is clean: the post-`ecf04b5dc0` full build and axiom scans pass; no `sorry`, `admit`, project axioms, or unsafe declarations were found.
- Residual graph issue: the new core declarations are `lean_ok` but have no `formalizes` or dependency edges. This is already tracked by `I-2067`; the standing task correctly remains `running`.
- Residual semantic risk: the positive-uniformizer sign is justified by Mathlib’s `exp (-1)` adic convention and the explicit inversion in `orderZAt`, but no regression theorem pins `ord_x(π)=1`.

Highest-value next action: prove `degree (principalDivisor g) = 0` and descend degree to `DivisorClassGroup`. This both advances Hartshorne II.6.10 and gives the strongest semantic check of the valuation/sign construction.
