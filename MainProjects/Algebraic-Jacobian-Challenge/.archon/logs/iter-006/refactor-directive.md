<!-- Archived from REFACTOR_DIRECTIVE.md at 2026-05-07T03:03:51Z -->
<!-- This is the directive the plan agent wrote for the refactor agent in this iteration. -->

# Iter-006 refactor directive — `Scheme.toModuleKSheaf` (Phase A step 5 main)

## Problem

Phase A step 5 of `STRATEGY.md` requires equipping `H^1(C, O_C)` with a `Module k`-structure for `C : Over (Spec (CommRingCat.of k))`. The iter-005 prover round closed the **prerequisites** for this step (`HasSheafify`, `HasExt` on `Sheaf (Opens.gT X) (ModuleCat k)`); the **substantive content** — expressing `O_C` as a sheaf valued in `ModuleCat k` via the structure morphism — remains.

Without `Scheme.toModuleKSheaf`, the `genus` definition cannot be written honestly: `(Scheme.toAbSheaf C).H 1` is only an `AddCommGroup`, while `Module.finrank k _` requires a `Module k` structure. With `Scheme.toModuleKSheaf`, the chain `Scheme.toModuleKSheaf C` → `(_).H 1` → `CategoryTheory.Abelian.Ext.instModule` produces the desired `Module k` automatically (the `Linear k`-enrichment on `Sheaf (Opens.gT _) (ModuleCat k)` is auto-inferable in Mathlib).

## Mathematical justification

For `C : Over (Spec (CommRingCat.of k))`, the structure morphism `C.hom : C.left ⟶ Spec (CommRingCat.of k)` induces a `k`-algebra structure on each section `Γ(C.left, U)`: the chain
```
k ≃ Γ(Spec k, ⊤) → Γ(C.left, C.hom⁻¹ ⊤) → Γ(C.left, U)
```
(where the first iso is `Scheme.ΓSpecIso`, the middle map is `C.hom.app ⊤`, and the last is the restriction along `U ≤ ⊤`) is a ring homomorphism, hence makes each `Γ(C.left, U)` a `k`-algebra and a fortiori a `k`-module. The restriction maps `Γ(C.left, U) → Γ(C.left, V)` (for `V ≤ U`) are then `k`-linear by naturality.

This packages into a presheaf `(Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat k` whose underlying-set functor agrees on the nose with `C.left.presheaf ⋙ forget CommRingCat`. The sheaf condition transfers via `Presheaf.isSheaf_iff_isSheaf_forget` on both sides: the underlying-Type sheaf condition is exactly `C.left.sheaf.cond`.

The plan-agent live Mathlib probe (`lean_run_code`, iter-006) confirms an end-to-end ~80-LOC construction type-checks against Mathlib `b80f227`. The closure bodies are recorded in §"Closure bodies" below; deviations from these bodies should be flagged in `task_results/<file>.lean.md` and not silently substituted.

Blueprint reference: `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` Section "The structure sheaf of a $\Spec k$-scheme as a sheaf of $k$-modules" — already extended in this iter-006 plan-agent pass. The blueprint records the eight `\lean{...}` references that the refactor must resolve.

## Scope

**Extend** the existing file `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (do **not** create a new file). Append the following eight declarations *after* the iter-005 closures (currently lines 39 and 49 in the file). The iter-005 closures (`instHasSheafify_Opens_ModuleCatK`, `instHasExt_Sheaf_Opens_ModuleCatK`) must remain untouched.

The eight new declarations split between two namespace blocks:

- The first five (helpers `kToSection`, `algebraSection`, `algebraMap_eq_kToSection`, `kToSection_naturality`, `algebraMap_naturality`) sit inside `namespace AlgebraicGeometry.Scheme.toModuleKSheaf` — matching the iter-002 / iter-003 convention of placing helpers in a sub-namespace named after the main definition.
- The final three (`toModuleKPresheaf`, `toModuleKPresheaf_isSheaf`, `toModuleKSheaf`) sit inside `namespace AlgebraicGeometry.Scheme`. The bundled sheaf `toModuleKSheaf` therefore has fully qualified name `AlgebraicGeometry.Scheme.toModuleKSheaf` — the *same* path used by the helpers' sub-namespace, which Lean handles correctly (a definition and a namespace may share a name).

The refactor agent should add these as `:= sorry` bodies (signatures only, with type-correct return types). The iter-006 prover round will fill them.

## Imports / preamble

After the existing `import AlgebraicJacobian.Cohomology.StructureSheafAb`, add the following imports if they are not transitively pulled in already:
- `Mathlib.AlgebraicGeometry.Scheme` (for `Scheme.ΓSpecIso`, `Scheme.Hom.app`, `Scheme.presheaf`, `Scheme.sheaf`).
- `Mathlib.Algebra.Category.ModuleCat.Basic` (for `ModuleCat.of`, `ModuleCat.ofHom`, `ModuleCat.hom_ext`).
- `Mathlib.CategoryTheory.Sites.Sheaf` (for `Presheaf.isSheaf_iff_isSheaf_forget`).

If a single `import Mathlib` simplifies the imports list, that is acceptable (the plan-agent probe ran under `import Mathlib`).

## Eight scaffold declarations to add

Each declaration's signature is given below. The bodies are `sorry` *for the refactor agent*; the prover will fill them with the closure bodies recorded in §"Closure bodies" below. Note: the precise field-name conventions for `ModuleCat.ofHom`, `LinearMap`, etc. should follow Mathlib `b80f227`; if any minor naming mismatch arises, document and adapt as in the iter-005 refactor.

### (1) `Scheme.toModuleKSheaf.kToSection`

```lean
namespace AlgebraicGeometry.Scheme.toModuleKSheaf

