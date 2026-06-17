# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ma-ihom263

## Iteration
263

## Question
Is the `internalHomObjModule` design a parallel-API smell (progress-critic "design-shape
suspected"), or is only a thin `internalHomObjModule`-add ↦ `Hom`-add bridge missing for
`sliceDualTransport`'s `map_add'`/`map_smul'`?  Does Mathlib have a canonical idiom that fires
`map_add` without a manual `change`, and what is the cleanest bridge?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| `internalHomObjModule` re-implements a Mathlib module-on-Hom? | PROCEED | informational |
| bridge unblocking map_add' (and its generality) | PROCEED | informational |

## Informational

**The design is NOT a smell — PROCEED, no refactor.**  `internalHomObjModule`
(PresheafInternalHom.lean:669) reduces to `homModule` (PresheafInternalHom.lean:628), a
`Module … (M ⟶ N) where` that supplies **only** `smul := φ ↦ φ ≫ globalSMul …` and the `smul`
axioms.  It declares NO `add`/`zero`/`neg`; the `AddCommGroup (M ⟶ N)` is the ambient
`PresheafOfModules.Hom` Preadditive group.  So there is exactly **one** add, shared with Mathlib's
Preadditive Hom group — no parallel API to unify.  This is precisely Mathlib's idiom for a
module-on-a-Hom-type (cf. `Module.End`, the fixed-ring internal hom): supply the scalar action over
the category's `Preadditive` group.  The `smul` (post-composition with `globalSMul`) is the
mathematically-canonical action.  The blocker the prover hit is the **endemic
`ModuleCat`/`restrictScalars`/`pushforward` carrier-vs-`Hom` defeq friction**, not a design choice.

**Q1 (canonical idiom)**: `PresheafOfModules.add_app` exists (used at PresheafInternalHom.lean:609)
but does NOT fire here, because the `+` on `x y : ↑(((pushforward β).obj M.val.dual).obj V)` is on a
`ModuleCat` *carrier* wrapped through `pushforward`/`restrictScalars`/`ofPresheaf`, not a literal
`M ⟶ N` Hom add.  Mathlib's standard resolution is NOT a special `add_apply` lemma — it is to
**reshape the goal with `change`/`show`** to the bare composite form, then let
`Functor.map_add` (restrictScalars is `Additive`) + `Preadditive.add_comp` fire.

**Q2 (cleanest bridge)**: the hypothesised defeq bridge is correct and is literally `rfl`; no
standalone helper lemma is needed.  `map_add'` closes outright with this VERIFIED recipe (goal → `[]`):

```lean
· intro x y
  apply PresheafOfModules.hom_ext
  intro W
  change (ModuleCat.restrictScalars _).map ((x + y).app _) ≫ _ = _   -- LOAD-BEARING
  rw [show (x + y).app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom)))
        = x.app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom)))
          + y.app (op (Over.mk ((Hom.opensFunctor f).map (unop W).hom))) from rfl,
      Functor.map_add, Preadditive.add_comp]
```

The `change … = _` BEFORE the bridge rewrite is the lever: replacing it with
`simp only [PresheafOfModules.add_app]` / `dsimp only [PresheafOfModules.add_app]` leaves the
`(restrictScalars _).map (·)` application in a form where `Functor.map_add` reports "pattern not
found" (both alternatives verified to FAIL at the same `rw`).

**Q3 / generalisation**: the `change`-reshape opener generalises to `map_smul'`, but the additive
`rfl` bridge does **not**.  `m • x` on the domain is the `homModule` post-composition action
(`φ ≫ globalSMul`) with the scalar at the `V`-level — the naive `(m • x).app W = (β.app W m) • x.app W`
bridge FAILS (verified type-mismatch / `HSMul` synth failure).  `map_smul'` needs the genuine smul
argument (`homModule.smul` unfold → `comp_app` → `globalSMul_hom_apply`, intertwined through
`dualUnitRingSwap`; the presheaf shadow of `restrictScalarsRingIsoDualEquiv`'s `map_smul'`), opened
by the same `change (ModuleCat.restrictScalars _).map ((m • x).app _) ≫ _ = _`.  The remaining
sub-holes (`invFun`/`left_inv`/`right_inv`) are `Iso.inv_hom_id`/`hom_inv_id` round-trips, not
additivity — the bridge does not bear on them.  So "this recurs on every sub-hole" holds only for
the cheap `change`-reshape pattern, not for a multiplying family of bridge lemmas.

## What I verified (LSP)
- `homModule` declares only `smul` + smul-axioms; add is the ambient Preadditive group — source
  read (PresheafInternalHom.lean:628-642, 669-674).
- `(x + y).app W = x.app W + y.app W` against the real `((pushforward β).obj M.val.dual).obj V`
  objects — `lean_run_code`, closes by `rfl`. ✓
- `(ModuleCat.restrictScalars φ).Additive` — `lean_run_code`, `infer_instance`. ✓
- **`map_add'` fully closes** with the recipe above — `lean_multi_attempt` at DualInverse.lean:343,
  `goals: []` (only style warnings). ✓
- `simp only`/`dsimp only [PresheafOfModules.add_app]` variants FAIL at `Functor.map_add`
  ("pattern not found") — same `lean_multi_attempt`. ✓ (justifies the `change`).
- Naive smul bridge `(m • x).app W = (β.app W m) • x.app W` FAILS (scalar level mismatch +
  `HSMul` synth) — `lean_multi_attempt` at DualInverse.lean:346. ✓ (justifies the harder smul route).

## Persistent file
- `analogies/ma-ihom263.md` — design-rationale + the verified `map_add'` recipe and `map_smul'`
  route captured for future iters.

Overall verdict: PROCEED — `internalHomObjModule` is Mathlib-aligned (single shared Preadditive add,
canonical post-composition smul); ship the verified `change`-based `map_add'` recipe and build
`map_smul'` from `homModule.smul`/`globalSMul` with the same opener — no design refactor.
