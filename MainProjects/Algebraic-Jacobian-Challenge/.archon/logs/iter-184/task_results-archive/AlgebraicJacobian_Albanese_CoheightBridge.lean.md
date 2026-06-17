# AlgebraicJacobian/Albanese/CoheightBridge.lean

**Status:** ✅ **BEST-CASE outcome achieved** — all 4 declarations
**axiom-clean (Tier 1)** kernel-only (`propext`, `Classical.choice`,
`Quot.sound`). Zero project sorries. Build green file-locally and
project-wide.

## File-creation context (Lane M, NEW FILE iter-183)

- File did not exist entering iter-183. Created from scratch per
  blueprint chapter `Albanese_CoheightBridge.tex` (landed iter-183
  plan-phase via `blueprint-writer coheightbridge-skeleton`).
- Added `import AlgebraicJacobian.Albanese.CoheightBridge` to root
  `AlgebraicJacobian.lean`.
- Total file LOC: ~225 (target was 60–100, came in slightly higher
  due to explicit `@`-syntax pinning of `specializationPreorder` and
  the manual scheme-iso → topological-iso → order-iso construction in
  Decl 3; see "Design choices" below).

## Per-declaration outcomes

### `Order.coheight_eq_of_isOpenEmbedding` (L52) — Tier 1 axiom-clean

**Approach:** Pre-scaffold check via `lean_loogle "Order.coheight,
IsOpen"` per plan directive returned empty (lemma genuinely absent from
Mathlib). Proceeded with scaffold.

**Proof structure (~50 LOC):**
- `letI : Preorder X := specializationPreorder X` and same for `↥U` to
  pin the spec preorder *inside* the proof body (the statement uses
  `@Order.coheight … (specializationPreorder …)` explicitly to be
  unambiguous in the conclusion type).
- Strict-monotonicity of `Subtype.val : ↥U → X` proven directly:
  monotonicity via `Continuous.specialization_monotone`; the strict
  half via `subtype_specializes_iff` to convert `b.val ⤳ a.val (in X)`
  ↔ `b ⤳ a (in ↥U)`.
- Forward bound: `coheight_le_coheight_apply_of_strictMono`.
- Reverse bound: build LTSeries in `↥U` from one in `X` via
  `Specializes.mem_open` (every element of a chain starting at `z ∈ U`
  is itself in `U` because the spec preorder relation `z ≤ p i` is
  exactly `p i ⤳ z`, and `U` open + `z ∈ U` ⟹ `p i ∈ U`).
- Closure: `length_le_coheight` on the constructed series.

### `Order.coheight_spec_eq_height_primeSpectrum` (L110) — Tier 1 axiom-clean

**Approach:** Construct `Spec R ≃o (PrimeSpectrum R)ᵒᵈ` from
`AlgebraicGeometry.AffineSpace.spec_le_iff`, then transport coheight
via `coheight_orderIso`. Final step `rfl` because
`coheight (OrderDual.toDual x) = height x` is definitional (the
`coheight_toDual` simp lemma is itself `rfl`).

**Proof structure (~25 LOC):** `{ toFun := …; map_rel_iff' := …}`-style
order-iso definition, then 2-line transport.

### `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` (L143) — Tier 1 axiom-clean

**Approach:** 5-step assembly per blueprint:
1. Pick affine open `U ∋ z` via `exists_isAffineOpen_mem_and_subset`.
2. Name prime `p := hU.primeIdealOf ⟨z, hzU⟩`.
3. Bind `Algebra Γ(X,U) (X.presheaf.stalk z)` via
   `TopCat.Presheaf.algebra_section_stalk` (had to bind explicitly via
   `letI`; the auto-instance synthesis failed for
   `IsLocalization.AtPrime.ringKrullDim_eq_height`'s `[Algebra R A]`
   argument until this was bound).
4. `ringKrullDim stalk = p.asIdeal.height = Order.height p` via
   `IsLocalization.AtPrime.ringKrullDim_eq_height` +
   `Ideal.height_eq_primeHeight`. Final step `rfl` for
   `Ideal.primeHeight p.asIdeal = Order.height ⟨p.asIdeal, p.isPrime⟩`
   (definitional unfold).
