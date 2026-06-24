# Analogy: is `τ` (sheaf→presheaf section flattening) constructible, or must SNAP abandon the `muGamma_collapse` route for graded `mul_assoc`?

## Mode
cross-domain-inspiration

## Slug
snap-tau

## Iteration
029

## Structural problem (abstracted)
We have a reflective localization `L ⊣ ι` of a **monoidal** category `C` (= presheaves
of modules, `PresheafOfModules.monoidalCategory`) onto `D` (= `SheafOfModules O_X` =
`X.Modules`), with sheafification `L` the left adjoint and inclusion `ι` the right
adjoint. The graded multiplication `sectionsMul` is the `⊤`-component of the
adjunction **unit** on the presheaf tensor — i.e. the *tensorator* `μ_{F,G} : Γ(F)⊗Γ(G) → Γ(F⊗G)`
of the lax-monoidal functor "global sections". We want graded `mul_assoc`. The blueprint
tried to factor the product through the *presheaf* power `P^{(m+m')}` via a map
`τ : Γ(L^⊗m)⊗Γ(L^⊗m') → Γ(P^{(m+m')})` whose **source lives downstream of the localization
(sheaf powers) and whose target lives upstream (presheaf power)** — i.e. a section of the
localization on global sections. No such section exists.

## Failed approaches (from directive)
- Object-level monoidal coherence on `SheafOfModules` (pentagon/associator) by hand: DEAD wall, 10+ iters.
- Re-base hand-built `tensorObj` onto Mathlib `Sheaf.monoidalCategory`'s localized `⊗_loc`: REFUTED (kernel TYPE mismatch).
- `sectionMul_assoc_core`: re-summons the off-path sheaf pentagon `tensorPowAdd_assoc`.
- `τ` via `η`-inverse / plain tensor concatenation: no section-level inverse; `Γ(L^⊗m) ≠ Γ(L)^{⊗m}`.