variable {k : Type u} [CommRing k]

/-- Phase A step 5 main, helper (1): the ring map `k → Γ(C, U)` induced by the
structure morphism `C.hom : C.left ⟶ Spec (CommRingCat.of k)` and the
restriction along `U ≤ ⊤`. -/
noncomputable def kToSection (C : Over (Spec (CommRingCat.of k)))
    (U : (Opens C.left.toTopCat)ᵒᵖ) :
    (CommRingCat.of k) ⟶ C.left.presheaf.obj U :=
  sorry
```

### (2) `Scheme.toModuleKSheaf.algebraSection` instance

```lean
/-- Phase A step 5 main, helper (2): `Γ(C, U)` is a `k`-algebra via the ring
map of `kToSection`. -/
noncomputable instance algebraSection (C : Over (Spec (CommRingCat.of k)))
    (U : (Opens C.left.toTopCat)ᵒᵖ) :
    Algebra k (C.left.presheaf.obj U) :=
  sorry
```

### (3) `Scheme.toModuleKSheaf.algebraMap_eq_kToSection`

```lean
/-- Phase A step 5 main, helper (3): unfolding lemma for the algebra map. -/
lemma algebraMap_eq_kToSection (C : Over (Spec (CommRingCat.of k)))
    (U : (Opens C.left.toTopCat)ᵒᵖ) :
    (algebraMap k (C.left.presheaf.obj U)) = (kToSection C U).hom :=
  sorry
