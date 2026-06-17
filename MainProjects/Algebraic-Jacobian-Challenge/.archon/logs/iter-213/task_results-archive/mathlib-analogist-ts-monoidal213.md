# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts-monoidal213

## Iteration
213

## Question
(1) Does Mathlib provide `MonoidalCategory (SheafOfModules R)` (or `Sheaf J (ModuleCat …)`)?
(2) Is `PresheafOfModules.sheafification` a (lax/strong) monoidal functor, or is there a
reflective-localization monoidal transport (`Localization.Monoidal`,
`MorphismProperty.IsMonoidal`) yielding the associator for free? (3) If neither, the minimal
correct route to `Nonempty ((M⊗N)⊗P ≅ M⊗(N⊗P))` for invertible objects — does it require
EITHER (a) sectionwise flatness `[∀ U, Module.Flat (𝒪_X(U)) (M.val(U))]` (FALSE for
non-affine opens) OR (b) the abandoned `tensorObj_restrict_iso`? If a route needs NEITHER,
name it precisely.

> **All citations FRESH-verified** against the project's pinned Mathlib
> (`.lake/packages/mathlib`) this iteration (leansearch/loogle/grep/Read). An early
> tool outage cleared; ignore any stale draft. This report **reverses** the iters 206–212
> conclusion that the associator is walled behind `MonoidalClosed (PresheafOfModules R₀)`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. `MonoidalCategory (SheafOfModules R)` in Mathlib? | NEEDS_MATHLIB_GAP_FILL (absent; `Sheaf.monoidalCategory` is fixed-A pointwise tensor, not module ⊗_R) | informational |
| 2. monoidal sheafification ⇒ free associator? | NEEDS_MATHLIB_GAP_FILL (exists for fixed-A given `J.W.IsMonoidal`; the unlock is the **enough-points** route to `J.W.IsMonoidal`, no MonoidalClosed) | informational |
| 3. route needing NEITHER (a) nor (b): route (d) stalkwise-iso whiskering | ALIGN_WITH_MATHLIB (technique) | major |
| 3′. blueprint "Flatness is free" / flat route (a) | divergent-and-wrong (do NOT take) | critical (shipped) |

## Must-fix-this-iter

- **Retire the flat route and the blueprint "Flatness is free" step — and replace it with
  the stalkwise argument (route d), not with local triviality.** `W_whiskerLeft_of_flat` /
  `W_whiskerRight_of_flat` (`TensorObjSubstrate.lean:332,348`) require the **sectionwise**
  instance `[∀ U, Module.Flat (𝒪_X(U)) (P.val(U))]`, FALSE for non-affine opens
  (⊗-invertibility is affine-local; global sections over a non-affine open is not exact).
  Blueprint `Picard_TensorObjSubstrate.tex:664–669` is the wrong step (already `% NOTE`-flagged
  iter-212). **Root cause (new):** these lemmas split `J.W` into locally-injective +
  locally-surjective and try to preserve *injectivity alone* — `injective ⊗ id` is what needs
  flatness. A `J.W`-map is in fact a **stalkwise isomorphism**, and `F ⊗ (iso)` is always an
  iso, so the *combined* property is preserved with no flatness. Rewrite the two lemmas as a
  single `W_whisker_of_stalkwise` (see Major).

## Major

- **Route (d): stalkwise-iso whiskering — the route needing NEITHER (a) NOR (b).**
  Via the CLOSED bridge `isIso_sheafification_map_of_W` (line 373), `tensorObj_assoc_iso`
  reduces to `J.W (toPresheaf (η ▷ P.val))` and the mirror `M.val ◁ η`, where `η = toSheafify`
  is in `J.W` and `▷/◁` is the module whiskering. Surjectivity is free
  (`isLocallySurjective_whiskerLeft`, line 222). For the whole `J.W`:
  - `J.W f ↔ f` is **stalkwise iso** (topological site of `X`): outer direction
    `CategoryTheory.Sheaf.isIso_of_stalkFunctor_map_iso` (`Mathlib.Topology.Sheaves.Stalks`),
    `J.W ↔ IsIso(sheafify)` via the file's own
    `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`.
  - `(η ▷ P.val)_x = η_x ⊗_{𝒪_{X,x}} id_{P.val_x}`; `η_x` is an **iso** (W-map stalkwise iso),
    so `η_x ⊗ id` is an iso ⟹ `η ▷ P.val` stalkwise iso ⟹ in `J.W`. **Arbitrary `P`** — no
    flatness, no invertibility, no local triviality, no `tensorObj_restrict_iso`.
  - This is the exact technique Mathlib newly blesses in
    `Mathlib/CategoryTheory/Sites/Point/IsMonoidalW.lean` (Joël Riou, **2026**):
    `[J.HasSheafCompose (forget A)] [HasEnoughPoints J] → (J.W (A := A)).IsMonoidal`, whose
    proof is `hP.W_iff` (W = fibrewise iso) + `Functor.Monoidal.map_tensor` + `infer_instance`
    (iso ⊗ iso = iso), with **no `MonoidalClosed`**. Iters 206–210 missed it — they found only
    the older MonoidalClosed-gated `GrothendieckTopology.W.monoidal` (`Sites.Monoidal:149`,
    under `variable [MonoidalClosed A]`, `whiskerLeft` built from `MonoidalClosed.curry`).
  - **Mathlib already supplies the points.** `TopCat.hasEnoughPoints (X : TopCat) :
    (Opens.grothendieckTopology X).HasEnoughPoints` (`Mathlib.Topology.Sheaves.Points`, Riou
    **2026**) — "spaces have enough points, given by the stalks at the points of `X`." So the
    conservative stalk family for `X`'s site is present; `hP.W_iff` (`Sites.Point.Conservative`)
    then gives `J.W f ↔ stalkwise iso`, and the concrete `TopCat.Presheaf.isIso_iff_stalkFunctor_map_iso`
    (`Topology.Sheaves.Stalks`, instances `[PreservesFilteredColimits (forget C)] [HasLimits C]
    [PreservesLimits (forget C)] [(forget C).ReflectsIsomorphisms]` — all true for ModuleCat/
    AddCommGrp) is the iso bridge.
  - **Porting ingredients (project-side, both flatness-free):** (d.1) instantiate the
    enough-points/stalkwise characterization for the **module-level** `J.W` (the Mathlib
    `IsMonoidalW` instance itself is for fixed-A *pointwise* tensor, so the module relative
    tensor `⊗_R` needs the same `hasEnoughPoints` + `hP.W_iff` argument run by hand — small,
    the points themselves are free); (d.2) stalk commutes with the module-presheaf tensor
    `(M ⊗ᵖ N)_x ≅ M_x ⊗_{𝒪_{X,x}} N_x` (stalk = filtered colimit; `tensorLeft`/`tensorRight`
    preserve filtered colimits — the very instances the Mathlib `IsMonoidalW` block assumes,
    available for module categories).
  - **Action**: rewrite `W_whiskerLeft/Right_of_flat` → `W_whisker_of_stalkwise` (drop the
    `[∀ X, Module.Flat …]` hypothesis), keep the 3-step composite +
    `isIso_sheafification_map_of_W` + `isLocallySurjective_whiskerLeft`. This closes
    `tensorObj_assoc_iso` for **arbitrary** `M N P` and revives the blueprint's original
    "no flatness required" statement. Fallback if (d.1) is heavy: route (c) below.

