# Analogy: symmetric-power functor on `ModuleCat R`

## Mode
api-alignment

## Slug
sympower-iter010

## Iteration
010

## Question
What is the Mathlib-aligned way to build
`ModuleCat.symmetricPower.functor : (i : ℕ) → ModuleCat R ⥤ ModuleCat R`
(blueprint `found:modulecat_sym_power`), mirroring the existing
`ModuleCat.exteriorPower.functor`? Does Mathlib already provide it (re-export), or only
the module / linear map (port the exterior pattern), or neither (gap-fill)?

## Project artifact(s)
- (proposed, not yet written) `MR4213770…/Foundations.lean` or a new file — a `Sym^i`
  functor on `ModuleCat R`, to be lifted later to `PresheafOfModules` / `X.Modules`.
- Mirrors the exterior chain already cited in `analogies/found-design.md`.

## Headline finding

**No symmetric-power FUNCTOR exists in Mathlib, and — unlike the exterior case — neither does
the underlying linear-algebra functorial action.** The gap is TWO layers deep, where exterior
power has both layers already present. The bare *type* `SymmetricPower R ι M` exists, but with
NO `map` on morphisms, NO universal property, NO functoriality lemmas (these are written
verbatim as "TODO" in the Mathlib file header).

### What EXISTS (verified, LSP)
- `SymmetricPower (R ι : Type u) [CommSemiring R] (M : Type v) [AddCommMonoid M] [Module R M]
  : Type (max u v)` — `Mathlib.LinearAlgebra.TensorPower.Symmetric` (52). Quotient of
  `⨂[R] (_:ι), M` (`PiTensorProduct`) by the permutation relation `SymmetricPower.Rel`.
- Notation `Sym[R] ι M` and `Sym[R]^n M := Sym[R] (Fin n) M` (57, 60).
- Instances: `AddCommMonoid` (deriving, 54), `AddCommGroup` (over `CommRing`+`AddCommGroup`, 64),
  `SymmetricPower.module : Module R (Sym[R] ι M)` (98).
- `SymmetricPower.mk : (⨂[R] _:ι, M) →ₗ[R] Sym[R] ι M` (108) — the quotient linear map.
- `SymmetricPower.tprod : MultilinearMap R (fun _:ι ↦ M) (Sym[R] ι M)` (115), `tprod_equiv`
  (permutation-invariance, 123), `span_tprod_eq_top` (137).
- Building block for the morphism map: `PiTensorProduct.map (f : Π i, sᵢ →ₗ tᵢ)` with
  `PiTensorProduct.map_id`, `map_comp`, `map_tprod` — `Mathlib.LinearAlgebra.PiTensorProduct.Basic`.

### What is MISSING (verified absent — `SymmetricPower` occurs in exactly ONE Mathlib file)
- `SymmetricPower.map (f : M →ₗ[R] N) : Sym[R] ι M →ₗ[R] Sym[R] ι N` — the functorial action.
  **Does not exist** (`Unknown constant SymmetricPower.map`).
- The universal property `symmetricMapLinearEquiv` (linear maps `Sym^n M →ₗ N` ≃ symmetric
  multilinear `Mⁿ → N`) — explicit TODO in the file header (28-29).
- Functoriality `map_id`, `map_comp` — absent (nothing to state them about).
- `Sym^0 M ≅ R` and `Sym^1 M ≅ M` (the analogues of `exteriorPower.iso₀/iso₁/natIso₀/natIso₁`)
  — absent.
- Any `ModuleCat.symmetricPower` namespace / functor — absent (loogle empty).

## Decisions identified

### Decision: does a re-exportable Sym functor exist?
- **Mathlib idiom**: `ModuleCat.exteriorPower.functor (R) (n) : ModuleCat.{v} R ⥤ ModuleCat.{max u v} R`
  — `Mathlib.Algebra.Category.ModuleCat.ExteriorPower` (104). Built as `obj M := M.exteriorPower n`,
  `map f := exteriorPower.map f n`, `@[simps]`, `noncomputable`.
- **Project path**: wants the symmetric twin.
- **Gap**: divergent-and-wrong if stubbed; **no Mathlib decl to alias**.
- **Verdict**: **NEEDS_MATHLIB_GAP_FILL**. There is nothing to re-export.

### Decision: which layer to build (linear-algebra `map` vs ModuleCat wrapper)
- **Mathlib idiom (exterior)**: the heavy lifting lives in `LinearAlgebra/ExteriorPower/Basic.lean`
  — `exteriorPower.map (f) := alternatingMapLinearEquiv ((ιMulti R n).compLinearMap f)` (258),
  `map_id` (291), `map_comp` (296), `map_apply_ιMulti` (271). The ModuleCat file is then a THIN
  wrapper (`ofHom`, `@[simps] functor`).
- **Project path / reality**: for Sym this LinearAlgebra layer does **not** exist and must be built
  first. The ModuleCat wrapper alone is insufficient.
- **Cost**: ~1 medium LinearAlgebra file (`SymmetricPower.map` + `map_id` + `map_comp` +
  `map_tprod`-style compat) + ~1 thin ModuleCat file. The first is the real work; it is feasible
  because `PiTensorProduct.map`/`map_id`/`map_comp`/`map_tprod` supply every needed step.
