# blueprint-writer directive — OCofP pin cleanup iter-197

## Chapter
`blueprint/src/chapters/RiemannRoch_OCofP.tex`

## Strategy context (slice that matters)

The OCofP chapter underpins Route C RR.3 — the sections of
`O_C(P)` for a closed point `P` on a smooth proper geom-irred curve.
The headline target is
`AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero`
(`thm:lineBundleAtClosedPoint_exists_nonconstant_genusZero`).

iter-196 plan-phase blueprint-writer `ocofp-leanrecipes` added 3
sub-claim `\lean{...}` pins for (a) toFunctionField injectivity,
(b) order conditions, (c) principal_ne_zero. The iter-196 prover
landed sub-claims (a) (axiom-clean as
`toFunctionField_injective`) and (b) (axiom-clean as direct
`globalSections_iff_mpr` application) but did NOT create standalone
named declarations for (b) and (c). Result: two of the three pins
introduced iter-196 reference non-existent Lean names.

The lean-vs-blueprint-checker `ocofp` iter-196 flagged this as
**major** (broken `\lean{...}` pins). Also flagged the
`\leanok`-inside-`\uses` formatting bug; the plan agent already
patched that one directly. This dispatch is purely the broken-pin
fixes.

## Major items to address this iter

### M-1. Remove or rename the broken `\lean{...}` pin on `lem:lineBundleAtClosedPoint_order_conditions_of_globalSection`

**Current state** (chapter line 775): the lemma block carries
`\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection}`.
The corresponding Lean declaration does NOT exist; the iter-196
prover inlined the content as `have h_orders` inside
`exists_nonconstant_rational_from_dim_eq_two` (OCofP.lean L1594-1595)
via direct `globalSections_iff_mpr` application.

**Action** (choose ONE; the planner's recommendation is the second):

Option (a): Remove the `\lean{...}` pin and demote the lemma block to
an informal lemma (it is still mathematically correct and useful for
the proof sketch). Keep the prose but drop the pin.

Option (b) — **planner recommended**: Rewrite the lemma so the pin
matches what Lean actually has:

```latex
\begin{lemma}[Order conditions via globalSections\_iff (inverse direction)]
  \label{lem:lineBundleAtClosedPoint_globalSections_iff_mpr}
  \lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff_mpr}
  ...
\end{lemma>
```

i.e. pin the EXISTING `globalSections_iff_mpr` private helper (OCofP.lean
L1024) since that is what does the work. Update any `\uses{...}` that
referenced the old label.

### M-2. Remove or rename the broken `\lean{...}` pin on `lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant`

**Current state** (chapter line 827): the lemma block carries
`\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant}`.
No such Lean declaration exists. The iter-196 prover inlined the
contrapositive logic in `exists_nonconstant_rational_from_dim_eq_two`
(OCofP.lean L1596-1635) and extracted the Mathlib gap substep as the
private helper `functionField_const_of_complete_curve_of_orderZero`
(OCofP.lean L1390).

**Action** (planner recommended):
- Rename the pin to
  `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.functionField_const_of_complete_curve_of_orderZero}`
  and rewrite the lemma block to MATCH the extracted helper's
  statement (`(f ≠ 0) ∧ (∀ Q, order Q f = 0) ⟹ ∃ c, f = algebraMap kbar K(C) c`).
- Keep the original prose about "principal ≠ 0 of nonconstant" as
  the contrapositive proof sketch in a separate `% NOTE:` block
  immediately after — explaining that the contrapositive (`order_Q
  f = 0 ∀Q ⟹ f ∈ k̄`) is the mathematically equivalent form, and
  the project chose to extract the function-field-of-complete-curve
  statement as the named substrate.
- Update any `\uses{...}` that referenced the old label.

### M-3. Add `\lean{...}` pin for `toFunctionField_injective`

**Current state**: the chapter has a `\lean{}` block for `lem:lineBundleAtClosedPoint_toFunctionField_injective`
at line 668 referencing
`AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective`.
The Lean declaration exists at OCofP.lean L1287 (private lemma,
axiom-clean, ~50 LOC).

**Verification needed**: check the existing pin's name matches the
Lean private declaration name exactly. If it does (likely), no
action — just confirm in the report. If not, fix.

### M-4. Confirm the `\leanok`-inside-`\uses` fix landed

The planner already patched line 694 (moved `\leanok` from inside the
`\uses{...}` arg to a separate line immediately preceding it).
Verify the patch in the current file state; do NOT re-patch.

## Required content shape

- Total chapter LOC: ≤ ~30 LOC delta (mostly textual: pin renames,
  prose touch-ups, one `% NOTE:` block).
- Do NOT add `\leanok` / `\mathlibok` markers anywhere — those are
  managed by `sync_leanok` / the review agent.
- Do NOT touch other chapters.

## References

- Lean file: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- Reviewer report: `task_results/lean-vs-blueprint-checker-ocofp.md`
- iter-196 prover task report: `task_results/AlgebraicJacobian_RiemannRoch_OCofP.lean.md`

## Out of scope

- Closing or proving anything in `OCofP.lean` (prover job).
- Any other chapter.
- Adding new `\lean{...}` pins beyond those listed above.
- Changing `\leanok` or `\mathlibok` markers.

## Verification (for you, the writer)

After your edits land:
- Every `\lean{...}` pin in the chapter resolves to an existing Lean
  declaration in `AlgebraicJacobian/RiemannRoch/OCofP.lean` (or
  flagged as a future target with explanation).
- No `\uses{...}` references a non-existent label.

Report in `task_results/blueprint-writer-ocofp-pin-cleanup-iter197.md`:
- 1-paragraph summary of what changed
- List of M-1 through M-4 addressed
