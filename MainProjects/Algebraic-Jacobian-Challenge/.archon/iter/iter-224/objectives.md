# Iter-224 objectives detail — Lane TS.dual sub-step 3 CLOSE via analogist ts224dual

Funded block A.1.c.SubT.dual (sheaf internal-hom / dual of 𝒪_X-modules), elapsed 5 of ~6–12 iters.
Sub-steps 1 (value module, iter-219) and 2 (presheaf `internalHom` + restriction maps, iter-220)
RETIRED axiom-clean. Sub-step 3 (the `dual` object + the evaluation morphism `internalHomEval`) has
spanned iters 221→224. iter-221 landed `dual` + `internalHomEvalApp` + 5 eval helpers; iter-222
solved the `Over.map` coherence and ASSEMBLED `internalHomEval` with a typed naturality `sorry`;
iter-223 confirmed the `whnf` bomb is goal-wide and deferred to this analogist consult. THIS iter
closes that sorry via the analogist recipe.

**Mode:** `[prover-mode: prove]` — close ONE existing sorry whose recipe is now fully specified.

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: prove]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra`, block
`lem:internal_hom_eval` (math complete+correct; the fix is Lean-tactical/shape-level, intentionally
HERE not in the blueprint). Source: `references/stacks-modules.tex` (§Internal Hom, tag area 01CM).
Authoritative analogist rationale + citations: `analogies/ts224dual.md`. iter-223 prover handoff
(goal-wide bomb diagnosis + six-step reduction): `task_results/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`.

### PRIMARY target — close the `internalHomEval` naturality `sorry` (project 81→80)

`internalHomEval : M ⊗_R M^∨ ⟶ 𝟙_` is already assembled with `app X := internalHomEvalApp M X`; ONLY
the naturality field is a typed `sorry`. The six-step reduction is fully worked out and preserved
in-source. The naturality goal, after `intro X Y f; refine
ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)`, is:
```
((tensorObj M (dual M)).map f ≫ (restrictScalars _).map (internalHomEvalApp M Y)).hom (s ⊗ₜ φ)
  = (internalHomEvalApp M X ≫ (𝟙_).map f).hom (s ⊗ₜ φ)
