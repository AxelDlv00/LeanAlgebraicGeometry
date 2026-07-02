# Analogy: transporting an oplax-monoidal left-unitality coherence across the sheafification reflector (STU-collapse)

## Mode
cross-domain-inspiration

## Slug
stu-seam

## Iteration
064

## Structural problem (abstracted)
A left-adjoint reflector `L : C → D` that is a *localization* `L.IsLocalization W` carries the source
monoidal structure to a monoidal structure on `D` (Day-style / Gabriel–Zisman). The localized left
unitor `λ^D_{L Y}` must collapse, modulo the unit-comparison `ε : L(𝟙_C) ≅ unit_D` and the
tensor-comparison `μ_{X,Y} : L X ⊗ L Y ≅ L(X⊗Y)`, to the image of the source unitor `L.map λ^C_Y`.
Concretely: `λ^D_{L Y}.hom = ε.inv ▷ L Y  ≫  μ.hom  ≫  L.map λ^C_Y`. This is the project's
`sheafifyTensorUnitIso`(=μ) / `sheafifyUnitIso`(=ε) / `tensorObj_left_unitor`(=λ^D) collapse against
`a.map(λ_presheaf)`(=`L.map λ^C`).

## Failed approaches (from directive)
- term-mode `congrArg`/`Eq.trans` split-fold: lands seam mechanics, cannot manufacture the structural collapse.
- `rw`/`erw`/`simp [Category.assoc]`: miss across the `SheafOfModules ≫` defeq-not-syntactic seam.
- building a strong `Functor.Monoidal (pullback φ)`: globally FALSE (δ not iso).

## The decisive finding
Mathlib has built **exactly this transport, for exactly this category**, and the collapse coherence is
a *named lemma proved definitionally* — not by seam-chasing. The project hand-built the sheaf-level
unitor as `a.map(λ) ≫ counit`, which is why the collapse is not definitional and the seam fights back.
Mathlib instead **defines the localized unitor as a localization-lift**, so the collapse falls out of
the lift's defining evaluation lemma `liftNatTrans_app`.

## Analogues found

### Analogue: `CategoryTheory.Localization.Monoidal.leftUnitor_hom_app`  — THE match
- Cite: `Mathlib/CategoryTheory/Localization/Monoidal/Basic.lean:212` (def `leftUnitor` :151, `μ` :184,
  `μ_natural_left` :188).
- **Domain**: category theory / monoidal localization (Gabriel–Zisman). Same field, but the
  *reflective-localization-of-monoidal* sub-area the project never anchored on.
- **Same structural problem there**: for `L.IsLocalization W` with `[W.IsMonoidal]`, build
  `MonoidalCategory (LocalizedMonoidal L W ε)` and prove the unitor collapse. `leftUnitor_hom_app` is
  *verbatim* the STU-collapse: `(λ_ (L'.obj Y)).hom = ε.inv ▷ L'Y ≫ μ.hom ≫ L'.map (λ_ Y).hom`.
- **Technique** (the answer to "which naturality squares of the unit/counit it composes"): it composes
  **none by hand**. The localized `leftUnitor` (Basic.lean:151) is *defined* as
  `(tensorBifunctor).mapIso ε.symm ≪≫ Localization.liftNatIso L' W _ _ (leftUnitorNatIso C ≪≫ L.leftUnitor)`.
  The proof (Basic.lean:215) is `dsimp +instances [monoidalCategoryStruct, leftUnitor]; rw [liftNatTrans_app]; … simp only [comp_id]`.
  The engine is `Localization.liftNatTrans_app` (`Localization/Predicate.lean:327`):
  `(liftNatTrans … τ).app (L.obj X) = Lifting.iso.hom.app X ≫ τ.app X ≫ Lifting.iso.inv.app X`.
  On an object **in the image of `L`** the lifted nat-trans *reduces definitionally* to the source datum
  conjugated by the `Lifting.iso` — the seam evaporates because the lifted morphism is, by construction,
  pinned on `L`-image objects. `μ` is itself the lifting iso of the curried tensor (`Lifting₂.iso`,
  Basic.lean:135), so `μ_natural_left/right` (:188/:200) come straight from `NatTrans.naturality_app`
  of that lifting iso — those are the only naturality squares, and they are free.
- **Mapping to project**: `L = PresheafOfModules.sheafification`, `D = SheafOfModules`, `ε = sheafifyUnitIso`,
  `μ = sheafifyTensorUnitIso`, `λ^D = tensorObj_left_unitor`, `L.map λ^C = a.map(presheaf leftUnitor)`.
  The project's L2 (`tensorObj_left_unitor_pullback_eq_sheafify`) and L3-3a residuals are both instances
  of `leftUnitor_hom_app` after the `pullbackValIso`/`pbv` legs are split off (already done in `hcomb`).
- **Porting cost**: medium. Two routes (see Top suggestion). The lemma itself is reusable verbatim
  **iff** the project's sheaf unitor is the `LocalizedMonoidal` one; otherwise replicate the 5-line
  `dsimp[leftUnitor]; rw[liftNatTrans_app]; simp[comp_id]` script with the project's own lift devices.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.Localization.Monoidal.functorMonoidalOfComp_ε` / `_μ`
