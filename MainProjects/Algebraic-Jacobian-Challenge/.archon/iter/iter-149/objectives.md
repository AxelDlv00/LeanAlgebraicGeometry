# Iter-149 prover objectives — detailed dispatch sheet

Two parallel lanes. The Archon loop dispatcher fans out one prover per
file from `PROGRESS.md` `## Current Objectives` in import order
(ChartAlgebraS3.lean → ChartAlgebra.lean since the latter will import
the former).

## Lane 1 — `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` (NEW FILE)

### File-skeleton + closures

Create the new file with the following structure:

```lean
import AlgebraicJacobian.Cotangent.ChartAlgebra  -- (or selective Mathlib imports if cyclic)
-- plus the relevant Mathlib namespaces:
--   Mathlib.AlgebraicGeometry.Properties (Smooth, IsProper, GeometricallyIrreducible)
--   Mathlib.RingTheory.Nilpotent.GeometricallyReduced (Algebra.IsGeometricallyReduced)
--   Mathlib.FieldTheory.PurelyInseparable.Basic (IsPurelyInseparable)
--   Mathlib.FieldTheory.IsAlgClosed.Basic (AlgebraicClosure)
--   Mathlib.AlgebraicGeometry.AffineSpace (for Spec-Γ adjunction)
```

**WARNING about import cycle**: `Cotangent/ChartAlgebra.lean` imports
`AlgebraicJacobian.Rigidity` already (for `ext_of_eqOnOpen`). If
`Cotangent/ChartAlgebraS3.lean` imports `ChartAlgebra.lean` and is
itself imported by `ChartAlgebra.lean`, there is a cycle. Resolution
options (the prover picks the cleanest):

- **Option A** (recommended): make `ChartAlgebraS3.lean` an UPSTREAM
  file that `ChartAlgebra.lean` imports. The (S3.*) lemmas don't
  depend on the chart-algebra (α)/(β-core)/(lift) declarations; they
  are standalone scheme/algebra results.
- **Option B**: keep `ChartAlgebraS3.lean` DOWNSTREAM of
  `ChartAlgebra.lean` and don't have `ChartAlgebra.lean` consume the
  (S3.*) lemmas via the new file — instead, redefine them locally
  in `ChartAlgebra.lean`'s body where consumed. (NOT recommended;
  loses the first-class-declaration discipline.)

Add the new file to `AlgebraicJacobian.lean` umbrella in import
order before `Cotangent.ChartAlgebra`.

### Declaration scaffolds

Each declaration's signature is mandated by `RigidityKbar.tex` §
"Chart-algebra piece (ii) first-class decomposition" (post iter-149
writer expansion). The prover may adjust the namespace if Mathlib
convention dictates.

**1. `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`** (S3.sep.1)

```lean
/-- (S3.sep.1) For a smooth proper scheme `X` over a field `k`, the
global sections `Γ(X, O_X)` form a geometrically reduced `k`-algebra.

Blueprint: `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` in
`RigidityKbar.tex`. Stacks Tags 0334 + 04QM (smooth fibers reduced). -/
theorem isGeometricallyReduced_Gamma_of_smooth
    {k : Type u} [Field k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))] :
    Algebra.IsGeometricallyReduced k ↥(X.presheaf.obj (Opposite.op ⊤)) := by
  sorry
```

Proof recipe (per blueprint):
- Smoothness of `X / Spec k` ⇒ for any field extension `K/k`, `X_K` is
  reduced (Stacks Tag 0334; Mathlib's `IsReduced` instance via base
  change of smooth schemes).
- `Γ(X_K, O_{X_K})` injects into reduced local rings ⇒ is reduced.
- Use (S3.pi.1) flat-base-change identification
  `Γ(X_K, O_{X_K}) ≅ Γ(X, O_X) ⊗_k K` to translate "`Γ(X_K)` reduced
  for every `K`" into "`Γ(X) ⊗_k K` reduced for every `K`" = the
  definition of `Algebra.IsGeometricallyReduced k Γ(X)`.

