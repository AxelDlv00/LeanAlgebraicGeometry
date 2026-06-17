# Directive: mathlib-analogist (api-alignment)

## Mode: api-alignment

## Context (self-contained)

We are about to formalize a theorem `cechAugmented_exact` in a Lean project building Čech
cohomology of schemes. The target lives in category `X.Modules` = `SheafOfModules (X.ringCatSheaf)`
(sheaves of `O_X`-modules on a scheme `X`). We must prove a cochain complex of `X.Modules` is
exact (all homology objects `IsZero`).

The proof route (already in the project blueprint) is "sections + sheafification", in 4 steps:
1. **Reflect through the forgetful functor to abelian sheaves.** Use that
   `SheafOfModules.toSheaf` (the functor `X.Modules ⥤ Sheaf J AddCommGrp`) is **faithful and
   additive**, hence preserves zero morphisms, hence **reflects the property "an object is zero"**.
   So it suffices to show `IsZero (toSheaf.obj (homology p))` in `Sheaf J AddCommGrp`.
2. The homology SHEAF = sheafification of the PRESHEAF homology. The project already has the
   module-level engine `PresheafOfModules.homologyIsoSheafify` (in `HigherDirectImagePresheaf.lean`)
   giving `H^i(sheafify K) ≅ sheafify(H^i K)` for a cochain complex `K` of presheaves of modules.
3. The presheaf homology is locally zero on the affine basis, so its sheafification is the zero
   sheaf. The project already landed **upstream, abelian-sheaf-level** site lemmas (in
   `CechHigherDirectImage.lean`):
   - `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W`
   - `…isZero_presheafToSheaf_obj_of_W_isZero`
   - `…isZero_presheafToSheaf_obj_of_isLocallyBijective`
   These act on `presheafToSheaf J AddCommGrp` (abelian-sheaf sheafification), NOT on the
   module-level `PresheafOfModules.sheafification`.

## The exact question (the one remaining bridge)

There are TWO sheafification functors in play and we need them reconciled:
- **Module-level:** `PresheafOfModules.sheafification α` (what `homologyIsoSheafify` produces), giving
  objects in `SheafOfModules`.
- **Abelian-sheaf-level:** `CategoryTheory.presheafToSheaf J AddCommGrp` (what the 3 landed site
  lemmas consume).

The bridge we need: reflect `IsZero` of a `SheafOfModules` object (the homology) through the
faithful additive `SheafOfModules.toSheaf`, AND match `toSheaf ∘ (module sheafification)` with
`(presheafToSheaf J AddCommGrp) ∘ (forget to presheaves of abelian groups)` — i.e. the
"sheafification square". The project already built an analogous square
`PresheafOfModules.sheafificationCompToSheaf` for the `toSheaf`-preserves-colimits result (see
`AffineSerreVanishing.lean` lines ~94–120, and `analogies/tosheaf-epi.md`).

Please answer, with precise Mathlib citations (declaration names + file), whether these exist
as-is in current Mathlib / the project, and what the canonical idiom is:

1. **Faithful + additive ⇒ reflects IsZero.** Is there a Mathlib lemma "a faithful functor that
   preserves zero morphisms reflects `IsZero`" (or `Functor.reflects_isZero` / via
   `ReflectsZeroMorphisms` / `Faithful` + `PreservesZeroMorphisms`)? The project blueprint named
   `CategoryTheory.Functor.reflects_exact_of_faithful` — confirm it exists and whether the simpler
   "reflects IsZero" form exists. Name the exact decl.

2. **`SheafOfModules.toSheaf` faithfulness/additivity instances.** Confirm `[Faithful
   (SheafOfModules.toSheaf R)]` and additivity (`PreservesZeroMorphisms` / `Functor.Additive`)
   are available as instances in Mathlib. Name them.

3. **The sheafification square at the homology object.** What is the cleanest Mathlib idiom to get
   `toSheaf.obj ((PresheafOfModules.sheafification α).obj P) ≅ (presheafToSheaf J AddCommGrp).obj
   ((toPresheaf … ⋙ forget) P)` — i.e. `toSheaf ∘ sheafification ≅ presheafToSheaf ∘ forget`?
   Does `PresheafOfModules.sheafificationCompToSheaf` (the project's existing square) directly give
   this, and at what generality? Is there a Mathlib-native naturality square we should use instead
   (`PresheafOfModules.toSheaf`, `SheafOfModules.toSheaf`, `sheafificationAdjunction`)?

4. **Diamond risk.** This project has a documented history of CommRingCat-vs-Ring `Semiring` diamonds
   and `toSheaf` `.val`-vs-`.hom` mismatches (`analogies/keystone-tile-reconciliation-not-rfl.md`,
   `rR-semiring-diamond-change-workaround.md`, `tosheaf-epi.md`). Flag any spot in the above bridge
   where a defeq/diamond mismatch is likely, and the Mathlib-idiomatic way to avoid it (e.g. work
   with `.hom` not `.val`, use `change`/defeq not `rw`, use the existing square's `.app`).

Output: an `analogies/<slug>.md` file with the concrete decl names, the recommended bridge
construction (as mathematical/structural prose, NOT Lean tactic blocks), and the diamond hazards
to avoid. Also a `task_results/` report. Search radius: the Mathlib `CategoryTheory.Sites`,
`Algebra.Category.ModuleCat.Sheaf`, and `PresheafOfModules` areas.
