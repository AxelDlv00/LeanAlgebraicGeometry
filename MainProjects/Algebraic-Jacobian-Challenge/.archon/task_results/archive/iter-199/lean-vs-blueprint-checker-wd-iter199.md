# Lean ↔ Blueprint Check Report

## Slug
wd-iter199

## Iteration
199

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: def:prime_divisor)
- **Lean target exists**: yes
- **Signature matches**: yes — `structure` with `point : X` and `coheight : Order.coheight point = 1`, matching the blueprint's iter-173 pin exactly.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; axiom-clean. Consistent with blueprint prose.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: def:codim1_cycles)
- **Lean target exists**: yes
- **Signature matches**: yes — `X.PrimeDivisor →₀ ℤ`, matching the blueprint's free-abelian-group presentation.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: def:order_at_point)
- **Lean target exists**: yes
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (...)] (f : X.functionField) : ℤ`, exactly as pinned by blueprint §2.
- **Proof follows sketch**: yes — body is `WithZero.log (Ring.ordFrac (...) f)`, matching the blueprint's Mathlib API path description.
- **notes**: `\leanok` present. Blueprint's "Junk-on-f=0 convention" (`order_zero` simp lemma at L233) is in the file and consistent.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: def:divisor_closed_point)
- **Lean target exists**: yes
- **Signature matches**: yes — junk-if-branching on `Order.coheight P = 1` as pinned at blueprint §3.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (chapter: lem:ofClosedPoint_eq_single)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-line `simp [ofClosedPoint, h]`.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (chapter: lem:ofClosedPoint_eq_zero)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: def:divisor_degree)
- **Lean target exists**: yes
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)` as described in blueprint §4.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: thm:divisor_degree_hom)
- **Lean target exists**: yes (`degree_hom : X.WeilDivisor →+ ℤ`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Finsupp.liftAddHom` packaging consistent with blueprint's "immediate from the definition" proof.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}` (chapter: lem:rationalMap_order_finite_support)
- **Lean target exists**: **NO** — see Red flags §1.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint L532 pins this name. In the Lean file (L357) the theorem is declared `private`, making the public identifier `AlgebraicGeometry.Scheme.rationalMap_order_finite_support` non-existent. Additionally the natural qualified name (inside `namespace AlgebraicGeometry`, not `namespace AlgebraicGeometry.Scheme`) would be `AlgebraicGeometry.rationalMap_order_finite_support`, not the `.Scheme.`-prefixed form pinned in the blueprint.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: def:principal_divisor)
- **Lean target exists**: yes
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor`
- **Proof follows sketch**: yes — `Finsupp.ofSupportFinite` with `rationalMap_order_finite_support` as the finiteness witness, matching blueprint §5.
- **notes**: `\leanok` present. The proof body is axiom-clean modulo the `private` sorry in `rationalMap_order_finite_support`; this propagation is acknowledged in the blueprint sub-build note.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: thm:principal_hom)
- **Lean target exists**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`
- **Signature matches**: yes
- **Proof follows sketch**: yes — coordinate-wise from DVR identities `order_mul_of_ne_zero` / `order_one`, matching blueprint §5 proof.
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: thm:principal_deg_zero)
- **Lean target exists**: yes
- **Signature matches**: yes — `{kbar} [Field kbar] [IsAlgClosed kbar] (C : Over (Spec (.of kbar))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [IsIntegral C.left] [IsLocallyNoetherian C.left] [IsRegularInCodimensionOne C.left] (f : C.left.functionField) (hf : f ≠ 0) : degree (principal f hf) = 0`
- **Proof follows sketch**: partial — constant branch closed axiom-clean; non-constant branch deferred with `sorry` (authorised sub-build deferral per blueprint §5 sub-build note).
- **notes**: `\leanok` present on statement (declaration formalised with sorry).

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (chapter: def:WeilDivisor_positivePart)
- **Lean target exists**: yes
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`, matching blueprint §6 description.
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (chapter: lem:degree_positivePart_principal_eq_finrank)
- **Lean target exists**: yes
- **Signature matches**: yes — pins to `(ProjectiveLineBar kbar).left.functionField` with uniformiser hypothesis `hLPUnif` (iter-194 refactor v2 signature), matching blueprint §6 note precisely.
- **Proof follows sketch**: partial — `degree_positivePart_eq_sum_max` + `Finsupp.sum_max_zero_eq_sum_filter_pos` + `principal_apply` reduction done; ramification-inertia bridge (`Ideal.sum_ramification_inertia`) deferred with `sorry`. Consistent with blueprint's "Following Hartshorne II.6.9" proof sketch and the acknowledged `Scheme.Hom.ofFunctionFieldEmbedding` Mathlib gap.
- **notes**: `\leanok` present on statement.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: def:linear_equivalence)
- **Lean target exists**: yes
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present; axiom-clean.

---

## Red flags

### Stale / wrong `\lean{...}` pin

**`lem:rationalMap_order_finite_support` (blueprint L529–L587)**: The blueprint pin `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}` (L532) names a declaration that does not exist as a public Lean identifier, for two compounding reasons:

1. **`private` declaration**: In `WeilDivisor.lean` L357 the theorem is declared `private theorem rationalMap_order_finite_support`. Lean 4's `private` keyword makes the declaration invisible outside its defining file; the fully-qualified public name is therefore inaccessible by any external consumer or toolchain lookup.

2. **Wrong namespace in pin**: The theorem sits inside `namespace AlgebraicGeometry` (opened at L61) with no intervening `namespace Scheme`. Its natural Lean-qualified name is therefore `AlgebraicGeometry.rationalMap_order_finite_support`, not `AlgebraicGeometry.Scheme.rationalMap_order_finite_support` as the blueprint pin claims. The `.Scheme.` segment is spurious.

The `sync_leanok` phase will fail to resolve this name and will not set `\leanok` for the block — which is the correct sentinel behaviour given the sorry, but the toolchain failure mode is confusing rather than principled. More importantly, any future attempt to make this theorem public would need to correct the blueprint pin's namespace simultaneously.

**Introduced**: iter-199 plan-phase (per directive). Pre-existing iterations did not have a `\lean{...}` pin for this private theorem.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` blueprint reference. All fall into the established project convention of §2 "anonymous substrate helpers" covered by prose in `def:order_at_point`, or are internal glue:

