# Iter-146 prover objectives (sidecar)

Single prover lane on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`,
scoped to the 3 blueprint-adequate sub-piece sorries
(per `lean-vs-blueprint-checker-chart-algebra-review145` + `blueprint-reviewer-iter146`).

## Sub-piece (α) — `algebra_isPushout_of_affine_product` @ `ChartAlgebra.lean:50`

Iter-145 placeholder: `theorem algebra_isPushout_of_affine_product : True := sorry`.

Real signature target (per blueprint `\lem:chart_algebra_isPushout_of_affine_product`):
the affine pullback `Spec R ×_k Spec S = Spec (R ⊗_k S)` is the
canonical `Algebra.IsPushout` square at the ring level. Concretely
(prover refines per blueprint):
```
variable {k R S : Type*} [CommRing k] [CommRing R] [CommRing S]
  [Algebra k R] [Algebra k S]
theorem algebra_isPushout_of_affine_product :
    Algebra.IsPushout k R S (R ⊗[k] S) := ...
```
(Universe and `Algebra` instance plumbing per the blueprint sketch;
prover may need to add `[Algebra k (R ⊗[k] S)]` or related instances.)

Closure path per blueprint 3-step Mathlib recipe:
1. `pullbackSpecIso` (Mathlib `AlgebraicGeometry.PullbackCarrier`):
   pullback in `Scheme` of two `Spec` maps over `Spec k` is `Spec` of
   the tensor product.
2. `isPullback_SpecMap_of_isPushout` (Mathlib `AlgebraicGeometry.Spec`):
   `Spec` sends ring-pushout squares to scheme-pullback squares.
3. `CommRingCat.isPushout_iff_isPushout`: equivalent characterisations
   of pushout in `CommRingCat` and `Algebra.IsPushout`.

Mathlib imports may need extension (currently
`Mathlib.RingTheory.IsTensorProduct` + `Mathlib.RingTheory.Kaehler.Basic`):
add `Mathlib.AlgebraicGeometry.PullbackCarrier` if needed for the
3-step recipe.

Estimate: ~80–150 LOC body. Smallest + foundational; planner
recommends prover attack this first.

## Sub-piece — `constants_integral_over_base_field` @ `ChartAlgebra.lean:77`

Iter-145 placeholder: `theorem constants_integral_over_base_field : True := sorry`.

Real signature target (per blueprint `\lem:constants_integral_over_base_field`):
in a smooth proper geometrically irreducible scheme `X` over a base
field `k`, the global sections `Γ(X, O_X)` are precisely the constants
`range (algebraMap k Γ(X, O_X))` (equivalently `Γ(X, O_X) ≅ k`).
Concretely (prover refines per blueprint):
```
variable {k : Type*} [Field k] (X : Scheme.{?})
  [X.Over (Spec (.of k))] [IsProper X.toOver.hom]
  [GeometricallyIrreducible X.toOver.hom]
  [SmoothOfRelativeDimension n X.toOver.hom]
theorem constants_integral_over_base_field :
    (algebraMap k Γ(X, ⊤)).range = ⊤ := ...
