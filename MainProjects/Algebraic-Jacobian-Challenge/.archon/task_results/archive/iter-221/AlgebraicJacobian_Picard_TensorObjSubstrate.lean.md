# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Summary
- **Declarations added (6, all axiom-clean — `{propext, Classical.choice, Quot.sound}`):**
  1. `PresheafOfModules.dual` (def) — **PRIMARY target 1, DONE.** Blueprint `def:presheaf_dual`.
  2. `PresheafOfModules.InternalHom.termRingMap_terminal` (lemma) — helper: `termRingMap` at the terminal object's own op is the identity.
  3. `PresheafOfModules.evalLin` (def) — the over-ring→`R₀.obj X` cast of `φ ↦ (s ↦ φ(s))`.
  4. `PresheafOfModules.evalLin_add` (lemma) — `evalLin` additive in `φ`.
  5. `PresheafOfModules.evalLin_smul` (lemma) — `evalLin` `R₀.obj X`-linear in `φ`.
  6. `PresheafOfModules.internalHomEvalApp` (def) — the **open-by-open** bilinear contraction `(M(X)) ⊗_{R(X)} (M|_X ⟶ R|_X) → R(X)`, `s ⊗ φ ↦ φ(s)`. This is the mathematical heart of `internalHomEval`.
- **Declaration blocked (1):** `PresheafOfModules.internalHomEval` (the full morphism of presheaves of modules `M ⊗ M^∨ ⟶ R`, blueprint `lem:internal_hom_eval`) — its `naturality` field needs `Over.map`-coherence work (iter-220 `hom_app_heq`/`subst` style). NOT added (no sorry left behind).
- **Ride-along fixes done:** `@[implicit_reducible]` added to `internalHomObjModule` (lean-auditor ts220 major); stale L37–45 status docstring + `internalHomObjModule` docstring corrected (comment-only).
- **Sorry count in file:** 3 → 3 (unchanged; the 3 pre-existing typed-`sorry`s at `isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` were NOT touched, per FORBIDDEN list). No new sorry added.
- **File compiles:** whole-file `lean_diagnostic_messages severity=error` returns empty.

## Blueprint markers (for review agent / sync_leanok)
- `def:presheaf_dual` `\lean{PresheafOfModules.dual}` — **ready for `\leanok`** (built, axiom-clean).
- `lem:internal_hom_eval` `\lean{PresheafOfModules.internalHomEval}` — **NOT ready** (decl of that exact name does not yet exist; only the per-object map `internalHomEvalApp` + helpers are built). sync_leanok will correctly leave it unmarked.
- Suggestion to plan agent: consider pinning the new helpers in the chapter (`internalHomEvalApp` could back a "open-by-open contraction" sub-block under `lem:internal_hom_eval`, mirroring how `internalHomObjModule`/`restrictionMap` back `def:presheaf_internal_hom`).

## PresheafOfModules.dual (RESOLVED — axiom-clean)
- **Approach:** `dual M := InternalHom.internalHom M (𝟙_ ...)`. Verified `𝟙_ (PresheafOfModules ...) = PresheafOfModules.unit ...` by `rfl`. Placed in a new `section Dual` with `{D : Type u} [Category.{u,u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}` (the single-universe `Opens X` site, matching `internalHom`).
- **Result:** RESOLVED.

## PresheafOfModules.InternalHom.termRingMap_terminal (RESOLVED — axiom-clean)
- `termRingMap hT (op T) f = f`: `hT.from T = 𝟙 T` by `hT.hom_ext`, then `R.map_id`. Reopened the `InternalHom` namespace after the Assembly block (NOTE: the original `end InternalHom` that closed the Assembly namespace must be kept — I briefly deleted it by accident; the structure is now `end Assembly` / `end InternalHom` / `namespace InternalHom` (helpers) / `end InternalHom` / `section Dual`).

## PresheafOfModules.evalLin (RESOLVED — axiom-clean) — KEY TRICK
- **The central diamond-bridge.** `φ.app(terminal)` is linear over the **over-category ring** `((Over.forget X.unop).op ⋙ R₀).obj (op (Over.mk (𝟙 X.unop)))`, which is *definitionally* — but NOT syntactically — `R₀.obj X`. A bare `map_smul`/codomain over `R₀.obj X` therefore fails instance synthesis.
- **Fix:** state `evalLin M X φ : (M.obj X : Type u) →ₗ[(R₀.obj X : Type u)] (R₀.obj X : Type u) := (φ.app term).hom`. The type ascription forces the defeq cast across the over-ring/scheme-ring diamond, and it typechecks. Codomain is `R₀.obj X` (NOT the unit value `(𝟙_).obj X`), because `(𝟙_).obj X` reduces to the bare ring carrier and loses the `PresheafOfModules` structure that carries the `CommRingCat` module instance.

