# Blueprint Writer Report

## Slug
RiemannRoch_WeilDivisor-cov273

## Status
COMPLETE — all 31 uncovered Lean declarations now have exactly one `\lean{}`-pinned
blueprint block, each wired into the chapter's dependency cone (no isolated nodes,
no broken `\uses{}`, no conflicts per `leandag`).

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Changes Made (31 blocks added, one per uncovered decl)

### Open-immersion descent (§ "Open-immersion descent for prime divisors")
- **lemma** `lem:primeDivisor_restrictToOpen_point` / `…PrimeDivisor.restrictToOpen_point` — point field of a restricted prime divisor. `\uses{def:primeDivisor_restrictToOpen}`.
- **lemma** `lem:primeDivisor_ofOpen_point` / `…PrimeDivisor.ofOpen_point` — point field of a pushed prime divisor. `\uses{def:primeDivisor_ofOpen}`.
- **lemma** `lem:ordFrac_stalkIso_naturality` / `…PrimeDivisor.ordFrac_stalkIso_naturality` — parameterised `ordFrac` naturality across the stalk iso. `\uses{lem:primeDivisor_stalkIso, lem:ordFrac_ringEquiv, def:primeDivisor_restrictToOpen, def:isRegularInCodimensionOne}`.

### Ring-iso naturality substrate (new `\subsection` before `def:functionFieldIso`)
- **lemma** `lem:ord_ringEquiv` / `Ring.ord_ringEquiv` — length valuation invariant under a ring iso. (base node; in-edges from the two below)
- **lemma** `lem:nonZeroDivisors_ringEquiv` / `Ring.nonZeroDivisors_ringEquiv` — nzd preserved by a ring iso.
- **lemma** `lem:ordMonoidWithZeroHom_ringEquiv` / `Ring.ordMonoidWithZeroHom_ringEquiv` — `\uses{lem:ord_ringEquiv, lem:nonZeroDivisors_ringEquiv}`.
- **lemma** `lem:ordFrac_ringEquiv` / `Ring.ordFrac_ringEquiv` (anchor) — `\uses{lem:ordMonoidWithZeroHom_ringEquiv, lem:nonZeroDivisors_ringEquiv}`.

### DVR / Krull-dim bridge instances (after `def:isRegularInCodimensionOne`)
- **definition** `def:isRegularInCodimOne_dvrStalk` / `…IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` — `\uses{def:isRegularInCodimensionOne, def:prime_divisor}`.
- **definition** `def:isRegularInCodimOne_krullDimStalk` / `…IsRegularInCodimensionOne.instKrullDimLEStalk` — `\uses{def:isRegularInCodimOne_dvrStalk, def:prime_divisor}`.

### Order valuation identities (new `\subsection` after `def:order_at_point`)
- **lemma** `lem:order_zero` / `…RationalMap.order_zero` — `\uses{def:order_at_point}`.
- **lemma** `lem:order_one` / `…RationalMap.order_one` — `\uses{def:order_at_point}`.
- **lemma** `lem:order_mul_of_ne_zero` / `…RationalMap.order_mul_of_ne_zero` — `\uses{def:order_at_point}`.
- **lemma** `lem:order_inv` / `…RationalMap.order_inv` — `\uses{def:order_at_point}`.
- **lemma** `lem:order_units_inv` / `…RationalMap.order_units_inv` — `\uses{lem:order_inv}`.
- **lemma** `lem:order_neg` / `…RationalMap.order_neg` — `\uses{def:order_at_point}`.
- **lemma** `lem:order_pow_of_ne_zero` / `…RationalMap.order_pow_of_ne_zero` — `\uses{lem:order_mul_of_ne_zero, lem:order_one}`.

### Degree lemmas (after `thm:divisor_degree_hom`)
- **lemma** `lem:degree_hom_apply` / `…WeilDivisor.degree_hom_apply` — `\uses{thm:divisor_degree_hom, def:divisor_degree}`.
- **lemma** `lem:degree_zero` / `…WeilDivisor.degree_zero` — `\uses{lem:degree_hom_apply, def:divisor_degree}`.
- **lemma** `lem:degree_add` / `…WeilDivisor.degree_add` — `\uses{lem:degree_hom_apply, def:divisor_degree}`.
- **lemma** `lem:degree_neg` / `…WeilDivisor.degree_neg` — `\uses{lem:degree_hom_apply, def:divisor_degree}`.
- **lemma** `lem:degree_sub` / `…WeilDivisor.degree_sub` — `\uses{lem:degree_hom_apply, def:divisor_degree}`.
- **lemma** `lem:degree_single` / `…WeilDivisor.degree_single` — `\uses{def:divisor_degree, def:prime_divisor}`.

### Principal-divisor helpers (after `def:principal_divisor`)
- **lemma** `lem:principal_apply` / `…WeilDivisor.principal_apply` — `\uses{def:principal_divisor, def:order_at_point}`.
- **lemma** `lem:principal_one` / `…WeilDivisor.principal_one` — `\uses{def:principal_divisor, lem:principal_apply, lem:order_one}`.

