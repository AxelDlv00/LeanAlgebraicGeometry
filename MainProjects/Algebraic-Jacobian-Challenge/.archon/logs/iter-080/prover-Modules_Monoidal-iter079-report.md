# AlgebraicJacobian/Modules/Monoidal.lean

## Iter-079 outcome — net 2 → 1 sorries (-1; both targets closed via `LocalizedMonoidal`)

Sorries closed: `instMonoidalCategoryStruct` (L135-138), `instMonoidalCategory` (L142-145).
Sorries remaining: `instIsMonoidal_W` (L126, the single permitted GAP-FILL).
File compiles cleanly (no errors; 1 warning, the expected `sorry` warning).

Both originally-targeted sorries are now derived as `inferInstanceAs` from the Mathlib
`CategoryTheory.LocalizedMonoidal` machinery. The substantive content is concentrated in
the single semantic gap-fill `instIsMonoidal_W`, exactly as the plan agent's recipe directed.

## instMonoidalCategoryStruct (line 135) — RESOLVED

### Attempt 1
- **Approach:** `inferInstanceAs (MonoidalCategoryStruct (LocalizedMonoidal L W (Iso.refl _)))`.
- **Result:** RESOLVED. Both target instances now derive from `Localization.Monoidal.monoidalCategoryStruct`
  (Mathlib `CategoryTheory/Localization/Monoidal/Basic.lean:172`), given:
  - `(sheafificationFunctor X).IsLocalization (W X)` — from `Adjunction.isLocalization` applied to
    `PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)` (right adjoint is Full + Faithful,
    `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:168, 171`).
  - `(W X).IsMonoidal` — the gap-fill below.
  - `MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)` — bridging instance,
    `instMonoidalCategoryPresheaf`, derived via `show ... from inferInstance` to bridge the
    definitional equality `X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ ...`.

## instMonoidalCategory (line 142) — RESOLVED

### Attempt 1
- **Approach:** `inferInstanceAs (MonoidalCategory (LocalizedMonoidal L W (Iso.refl _)))`.
- **Result:** RESOLVED. Same architecture as `instMonoidalCategoryStruct` — pentagon, triangle,
  and naturality axioms transfer via `Localization.Monoidal.MonoidalCategory` instance
  (`Basic.lean:440`).

## instIsMonoidal_W (line 126) — IN PROGRESS (permitted GAP-FILL)

### Attempt 1
- **Approach:** `MorphismProperty.IsMonoidal.mk'`, reducing to: if `L f` and `L g` are isos
  in `X.Modules`, then `L (f ⊗ₘ g)` is also iso.
- **Result:** PARTIAL. The reduction step (`simp only [MorphismProperty.inverseImage_iff,
  MorphismProperty.isomorphisms.iff] at hf hg ⊢`) produces the goal
  `IsIso ((sheafificationFunctor X).map (f ⊗ₘ g))`, with hypotheses
  `hf : IsIso (L.map f)`, `hg : IsIso (L.map g)`.
- **Stuck on:** the substantive iso-stability of sheafification under presheaf-tensor whiskering.

### Why this is hard
Verified the following routes are blocked:

1. **Decomposition via `tensorHom_def`** (`f ⊗ₘ g = (f ▷ Y₁) ≫ (X₂ ◁ g)`): reduces to two
   instances of `L.map (h ▷ Z)` iso / `L.map (Z ◁ h)` iso when `L.map h` is iso. These are
   exactly the `IsMonoidal.whiskerLeft` and `IsMonoidal.whiskerRight` conditions — no progress.

