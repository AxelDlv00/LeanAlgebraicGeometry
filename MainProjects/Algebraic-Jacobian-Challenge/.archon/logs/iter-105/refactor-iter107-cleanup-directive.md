# Refactor Directive

## Slug
iter107-cleanup

## Problem

Two structural issues have accumulated in `BasicOpenCech.lean` that must be cleaned up before the iter-107 prover lane can productively attempt the L1147 closure via option 3 (direct in-line per-coord proof, bypassing the iter-105/106 wrapper engine):

1. **Iter-106 Route 1 lemma is a dead-end scaffold.** The lemma `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'` (L728–L751) carries a sorry body and a computed-but-unused `have hPrev` (lean-auditor-iter104 major finding). The iter-106 prover tried 7 body-closure routes — all failed at the same eqToHom-vs-Pi.π transport across different index types. The strategy-critic + progress-critic both classified the wrapper-engine approach as STUCK / sunk cost; option 3 (in-line direct per-coord) is the committed route for iter-107. The Route 1 lemma is now inert dead-end infrastructure; back it out entirely.

2. **Lean-auditor-iter104 documented 4 stale "Body left as 'sorry'" docstrings** at L488 (`cechCofaceMap_summand_family_R_linear`), L760 (`alternating_sum_pi_smul_aux`), L823 (`alternating_sum_pi_smul_aux_sum_comp`), L871 (`alternating_zsmul_pi_smul_aux_sum_comp`) — all four bodies are now fully closed but the docstrings still admit a sorry. These are excuse-comments that silence the alarm on what is delivered.

3. **Iter-107 excuse-comment block inside `cechCofaceMap_pi_smul`** at L1168–L1173 ("Iter-107 plan-agent re-route: lift maxHeartbeats to 3200000+") defers a fix that has NOT been applied. The iter-107 plan has SWITCHED to option 3 (no heartbeat lift; bypass wrapper). The deferral block is now stale plan content.

4. **240-line dead-code block in `Differentials.lean` L675–L912** (lean-auditor-iter104 major finding). `/- ITER-076 disabled chain. Preserved as a reference block ... -/` with embedded sorries; doc belongs in blueprint or git history, not in live source.

## Mathematical justification

1. **Route 1 lemma removal**: the lemma stated `(named_family at Fin.cast hRel.symm i) ≫ eqToHom_outer = wrapper at i`, modulo `Fin.cast hRel.symm` roundtrip + index-type transport. The iter-106 prover's body attempts revealed that `eqToHom_naturality` is for naturality of single morphisms, not for transporting `Pi.π` through an eqToHom that arises from index-TYPE equality between two `Fin (... + 2)` and `Fin (n + 1)` instances. Mathlib does not directly expose object-equality eqToHom transport for indexed products. This is not a budget problem (raising heartbeats didn't help iter-106) — it is the wrong tactic surface. The committed iter-107 strategy is to skip the wrapper entirely: at the per-summand discharge in `cechCofaceMap_pi_smul`, apply `Pi.hom_ext` (or `funext + show` to expose `Pi.π Z₂ j' ≫ ...`) on the per-coord goal to reduce the morphism equality at coordinate `j'` to a per-coord scalar pullback, where the inner term is a NAMED Mathlib morphism (`Pi.π Z₁ index ≫ (toModuleKPresheaf C).map _.op`) — no anonymous closure, no discrim-tree blocker.

2. **Stale docstring corrections**: the four docstrings should describe the body that landed, not the body that was planned. E.g. for `cechCofaceMap_summand_family_R_linear` (closed iter-104): replace the "Body left as 'sorry' for the iter-105 prover. Proof sketch:" paragraph with "Body closed iter-104 via 50-LOC binder-level proof: `letI` reconstruction + `funext j'` + `Pi.smul_apply` pivot + `show`-to-`Pi.π Z_int j'` form + `unfold cechCofaceMap_summand_family` + `Pi.lift_π_apply` + `ConcreteCategory.comp_apply` + body-local `hSym` (via `piIsoPi_inv_kernel_ι_apply`) + `RingHom.toModule_smul` (rfl) + term-level `Eq.trans + congrArg + presheafMap_restrict_collapse`." Similar one-paragraph rewrites for L760/L823/L871.

3. **Iter-107 excuse-comment removal**: the iter-107 plan has committed to option 3 (no heartbeat lift). The block at L1168–L1173 must be removed; replace with a single short `-- iter-107 plan: option 3 (in-line per-coord)` line for breadcrumb.

4. **Differentials dead block**: documentation belongs in the chapter file (`Differentials.tex`) or in git history. Live source must not carry 240 lines of commented-out tactic code that contains sorries.

## Changes Requested

### Change 1 — Back out Route 1 lemma in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

