# Mathlib Analogist Report

## Slug

isiso-routes-iter139

## Iteration

139

## Question

The iter-138 Route (b) skeleton for
`relativeDifferentialsPresheaf_basechange_along_proj_two`
(`AlgebraicJacobian/Cotangent/GrpObj.lean:612`) closed with three
concrete sorries. The third is `IsIso (basechange_along_proj_two_inv G)`
at line 624. Two paths are on the table for iter-140 closure:
**Route (a)** chart-unfolding helper + forward direction; **Route (b'2)**
local-iso check via `PresheafOfModules.toPresheaf` (iso-reflection) +
`NatTrans.isIso_iff_isIso_app`. Which to take?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Route choice for `IsIso` sorry | **PROCEED with Route (b'2)** | informational |
| 2: Helper placement | PROCEED | informational |
| 3: Per-open identification idiom (`tensorKaehlerEquiv`) | ALIGN_WITH_MATHLIB | critical |
| 4: Pullback-opacity caveat | PROCEED | informational |
| 5: LOC envelope revision | PROCEED — ~195–365 LOC | informational |

## Must-fix-this-iter

None — the iter-138 prover landed honest scaffolding; no shipped
divergent API is at issue here. The "must do this in iter-140"
guidance lives under **Major** below since the body has not yet been
written.

## Major

**Route (b'2) is the iter-140 closure target.** The iter-138 prover's
named API is verified:

- `PresheafOfModules.toPresheaf` — exists at
  `Mathlib.Algebra.Category.ModuleCat.Presheaf:149`
  (signature `PresheafOfModules R ⥤ Cᵒᵖ ⥤ Ab`).
- `NatTrans.isIso_iff_isIso_app` — exists at
  `Mathlib.CategoryTheory.NatIso:232`
  (signature `(τ : F ⟶ G) : IsIso τ ↔ ∀ X, IsIso (τ.app X)`).
- `PresheafOfModules.pullback` —
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback:44`.
- `PresheafOfModules.pullbackPushforwardAdjunction` —
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback:50`.

**Critical caveat the iter-138 prover did not flag**:
`(PresheafOfModules.toPresheaf R).ReflectsIsomorphisms` is **NOT**
directly registered as an instance in Mathlib. Typeclass synthesis
fails on this exact instance unless one of the following imports is
present:

- `Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced` (direct),
  or transitively via
- `Mathlib.Algebra.Category.ModuleCat.Presheaf.Sheafification`.

The Balanced.lean file gives a priority-100 instance
`reflectsIsomorphisms_of_reflectsMonomorphisms_of_reflectsEpimorphisms`
(`Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced:31`) which
combines `Balanced (PresheafOfModules R)` (registered) with
`(toPresheaf R).ReflectsMonomorphisms` (from `Faithful`) and
`(toPresheaf R).ReflectsEpimorphisms` (also inferable) to deliver
`ReflectsIsomorphisms`. **Verify the import chain reaches Balanced
before relying on the iso-reflection step.**

With imports in place, the load-bearing reduction is a **5-line
helper** verified to typecheck this iter:

```lean
namespace PresheafOfModules
theorem isIso_of_app_iso_module {C : Type*} [Category C]
    {R : Cᵒᵖ ⥤ RingCat} {M N : PresheafOfModules R}
    (f : M ⟶ N) (h : ∀ X, IsIso (f.app X)) : IsIso f := by
  rw [← isIso_iff_of_reflects_iso _ (PresheafOfModules.toPresheaf R),
       NatTrans.isIso_iff_isIso_app]
  intro X
  exact Functor.map_isIso (forget₂ (ModuleCat _) AddCommGrpCat) (f.app X)
end PresheafOfModules
```

This is the **5-line bridge** that swaps "PresheafOfModules iso check"
for "per-open ModuleCat iso check at every X". Mirrors the Mathlib
analogue at `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:132`
(`Scheme.Modules.Hom.isIso_iff_isIso_app`), which uses the same
reflection pattern at the sheaf-of-modules level.

**Iter-140 prover gap items, in build order**:

1. **5-line `isIso_of_app_iso_module` helper** (verified). Place
   adjacent to `basechange_along_proj_two_inv` in
   `Cotangent/GrpObj.lean`. Add
   `import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced`
   if not transitively present (check the build first).
2. **Chart-level `Algebra.IsPushout`-from-affine-product helper**
   (~80–150 LOC; **shared with Route (a)**). Build from
   `CommRingCat.isPushout_iff_isPushout`
   (`Mathlib/Algebra/Category/Ring/Constructions.lean:133`),
   `pullbackSpecIso`
   (`Mathlib/AlgebraicGeometry/Pullbacks.lean:703`),
   `isPullback_SpecMap_of_isPushout`
   (`Mathlib/AlgebraicGeometry/Pullbacks.lean:771`).
3. **`((pullback ψ).obj M).obj X` chart-unfolding helper**
   (~30–60 LOC; **shared with Route (a)**). Build from
   `pullbackPushforwardAdjunction` unit/counit at chart level.
   This addresses the `pullback`-opacity blocker that neither
   route escapes.
4. **Per-open identification** (~80–150 LOC). For each affine `X`,
   identify `(basechange_along_proj_two_inv G).app X` with
   `KaehlerDifferential.tensorKaehlerEquiv.symm`
   (`Mathlib.RingTheory.Kaehler.TensorProduct`) modulo the chart
   unfolding (step 3) and `Algebra.IsPushout` (step 2). Companion
   simp lemma: `tensorKaehlerEquiv_symm_D_tmul`.

## Informational

### Why Route (a) is the worse choice (concrete comparison)

| | Route (a) | Route (b'2) |
|---|---|---|
| 5-line `isIso_of_app_iso_module` helper | n/a | **5 LOC** |
| `pullbackObjEquivTensor` chart-unfolding | ~30–60 LOC (shared) | ~30–60 LOC (shared) |
| Chart-level `Algebra.IsPushout` | ~80–150 LOC (shared) | ~80–150 LOC (shared) |
| Forward direction construction + inverse pair | **~80–200 LOC extra** | n/a — iso check is local |
| Per-open `tensorKaehlerEquiv` identification | ~50–100 LOC | ~80–150 LOC |
| **Total** | **~240–510 LOC** | **~195–365 LOC** |

Route (b'2) saves ~50–195 LOC by replacing the "build forward,
prove inverse pair" work with the 5-line iso-reflection bridge plus
a slightly heavier per-open identification.

### Why both routes share the heavy lifting

The `PresheafOfModules.pullback` is `(pushforward φ).leftAdjoint`
(`Pullback.lean:44`) — abstractly defined, no chart-wise unfolding
in Mathlib. **Neither** Route (a) nor Route (b'2) escapes the need to
describe `((pullback ψ).obj M_G).obj X` per-open to identify it with
`tensorKaehlerEquiv`'s output. Route (b'2)'s savings come from
avoiding the explicit forward construction, not from avoiding the
chart-unfolding helper. Both shared helpers (`pullbackObjEquivTensor`,
`Algebra.IsPushout` chart-helper) are upstream-PR candidates.

### Alternative not pursued

A third route — checking iso via `PresheafOfModules.evaluation R X`
directly (instead of going through `toPresheaf` + `NatTrans.isIso`) —
is plausible (`evaluation R X` lands in `ModuleCat (R.obj X)`, no
need to bounce through `AddCommGrpCat`). But Mathlib has no packaged
"joint reflects iso" lemma for `evaluation` (only the colimit
versions, `evaluationJointlyReflectsColimits`). Building one would
add ~10–20 LOC and require the same Balanced infrastructure. **Not
worth deviating** — the 5-line `isIso_of_app_iso_module` via
`toPresheaf` is the direct path.

## Persistent file

- `analogies/isiso-basechange-along-proj-two-inv.md` —
  full route comparison with verified Mathlib API + iter-140 build
  order + LOC table.

## Overall verdict

**PROCEED with Route (b'2)** — Mathlib API is verified-to-exist,
the 5-line iso-reflection helper is typechecked, and Route (b'2)
saves ~50–195 LOC vs Route (a) by avoiding the explicit
forward-direction construction. The iter-140 prover must build (or
verify transitive import of) the `ReflectsIso.Balanced` infrastructure
and the two shared helpers (`pullbackObjEquivTensor`, chart-level
`Algebra.IsPushout`) regardless of route — these are upstream-PR
candidates worth flagging.
