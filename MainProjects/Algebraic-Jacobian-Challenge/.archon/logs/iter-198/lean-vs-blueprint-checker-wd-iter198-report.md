# Lean ↔ Blueprint Check Report

## Slug
wd-iter198

## Iteration
198

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: `def:prime_divisor`)
- **Lean target exists**: yes (L93)
- **Signature matches**: yes — `structure Scheme.PrimeDivisor (X : Scheme.{u})` with `point : X` and `coheight : Order.coheight point = 1`, matching the blueprint's iter-173 pin exactly.
- **Proof follows sketch**: N/A (structure, no proof body)
- **`\leanok`**: present on statement block ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: `def:codim1_cycles`)
- **Lean target exists**: yes (L106)
- **Signature matches**: yes — `def Scheme.WeilDivisor (X : Scheme.{u}) : Type u := X.PrimeDivisor →₀ ℤ`, matching blueprint.
- **Proof follows sketch**: N/A (definition)
- **`\leanok`**: present on statement block ✓

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: `def:order_at_point`)
- **Lean target exists**: yes (L153–157)
- **Signature matches**: yes — `noncomputable def order {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] (f : X.functionField) : ℤ`, matching the iter-175 pin exactly.
- **Proof follows sketch**: yes — body is `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)`, exactly as the blueprint specifies.
- **`\leanok`**: present on statement block ✓
- **notes**: Blueprint prose in `def:order_at_point` mentions `v_Y(fg)=v_Y(f)+v_Y(g)`, `v_Y(f⁻¹)=-v_Y(f)`, `v_Y(1)=0` "available as named lemmas", but provides no `\lean{...}` pins for those four named lemmas — see **Unreferenced declarations** below.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: `def:divisor_closed_point`)
- **Lean target exists**: yes (L399–401)
- **Signature matches**: yes — junk-defined via `if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0`, matching blueprint's iter-174 pin.
- **Proof follows sketch**: yes
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (chapter: `lem:ofClosedPoint_eq_single`)
- **Lean target exists**: yes (L407–410)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-line `simp [ofClosedPoint, h]`.
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (chapter: `lem:ofClosedPoint_eq_zero`)
- **Lean target exists**: yes (L416–419)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: `def:divisor_degree`)
- **Lean target exists**: yes (L438–439)
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)`, matching blueprint.
- **Proof follows sketch**: N/A
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: `thm:divisor_degree_hom`)
- **Lean target exists**: yes (L453–454)
- **Signature matches**: yes — `degree_hom : X.WeilDivisor →+ ℤ` built from `Finsupp.liftAddHom`, matching blueprint.
- **Proof follows sketch**: yes
- **`\leanok`**: present ✓
- **notes**: The blueprint proof sketch mentions `deg(-D) = -deg(D)`, which is now a separate named lemma `degree_neg`; blueprint doesn't pin it — see below.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: `def:principal_divisor`)
- **Lean target exists**: yes (L513–518)
- **Signature matches**: yes — uses `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]`, matching blueprint's intent.
- **Proof follows sketch**: partial — body `Finsupp.ofSupportFinite ... (rationalMap_order_finite_support f)` is structurally correct, but `rationalMap_order_finite_support` (the private theorem it depends on) has a `sorry` in the `f ≠ 0` branch. The blueprint §5 prose presents Lemma 6.1 as an established fact without noting this sorry.
- **`\leanok`**: present on statement block; technically correct under the vocabulary ("at least a sorry present" — the sorry propagates through the helper).

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: `thm:principal_hom`)
- **Lean target exists**: yes (L576–619)
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`, matching blueprint.
- **Proof follows sketch**: yes — closes coordinate-wise from `Ring.ordFrac` multiplicativity and `WithZero.log_mul/one`, matching the proof sketch.
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: `thm:principal_deg_zero`)
- **Lean target exists**: yes (L638–673)
- **Signature matches**: yes
- **Proof follows sketch**: partial — constant branch (`∀ Y, ord_Y f = 0 → principal f = 0`) is closed. Non-constant branch has `sorry` (Route C PAUSE, L673).
- **`\leanok`**: present on statement block (correct per vocabulary: body exists).
- **notes**: Blueprint prose presents this theorem's proof cleanly without noting that the non-constant branch (`f ∉ k̄`) is currently a sorry. The sub-build note referenced from `def:principal_divisor`'s Lean docstring ("see chapter RiemannRoch_WeilDivisor.tex §5 sub-build note") does **not exist** in the blueprint — the §5 section has no standalone sub-build note; this cross-reference from the Lean file is dangling.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (chapter: `def:WeilDivisor_positivePart`)
- **Lean target exists**: yes (L712–713)
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`, matching blueprint.
- **Proof follows sketch**: N/A
- **`\leanok`**: present ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (chapter: `lem:degree_positivePart_principal_eq_finrank`)
- **Lean target exists**: yes (L1139–1243)
- **Signature matches**: yes — pins `t ∈ (ProjectiveLineBar kbar).left.functionField` with the `hLPUnif` uniformiser constraint, matching iter-194 refactor v2.
- **Proof follows sketch**: partial — Steps A+B+C (Finsupp reductions, `degree_positivePart_eq_sum_max`, `Finsupp.sum_max_zero_eq_sum_filter_pos`, `principal_apply`) are closed; the ramification-inertia bridge (`Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map`) has `sorry` (L1243, Route C PAUSE).
- **`\leanok`**: present on statement block (correct per vocabulary).

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: `def:linear_equivalence`)
- **Lean target exists**: yes (L1262–1264)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Prop-valued definition)
- **`\leanok`**: present ✓

---

## Red flags

### Placeholder / suspect bodies
- `rationalMap_order_finite_support` (private, L307–365): `f ≠ 0` branch is `:= sorry` (L365). This private theorem is the finite-support witness for `principal`; the sorry is axiom-documented (30-line structural-blocker comment, L326–364) explaining the `[IsLocallyNoetherian X]` vs `[IsNoetherian X]` gap. The definition `principal` itself compiles because it accepts the sorry witness, but any consumer that inspects the axiom set of `principal` will encounter `sorryAx`. Blueprint §5 presents Hartshorne Lemma 6.1 as established without acknowledging this sorry.

- `principal_degree_zero` (L638–673): non-constant branch ends in `:= sorry` (L673). This is Route C PAUSE and expected; `\leanok` on the statement block is correct per vocabulary.

- `degree_positivePart_principal_eq_finrank` (L1139–1243): closes to `:= sorry` (L1243). Route C PAUSE and expected.

### Excuse-comments
None of the current sorry sites use "this is wrong but works for now" language. The Lean file's sorry comments are properly documented as known gaps (structural-blocker notes or Route C PAUSE directives), not excuse-comments in the sense of the red-flag rule.

### Axioms / Classical.choice on non-trivial claims
No new `axiom` declarations introduced this iteration. `isRegularInCodimOneProjectiveLineBar` (L885) is a `theorem ... by ... sorry` (a typed-sorry, not a bare `axiom`); the lean-auditor iter-196 must-fix that demoted it from `instance` to `theorem` is already in place.

---

## Unreferenced declarations (informational)

### Substantive declarations with no `\lean{...}` pin — the 6 iter-198 additions

The following six declarations were added axiom-clean in iter-198 and have **no** `\lean{...}` pin in the blueprint:

1. `AlgebraicGeometry.Scheme.RationalMap.order_zero` (L234–241)
   — `ord_Y 0 = 0`. Blueprint §2 alludes to "v_Y(1) = 0 available as named lemmas" but provides no pin.
2. `AlgebraicGeometry.Scheme.RationalMap.order_mul_of_ne_zero` (L246–255)
   — `ord_Y (f·g) = ord_Y f + ord_Y g` for `f,g ≠ 0`. Blueprint alludes to `v_Y(fg)=v_Y(f)+v_Y(g)` in prose but provides no pin.
3. `AlgebraicGeometry.Scheme.RationalMap.order_inv` (L265–272)
   — `ord_Y f⁻¹ = -ord_Y f`. Blueprint alludes to `v_Y(f⁻¹)=-v_Y(f)` but provides no pin.
4. `AlgebraicGeometry.Scheme.RationalMap.order_units_inv` (L279–288)
   — unit specialisation of `order_inv`. No prose mention; no pin.
5. `AlgebraicGeometry.Scheme.WeilDivisor.degree_neg` (L479–483)
   — `deg(-D) = -deg D`. Blueprint `thm:divisor_degree_hom` states this in the theorem but issues no separate pin for the standalone lemma.
6. `AlgebraicGeometry.Scheme.WeilDivisor.degree_sub` (L488–491)
   — `deg(D₁ - D₂) = deg D₁ - deg D₂`. No mention; no pin.

**`\leanok` status for the 6 new declarations**: all proofs are axiom-clean (no sorries). Since there are no `\lean{...}` statement blocks for them in the chapter, `sync_leanok` cannot add `\leanok` to them. The `\leanok` that *should* appear after pins are added is absent because the pins themselves are absent. This fully explains why `sync_leanok iter=198` did not touch `RiemannRoch_WeilDivisor.tex` — there was nothing for it to update.

### Other substantive declarations without pins

- `Scheme.IsRegularInCodimensionOne` class (L178–184): introduced in an earlier iter, referenced heavily by `principal`, `principal_hom`, `principal_degree_zero`, `degree_positivePart_principal_eq_finrank`, `LinearEquivalence`. Blueprint §2 says "Iter-173+ may introduce a Scheme.IsRegularInCodimensionOne predicate to abbreviate this; until then the order/principal lemmas thread the DVR hypothesis explicitly." This statement is **stale** — the predicate has been introduced and IS used by all principal-layer declarations. The blueprint should acknowledge this class with a `\lean{...}` pin (or at minimum update the prose from "may introduce" to "has been introduced").

### Helper declarations (acceptable)

`AddCommGroup` and `Inhabited` instances (L110–116), `instIsDiscreteValuationRingStalk` / `instKrullDimLEStalk` bridge instances (L189–208), `degree_hom_apply` (L456–459), `degree_zero` (L463–465), `degree_add` (L469–472), `principal_apply` (L527–535), `order_one` (L544–550), `principal_one` (L555–562), `positivePart_zero` (L716–720), `degree_positivePart_eq_sum_max` (L731–735), `positivePart_single` (L744–750), `degree_single` (L757–762), `one_le_degree_positivePart_principal_of_order_one` (L771–817), `Finsupp.sum_max_zero_eq_sum_filter_pos` (L832–843), `instIsLocallyNoetherianProjectiveLineBar` (L869–874), `isRegularInCodimOneProjectiveLineBar` (L885–1102).

---

## Blueprint adequacy for this file

- **Coverage**: 14/14 pinned declarations resolved in Lean. 6 substantive declarations (iter-198 additions) have no `\lean{...}` block; `Scheme.IsRegularInCodimensionOne` has a stale prose mention but no pin. Remaining ~20 declarations are helpers (acceptable).
- **Proof-sketch depth**: **under-specified** in two respects:
  1. §5 (`def:principal_divisor`): the blueprint presents Hartshorne Lemma 6.1 as an established fact but provides no sub-build note documenting that the f≠0 branch is a sorry due to the `[IsLocallyNoetherian X]` vs `[IsNoetherian X]` typeclass insufficiency identified in iter-198.
  2. §2 ("Standing hypothesis (*) in the Lean encoding"): the blueprint says `[IsLocallyNoetherian X]` is threaded for the order/principal layer. The iter-198 prover surfaced that this is **insufficient** to close `rationalMap_order_finite_support` (the private finite-support theorem underlying `principal`): global Noetherianness (`[IsNoetherian X] = [IsLocallyNoetherian X] + [CompactSpace X]`) is required for step (c) of the proof — bounding prime divisors outside an affine chart. This gap is documented in 30+ lines of Lean comments at L326–364 but is **completely absent** from the blueprint chapter.
- **Hint precision**: **partially loose** — the blueprint's prose in `def:order_at_point` names four identities as "available as named lemmas" without providing `\lean{...}` pins, and `thm:divisor_degree_hom` states `deg(-D) = -deg(D)` without pinning `degree_neg` separately.
- **Generality**: matches need overall.
- **Recommended chapter-side actions**:
  1. **Add `\lean{...}` pins** for all 6 iter-198 additions in §2 and §4:
     - `\lean{AlgebraicGeometry.Scheme.RationalMap.order_zero}`
     - `\lean{AlgebraicGeometry.Scheme.RationalMap.order_mul_of_ne_zero}`
     - `\lean{AlgebraicGeometry.Scheme.RationalMap.order_inv}`
     - `\lean{AlgebraicGeometry.Scheme.RationalMap.order_units_inv}`
     - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_neg}`
     - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_sub}`
     (Once pins are added, `sync_leanok` will automatically add `\leanok` to all six since their proofs are axiom-clean.)
  2. **Add a sub-build note** in §5 (`def:principal_divisor`) documenting that `rationalMap_order_finite_support` (the private theorem packaging Hartshorne Lemma 6.1) has a `sorry` in the `f ≠ 0` branch due to a typeclass gap, and note the resolution path (`[IsNoetherian X]` required; iter-199+ work pending Route C approval).
  3. **Update §2 typeclass discussion** to document the `[IsLocallyNoetherian X]` insufficiency: add a note (after the existing paragraph on the order/principal layer typeclass set) explaining that closing the finite-support side condition for Lemma 6.1 requires `[IsNoetherian X]` (quasi-compact + locally Noetherian) so that prime divisors outside any given affine chart are also bounded.
  4. **Update the stale `Scheme.IsRegularInCodimensionOne` prose** in §2 ("Iter-173+ may introduce...") to past tense and add a `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` pin.
  5. **Correct the dangling cross-reference**: `def:principal_divisor`'s Lean docstring (L309) says "see chapter RiemannRoch_WeilDivisor.tex §5 sub-build note" but no such standalone sub-build note section exists in the chapter. Reconcile: either add the sub-build note (action 2 above covers this) or remove the cross-reference.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | 6 iter-198 declarations missing `\lean{...}` pins (§2: `order_zero`, `order_mul_of_ne_zero`, `order_inv`, `order_units_inv`; §4: `degree_neg`, `degree_sub`) | **major** |
| 2 | Blueprint §5/§2 entirely silent on `[IsLocallyNoetherian X]` insufficiency for `rationalMap_order_finite_support`'s `f≠0` branch; `[IsNoetherian X]` gap not documented anywhere in chapter | **major** |
| 3 | Blueprint §5 presents Hartshorne Lemma 6.1 as established fact; the underlying sorry is undocumented (no sub-build note, despite Lean docstring at L309 cross-referencing a non-existent one) | **major** |
| 4 | Stale prose: "Iter-173+ may introduce `Scheme.IsRegularInCodimensionOne`...until then...thread DVR hypothesis explicitly" — class is already introduced and used in all principal-layer signatures; no `\lean{...}` pin | **minor** |

**Overall verdict**: The 14 pinned declarations all resolve in Lean with correct signatures, and the new iter-198 Lean proofs are axiom-clean; however, all 6 iter-198 additions are unregistered in the blueprint (missing `\lean{...}` pins), and the chapter is silent on the structural `IsLocallyNoetherian` vs `IsNoetherian` typeclass gap surfaced by the iter-198 prover — 3 major findings, no must-fix-this-iter.

---

*Report path: `.archon/task_results/lean-vs-blueprint-checker-wd-iter198.md`*