5. Lift `Order.height p (in PrimeSpectrum)` back to `Order.coheight z
   (in X)` via:
   - `Order.coheight_spec_eq_height_primeSpectrum` (Decl 2).
   - `Order.coheight_orderIso` on the scheme-iso-induced
     `U.toScheme ≃o Spec Γ(X,U)` order iso, built from
     `hU.isoSpec` → `TopCat.homeoOfIso` → manual order-iso
     construction (homeomorphisms preserve `⤳`).
   - `Order.coheight_eq_of_isOpenEmbedding` (Decl 1) on the open
     embedding `U.1 ↪ X`.

**Proof structure (~70 LOC, the bulk of the file):** straightforward
chain of rewrites once the order-iso `eOrder : U.toScheme ≃o Spec
Γ(X,U)` is constructed.

### `AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one` (L218) — Tier 1 axiom-clean

**Approach:** 1-line via `Ring.krullDimLE_iff` →
`ringKrullDim_stalk_eq_coheight` → `hz` → `norm_cast`. ~5 LOC.

## Design choices

### `@Order.coheight … (specializationPreorder …)` pinning in Decl 1

The signature uses explicit `@` syntax to pin the `Preorder` instance
on both sides to `specializationPreorder`. This was necessary because:

- `Order.coheight` requires `[Preorder α]`. Bare `[TopologicalSpace X]`
  does not auto-derive `[Preorder X]` (`specializationPreorder` is
  marked `@[instance_reducible]` but is not a true typeclass instance).
- Adding `letI : Preorder X := specializationPreorder X` in the proof
  *body* works but does not change the *statement* type.
- The Subtype side has an additional complication: `Subtype.preorder`
  is a global instance that derives `Preorder ↥U` whenever `Preorder X`
  is available. This conflicts with `specializationPreorder ↥U` (the
  spec preorder on the subspace topology). Verified that `letI` for
  `Preorder ↥U` overrides `Subtype.preorder` for instance synthesis
  inside the proof body, but the conflict re-emerges if instances are
  inferred at the statement level. Hence the explicit `@` pinning.

### Consumer-facing call pattern in Decl 3

When Decl 3 calls Decl 1, the result has type
`@coheight X (specializationPreorder X) z = @coheight U.1
(specializationPreorder U.1) ⟨z, hzU⟩`. For `X : Scheme`,
`Scheme.instPreorder X = specializationPreorder X` (definitionally,
per `Mathlib/AlgebraicGeometry/Scheme.lean:158`), so the LHS is
definitionally equal to `Order.coheight z`. For `U.toScheme`, the
preorder is also `specializationPreorder` definitionally. Hence the
`have h1 : Order.coheight (α := X) z = Order.coheight (α := U.toScheme)
⟨z, hzU⟩ := h1'` line type-checks as a direct cast.

### Algebra synthesis fix in Decl 3

`IsLocalization.AtPrime.ringKrullDim_eq_height` requires `[Algebra R
A]`. For `R = Γ(X,U)` and `A = X.presheaf.stalk z`, Lean did not
auto-synthesize the algebra instance even though
`TopCat.Presheaf.algebra_section_stalk` is registered as an instance.
Adding an explicit `letI := …` line before the rewrite fixed this.

## Search hits

- `Specializes.mem_open` (Mathlib.Topology.Inseparable:96) — verified.
- `subtype_specializes_iff` (Mathlib.Topology.Inseparable:173) — verified.
- `Continuous.specialization_monotone` (Mathlib.Topology.Inseparable:230) — verified.
- `coheight_orderIso` (Mathlib.Order.KrullDimension:335) — verified.
- `coheight_toDual` (Mathlib.Order.KrullDimension:116) — verified, `rfl`.
- `coheight_le_iff'`, `length_le_coheight`,
  `coheight_le_coheight_apply_of_strictMono`
  (Mathlib.Order.KrullDimension) — all verified.
- `exists_isAffineOpen_mem_and_subset`
  (Mathlib.AlgebraicGeometry.AffineScheme:271) — verified.
