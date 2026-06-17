<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T10:08:08Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Refactor Directive — iter-012

## Summary

Append two new declarations to `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`, both with body `:= sorry`, opening Path-2 of Phase A step 6 (Čech cohomology of the structure sheaf). No other file is touched. Iter-011 closures (`AlgebraicGeometry.genus` in `Genus.lean`) and prior iter-005/006/007/009/010 declarations remain intact. `archon-protected.yaml` unchanged.

## Mathematical justification

Iter-011 closed the protected `AlgebraicGeometry.genus` definition with `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. The downstream consumer `smoothOfRelativeDimension_genus` (one of the four `Jacobian.lean` instances, currently `sorry`) will eventually require **Serre finiteness** — the theorem `Module.Finite k (Scheme.HModule k (Scheme.toModuleKSheaf C) i)` for $i \le 1$ on a smooth proper geometrically irreducible curve $C/k$. Without Serre finiteness, `genus C` is well-defined but is zero on infinite-dimensional $H^1$; with Serre finiteness it equals the geometric genus.

Mathlib `b80f227` does not provide Serre finiteness for sheaf-Ext (`ModuleCat.finite_ext` covers module-Ext only — not the sheaf-cohomology setting that defines $H^i$). The viable route is **Path 2 (Čech-cohomology scaffold)**: iter-013+ work will produce a Čech-vs-derived-functor comparison theorem for an acyclic cover, then transport finiteness through that comparison, using affine-finiteness (each cochain group is finite-dimensional when the cover is affine and the curve is proper) plus dimension-vanishing (degree $> 1$ vanishes on a curve). Iter-012 lays the smallest useful first sub-step: the carrier on which all the iter-013+ work will operate.

The carrier is Mathlib's `CategoryTheory.cechComplexFunctor` (file `Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean`) applied to the underlying presheaf of `Scheme.toModuleKSheaf C` for an arbitrary indexed open cover `𝒰 : ι → Opens C.left.toTopCat`. The result is a cochain complex in `CochainComplex (ModuleCat.{u} k) ℕ`; its `n`-th cohomology lives in `ModuleCat.{u} k`. Both are well-defined; the `Module k`-finiteness of either is what Serre finiteness will eventually establish (iter-013+), but is not iter-012 work.

## Plan-agent live probe (iter-012, this pass)

```lean
import Mathlib
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

universe u

namespace AlgebraicGeometry

-- Probe (1): the Čech complex.
noncomputable example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) :
    CochainComplex (ModuleCat.{u} k) ℕ :=
  (cechComplexFunctor 𝒰).obj
    ((sheafToPresheaf _ _).obj (Scheme.toModuleKSheaf C))

-- Probe (2): the cohomology in degree n.
noncomputable example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) (n : ℕ) :
    ModuleCat.{u} k :=
  ((cechComplexFunctor 𝒰).obj
    ((sheafToPresheaf _ _).obj (Scheme.toModuleKSheaf C))).homology n

end AlgebraicGeometry
-- both: {success: true, diagnostics: []}
```

The required typeclass instances (`HasProducts (ModuleCat.{u} k)`, `HasFiniteProducts (Opens X)`, `Preadditive (ModuleCat.{u} k)`) are all auto-resolved against the existing project state.

## File touched (single)

`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` — currently 212 lines. After iter-012 refactor: ~232 lines (~20 LOC of new declarations + docstrings appended after the iter-010 `HModule_zero_linearEquiv` block at L211).

No new file. No new chapter file. The blueprint chapter `chapters/Cohomology_StructureSheafModuleK.tex` already contains the informal sketch (Section "Čech cohomology of the structure sheaf (iter-012 scaffold)", with `def:Scheme_cechCochain_OC` and `def:Scheme_cechCohomology_OC` blocks); the plan agent updated it this pass before issuing this directive.

## Specific changes

### Change 1 — append `Scheme.cechCochain_OC`

Append after the iter-010 `HModule_zero_linearEquiv` block (after line 211). Use exactly this signature and docstring:

```lean
/-- Phase A step 6 *Path 2* (iter-012 scaffold): the Čech cochain complex of
the structure sheaf of a `Spec k`-scheme `C : Over (Spec (CommRingCat.of k))`,
with respect to an arbitrary indexed family of opens `𝒰 : ι → Opens C.left.toTopCat`.
Built from Mathlib's `CategoryTheory.cechComplexFunctor` (file
`Mathlib/CategoryTheory/Sites/SheafCohomology/Cech.lean`) applied to the
underlying presheaf of `Scheme.toModuleKSheaf C` (iter-006). The result is a
cochain complex valued in `ModuleCat.{u} k`, indexed by `ℕ`.

The cohomology of this complex is `Scheme.cechCohomology_OC` below. The
downstream comparison theorem (Čech cohomology = derived-functor cohomology
= `Scheme.HModule k (Scheme.toModuleKSheaf C)` for an acyclic cover) is
queued for iter-013+; iter-012 only establishes the Čech-side carrier. -/
noncomputable def Scheme.cechCochain_OC
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) :
    CochainComplex (ModuleCat.{u} k) ℕ :=
  sorry