## PresheafOfModules.evalLin_smul (RESOLVED — axiom-clean) — KEY TRICK
- Goal after `LinearMap.ext fun s => _; rw [LinearMap.smul_apply]`: `evalLin (c•φ) s = c • evalLin φ s`.
- The `homModule` action `c • φ = φ ≫ globalSMul c` reduces (rfl) the LHS to `termRingMap(op term) c •_{over-ring} (φ.app term).hom s`. **Crucial:** in the `change`, keep the evaluated value at its *natural over-ring type* `((φ : restr.. ⟶ restr..).app term).hom s` (NOT cast to `R₀.obj X`), so the over-ring smul typechecks; then `rw [termRingMap_terminal]` turns the scalar into `c`, and a final `rfl` discharges the over-ring-vs-`R₀.obj X` smul defeq.
- `termRingMap` needs its ring presheaf given explicitly: `termRingMap (R := (Over.forget X.unop).op ⋙ R₀) Over.mkIdTerminal ...`.

## PresheafOfModules.internalHomEvalApp (RESOLVED — axiom-clean) — KEY TRICK
- Built as `ModuleCat.ofHom (TensorProduct.lift (LinearMap.mk₂ (R₀.obj X) (fun s φ => evalLin M X φ s) ...))`.
- mk₂'s 4 obligations: linear-in-`s` = `map_add`/`map_smul` of `evalLin M X φ`; linear-in-`φ` = `evalLin_add`/`evalLin_smul` (+ `LinearMap.add_apply`/`smul_apply`, after a `change` to beta-reduce mk₂'s lambda).
- **The `ofHom` boundary diamond:** the def's return type `... ⟶ (𝟙_).obj X` (ModuleCat over the RingCat ring `(R₀⋙forget₂).obj X`) would otherwise force mk₂'s codomain `P` to the bare RingCat carrier (Module synthesis fails). **Fix:** wrap the body in `show ModuleCat.of (R₀.obj X) (TensorProduct (R₀.obj X) (M.obj X) ((dual M).obj X)) ⟶ ModuleCat.of (R₀.obj X) (R₀.obj X) from ...`. This pins the build over the `CommRingCat` ModuleCats (where `Semiring.toModule` exists) and lets the kernel defeq-check it against the pinned return type.

## PresheafOfModules.internalHomEval (NOT ADDED — precise handoff)
- **What's needed:** `Hom.mk` with `app X := internalHomEvalApp M X` and the semilinear `naturality` field. The field elaborates (goal confirmed via `lean_goal`).
- **Reduction (confirmed working):** `apply ModuleCat.MonoidalCategory.tensor_ext; intro s φ` reduces naturality to the simple-tensor equation. Computing both sides (via `ModuleCat.hom_comp`/`LinearMap.comp_apply`, `PresheafOfModules.Monoidal.tensorObj_map_tmul`, and an `internalHomEvalApp` tmul lemma) gives exactly:
  `evalLin M Y ((dual M).map f φ) (M.map f s) = (𝟙_).map f ((φ.app term_X).hom s)`.
- **The remaining gap (the iter-220 hard part):** this is `PresheafOfModules.naturality_apply φ ((Over.homMk f.unop).op) s` (`Mathlib/.../Presheaf.lean:112`), MODULO the `Over.map` coherence identifications:
  - `(dual M).map f φ = restrictionMap f.unop φ` (via `ofPresheaf_map` + `internalHomPresheaf` map = `restrictionMapAddHom`),
  - `(restrictionMap f.unop φ).app term_Y = φ.app (op (Over.mk f.unop))`, needing `(Over.map f.unop).obj (Over.mk (𝟙 Y.unop)) = Over.mk f.unop` (`Over.map_obj` + `id_comp`),
  - `(restr X.unop M).map (Over.homMk f.unop).op = M.map f` and `(restr X.unop 𝟙_).map (Over.homMk f.unop).op = (𝟙_).map f` (pushforward₀ map = `M.map (h.left).op`, `h.left = f.unop`).
  These are exactly the `Over.map` pseudofunctor-coherence steps that iter-220 cracked with `hom_app_heq`/`subst`. A helper `internalHomEvalApp_tmul` (`(internalHomEvalApp M X).hom (s ⊗ₜ φ) = evalLin M X φ s`, via `TensorProduct.lift.tmul`) is the first sub-step; I had it building modulo a stubborn codomain type-ascription (the same `(𝟙_).obj X` vs `R₀.obj X` issue — state it with the value at its natural type, NOT ascribed).
- **Dead end to avoid:** do NOT try to make the bilinear codomain literally `(𝟙_).obj X` — it reduces to the bare RingCat carrier and the `CommRingCat` module instance vanishes. Always land evaluation values in `R₀.obj X` and bridge with `show ... from` / defeq at the `ofHom` boundary.

## Why I stopped
- **Partial progress.** 6 axiom-clean declarations added (PRIMARY target 1 `dual` complete; the per-object evaluation map `internalHomEvalApp` — the mathematical content of PRIMARY target 2 — complete, plus its 3 supporting lemmas + 1 helper). The full morphism `internalHomEval` is blocked on the `Over.map`-coherence naturality assembly (named precisely above), which is genuine iter-220-level work and was not completed this session. No sorry introduced; all alternatives for the value-level build were exhausted and succeeded. The informal agent was not consulted (the blockers were Lean-elaboration diamonds, not mathematical — the math path is fully clear and recorded above).
