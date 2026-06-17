# AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Summary
- **Added (axiom-clean, 3 decls):**
  - `AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop` (ring-hom naturality crux).
  - `AlgebraicGeometry.gammaPushforwardIso` (the **Γ-fragment iso**, general `N`) — the
    keystone the iter-234/235 attempts could not build (carrier wall).
  - `AlgebraicGeometry.gammaPushforwardTildeIso` (Γ-fragment specialised to `tilde M`,
    the form the affine theorem consumes).
  - All three `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- **Blocked:** full object iso `pushforward_spec_tilde_iso` — NOT added. Its sole
  remaining obligation is **quasi-coherence of `(Spec φ)_* (tilde M)`** (Mathlib-absent,
  circular with the obvious counit route). Precise next-step routes documented below + in
  the file.
- **Sorry count across file:** 2 → 2 (unchanged; both pre-existing —
  `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`). No new sorry.

## `globalSectionsIso_hom_comp_specMap_appTop` (RESOLVED — axiom-clean)
- **Statement:** `(StructureSheaf.globalSectionsIso ↑R).hom ≫ (Spec.map φ).appTop =
  φ ≫ (StructureSheaf.globalSectionsIso ↑R').hom`.
- **Proof:** `globalSectionsIso ↑S . hom = (Scheme.ΓSpecIso S).inv` by `rfl`; rewrite both,
  close with `(Scheme.ΓSpecIso_inv_naturality φ).symm`.

## `gammaPushforwardIso` (RESOLVED — axiom-clean, the keystone)
- **Statement:** `(moduleSpecΓFunctor (R:=R)).obj ((pushforward (Spec.map φ)).obj N) ≅
  (ModuleCat.restrictScalars φ.hom).obj ((moduleSpecΓFunctor (R:=R')).obj N)` for general
  `N : (Spec R').Modules`.
- **Approach (element-free route (b), de-risked this iter):** both sides peel **by `rfl`**
  (verified by two `rfl` probes) to nested `ModuleCat.restrictScalars` towers over the
  common global-section module `SecN := Γ(N,⊤)` (the `forgetToSheafModuleCat` /
  `initialOpOfTerminal isTerminalTop` wrapping is an identity restriction). Reconcile by:
  `(restrictScalarsComp'App gsRhom pushTop … rfl SecN).symm ≪≫ eqToIso (congrArg …
  hcomp) ≪≫ (restrictScalarsComp'App φ.hom gsR'hom … rfl SecN)`, where
  `pushTop = ((Spec.map φ).toRingCatSheafHom.hom.app (op ⊤)).hom`, and the composite
  ring-hom equality `hcomp : pushTop.comp gsRhom = gsR'hom.comp φ.hom` comes from
  `globalSectionsIso_hom_comp_specMap_appTop` via `RingHom.ext` + `congr($_.hom x)`.
- **Why this beats iter-234/235:** NO element-level `smul` is touched — the construction
  is entirely at the `ModuleCat` object/functor level, so the carrier-instance wall (no
  synthesizable `Module Γ(SpecR',⊤) (carrier-alias)`) never arises.

## `gammaPushforwardTildeIso` (RESOLVED — axiom-clean)
- **Statement:** `(moduleSpecΓFunctor (R:=R)).obj ((pushforward (Spec.map φ)).obj (tilde M))
  ≅ (ModuleCat.restrictScalars φ.hom).obj M`.
- **Proof:** `gammaPushforwardIso φ (tilde M) ≪≫ (restrictScalars φ.hom).mapIso
  (tilde.toTildeΓNatIso.app M).symm` (uses the tilde-adjunction unit iso `Γ(M^~,⊤) ≅ M`).

## Route (a) — section-level `map_smul'` — FAILED (carrier wall), documented & abandoned
- The `LinearEquiv.toModuleIso` with `AddEquiv.refl` typechecks once annotated
  `≃ₗ[(R : Type u)]` (fixes `CommRingCat.of ↑R` synth; NO `respectTransparency` — supersedes
  iter-234). `map_smul'` reduces (via `rw [RingHom.id_apply]` + 4×
  `erw [ModuleCat.restrictScalars.smul_def]`) **exactly** to `A • m = B • m` with
  `A, B : Γ(Spec R',⊤)` equal by `ΓSpecIso_inv_naturality`.
- Every finisher fails on the alias-vs-reduced-type wall: `congr 1` → `whnf` timeout;
  `congrArg (· • m)`, type-forced binder, `change _ • (m : reduced) = _` → `failed to
  synthesize HSMul (alias) (carrier)`; `congr 2` → `RingHom`-type + `HEq` goals.
  **Dead end — do NOT retry any section-level finisher.** Route (b) above is the fix.

## `pushforward_spec_tilde_iso` (NOT ADDED — needs QC of pushforward)
- The object iso factors as `pushforward (tilde M) ⟵[fromTildeΓ] tilde (Γ(pushforward
  (tilde M))) ⟶[tilde.map gammaPushforwardTildeIso.hom] tilde (restrictScalars φ M)`. The
  second map is an iso (tilde of an iso). `fromTildeΓ (pushforward (tilde M))` is an iso
  **iff** `pushforward (Spec φ)_* (tilde M)` is quasi-coherent.
- QC of the pushforward is the **sole remaining obligation**. It is Mathlib-absent and
  circular with the counit route (`moduleSpecΓFunctor` reflects isos only between QC
  objects — the tilde-adjunction *unit* is the iso, not the counit, so `Γ(fromTildeΓ Y)`
  is always iso but that does not lift to `fromTildeΓ Y`).
- **Independent QC routes for the next prover:** (i) a `SheafOfModules.Presentation` of
  the pushforward; (ii) `SheafOfModules.IsQuasicoherent.of_coversTop` over basic opens
  with the slice/over-category restriction shown QC; (iii) build the object iso directly
  on basic opens via `Modules.isIso_of_isIso_app_of_isBasis` (already in THIS file) +
  `IsLocalizedModule` (`(restrictScalars φ M)` localised at `a` = `M` localised at `φ a`,
  since `a` acts through `φ a`). Route (iii) yields the object iso AND QC simultaneously.
- Recipe also in blueprint `Cohomology_FlatBaseChange.tex` (4-movement proof) +
  `analogies/fbc-dict.md`.

## Why I stopped
- **Real progress:** 3 axiom-clean declarations — `globalSectionsIso_hom_comp_specMap_appTop`
  (ring crux), `gammaPushforwardIso` (the keystone Γ-fragment iso that iter-234/235 could
  not build), `gammaPushforwardTildeIso` (affine-theorem-consumable form). The
  long-standing carrier wall on the Γ-fragment is **resolved** via the element-free
  `restrictScalarsComp'` + `eqToIso` route.
- **Decomposition advance:** route (a) confirmed dead with exact failure modes; route (b)
  fully executed; the object iso `pushforward_spec_tilde_iso` is now reduced to a single
  named obligation (QC of the pushforward) with three concrete attack routes.
- **Not attempted (out of budget):** QC of `pushforward (tilde M)` and hence the object
  iso + affine theorem. The deep `flatBaseChange_pushforward_isIso` (Čech + flatness)
  stays a documented sorry per PROGRESS.md (do NOT attempt).
- **Informal agent:** unavailable (`MOONSHOT_API_KEY` → HTTP 401; no other provider key).
- **Tooling notes:** file lacks `open Opposite` → use `Opposite.op` (not `op`).
  `ModuleCat.restrictScalarsComp'App` lives in `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`.
  The `forgetToSheafModuleCat … .val` accessor emits a deprecation warning (`Sheaf.val` →
  `ObjectProperty.obj`) — harmless, matches the project's deferred-polish posture.

## Blueprint flags (for review agent)
- `gammaPushforwardIso`, `gammaPushforwardTildeIso`, `globalSectionsIso_hom_comp_specMap_appTop`
  are bespoke supporting infra for `lem:pushforward_spec_tilde_iso`; no `\lean{}` pins
  exist yet. Planner may add hints + `\leanok`-eligible statement blocks if desired.
- `lem:pushforward_spec_tilde_iso` itself remains unformalized (QC obligation outstanding).