```

Expected closure body (iter-012 prover round): `(cechComplexFunctor 𝒰).obj ((sheafToPresheaf _ _).obj (Scheme.toModuleKSheaf C))`.

### Change 2 — append `Scheme.cechCohomology_OC`

Append immediately after Change 1:

```lean
/-- Phase A step 6 *Path 2* (iter-012 scaffold): the `n`-th Čech cohomology
of the structure sheaf for an arbitrary indexed open cover. Defined as the
`n`-th homology of the Čech cochain complex `Scheme.cechCochain_OC`. The
result lives in `ModuleCat.{u} k` and therefore carries a `Module k`
structure for free; the iter-013+ comparison theorem will identify it
with `Scheme.HModule k (Scheme.toModuleKSheaf C) n` when the cover is
acyclic. -/
noncomputable def Scheme.cechCohomology_OC
    {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) (n : ℕ) :
    ModuleCat.{u} k :=
  sorry
```

Expected closure body (iter-012 prover round): `(Scheme.cechCochain_OC C 𝒰).homology n`.

### Change 3 — none

No other change. Do **not** edit `archon-protected.yaml`. Do **not** rename or reorder existing declarations. Do **not** touch any other `.lean` file. Do **not** rewrite any docstring beyond appending the two new ones.

## Sanity checks (refactor agent must run before declaring done)

1. `${LEAN4_PYTHON_BIN:-python3} "$LEAN4_SCRIPTS/sorry_analyzer.py" AlgebraicJacobian/ --format=summary` should return `11 total across 4 file(s)` (= pre-refactor 9 + 2 new). Expected distribution: `5 Jacobian.lean + 3 AbelJacobi.lean + 1 Picard/Functor.lean + 2 Cohomology/StructureSheafModuleK.lean`.
2. `lean_diagnostic_messages AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` should return exactly two `declaration uses 'sorry'` warnings (on the two new declarations) and zero errors. All earlier declarations in the file (iter-005 prerequisites, iter-006 main, iter-007 polish, iter-009 `HModule`, iter-010 `HModule_zero_linearEquiv`) must remain compiling.
3. `lean_diagnostic_messages AlgebraicJacobian/Genus.lean` should return `{success: true, items: [], failed_dependencies: []}` (the iter-011 `genus` closure must remain intact — adding declarations downstream of it cannot affect its compilation, but verify regardless).
4. Re-probe the prover's intended closure bodies (sanity check that the directive's `sorry` slots accept the iter-012 prover's expected one-liners):

```lean
import AlgebraicJacobian.Cohomology.StructureSheafModuleK

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

universe u

namespace AlgebraicGeometry

-- Probe: cechCochain_OC body
noncomputable example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) :
    CochainComplex (ModuleCat.{u} k) ℕ :=
  (cechComplexFunctor 𝒰).obj
    ((sheafToPresheaf _ _).obj (Scheme.toModuleKSheaf C))

-- Probe: cechCohomology_OC body (assumes Scheme.cechCochain_OC present)
noncomputable example {k : Type u} [Field k] (C : Over (Spec (.of k)))
    {ι : Type u} (𝒰 : ι → Opens C.left.toTopCat) (n : ℕ) :
    ModuleCat.{u} k :=
  (Scheme.cechCochain_OC C 𝒰).homology n

end AlgebraicGeometry
```

Both must return `{success: true, diagnostics: []}` against the post-refactor file. (Note: there will be a deprecation warning on `Sheaf.val`-style spellings; use `(sheafToPresheaf _ _).obj F` not `F.val` for the presheaf extraction. The iter-012 plan-agent probe used the modern spelling.)

## Forbidden modifications

- Do **not** scaffold a new file `AlgebraicJacobian/Cohomology/Cech.lean`. Iter-012 keeps the surface area minimal; new files come iter-013+ when the Čech content justifies the split.
- Do **not** introduce typeclass parameters beyond what `cechComplexFunctor` requires (all auto-resolved).
- Do **not** rename or restructure the iter-010 `HModule_zero_linearEquiv` block; iter-012 declarations append after it.
- Do **not** reorder the file. The iter-012 declarations must appear after the iter-010 block, in the order Change 1 → Change 2 (so `cechCohomology_OC` can reference `cechCochain_OC` in its prover-round body).
- Do **not** change the `noncomputable` modifier on either declaration. Both are noncomputable (the `cechComplexFunctor` body uses `Abelian.Ext`-flavoured products and `homology` is noncomputable).
- Do **not** add or remove any `import`. The existing `import AlgebraicJacobian.Cohomology.StructureSheafAb` (which transitively brings in `Mathlib`) is sufficient — `cechComplexFunctor` and `sheafToPresheaf` resolve through it.
- Do **not** touch `archon-protected.yaml`.

## Expected sorry-count delta

- Pre-refactor: 9 sorries (= 8 protected + 1 deferred `representable`). Distribution: `5 Jacobian.lean + 3 AbelJacobi.lean + 1 Picard/Functor.lean + 0 Cohomology/StructureSheafModuleK.lean`.
- Post-refactor: 11 sorries (= 9 + 2 new). Distribution: `5 Jacobian.lean + 3 AbelJacobi.lean + 1 Picard/Functor.lean + 2 Cohomology/StructureSheafModuleK.lean`.
- Post-iter-012-prover (next phase, after this refactor): 9 sorries (back to baseline).

## After the refactor agent runs

The plan agent will be re-invoked for a post-refactor verification pass:
1. Verify the two new declarations are appended at the correct locations with verbatim signatures.
2. Verify sorry count = 11 and warnings = 2 on `StructureSheafModuleK.lean`.
3. Verify `archon-protected.yaml` unchanged and `Genus.lean` still compiles cleanly.
4. Re-probe the prover's intended closure bodies against the post-refactor file.
5. Write `PROGRESS.md` with the iter-012 prover-round objective on `Cohomology/StructureSheafModuleK.lean` (sole file touched this iteration).
