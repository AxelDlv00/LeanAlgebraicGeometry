# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Outcome: PARTIAL — Step 1c LANDED inline (~40 LOC); Steps 2–4 deferred.

**Sorry count: 6 (unchanged); FILE COMPILES (`lean_diagnostic_messages` severity=error returns `[]`).**

Locations: L1120 (PAUSED), L1212, L1536, L1564, L1754, **L1846** (former L1802 `h_loc_exact`, shifted +44 by iter-109 inline Step 1c scaffolding).

## `h_loc_exact` at L1781 (sorry was L1802, now L1846)

### Step 1c — RESOLVED (closes "per-coord `IsLocalization.Away`" portion of the recipe)

Three inline `have`s landed at L1796–L1834 (preserving the iter-108 `h_V_le_U` + `h_slice_eq` Steps 1a+1b setup byte-for-byte at L1786–L1795):

1. **`h_pi_eq_inf'`** (L1799–L1812, 14 LOC): `∏ᶜ_a basicOpenCover ↑s₀ (x a) = (Finset.image x Finset.univ).inf' _ (basicOpenCover ↑s₀)`. Chain:
   - `∏ᶜ_a → ⨅ a` via `le_antisymm (le_iInf (Pi.π).le) (Pi.lift homOfLE).le`.
   - `⨅ a → Finset.univ.inf` via `Finset.inf_univ_eq_iInf`.
   - `Finset.univ.inf → Finset.univ.inf'` via `Finset.inf'_eq_inf`.
   - `Finset.univ.inf' (g ∘ x) → (Finset.image x univ).inf' g` via `Finset.inf'_image` (in reverse).

   This bridge unblocks the project's `basicOpenCover_finset_inf'_isAffineOpen` helper (which expects `Finset (↑s₀)`, not the cochain's native `Fin (n+1) → ↑s₀` indexing). The universe-mismatch on `CompleteLattice.finite_product_eq_finset_inf` (which requires `α, ι : Type u` same universe — `Fin (n+1) : Type 0` vs `Opens : Type u`) is sidestepped via `Pi.π`/`Pi.lift`-style `le_antisymm`.

2. **`h_V_affine`** (L1814–L1818, 5 LOC): `IsAffineOpen (∏ᶜ fun a => basicOpenCover ↑s₀ (x a))` via `h_pi_eq_inf' x ▸ basicOpenCover_finset_inf'_isAffineOpen hU ↑s₀ (Finset.image x Finset.univ) _`.

3. **`h_isLoc`** (L1822–L1834, 13 LOC): the per-coord `IsLocalization.Away ((presheafMap _).hom f.1) Γ(V_x ⊓ D(f.1))` via `(h_V_affine x).isLocalization_of_eq_basicOpen` + `h_slice_eq x`. Explicit `@`-form thread the algebra `((presheafMap inf_le_left).hom).toAlgebra` on the conclusion type (matching Mathlib's signature exactly, modeled on the project's `basicOpenCover_finset_inf'_isLocalization` at L330).

### Steps 2–4 — DEFERRED (per-x `IsScalarTower` + Pi-localization transport)

Trailing `sorry` at L1846 remains. Iter-109 prover ATTEMPTED Step 2 (algebra adapter via `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`) but hit a structural blocker:

**Step 2 attempts (lean_multi_attempt; not committed)**:

- **Attempt A: `letI` algebras + scTower in goal type**. Set up `alg1 : Algebra R Γ(V_x)`, `alg2 : Algebra Γ(V_x) Γ(V_x ⊓ D(f.1))`, `alg3 : Algebra R Γ(V_x ⊓ D(f.1))`, and `scTower : IsScalarTower` (via `IsScalarTower.of_algebraMap_eq` + `presheafMap_restrict_collapse`). The `letI` chain compiled as part of the goal type. **Blocker**: `letI` in the goal type does NOT propagate to the proof body's typeclass inference — the `infer_instance` fails to find the `Algebra` instances even though they appear in the type signature. Lean's `letI ... in <goal>` elaborates the `letI` immediately, so the body sees the goal without binders. Tried `intro alg1 alg2 alg3 scTower` — fails with "No additional binders to introduce".

- **Attempt B: explicit `@`-form on `IsLocalizedModule`**. Wrote the conclusion as `@IsLocalizedModule R _ (powers f.1) Γ(V_x) _ _ Γ(V_x ⊓ D(f.1)) _ <module-instance> <linear-map>`. **Blocker**: the explicit-argument order for `IsLocalizedModule` is brittle — argument 2 was misparsed as `Submonoid` instead of `CommSemiring R`, and `RingHom.toLinearMap` does not exist on bare `RingHom` (needs the algebra structure first). Would require ~60 more LOC of explicit-argument bookkeeping.

