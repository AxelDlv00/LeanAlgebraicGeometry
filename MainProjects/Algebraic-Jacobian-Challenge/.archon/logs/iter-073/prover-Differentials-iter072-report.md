# AlgebraicJacobian/Differentials.lean — iter-072

## Summary

**Primary target closed**: `cotangentExactSeqAlpha` inner sorry at L242 — fully proved.
Net sorry trajectory **8 → 7** for this file.

Constructed the `Derivation' φ_g'` of the pushed-forward target
`M_pushed := (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
  (relativeDifferentialsPresheaf (f ≫ g))` and fed it to
`(PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc`.

**Stretch target not attempted in code**: `cotangentExactSeq_structure.h_epi` (L368).
See note below — Mathlib does not appear to have a SheafOfModules-level
`epi_iff_surjective` lemma, and the project file does not yet have a wrapper
that lifts `PresheafOfModules.epi_iff_surjective` through the
`X.Modules → X.PresheafOfModules` forgetful functor. Recorded as next step.

## `cotangentExactSeqAlpha` (L199–L279) — RESOLVED

### Construction

The skeleton (iter-071) was:
```
refine ((Scheme.Modules.pullbackPushforwardAdjunction f).homEquiv _ _).symm ?_
let φ_g' := ... ; let φ_fg' := ...
let presheafHom : relativeDifferentialsPresheaf g ⟶
    (PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
      (relativeDifferentialsPresheaf (f ≫ g)) :=
  (PresheafOfModules.DifferentialsConstruction.isUniversal' φ_g').desc sorry  -- L242
exact ⟨presheafHom⟩
```

The closed proof now provides a `d_target :
((PresheafOfModules.pushforward f.toRingCatSheafHom.hom).obj
  (relativeDifferentialsPresheaf (f ≫ g))).Derivation' φ_g'` via:

- **`d` field**: `fun {U} => AddMonoidHom.mk' (fun b => D_X.d ((f.c.app U).hom b)) _`
  where `D_X = PresheafOfModules.DifferentialsConstruction.derivation' φ_fg'`.
  The map-additive proof obligation closes by `simp` (uses `AddMonoidHom.map_add`
  on `(f.c.app U).hom` and `D_X.d`).

