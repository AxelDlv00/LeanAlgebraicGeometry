# Iter-221 objectives detail — Lane TS.dual sub-step 3

Funded `mathlib-build` block A.1.c.SubT.dual (sheaf internal-hom / dual of 𝒪_X-modules),
elapsed 2 of ~6–12 iters. Sub-steps 1 (value module, iter-219) and 2 (restriction maps +
assembled presheaf `internalHom`, iter-220) are RETIRED axiom-clean. This iter = sub-step 3.

## File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` [prover-mode: mathlib-build]

Blueprint: `chapters/Picard_TensorObjSubstrate.tex` §`sec:tensorobj_dual_infra`.
Source: `references/stacks-modules.tex` (§Internal Hom, tag area 01CM).
Recipe / cost map: `analogies/ts219dual.md`. iter-220 handoff:
`task_results/archive/iter-220/AlgebraicJacobian_Picard_TensorObjSubstrate.lean.md`.

### PRIMARY build target 1 — `PresheafOfModules.dual` (`def:presheaf_dual`)
`dual M := internalHom M R` (the internal hom into the unit/structure presheaf).
- The blueprint block (L2584–2602) gives `M^∨ := ℋom(M, R)`, value
  `M^∨(U) = (M|_U ⟶ R|_U)` the `R(U)`-module of `R|_U`-linear functionals.
- Should be a near-trivial alias once the unit presheaf `R` (the structure presheaf as
  a `PresheafOfModules` over itself) is named correctly. GOTCHA from iter-220: `internalHom`
  is stated over the single-universe base `{D : Type u}[Category.{u,u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}`
  (the `Opens X` site). Build `dual` in the SAME single-universe section so the universes line up.
  Identify the canonical "unit" `PresheafOfModules` (the regular representation of the
  structure presheaf, `M = R₀` viewed as a module over itself) — Mathlib's
  `PresheafOfModules.unit`/regular-module idiom if it exists [expected], else construct it
  from the ground ring presheaf.

### PRIMARY build target 2 — `PresheafOfModules.internalHomEval` (`lem:internal_hom_eval`)
The evaluation/contraction counit `ev_M : M ⊗_R M^∨ → R`, `s ⊗ φ ↦ φ(s)`.
- Blueprint block L2604–2651. On each open `U` it is the standard contraction
  `(M|_U) ⊗_{R(U)} (M|_U ⟶ R|_U) → R(U)`, `s ⊗ φ ↦ φ(s)`, bilinear over `R(U)`, natural
  in restriction because `φ(s)|_V = (φ|_V)(s|_V)`.
- The tensor is the presheaf tensor underlying `def:scheme_modules_tensorobj`.
- This is the harder of the two: needs the open-by-open contraction assembled into a
  morphism of presheaves of modules. Reuse the `restrictionMap` naturality machinery from
  iter-220 (`hom_app_heq`/`subst` trick for `Over.map` coherence) for the naturality square.

### Ride-along Lean fix (do this; NOT optional — lean-auditor ts220 major)
- `internalHomObjModule` (≈L1123) is a class-type `def` MISSING `@[implicit_reducible]`
  (the companion `homModule` at ≈L1082 has it). The compiler emits a warning and instance
  search for the `Module`/`SMul` on `M|_U ⟶ N|_U` may silently fail downstream (exactly when
  `dual`/`internalHomEval` elaborate `r • m`). Add `@[implicit_reducible]` to match `homModule`.

### Ride-along cleanup (LAST, optional, comment-only — do NOT touch proof bodies)
- Stale docstrings (lean-auditor ts219/ts220, re-locate by content since line numbers shifted):
  the L37–45 "iter-202 file-skeleton scaffold" status block now misreports `tensorObj`/
  `tensorObj_functoriality` as carrying sorry bodies (they are closed); the `internalHomObjModule`
  docstring (≈L1122) says `internalHom` "is the remaining downstream build" — it was assembled.

### mathlib-build contract / success bar
- No sorry in output. THIS iter's success = `dual` + `internalHomEval` built axiom-clean
  (or genuine partial toward `internalHomEval` + a clean handoff). NOT closing
  `exists_tensorObj_inverse` (sub-step 5).
- Keep build GREEN. `lean_verify` each new decl → `{propext, Classical.choice, Quot.sound}`.

### FORBIDDEN this iter
- Do NOT `prove`/pin `exists_tensorObj_inverse` (L1733) or `addCommGroup_via_tensorObj` (L1777)
  — both blocked on later sub-steps (4=sheafify, 5=inverse); iter-214 d.1 anti-pattern.
- Do NOT touch `tensorObj_assoc_iso` / delete the still-live whiskering decls (assoc re-route
  deferred jointly with the dual — needs `SheafOfModules` morphism descent).
- Do NOT attempt sub-step 4 (`lem:internal_hom_isSheaf` sheafification / `Scheme.Modules.dual`)
  — that is the next iter, and its blueprint block may be split first (see reviewer ts221).