The clean path forward requires either:
- (i) Moving the algebra setup BEFORE the `have h_IsLocMod` so the instances are stable in the outer scope (but then they're not per-x; need to redefine V_x as a `set` block per x — but `set` inside a single `have` body doesn't easily express the per-x dependency).
- (ii) Building the per-x `IsLocalizedModule` as a term-mode construction via `IsLocalizedModule.mk` directly, avoiding the `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` instance entirely.
- (iii) Refactoring the architectural layer to make Steps 1c–4 a top-level helper lemma — explicitly disallowed iter-109 ("No new top-level helpers"), but the natural shape for iter-110+ if the C1 escape-valve fires.

### LOC counter

`h_loc_exact` body now spans L1783–L1846 = **64 LOC** (was L1783–L1802 = 20 LOC at iter-109 entry). Steps 1c additions = 40 LOC. Under the iter-107 strategy-critic soft cap of 150 LOC.

### Final `lean_diagnostic_messages` (severity=error)

```
{"result":{"success":true,"items":[],"failed_dependencies":[]}}
```

File compiles. No new axioms. No new top-level helpers. No new sorries (6 → 6).

## Recommendation for iter-110 plan agent

**This is the SECOND consecutive PARTIAL on L1846 (iter-108 PARTIAL on Steps 1a+1b; iter-109 PARTIAL closing Step 1c only).** Per the iter-107 strategy-critic exit criterion, the iter-110 plan should fire the **escape-valve menu** (per STRATEGY.md § "Phase A escape-valve menu"):

- **Option 1 (CHEAPEST, RECOMMENDED)**: defer L1846 as a named Mathlib-gap sorry. The structural blocker (Step 2 algebra-instance threading + Step 3 Pi-localization transport) is real and would take ~5–8 iters of dedicated work to close inline within the soft cap, OR ~150–250 LOC if architecturally refactored. Defer-as-gap preserves the iter-109 Step 1c progress as inert infrastructure (the per-coord `h_isLoc` is independent of L1846 closure and survives).
- **Option 2**: fire C1 promotion (LineBundle architectural refactor, 5–8 iters / 200–300 LOC). The USER_HINTS iter-107 "no approximation" framing favors this — but C1 is orthogonal to the L1846 obstruction, so firing C1 doesn't help L1846 specifically. Better as a parallel lane.
- **Option 3**: re-consult `mathlib-analogist` to design a "Step 2-only" closure pattern that avoids the `letI`-in-goal-type propagation issue. Concrete blocker is identified above (Attempts A+B); analogist should evaluate whether term-mode `IsLocalizedModule.mk` is feasible inline.

## Key Mathlib lemmas verified in scope (iter-109)

- ✓ `IsLocalizedModule.pi` (`Mathlib.RingTheory.TensorProduct.IsBaseChangePi`)
- ✓ `IsAffineOpen.isLocalization_of_eq_basicOpen` (`Mathlib.AlgebraicGeometry.AffineScheme`)
- ✓ `Function.Exact.iff_of_ladder_linearEquiv` (`Mathlib.Algebra.Exact`)
- ✓ `Function.Exact.of_ladder_linearEquiv_of_exact` (`Mathlib.Algebra.Exact`)
- ✓ `LinearEquiv.conj_exact_iff_exact` (`Mathlib.Algebra.Exact`) — fallback
- ✓ `IsLocalizedModule.iso` (`Mathlib.Algebra.Module.LocalizedModule.Basic`)
- ✓ `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` (`Mathlib.Algebra.Module.LocalizedModule.IsLocalization`)
- ✓ `Submonoid.map_powers` (`Mathlib.Algebra.Group.Submonoid.Membership`)
- ✓ `Algebra.algebraMapSubmonoid_powers` (`Mathlib.Algebra.Algebra.Basic`)
- ✓ `IsLocalizedModule.linearMap_ext` (`Mathlib.Algebra.Module.LocalizedModule.Basic`)
- ✓ `Finset.inf_univ_eq_iInf` (`Mathlib.Data.Fintype.Lattice`)
- ✓ `Finset.inf'_image` (`Mathlib.Data.Finset.Lattice.Fold`)
- ✓ `Finset.inf'_eq_inf` (`Mathlib.Data.Finset.Lattice.Fold`)
- ✓ `IsScalarTower.of_algebraMap_eq` (`Mathlib.Algebra.Algebra.Tower`)
- ✓ `RingHom.algebraMap_toAlgebra` (`Mathlib.Algebra.Algebra.Basic`)

## Dead ends from iter-109 attempts

- ❌ `rw [CompleteLattice.finite_product_eq_finset_inf]` direct application on `∏ᶜ` in `Opens` — fails due to universe mismatch (`Fin (n+1) : Type 0` vs `Opens : Type u`); workaround via `Pi.π`/`Pi.lift` `le_antisymm`.
- ❌ `letI ... in <type> := by intro` form for threading per-x algebras into the body — Lean elaborates `letI`-in-type eagerly, leaving no binders. The body sees the unfolded type and cannot recover the instances by `intro`.
- ❌ Explicit `@IsLocalizedModule R _ S M _ _ N _ <module> <linear>` form — argument order brittle; `RingHom.toLinearMap` doesn't exist; would need ~60 LOC of explicit bookkeeping.
