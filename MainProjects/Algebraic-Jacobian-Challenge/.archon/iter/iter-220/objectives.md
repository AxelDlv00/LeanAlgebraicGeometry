# Iter-220 objectives detail — Lane TS sub-step 2 (presheaf assembly of the internal hom)

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — [prover-mode: mathlib-build]

Funded sheaf-internal-hom build, sub-phase **A.1.c.SubT.dual**, sub-step **2 of 5**. iter-219 built
sub-step 1 (the per-object value module: `homModule`, `internalHomObjModule`, 11 axiom-clean decls,
file lines ~969–1140). This iter assembles the full presheaf.

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra` (gate-cleared this
iter, ts220fp2). Source: `references/stacks-modules.tex` §Internal Hom (tag 01CM). Recipe + cost:
`analogies/ts219dual.md`. iter-219 precise handoff: archived
`task_results/archive/iter-219/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md` ("Remaining work"
section).

### PRIMARY build targets (each a clean, no-sorry decl — mathlib-build contract)

1. **`PresheafOfModules.InternalHom.restrictionMap` (`lem:presheaf_internal_hom_restriction`).** For
   `g : V ⟶ U` in the base, the restriction map `(M|_U ⟶ N|_U) → (M|_V ⟶ N|_V)`, `φ ↦ φ|_V`,
   additive and **semilinear over `R(g) : R(U) → R(V)`** (`(f • φ)|_V = R(g)(f) • (φ|_V)`). Route
   (iter-219 handoff): `Over.map g : Over V ⥤ Over U` (precompose `_ ≫ g`); restrict a morphism over
   `Over U` to one over `Over V` by precomposition. Verify the associativity defeq
   `(Over.forget V).op ⋙ R = (Over.map g).op ⋙ (Over.forget U).op ⋙ R` (should be `rfl`, mirroring
   the terminal-ring `rfl` already used in `internalHomObjModule`). Semilinearity is: restricting the
   global-scalar endomorphism `globalSMul f` to `V` is `globalSMul (R(g) f)`.

2. **`PresheafOfModules.internalHom` (`def:presheaf_internal_hom`)** — the full presheaf. Package
   `U ↦ ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` (value = `internalHomObjModule`) + the step-1 restriction
   maps into `PresheafOfModules R` via `PresheafOfModules.ofPresheaf`/`mk`. Needs: the underlying
   `Cᵒᵖ ⥤ Ab` presheaf `U ↦ (M|_U ⟶ N|_U)` with the step-1 maps; per-object `Module (R(U))`
   (`internalHomObjModule`); the `map_smul` semilinearity compatibility (step 1). Functoriality
   (id/comp) from `Over.map` functoriality. GOTCHA (iter-219): `ModuleCat.of` of a hom-type module is
   fragile under `letI`; construct the `ModuleCat` value with instances explicit
   (`@ModuleCat.of … AddCommGroup Module`).

### DOWNSTREAM (push as far as budget allows; each clean/no-sorry)
- `PresheafOfModules.dual M := internalHom M (unit R)` (`def:presheaf_dual`).
- `PresheafOfModules.internalHomEval` `M ⊗ M^∨ → R`, sectionwise contraction `s ⊗ φ ↦ φ(s)`
  (`lem:internal_hom_eval`).

### Ride-along cleanup (LAST, optional — comment-only, do NOT touch proof bodies)
lean-auditor ts219 flagged stale docstrings (no math impact, but they misreport sorry status):
- L37–85 block header "Status (iter-202 Lane TS — file-skeleton scaffold)" — claims the 4 pinned
  decls carry `sorry` bodies; `tensorObj`/`tensorObj_functoriality`/`tensorObjOnProduct` are now
  complete. Update/remove.
- L1567 `tensorObjOnProduct` docstring "iter-202 Lane TS scaffold: typed `sorry`" — body is complete;
  fix.
- L1271 `tensorObj_assoc_iso` docstring "iter-212 status (typed `sorry`)" — body is real (sorry is in
  a downstream dependency); de-misleading + stale iter.
- L1201 "scaffold the iter-203+ bodies"; L1588 `addCommGroup_via_tensorObj` stale iter numbers.

### mathlib-build contract / success bar
No sorry in output (each step fully built or absent). Go as far as you can; stop only when genuinely
blocked and hand off a PRECISE decomposition of the next sub-step. **THIS iter's success = the
ASSEMBLED `PresheafOfModules.internalHom` (or genuine partial progress toward it with a clean
handoff), NOT more value-module helpers** (progress-critic ts220 watch item: producing the assembled
presheaf = CONVERGING; producing only more value-module helpers without assembly = first churn
signal). NOT closing `exists_tensorObj_inverse` (that is sub-step 5). Keep build GREEN.

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (blocked on this infra; iter-214 d.1 anti-pattern).
- Do NOT touch `tensorObj_assoc_iso` or delete the still-live whiskering decls (the assoc re-route is
  deferred jointly with the dual — both need `SheafOfModules` morphism descent).
