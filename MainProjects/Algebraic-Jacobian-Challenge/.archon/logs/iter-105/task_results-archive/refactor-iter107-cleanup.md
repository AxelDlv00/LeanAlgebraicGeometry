# Refactor Report

## Slug
iter107-cleanup

## Status
COMPLETE — All 5 changes landed; both files compile (warnings only, no errors); sorry analyzer confirms total = 14 (BasicOpenCech 6, Differentials 5, Modules/Monoidal 1, Jacobian 1, Picard/Functor 1).

## Directive

### Problem
1. Iter-106 Route 1 lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` carried a `sorry` body and unused `hPrev`; classified as STUCK / sunk-cost dead-end scaffold by iter-106 critics. Iter-107 has switched to option 3 (in-line direct per-coord proof) bypassing the wrapper engine.
2. Four "Body left as `sorry`" docstrings at L488 / L760 / L823 / L871 in `BasicOpenCech.lean` are stale — the corresponding bodies all closed in earlier iterations.
3. Iter-107 excuse-comment block inside `cechCofaceMap_pi_smul` (L1168–L1173) defers a heartbeat-lift fix that the iter-107 plan has abandoned.
4. Iter-102 NOTE paragraph in the L928 heartbeats comment block documents a reverted experiment.
5. 240-line dead-code block (`/- ITER-076 disabled chain. ... -/`) in `Differentials.lean` L675–L912 with embedded sorries inside a comment.

### Changes Requested
1. Delete the Route 1 lemma at L728–L751 of `BasicOpenCech.lean` (docstring + signature + body, including unused `hPrev`).
2. Rewrite four stale docstrings to describe the bodies that landed (iter-104, iter-097, iter-099, iter-103 closures).
3. Replace the iter-107 deferral comment block inside `cechCofaceMap_pi_smul` with a single breadcrumb line.
4. Trim the iter-102 paragraph from the L928 heartbeats comment block.
5. Delete the ITER-076 dead-code block (L675–L912) from `Differentials.lean`.

## Changes Made

### File: AlgebraicJacobian/Cohomology/BasicOpenCech.lean

- **Change 2 (a)** — Replaced the `"Body left as ``sorry`` for the iter-105 prover. Proof sketch (~15 LOC): ..."` docstring paragraph (originally L488–L493) for `cechCofaceMap_summand_family_R_linear` with a description of the iter-104 closure (body-local `letI` reconstruction + `funext j'` + `Pi.smul_apply` pivot + `show`-to-`Pi.π Z_int j'` form + `unfold cechCofaceMap_summand_family` + `Pi.lift_π_apply` + `ConcreteCategory.comp_apply` + body-local `hSym` from `piIsoPi_inv_kernel_ι_apply` + `RingHom.toModule_smul` + term-level `Eq.trans + congrArg + presheafMap_restrict_collapse`).
- **Change 1** — Deleted the entire Route 1 declaration `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (docstring + theorem + body with `rcases n; · omega; · have hPrev := ...; sorry`). The file now jumps from the closing `)` of `cechCofaceMap_summand_family'_R_linear`'s body straight to `set_option maxHeartbeats 800000 in` for `alternating_sum_pi_smul_aux`. Grep across the project confirms no external references to the deleted lemma name.
- **Change 2 (b)** — Replaced the `"Body left as ``sorry`` for the iter-097 prover. Proof sketch: induct on..."` docstring paragraph for `alternating_sum_pi_smul_aux` with a description of the iter-097 closure (`Finset.cons_induction` + simultaneous-side `simp only` chain: empty case via `Finset.sum_empty`/`ModuleCat.hom_zero`/`LinearMap.zero_apply`/`map_zero`/`smul_zero`; cons step via `Finset.sum_cons`/`ModuleCat.hom_add`/`LinearMap.add_apply`/`map_add` + `hF` on the head + IH on the tail + `smul_add`).
- **Change 2 (c)** — Replaced the `"Body left as ``sorry`` for the iter-099 prover. Proof sketch: rw [Preadditive.sum_comp s G E] ..."` docstring paragraph for `alternating_sum_pi_smul_aux_sum_comp` with a description of the iter-099 closure (`intro r y; rw [Preadditive.sum_comp s G E]; exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ G i ≫ E) e₁ e₂ hG r y`).
- **Change 2 (d)** — Replaced the `"Body left as ``sorry`` for the iter-103 prover. Proof sketch (~5-10 lines): ..."` docstring paragraph for `alternating_zsmul_pi_smul_aux_sum_comp` with a description of the iter-103 closure (binder-level Path B: `intro r y; rw [Preadditive.sum_comp s (fun i ↦ σ i • G i) E]; simp_rw [Preadditive.zsmul_comp]; exact alternating_sum_pi_smul_aux ... (per-summand show + map_zsmul e₂ (σ i) + hG i hi r y + smul_comm (σ i) r)`).
- **Change 4** — Removed the iter-102 NOTE paragraph (5 lines documenting a reverted experiment) from the L928 heartbeats comment block; kept only the iter-087 paragraph that justifies the actual 1600000 budget.
- **Change 3** — Replaced the 6-line iter-106 / iter-107 deferral block inside `cechCofaceMap_pi_smul`'s body (the one telling the prover to "lift maxHeartbeats to 3200000+") with the single breadcrumb line `-- iter-107 plan: option 3 (in-line per-coord scalar pullback; wrapper bypassed).`. The iter-105 partial-proof scaffold (S1–S5 chain, wrapper R-linearity instantiation, `h_wrap_pt`, trailing `sorry`) and the iter-099/100/101/103/105 scalar-extraction chain at L1098–L1144 are byte-for-byte preserved. `set_option maxHeartbeats 1600000 in` at the theorem head is untouched.
- **Cascading:** None. No declaration name or signature was changed. The deleted Route 1 lemma was unused outside its own file.

