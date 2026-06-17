# Picard/TensorObjSubstrate.lean — iter-205 (Lane TS, mathlib-build)

## Summary
- **Declarations added (2, axiom-clean)**:
  1. `isMonoidal_W_of_whiskerLeft` (L411–426) — builds `MorphismProperty.IsMonoidal W`
     for `W := (J.W).inverseImage (toPresheaf (R' ⋙ forget₂ _ _))` from the single
     hypothesis `whiskerLeft` (`W g → W (F ◁ g)`). `IsMultiplicative W` is automatic;
     `whiskerRight` is derived from `whiskerLeft` via the symmetric braiding on
     `PresheafOfModules` (`arrow_mk_iso_iff (Arrow.isoMk (β_ _ _) (β_ _ _))`).
  2. `monoidalCategoryOfIsMonoidalW` (L428–442) — the localization-monoidal transport:
     `[IsMonoidal W] → MonoidalCategory (SheafOfModules R)`, via
     `Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal` on
     `PresheafOfModules.sheafification α` with unit iso `Iso.refl`.
- **Both verified axiom-clean**: `#print axioms` / `lean_verify` = `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.
- **File sorry count**: 4 → 4 (the 4 pre-existing sorries — `monoidalCategory` L150,
  `tensorObj_restrict_iso` L249, `exists_tensorObj_inverse` L300, `addCommGroup_via_tensorObj`
  L339 — are left untouched; I added NO sorry). Build GREEN, no errors (LSP full elaboration).
- **Net effect**: the whole substrate cone is now reduced **in compiled, verified Lean**
  (not prose) to ONE residual fact: `whiskerLeft : W g → W (F ◁ g)`.

## What the two lemmas establish (the obstruction, decomposed in code)

The blueprint route (`thm:scheme_modules_monoidal`) is:
```
MonoidalCategory (SheafOfModules R)        -- = monoidalCategory, tensorObj_restrict_iso
  ⟸  [IsMonoidal W]                        -- monoidalCategoryOfIsMonoidalW  ✅ built
  ⟸  whiskerLeft (W g → W (F ◁ g))         -- isMonoidal_W_of_whiskerLeft    ✅ built
