# Iter-222 objectives detail — Lane TS.dual sub-step 3 COMPLETION

Funded `mathlib-build` block A.1.c.SubT.dual (sheaf internal-hom / dual of 𝒪_X-modules),
elapsed 3 of ~6–12 iters. Sub-steps 1 (value module, iter-219) and 2 (restriction maps +
assembled presheaf `internalHom`, iter-220) RETIRED axiom-clean. Sub-step 3 is at ~50%:
iter-221 landed `dual` (PRIMARY 1) + `internalHomEvalApp` + 5 helpers (the per-object heart
of PRIMARY 2); the full natural morphism `internalHomEval` slipped. THIS iter completes it.

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra`, block
`lem:internal_hom_eval` (enriched iter-222 by blueprint-writer ts222: `% NOTE:` + assembly
prose isolating the naturality step; gate-cleared blueprint-clean ts222).
Source: `references/stacks-modules.tex` (§Internal Hom, tag area 01CM).
iter-221 handoff (the worked-out reduction): `task_results/archive/iter-221/
AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md` §`internalHomEval (NOT ADDED)`.
iter-220 `restrictionMap` functoriality template (the `hom_app_heq` trick to port):
`task_results/archive/iter-220/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`.

### PRIMARY target — `PresheafOfModules.internalHomEval` (`lem:internal_hom_eval`)

The full morphism of presheaves of `R`-modules `ev_M : M ⊗_R M^∨ ⟶ R`, `s ⊗ φ ↦ φ(s)`.
Build as `Hom.mk` with `app X := internalHomEvalApp M X` (ALREADY BUILT iter-221) + the
semilinear `naturality` field. ONLY the naturality assembly remains.

**Recipe (port the iter-221 prover's own worked-out reduction — do NOT re-derive):**

1. **First sub-step — `internalHomEvalApp_tmul`** (simp lemma):
   `(internalHomEvalApp M X).hom (s ⊗ₜ φ) = evalLin M X φ s`, via `TensorProduct.lift.tmul`.
   GOTCHA (iter-221): state it with the eval value at its NATURAL over-ring type, NOT ascribed
   to `(𝟙_).obj X` — the `(𝟙_).obj X` (bare RingCat carrier) vs `R₀.obj X` (CommRingCat module)
   diamond loses the module instance. Land eval values in `R₀.obj X`; bridge with `show ... from`
   / defeq at the `ofHom` boundary.

2. **Reduce naturality**: `apply ModuleCat.MonoidalCategory.tensor_ext; intro s φ`. Computing both
   sides (via `ModuleCat.hom_comp`/`LinearMap.comp_apply`, `PresheafOfModules.Monoidal.tensorObj_map_tmul`,
   and `internalHomEvalApp_tmul`) gives exactly:
   `evalLin M Y ((dual M).map f φ) (M.map f s) = (𝟙_).map f ((φ.app term_X).hom s)`.

3. **Identify with `naturality_apply`**: the goal IS
   `PresheafOfModules.naturality_apply φ ((Over.homMk f.unop).op) s` (`Mathlib/.../Presheaf.lean:112`)
   MODULO three `Over.map` coherence identifications (all named in the handoff):
   - `(dual M).map f φ = restrictionMap f.unop φ` (via `ofPresheaf_map` + `internalHomPresheaf` map
     = `restrictionMapAddHom`);
   - `(restrictionMap f.unop φ).app term_Y = φ.app (op (Over.mk f.unop))`, needing
     `(Over.map f.unop).obj (Over.mk (𝟙 Y.unop)) = Over.mk f.unop` (`Over.map_obj` + `id_comp`);
   - `(restr X.unop M).map (Over.homMk f.unop).op = M.map f` and the same for `𝟙_`
     (pushforward₀ map = `M.map (h.left).op`, `h.left = f.unop`).

4. **Discharge the coherence steps** with the iter-220 `restrictionMap` functoriality template:
   the private helper `hom_app_heq φ (h : X = Y) : HEq (φ.app X) (φ.app Y)` (`subst h; rfl`) +
   `eq_of_heq`. SAME obstacle iter-220 cracked for `restrictionMap`; reuse the proof in shape.

### mathlib-build contract / success bar
- No sorry in output. Success = `internalHomEval` built axiom-clean (sub-step 3 RETIRED).
- `lean_verify PresheafOfModules.internalHomEval` → `{propext, Classical.choice, Quot.sound}`.
- Keep build GREEN. The reduction is already worked out → a REAL assembly attempt is expected.
  If genuinely blocked at a NEW obstacle, leave a clean partial + precise handoff (no sorry).

### Ride-along cleanup (LAST, optional, comment-only — do NOT touch proof bodies)
- Stale docstrings (lean-auditor ts221 major; re-locate by content, lines shift):
  `tensorObjOnProduct` (≈L1853) "iter-202 scaffold: typed `sorry`" — it is fully proved;
  `tensorObj_assoc_iso` status block (≈L1562) describes the superseded flatness route — the
  actual residual is `isLocallyInjective_whiskerLeft_of_W` (ROUTE (d)).

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (sub-step 5) or `addCommGroup_via_tensorObj`
  (RPF consumer) — iter-214 d.1 anti-pattern.
- Do NOT touch `tensorObj_assoc_iso`'s PROOF / delete the still-live whiskering decls (assoc
  re-route deferred jointly with the dual — needs `SheafOfModules` morphism descent).
- Do NOT attempt sub-step 4 (`lem:internal_hom_isSheaf` sheafification / `Scheme.Modules.dual`).
- Do NOT undertake the 14-site `Sheaf.val` → `ObjectProperty.obj` deprecation migration
  (deferred to a dedicated polish pass).

### STUCK watch (progress-critic ts222)
- `Over.map` coherence has blocked 2 consecutive iters (220 cracked it for `restrictionMap`;
  221 not yet for the eval naturality). If THIS iter reports it AGAIN despite porting `hom_app_heq`
  — OR the `tensor_ext` reduction fails to reach `naturality_apply` for a NEW structural reason —
  the 3-iter STUCK threshold is hit and iter-223 MUST run a mathlib-analogist consult (how
  `PresheafOfModules.Hom` naturality is proved when the restriction functor is `Over.map`-defined)
  BEFORE re-dispatching this lane.