```
(Universe + `Over (Spec (.of k))` plumbing per blueprint; prover may
need a `noncomputable` qualifier.)

Closure path per blueprint 3-substep recipe:
1. Properness ⇒ `Γ(X, O_X)` is a finite `k`-vector-space (Mathlib
   `IsProper.finite_global_sections` or similar coherent-pushforward
   chain).
2. Smooth + geometrically irreducible ⇒ `Γ(X, O_X)` is an integral
   domain (smooth proper geom-irr → reduced + irreducible →
   `Γ` integral).
3. Finite integral domain over a field `k` is a finite field extension
   of `k`. Geometric irreducibility forces dim_k = 1 via base change
   to `k̄` (`Γ(X_{k̄}, O_{X_{k̄}}) = k̄`; if dim_k > 1 then
   `Γ(X_{k̄}, O_{X_{k̄}})` strictly contains `k̄`, contradicting
   geometric irreducibility).

Mathlib leverage: `IsProper`-namespace coherent-pushforward lemmas;
`IsBaseChange`-namespace flat-base-change-of-Γ; standard finite-field-
extension-of-integral-domain-of-field results.

Estimate: ~50–100 LOC body. Smallest standalone; planner recommends
prover attack this second.

## Sub-piece — `Scheme.Over.ext_of_diff_zero` @ `ChartAlgebra.lean:89`

Iter-145 placeholder: `theorem ext_of_diff_zero : True := sorry`.

Real signature target (per blueprint `\lem:Scheme_Over_ext_of_diff_zero`):
two morphisms `f, g : C ⟶ A` in `Over (Spec k)` with `df = dg` and
agreement on an open `U` are equal. Concretely (prover refines per
blueprint):
```
variable {k : Type*} [Field k] {C A : Over (Spec (.of k))}
  [SmoothOfRelativeDimension n C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
  [GrpObj A] [SmoothOfRelativeDimension m A.hom]
  [IsProper A.hom] [GeometricallyIrreducible A.hom]
theorem ext_of_diff_zero
    (f g : C ⟶ A)
    (hdf : -- df = dg as a derivation; precise formulation TBD by prover)
    (U : Opens C.left) (hU : Nonempty U)
    (heq : -- f and g agree on U)
    : f = g := ...
```
(The exact `df = dg` formulation is the prover's discretion; blueprint
prose says "df = dg as morphisms `Ω_{A/k} → Ω_{C/k}` pulled back along
f and g". The `eqOnOpen` packaging matches `Scheme.Over.ext_of_eqOnOpen`
shape.)

Closure path per blueprint 3-step recipe:
1. Reduce to a single difference morphism `h = μ ∘ ⟨f, ι ∘ g⟩` (where
   `μ` is the group multiplication on `A` and `ι` is the group
   inversion) with `dh = 0` using `KaehlerDifferential.D_sub`.
2. Apply `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
   (β-core sub-piece) chart-by-chart on `C` to conclude `h` factors
   through `Spec k` (i.e. `h` is the constant `1_A`). **Note: the
   β-core sub-piece is `sorry`-bodied as of iter-146; the prover may
   land a structural shell here that invokes the β-core helper as a
   `sorry`-bearing reference**, leaving the actual body closure
   pending iter-147+ β-core closure. This is acceptable iter-146 —
   the prover's primary job is signature refinement + structural
   shell + helper invocation.
3. Identify the constant value via Step 1's agreement on `U` (the
   difference morphism agrees with the constant `1_A` on `U`); invoke
   `\thm:GrpObj_eq_of_eqOnOpen` (project's iter-125 `ext_of_eqOnOpen`
   packaging in `AlgebraicJacobian/Rigidity.lean`) to conclude
   `h = 1_A` globally, hence `f = g`.

Mathlib leverage: `KaehlerDifferential.D_sub` (verified); project's
`Scheme.Over.ext_of_eqOnOpen` (post iter-125 refactor, k-agnostic).

Estimate: ~100–150 LOC body. Structural shell + β-core helper-sorry
acceptable iter-146; planner recommends prover attack this third.

## Order of attack (planner recommendation)

1. (α) `algebra_isPushout_of_affine_product` — foundational + smallest.
2. `constants_integral_over_base_field` — smallest standalone.
3. `Scheme.Over.ext_of_diff_zero` — structural shell; depends on
   β-core helper-sorry call.

The prover may re-order if it judges dependencies differently. Each
sub-piece's signature refinement is the primary success criterion for
iter-146; body closure secondary.

## Deferred sub-pieces (iter-147+ prover lane)

- (β-core) `df_zero_factors_through_constant_on_chart` @ L59 —
  load-bearing 5-step proof with 2-chart Čech / Mayer–Vietoris
  promotion. Iter-146 blueprint-writer-rigiditykbar-iter146 landed
  the Step 3 rewrite + Step 3.aux 2-chart cover existence paragraph;
  iter-147+ prover after iter-147 blueprint-reviewer green-light.
- (KDM ring-side) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  @ L69 — algebra-level core with characteristic case-split.
  Iter-146 writer landed the char-`p` (p1) 4-substep recipe + (p3)
  new helper extraction (`\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`);
  iter-147+ prover after iter-147 blueprint-reviewer green-light.

## HARD GATE rebuttal recap

The `blueprint-reviewer-iter146` HARD GATE FIRES on `RigidityKbar.tex`
at chapter-level (`complete: partial / correct: partial`). The 3
iter-146 in-scope sub-pieces (α + integral + lift) have CLEAN
first-class blocks per both `lean-vs-blueprint-checker-chart-algebra-review145`
(adequate) and `blueprint-reviewer-iter146` (no must-fix touches
them). The chapter-level partial rating is driven by findings on the
2 DEFERRED sub-pieces (β-core + KDM) plus 8 broken `\lean{...}` hints
to iter-145-EXCISED bundled-route declarations (none of which point
at `Cotangent/ChartAlgebra.lean`). The iter-146 blueprint-writer
absorbed all 11 must-fix items the same iter. Full rebuttal in
`iter/iter-146/plan.md` § "HARD GATE rebuttal".