```
Both arrows are now axiom-clean compiled declarations. `IsMultiplicative W` is a free
instance (`inverseImage` of the localizing property `J.W`); `whiskerRight ⟸ whiskerLeft`
is the braiding trick. So the ENTIRE remaining gap is exactly `whiskerLeft`.

## monoidalCategory / tensorObj_restrict_iso (PRIMARY) — PARTIAL, reduced to `whiskerLeft`

### Approach
Verified the full transport pipeline against Mathlib at the pinned commit:
- `PresheafOfModules.sheafification.IsLocalization W` **exists**
  (`Mathlib.Algebra.Category.ModuleCat.Sheaf.Localization`); `W = (J.W).inverseImage (toPresheaf R₀)`
  via `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`.
- `Localization.Monoidal.instMonoidalCategoryLocalizedMonoidal` needs
  `[MonoidalCategory (PresheafOfModules R₀)]` (exists, relative `⊗_R`),
  `[(sheafification α).IsLocalization W]` (exists), `[W.IsMonoidal]` (the gap),
  and a unit iso (take `Iso.refl`).
- `MorphismProperty.IsMonoidal W` = `IsMultiplicative W` (auto) + `whiskerLeft` + `whiskerRight`.
- `BraidedCategory (PresheafOfModules R₀)` exists (`symmetricCategory` instance) ⇒
  `whiskerRight ⟸ whiskerLeft`.

### Result — PARTIAL (the transport + reduction are built; `whiskerLeft` blocked)

### The genuine Mathlib-absent ingredient (precise)
`whiskerLeft`: for `g` inverted by sheafification (`W g`, equivalently `g` locally
bijective for `J`) and any `F : PresheafOfModules R₀`, the relative tensor
`F ◁ g` is again inverted by sheafification.

- Mathlib's slick proof of the **ambient** analogue
  (`CategoryTheory.GrothendieckTopology.W.whiskerLeft`, `Mathlib/CategoryTheory/Sites/Monoidal.lean`
  L132) tests `J.W (F ◁ g)` against sheaves `H` and reduces via the closed-monoidal
  adjunction `Hom(F ◁ g, H) ≃ Hom(g, ihom F H)` plus "**`ihom F H` is a sheaf when `H`
  is**" (`Presheaf.isSheaf_functorEnrichedHom`). This needs `MonoidalClosed A`.
- For the **relative** module tensor I need `MonoidalClosed (PresheafOfModules R₀)`.
  **VERIFIED ABSENT**: `infer_instance` for `MonoidalClosed (PresheafOfModules (R ⋙ forget₂ _ _))`
  fails. The closed structure on `ModuleCat R` does NOT lift to presheaves of modules over a
  *varying* ring (the internal hom is the enriched/functor hom, not sectionwise).
- Exactness route also blocked: tensoring does not preserve injectivity without flatness, so
  the "locally bijective" preservation cannot be done elementwise; it genuinely requires the
  closed/reflective machinery.

### Dead-end warnings (do NOT retry)
- **`Sites/Monoidal.lean`'s `J.W.IsMonoidal` does NOT apply.** It is for `Sheaf J A` with the
  *ambient* monoidal structure on `A = AddCommGrpCat` (i.e. `⊗_ℤ` levelwise / cartesian), and
  is transported along the forgetful `toPresheaf`. But `toPresheaf : PresheafOfModules R₀ ⥤ Cᵒᵖ ⥤ AddCommGrpCat`
  is **not** a monoidal functor for the relative `⊗_R` (it forgets the module tensor). Confirmed:
  `J.W (A := AddCommGrpCat)` whiskering is `F ◁_{⊗ℤ} g`, not `F ◁_{⊗R} g`.
- **No existing `MonoidalCategory (SheafOfModules R)` instance** (`infer_instance` fails).
- **Presheaf-pullback strong-monoidal is also absent** (alternative `tensorObj_restrict_iso`
  route): `grep Monoidal/tensor` in `Mathlib/Algebra/Category/ModuleCat/Presheaf/{Pullback,ChangeOfRings}.lean`
  → nothing. So the direct sectionwise route for `tensorObj_restrict_iso` is equally blocked.
- **Scheme-level wiring of `monoidalCategory` through `monoidalCategoryOfIsMonoidalW`** hits a
  syntactic-vs-defeq instance friction: the `PresheafOfModules` monoidal instance is keyed on the
  *syntactic* form `X.presheaf ⋙ forget₂ CommRingCat RingCat`, while the sheafification instances
  (`IsLocallyInjective`, `WEqualsLocallyBijective`, `HasWeakSheafify`) auto-resolve only for
  `X.ringCatSheaf.val`. They are `rfl`-defeq (verified `X.ringCatSheaf.val = X.presheaf ⋙ forget₂ _ _`
  by `rfl`) but instance synthesis is syntactic, so the two forms must be bridged by hand with
  `inferInstanceAs`. Mechanical but fiddly; left for a follow-up (NOT attempted in-file to avoid
  destabilising the 4 existing sorries). The two general lemmas already capture all the real content.

### Informal agent
Not called: the obstruction is a precisely-identified *infrastructure absence*
(`MonoidalClosed (PresheafOfModules R₀)`), not a proof-strategy question an LLM sketch would help
with. (Memory `informal-agent-key-invalid`: prior iter-204 call returned HTTP 401 anyway.)

## Next step (for the planner)
The lone remaining ingredient is now sharply isolated and dischargeable in two ways:

1. **(Recommended, large)** Build `MonoidalClosed (PresheafOfModules (R' ⋙ forget₂ _ _))` — the
   module analogue of `Mathlib/CategoryTheory/Monoidal/Closed/FunctorCategory` — then mirror
   `Sites/Monoidal.lean` (`isSheaf_functorEnrichedHom` + the `whiskerLeft` adjunction reduction)
   to discharge the `whiskerLeft` hypothesis of `isMonoidal_W_of_whiskerLeft`. This is a multi-file
   Mathlib-PR-scale effort; spin it as its own sub-lane.
2. **(Smaller, in-file)** Provide `whiskerLeft` directly as
   `∀ ⦃G₁ G₂⦄ {g}, W g → ∀ F, W (F ◁ g)` by any means (e.g. a sectionwise locally-bijective
   argument if a flatness-free proof can be found), then:
   `haveI := isMonoidal_W_of_whiskerLeft hwl; exact monoidalCategoryOfIsMonoidalW α`
   closes `monoidalCategory` (modulo the syntactic ring-presheaf bridging above), which cascades to
   `tensorObj_restrict_iso` → `tensorObj_isLocallyTrivial` (axiom-clean) →
   `exists_tensorObj_inverse` → `addCommGroup_via_tensorObj`.

Either way, `monoidalCategoryOfIsMonoidalW` and `isMonoidal_W_of_whiskerLeft` are permanent
axiom-clean infrastructure that the discharge plugs straight into.

## Why I stopped
**Verdict: Partial progress (real, code-level).**
- **Real progress**: 2 axiom-clean declarations added — `isMonoidal_W_of_whiskerLeft` (L411) and
  `monoidalCategoryOfIsMonoidalW` (L428) — which together reduce the entire `monoidalCategory` /
  `tensorObj_restrict_iso` cone to the single fact `whiskerLeft`, verified in compiled Lean
  (strictly stronger than the iter-204 prose decomposition).
- **Specific blocker**: `whiskerLeft : W g → W (F ◁ g)` for the relative module tensor, which
  requires `MonoidalClosed (PresheafOfModules R₀)` — **verified absent** from Mathlib (the module
  analogue of `Sites/Monoidal.lean`'s closed-monoidal apparatus). This is a genuine multi-file
  infrastructure gap, not a one-iteration proof.
- Alternatives exhausted: closed-monoidal route (absent instance), ambient-`J.W` transport (wrong
  tensor), presheaf-pullback strong-monoidal (absent), Scheme-level wiring (syntactic friction,
  deferred). `leansearch`/`loogle` for `IsMonoidal`+`PresheafOfModules`/`sheafification`+`Monoidal`
  → no results.

## Blueprint markers
- `def:scheme_modules_tensorobj`, `lem:scheme_modules_tensorobj_functoriality` — already `\leanok`
  (closed iter-203), unchanged.
- The two new supplement lemmas are NOT `\lean{...}`-pinned in the blueprint (they are project-local
  Mathlib infrastructure, not blueprint declarations). No blueprint marker change requested. The
  planner may optionally pin `monoidalCategoryOfIsMonoidalW` / `isMonoidal_W_of_whiskerLeft` into the
  `thm:scheme_modules_monoidal` proof sketch as the formalized transport+reduction.
