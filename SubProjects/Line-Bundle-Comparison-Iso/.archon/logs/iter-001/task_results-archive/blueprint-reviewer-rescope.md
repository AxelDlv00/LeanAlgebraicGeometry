# Blueprint Review: rescope
**Iter:** 001
**Scope:** `Picard_TensorObjSubstrate.tex` — fast-path re-review of single must-fix (`lem:tensorobj_inverse_invertible`)

## Gate verdict

**YES — `Picard_TensorObjSubstrate.tex` reads `complete: true` AND `correct: true` with NO must-fix-this-iter finding.**

HARD GATE CLEARED for all 5 covered files:
`TensorObjSubstrate.lean`, `DualInverse.lean`, `StalkTensor.lean`, `PresheafInternalHom.lean`, `Vestigial.lean`.

## Must-fix confirmation (all 4 directive items)

1. **Stale language GONE.** No trace of "Infrastructure-blocked", "not realizable", "cannot be named", or "placeholder" anywhere in the file. Grep returned 0 hits.

2. **Replacement proof sound and prover-usable.** `lem:tensorobj_inverse_invertible` (L1355–L1487) now contains a real 3-step proof:
   - *Step 1* (L⁻¹ is a line bundle): constructs dual via `def:presheaf_internal_hom` / `lem:internal_hom_isSheaf`; uses `lem:dual_isLocallyTrivial` for local triviality.
   - *Step 2* (contraction is locally an iso): applies `lem:tensorobj_restrict_iso` and `lem:tensorobj_unit_iso` to reduce to the free rank-one case.
   - *Step 3* (glue to global iso): uses local-iso-implies-global-iso via `lem:tensorobj_restrict_iso` naturality.
   - "Downstream Lean dependency" note present: body consumes `lem:dual_restrict_iso`.
   Proof is mathematically complete and provides sufficient detail for prover.

3. **Citations intact.** `% SOURCE:` (Stacks Tag 01CR, L1368), `% SOURCE QUOTE:` (L1374–1392), and `\textit{Source: [Stacks Project], Tag~01CR, ...}` visible line (L1393–1397) all present and consistent.

4. **`unknown_uses` empty; `lem:dual_restrict_iso` in `\uses{}`.**
   - Proof block `\uses{}` (L1413): `{lem:tensorobj_preserves_locally_trivial, lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso, lem:internal_hom_eval, lem:dual_isLocallyTrivial, lem:dual_restrict_iso}` — includes `lem:dual_restrict_iso` ✓
   - `leandag build --json`: `unknown_uses: []` ✓

## Per-chapter

### `Picard_TensorObjSubstrate.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: See "soon" findings below; no gate-blocking issues.

## Severity summary

- **must-fix**: none
- **soon** (not gate-blocking):
  - `lem:internal_hom_isSheaf` is explicitly cited in the proof body of `lem:tensorobj_inverse_invertible` (L1417, L1474) but absent from the proof `\uses{}` at L1413. Missing direct edge; wire-up recommendation: add `lem:internal_hom_isSheaf` to the proof `\uses{}`. Not a gate blocker (`lem:internal_hom_isSheaf` is already `\leanok`, and `unknown_uses` remains empty).
- **known / not re-reported**:
  - `lem:leftadjointuniq_app_unit_eta_general` lean-name drift — cosmetic, decl exists.
  - 3 unmatched `\lean{}` (`lem:pullback_compatible_with_tensorobj`, `lem:pullback_tensor_iso_loctriv`, `thm:rel_pic_addcommgroup_via_tensorobj`) — forward scaffold targets, not gate blockers.
  - 3 broken `\cref{}` in chapter to missing sibling chapters (`chap:Albanese_AlbaneseUP`, `chap:Picard_FGAPicRepresentability`, `chap:Picard_IdentityComponent`) — rendering-only, no gate impact.

## leandag stats (full blueprint)
- `blueprint_nodes`: 108, `lean_aux_nodes`: 91, `proved`: 59, `with_sorry`: 6
- `isolated`: 91 (ALL `lean_aux` — no isolated blueprint nodes)
- `unknown_uses`: [] (empty)
- `unmatched_lean`: 3 (all pre-existing forward-reference scaffold targets)
- `conflicts`: []

## archon blueprint-doctor
- `malformed_refs`: [] (empty — no undefined macros, math-delim, literal-ref, or bare-label issues)
- `orphan_chapters`: []
- `covers_problems`: []
