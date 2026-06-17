# AlgebraicJacobian/Modules/Monoidal.lean

## Iter-078 outcome — net 3 → 2 sorries (-1; one closure)

Sorries closed: `tensorObj` (L55 → L73 in the new layout).
Sorries remaining: `instMonoidalCategoryStruct` (L111), `instMonoidalCategory` (L123).
File compiles cleanly (no errors; 2 warnings, both expected `sorry` warnings).

## tensorObj (line 73) — RESOLVED

### Attempt 1
- **Approach:** Direct sheafification of presheaf tensor product.
  ```
  noncomputable def tensorObj (M N : X.Modules) : X.Modules :=
    letI : MonoidalCategoryStruct (_root_.PresheafOfModules.{u} X.ringCatSheaf.obj) :=
      show MonoidalCategoryStruct
        (_root_.PresheafOfModules.{u} (X.sheaf.obj ⋙ forget₂ CommRingCat.{u} RingCat.{u})) from
        inferInstance
    (_root_.PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
      ((Modules.toPresheafOfModules X).obj M ⊗ (Modules.toPresheafOfModules X).obj N)
  ```
- **Result:** RESOLVED.
- **Key insight:** The instance lookup for `MonoidalCategoryStruct (PresheafOfModules R₀)` requires `R₀` to syntactically present as `R ⋙ forget₂ CommRingCat RingCat` because that's the form in `PresheafOfModules.monoidalCategoryStruct`. Since `X.ringCatSheaf.obj` is `X.sheaf.obj ⋙ forget₂ CommRingCat RingCat` only via `sheafCompose`, we use a local `letI` + `show` to expose the form. Without this, `inferInstance` fails. There are also two `PresheafOfModules` names in scope (`_root_.PresheafOfModules` for the general one and `AlgebraicGeometry.Scheme.PresheafOfModules X`), so the `_root_` prefix is required for disambiguation. After these two fixes, the application elaborates cleanly with all type-class instances resolved (locally-bijective for `𝟙`, `HasWeakSheafify`, `WEqualsLocallyBijective` — all inferred from the `import Mathlib`).

## instMonoidalCategoryStruct (line 111) — IN PROGRESS

### Attempt 1
- **Approach:** Direct anonymous constructor `{...}` filling each field via sheafification of presheaf-side data.
  - `tensorObj := tensorObj X` ✓
  - `tensorUnit := L.obj (𝟙_ _)` — typeable.
  - `whiskerLeft M _ _ f := L.map (F.obj M ◁ F.map f)` — typeable.
  - `whiskerRight f N := L.map (F.map f ▷ F.obj N)` — typeable.
  - `tensorHom f g := L.map (F.map f ⊗ₘ F.map g)` — typeable.
  - **`associator`**: stuck. Need `tensorObj (tensorObj M N) K ≅ tensorObj M (tensorObj N K)`. Unfolding:
    - LHS: `L.obj (F.obj (L.obj (F.obj M ⊗ F.obj N)) ⊗ F.obj K)`
    - RHS: `L.obj (F.obj M ⊗ F.obj (L.obj (F.obj N ⊗ F.obj K)))`
    - These differ structurally; the inner `F.obj (L.obj _)` is `(F ∘ L) _`, the sheafification monad applied to the presheaf tensor. The two are connected by the unit `η : 1 ⟹ F ∘ L`, not by an iso.
  - **`leftUnitor`**, **`rightUnitor`**: same difficulty.
- **Result:** PARTIAL. Data fields filled, iso fields stuck.
- **Dead-end:** Trying to fill iso fields by naïve `Iso.refl`, sheafified presheaf-side iso, or `(L.map (α_ _ _ _).hom)` all fail type-checking because the source/target objects of the sheaf-side iso are not the sheafifications of the corresponding presheaf-side iso's source/target.

### Attempt 2 (architectural — the canonical resolution)
- **Approach:** Use `CategoryTheory.Localization.Monoidal.Basic` (`LocalizedMonoidal`) with `L := PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)` and `W := (isomorphisms _).inverseImage L`.
- **Prerequisites available:**
  1. `Adjunction.isLocalization` (Mathlib `CategoryTheory.Localization.Adjunction`) gives `G.IsLocalization ((MorphismProperty.isomorphisms _).inverseImage G)` whenever `G ⊣ F` and `F.Full + F.Faithful`. The right adjoint `SheafOfModules.forget R ⋙ restrictScalars α` is Full (Mathlib `PresheafOfModules/Sheafification.lean:168`) and Faithful (`:171`), so this directly applies to our `sheafification (𝟙 X.ringCatSheaf.obj)`.
  2. `LocalizedMonoidal L W (Iso.refl _)` and the matching `Localization.Monoidal.monoidalCategoryStruct` instance: off-the-shelf in `Localization/Monoidal/Basic.lean`.
