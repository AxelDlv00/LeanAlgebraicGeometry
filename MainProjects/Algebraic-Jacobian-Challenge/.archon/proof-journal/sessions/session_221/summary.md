# Session 221 — Review Summary

## Session metadata

- **Iteration / session:** 221. One prover (opus, mathlib-build), status **PARTIAL**.
- **Lane:** funded Decision-1 sheaf internal-hom build (committed iter-219; ~6–12 iters),
  **sub-step 3 of 5** (presheaf dual + evaluation counit). Elapsed 3.
- **Sorry (file `TensorObjSubstrate.lean`):** 3 → 3 (unchanged; expected for a mathlib-build
  iter). The 3 untouched residuals are `isLocallyInjective_whiskerLeft_of_W`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`.
- **Build GREEN** (whole-file `lean_diagnostic_messages` errors empty at session end).
- **blueprint-doctor: CLEAN** — every chapter `\input`'d, every `\ref`/`\uses` resolves,
  every annotation non-empty, no `axiom` decls.
- **`sync_leanok`:** iter 221, sha `b263bbf6`, **added 2**, removed 0, chapter
  `Picard_TensorObjSubstrate.tex`. The 2 added markers are the axiom-clean dual block;
  `lem:internal_hom_eval` correctly stays UNMARKED (the `internalHomEval` decl does not exist
  yet — only the per-object `internalHomEvalApp`). Not laundering.

## Targets attempted

### `PresheafOfModules.dual` (`def:presheaf_dual`) — SOLVED, axiom-clean (PRIMARY target 1)

- **Approach:** `dual M := InternalHom.internalHom M (𝟙_ ...)`, the iter-220 internal hom
  specialised at the monoidal unit (structure presheaf as a module over itself). Verified
  `𝟙_ (PresheafOfModules ...) = PresheafOfModules.unit ...` by `rfl`. Placed in a new
  `section Dual` `{D : Type u}[Category.{u,u} D]{R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}` (the
  single-universe `Opens X` site matching `internalHom`).
- **Result:** RESOLVED, `{propext, Classical.choice, Quot.sound}`. This is the contravariant
  object the iter-219 analogist judged "absent at presheaf, sheaf AND categorical level" — now
  built project-side at the presheaf level.

### `PresheafOfModules.internalHomEvalApp` — SOLVED, axiom-clean (heart of PRIMARY target 2)

- **Approach:** `ModuleCat.ofHom (TensorProduct.lift (LinearMap.mk₂ (R₀.obj X) (fun s φ =>
  evalLin M X φ s) ...))` — the per-open `R(X)`-bilinear contraction
  `(M(X)) ⊗_{R(X)} (M|_X ⟶ R|_X) → R(X)`, `s ⊗ φ ↦ φ(s)`.
- **Errors hit:** `failed to synthesize Module ↑(R₀.obj X) ↑((𝟙_ ...).obj X)` — the `(𝟙_).obj X`
  codomain reduces to the bare `RingCat` carrier, losing the `CommRingCat` module.
- **Fix:** `show ModuleCat.of (R₀.obj X) _ ⟶ ModuleCat.of (R₀.obj X) (R₀.obj X) from ...` at the
  `ofHom` boundary (pins the build over `CommRingCat` ModuleCats). mk₂'s 4 obligations: linear
  in `s` = `map_add`/`map_smul` of `evalLin`; linear in `φ` = `evalLin_add`/`evalLin_smul`
  (+ `add_apply`/`smul_apply`, after a `change` to beta-reduce mk₂'s lambda).
- **Result:** RESOLVED, axiom-clean.

### `evalLin`, `evalLin_add`, `evalLin_smul`, `termRingMap_terminal` — SOLVED, axiom-clean

- `evalLin M X φ : (M.obj X) →ₗ[R₀.obj X] (R₀.obj X) := (φ.app term).hom` — the type ascription
  forces the defeq cast across the over-ring/scheme-ring diamond (`φ.app term` is linear over
  `((Over.forget X.unop).op ⋙ R₀).obj _`, defeq-not-syntactic to `R₀.obj X`).
- `evalLin_add`: `rfl` (Hom-addition is definitionally additive on `app`/`hom`).
- `evalLin_smul`: keep the value at its NATURAL over-ring type in `change`,
  `rw [termRingMap_terminal]`, then `rfl` discharges the smul defeq. `termRingMap` needs its
  ring presheaf passed explicitly: `termRingMap (R := (Over.forget X.unop).op ⋙ R₀) ...`.
- `termRingMap_terminal`: `termRingMap hT (op T) f = f` via `hT.hom_ext` + `R.map_id`.

### `PresheafOfModules.internalHomEval` (`lem:internal_hom_eval`) — BLOCKED (no sorry left)

- **What's needed:** `Hom.mk` with `app X := internalHomEvalApp M X` and the semilinear
  `naturality` field.
- **Reduction (fully worked out, recorded in task_results):** `apply
  ModuleCat.MonoidalCategory.tensor_ext; intro s φ` reduces naturality to
  `evalLin M Y ((dual M).map f φ) (M.map f s) = (𝟙_).map f ((φ.app term).hom s)` =
  `PresheafOfModules.naturality_apply φ (Over.homMk f.unop).op s` MODULO `Over.map`-coherence
  identifications (`(dual M).map f = restrictionMap f.unop`; `(restr X M).map (Over.homMk
  f.unop).op = M.map f`; etc.).
- **The gap:** exactly the `Over.map` pseudofunctor-coherence steps iter-220 cracked for
  `restrictionMap` via the private helper `hom_app_heq` (`subst h; rfl`) + `eq_of_heq`. The
  prover also attempted a helper `internalHomEvalApp_tmul` (reverted — same `(𝟙_).obj X`
  codomain ascription issue). NOT added; no sorry introduced.

## Ride-along Lean fixes (done)

- `@[implicit_reducible]` added to `internalHomObjModule` (lean-auditor ts220 major).
- Stale L37–45 "iter-202 file-skeleton scaffold" status block + `internalHomObjModule`
  docstring corrected (comment-only).

## Key findings / patterns

- Three reusable diamond-bridge tricks (over-ring CAST via `evalLin` ascription; keep eval
  value at natural over-ring type in `change`; `show ... from ofHom ...` at the `ofHom`
  boundary; NEVER land eval in `(𝟙_).obj X`). Banked to PROJECT_STATUS Knowledge Base.
- The blocked `internalHomEval` has a precedented, recorded fix — this is a slip, not a wall.

## Blueprint markers updated (manual)

- None this iter. `def:presheaf_dual` was marked by the deterministic `sync_leanok` (added 2).
  `lem:internal_hom_eval` correctly remains unmarked (decl absent). No `\mathlibok` /
  `\lean{}` correction / `\notready` change was warranted (the dual is project-proved, not
  Mathlib-backed; the prover's `\lean{}` pins match the chapter).

## Review subagents

- `lean-auditor` (ts221): **0 must-fix**, 3 major, 6 minor. Confirmed all 6 focus decls
  axiom-clean and `@[implicit_reducible]` on `internalHomObjModule` present; 3 pre-existing
  sorries, no new ones. Major items = 2 stale status docstrings (`tensorObjOnProduct` ~L1853,
  `tensorObj_assoc_iso` ~L1562) + 14 deprecated `Sheaf.val` uses.
- `lean-vs-blueprint-checker` (ts221): verdict PARTIAL, **0 blocking must-fix**. `def:presheaf_dual`
  faithful & axiom-clean; `lem:internal_hom_eval` pin is (expectedly) ahead of the Lean —
  `sync_leanok` correctly leaves it unmarked; no `\lean{}` rename to apply.
- Full findings + actions in `recommendations.md`. Reports:
  `logs/iter-221/lean-auditor-ts221-report.md`,
  `logs/iter-221/lean-vs-blueprint-checker-ts221-report.md`.

## Notes (LOW)

- lean-auditor flagged 4× `set_option backward.isDefEq.respectTransparency false` and a blanket
  `import Mathlib` as fragility/style smells (not bugs). The 3 pre-existing sorries
  (`isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj`) all carry honest, detailed decompositions — no excuse-comments.

## Recommendation for next session

Continue the funded build — assemble `internalHomEval` reusing the iter-220 `restrictionMap`
functoriality proof (`hom_app_heq` + `subst`) as template; the reduction is already done.
Track by sub-step retirement (3 of ~6–12), not the flat sorry counter.