If Mathlib already has `Smooth ⇒ IsGeometricallyReduced` for the
scheme-side `Γ` (verify via `lean_leansearch` "smooth implies
geometrically reduced global sections"), this lemma may be a thin
wrapper. Otherwise it's a project bridge consuming (S3.pi.1).

Estimate: ~80–150 LOC. **Priority HIGH.**

---

**2. `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`** (S3.sep.2)

```lean
/-- (S3.sep.2) A geometrically reduced finite field extension is
separable.

Blueprint: `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable`.
Stacks Tag 0BJF. -/
theorem Algebra.IsSeparable.of_isGeometricallyReduced_of_finite
    {k F : Type u} [Field k] [Field F] [Algebra k F]
    [Algebra.IsGeometricallyReduced k F] [FiniteDimensional k F] :
    Algebra.IsSeparable k F := by
  sorry
```

Proof recipe: `F ⊗_k \bar k` reduced + finite-dim ⇒ Artinian product
of fields; dimension count `dim_{\bar k} (F ⊗_k \bar k) = [F : k]`;
the number of distinct `k`-embeddings `F ↪ \bar k` equals `[F : k]`
exactly when `F / k` is separable.

If Mathlib already proves this in the `IsSeparable` family (verify
via `lean_leansearch` "geometrically reduced separable"), the lemma
is a one-liner.

Estimate: ~30–50 LOC.

---

**3. `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`** (S3.pi.1)

```lean
/-- (S3.pi.1) For a proper scheme `X` over a field `k` and a field
extension `K/k`, the canonical map
`Γ(X, O_X) ⊗_k K → Γ(X_K, O_{X_K})` is an isomorphism.

Blueprint: `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`.
Stacks Tag 02KH (specialised to H^0). -/
theorem Gamma_baseChange_iso_tensor_of_proper
    {k K : Type u} [Field k] [Field K] [Algebra k K]
    {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))] :
    -- the canonical map / iso (prover picks the natural Mathlib idiom)
    sorry := by
  sorry
```

This is the DEEP one. The prover may legitimately PARTIAL with a
structured `sorry` documenting the closure path:
- Cover `X` by finitely many affines `U_i = Spec A_i` (quasi-compactness
  from properness).
- Čech complex computes `Γ(X) = eq(∏_i A_i ⇒ ∏_{i,j} A_{ij})`.
- Tensor with `K` over `k` preserves the equalizer (flatness of `K/k`).
- For affines: `(A ⊗_k K) ≅ Γ(U_K, O_{U_K})` (Stacks Tag 00DS; verified
  in Mathlib via `pullbackSpecIso` / `Spec_baseChange` family).
- Reassemble.

Estimate: ~150–250 LOC. **Priority MEDIUM.** PARTIAL acceptable —
this sub-claim's residual `sorry` then propagates upward to substep 3
of `constants_integral_over_base_field` (Lane 2 below), but the build
still compiles.

---

**4. `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`** (S3.pi.2)

```lean
/-- (S3.pi.2) A finite-dimensional field extension `F / k` is purely
inseparable when `F ⊗_k \bar k` has a unique minimal prime.

Blueprint: `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`.
Stacks Tag 05DH. -/
theorem Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange
    {k F : Type u} [Field k] [Field F] [Algebra k F]
    [FiniteDimensional k F]
    (hUnique : ∀ p q : Ideal (TensorProduct k F (AlgebraicClosure k)),
        p.IsPrime → q.IsPrime → p ≤ q → p = q ∨ q = ⊤) :
    -- the prover may pick the natural Mathlib idiom for "unique minimal
    -- prime"; the body works through the prime-ideal lattice
    IsPurelyInseparable k F := by
  sorry
```

Proof recipe: `F ⊗_k \bar k` is a finite-dim `\bar k`-algebra.
Quotient by nilradical: a domain finite over `\bar k`, hence a field
(Artinian + integral domain). Field finite over algebraically closed
`\bar k` is `\bar k` itself. So `(F ⊗_k \bar k) / Nil ≅ \bar k`,
and `[F : k]` is the rank, with all geometric points collapsed. By
Stacks Tag 05DH, `F / k` is purely inseparable.

Estimate: ~50–100 LOC.

---

### Lane 1 attack order

1. (S3.sep.1) — highest priority (cleanest single closure per
   iter-148 review's REC-1; verify Mathlib alignment first).
2. (S3.sep.2) — short; assemblable via `IsSeparable` infra.
3. (S3.pi.2) — medium; assemblable via `IsPurelyInseparable.of_*`
   family after (S3.pi.1) is in place (as `sorry` or as proven).
4. (S3.pi.1) — heaviest; PARTIAL is acceptable. May ship as a
   structured `sorry` with the Čech-equaliser + flat-tensor-exchange
   chain documented in-source as comments.

### Lane 1 scope envelope

Aggregate: ~200–400 LOC (4 declarations + 2–3 bodies closed).

---

## Lane 2 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

### Two sorries to close

#### L168 — KDM forward inclusion (p2) bridge body

**Signature inflation permitted** (per iter-148 review's REC-2): add
`[CharZero k]` and `[Algebra.IsStandardSmoothOfRelativeDimension k B n]`
hypotheses. The β-core consumer
`df_zero_factors_through_constant_on_chart` inflates correspondingly
(verified safe iter-148 review).

The (BR.1)–(BR.5) sub-step chain is now spelled out in blueprint
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` § "Primary
path (p2)" post iter-149 writer expansion:

- **(BR.1)** Signature edit. (above)
- **(BR.2)** Basis selection via
  `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified in
  Mathlib snapshot b80f227,
  `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`].
- **(BR.3)** Coefficient-derivation extraction `∂_i : B → B` from the
  basis. Project material; suggested target name
  `KaehlerDifferential.coordinateDeriv`. ~30–50 LOC.
- **(BR.4)** `Differential B` instance per `∂_i` (the `∂_i` is
  `k`-linear hence `ℤ`-linear). ~10–20 LOC. Suggested target name
  `KaehlerDifferential.coordinateDerivDifferentialInstance`.
- **(BR.5)** `Differential.ContainConstants` instance for the chosen
  `∂_i` in `CharZero k` + standard-smooth. ~40–80 LOC. Mathlib has
  the class definition (`Mathlib.RingTheory.Derivation.DifferentialRing`)
  but no instance for this case. Suggested target name
  `KaehlerDifferential.coordinateDeriv_containConstants_of_charZero`.

Aggregate (BR.3)–(BR.5) build: ~80–150 LOC. Plus the orchestrating
proof body (each (BR.*) sub-step may be a `local lemma` inside the
proof body or a sibling helper in the file; the prover picks the
ergonomic form).

#### L367 — constants substep 3 conjunction sorry

Replace the consolidated `have ⟨hPI, hSep⟩ : IsPurelyInseparable
k Γ ∧ Algebra.IsSeparable k Γ := by sorry` with a proof that consumes
the four (S3.*) lemmas from Lane 1's `ChartAlgebraS3.lean`. The
smart-proof reduction skeleton above the consolidated sorry stays
intact; only the sorry is rewritten.

Recipe:
- (S3.sep.1) gives `Algebra.IsGeometricallyReduced k Γ`.
- (S3.sep.2) gives `Algebra.IsSeparable k Γ` from (S3.sep.1) +
  `FiniteDimensional k Γ` (which is supplied by the iter-146
  `_hAppTopFinite` hypothesis).
- (S3.pi.1) gives `Γ_{\bar k} ≅ Γ ⊗_k \bar k`.
- Use `GeometricallyIrreducible (X ↘ Spec k)` ⇒ X_{\bar k} irreducible
  + reducedness ⇒ `Γ(X_{\bar k}, ⊤)` a domain ⇒ unique min prime in
  `Γ ⊗_k \bar k` (via the (S3.pi.1) iso).
- (S3.pi.2) gives `IsPurelyInseparable k Γ` from the unique-min-prime
  hypothesis + `FiniteDimensional k Γ`.

Estimate: ~30–80 LOC.

#### Lane 2 attack order

1. KDM (p2) bridge body — close (BR.3) coefficient-derivation
   extraction first, then (BR.4) Differential instance, then (BR.5)
   ContainConstants instance; finally orchestrate them into the KDM
   forward-inclusion proof body.
2. Substep 3 conjunction sorry rewrite — mechanical once Lane 1
   signatures land. If Lane 1 PARTIAL's on (S3.pi.1), the resulting
   substep 3 proof body still compiles (sorry propagation via
   imports is acceptable).

### Lane 2 scope envelope

Aggregate: ~130–280 LOC.

---

## Aggregate scope: 330–680 LOC across two parallel files

The user-hint commitment to "several hundred LOC of proof script" is
matched even at the lower bound (330 LOC); at the upper bound (680
LOC) iter-149 would land more than the project's iter-146 + iter-147
+ iter-148 prover-lane LOCs combined (134+117+77 = 328).

PARTIAL outcomes are acceptable on:
- (S3.pi.1) of Lane 1 (deep; documented closure path is the
  next-iter target).
- KDM (p2) bridge body of Lane 2 (the (BR.3)-(BR.5) chain depends
  on Mathlib instance synthesis for `Differential.ContainConstants`
  that may need careful staging).

INCOMPLETE outcomes on:
- (S3.sep.1) or (S3.sep.2) — escalate to iter-150 STUCK verdict.
- Constants substep 3 conjunction sorry rewrite — only if Lane 1
  fails to scaffold any (S3.*) declaration.
