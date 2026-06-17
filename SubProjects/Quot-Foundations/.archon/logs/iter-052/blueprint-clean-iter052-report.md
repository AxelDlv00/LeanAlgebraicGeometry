# Blueprint Clean — iter-052

**Chapters processed:** `blueprint/src/chapters/Picard_FlatteningStratification.tex`,
`blueprint/src/chapters/Picard_GrassmannianQuot.tex`

## Changes made

### 1. `Picard_FlatteningStratification.tex` — `lem:module_finite_of_ringEquiv_semilinear` proof

**Issue:** Lean tactic leakage. The proof body ended with the parenthetical
`(a one-step \texttt{Submodule.span\_induction} on a finite \(R\)-spanning set, the
\(\mathrm{smul}\) case using \(\sigma\)-semilinearity)`, which names a Lean tactic
(`Submodule.span_induction`) and uses the Lean-specific term `smul`.

**Fix:** Dropped the parenthetical entirely. The mathematical argument was already
complete in the preceding sentences; the parenthetical added nothing beyond a pointer to
a Lean proof step.

### 2. `Picard_GrassmannianQuot.tex` — `def:scheme_modules_glue` NOTE comment

**Issue:** A seven-line `% NOTE: (iter-051) …` comment embedded in the statement body
contained:
- Lean syntax/implementation details (`_hC1` argument name, `sorry`, `whnf runaway`,
  `eqToHom`);
- Project-history verbosity (`iter-051`, reference to
  `task_results/AlgebraicJacobian_Picard_GrassmannianQuot.md`).

The underlying issue — adding hypothesis C2 to the Lean signature — is reflected in the
current blueprint body, which now carries the full mathematical C2 condition via
`lem:modules_pullback_basechange_transport`. The implementation-status NOTE is therefore
both stale and impure.

**Fix:** NOTE comment removed in full. The C2 condition remains properly stated in the
definition.

## Validation of new blocks

All new blocks were inspected for math-only prose, source-quote completeness, and LaTeX
correctness. Findings:

| Block | File | Status |
|---|---|---|
| Mathlib anchors G3 (`lem:mathlib_flat_of_free` / `_localization_preserves` / `_localization_flat` / `_flat_of_localized_maximal` / `_flat_of_isLocalized_maximal` / `_flat_trans`) | FlatStrat | ✓ Clean; `\mathlibok`; no external source quote needed |
| `lem:gf_patch_free_imp_flat` | FlatStrat | ✓ Clean; Archon-original; no source quote needed |
| `lem:gf_stalk_flat_over_base` | FlatStrat | ✓ Clean; Archon-original; no source quote needed |
| `lem:gf_flat_base_local_on_source` | FlatStrat | ✓ Clean; Archon-original; no source quote needed |
| `lem:gf_stalk_flat_localBase` | FlatStrat | ✓ Clean; Archon-original; no source quote needed |
| `lem:module_finite_of_ringEquiv_semilinear` | FlatStrat | ✓ Clean after fix above; Archon-original |
| `def:modules_pullbackComp` | GrQuot | ✓ Clean; `\mathlibok`; no external source quote needed |
| `lem:modules_pullback_basechange_transport` | GrQuot | ✓ Clean; Archon-original infra block; no source quote needed |
| C2 restatement inside `def:scheme_modules_glue` | GrQuot | ✓ Clean after NOTE removal; properly uses `\cref{lem:modules_pullback_basechange_transport}` |

## No further issues found

- No other Lean tactic/syntax leakage detected in either file.
- No other `% NOTE:` comments present (the GrQuot NOTE was the only one).
- No missing source quotes: all externally-sourced blocks retain their `% SOURCE QUOTE:`
  / `% SOURCE QUOTE PROOF:` comments; all Archon-original and Mathlib-backed blocks
  correctly carry no source quote.
- `\leanok` markers untouched; `\lean{}` targets and `\uses{}` edges untouched.
- LaTeX syntax verified; no structural issues detected.

## Files modified

- `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- `blueprint/src/chapters/Picard_GrassmannianQuot.tex`
