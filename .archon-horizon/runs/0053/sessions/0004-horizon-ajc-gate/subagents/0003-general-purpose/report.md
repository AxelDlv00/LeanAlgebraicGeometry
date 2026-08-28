Done. Everything compiles and is axiom-clean.

## Delivered

New file (the only file I touched, nothing committed):
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardP1Topology.lean`

Imports: `AlgebraicJacobian.RiemannRoch.Adelic.FinitenessP1` and `AlgebraicJacobian.Picard.RigidPushforward`. **No `sorry`.** Namespace `AlgebraicGeometry.Adelic`, `set_option autoImplicit false`, `universe u`, `variable (k : Type u) [Field k]`.

Declarations (all take `k` explicitly first):

```lean
theorem isIntegral_p1Chart (i : ULift.{u} (Fin 2))
    (h : IsDomain Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k i)) :
    IsIntegral (p1Chart k i).toScheme

theorem isOpenCover_p1Chart : IsOpenCover (p1Chart k)   -- TopologicalSpace.IsOpenCover

theorem isReduced_p1 (h₀ …⟨0⟩) (h₁ …⟨1⟩) :
    IsReduced (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)))

theorem irreducibleSpace_p1 (h₀) (h₁) (hne : p1Chart k ⟨0⟩ ⊓ p1Chart k ⟨1⟩ ≠ ⊥) :
    IrreducibleSpace (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)))

theorem isIntegral_p1_of_isDomain_charts
    (h₀ : IsDomain Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨0⟩))
    (h₁ : IsDomain Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨1⟩))
    (hne : p1Chart k ⟨0⟩ ⊓ p1Chart k ⟨1⟩ ≠ ⊥) :
    IsIntegral (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)))

theorem isIntegral_p1Over_left_of_isDomain_charts (h₀) (h₁) (hne) :
    IsIntegral ((p1Over k).left)
```

The `p1Over` version **is** a one-liner — `(p1Over k).left` is defeq to `ℙ(…)`, no `show`/`change` needed.

## Hypothesis spellings match the sibling file exactly

`RigidPushforwardP1ChartSections.lean` (other agent) produces `Adelic.instIsDomainP1ChartSectionsX` / `…Y` and `Adelic.p1Chart_inf_ne_bot` in precisely these forms, so the gate composition is
`isIntegral_p1Over_left_of_isDomain_charts k (instIsDomainP1ChartSectionsX k) (instIsDomainP1ChartSectionsY k) (p1Chart_inf_ne_bot k)`.

## Build

```
✔ [8587/8587] Built AlgebraicJacobian.Picard.RigidPushforwardP1Topology (1324s)
Build completed successfully (8587 jobs).
real 26m17s   EXIT=0
```
No errors, no warnings, no style-linter output. (The wall time is machine contention, not the file: load average was ~50 on 16 cores with swap fully exhausted; `lake` itself used 29 s of CPU. A first attempt was killed by a `timeout 1800`.)

`#print axioms` (via `lake env lean /tmp/ajc_axioms_p1topology.lean`) — all six declarations: `[propext, Classical.choice, Quot.sound]`.

## Where the suggested route needed adjusting

* **Step 2 has a direct criterion — the stalk dance is unnecessary.** `AlgebraicGeometry.IsReduced.of_openCover (𝒰 : X.OpenCover) [∀ i, IsReduced (𝒰.X i)] : IsReduced X` (mathlib `Properties.lean:132`), fed by `Scheme.openCoverOfIsOpenCover` (`Restrict.lean:179`), whose `.X i` is literally `U i`. Two friction points: the `∀ i, IsReduced (𝒰.X i)` instance must be supplied by an explicitly-typed `haveI` (plain `haveI := key` does not get picked up), and `fin_cases` on the `ULift (Fin 2)` index produces `{ down := (fun i ↦ i) ⟨0, _⟩ }`, which instance search will not unify with `⟨0⟩` — I route through an explicit `i = ⟨0⟩ ∨ i = ⟨1⟩` disjunction and `rw`.
* **Step 1 is cleanest via `IsIntegral.of_isIso`, not `isIntegral_of_isAffine_of_isDomain`.** `(isAffineOpen_p1Chart k i).isoSpec : ↑U ≅ Spec Γ(X, U)`, then `IsIntegral.of_isIso …isoSpec.inv` with the `instance {R} [IsDomain R] : IsIntegral (Spec R)`. No `topIso`/`Γ(U,⊤)` identification needed at all, and no `Nonempty` side condition.
* **Step 3 worked as sketched** and is ~30 lines; the sibling `P1Points.lean` chart-chasing argument was not needed. Key names: `isIrreducible_iff_irreducibleSpace`, `subset_closure_inter_of_isPreirreducible_of_isOpen` (this is the "nonempty open of an irreducible subspace is dense in it" lemma), `IsPreirreducible.open_subset`, `isIrreducible_iff_closure`, `irreducibleSpace_def`. Coercion friction was handled by `set X : Scheme.{u} := ℙ(…)` at the top of the proof, which makes `(p1Chart k ⟨0⟩ : Set X)` elaborate (without it, `(↑(p1Chart k ⟨0⟩) : Set _)` fails to find the `Opens → Set` coercion), and by `exact inferInstanceAs (IrreducibleSpace (p1Chart k ⟨0⟩).toScheme)` to cross from `↥(U.toScheme)` to `↥(↑U : Set X)` — these are `rfl`-equal (`Scheme.Opens.toScheme_carrier`) but instance search will not find it.
* `Nonempty` of a chart was never needed — `hne` is used only through `Opens.ne_bot_iff_nonempty`.

## Not done / notes

* The module is **not** rooted in `AlgebraicJacobian.lean` (you told me not to edit it), so it is invisible to the root build until someone adds it.
* The `RigidPushforward` import does not make the module more expensive than it already was: `FinitenessP1` already pulls the `Mathlib` umbrella transitively (via `Adelic/Cokernel.lean` and `Picard/SerreTwist.lean`), so there was no cheaper option and no cycle.