- `IsAffineOpen.primeIdealOf` + `IsAffineOpen.isLocalization_stalk`
  (Mathlib.AlgebraicGeometry.AffineScheme:751, 806) — verified.
- `IsLocalization.AtPrime.ringKrullDim_eq_height`
  (Mathlib.RingTheory.Ideal.Height:341) — verified.
- `Ideal.height_eq_primeHeight` (Mathlib.RingTheory.Ideal.Height:45) — verified.
- `AlgebraicGeometry.AffineSpace.spec_le_iff`
  (Mathlib.AlgebraicGeometry.AffineSpace:438) — verified (note nested
  namespace — initial attempt with `AlgebraicGeometry.spec_le_iff`
  failed).
- `TopCat.Presheaf.algebra_section_stalk`
  (Mathlib.Topology.Sheaves.CommRingCat:275) — verified.

## Blueprint marker readiness

All four declarations are formalized with zero `sorry` and zero new
axioms; the blueprint chapter `Albanese_CoheightBridge.tex` is ready
for `\leanok` on:

- `lem:coheight_eq_of_isOpenEmbedding` (both statement and proof).
- `lem:coheight_spec_eq_height_primeSpectrum` (both).
- `thm:ringKrullDim_stalk_eq_coheight` (both).
- `lem:ringKrullDimLE_of_coheight_eq_one` (both).

(The deterministic `sync_leanok` phase between prover and review
should add these markers automatically.)

## Sorry projection impact

Entering this lane the file did not exist (sorry count contribution
= 0). Exiting with 4 axiom-clean declarations, **net sorry change =
0** for this file but the file delivers 4 new closed lemmas usable
by downstream consumers.

The downstream `hreg_dim` refactor in `CodimOneExtension.lean`
becomes a 1-iter follow-up (per blueprint §coheight_consumers): the
internal conjunction halves, with `ringKrullDim` discharged by Decl 4
and `IsRegularLocalRing` remaining as the named Stacks-00TT gap.
Similarly the `Scheme.RationalMap.order` argument hygiene in
`WeilDivisor.lean` becomes available.

## Lemmas discovered / API pointers for next iter

1. **`Algebra R A` instance synthesis sometimes fails for
   `IsLocalization.AtPrime`** despite a registered instance — explicit
   `letI` is needed. Recorded for future stalk-localization work.
2. **`AlgebraicGeometry.AffineSpace.spec_le_iff`** is in a nested
   namespace (`AffineSpace` inside `AlgebraicGeometry`). Easy
   namespace miss; the file's section markers (`section instances` at
   L362) suggest a flatter export would help.
3. **The `Subtype.preorder` vs `specializationPreorder` conflict**
   for subtypes of topological spaces is a genuine source of
   typeclass-search friction. Workaround: `letI` overrides
   `Subtype.preorder` for instance synthesis inside the proof body,
   but the statement type still needs explicit `@` pinning.

## Dead ends / negative results

- Initial attempt used `Monotone.strictMono_of_injective` to derive
  the StrictMono of `Subtype.val`. **Failed** because that lemma
  requires `[PartialOrder α]` (source), and `specializationPreorder`
  is only a `Preorder`. Falling through to the underlying
  `Subtype.preorder` (the natural-inclusion subtype preorder) gave
  the wrong order structure. Fix: prove `StrictMono` manually using
  `Monotone f` + irreflexivity via `subtype_specializes_iff`.
- Initial Decl 2 attempted `Order.coheight_toDual _` without
  arguments and got a type mismatch because Lean inferred the wrong
  Preorder instance on `PrimeSpectrum R`. Fix: rely on the
  definitional equality `coheight (toDual x) = height x` and close
  via `rfl` directly.

## Build verification

```
lake build AlgebraicJacobian.Albanese.CoheightBridge
→ ✔ [8317/8317] Built AlgebraicJacobian.Albanese.CoheightBridge (4.5s)

lake build AlgebraicJacobian
→ ✔ [8355/8356] Built AlgebraicJacobian (3.1s)
→ Build completed successfully (8356 jobs).
```

All four `lean_verify` calls show `axioms: ["propext", "Classical.choice",
"Quot.sound"]` and zero warnings.