### Positive-part + ProjectiveLineBar helpers (before `lem:degree_positivePart_principal_eq_finrank`)
- **lemma** `lem:positivePart_zero` / `…WeilDivisor.positivePart_zero` — `\uses{def:WeilDivisor_positivePart}`.
- **lemma** `lem:positivePart_single` / `…WeilDivisor.positivePart_single` — `\uses{def:WeilDivisor_positivePart, def:prime_divisor}`.
- **lemma** `lem:degree_positivePart_eq_sum_max` / `…WeilDivisor.degree_positivePart_eq_sum_max` — `\uses{def:WeilDivisor_positivePart, def:divisor_degree}`.
- **lemma** `lem:finsupp_sum_max_zero_eq_sum_filter_pos` / `Finsupp.sum_max_zero_eq_sum_filter_pos` — `\uses{lem:degree_positivePart_eq_sum_max}`.
- **lemma** `lem:one_le_degree_positivePart_principal_of_order_one` / `…WeilDivisor.one_le_degree_positivePart_principal_of_order_one` — `\uses{lem:degree_positivePart_eq_sum_max, lem:principal_apply, def:principal_divisor, def:order_at_point}`.
- **definition** `def:projectiveLineBar_isLocallyNoetherian` / `…WeilDivisor.instIsLocallyNoetherianProjectiveLineBar` — `\uses{def:codim1_cycles}`.
- **theorem** `thm:projectiveLineBar_isRegularInCodimOne` / `…WeilDivisor.isRegularInCodimOneProjectiveLineBar` — `\uses{def:isRegularInCodimensionOne}`.

## Cross-references introduced (edges added to EXISTING blocks to consume the new helpers)
- `def:order_at_point` — added `def:isRegularInCodimOne_krullDimStalk` (order's `Ring.KrullDimLE 1` hypothesis source).
- `lem:order_eq_order_restrict` — added `lem:ordFrac_stalkIso_naturality` (its proof discharges that lemma's `h_compat`).
- `thm:principal_hom` — added `lem:order_mul_of_ne_zero, lem:order_units_inv, lem:order_one` (the DVR identities its proof sums).
- `lem:degree_positivePart_principal_eq_finrank` — added 9 edges: `lem:degree_positivePart_eq_sum_max, lem:finsupp_sum_max_zero_eq_sum_filter_pos, lem:one_le_degree_positivePart_principal_of_order_one, lem:principal_apply, lem:order_pow_of_ne_zero, lem:degree_single, lem:positivePart_single, def:projectiveLineBar_isLocallyNoetherian, thm:projectiveLineBar_isRegularInCodimOne`.

Internal new→new edges: the four `Ring.*` blocks form a chain (`ord_ringEquiv`, `nonZeroDivisors_ringEquiv` → `ordMonoidWithZeroHom_ringEquiv` → `ordFrac_ringEquiv`) and `ordFrac_ringEquiv` feeds `lem:ordFrac_stalkIso_naturality`, which is consumed by the existing `lem:order_eq_order_restrict` — so the whole substrate is in the cone.

## REF placeholders fixed
0 — the chapter contained no literal `REF` placeholders (`grep` for `REF` returned nothing).

## Verification (leandag)
- `leandag build --json`: no `conflicts`; the chapter's `unknown_uses` set is empty (the single project-wide `unknown_uses`, `lem:depth_via_ext → lem:ext_smul_eq_zero_of_mem_annihilator`, is in an Albanese chapter, not this one).
- All 31 new `\lean{}` pins resolve — none appear in `unmatched_lean`.
- `leandag query --isolated --chapter RiemannRoch_WeilDivisor`: 0 isolated nodes.
- LaTeX environments balanced (lemma 35/35, definition 15/15, theorem 5/5, proof 40/40).
- definition+proof pairing has in-repo precedent (AbelianVarietyRigidity.tex, 11 occurrences).

## References consulted
None — every added block is a project-internal helper proved sorry-free in Lean
(no external `% SOURCE:` quotes were written; all citation content already present
in the chapter was left untouched).

## Macros needed
None.

## Notes for Plan Agent
- I did NOT add `\leanok` to any new block (per descriptor); the `sync_leanok` phase will set it. Note `isRegularInCodimOneProjectiveLineBar` is a typed-sorry theorem in Lean (its body has a residual `sorry` per the file's own comments), so `sync_leanok` will likely leave it unmarked even though it appears in the cover list — that is expected and not a writer error.
- The four `Ring.*` helpers and `ordFrac_stalkIso_naturality` are `private` in Lean; `sync_leanok` historically may not resolve `private` decls cleanly (cf. the existing note on `rationalMap_order_finite_support`). Flagging in case the leanok sync skips them.

## Strategy-modifying findings
None.