## VERDICT ON `τ`: **NOT constructible. Abandon `muGamma_collapse`.**
`Γ(P^{(k)}) = (P^{(k)})(X) = Γ(L)^{⊗_{Γ(O_X)} k}` (presheaf tensor is objectwise module tensor),
so `τ`'s target is the `k`-fold module tensor power of `Γ(L)`. Its source factor `Γ(L^⊗m) =
Γ(L(P^{(m)}))` receives only a **forward** unit `Γ(η_m) : Γ(L)^{⊗m} → Γ(L^⊗m)`, which is
**not** an isomorphism (sheafification genuinely changes global sections — e.g. `L=O(1)/P¹`).
There is no natural `Γ(L^⊗m) → Γ(L)^{⊗m}`, hence no `τ` out of the tensor of the two sheaf-power
section modules landing in `Γ(L)^{⊗(m+m')}`. The blueprint prose "concatenate the two
elementary-tensor presentations" is a category error: it silently assumes `Γ(L^⊗m) = Γ(L)^{⊗m}`,
which is exactly the `TensorPower`/`PiTensorProduct` setting that does NOT hold after sheafification.
**`τ` is the wrong device; the off-path pentagon it tries to avoid is the *correct* obligation,
and Mathlib already discharges it abstractly via the localized monoidal structure.**

## Analogues found (ranked by porting cost, lowest first)

### Analogue: `CategoryTheory.Adjunction.rightAdjointLaxMonoidal` + `CategoryTheory.Functor.LaxMonoidal.associativity`
- **Domain**: category theory (monoidal functors / adjunctions). File: `Mathlib.CategoryTheory.Monoidal.Functor`.
- **Same structural problem there**: given `F ⊣ G` with `F` (op)lax monoidal, the right adjoint `G`
  is lax monoidal with tensorator `μ_{X,Y} : G X ⊗ G Y → G(X⊗Y)` built FROM the adjunction
  (`rightAdjointLaxMonoidal`); and EVERY lax monoidal functor satisfies the pentagon-compatible
  `associativity` square `(μ_{XY}▷FZ) ≫ μ_{X⊗Y,Z} ≫ F(α) = α ≫ (FX◁μ_{YZ}) ≫ μ_{X,Y⊗Z}`.
- **Technique**: recognize `sectionsMul` AS this `μ`. SNAP's `sectionsMul F G` is literally
  `(sheafificationAdjunction.unit.app (F♭⊗G♭)).app ⊤` — which is, up to evaluation at `⊤`,
  the tensorator of the lax-monoidal inclusion `ι = (SheafOfModules.forget)∘restrictScalars`
  (right adjoint of the oplax/strong-monoidal sheafification `L`). Then graded `mul_assoc` IS
  `Functor.LaxMonoidal.associativity` (no `τ`, no hand pentagon).
- **Mapping to project**: `C = X.PresheafOfModules` (`PresheafOfModules.monoidalCategory`),
  `D = X.Modules`, `L = PresheafOfModules.sheafification (𝟙 …)` (already SNAP's `sheafification`,
  `PresheafOfModules.sheafificationAdjunction`), `G = toPresheafOfModules` (right adjoint).
  `Γ = G ⋙ (eval at op ⊤)`; eval-at-⊤ on presheaves is strong monoidal (presheaf `⊗` is objectwise),
  so `Γ` is lax monoidal and its `μ = sectionsMul`. `mul_assoc` ← `Functor.LaxMonoidal.associativity Γ`
  applied at `L^⊗a, L^⊗b, L^⊗c`, then transported across the additive grading iso `tensorPowAdd`.
- **Porting cost**: medium. Need `L.OplaxMonoidal` (equivalently the strong-monoidality of
  sheafification — SNAP already has the comparison `isIso_sheafification_whiskerRight_unit`),
  then `rightAdjointLaxMonoidal` gives `ι.LaxMonoidal` for free, and `associativity` is a library lemma.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.LocalizedMonoidal` (engine) — mirror of `CategoryTheory.Sheaf.monoidalCategory`
- **Domain**: category theory (localization of monoidal categories). Files:
  `Mathlib.CategoryTheory.Localization.Monoidal.Basic` (`LocalizedMonoidal`,
  `instMonoidalCategoryLocalizedMonoidal`, `instMonoidalLocalizedMonoidalToMonoidalCategory`,
  `Localization.Monoidal.toMonoidalCategory`), built on by `Mathlib.CategoryTheory.Sites.Monoidal`
  (`Sheaf.monoidalCategory`, `instMonoidalFunctorOppositePresheafToSheaf`).
- **Same structural problem there**: given a monoidal `C`, a localization `L : C → D` at `W`
  with `W.IsMonoidal` (multiplicative + stable under whiskering) and `ε : L(𝟙) ≅ unit`,
  the type-synonym `LocalizedMonoidal L W ε` (a **copy of `D`**, i.e. of `X.Modules`) carries a
  canonical `MonoidalCategory` with tensor `= L(ιX ⊗ ιY)` and `L` becomes a monoidal functor.
  This is *exactly* how Mathlib makes the SHEAF tensor monoidal and proves the pentagon — once.
- **Technique**: assemble `MonoidalCategory X.Modules` by this construction (not by hand).
  Then `tensorPowAdd_assoc` (the dead wall) is FREE: it is the pentagon of a genuine
  `MonoidalCategory`. `sectionsMul` becomes `μ` of `Γ` (previous analogue) and `mul_assoc` follows.
- **Mapping to project**: `L = sheafification`, `W =` sheafification-inverted maps
  (`PresheafOfModules` locally-bijective class), `ε =` SNAP's `sheafificationCounitIso`/unit normalization.
  Inputs available: `instIsLeftAdjointSheafOfModulesSheafification` (so `L` is a reflective
  localization ⇒ `L.IsLocalization W`), `sheafification_reflective` (counit iso),
  `PresheafOfModules.sheafificationAdjunction`. The real obligation is `W.IsMonoidal`, whose
  whiskering-stability is the SAME content as SNAP's existing `isIso_sheafification_whiskerRight_unit`.
- **Porting cost**: medium–high (assemble `W.IsMonoidal` + `IsLocalization`), but it is a ONE-TIME
  cost that simultaneously kills `tensorPowAdd_assoc`, the unitor bridges, and `mul_assoc`.
- **IMPORTANT on the prior refutation**: the REFUTED "localized `⊗_loc`" was
  `Sheaf.monoidalCategory` for fixed-coefficient `Sheaf J A` — a DIFFERENT object than
  `LocalizedMonoidal (PresheafOfModules.sheafification)`. The latter is a type synonym of
  `X.Modules` whose `tensorObj F G = sheafification(ι F ⊗ ι G)` = SNAP's `tensorObj` definitionally
  (or by a trivial iso). The kernel mismatch does NOT obviously transfer; re-test against
  `LocalizedMonoidal`, not against `Sheaf.monoidalCategory`.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: stalkwise reduction of the associator coherence (`tensorPowAdd_assoc`)
- **Domain**: sheaf theory on topological spaces. Files: `Mathlib.Topology.Sheaves.Stalks`
  (`TopCat.Presheaf.app_isIso_of_stalkFunctor_map_iso`; sheaf morphisms determined by stalks),
  `Mathlib.Topology.Sheaves.Sheafify` (`sheafifyStalkIso`: sheafification preserves stalks),
  `Mathlib.AlgebraicGeometry.Modules.Sheaf` (`Scheme.Modules.restrictStalkNatIso`),
  `Mathlib.Algebra.Category.ModuleCat.Monoidal.Basic` (`ModuleCat` associator + pentagon, free).
- **Same structural problem there**: prove an equality of SHEAF morphisms (the associator
  coherence) by checking at every stalk, where the sheaf `⊗` becomes a plain `ModuleCat ⊗`
  (`(F⊗_sh G)_x ≅ F_x ⊗ G_x` via `sheafifyStalkIso` + objectwise presheaf tensor), reducing to
  the `ModuleCat` pentagon, then lifting via stalk-faithfulness of sheaf morphisms.
- **Technique**: this cracks the EXACT dead wall (`tensorPowAdd_assoc`) WITHOUT assembling a full
  monoidal instance — the alternative if the `LocalizedMonoidal` instance proves too heavy.
- **Mapping to project**: prove `tensorPowAdd_assoc` as an equality of `X.Modules` morphisms by
  reducing to stalks (`SheafOfModules` morphisms are determined by underlying-`Ab`-sheaf stalks,
  `instReflectsIsomorphismsSheafOfModulesToSheaf`), using `sheafifyStalkIso` to identify the
  stalk of `tensorObj` with `M_x ⊗ N_x`, then `ModuleCat.MonoidalCategory` pentagon. `mul_assoc`
  then follows by applying `Γ(-)` to the established object-level associator coherence — note this
  is the NATURAL section route SNAP already identified, just with the pentagon now PROVEN.
- **Porting cost**: medium. Needs a "stalk of `tensorObj` = tensor of stalks" lemma (assemble from
  `sheafifyStalkIso` + presheaf-tensor stalk) and stalk-faithfulness for `SheafOfModules` morphisms.
- **Verdict**: ANALOGUE_FOUND (fallback to Rank 1/2 engines).

### Analogue (PARTIAL): `AlgebraicGeometry.ProjectiveSpectrum.StructureSheaf` — pointwise section product
- **Domain**: algebraic geometry (Proj). File: `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.StructureSheaf`.
- **Same structural problem there**: a graded structure sheaf whose section product is
  `(s·t)(x) = s(x)·t(x)` POINTWISE (`Proj.mul_apply`), with `mul_assoc` inherited objectwise from
  the target `CommRing` — NO sheaf tensor product, NO monoidal coherence.
- **Why it does NOT directly port**: Proj's grading is **internal** (homogeneous degrees of a fixed
  ambient `GradedRing 𝒜`); the product is `𝒜`-multiplication, available because the graded ring
  pre-exists. SNAP is **building** `Γ_*` (external grading by tensor powers of `L`); there is no
  ambient graded ring to multiply within. The pointwise trick only ports if `L` is first trivialized
  on a cover (reducing to `O_X`-multiplication) — which is morally the stalk route above.
- **Porting cost**: high (requires trivialization/cover machinery SNAP does not have).
- **Verdict**: PARTIAL_ANALOGUE (documents the structural reason `τ` fails: internal vs external grading).

## Discarded
- `TensorPower.mul_assoc` / `TensorPower.tprod_mul_tprod` / `PiTensorProduct.tmul`
  (`Mathlib.LinearAlgebra.TensorPower`, `…PiTensorProduct`): the "append" is PURELY module-level on
  powers `M^{⊗k}` of a FIXED module `M`; it is never a sheaf↔presheaf bridge. Porting it is precisely
  the `τ` assumption `Γ(L^⊗m)=Γ(L)^{⊗m}`, which is FALSE. This is the blueprint's category error and
  CONFIRMS `τ` non-constructibility. Discard.
- `Sheaf.monoidalCategory` for fixed-coefficient `Sheaf J A`: not applicable to `SheafOfModules O_X`
  (varying ring sheaf); it is the object that already kernel-mismatched. Use `LocalizedMonoidal` of
  `PresheafOfModules` instead.

## Top suggestion
Abandon `τ`/`muGamma_collapse`. Pivot to the lax-monoidal route, which is built for SNAP's exact
shape. Concretely: (1) establish `sheafification.OplaxMonoidal` (SNAP already has the whiskering
comparison `isIso_sheafification_whiskerRight_unit`); (2) get `ι.LaxMonoidal` for free via
`CategoryTheory.Adjunction.rightAdjointLaxMonoidal` (read `Mathlib.CategoryTheory.Monoidal.Functor`);
(3) recognize `sectionsMul` as the tensorator `μ` of `Γ = ι ⋙ ev_⊤`, and close graded `mul_assoc`
with `CategoryTheory.Functor.LaxMonoidal.associativity`. For maximum payoff (also discharging the
dead `tensorPowAdd_assoc`), first assemble `MonoidalCategory X.Modules` via
`CategoryTheory.LocalizedMonoidal (PresheafOfModules.sheafification) W ε`
(`Mathlib.CategoryTheory.Localization.Monoidal.Basic`), mirroring `Sheaf.monoidalCategory` — the only
new obligation is `W.IsMonoidal`, whose content SNAP largely already proved. First file to touch:
`AlgebraicJacobian/Picard/SectionGradedRing.lean` (re-point `tensorObj` at / build an iso to the
`LocalizedMonoidal` tensor; replace `sectionsMul`/`muGamma_collapse` reasoning with the `μ`
identification). If the monoidal-instance assembly stalls, fall back to proving `tensorPowAdd_assoc`
stalkwise (`sheafifyStalkIso` → `ModuleCat` pentagon).