- **Verdict**: **NEEDS_MATHLIB_GAP_FILL**, build in two layers exactly mirroring the exterior split.

### Decision: universe handling (CRITICAL TRAP)
- **Mathlib idiom (exterior)**: indexed by `n : ℕ`; no universe coupling. Functor over general
  `R : Type u`, output `ModuleCat.{max u v} R`.
- **Sym reality**: `SymmetricPower (R ι : Type u)` forces **R and ι in the SAME universe `u`**.
  Therefore `Sym[R]^n M = Sym[R] (Fin n) M` typechecks **only when `R : Type 0`** (verified:
  `Fin n : Type 0` vs `R : Type u` → "type mismatch … expected Type u"). The exterior functor
  has no such restriction.
- **Fix (verified compiles)**: index by a Type-`u` copy — `SymmetricPower R (ULift.{u} (Fin n)) M`.
  Then R, ι : Type u and output is `Type (max u v)`, achieving exterior-parity over general `R`.
  Do NOT use the `Sym[R]^n` notation in the functor def (it pins `R : Type 0`).
- **Verdict**: **DIVERGE (forced)** — use `ULift.{u} (Fin n)` as the index, not `Fin n`, to keep
  `R : Type u` general; document this as the one shape difference from the exterior twin.

### Decision: ring generality / special cases
- `SymmetricPower` needs only `CommSemiring R` + `AddCommMonoid M` (MORE general than exterior's
  `CommRing`). For ModuleCat parity use `CommRing R` + `AddCommGroup M` (the provided
  `AddCommGroup` instance applies). No trap.
- Defined for **all** `i : ℕ` incl. 0,1 (`Fin 0`, `Fin 1`); no special-casing in the def or in
  the `map_id`/`map_comp` proofs (those descend from `PiTensorProduct.map_id`/`map_comp`
  uniformly). `Sym^0 ≅ R` / `Sym^1 ≅ M` are *optional* downstream conveniences, not prerequisites
  for the functor.

## Recommendation

Build it; there is nothing to re-export. Mirror the exterior **two-file split**:

**Layer 1 — linear algebra** (new project file, e.g. `…/SymmetricPower/Map.lean`, mirroring
`Mathlib/LinearAlgebra/ExteriorPower/Basic.lean`):

```
namespace SymmetricPower
variable {R : Type u} [CommSemiring R] {ι : Type u}
  {M N P : Type*} [AddCommMonoid M] [Module R M] [AddCommMonoid N] [Module R N] …

/-- functorial action; descend `mk ∘ PiTensorProduct.map (fun _ => f)` through the quotient. -/
noncomputable def map (f : M →ₗ[R] N) : Sym[R] ι M →ₗ[R] Sym[R] ι N := …
  -- well-defined: PiTensorProduct.map (fun _ => f) intertwines Rel (acts factorwise via
  -- map_tprod, commutes with permutation of identical factors); descend via AddCon.lift / mk.

@[simp] lemma map_tprod (f) (g : ι → M) : map f (⨂ₛ[R] i, g i) = ⨂ₛ[R] i, f (g i) := …
@[simp] theorem map_id : map (LinearMap.id : M →ₗ[R] M) = LinearMap.id := …   -- from PiTensorProduct.map_id + span_tprod_eq_top
theorem map_comp (f : M →ₗ[R] N) (g : N →ₗ[R] P) :
    map (g ∘ₗ f) = map g ∘ₗ map f := …                                       -- from PiTensorProduct.map_comp
end SymmetricPower
```

**Layer 2 — ModuleCat wrapper** (new project file mirroring
`Mathlib/Algebra/Category/ModuleCat/ExteriorPower.lean`):

```
namespace ModuleCat
variable {R : Type u} [CommRing R]
def symmetricPower (M : ModuleCat.{v} R) (n : ℕ) : ModuleCat.{max u v} R :=
  ModuleCat.of R (SymmetricPower R (ULift.{u} (Fin n)) M)         -- NOTE: ULift, not Fin n (universe trap)
namespace symmetricPower
noncomputable def map {M N : ModuleCat.{v} R} (f : M ⟶ N) (n : ℕ) :
    M.symmetricPower n ⟶ N.symmetricPower n := ofHom (SymmetricPower.map f.hom)
variable (R) in
@[simps] noncomputable def functor (n : ℕ) : ModuleCat.{v} R ⥤ ModuleCat.{max u v} R where
  obj M := M.symmetricPower n
  map f := map f n
  -- map_id / map_comp obligations: discharge via SymmetricPower.map_id / map_comp + ModuleCat.hom_ext
end symmetricPower
end ModuleCat
```

Follow the exterior naming verbatim (`ModuleCat.symmetricPower`, `.functor`, `.map`,
`functor_obj`/`functor_map` from `@[simps]`) for API parity, so the later
`PresheafOfModules` → `X.Modules` lift reuses the same idiom as the exterior chain. The one
intentional shape difference is the **`ULift.{u} (Fin n)` index** (forced by `SymmetricPower`'s
same-universe `R ι` constraint) — document it at the def site. The `Sym^0 ≅ R` / `Sym^1 ≅ M`
isos are a follow-up nicety, not part of this lane.