2. **Reduction via `sheafificationCompToSheaf`**: `L.map h` iso iff
   `(presheafToSheaf AddCommGrpCat).map ((toPresheaf R₀).map h)` iso (since `SheafOfModules.toSheaf`
   reflects isos and `sheafificationCompToSheaf` gives the natural iso `L ⋙ toSheaf ≅ toPresheaf ⋙ presheafToSheaf`).
   - **Blocked because:** `toPresheaf R₀` is NOT a monoidal functor. The presheaf-tensor on
     `PresheafOfModules R₀` evaluates pointwise as the `R₀(U)`-balanced tensor product on
     `M(U) ⊗_{R₀(U)} N(U)`, whereas `toPresheaf R₀ M ⊗ toPresheaf R₀ N` (in `Cᵒᵖ ⥤ AddCommGrpCat`)
     would be the ℤ-tensor product. The presheaf-of-modules tensor and the abelian-presheaf
     tensor differ — `toPresheaf R₀` does not preserve tensors, so `J.W.IsMonoidal` for `AddCommGrpCat`
     (provided by Mathlib in `Sites/Monoidal.lean:149` under braided+closed assumptions) cannot
     transfer directly.

3. **Closedness route** (`Sites/Monoidal.lean` precedent): the Mathlib proof of `J.W.IsMonoidal`
   uses internal-hom adjunction `Hom(F ⊗ G, H) ≅ Hom(G, [F, H])` plus the fact that `[F, H]` is
   a sheaf when `H` is. For `PresheafOfModules R₀` with `R₀` varying over open sets, this requires
   `MonoidalClosed (PresheafOfModules R₀)` and `HasFunctorEnrichedHom`/`HasEnrichedHom` for
   presheaves of modules — substantial infrastructure not currently in Mathlib for the varying-value
   case. Note: `Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean` provides closedness for
   `ModuleCat R` over a *fixed* ring, but the varying-ring case is missing.

### Status
Single `sorry` retained in `instIsMonoidal_W` (line 126) per the user policy permitting one
semantic gap-fill (cf. `task_pending.md` "One semantic-gap-fill is explicitly permitted: the
`W.IsMonoidal` instance ..."). Both targeted closures (`instMonoidalCategoryStruct`,
`instMonoidalCategory`) are completed and use this instance.

### Next session next step
1. **Most promising route** (estimated 100-200 LOC if attempted): manually verify pointwise
   that `(sheafification α).map (Y ◁ f)` is iso by:
   - Using `sheafification_map` (`Sheafification.lean`) to expose `L.map h` via `sheafifyMap`
     and `(presheafToSheaf AddCommGrpCat).map ((toPresheaf R₀).map h)`.
   - Identifying the underlying-AB-group map of `(toPresheaf R₀).map (Y ◁ f)`: pointwise this
     is `id_{Y(U)} ⊗_{R₀(U)} f.app(U) : Y(U) ⊗_{R₀(U)} X₁(U) → Y(U) ⊗_{R₀(U)} X₂(U)` viewed in
     `AddCommGrpCat`.
   - Building an auxiliary lemma: if `f : M → N` is locally surjective + locally injective
     (as a presheaf of abelian groups), then so is `1 ⊗ f : R ⊗_R M → R ⊗_R N` for any presheaf
     of modules `R`. This is a `Presheaf.IsLocallyInjective`/`Presheaf.IsLocallySurjective`
     argument at the level of stalks.
2. **Cleaner long-term route**: upstream the `MonoidalClosed (PresheafOfModules R₀)` instance
   to Mathlib + `HasFunctorEnrichedHom` for presheaves of modules. Then `Sites/Monoidal.lean`'s
   approach transfers directly. This is a multi-PR Mathlib upstream effort.

## Architectural notes

- **`tensorObj` def at L60-66 preserved byte-for-byte** from iter-078, as required.
- The localization's `tensorObj` (induced by `MonoidalCategoryStruct.tensorObj` from
  `Localization.Monoidal.monoidalCategoryStruct`) is `((tensorBifunctor L W ε).obj M).obj N`, which
  unfolds to `sheafification` of the presheaf tensor (via `Localization.lift₂`). The file's
  `tensorObj` definition `L.obj (F.obj M ⊗ F.obj N)` is naturally isomorphic but **not** definitionally
  equal to the localization's; both routes coexist in the file.
- **Bridging instance** `instMonoidalCategoryPresheaf` is needed at top level (not just `letI`
  inside proof bodies) because `(W X).IsMonoidal` and `LocalizedMonoidal` references occur in the
  *types* of subsequent instances. This bridges the definitional equality
  `X.ringCatSheaf.obj = X.sheaf.obj ⋙ forget₂ CommRingCat RingCat`. Not a "thin helper" — purely
  structural, required for type-class inference to find the syntactic `R ⋙ forget₂` form expected
  by `PresheafOfModules.monoidalCategory`.