```

**Root cause (mathlib-analogist ts224dual, api-alignment, ALIGN-WITH-MATHLIB):** the project writes
`dual M := InternalHom.internalHom M (𝟙_ …)` (TensorObjSubstrate.lean:1359). The `𝟙_` *instance
projection* `MonoidalCategoryStruct.tensorUnit` is embedded in `dual`'s body; since `dual M`
saturates the naturality goal, every `kabstract` (run by `rw`/`erw`/`simp`/`change` at the ambient
`.default` transparency) unfolds it and whnf's Mathlib's heavy unit machinery
(`PresheafOfModules.Monoidal.tensorUnit`), whose normal form is ~exponential. There is NO reusable
Mathlib counit (`MonoidalClosed (PresheafOfModules R)` does not exist — Decision 1
NEEDS_MATHLIB_GAP_FILL, re-confirms ts219dual; building one = the whole ts219 block, out of scope).

### The fix — two composable routes; TRY ROUTE A FIRST

**ROUTE A (FIRST — cheap, 0 signature changes, the DECISIVE experiment).** Wrap EACH rewriting
tactic in the naturality proof in `with_reducible`. Then `kabstract` runs at `.reducible` and leaves
the non-reducible defs `dual` / `internalHom` / `ofPresheaf` / `tensorUnit` FOLDED — no whnf bomb —
while the elementwise lemma LHSs are head-aligned with the goal and match anyway. Concretely:
```
intro X Y f
refine ModuleCat.MonoidalCategory.tensor_ext (fun s φ => ?_)
with_reducible rw [Monoidal.tensorObj_map_tmul, internalHomEvalApp_tmul, internalHomEvalApp_tmul]
-- reduces to G: evalLin M Y ((dual M).map f φ) (M.map f s) = ((𝟙_).map f).hom (evalLin M X φ s)
with_reducible rw [PresheafOfModules.Monoidal.tensorUnit_map]   -- RHS → ring map R.map f
-- step (★), step key (naturality_apply), step hdt (dual_map_app_terminal / hom_app_heq), close
```
Apply each of the six steps under `with_reducible` (or a `with_reducible simp only [...]`). DIRECT
monoidal-coherence precedent in Mathlib: `Mathlib/RepresentationTheory/Action.lean:157-158`
(`with_reducible convert …`, `all_goals with_reducible simp`); `conv`-localized variant
`Mathlib/Tactic/Conv.lean:123`. **This folds ALL the heavy defs at once**, so it is the decisive test
of whether a whnf-free close exists at the current object shape (iter-223 only made
`dual`/`internalHomEvalApp` irreducible — never `internalHom`/`ofPresheaf` — so this is genuinely a
new lever, not a retry).

**ROUTE B (only if ROUTE A still bombs — robust structural ALIGN, ~20–40 LOC, in-file only).**
Re-shape `dual` and `internalHomEval` onto the EXPLICIT unit `PresheafOfModules.unit …` rather than
the `𝟙_` projection (Mathlib's idiom — `unitHomEquiv` and the unitor-naturality proofs at
`…/Algebra/Category/ModuleCat/Presheaf/Monoidal.lean:110-122` are ALL written against `unit R`, never
`𝟙_`):
- `dual M := InternalHom.internalHom M (PresheafOfModules.unit …)`   (was `… (𝟙_ …)`);
- retype the `evalLin` cast site to `restr X.unop (PresheafOfModules.unit …)`;
- set `internalHomEval`'s codomain to `PresheafOfModules.unit …`. **Because `tensorUnit := unit _`
  (`Monoidal.lean:110`), `unit …` is DEFEQ to `𝟙_`, so every downstream `… ⟶ 𝟙_` consumer
  (`exists_tensorObj_inverse`, the group-law isos) still typechecks. This is a BODY change, NOT a
  signature break, and it does NOT touch sub-step 2's `internalHom` / `restrictionMap` (which are
  parametric in the second argument).**
- replace the `tensorUnit_map` step by `unit`'s definitional `R.map f` via `unit_map_one` /
  `unit_map_apply`.

There is NO `𝟙_ ≅ unit` iso in Mathlib (they are defeq); do NOT try to `rw [show 𝟙_ = unit from rfl]`
— that rewrite IS the toxic `kabstract`-over-`𝟙_` step. The fix is to never introduce `𝟙_`, not to
rewrite it away.

### Reuse (do NOT re-derive)
`internalHomEvalApp_tmul`, `restr_map_homMk`, `dual_map_app_terminal`, the private `hom_app_heq`,
`PresheafOfModules.naturality_apply`, `unit_map_apply`, `pushforward_obj_map_apply`, `tensorUnit_map`.

### Success bar
- `lean_verify PresheafOfModules.internalHomEval` = `{propext, Classical.choice, Quot.sound}`.
- Project sorry 81→80. Sub-step 3 RETIRED. Build GREEN.
- The recipe is concrete with Mathlib precedent — a real close is expected, not a re-statement.

### FAILURE handoff (triggers the iter-225 revert — do NOT invent more helpers)
If BOTH ROUTE A and ROUTE B fail to close the sorry, leave the typed sorry GREEN + a PRECISE handoff:
name which route failed and exactly where it bombed. In particular, if `with_reducible` STILL bombs,
that pins the toxicity to the `internalHom`/`ofPresheaf` body's defeq cost (not only the `𝟙_`
projection) — record that. Per progress-critic ts224, iter-225 then executes the REVERT-to-ABSENT
fallback (revert `internalHomEval` to absent, sorry 81→80) and advances the lane frontier to
sub-step 4 (sheaf condition — does NOT depend on the eval morphism).

### Ride-along (LAST, comment-only — do NOT touch proof bodies; lean-auditor ts223)
- (a) file-header `## Status` block (≈L37–57): post-close → 3 residuals
  (`isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`),
  drop `internalHomEval`/whnf-bomb language; if NOT closed → keep 4.
- (b) `tensorObj_assoc_iso` docstring (≈L1644): "iter-212 typed `sorry`" → closed at direct-sorry
  level; sorry-transitive only via `isLocallyInjective_whiskerLeft_of_W`.
- (c) `tensorObjOnProduct` docstring (≈L1937): "iter-202 scaffold typed `sorry`" → now complete.
- (d) `exists_tensorObj_inverse` inline (≈L1926): "no internal-hom" → "no **sheaf-level**
  (`SheafOfModules`) internal-hom/dual/evaluation".

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (sub-step 5) or `addCommGroup_via_tensorObj` (RPF
  consumer) — iter-214 d.1 anti-pattern.
- Do NOT touch `tensorObj_assoc_iso`'s PROOF / delete the still-live whiskering decls.
- Do NOT attempt sub-step 4 (`lem:internal_hom_isSheaf` sheafification / `Scheme.Modules.dual`).
- Do NOT raise `set_option maxHeartbeats` to brute-force the bomb (exponential, not budget-bound —
  not a fix, leaves a fragile decl). Use `with_reducible` (ROUTE A) or the `unit`-reshape (ROUTE B).
- Do NOT undertake the 14-site `Sheaf.val` → `ObjectProperty.obj` deprecation migration.
