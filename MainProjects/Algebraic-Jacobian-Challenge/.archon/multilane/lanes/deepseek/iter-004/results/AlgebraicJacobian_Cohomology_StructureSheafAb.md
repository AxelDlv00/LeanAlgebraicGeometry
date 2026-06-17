# Task Results: `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`

## Summary

All 3 sorries closed. File compiles cleanly (`lean_diagnostic_messages` returns 0 errors).

## Sorries closed

### 1. `instHasSheafify_Opens_AddCommGrp` (L34)
- **Line**: 34
- **Declaration**: `AlgebraicGeometry.Cohomology.instHasSheafify_Opens_AddCommGrp`
- **Closure**: `inferInstance`
- **Verified by probe**: `example (X : TopCat.{u}) : HasSheafify (Opens.grothendieckTopology X) AddCommGrpCat.{u} := inferInstance` succeeds.
- **Body**:
  ```lean
  instance instHasSheafify_Opens_AddCommGrp (X : TopCat.{u}) :
      CategoryTheory.HasSheafify (Opens.grothendieckTopology X)
        AddCommGrpCat.{u} := inferInstance
  ```

### 2. `instHasExt_Sheaf_Opens_AddCommGrp` (L42)
- **Line**: 42
- **Declaration**: `AlgebraicGeometry.Cohomology.instHasExt_Sheaf_Opens_AddCommGrp`
- **Closure**: `HasExt.standard _`
- **Verified by probe**: `example (X : TopCat.{u}) : HasExt.{u+1} (Sheaf (Opens.grothendieckTopology X) AddCommGrpCat.{u}) := HasExt.standard _` succeeds.
- **Body**:
  ```lean
  noncomputable instance instHasExt_Sheaf_Opens_AddCommGrp (X : TopCat.{u}) :
      CategoryTheory.HasExt.{u+1}
        (CategoryTheory.Sheaf (Opens.grothendieckTopology X)
          AddCommGrpCat.{u}) := HasExt.standard _
  ```

### 3. `Scheme.toAbSheaf` (L54)
- **Line**: 54
- **Declaration**: `AlgebraicGeometry.Scheme.toAbSheaf`
- **Closure**: `(sheafCompose ...).obj C.sheaf`
- **Verified by probe**: `example (C : Scheme.{u}) : Sheaf (Opens.grothendieckTopology C.toTopCat) AddCommGrpCat.{u} := (sheafCompose (Opens.grothendieckTopology C.toTopCat) (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat)).obj C.sheaf` succeeds.
- The `HasSheafCompose` instance from `Cohomology/SheafCompose.lean` (iter-003) is picked up automatically.
- **Body**:
  ```lean
  noncomputable def toAbSheaf (C : Scheme.{u}) :
      CategoryTheory.Sheaf (Opens.grothendieckTopology C.toTopCat)
        AddCommGrpCat.{u} :=
    (sheafCompose (Opens.grothendieckTopology C.toTopCat)
      (forget₂ CommRingCat RingCat ⋙ forget₂ RingCat AddCommGrpCat)).obj C.sheaf
  ```

## Obstructions

None. All three closures matched the plan agent's expected closures exactly.

## Axiom declarations

None considered or added.

## Proposed `\leanok` markers

- `thm:HasSheafify_Opens_AddCommGrp` — `\leanok` (proof is `inferInstance`, no sorry)
- `thm:HasExt_Sheaf_Opens_AddCommGrp` — `\leanok` (proof is `HasExt.standard _`, no sorry)
- `def:Scheme_toAbSheaf` — `\leanok` (definition is closed, no sorry)