## Mathlib references confirmed iter-079

- `CategoryTheory.LocalizedMonoidal` — `Localization/Monoidal/Basic.lean:86`. Type synonym for `D`.
- `Localization.Monoidal.monoidalCategoryStruct` — `Basic.lean:172`. The monoidal structure.
- `Mathlib instance MonoidalCategory (LocalizedMonoidal ...)` — `Basic.lean:440`.
- `MorphismProperty.IsMonoidal.mk'` — `Basic.lean:50-54`. Reduces to tensorHom stability.
- `Adjunction.isLocalization` — `Localization/Adjunction.lean:139`. Right-adjoint Full+Faithful ⇒ left adjoint is localization.
- `PresheafOfModules.sheafificationAdjunction` — `ModuleCat/Presheaf/Sheafification.lean:124`.
  Right adjoint Full (`:168`) and Faithful (`:171`).
- `PresheafOfModules.monoidalCategory` — `ModuleCat/Presheaf/Monoidal.lean:125`.
- `MorphismProperty.inverseImage_iff` — for unfolding `(isomorphisms _).inverseImage L f`.
- `MorphismProperty.isomorphisms.iff` — for unfolding `(isomorphisms _) h ↔ IsIso h`.
- `MonoidalCategory.tensorHom_def` — `f ⊗ₘ g = (f ▷ Y₁) ≫ (X₂ ◁ g)`.

## Recommendations for plan agent

1. **Iter-080+ for Phase C step C1**: the `LineBundle` refactor can now proceed using `MonoidalCategory.Invertible`
   on `X.Modules`. The `instIsMonoidal_W` sorry does not block downstream uses of `MonoidalCategory X.Modules` —
   it only blocks anyone who needs `(W X).IsMonoidal` as a hypothesis (an unusual need; the typical user wants
   `MonoidalCategory X.Modules` itself, which is now an instance).
2. **Iter-080+ for `instIsMonoidal_W` closure**: the cleanest route is to upstream `MonoidalClosed (PresheafOfModules R₀)`
   to Mathlib (along with the variants of `HasFunctorEnrichedHom` / `isSheaf_functorEnrichedHom` for varying-ring
   PresheafOfModules), then transfer via `Sites/Monoidal.lean`. As a stopgap, a stalks-level argument
   (`Presheaf.IsLocallyInjective`/`Presheaf.IsLocallySurjective` on `1 ⊗ f`) may be tractable in 100-200 LOC.

## Constraints respected

- Both targeted closures (`instMonoidalCategoryStruct`, `instMonoidalCategory`) realised; net -1 sorry.
- One bridging instance added (`instMonoidalCategoryPresheaf`) — purely structural to bridge a definitional
  equality, not a "thin helper" in the user-policy sense (the gap-fill `instIsMonoidal_W` is the single semantic
  gap-fill, as authorised).
- No new axioms.
- `tensorObj` (L60-66) preserved byte-for-byte from iter-078.
- No `lean_run_code` pre-validation used (only `lean_diagnostic_messages`, `lean_goal`, `lean_hover_info`,
  `lean_multi_attempt`, `lean_leansearch`, `lean_loogle`).
- Hard cap honored: 2 sorries → 1 sorry (net -1).
- Target: ≤ 0 NOT reached, but matches the plan's expectation that the substantive remaining content is
  concentrated in the single gap-fill.

## Blueprint status

Theorem `thm:Modules_MonoidalCategory` (statement) → declarations exist; `\leanok` already on statement.
Theorem `thm:Modules_MonoidalCategory` (proof) → still uses a `sorry` (in `instIsMonoidal_W`); should NOT be
marked `\leanok` on the proof side until that closes. The `sync_leanok` deterministic phase should detect
this automatically.

Definition `def:Modules_tensorObj` → fully closed, ready for `\leanok` (also confirmed iter-078).
