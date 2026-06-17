# AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Summary
- **Declarations added (axiom-clean):** 0.
- **Declarations blocked:** 1 — `moduleSpecΓFunctor_pushforward_tilde_iso` (the global-sections
  fragment of the tilde pushforward dictionary). Construction skeleton typechecks; the lone
  `map_smul'` goal is blocked by a typeclass-instance wall (details below). Not added (no `sorry`
  left in the file).
- **Sorry count (this file): 2 → 2** (unchanged; the two pre-existing documented deep sorries at
  `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`). No new sorries.
- Existing locality lemmas re-verified axiom-clean (`Modules.isIso_iff_isIso_app_affineOpens`:
  axioms = `{propext, Classical.choice, Quot.sound}`).

## Orientation / scouting (confirmed Mathlib facts, reusable next iter)
- `Scheme.Modules` pushforward/pullback live in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`;
  `pushforward_obj_obj : Γ((pushforward f).obj M, U) = Γ(M, f ⁻¹ᵁ U)` is `rfl`. `(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤`
  (`by simp`); the global-section carriers of `pushforward (Spec.map φ) (tilde M)` over `R` and of
  `tilde M` over `R'` are **defeq as types** (verified by `rfl`).
- Tilde dictionary in `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`: `tilde.functor R : ModuleCat R ⥤ (Spec R).Modules`,
  `moduleSpecΓFunctor : (Spec R).Modules ⥤ ModuleCat R` (= `modulesSpecToSheaf ⋙ forget ⋙ eval (op ⊤)`),
  adjunction `tilde.adjunction : tilde.functor R ⊣ moduleSpecΓFunctor` with `IsIso (unit)`, counit
  `Scheme.Modules.fromTildeΓ` + `isIso_fromTildeΓ_iff` (iso ⇔ quasicoherent), and `IsQuasicoherent`
  **only** as an instance on `tilde M`. There is **no** lemma that `pushforward (Spec.map φ)` preserves
  `IsQuasicoherent`.
- The R-module structure produced by `moduleSpecΓFunctor` is `Module.compHom` along
  `(StructureSheaf.globalSectionsIso R).hom` of the `Γ(Spec R,⊤)`-action.
- `PresheafOfModules.pushforward φ = pushforward₀ F R ⋙ restrictScalars φ`
  (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean`) — so the pushforward module
  structure **is** `restrictScalars` along the ring-sheaf map.
- Key naturality lemma: `Scheme.ΓSpecIso_naturality` / `Scheme.ΓSpecIso_inv_naturality`
  (`Mathlib/AlgebraicGeometry/Scheme.lean:613/619`):
  `f ≫ (ΓSpecIso S).inv = (ΓSpecIso R).inv ≫ (Spec.map f).appTop`. `(globalSectionsIso R).hom = ofHom (algebraMap)`,
  `(ΓSpecIso R).inv = ofHom (algebraMap)`.
- `set_option backward.isDefEq.respectTransparency false` is **required** for any iso between
  `restrictScalars`-of-Spec-modules to even typecheck (Mathlib's Tilde.lean uses it pervasively).

## `moduleSpecΓFunctor_pushforward_tilde_iso` (NOT added)
**Goal target:**
`(restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R:=R')).obj (tilde M))
   ≅ (moduleSpecΓFunctor (R:=R)).obj ((pushforward (Spec.map φ)).obj (tilde M))`
for `φ : R ⟶ R'`, `M : ModuleCat R'`. (This is the Γ-level version of dictionary piece (1) in
PROGRESS.md / `informal/affineBaseChange_pushforward_iso.md`; the full object-level
`pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)` additionally needs
quasi-coherence of the pushforward, which is itself a separate large build.)

- **Construction skeleton — RESOLVED (typechecks):** with `respectTransparency false`,
  `LinearEquiv.toModuleIso (X₁ := …carrier…) (X₂ := …carrier…)` taking the identity
  `AddEquiv.refl` on the common carrier reduces the entire problem to one `map_smul'` goal.
- **`map_smul'` — BLOCKED.** After `erw [ModuleCat.restrictScalars.smul_def]` the LHS becomes
  `φ.hom r • s` (an `R'`-action, defeq). The RHS `r • s` is the `R`-action of
  `moduleSpecΓFunctor (R)` of the pushforward = `Module.compHom (gSI R).hom` of the `Γ(Spec R,⊤)`-action
  = `restrictScalars ((Spec.map φ).appTop)` of the `Γ(Spec R',⊤)`-action. Mathematically both sides
  equal `c • s` for a common `Γ(Spec R',⊤)`-action, with the two scalars equal by
  `ΓSpecIso_inv_naturality`. **The blocker is purely instance-level:** the intermediate
  `Γ(Spec R,⊤)`- and `Γ(Spec R',⊤)`-actions are buried inside `Module.compHom` / `ModuleCat.restrictScalars`
  and are **not synthesizable `SMul`/`Module` instances on the final carrier type**, so none of
  `change`/`rw`/`rfl`/`IsScalarTower.algebraMap_smul`/`simp [moduleSpecΓFunctor]` can name the common
  `Γ(Spec R',⊤)`-action to perform the `congr` to scalar equality. (Confirmed by `lean_multi_attempt`:
  `change … globalSectionsIso … • s` → "failed to synthesize HSMul ↑(structureSheaf R').obj … …".)

### Attempts (all FAILED, with exact reason)
- `show φ.hom r • s = _` — OK (LHS R'-form reachable); `show … = r • s` / `change φ.hom r • s = r • s` —
  FAIL (RHS smul instance is the buried `Module.compHom` one, not defeq to the named target).
- `change (globalSectionsIso R').hom.hom (φ.hom r) • s = _` — FAIL: `HSMul Γ(Spec R',⊤) carrier` not synthesizable.
- `erw [restrictScalars.smul_def]` twice — fires only on the `restrictScalars` (LHS) layer, not the
  `compHom` (RHS / moduleSpecΓ) layer.
- `rfl` — FAIL (naturality is not definitional).
- `IsScalarTower.algebraMap_smul` — FAIL ("typeclass instance problem is stuck", needs the same buried SMul).
- `Module.compHom_smul_apply` — unknown constant.
- Informal agent — UNAVAILABLE: `MOONSHOT_API_KEY` → HTTP 401 "Invalid Authentication"; no
  `DEEPSEEK/OPENROUTER/OPENAI/GEMINI` key set (documented also in prior iters).

### Two concrete next-step routes (pick one next iter)
1. **Term-mode `@`-explicit smul reduction.** Thread the `Module.compHom` (gSI R) and the
   pushforward `restrictScalars ((Spec.map φ).appTop)` instances by hand with `@SMul.smul`/`@HSMul.hSMul`
   to expose both sides as `Γ(Spec R',⊤)`-actions, then `congr 1` and close with `ΓSpecIso_inv_naturality`.
   High effort (the instance terms are large — see attempt logs), but no new Mathlib needed.
2. **Functorial (element-free) construction — PARTIALLY PROBED, RECOMMENDED.** Use the identity-carrier
   isos `ModuleCat.restrictScalarsComp'App` (`(restrictScalars gf).obj M ≅ (restrictScalars f).obj ((restrictScalars g).obj M)`,
   `hom_apply M x = x`) and `restrictScalarsId'App`, plus an `eqToIso`/congruence from the RingHom equality
   `(gSI R').hom.hom ∘ φ.hom = ψ ∘ (gSI R).hom.hom : R → Γ(Spec R',⊤)` (= `ΓSpecIso_inv_naturality`). All maps
   stay identity-carrier, so **no element smul is ever touched**. Plan:
   - LHS = `(restrictScalars φ.hom).obj ((moduleSpecΓ R').obj (tilde M))`
     ≅ `(restrictScalars ((gSI R').hom.hom ∘ φ.hom)).obj W`.
   - RHS = `(moduleSpecΓ R).obj (pushforward (Spec.map φ) (tilde M))`
     ≅ `(restrictScalars (ψ ∘ (gSI R).hom.hom)).obj W`.
   - connect by `restrictScalars (ringeq) W`.
   **Probe results this iter (lean_run_code, `respectTransparency false`):**
   - **Step (a) CONFIRMED by `rfl`:** `(moduleSpecΓFunctor (R:=R')).obj (tilde M)
     = (ModuleCat.restrictScalars (StructureSheaf.globalSectionsIso R').hom.hom).obj W`, where
     `W := ((evaluation _ _).obj (op ⊤)).obj ((TopCat.Sheaf.forget _ _).obj
       ((SheafOfModules.forgetToSheafModuleCat (Spec R').ringCatSheaf (op ⊤)
         (Limits.initialOpOfTerminal Limits.isTerminalTop)).obj (tilde M)))`.
   - **Step (b) BLOCKED on plumbing:** recognizing `(moduleSpecΓ R).obj (pushforward (Spec.map φ) (tilde M))`
     as `(restrictScalars (gSI R).hom.hom).obj ((restrictScalars ψ).obj W)` needs the explicit pushforward
     ring map `ψ : Γ(Spec R,⊤) → Γ(Spec R',⊤)`. `(Spec.map φ).toRingCatSheafHom` is an `InducedCategory.Hom`
     (NOT a `Sheaf.Hom`), so `.val.app (op ⊤)` does **not** project — the next prover must dig out the ring
     map from `SheafOfModules.pushforward` / `PresheafOfModules.pushforward = pushforward₀ ⋙ restrictScalars`
     internals (the `φ.hom`/`sheafPushforwardContinuous` plumbing). Also verify whether
     `(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤` holds by `rfl` (it currently closes by `simp`, not obviously `rfl`); if not
     `rfl`, the `W` on the pushforward side is `Γ(tilde M, (Spec.map φ)⁻¹ᵁ ⊤)` and needs an `eqToHom`/`Opens`
     transport to match `W` at `⊤`. Once `ψ` and the common-`W` defeq are pinned, the whole iso assembles
     from `restrictScalarsComp'App` + the ring-map equality with zero element-smul.

## Note for the planner
Even with the global-sections iso closed, `affineBaseChange_pushforward_iso` does **not** close:
the remaining chain still needs (a) the object-level `pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)`
(requires quasi-coherence of the pushforward — Mathlib-absent), (b) the pullback dictionary
(`pullback (Spec.map φ)` ≅ base change `-⊗[R]R'`), (c) the fibre-product identification
`X' = Spec(R'⊗_R A)`, and (d) matching the adjoint-mate `pushforwardBaseChangeMap.app U` to
`TensorProduct.AlgebraTensorModule.cancelBaseChange`. This is a multi-iteration engine build; the
global-sections fragment above is a necessary-but-not-sufficient first brick. Recommend treating the
two routes above as the next binary probe for this lane.

## Blueprint markers
- No declarations became formalized this iteration, so no `\leanok`-readiness changes. The three
  `lem:modules_isIso_*` locality lemmas (already pinned/closed in prior iters) remain axiom-clean.
- The chapter's `lem:affine_base_change_pushforward` / `thm:flat_base_change_pushforward` proofs remain
  documented sorries (correctly carry `% NOTE:` annotations already).