```

### (4) `Scheme.toModuleKSheaf.kToSection_naturality`

```lean
/-- Phase A step 5 main, helper (4): the structure-morphism algebra map is
natural in `U`. -/
lemma kToSection_naturality (C : Over (Spec (CommRingCat.of k)))
    {U V : (Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    kToSection C U ≫ C.left.presheaf.map f = kToSection C V :=
  sorry
```

### (5) `Scheme.toModuleKSheaf.algebraMap_naturality`

```lean
/-- Phase A step 5 main, helper (5): corollary of (4) at the level of
`algebraMap`. -/
lemma algebraMap_naturality (C : Over (Spec (CommRingCat.of k)))
    {U V : (Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) (r : k) :
    (C.left.presheaf.map f).hom (algebraMap k (C.left.presheaf.obj U) r)
      = algebraMap k (C.left.presheaf.obj V) r :=
  sorry

end AlgebraicGeometry.Scheme.toModuleKSheaf
```

### (6) `Scheme.toModuleKPresheaf`

```lean
namespace AlgebraicGeometry.Scheme

variable {k : Type u} [CommRing k]

/-- Phase A step 5 main, helper (6): the presheaf of `k`-modules built from
`O_C` and the structure-morphism algebra structure. -/
noncomputable def toModuleKPresheaf (C : Over (Spec (CommRingCat.of k))) :
    (Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k :=
  sorry
```

### (7) `Scheme.toModuleKPresheaf_isSheaf`

```lean
/-- Phase A step 5 main, helper (7): the presheaf of (6) is a sheaf for the
Grothendieck topology of opens of `C.left.toTopCat`. -/
lemma toModuleKPresheaf_isSheaf (C : Over (Spec (CommRingCat.of k))) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (toModuleKPresheaf C) :=
  sorry
```

### (8) `Scheme.toModuleKSheaf`

```lean
/-- Phase A step 5 main: the structure sheaf of a `Spec k`-scheme as a sheaf
of `k`-modules. Bundles `toModuleKPresheaf` (helper 6) and
`toModuleKPresheaf_isSheaf` (helper 7) into the standard `Sheaf` shape. -/
noncomputable def toModuleKSheaf (C : Over (Spec (CommRingCat.of k))) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  sorry

end AlgebraicGeometry.Scheme
```

## Closure bodies (for the iter-006 prover round, NOT for the refactor)

These are the probe-confirmed closure bodies the iter-006 prover will fill. Recorded here so the plan agent can verify the prover did not silently substitute a vacuous closure. **Do not** install them in the refactor — leave the eight scaffold sorries in place so the prover round has an explicit task.

```lean
-- (1) kToSection
(Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ C.hom.app ⊤ ≫
  C.left.presheaf.map (homOfLE le_top).op

-- (2) algebraSection
RingHom.toAlgebra (kToSection C U).hom

-- (3) algebraMap_eq_kToSection
rfl

-- (4) kToSection_naturality
by
  unfold kToSection
  simp only [Category.assoc]
  congr 1; congr 1
  rw [← C.left.presheaf.map_comp]; rfl

-- (5) algebraMap_naturality
by
  rw [algebraMap_eq_kToSection, algebraMap_eq_kToSection]
  exact congr_arg (fun (g : CommRingCat.of k ⟶ _) => g.hom r)
    (kToSection_naturality C f)

-- (6) toModuleKPresheaf
{ obj := fun U => ModuleCat.of k (C.left.presheaf.obj U)
  map := fun {U V} f => ModuleCat.ofHom
    { toFun := (C.left.presheaf.map f).hom
      map_add' := (C.left.presheaf.map f).hom.map_add
      map_smul' := by
        intros r x
        change (C.left.presheaf.map f).hom (r • x)
          = r • (C.left.presheaf.map f).hom x
        simp only [Algebra.smul_def, RingHom.map_mul]
        rw [toModuleKSheaf.algebraMap_naturality] }
  map_id := fun U => by
    apply ModuleCat.hom_ext; apply LinearMap.ext; intro x
    have h : C.left.presheaf.map (𝟙 U) = 𝟙 _ := C.left.presheaf.map_id U
    change (C.left.presheaf.map (𝟙 U)).hom x = x
    rw [h]; rfl
  map_comp := fun {U V W} f g => by
    apply ModuleCat.hom_ext; apply LinearMap.ext; intro x
    have h : C.left.presheaf.map (f ≫ g)
        = C.left.presheaf.map f ≫ C.left.presheaf.map g :=
      C.left.presheaf.map_comp f g
    change (C.left.presheaf.map (f ≫ g)).hom x =
      (C.left.presheaf.map g).hom ((C.left.presheaf.map f).hom x)
    rw [h]; rfl }

-- (7) toModuleKPresheaf_isSheaf
by
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _ (forget (ModuleCat.{u} k))]
  have hOC := C.left.sheaf.cond
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _ (forget CommRingCat.{u})] at hOC
  have heq : toModuleKPresheaf C ⋙ forget (ModuleCat.{u} k) =
      C.left.presheaf ⋙ forget CommRingCat.{u} := by
    apply CategoryTheory.Functor.ext
    · intros U V f; rfl
    · intro U; rfl
  rw [heq]; exact hOC

-- (8) toModuleKSheaf
⟨toModuleKPresheaf C, toModuleKPresheaf_isSheaf C⟩
```

## What must NOT change

- `archon-protected.yaml` — unchanged.
- `Cohomology/StructureSheafModuleK.lean` lines 39 and 49 (the iter-005 closures) — unchanged.
- All other `.lean` files (`Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean`, `Picard/Functor.lean`, `Picard/FunctorAb.lean`, `Picard/LineBundle.lean`, `Cohomology/SheafCompose.lean`, `Cohomology/StructureSheafAb.lean`, `Rigidity.lean`, `AlgebraicJacobian.lean`) — unchanged.
- Blueprint chapter `Cohomology_StructureSheafModuleK.tex` — already updated by the plan agent in this iter-006 pass; the refactor agent should not modify it.
- All other blueprint chapters — unchanged.

## Forbidden substitutions in the refactor

- Replacing the structure-morphism-derived algebra map with the trivial `k → Γ(C, U)` (e.g.\ a constant or `algebraMap k k`) — would falsify `genus`.
- Defining `algebraSection` as `Algebra.id k` — false on every non-zero `Γ(C, U)`.
- Replacing `toModuleKPresheaf` with the constant `PUnit`-valued presheaf — destroys the downstream cohomology chain.
- Returning a vacuous `toModuleKSheaf` (e.g.\ `⟨_ , Presheaf.isSheaf_top _⟩` with the wrong presheaf) — same.

The eight scaffold sorries must have the type signatures recorded above. If a Mathlib `b80f227` rename forces a small adjustment (analogous to the iter-005 `forget AddCommGrpCat.{u}` qualification), document it in `task_results/refactor.md`.

## Expected outcome

- File `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` extended from 56 to ~150 LOC, containing the iter-005 closures plus the eight new scaffold sorries.
- Sorry count: 10 → 18 (10 baseline + 8 new scaffolds).
- No new `axiom` declarations; `archon-protected.yaml` unchanged.
- File compiles end-to-end (each sorry is locally type-correct given its signature; no cascading errors).
- `leanblueprint checkdecls` passes (the eight new `\lean{...}` references in the chapter all resolve to the new scaffold declarations).

The plan agent will be re-invoked after the refactor to verify the result and dispatch the iter-006 prover round.