Delete the entire iter-106 addition L728–L751 (the docstring + theorem signature + `rcases n with _ | n'; · omega; · have hPrev := ...; sorry` body). After deletion, the file should jump from L727 (the closing `)` of `cechCofaceMap_summand_family'_R_linear`'s body) directly to the existing `set_option maxHeartbeats 800000 in` block that introduces `alternating_sum_pi_smul_aux` (currently at L753).

### Change 2 — Rewrite four stale docstrings in `BasicOpenCech.lean`

For each of the four declarations below, REPLACE the docstring paragraph that admits a sorry with a one-paragraph description of the body that actually landed:

- **L488–L493 (or near, before `theorem cechCofaceMap_summand_family_R_linear`)**: replace the "Body left as 'sorry' for the iter-105 prover" paragraph with a description of the iter-104 closure (50-LOC binder-level proof).
- **L760–L778 (before `theorem alternating_sum_pi_smul_aux`)**: replace the "Body left as 'sorry' for the iter-097 prover" paragraph with a description of the iter-097 closure (`Finset.cons_induction` + simultaneous-side `simp only`).
- **L823–L829 (before `theorem alternating_sum_pi_smul_aux_sum_comp`)**: replace "Body left as 'sorry' for the iter-099 prover" paragraph with description of the iter-099 closure (`intro r y; rw [Preadditive.sum_comp]; exact alternating_sum_pi_smul_aux ...`).
- **L871–L886 (before `theorem alternating_zsmul_pi_smul_aux_sum_comp`)**: replace "Body left as 'sorry' for the iter-103 prover" paragraph with description of the iter-103 closure (binder-level Path B: `intro r y; rw [Preadditive.sum_comp]; simp_rw [Preadditive.zsmul_comp]; exact alternating_sum_pi_smul_aux ... (per-summand show + map_zsmul + smul_comm + hG)`).

Keep the rest of each docstring (statement-of-result, mathematical content, usage notes) intact.

### Change 3 — Remove iter-107 excuse-comment block inside `cechCofaceMap_pi_smul` body

In `cechCofaceMap_pi_smul` body, DELETE the comment block at L1168–L1173:
```
  -- Iter-106 attempt to use Route 1 lemma ...
  -- ... Iter-107 plan-agent re-route: lift maxHeartbeats to 3200000+ for the `cechCofaceMap_pi_smul`
  -- theorem head, then retry the Route 1 chain at this position.
```

REPLACE with a single line:
```
  -- iter-107 plan: option 3 (in-line per-coord scalar pullback; wrapper bypassed).
```

Do NOT modify any other comment in `cechCofaceMap_pi_smul`'s body. Do NOT modify the iter-105 partial-proof scaffold at L1144–L1167 or the trailing `sorry`. Do NOT modify the iter-099/100/101/103/105 scalar-extraction chain at L1098–L1144. Do NOT touch `set_option maxHeartbeats 1600000 in` at L937 (keep budget unchanged).

### Change 4 — Trim iter-102 NOTE block in `BasicOpenCech.lean`

In the `-- Iter-087: lifted to 1600000 ...` comment block at L928–L936, REMOVE the iter-102 paragraph that documents a reverted experiment:
```
-- Iter-102 NOTE: the attempted use of `alternating_zsmul_pi_smul_aux_sum_comp`
-- at the L773 call site forced a transient 8x heartbeat bump (12800000)
-- that still timed out at whnf; the call site was reverted to use
-- `alternating_sum_pi_smul_aux_sum_comp` and the budget restored to 1600000.
-- The sister lemma remains available as inert infrastructure for iter-103.
```

Keep only the iter-087 paragraph (the actual non-reverted heartbeat budget rationale).

### Change 5 — Remove 240-line dead-code block in `AlgebraicJacobian/Differentials.lean`

Delete the entire `/- ITER-076 disabled chain. Preserved as a reference block ... -/` block at L675–L912 (lean-auditor-iter104 major finding). The block contains commented-out tactic source plus 2 embedded sorries (which are NOT counted as live sorries — they're inside a comment). After deletion, the file should compile end-to-end with the same 5 live sorries as before (L122, L636, L957, L974, L1116; line numbers will shift downward by ~237).

DO NOT modify any of the 5 live sorries' surrounding context.

## Affected Files

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — Changes 1, 2, 3, 4.
- `AlgebraicJacobian/Differentials.lean` — Change 5.

## Expected Outcome

After this refactor:
- `BasicOpenCech.lean` sorry count: 6 (was 7; Route 1 lemma at L751 removed).
- `Differentials.lean` sorry count: 5 (unchanged; the 2 sorries inside the deleted comment block were NOT live).
- Project total: 14 (was 15).
- Both files compile end-to-end.
- The lean-auditor-iter104 major findings on stale docstrings + dead scaffold + iter-107 excuse-comment + Differentials dead block are all resolved.

## Verification (mandatory)

Before writing your report, run:
```
PATH=$HOME/.elan/bin:$PATH lake env lean AlgebraicJacobian/Cohomology/BasicOpenCech.lean
PATH=$HOME/.elan/bin:$PATH lake env lean AlgebraicJacobian/Differentials.lean
```
Both must exit 0 (or warnings only, no errors). Also run:
```
${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian --format=summary
```
Confirm total = 14 (BasicOpenCech 6, Differentials 5, Modules/Monoidal 1, Jacobian 1, Picard/Functor 1).

## Constraints

- **No new axioms.**
- **Do not touch any other `.lean` file** beyond the two listed.
- **Do not modify any protected signature** in `archon-protected.yaml`.
- **Do not touch `set_option maxHeartbeats`** (keep iter-087's 1600000 at the `cechCofaceMap_pi_smul` head; keep iter-078's 800000 at `alternating_sum_pi_smul_aux` and `cechCofaceMap_pi_smul` neighbours).
- **Do not modify any body** of a closed theorem. Bodies of `cechCofaceMap_summand_family_R_linear`, `alternating_sum_pi_smul_aux`, `alternating_sum_pi_smul_aux_sum_comp`, `alternating_zsmul_pi_smul_aux_sum_comp`, `cechCofaceMap_summand_family'`, `cechCofaceMap_summand_family'_R_linear` are byte-for-byte preserved.
- **Do not modify the iter-105 partial-proof scaffold at L1099–L1178 inside `cechCofaceMap_pi_smul`** (except for the Change 3 comment edit). The S1–S5 chain + wrapper-R-linearity instantiation + `h_wrap_pt` partial proof must remain so the iter-107 prover sees the prior context.
