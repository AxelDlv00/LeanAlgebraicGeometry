# Iter-223 objectives detail — Lane TS.dual sub-step 3 FINAL CLOSE

Funded `mathlib-build` block A.1.c.SubT.dual (sheaf internal-hom / dual of 𝒪_X-modules),
elapsed 4 of ~6–12 iters. Sub-steps 1 (value module, iter-219) and 2 (restriction maps +
assembled presheaf `internalHom`, iter-220) RETIRED axiom-clean. Sub-step 3 (the `dual`
object + the evaluation morphism `internalHomEval`) is at ~90%: iter-221 landed `dual` +
`internalHomEvalApp` + 5 eval helpers; iter-222 SOLVED the `Over.map` coherence obstacle
(`restr_map_homMk`, `dual_map_app_terminal` — axiom-clean) and assembled `internalHomEval`,
leaving ONLY its `naturality` field as a typed `sorry`. THIS iter closes that sorry.

**MODE SWITCH:** lane was `mathlib-build` for sub-steps 1–3a; this iter is `[prover-mode: prove]`
— the objective is to fill ONE existing sorry whose recipe is fully worked out, which the
mathlib-build dispatcher_notes explicitly route to `prove`.

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: prove]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra`, block
`lem:internal_hom_eval` (math complete + correct; the whnf-fix below is Lean-tactical and
intentionally lives HERE, not in the blueprint — blueprint-clean would strip tactic content).
Source: `references/stacks-modules.tex` (§Internal Hom, tag area 01CM).
iter-222 handoff (the precise bomb diagnosis + three fixes):
`task_results/archive/iter-222/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`.

### PRIMARY target — close the `internalHomEval` naturality `sorry` (project 81→80)

`internalHomEval : M ⊗_R M^∨ ⟶ 𝟙_` is already assembled with `app X := internalHomEvalApp M X`.
The `naturality` field is a typed `sorry` because the iter-222 assembly route hit a `whnf`
heartbeat BOMB (>3.2M heartbeats, ~exponential — NOT budget-bound) localized to instantiating
the private `rfl`-bridge `restr_map_homMk` at the CONCRETE unit object `𝟙_` (its whnf normal
form is enormous). The naturality reduction is otherwise DONE and verified in pieces:

  after `intro X Y f; refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)`, then
  `change`/`erw [Monoidal.tensorObj_map_tmul]`/`rw [internalHomEvalApp_tmul, internalHomEvalApp_tmul]`
  reduces to **G**: `evalLin M Y ((dual M).map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)`,
  and `key := PresheafOfModules.naturality_apply φ (Over.homMk f.unop).op s` closes it MODULO the
  `restr_map_homMk` unit-instantiation that bombs.

### The fix — make every step SYNTACTIC, never `whnf` the unit `𝟙_`

**PRIMARY ROUTE (#2, recommended — uses verified Mathlib API):** replace the `rfl`-bridge
`restr_map_homMk` with Mathlib's pushforward map-action lemmas so matching is syntactic and the
unit's enormous whnf normal form is never forced:

- `PresheafOfModules.pushforward_obj_map_apply`  **[verified iter-223 via loogle]**
  (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pushforward`):
  `(((pushforward φ).obj M).map f).hom m = (M.map (F.map f.unop).op) m`.
- `PresheafOfModules.pushforward_map_app_apply`  **[verified iter-223 via loogle]** (same module):
  `(((pushforward φ).map α).app X).hom m = (α.app (op (F.obj (unop X)))) m`.

Note `restr U M = pushforward₀ (Over.forget U)` and `pushforward₀ F R = pushforward (𝟙 (F.op ⋙ R))`
(so apply the above with `φ = 𝟙`); `(Over.forget U).map (Over.homMk f.unop) = f.unop` reduces
`F.map f.unop` to exactly `M.map f`. Rewrite `key` with these instead of `restr_map_homMk (𝟙_) f`.

**FALLBACK ROUTE (#1):** generalize the unit. Before `naturality_apply` / `rw …at key`,
`set U := 𝟙_ (PresheafOfModules …)` (or `generalize`), perform the `restr_map_homMk` /
`naturality_apply` / `exact` with `U` ABSTRACT (cheap — verified for abstract M), then
`subst`/specialize `U := 𝟙_` only at the very end where no further whnf is forced.

**FALLBACK ROUTE (#3):** close **G** elementwise without `exact key.symm`: after the syntactic
`rw [dual_map_app_terminal, restr_map_homMk]` (avoiding the unit-instantiation form), finish with
`LinearMap.ext` / `congr 1` / `exact (key …)` where every remaining goal is between small
(`evalLin` / `φ.app`) terms.

Already-landed, axiom-clean ingredients to reuse (do NOT re-derive): `internalHomEvalApp_tmul`,
`restr_map_homMk` (cheap for abstract N), `dual_map_app_terminal` (`hom_app_heq` + `congrArg Over.mk
(Category.id_comp f.unop)` — note this is in the iter-222 handoff, may need re-landing in-file),
the iter-220 `hom_app_heq` private helper.

### Success bar
- `internalHomEval` axiom-clean → `lean_verify PresheafOfModules.internalHomEval` =
  `{propext, Classical.choice, Quot.sound}`. Project sorry 81→80. Sub-step 3 RETIRED.
- Keep build GREEN. The reduction is fully worked out and the primary route uses two verified
  Mathlib lemmas — a real close is expected, not a re-statement.
- If route #2 AND #1 AND #3 ALL fail to close it (genuinely new obstacle), leave the typed sorry
  GREEN + a precise handoff naming WHICH route failed and why — this triggers the iter-224 STUCK
  escalation (mathlib-analogist consult, NOT another helper round). Do not invent a 4th helper.

### Ride-along (LAST, comment-only — do NOT touch proof bodies)
- Fix the stale file-header `## Status (current)` block (≈L37–47): it lists 3 sorry residuals but
  the actual count was 4 this entry (the `internalHomEval` naturality sorry). Once you CLOSE that
  sorry it returns to 3 — update the header to read the correct post-close count (the 3 residuals
  `isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`)
  and drop any "fourth sorry" language. (lean-auditor ts222 major #1.)
- If NOT closed: header must read 4 and list `internalHomEval` among residuals.

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (sub-step 5) or `addCommGroup_via_tensorObj`
  (RPF consumer) — iter-214 d.1 anti-pattern.
- Do NOT touch `tensorObj_assoc_iso`'s PROOF / delete the still-live whiskering decls (assoc
  re-route deferred jointly with the dual — needs `SheafOfModules` morphism descent).
- Do NOT attempt sub-step 4 (`lem:internal_hom_isSheaf` sheafification / `Scheme.Modules.dual`).
- Do NOT raise `set_option maxHeartbeats` to brute-force the bomb — the cost is exponential, not
  budget-bound; that is NOT a fix and leaves a fragile decl. Use a syntactic route.
- Do NOT undertake the 14-site `Sheaf.val` → `ObjectProperty.obj` deprecation migration.

### STUCK escalation tripwire (progress-critic ts223)
- progress-critic ts223 = CHURNING (mechanical PARTIAL×4) but endorsed THIS dispatch as the
  correct corrective; STUCK clock RESET (the iter-221 `Over.map` blocker was solved; the whnf bomb
  is a distinct first-occurrence). If iter-223 reports the whnf bomb AGAIN with none of the three
  fixes closing it, iter-224 MUST run a mathlib-analogist consult (whnf-friendly
  `PresheafOfModules.Hom` naturality API that avoids the `𝟙_` reduction) BEFORE re-dispatching.