- **Fallback route (c): local-on-cover injectivity scoped to `IsLocallyTrivial`.** Stay with
  the inj+surj split but replace the flat injectivity step with a trivializing-cover argument
  (`P.val(V) ≅ 𝒪_X(V)` on a cover ⟹ `η ▷ P|_V ≅ η` via the right unitor; local injectivity is
  local-on-target). Re-scope the lemma to `IsLocallyTrivial` (which the consumers
  `tensorObjOnProduct`/`exists_tensorObj_inverse`, lines 704–756, already use). Needs neither
  (a) nor (b) either, but is narrower (per-object, locally-trivial only) and heavier than (d).

## Informational

- **Decision 1.** No `MonoidalCategory (SheafOfModules R)`. The general
  `CategoryTheory.Sheaf.monoidalCategory` (`Sites.Monoidal:165`,
  `[J.W.IsMonoidal] [HasWeakSheafify J A] → MonoidalCategory (Sheaf J A)`) is for a **fixed**
  monoidal `A` with the **pointwise** tensor `F.obj X ⊗_A G.obj X`; the project's
  `PresheafOfModules.Monoidal` tensor is the **relative** `M.obj X ⊗_{R.obj X} N.obj X`, a
  different (quotient) structure, so it does not instantiate. File header lines 30–35 concur.
- **Decision 2.** `presheafToSheaf` IS monoidal given `J.W.IsMonoidal`
  (`Sheaf.instMonoidalFunctorOppositePresheafToSheaf`, `Sites.Monoidal`), and
  `CategoryTheory.Localization.Monoidal.*` (`Localization.Monoidal.Basic`) gives the localized
  monoidal category — both `[W.IsMonoidal]`-gated, both fixed-A/pointwise. So a strong-monoidal
  sheafification (⇒ free associator) is available *the moment* `J.W.IsMonoidal` holds; the only
  flatness-/MonoidalClosed-free way to get that is the enough-points route (Major). Mathlib
  **does** supply the points for the relevant site: `TopCat.hasEnoughPoints (X) :
  (Opens.grothendieckTopology X).HasEnoughPoints` (`Topology.Sheaves.Points:67`, 2026, via
  stalks) — so the abstract `IsMonoidalW` gives `(J.W (A := A)).IsMonoidal` outright for
  *fixed-A pointwise* tensor on `X`'s site. The only residue is the project's *relative module*
  tensor `⊗_R`, for which the same enough-points argument must be re-run by hand — small and
  flatness-free, not the multi-file `MonoidalClosed (PresheafOfModules R₀)` build prior iters
  assumed.
- **Why the bundled routes converge.** `Sheaf.monoidalCategory`, `Localization.Monoidal`, and
  `W.IsMonoidal` are one requirement: ⊗ preserves `J.W` under whiskering. Mathlib offers two
  proofs — MonoidalClosed (absent for modules) and enough-points/stalkwise (no MonoidalClosed).
  The project should take the second, concretely via `TopCat` stalks.

## Persistent file
- `analogies/ts-monoidal213.md` — full decision blocks, route-(d) proof sketch, and the two
  porting lemmas, captured for future iters.

Overall verdict: Mathlib ships neither a monoidal `SheafOfModules` nor a monoidal
sheafification for the relative module tensor, but the prior "MonoidalClosed wall" is
**overturned** — a `J.W`-map is a stalkwise isomorphism and isos tensor to isos, so whiskering
stability (hence the associator, for arbitrary `M N P`) follows with **no flatness, no
MonoidalClosed, and no `tensorObj_restrict_iso`** (route (d), the technique Mathlib newly
blesses in `Sites/Point/IsMonoidalW.lean`, 2026, with the points for `X`'s site already
supplied by `TopCat.hasEnoughPoints`); the only project work is re-running the enough-points
argument for the module localizer plus stalk-commutes-with-module-tensor.
