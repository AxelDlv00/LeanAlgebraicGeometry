Filed as I-0048. Audit verdict: **CLEAN**.

## Summary

The run-0006 T6 diff in `SubProjects/Albanese` does what the report claims. The Stacks 00TT gap is genuinely closed via a new Serre-free route, and both `isRegularLocalRing_stalk_of_smooth` and `localRing_dvr_of_codim_one` are honestly sorry-free.

**Stray files** — none. The working tree diff is exactly 7 modified + 1 new file (`AlgebraicJacobian/Albanese/SmoothPrimeRegularity.lean`). Top-level oddities (`RationalCurveIso.body`, `informal/`, `analogies/`, `TO_USER.md`) are tracked from prior commits and untouched by T6.

**Buried cheats** — none beyond the 3 sanctioned gaps. All three are genuine named-lemma gaps (full statement present, only the proof body is `sorry`):
- `indeterminacy_codimGe2_of_smooth_of_complete` (sorry at line 1386)
- `extend_of_codimOneFree_of_smooth` (line 1454)
- `indeterminacy_pure_codim_one_into_grpScheme` (line 1529)

No `admit`/`native_decide`/new `axiom`/`@[implemented_by]`/`unsafe` anywhere; the new file is fully sorry-free. Crucially, the two "closed" theorems are defined *before* the sorries (lines 1188, 1309) and route through `SmoothPrimeRegularity.isRegularLocalRing_of_isLocalization_atPrime_of_isStandardSmooth_of_perfectField` (line 662) — a substantive Kähler-differential / conormal-identity / trdeg-height proof, not a shortcut. They cannot and do not depend on the gaps.

**−648-line rewrite** — genuine simplification, not a regression. Signatures of every retained/exported declaration are byte-identical to HEAD (verified `CodimOneFree`, `indeterminacyLocus`, `localRing_dvr_of_codim_one`, `extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`, `isRegularLocalRing_stalk_of_smooth`). Nothing weakened or made vacuous. The deleted material is the abandoned Serre/closed-point scaffolding (`MvPolynomial` height lemmas, regular-sequence Krull-dim lemmas, `submersivePresentation` cotangent-independence lemmas) now superseded. Every deleted decl has zero remaining consumers inside `SubProjects/Albanese` — the only lingering references are in the out-of-scope `MainProjects/Algebraic-Jacobian-Challenge` mirror (a separate project, not in the T6 write-set). The `blueprint/lean_decls` (−9) and `.tex` chapter edits track the deleted decls — expected Ground reconciliation.

**Dead code** — confirmed. `stalkMap_flat_of_smooth` (private, line 216) and `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth` (private, line 262) have no Lean consumers anywhere (comment mentions only). Both are `private`, so no external surface — harmless leftover, optional cleanup.

Relevant files:
- `/AI4M/users/Axel/LeanAlgebraicGeometry-Horizon/SubProjects/Albanese/AlgebraicJacobian/Albanese/SmoothPrimeRegularity.lean`
- `/AI4M/users/Axel/LeanAlgebraicGeometry-Horizon/SubProjects/Albanese/AlgebraicJacobian/Albanese/CodimOneExtension.lean`