| Declaration | Nature | Blueprint home |
|---|---|---|
| `Scheme.IsRegularInCodimensionOne` (class) | project-bespoke predicate | prose in §2 "Lean encoding" |
| `IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` | bridge instance | prose only |
| `IsRegularInCodimensionOne.instKrullDimLEStalk` | bridge instance | prose only |
| `Scheme.RationalMap.order_zero` | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_mul_of_ne_zero` | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_inv` | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_units_inv` | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_neg` **(iter-199)** | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_pow_of_ne_zero` **(iter-199)** | §2 substrate | `def:order_at_point` prose |
| `Scheme.RationalMap.order_one` | §2 substrate | `def:order_at_point` prose |
| `Scheme.WeilDivisor.degree_hom_apply` | unfolding helper | implicit in `thm:divisor_degree_hom` |
| `Scheme.WeilDivisor.degree_zero` / `degree_add` / `degree_neg` / `degree_sub` | §4 substrate | implicit in `def:divisor_degree` |
| `Scheme.WeilDivisor.principal_apply` | structural unfolding | implicit in `def:principal_divisor` |
| `Scheme.WeilDivisor.principal_one` | §5 substrate | implicit in `thm:principal_hom` |
| `Scheme.WeilDivisor.positivePart_zero` / `positivePart_single` / `degree_positivePart_eq_sum_max` / `degree_single` | §6 substrate | implicit in `def:WeilDivisor_positivePart` |
| `Scheme.WeilDivisor.one_le_degree_positivePart_principal_of_order_one` | §6 substrate | implicit in `lem:degree_positivePart_principal_eq_finrank` |
| `Finsupp.sum_max_zero_eq_sum_filter_pos` | §6 generic helper | implicit |
| `instIsLocallyNoetherianProjectiveLineBar` | instance scaffold | implicit in `lem:degree_positivePart_principal_eq_finrank` |
| `isRegularInCodimOneProjectiveLineBar` | theorem scaffold | implicit |

**Iter-199 additions `order_neg` and `order_pow_of_ne_zero`**: these follow the exact pattern of their sibling §2 substrate lemmas (`order_zero`, `order_mul_of_ne_zero`, `order_inv`, `order_units_inv`) which also have no individual blueprint pins. The `def:order_at_point` prose covers the entire valuation-identity cluster; standalone `\lean{...}` pins would be disproportionate for lemmas of this granularity. **Recommendation: leave anonymous.** No pin needed.

---

## Blueprint adequacy for this file

- **Coverage**: 13/13 publicly-pinned Lean declarations have a corresponding `\lean{...}` block. The private theorem `rationalMap_order_finite_support` is the only substantive declaration with a pin pointing at a non-existent public name (see Red flags above). All other unreferenced declarations are helper substrate or glue — none are substantive declarations the blueprint is obligated to cover individually.

- **Proof-sketch depth**: **adequate** for the formally-targeted declarations. The `lem:rationalMap_order_finite_support` proof sketch is detailed (4-step Hartshorne 6.1 / Stacks 02RV recipe, explicit hypothesis gap analysis `[IsLocallyNoetherian X]` vs `[IsNoetherian X]`). The `lem:degree_positivePart_principal_eq_finrank` sketch (§6) gives the ramification-inertia route with explicit Mathlib lemma names (`Ideal.sum_ramification_inertia`, `Ideal.finrank_quotient_map`), adequate for a prover targeting this sub-build.

- **Hint precision**: **mostly precise**. All `\lean{...}` pins for existing public declarations are exact and correct. The sole broken pin (`AlgebraicGeometry.Scheme.rationalMap_order_finite_support`) is documented in Red flags.

- **Generality**: **matches need**. The blueprint's typeclass discipline (`[IsLocallyNoetherian X]` on most declarations, `[IsNoetherian X]` flagged as the correct strengthening for the HARD BAR helper) is accurately reflected in the Lean file.

- **Recommended chapter-side actions**:
  1. **(Major)** Fix or remove the broken pin at `lem:rationalMap_order_finite_support` L532. Two options:
     - **Option A** (preferred if the theorem is promoted to public in a future iter): remove `private`, confirm the declaration lives in the correct sub-namespace (`AlgebraicGeometry` not `AlgebraicGeometry.Scheme`), and correct the blueprint pin to `\lean{AlgebraicGeometry.rationalMap_order_finite_support}`.
     - **Option B** (if the theorem stays private): remove the `\lean{...}` pin entirely and leave the proof sketch under a `% NOTE:` annotation. The `def:principal_divisor` block already documents this as a private sub-lemma.

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint pin `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}` names a non-existent public declaration (the Lean theorem is `private` and the namespace `.Scheme.` is spurious) — introduced in iter-199 plan phase | **major** |
| `order_neg` / `order_pow_of_ne_zero` (iter-199) have no blueprint pin — consistent with §2 anonymous-substrate convention; no action needed | informational |
| HARD BAR helper (`rationalMap_order_finite_support`) sorry-body: known sub-build deferral; blueprint narrative accurately describes the `[IsLocallyNoetherian X]` vs `[IsNoetherian X]` gap | informational |
| All other `\lean{...}` pins: existing, correctly-named, signature-matching | clean |

**No must-fix-this-iter findings.** The one major finding is an editorial error in the blueprint pin introduced this iter; it does not corrupt any Lean proof, but it will confuse the `sync_leanok` toolchain and creates a stale public-name claim in the chapter.

**Overall verdict**: 13 public declarations checked, all matching their blueprint blocks; 1 major blueprint-side defect (broken `\lean{...}` pin for the private `rationalMap_order_finite_support` theorem, introduced in iter-199 plan phase — wrong namespace and `private` make the pinned name non-existent); 2 new iter-199 Lean helpers appropriately left anonymous per project convention.