- **Missing piece (the single semantic gap-fill):**
  - `W.IsMonoidal` — i.e., for `W := (isomorphisms _).inverseImage sheafification` on `PresheafOfModules X.ringCatSheaf.obj`, `W` is stable under left + right whiskering (`MorphismProperty.IsMonoidal`).
  - Substantively: if `sheafification f` is an iso, then `sheafification (X ◁ f)` is also an iso. This holds because sheafification is a **left adjoint** and the presheaf tensor product is a **colimit-preserving bifunctor** on each variable (cf. `PresheafOfModules.monoidalCategory` and the underlying `ModuleCat.tensorObj` colimit-preservation). Sketch: `sheafification (X ◁ f) = sheafification ((X ⊗ N₁) → (X ⊗ N₂))`; the tensor bifunctor is `Functor.flip` of curried tensor, and `Localization.lift₂` from `LocalizedMonoidal` already handles this exact situation for the case of a fixed value category in `Sheaf.monoidalCategory` (`Mathlib/CategoryTheory/Sites/Monoidal.lean:149-152`).
- **Status:** IN PROGRESS. The construction is mechanical once `W.IsMonoidal` is supplied. Writing the `W.IsMonoidal` instance is a single declaration of a few lines invoking colimit-preservation lemmas; it qualifies as the "one semantic gap-fill" the user policy allows.
- **Next session next step:**
  1. Open `PresheafOfModules/Sheafification.lean` or a new project-local file with one auxiliary lemma:
     ```
     instance : ((MorphismProperty.isomorphisms (SheafOfModules X.ringCatSheaf)).inverseImage
                 (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj))).IsMonoidal := …
     ```
     The proof body uses `MorphismProperty.IsMonoidal.mk'` and colimit-preservation of `sheafification` (since it's a left adjoint, `PresheafOfModules.sheafification.IsLeftAdjoint` is already an instance, line 156).
  2. Then `instMonoidalCategoryStruct` becomes `inferInstance` (or a single-line definitional rewriting using `LocalizedMonoidal`).
  3. Verify `tensorObj` from the localization matches our definition above (it should, since both are computed as `sheafification of (psh-tensor)`).

## instMonoidalCategory (line 123) — IN PROGRESS

### Attempt 1 (deferred)
- **Approach:** Once `instMonoidalCategoryStruct` is in place via `LocalizedMonoidal`, the `MonoidalCategory` instance is also off-the-shelf:
  ```
  inferInstanceAs (MonoidalCategory
    (LocalizedMonoidal (L := sheafification _) (W := …) (Iso.refl _)))
  ```
  The Mathlib pattern at `Sheaf.monoidalCategory` (`CategoryTheory/Sites/Monoidal.lean:165-168`) demonstrates this exact path.
- **Status:** BLOCKED on `instMonoidalCategoryStruct`.

## Relevant Mathlib lemmas found (compact index for next iteration)

- `Adjunction.isLocalization` — `Mathlib/CategoryTheory/Localization/Adjunction.lean`. Key existence theorem.
- `PresheafOfModules.sheafificationAdjunction` — `Mathlib/Algebra/Category/ModuleCat/Presheaf/Sheafification.lean:124`. The adjunction we use; right adjoint is Full + Faithful (`:168, :171`).
- `PresheafOfModules.sheafification.IsLeftAdjoint` — `Sheafification.lean:156`. Confirms left-adjoint status; used to derive colimit preservation.
- `CategoryTheory.Sheaf.monoidalCategory` — `Mathlib/CategoryTheory/Sites/Monoidal.lean:165`. The reference pattern for "lift monoidal structure via localization" with a *fixed* value category. Our case adapts this pattern with `PresheafOfModules.sheafification` instead of `presheafToSheaf` and `W := (isomorphisms _).inverseImage` instead of `J.W`.
- `MorphismProperty.IsMonoidal` and `IsMonoidal.mk'` — `Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean:44-54`. The gap-fill target.
- `CategoryTheory.LocalizedMonoidal` and `Localization.Monoidal.monoidalCategoryStruct` — `Localization/Monoidal/Basic.lean:86, 172`.
- `SheafOfModules.unit` — `Mathlib/Algebra/Category/ModuleCat/Sheaf.lean:160`. Alternative tensor unit; not needed if we use `LocalizedMonoidal` (the unit there is `L.obj (𝟙_ presheaf)`, which is `sheafification (PresheafOfModules.unit _)`).

## Recommendations for plan agent

1. **The remaining 2 sorries reduce to ONE gap-fill**: `MorphismProperty.IsMonoidal` for the inverseImage class of `sheafification` on `PresheafOfModules X.ringCatSheaf.obj`. This is a 5-10 line proof using colimit-preservation by left adjoints; it qualifies as the single allowed gap-fill per user policy.
2. Once that lemma is supplied, **both `instMonoidalCategoryStruct` and `instMonoidalCategory` become `inferInstance`-derivable** via the `LocalizedMonoidal` machinery (see Mathlib's `Sheaf.monoidalCategory` for the template).
3. Realistically iter-079 should close both with a clean ~15-line addition centred on the gap-fill.
4. The current scaffolding (this file's `tensorObj` definition) is forward-compatible with the localization-monoidal route: the localization's tensor product **is** sheafification of presheaf tensor (matching our def via `Localization.Monoidal.μ` being an iso).

## Constraints respected

- No new project-local helper lemmas added (`tensorObj` is the only filled body, and it's a protected scaffolded declaration).
- No new axioms.
- No `lean_run_code` pre-validation used (only `lean_diagnostic_messages` and `lean_hover_info` / `lean_leansearch`).
- Hard cap honored: 3 sorries → 2 sorries (net -1).
- Target ≤ 0 NOT reached, but real progress: 1/3 closed with explicit, mechanical path documented for the remaining 2.
