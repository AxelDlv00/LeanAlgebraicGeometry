# Lean ↔ Blueprint Check Report

## Slug
wd

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (chapter: def:prime_divisor)
- **Lean target exists**: yes (L93)
- **Signature matches**: yes — `structure` with `point : X` and `coheight : Order.coheight point = 1` matches blueprint's iter-173 pin exactly
- **Proof follows sketch**: N/A (structure, no proof body)
- **notes**: Clean match; blueprint's "reject list" for alternatives (closedSubschemeOfPoint, IdealSheafData) is reflected in the file's docstring.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (chapter: def:codim1_cycles)
- **Lean target exists**: yes (L106)
- **Signature matches**: yes — `X.PrimeDivisor →₀ ℤ`, no integrality typeclass on the head
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (chapter: def:order_at_point)
- **Lean target exists**: yes (L153)
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] (f : X.functionField) : ℤ`; body `WithZero.log (Ring.ordFrac ...)` matches blueprint's iter-175 pin precisely
- **Proof follows sketch**: yes (non-sorry, one-line body)
- **notes**: Blueprint's junk-on-f=0 convention and the Stacks 02IZ gap are both noted accurately.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (chapter: def:divisor_closed_point)
- **Lean target exists**: yes (L283)
- **Signature matches**: yes — `(P : C) (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor`; body is the `if h : Order.coheight P = 1 then ... else 0` case split described in the blueprint
- **Proof follows sketch**: yes
- **notes**: Clean match; junk-regime design matches blueprint's description.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (chapter: lem:ofClosedPoint_eq_single)
- **Lean target exists**: yes (L291)
- **Signature matches**: yes
- **Proof follows sketch**: yes (one-liner `simp [ofClosedPoint, h]`)
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (chapter: lem:ofClosedPoint_eq_zero)
- **Lean target exists**: yes (L300)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (chapter: def:divisor_degree)
- **Lean target exists**: yes (L322)
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)` matches blueprint's "literal sum of coefficients" description
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean match; blueprint's "no curve typeclass on the head" scope note matches Lean declaration.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (chapter: thm:divisor_degree_hom)
- **Lean target exists**: yes (L337)
- **Signature matches**: yes — `X.WeilDivisor →+ ℤ` via `Finsupp.liftAddHom`
- **Proof follows sketch**: yes (non-sorry)
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (chapter: def:principal_divisor)
- **Lean target exists**: yes (L378)
- **Signature matches**: yes — `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor`; body `Finsupp.ofSupportFinite` is consistent with blueprint's description
- **Proof follows sketch**: partial — body calls `rationalMap_order_finite_support f` which has a `sorry` in its nonzero branch (L249); blueprint explicitly authorizes this as a Mathlib-pending gap (Stacks 02RV)
- **notes**: Blueprint's sub-build deferral note at §5 covers the sorry. No issue.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (chapter: thm:principal_hom)
- **Lean target exists**: yes (L441)
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`; blueprint proves via DVR axioms per-Y, Lean proof is coordinatewise via `map_mul`/`WithZero.log_mul`
- **Proof follows sketch**: yes (non-sorry, complete proof)
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (chapter: thm:principal_deg_zero)
- **Lean target exists**: yes (L503)
- **Signature matches**: yes — `[Field kbar] [IsAlgClosed kbar] (C : Over (Spec (.of kbar))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [IsIntegral C.left] [IsLocallyNoetherian C.left] [Scheme.IsRegularInCodimensionOne C.left] (f : C.left.functionField) (hf : f ≠ 0) : degree (principal f hf) = 0`
- **Proof follows sketch**: partial — constant branch closed; non-constant branch (L527–538) has `sorry`; blueprint's sub-build note explicitly authorizes this
- **notes**: Blueprint flags "finite morphism induced by a non-constant rational function" and "multiplicativity of degree under finite pullback" as deferred sub-lemmas. The sorry at L538 is authorized.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (chapter: def:WeilDivisor_positivePart)
- **Lean target exists**: yes (L577)
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`; blueprint describes this as the `mapRange` form to avoid noncomputable `semilatticeSup`
- **Proof follows sketch**: N/A (definition)
- **notes**: Clean match.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (chapter: lem:degree_positivePart_principal_eq_finrank)
- **Lean target exists**: yes (L963)
- **Signature matches**: yes — pins `t ∈ (ProjectiveLineBar kbar).left.functionField`; `hLPUnif` uniformiser hypothesis (`∃ Y₀, order Y₀ t = 1 ∧ ∀ Y, order Y t > 0 → Y = Y₀`); conclusion `degree (positivePart (principal (algebraMap _ C.left.functionField t) halg)) = (Module.finrank ... : ℤ)`. Matches blueprint's iter-194 refactor v2 note precisely.
- **Proof follows sketch**: partial — body uses `degree_positivePart_eq_sum_max` + `Finsupp.sum_max_zero_eq_sum_filter_pos` + `principal_apply` reduction (Steps A/B/C from blueprint proof sketch), then `sorry` at L1067 for the ramification-inertia step. Blueprint proof explicitly requires `Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map` + `Scheme.Hom.ofFunctionFieldEmbedding` (a Mathlib-pending constructor); sorry is authorized.
- **notes**: Body unchanged from iter-195 per directive; blueprint's authorization of the Hartshorne I.6.12 gap is present. No issue.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (chapter: def:linear_equivalence)
- **Lean target exists**: yes (L1086)
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`; matches blueprint "D - D' = div(f) for some nonzero f"
- **Proof follows sketch**: N/A (Prop definition)
- **notes**: Clean match.

---

## Red flags

### Placeholder / suspect bodies

- `rationalMap_order_finite_support` (L227, private): `sorry` at L249 in the nonzero branch. Blueprint explicitly authorizes this as Stacks 02RV (Hartshorne Lemma 6.1, Mathlib-pending). **Not a red flag; authorized.**
- `principal_degree_zero` (L503): `sorry` at L538. Blueprint authorizes. **Not a red flag.**
- `degree_positivePart_principal_eq_finrank` (L963): `sorry` at L1067. Blueprint authorizes (Hartshorne I.6.12 correspondence Mathlib-pending). **Not a red flag.**
- `isRegularInCodimOneProjectiveLineBar` (L750): `sorry` at L916–920 (`hy_ne_bot : y.asIdeal ≠ ⊥`). This declaration has **no `\lean{...}` blueprint pin**. The sorry is documented in the Lean docstring as "TODO (iter-197+): port Stacks 02IZ topological-coheight ↔ ideal-height bridge". **Red flag: sorry in an unblueprinted declaration — see "Blueprint adequacy" section.**

### Excuse-comments

- `isRegularInCodimOneProjectiveLineBar` (L917–919): comment "TODO (iter-197+): port Stacks 02IZ topological-coheight ↔ ideal-height bridge; combine with `Y.coheight = 1` + open-immersion coheight preservation to derive `y.asIdeal ≠ ⊥`." This is a documented TODO on an unblueprinted theorem. The comment accurately identifies the mathematical gap without claiming the code is wrong. It is a legitimate workflow note, **not** a "wrong-but-works" excuse.

### Axioms / Classical.choice on non-trivial claims
- None found. All sorries are explicit `sorry` tactics, not `axiom` declarations.

---

## Focus-area specific findings

### Focus 1 — `isRegularInCodimOneProjectiveLineBar` naming change (iter-196)

**Finding**: The Lean file at L750 correctly carries the demoted-from-instance form:
```
theorem isRegularInCodimOneProjectiveLineBar (kbar : Type u) [Field kbar]
    [IsIntegral (ProjectiveLineBar kbar).left] :
    Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left
```
The docstring at L741–749 explicitly records the iter-196 demotion rationale and the new caller pattern (`haveI := isRegularInCodimOneProjectiveLineBar kbar`).

**Blueprint status**: The blueprint chapter has **no `\lean{...}` pin** for either `instIsRegularInCodimOneProjectiveLineBar` (the old instance name) or `isRegularInCodimOneProjectiveLineBar` (the new theorem name). The only blueprint mention of `Scheme.IsRegularInCodimensionOne` is:
- Standing hypothesis section (blueprint L97–102): *"Iter-173+ may introduce a `Scheme.IsRegularInCodimensionOne` predicate to abbreviate this"* — written before the class was introduced, never updated.
- A `%`-comment inside `lem:degree_positivePart_principal_eq_finrank` (blueprint L723–725): *"Refactor v2 net cost: +2 typed-sorry typeclass instances on `ProjectiveLineBar` (`IsLocallyNoetherian`, `IsRegularInCodimensionOne`)"* — this is a comment, not a `\lean{...}` pin.

The blueprint therefore does **not** reflect the naming change, because the old name was never blueprinted either. The standing hypothesis prose is stale (says "may introduce" for a class that has been present since iter-173+).

### Focus 2 — Route 2 PID-transfer recipe and `hy_ne_bot` residual gap

**Finding**: The Lean body at L766–926 implements an 8-step Route 2 proof sketch (chart cover via `𝒰.idx`/`𝒰.covers` → stalk-map iso via `IsOpenImmersion.iff_isIso_stalkMap` → `Spec.stalkIso` at chart stalk → PID/Dedekind transfer via `homogeneousLocalizationAwayIso`/`MvPolynomial.pUnitAlgEquiv` → `IsLocalization.AtPrime.isDiscreteValuationRing_of_dedekind_domain`), with the residual `hy_ne_bot : y.asIdeal ≠ ⊥` sorry at L916–920.

**Blueprint status**: The chapter has **no proof sketch** for `isRegularInCodimOneProjectiveLineBar`. The Route 2 recipe, the chart-cover decomposition, and the `hy_ne_bot` (Stacks 02IZ/005X) residual gap are described solely in the Lean docstring and tactic comments, not in the blueprint. The blueprint's Stacks 02IZ reference appears only in the `def:order_at_point` context (blueprint L336–352), not in the context of the `ProjectiveLineBar` DVR-stalk theorem.

### Focus 3 — L1067 `degree_positivePart_principal_eq_finrank` body

Unchanged from iter-195 per directive. The Lean body ends at L1067 with `sorry` after the `simp_rw [hbridge]` step. Blueprint proof sketch for `lem:degree_positivePart_principal_eq_finrank` is detailed and explicitly identifies the Hartshorne I.6.12 correspondence and `Ideal.sum_ramification_inertia` gap as the gating substrate. Status: **authorized by blueprint, no regression from iter-195**.

### Focus 4 — L249 / L538 sorries

- `rationalMap_order_finite_support` (L249): nonzero branch sorry, authorized by blueprint §5 sub-build note.
- `principal_degree_zero` (L538): non-constant branch sorry, authorized by blueprint proof sub-build note.
Both unchanged and off-critical-path. No issues.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` pin in the blueprint:

| Declaration | Line | Category |
|---|---|---|
| `Scheme.IsRegularInCodimensionOne` (class) | L178 | Substantive project-bespoke class — blueprint mentions it by name only in prose |
| `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` | L189 | Bridge instance — helper |
| `Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk` | L200 | Bridge instance — helper |
| `rationalMap_order_finite_support` (private theorem) | L227 | Private; blueprint §5 mentions it as "separate sub-build deferral" but doesn't pin |
| `principal_apply` | L392 | Structural helper |
| `Scheme.RationalMap.order_one` | L409 | Substrate lemma |
| `principal_one` | L420 | Substrate lemma |
| `degree_hom_apply` | L341 | Structural helper |
| `degree_zero` | L347 | Corollary helper |
| `degree_add` | L353 | Corollary helper |
| `positivePart_zero` | L582 | Substrate helper |
| `degree_positivePart_eq_sum_max` | L597 | Substrate helper |
| `positivePart_single` | L610 | Substrate helper |
| `degree_single` | L623 | Substrate helper |
| `one_le_degree_positivePart_principal_of_order_one` | L636 | Substrate helper |
| `Finsupp.sum_max_zero_eq_sum_filter_pos` | L697 | Generic Finsupp lemma |
| `instIsLocallyNoetherianProjectiveLineBar` | L734 | Infrastructure instance — fully closed, non-sorry |
| **`isRegularInCodimOneProjectiveLineBar`** | L750 | **Substantive theorem (partially proven, one sorry); should have a blueprint pin** |

The most notable missing pin is `isRegularInCodimOneProjectiveLineBar`: it is neither a trivial corollary nor a pure helper, and it was the subject of the iter-196 demotion. The blueprint should gain a `\lean{...}` reference to the theorem (and a proof sketch describing the Route 2 PID-transfer route and the `hy_ne_bot` residual).

---

## Blueprint adequacy for this file

- **Coverage**: 14/14 `\lean{...}`-pinned declarations exist and match. However, 18 additional declarations in the file have no blueprint pin. Of these, 2 are substantive and should be documented: `isRegularInCodimOneProjectiveLineBar` (theorem with partial proof and a named sorry gap) and `Scheme.IsRegularInCodimensionOne` (the project-bespoke class). The remaining 16 are helpers or infrastructure.

- **Proof-sketch depth**: **adequate** for the 14 pinned declarations. The blueprint's proof sketches for `thm:principal_deg_zero` and `lem:degree_positivePart_principal_eq_finrank` are detailed enough to guide the Lean proofs. However, **silent** for `isRegularInCodimOneProjectiveLineBar` — no sketch exists, yet the theorem has a 160-LOC body with an 8-step Route 2 recipe and a named Stacks-gated sorry.

- **Hint precision**: **precise** — all 14 `\lean{...}` hints correctly name the target declarations, and all signatures in the Lean file match the blueprint's stated signatures.

- **Generality**: **matches need** for the 14 pinned declarations. The `degree` definition is intentionally over-general (no curve typeclass), matching the blueprint's stated design intent.

- **Stale prose**: The "Standing hypothesis" paragraph (blueprint L71–119) says *"Iter-173+ may introduce a `Scheme.IsRegularInCodimensionOne` predicate to abbreviate this"* — this is now obsolete. The class exists, is fully used, and has been the project's typeclass for several iterations. The sentence should be updated.

- **Recommended chapter-side actions**:
  1. Add a `\begin{theorem}` block with `\lean{AlgebraicGeometry.isRegularInCodimOneProjectiveLineBar}` (or its fully-qualified name inside the `AlgebraicGeometry` namespace), with a proof sketch describing:
     - The Route 2 PID-transfer recipe (chart cover → stalk iso → `Spec.stalkIso` → `Away ≅ k̄[t]` iso chain → Dedekind → DVR-at-nonzero-prime)
     - The named residual gap `hy_ne_bot : y.asIdeal ≠ ⊥` gated on Stacks 02IZ/005X (topological-coheight ↔ ideal-height bridge)
  2. Add a `\begin{definition}` block for `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` (the project-bespoke class).
  3. Update the stale "Iter-173+ may introduce" sentence in the "Standing hypothesis" section.
  4. Add `\lean{...}` pins for `instIsLocallyNoetherianProjectiveLineBar` (it is non-sorry and derivable from properness + locally finite type).

---

## Severity summary

- **must-fix-this-iter**: none. All sorries in blueprinted declarations are authorized by the blueprint; no signature mismatches; no excuse-comments on declarations the blueprint claims are real; no rogue axioms.
- **major** (1): `isRegularInCodimOneProjectiveLineBar` (L750) — substantive theorem with a 160-LOC body and a named sorry gap that has no `\lean{...}` pin in the blueprint. A blueprint-writing subagent should land the corresponding block before the next prover pass on this file.
- **minor** (2): (a) stale "may introduce" prose in the Standing hypothesis section; (b) `Scheme.IsRegularInCodimensionOne` class and its bridge instances (`instIsDiscreteValuationRingStalk`, `instKrullDimLEStalk`) lack `\lean{...}` pins.

**Overall verdict**: 14 blueprinted declarations verified clean (all signatures match, all sorries authorized); 1 major blueprint coverage gap (`isRegularInCodimOneProjectiveLineBar` not blueprinted despite substantive iter-196 Route 2 advance); no Lean-side defects requiring fixes this iteration.