- Cite: `Mathlib/CategoryTheory/Localization/Monoidal/Functor.lean:130/134/140` (core :88,
  `curriedTensorPreIsoPost_hom_app_app'` :65).
- **Domain**: monoidal localization — transport of a *functor's* (op)lax-monoidal structure across `L`.
- **Same structural problem there**: an oplax/monoidal `F` that lifts along `L` to a monoidal `G` on the
  source gets its comparison maps on `L`-image objects computed *via the unit components*:
  `ε F = ε G ≫ e.inv.app _ ≫ F.map (η L)` and
  `μ F (L X)(L Y) = (e.hom ⊗ₘ e.hom) ≫ μ G X Y ≫ e.inv.app _ ≫ F.map (δ L …)`.
  This is literally "an oplax coherence pushed through the localization, expressed via the unit
  components η/δ of `L`" — the directive's general shape.
- **Technique**: route everything through the lift natural iso `e = Lifting.iso` and use its naturality
  squares (`curriedTensorPreIsoPost_hom_app_app'`, Functor.lean:65) + `map_δ_μ_assoc`. Same engine as
  above: the comparison on `L`-image objects is `e`-conjugation of the source datum.
- **Mapping to project**: this is the *δ-side* analogue (L3 / `pullbackTensorMap_eq_sheafify_delta`,
  `pullbackUnitIso_eq_sheafify_eta`). The project's `pullback φ` oplax structure on PresheafOfModules is
  the `G`; sheafifying it gives the `F`-on-`D` comparison via η/δ — exactly the form the project already
  reconciles by hand. Confirms the project's bridge-1/2 shape is the canonical one.
- **Porting cost**: medium (same anchoring prerequisite).
- **Verdict**: ANALOGUE_FOUND.

### Foundational fact enabling both (not an analogue — a direct API the project can stand on)
- `SheafOfModules.sheafification α |>.IsLocalization (J.W.inverseImage (toPresheaf R₀))`
  — `Mathlib/Algebra/Category/ModuleCat/Sheaf/Localization.lean:48` (via
  `(sheafificationAdjunction α).isLocalization`). **The project's sheafification reflector is already a
  Mathlib `IsLocalization`.** Combined with `Sites/Monoidal.lean:165-191` (which *defines*
  `Sheaf.monoidalCategory := LocalizedMonoidal (presheafToSheaf J A) J.W (Iso.refl _)` and registers
  `presheafToSheaf.Monoidal`), the entire `Localization.Monoidal` API is in-scope for the project's
  category — the project simply never anchored on it.

## Top suggestion
Try **Port A (technique replication)** first; keep **Port B (re-anchor)** as the structural fix.

**Port A** — reprove the L2 residual (`tensorObj_left_unitor_pullback_eq_sheafify`, TensorObjInverse.lean:1376
sorry) by *mimicking* `leftUnitor_hom_app`'s proof rather than chasing the seam. Read
`Localization/Monoidal/Basic.lean:150-220`. The move: express `sheafifyTensorUnitIso` (μ) as the
lifted-bifunctor comparison and `tensorObj_left_unitor` via `Localization.liftNatIso` of
`(leftUnitorNatIso ≪≫ a.leftUnitor)`; then the residual is `liftNatTrans_app`
(`Localization/Predicate.lean:327`) evaluated on the `L`-image object `(pullback φ').obj M.val`, where
the lifted unitor reduces *definitionally* to `Lifting.iso`-conjugated presheaf-λ — no `Category.assoc`
rewrite across the seam is needed, because the seam term is pinned by `liftNatTrans_app` to the source
datum. Close with `simp only [comp_id]` exactly as Basic.lean:220.

**Port B** — verify `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal` for the project's presheaf-module
tensor (the one open prerequisite). If it holds, the project's `tensorObj`/`tensorObj_left_unitor`/
`sheafifyTensorUnitIso` can be *replaced by* (or proved iso to) the `LocalizedMonoidal
(SheafOfModules.sheafification …) W` instances, after which L2 and L3-3a are `leftUnitor_hom_app` /
`functorMonoidalOfComp_μ` applied directly and the entire STU-seam family disappears. First file to
touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (where `tensorObj`/unitor are hand-built).

First file to touch for Port A: `AlgebraicJacobian/Picard/TensorObjInverse.lean:1314-1376`.
Mathlib file to read first: `Localization/Monoidal/Basic.lean:150-220` (leftUnitor + leftUnitor_hom_app).

## Discarded
- `CategoryTheory.Monoidal.Transport` (`Monoidal/Transport.lean`): transports monoidal structure across
  an **equivalence**; sheafification is a reflection, not an equivalence — and "build a strong monoidal
  functor" is a directive Failed-approach. NO_USEFUL_ANALOGUE.
- `CategoryTheory.Monoidal.DayConvolution`: builds a monoidal structure by left-Kan-extension, not by
  transporting an existing coherence across a localization; technique (pointwise LKE) does not port.
  PARTIAL_ANALOGUE at best.
- `Sites.Monoidal` for `Sheaf J A` with **fixed** value category `A`: not directly instantiable here
  (`SheafOfModules R` has module fibres over varying rings, per `monoidal-transport.md`), but its
  *construction route* (`:= LocalizedMonoidal (presheafToSheaf …)`) is the template Port B follows via
  the module-specific `SheafOfModules.sheafification.IsLocalization`.