### File: AlgebraicJacobian/Differentials.lean

- **Change 5** — Deleted the 238-line block `/- ITER-076 disabled chain. ... (sorry) -/` (originally L675–L912; documentation of the iter-076 attempted tactic chain with two `sorry` placeholders inside comment text). After deletion, the file flows from the `smul_induction_on` recursion that ends `rw [map_smul, ha']; rfl` (now around L673) directly into the `/-- Cotangent exact sequence for a composition of schemes X ⟶ Y ⟶ S. -/` docstring. The 5 live sorries (now at L113, L517, L711, L727, L871 per the post-refactor compile output) are intact and unchanged.
- **Cascading:** None. The deleted text was entirely inside a `/- ... -/` comment.

## New Sorries Introduced
None. Two sorries were eliminated:
- `BasicOpenCech.lean` — the Route 1 lemma body sorry (was at the deleted `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`).
- `Differentials.lean` — the 2 `(sorry)` strings inside the deleted ITER-076 comment block were never live sorries (they are inside `/- ... -/`), so the live-sorry count is unchanged at 5.

Net: BasicOpenCech sorry count 7 → 6 (Route 1 removed); Differentials sorry count 5 → 5 (unchanged). Project total 15 → 14.

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **compiles** (warnings only — unused variables `hU`, `hn`, `h_mod_pi*` in the iter-104/iter-105 R-linearity lemmas' signatures, present before this refactor; plus 2 `declaration uses sorry` warnings for `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` at L928 and `cechCofaceMap_pi_smul` at L1195, both expected). No errors.
- `AlgebraicJacobian/Differentials.lean`: **compiles** (warnings only — 5 `declaration uses sorry` warnings at L113, L517, L711, L727, L871, matching the 5 live sorries). No errors.
- `sorry_analyzer.py AlgebraicJacobian --format=summary`: 14 total across 5 files (BasicOpenCech 6, Differentials 5, Jacobian 1, Modules/Monoidal 1, Picard/Functor 1) — matches the directive's expected outcome exactly.

## Notes for Plan Agent

- Mathematical justification was sufficient; no judgment calls were required outside the directive's scope.
- The `archon-protected.yaml` surface is untouched — none of the protected declarations live in either edited file.
- Constraints honored: no new axioms; no other `.lean` files touched; no protected signatures modified; no `set_option maxHeartbeats` changes; bodies of `cechCofaceMap_summand_family_R_linear`, `alternating_sum_pi_smul_aux`, `alternating_sum_pi_smul_aux_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear` byte-for-byte preserved; iter-105 partial-proof scaffold inside `cechCofaceMap_pi_smul` preserved except for the directed Change 3 comment edit.
- The compiler still emits the iter-104/iter-105 "unused variable" warnings (`hU`, `hn`, body-local `h_mod_pi*`); these predate this refactor. They could be silenced by underscoring or `set_option linter.unusedVariables false` in a future polish pass, but doing so is out of scope for iter107-cleanup.
- The iter-107 prover lane can now attack the trailing `sorry` at the post-Change-3 line (now `BasicOpenCech.lean` L1195) via option 3 (in-line per-coord). The local context above the `sorry` retains the iter-105 wrapper hypothesis `h_wrap_pt` so the prover can choose to use it or bypass it.
