# Blueprint-clean report — iter065

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Scope
Post-gate065 blueprint purity pass. Focus: newly added/expanded blocks
(`def:coprodOverIncl`, `def:coprodToProdMap`, `lem:coprodToProd_isIso_of_equiv`,
`lem:coprodToProd_isIso_option`, `lem:pushPull_coprod_prod_empty` realignment,
`lem:slice_reverse_ring_map` expansion, `lem:pushPull_coprod_prod` reindexing paragraph).
Full-chapter scan also performed.

---

## Fixes applied (2 edits)

### 1. `def:coprodOverIncl` — `\operatorname{Sigma}.\iota_i` → `\iota_i` (3 occurrences)

**Where:** Lines 8354, 8360, 8361 (definition body of `def:coprodOverIncl`).

**Issue:** `\operatorname{Sigma}.\iota_i` uses a Lean-style dotted Greek construction name.
`Sigma.ι` is not on the project's accepted-notation list (which covers `Sigma.whiskerEquiv`,
`Sigma.desc`, `Pi.lift`, `Over.map`, `Over.post`, `Functor.sheafPushforwardContinuousComp'`).
The existing chapter convention (cf. line 7997) writes the coproduct inclusion as plain `\iota_i`.

**Fix:** Replaced all three occurrences with `\iota_i`.

### 2. Proof of `lem:coprodToProd_isIso_of_equiv` — `\operatorname{Pi.\pi}_i` → `\pi_i` (1 occurrence)

**Where:** Line 8432 (parenthetical in the "Matching the canonical form" paragraph).

**Issue:** `\operatorname{Pi.\pi}_i` embeds a Lean-style dotted Greek symbol. `Pi.π` is not
on the accepted list. The standard mathematical notation for the i-th product projection is `\pi_i`.

**Fix:** Replaced with `\pi_i`.

---

## `\uses{}` label audit — all new blocks

| Block | Labels in `\uses{}` | Status |
|-------|---------------------|--------|
| `lem:pushPull_coprod_prod_empty` (stmt) | `def:push_pull_obj`, `def:coprodToProdMap` | ✓ resolved |
| `lem:pushPull_coprod_prod_empty` (proof) | same | ✓ resolved |
| `def:coprodToProdMap` | `def:push_pull_obj`, `def:push_pull_map`, `def:coprodOverIncl` | ✓ resolved |
| `lem:coprodToProd_isIso_of_equiv` (stmt) | `def:push_pull_obj`, `def:coprodOverIncl`, `def:coprodToProdMap`, `lem:pushPullObjCongr` | ✓ resolved |
| `lem:coprodToProd_isIso_of_equiv` (proof) | `def:coprodOverIncl`, `def:coprodToProdMap`, `lem:pushPullObjCongr` | ✓ resolved |
| `lem:coprodToProd_isIso_option` (stmt) | `def:coprodToProdMap`, `lem:pushPull_binary_coprod_prod`, `lem:over_sigmaOptionIso`, `lem:piOptionIso`, `lem:pushPullObjCongr` | ✓ resolved |
| `lem:coprodToProd_isIso_option` (proof) | same | ✓ resolved |
| `lem:pushPull_coprod_prod` (stmt) | `def:push_pull_obj`, `def:coprodOverIncl`, `def:coprodToProdMap`, `lem:isIso_modules_of_toPresheaf`, `lem:pushPull_binary_coprod_prod`, `lem:pushPullObjCongr`, `lem:over_sigmaOptionIso`, `lem:piOptionIso`, `lem:pushPull_coprod_prod_empty`, `lem:coprodToProd_isIso_of_equiv`, `lem:coprodToProd_isIso_option` | ✓ all resolved |
| `lem:slice_reverse_ring_map` expansion | `lem:slice_structureSheaf_hom`, `lem:slice_overs_equiv_continuity` | ✓ resolved |

---

## Full-chapter scan findings

**Accepted and left unchanged:**
- `IsZero`, `IsIso` as `\operatorname{}` predicates — established throughout the chapter (not new leakage).
- `Pi.whiskerEquiv`, `Pi.mapIso` in the new proof — analogous to accepted `Sigma.whiskerEquiv`; denote specific constructions.
- `% NOTE (review iter-064): ...` comment blocks at lines 8477–8482, 10490–10493, 10548–10551, 10614–10618 — project build-state comments, explicitly permitted.

**Pre-existing prose not in scope:**
- "dormant axiom-clean assets" at lines 5350, 5458, 5836 — pre-dates gate065, not in the edited regions; left for a future global clean pass to avoid disturbing stable content.

**No reference-retriever spawn needed.** All new blocks are Archon-original constructions with no external citation obligation.

## Outcome

2 edits applied. Chapter is blueprint-clean for the gate065 additions.
`\leanok` markers untouched. No `\mathlibok` added to project-bespoke blocks.