- **`d_mul` field**: After `dsimp` to unfold `AddMonoidHom.mk'` and
  `(f.c.app U).hom.map_mul`, `D_X.d_mul` finishes; final equation matches
  the goal by `rfl` (since the `M_pushed` scalar action is literally
  `(f.c.app U).hom`-restricted from `D_X`'s action).

- **`d_map` field**: For `f' : U ⟶ V` in `Y.Opensᵒᵖ`, naturality of `f.c`
  gives `(f.c.app V).hom (Y.presheaf.map f' x) = X.presheaf.map _ ((f.c.app U).hom x)`,
  then `D_X.d_map` transports.

- **`d_app` field** (substantive): Uses the key **adjunction-coherence
  identity** (definitional / `rfl`):
  ```
  φ_g' ≫ f.c
    = (adj_f.unit.app ((TopCat.Presheaf.pullback CommRingCat g.base).obj S.presheaf))
        ≫ (TopCat.Presheaf.pushforward CommRingCat f.base).map φ_fg'
  ```
  Applying both sides to `a : ((pullback g.base).obj S.presheaf).obj U`
  expresses `(f.c.app U).hom (φ_g'.app U a)` as
  `(φ_fg'.app (op (f⁻¹U.unop))).hom (transport_a)` where
  `transport_a := (adj_f.unit.app _).app U a`, whence `D_X.d_app _ : 0`.

### Verification

`lean_run_code` reproduction with the same imports as `Differentials.lean`
(modulo project-local `Cohomology/StructureSheafModuleK.lean` which is
unused for `cotangentExactSeqAlpha`) compiled with no diagnostics. The
key facts `φ_g' ≫ f.c = adj_f.unit ≫ (pushforward).map φ_fg'` and
`pushforward g ∘ pushforward f = pushforward (f≫g)` both hold definitionally
(verified by `rfl` tests).

### Key insight (worth recording)

The adjunction-coherence identity
```
φ_g' ≫ f.c = adj_f.unit.app _ ≫ (pushforward f.base).map φ_fg'
```
is **definitional** (`rfl`) in this setup. This is because:
- `φ_g'` is `(adj_g.homEquiv).symm g.c`, whose value at a section is the
  pullback-counit composed with `g.c`.
- `φ_fg'` is `(adj_fg.homEquiv).symm (f≫g).c`, and
  `(f≫g).c = g.c ≫ (pushforward g.base).map f.c` (also `rfl`-able via
  `LocallyRingedSpace.comp_c`).
- The composition of adjoints `pullback (f≫g) = pullback f ∘ pullback g`
  reduces the two adjunctions to a single one, and the unit/counit of
  the composed adjunction factors definitionally as the product of unit/counit
  of the individual ones.

This pattern is reusable: any time we need to transport a derivation via
the pushforward+pullback for a composition `f ≫ g`, the unit/counit factorisation
yields the relevant `d_app` identity by `rfl`.

## `cotangentExactSeq_structure.h_epi` (L368) — NOT ATTEMPTED THIS ITERATION

### Approach considered

`cotangentExactSeqBeta f g : relativeDifferentials (f ≫ g) ⟶ relativeDifferentials f`
is a morphism of `X.Modules` (`SheafOfModules` over `X.ringCatSheaf`). To show
`Epi`, the standard route is:

1. Reduce to `Epi` of the underlying `PresheafOfModules` morphism
   `presheafHom = (isUniversal' φ_fg').desc d1` (from iter-071 closure of
   `cotangentExactSeqBeta`).
2. Apply `PresheafOfModules.epi_iff_surjective`
   (`Mathlib/Algebra/Category/ModuleCat/Presheaf/EpiMono.lean:59`) to
   reduce to pointwise surjectivity at each `U : X.Opensᵒᵖ`.
3. At each `U`, the map is `KaehlerDifferential.map A A' B B`
   for `A = ((pullback (f≫g)).obj S.presheaf).obj U`,
   `A' = ((pullback f.base).obj Y.presheaf).obj U`, `B = X.presheaf.obj U`.
   Conclude by `KaehlerDifferential.map_surjective`
   (`Mathlib/RingTheory/Kaehler/Basic.lean`).

### Blocker

Mathlib does **not** appear to have a direct
`SheafOfModules.epi_iff_epi_presheaf` lemma. The two natural candidates
(`Algebra/Category/ModuleCat/Sheaf/Abelian.lean`,
`Algebra/Category/ModuleCat/Sheaf/EpiMono.lean` — the latter does not
exist) do not provide this. Without that lemma, step 1 above requires
either:

- A sheafification-via-locally-surjective argument (Stacks 0098),
  which is substantial Mathlib infrastructure work, or
- A direct manipulation using `Sheaf.Hom` extensionality and pre-composition
  with arbitrary parallel morphisms, which requires producing a counterexample
  or a constructive epi-witness; this is essentially the same as proving
  step 1 from first principles.

### Recommended next step

A future iteration should add a project-local helper:

```lean
lemma SheafOfModules.epi_of_epi_presheaf {R : Cᵒᵖ ⥤ RingCat} [HasSheafify J _]
    {M N : SheafOfModules R} (f : M ⟶ N) :
    CategoryTheory.Epi f.val → CategoryTheory.Epi f := ...
```

then `h_epi` reduces to pointwise surjectivity via `KaehlerDifferential.map_surjective`.
Alternatively, since `Sheafify` is conservative for evaluation on the
Grothendieck topology basis (which is `Opens X` here), the
`PresheafOfModules.epi_iff_surjective` may transport directly through
`X.Modules`'s definition; need to check the precise abstraction layer.

## Other sorries — UNCHANGED

| Decl | Line | Status |
|---|---|---|
| `relativeDifferentialsPresheaf_isSheaf` | L122 | Off-limits this iteration |
| `_structure.h_zero` | L359 | Blocked behind `Alpha` definition completion (now possibly unblocked — `Alpha` is closed; revisit iter-073) |
| `_structure.h_exact` | L363 | Same as `h_zero` |
| `_structure.h_epi` | L368 | See note above |
| `smooth_iff_locally_free_omega` | L413 | Off-limits this iteration |
| `cotangent_at_section` | L430 | Off-limits this iteration |
| `serre_duality_genus` | L572 | Off-limits this iteration |

### Note on `_structure.h_zero` / `h_exact` unblock

With `Alpha` now fully closed, `h_zero` (`α ≫ β = 0`) becomes attackable.
Mathematically, on each affine chart `A → A' → B`, this is
`KaehlerDifferential.mapBaseChange ≫ KaehlerDifferential.map = 0`, which
follows from `KaehlerDifferential.exact_mapBaseChange_map`. The global proof
will need a presheaf-of-modules extensionality argument plus the
ring-level identity, which requires unfolding the definitions of `Alpha`
and `Beta` to recover the affine description. Recommended for iter-073.

## Sorry count (this file)

Before: 8 (L122, L242, L359, L363, L368, L413, L430, L572)
After: **7** (L122, L359, L363, L368, L413, L430, L572)

## Blueprint status

`blueprint/src/chapters/Differentials.tex` already aligned with α/β/_structure
decomposition; `def:cotangent_alpha` (cotangentExactSeqAlpha) is now formalized
with **zero sorries** in its body. Recommend the `sync_leanok` phase mark it
`\leanok` in the proof block (the `\leanok` for the *definition block* should
already be present from iter-064/iter-071).

## Files touched

- `AlgebraicJacobian/Differentials.lean` (L239–L274 inserted; L242 sorry removed).
- `AlgebraicJacobian/.archon/task_results/Differentials.lean.md` (this file).

## No new axioms

Verified: the proof uses only `AddMonoidHom.mk'`, `simpa`, `dsimp`, `rfl`,
`rw`, `congr_arg`, plus the named Mathlib lemmas
`(f.c.app U).hom.map_mul`, `D_X.d_mul`, `f.c.naturality`,
`D_X.d_map`, `D_X.d_app`, and `PresheafOfModules.DifferentialsConstruction.{derivation', isUniversal'}`.
No `axiom`, no `sorry`, no `Classical.choice` introduced.
