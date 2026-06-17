# Mathlib Analogist Report

## Mode
api-alignment

## Slug
tosheaf-reflect

## Iteration
053

## Question
Reconcile the two sheafification functors for `cechAugmented_exact`: reflect `IsZero` of a
`SheafOfModules` homology through the faithful additive `SheafOfModules.toSheaf`, and match
`toSheaf ∘ (module sheafification)` with `presheafToSheaf J AddCommGrp ∘ (forget to presheaves of
Ab)`. Confirm with precise citations: (1) a "faithful + preserves-zero ⇒ reflects IsZero" lemma,
(2) `toSheaf` faithful/additive instances, (3) the sheafification square at the homology object,
(4) diamond hazards.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. faithful+pzm ⇒ reflects IsZero (named vs inline) | PROCEED | informational |
| 2. `toSheaf` Faithful / Additive / PreservesZeroMorphisms instances | PROCEED | informational |
| 3. sheafification square `sheafificationCompToSheaf` at the object | PROCEED | informational |

## Informational

All three links are already supplied by Mathlib or by the project; **no ALIGN_WITH_MATHLIB
refactor is owed and no new infrastructure must be built beyond a 3-line helper.** Findings,
each machine-verified via `lean_run_code`:

1. **No bare-object "reflects IsZero" lemma in Mathlib.** The blueprint-named
   `CategoryTheory.Functor.reflects_exact_of_faithful` **exists** but needs `[Abelian C] [Abelian D]`
   and is `ShortComplex`-phrased:
   `(F : C ⥤ D) [F.PreservesZeroMorphisms] [F.Faithful] (S : ShortComplex C) : (S.map F).Exact → S.Exact`.
   The lighter, `Abelian`-free idiom for the bare object is the verified 3-line proof
   `rw [IsZero.iff_id_eq_zero] at h ⊢; apply F.map_injective; rw [F.map_id, F.map_zero, h]`
   (off `CategoryTheory.Limits.IsZero.iff_id_eq_zero`). Prefer it — building a `ShortComplex` just to
   reuse `reflects_exact_of_faithful` is needless overhead.

2. **`toSheaf` instances all present** (`inferInstance`-verified), in
   `Mathlib/Algebra/Category/ModuleCat/Sheaf.lean`:
   `Functor.Faithful (SheafOfModules.toSheaf R)`, `(SheafOfModules.toSheaf R).Additive`,
   `(SheafOfModules.toSheaf R).PreservesZeroMorphisms`.

3. **The square is Mathlib-native:** `PresheafOfModules.sheafificationCompToSheaf α :
   sheafification α ⋙ toSheaf R ≅ toPresheaf R₀ ⋙ presheafToSheaf J AddCommGrpCat`
   (signature verified). `.app P` yields the object iso
   `toSheaf.obj ((sheafification α).obj P) ≅ (presheafToSheaf J Ab).obj ((toPresheaf R₀).obj P)`.
   The guessed `PresheafOfModules.toSheaf` does **not** exist — the forgetful path is
   `toPresheaf R₀ ⋙ presheafToSheaf`. The project already consumes this exact square in
   `AffineSerreVanishing.lean:113-157`.

4. **Diamond hazards** (see `analogies/tosheaf-reflect.md` for the full list): keep the entire
   argument at the bundled functor/object/Iso level. The `.val`-vs-`.hom` and CommRingCat semiring
   diamonds only bite when a `Sheaf J Ab` morphism is unfolded to its `NatTrans`/component. The
   reflection via `IsZero.iff_id_eq_zero`+`map_injective` (bundled `𝟙 = 0`) and the transport via
   `IsZero.of_iso` along `(sheafificationCompToSheaf α).app P` stay bundled — the verified skeleton
   needed no `change`/defeq. Supply `presheafToSheaf` typeclass args in term mode, not mid-`rw`.

**End-to-end skeleton machine-verified** (steps reflect + square composed):
the goal `IsZero ((sheafification α).obj P)` is closed by `apply isZero_of_faithful_pzm (toSheaf R)`
then `exact hpre.of_iso ((sheafificationCompToSheaf α).app P).symm`, where `hpre` is the
`presheafToSheaf`-level `IsZero` produced by the landed site lemma
`isZero_presheafToSheaf_obj_of_isLocallyBijective`.

## Persistent file
- `analogies/tosheaf-reflect.md` — decl names, the 4-step bridge, and the diamond-avoidance rules.

Overall verdict: the entire bridge is assemblable from existing Mathlib instances + the native
`sheafificationCompToSheaf` square + the project's landed site lemmas, plus one 3-line bare-object
`IsZero`-reflection helper; no parallel API and no ALIGN refactor are needed.
