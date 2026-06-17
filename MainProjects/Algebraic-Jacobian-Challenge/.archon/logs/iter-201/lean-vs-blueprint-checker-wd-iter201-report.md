# Lean ↔ Blueprint Check Report

## Slug
wd-iter201

## Iteration
201

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (1648 lines)
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (1170 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (def:prime_divisor)
- **Lean target exists**: yes — `Scheme.PrimeDivisor` at line 94
- **Signature matches**: yes — structure with `point : X` and `coheight : Order.coheight point = 1`, exactly matching the blueprint's iter-173 pin description
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` on statement block is correct; declaration is axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (def:codim1_cycles)
- **Lean target exists**: yes — `def Scheme.WeilDivisor (X : Scheme.{u}) : Type u := X.PrimeDivisor →₀ ℤ` at line 107
- **Signature matches**: yes — free abelian group on `PrimeDivisor` as a `Finsupp`, exactly as stated
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` (def:isRegularInCodimensionOne)
- **Lean target exists**: yes — `class Scheme.IsRegularInCodimensionOne (X : Scheme.{u}) [IsIntegral X] : Prop` at line 451
- **Signature matches**: yes — one-field Prop class with `out : ∀ Y : Scheme.PrimeDivisor X, IsDiscreteValuationRing (X.presheaf.stalk Y.point)`, matching blueprint
- **Proof follows sketch**: N/A (class definition)
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.restrictToOpen}` (def:primeDivisor_restrictToOpen)
- **Lean target exists**: yes — line 162
- **Signature matches**: yes — `(U : X.Opens) (Y : X.PrimeDivisor) (hYU : Y.point ∈ U) : U.toScheme.PrimeDivisor`, matching blueprint prose exactly
- **Proof follows sketch**: yes — body uses `Order.coheight_eq_of_isOpenEmbedding` as specified in blueprint
- **notes**: `\leanok` on statement block (one of the 5 new sync_leanok markers) — **correctly placed**; axiom-clean proof

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.ofOpen}` (def:primeDivisor_ofOpen)
- **Lean target exists**: yes — line 174
- **Signature matches**: yes — `(U : X.Opens) (YU : U.toScheme.PrimeDivisor) : X.PrimeDivisor`, matching blueprint
- **Proof follows sketch**: yes — uses `Order.coheight_eq_of_isOpenEmbedding` in opposite direction as specified
- **notes**: `\leanok` (one of the 5 new sync_leanok markers) — **correctly placed**; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.equivOpen}` (lem:primeDivisor_equivOpen)
- **Lean target exists**: yes — line 195
- **Signature matches**: yes — `{ Y : X.PrimeDivisor // Y.point ∈ U } ≃ U.toScheme.PrimeDivisor` exactly
- **Proof follows sketch**: yes — blueprint says "both `left_inv` and `right_inv` hold definitionally (`rfl`)"; Lean has `left_inv := by rintro ⟨Y, hY⟩; rfl` and `right_inv := by intro YU; rfl`
- **notes**: `\leanok` (one of the 5 new sync_leanok markers) — **correctly placed**; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.stalkIso}` (lem:primeDivisor_stalkIso)
- **Lean target exists**: yes — line 210
- **Signature matches**: yes — thin wrapper around `AlgebraicGeometry.Scheme.Opens.stalkIso`, type `U.toScheme.presheaf.stalk (restrictToOpen U Y hYU).point ≅ X.presheaf.stalk Y.point`; blueprint description matches
- **Proof follows sketch**: yes — one-liner `AlgebraicGeometry.Scheme.Opens.stalkIso U ⟨Y.point, hYU⟩`
- **notes**: `\leanok` (one of the 5 new sync_leanok markers) — **correctly placed**; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne.instOpen}` (thm:isRegularInCodimensionOne_open)
- **Lean target exists**: yes — `instance Scheme.IsRegularInCodimensionOne.instOpen` at line 478
- **Signature matches**: yes — `[IsIntegral X] [Scheme.IsRegularInCodimensionOne X] (U : X.Opens) [IsIntegral U.toScheme] : Scheme.IsRegularInCodimensionOne U.toScheme`, matching blueprint's explicit typeclass list
- **Proof follows sketch**: yes — blueprint says transport DVR property via `Scheme.PrimeDivisor.ofOpen` + `Scheme.PrimeDivisor.stalkIso` + `IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing`; Lean proof follows this exactly
- **notes**: `\leanok` on statement block (one of the 5 new sync_leanok markers) — **correctly placed**. No `\begin{proof}...\end{proof}` block in the blueprint for this theorem, so the single statement `\leanok` is the correct end-state. Proof is axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (def:order_at_point)
- **Lean target exists**: yes — line 426
- **Signature matches**: yes — `noncomputable def order {X : Scheme.{u}} [IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor) [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] (f : X.functionField) : ℤ` exactly matches blueprint's iter-175 pin (including the explicit `[Ring.KrullDimLE 1 ...]` thread)
- **Proof follows sketch**: yes — body is `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` exactly as specified
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (def:divisor_closed_point)
- **Lean target exists**: yes — line 778
- **Signature matches**: yes — iter-174 junk-defined signature with `(C : Scheme.{u}) (P : C) (_hP : IsClosed ({P} : Set C))` returning `C.WeilDivisor` via dependent-if on `Order.coheight P = 1`, matching blueprint's junk-convention description exactly
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (lem:ofClosedPoint_eq_single)
- **Lean target exists**: yes — line 786
- **Signature matches**: yes — bridge equation `ofClosedPoint P hP = Finsupp.single ⟨P, h⟩ 1` for the codim-1 branch, matching blueprint
- **Proof follows sketch**: yes — `simp [ofClosedPoint, h]` unfolds the dependent-if as described
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (lem:ofClosedPoint_eq_zero)
- **Lean target exists**: yes — line 795
- **Signature matches**: yes — off-branch equation returning zero when `Order.coheight P ≠ 1`, matching blueprint
- **Proof follows sketch**: yes
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (def:divisor_degree)
- **Lean target exists**: yes — line 817
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)` for `D : X.WeilDivisor`, matching blueprint's "literal sum of coefficients" scope description
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (thm:divisor_degree_hom)
- **Lean target exists**: yes — line 832
- **Signature matches**: yes — `AddMonoidHom` from `X.WeilDivisor` to `ℤ`, built via `Finsupp.liftAddHom`, matching blueprint
- **Proof follows sketch**: yes — blueprint says "immediate from the definition"; Lean proof body is one-liner via `Finsupp.liftAddHom`
- **notes**: blueprint proof block has no `\leanok` (only statement block has it), consistent with the axiom-clean proof being present but no proof-block leanok having been added; this is fine since there is no `\begin{proof}` block in this theorem environment in the blueprint

---

### `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` (lem:rationalMap_order_finite_support)
- **Lean target exists**: yes — `private theorem rationalMap_order_finite_support` at line 686
- **Signature matches**: yes — `(f : X.functionField) : (Function.support (fun Y : X.PrimeDivisor => Scheme.RationalMap.order Y f)).Finite` under `[IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]`, matching blueprint
- **Proof follows sketch**: partial — f=0 branch is closed axiom-clean (lines 697–701 via `order_zero`); f≠0 branch has `sorry` at line 744, consistent with blueprint's Hartshorne II.6.1 sub-build deferral
- **notes**: **(PRE-EXISTING KNOWN ISSUE)** The `\lean{...}` pin names a `private` declaration; `sync_leanok` may not resolve private decls cleanly (acknowledged in blueprint `% NOTE:` comment). The `\leanok` on the statement block is semantically correct (at least one sorry present = statement formalized). The private scope is a pre-existing issue, not new this iter. **No new action required this iter.**

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (def:principal_divisor)
- **Lean target exists**: yes — line 892
- **Signature matches**: yes — `noncomputable def principal [IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (_hf : f ≠ 0) : X.WeilDivisor`, matching blueprint
- **Proof follows sketch**: yes — uses `Finsupp.ofSupportFinite` with `rationalMap_order_finite_support` as specified
- **notes**: `\leanok` correct; axiom-clean (pending sorry is inside `rationalMap_order_finite_support`, not here)

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (thm:principal_hom)
- **Lean target exists**: yes — line 955
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor` under the expected typeclasses; blueprint says "group homomorphism from multiplicative group of nonzero rational functions to additive group of Weil divisors", which this encodes
- **Proof follows sketch**: yes — blueprint proof: "each Y contributes v_Y with DVR identities `v_Y(fg) = v_Y(f)+v_Y(g)`, `v_Y(1)=0`"; Lean closes via `WithZero.log_mul`, `map_mul`, `WithZero.log_one`, `map_one` coordinate-wise exactly as described
- **notes**: `\leanok` correct; axiom-clean (no sorry in map_one'/map_mul' bodies)

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (thm:principal_deg_zero)
- **Lean target exists**: yes — line 1017
- **Signature matches**: yes — `theorem principal_degree_zero {kbar : Type u} [Field kbar] [IsAlgClosed kbar] (C : Over (Spec (.of kbar))) [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] [IsIntegral C.left] [IsLocallyNoetherian C.left] [Scheme.IsRegularInCodimensionOne C.left] (f : C.left.functionField) (hf : f ≠ 0) : degree (principal f hf) = 0`, matching blueprint's "Curve layer" typeclass set exactly
- **Proof follows sketch**: partial — constant branch (`hconst : ∀ Y, order Y f = 0 → principal = 0`) closed axiom-clean (lines 1030–1040); non-constant branch has `sorry` at line 1052, consistent with the blueprint's "sub-build note" deferral to `morphismToP1OfGlobalSections` (iter-178+)
- **notes**: `\leanok` on statement block is correct (sorry present)

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (def:WeilDivisor_positivePart)
- **Lean target exists**: yes — line 1091
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D`, matching blueprint's `mapRange (n ↦ n ⊔ 0)` description
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct; axiom-clean

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (lem:degree_positivePart_principal_eq_finrank)
- **Lean target exists**: yes — line 1518
- **Signature matches**: yes — Lean signature uses `(ProjectiveLineBar kbar).left.functionField` as the base field and `hLPUnif : ∃ Y₀ : PrimeDivisor, order Y₀ t = 1 ∧ ∀ Y, order Y t > 0 → Y = Y₀` as the uniformiser constraint, matching blueprint's iter-194 refactor v2 description exactly
- **Proof follows sketch**: partial — the "Steps A+B+C" structural reductions (`degree_positivePart_eq_sum_max`, `Finsupp.sum_max_zero_eq_sum_filter_pos`, `principal_apply` bridge) are closed; the ramification-inertia finale has `sorry` at line 1622, matching the blueprint's "Scheme.Hom.ofFunctionFieldEmbedding (no Mathlib constructor as of b80f227)" deferral note
- **notes**: `\leanok` on statement block is correct (sorry present)

---

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (def:linear_equivalence)
- **Lean target exists**: yes — line 1641
- **Signature matches**: yes — `def LinearEquivalence [IsIntegral X] [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X] (D D' : X.WeilDivisor) : Prop := ∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`, matching blueprint statement
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` correct; axiom-clean

---

## sync_leanok verification: 5 new markers

The 5 `\leanok` markers added by `sync_leanok` this iter are the Sub-build 1 (iter-200, axiom-clean) declarations:

| Blueprint block | Lean target | Block type | Correct? |
|---|---|---|---|
| `def:primeDivisor_restrictToOpen` | `Scheme.PrimeDivisor.restrictToOpen` (line 162) | statement | ✓ yes — axiom-clean def, sorry-free |
| `def:primeDivisor_ofOpen` | `Scheme.PrimeDivisor.ofOpen` (line 174) | statement | ✓ yes — axiom-clean def, sorry-free |
| `lem:primeDivisor_equivOpen` | `Scheme.PrimeDivisor.equivOpen` (line 195) | statement | ✓ yes — axiom-clean, both inverses close by rfl |
| `lem:primeDivisor_stalkIso` | `Scheme.PrimeDivisor.stalkIso` (line 210) | statement | ✓ yes — axiom-clean one-liner |
| `thm:isRegularInCodimensionOne_open` | `Scheme.IsRegularInCodimensionOne.instOpen` (line 478) | statement | ✓ yes — real proof, no sorry; no proof block in blueprint so statement-only leanok is complete end-state |

All 5 land on the correct block. None of these theorem environments have an explicit `\begin{proof}...\end{proof}` in the blueprint, so only the statement `\leanok` is generated (semantics: "declaration formalized, at least a sorry present" — actual proofs are sorry-free, so this is a conservative-safe marker). **All 5 verified correct.**

---

## Red flags

### Placeholder / suspect bodies

- `rationalMap_order_finite_support` at line 744: `:= sorry` in the f≠0 branch. Blueprint documents this as a Hartshorne II.6.1 / Stacks 02RV sub-build deferral. **Expected and documented.** Not a new finding.
- `Scheme.WeilDivisor.principal_degree_zero` at line 1052: `:= sorry` in the non-constant branch. Expected; blueprint documents as deferred to morphismToP1 lane.
- `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` at line 1622: `:= sorry` after the structural reductions. Expected; blueprint documents as the ramification-inertia gap.

All three are **pre-existing documented deferrals**, not new red flags introduced this iter.

### Excuse-comments

None of the sorry-bodies carry comments that excuse wrong definitions. The long block comment on `rationalMap_order_finite_support` (lines 703–743) is a structural-blocker note explaining *why* the hypothesis `[IsLocallyNoetherian X]` is insufficient and what the resolution path is — this is diagnostic documentation, not an excuse comment for wrong code.

### Axioms / Classical.choice

None of the iter-201 additions introduce `axiom` declarations. The 4 private `Ring.*` lemmas and `Scheme.Opens.functionFieldIso` are all axiom-clean.

---

## Unreferenced declarations (informational)

The following Lean declarations have no `\lean{...}` reference in the blueprint. Grouped by significance:

### Iter-201 Sub-build 2 declarations (directive focus)

| Declaration | Private? | Should pin? |
|---|---|---|
| `Ring.ord_ringEquiv` (line 247) | **private** | No — private helper, not reachable externally |
| `Ring.nonZeroDivisors_ringEquiv` (line 273) | **private** | No — private helper |
| `Ring.ordMonoidWithZeroHom_ringEquiv` (line 285) | **private** | No — private helper |
| `Ring.ordFrac_ringEquiv` (line 311) | **private** | No — private; algebraic core of Sub-build 2, but appropriately encapsulated |
| `Scheme.Opens.functionFieldIso` (line 380) | **public** | **YES — should pin** (see below) |
| `Scheme.PrimeDivisor.ordFrac_stalkIso_naturality` (line 519) | **private** | No — private packaging of Sub-build 2 for iter-202 Sub-build 3 consumption |

**Finding: `Scheme.Opens.functionFieldIso` (line 380) is a public `noncomputable def` with no `\lean{...}` pin in the blueprint.** It is the bridge between Sub-builds 2 and 3 described in the "End-to-end map" paragraph: *"The full Sub-build 3 closure replaces `e_K` with `Scheme.Opens.functionFieldIso U`"*. It is referenced informally three times in the blueprint (the comment block at line 362 in the .lean file, and twice in the blueprint's Sub-build 2/3 prose) but never via a `\lean{...}` block. As a public declaration that Sub-build 3 consumers will depend on, it merits a dedicated definition block.

### Scaffold/helper declarations (not requiring blueprint pins)

These are infrastructure helpers that don't need `\lean{...}` pins:

- `Scheme.PrimeDivisor.ext` (line 153) — extensionality lemma, helper
- `Scheme.PrimeDivisor.restrictToOpen_point` / `ofOpen_point` (lines 182, 187) — `@[simp]` field-extraction helpers
- `Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk` (line 462) — bridge instance
- `Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk` (line 493) — bridge instance
- `Scheme.RationalMap.order_zero` / `order_mul_of_ne_zero` / `order_inv` / `order_units_inv` / `order_neg` / `order_pow_of_ne_zero` / `order_one` (lines 563–929) — per-Y algebraic identities; all derive from Ring.ordFrac being a K →*₀ ℤᵐ⁰ monoid-with-zero hom; not individually pinned but collectively documented under `def:order_at_point`'s "Mathlib API path"
- `Scheme.WeilDivisor.degree_hom_apply` / `degree_zero` / `degree_add` / `degree_neg` / `degree_sub` (lines 836–870) — corollaries of `degree_hom`
- `Scheme.WeilDivisor.principal_apply` / `principal_one` (lines 906, 934) — structural unfolding helpers
- `Scheme.WeilDivisor.positivePart_zero` / `positivePart_single` / `degree_positivePart_eq_sum_max` / `degree_single` / `one_le_degree_positivePart_principal_of_order_one` (lines 1096–1196) — iteration-specific substrate helpers
- `Finsupp.sum_max_zero_eq_sum_filter_pos` (line 1211) — in `_root_` namespace, Lane I substrate helper
- `instIsLocallyNoetherianProjectiveLineBar` (line 1248) — axiom-clean instance; scaffolding for `degree_positivePart_principal_eq_finrank`
- `isRegularInCodimOneProjectiveLineBar` (line 1264) — complex axiom-clean proof (lines 1264–1481); scaffolding theorem for `degree_positivePart_principal_eq_finrank`

**Note on `isRegularInCodimOneProjectiveLineBar`**: the declaration comment calls this a "typed-sorry theorem" but inspection shows the proof body (lines 1280–1481) contains no `sorry` — it closes the chart-pick + stalk-transfer + DVR-transport chain completely, including the coheight-1 → nonzero-ideal bridge via `Order.IsMax.coheight_eq_zero`. This is a noteworthy achievement. It was previously `sorry`-bearing (demoted from `instance` in iter-196 to avoid silent `sorryAx` propagation); the proof was closed in a subsequent iter. The section comment ("Iter-194 typed-sorry instance scaffolding") is now stale — the scaffolding has become real code. This doesn't need a `\lean{...}` pin but the section header should eventually be updated by the plan agent.

---

## Blueprint adequacy for this file

- **Coverage**: 21/21 `\lean{...}`-pinned declarations have matching Lean targets with correct signatures. Of the remaining unreferenced Lean declarations: ~30 are helper/substrate (acceptable); **1 substantive public declaration is missing a pin** (`Scheme.Opens.functionFieldIso`).
- **Proof-sketch depth**: **adequate** for the pinned declarations. The "End-to-end map" paragraph provides detailed step-by-step decomposition of the Sub-build 1/2/3/terminal-closure chain. The individual Sub-build 2 proofs (private Ring.* lemmas) are not sketch-guided by the blueprint — they are algebraic manipulations correctly left to the prover — consistent with their private status. The `ordFrac_stalkIso_naturality` packaging declaration is similarly appropriate as an internal bridge.
- **Hint precision**: **precise** — every `\lean{...}` pin uses the correct fully-qualified namespace and resolves to a declaration whose signature matches the prose. The `rationalMap_order_finite_support` private-scope issue is pre-existing.
- **Generality**: **matches need** — the Sub-build 2 naturality result (`Ring.ordFrac_ringEquiv`) is at the correct level of generality (Noetherian Krull-dim-≤-1 domains with compatible fraction-field iso), sufficient for its iter-202 Sub-build 3 consumers.
- **Recommended chapter-side actions**:
  1. **(Major)** Add a `\begin{definition}...\end{definition}` block for `Scheme.Opens.functionFieldIso` in the "Open-immersion descent for prime divisors" section (or at the start of "§2 Order"), with `\lean{AlgebraicGeometry.Scheme.Opens.functionFieldIso}`, `\uses{lem:primeDivisor_stalkIso}`, and prose describing it as "canonical isomorphism between the function field of an open subscheme `U ⊆ X` and of `X` for integral `X`, obtained by composing `Scheme.Opens.stalkIso U (genericPoint U.toScheme)` with `stalkCongr` along `genericPoint_eq_of_isOpenImmersion`."
  2. **(Minor)** Update the section comment at line 1225 in `WeilDivisor.lean` ("Iter-194 typed-sorry instance scaffolding") to note that the scaffolding is now axiom-clean; the plan agent can propagate this in the blueprint's "End-to-end map" paragraph.

---

## Severity summary

| Finding | Severity |
|---|---|
| `Scheme.Opens.functionFieldIso` (public, iter-201) missing `\lean{...}` pin in "End-to-end map" section | **major** |
| `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` pins a `private` declaration (pre-existing) | soon |
| Stale section header "typed-sorry instance scaffolding" in `WeilDivisor.lean` L1225 (scaffolding is now real code) | minor |
| All 5 sync_leanok markers land correctly | (no issue) |
| All 21 `\lean{...}` pins resolve with matching signatures | (no issue) |
| 4 private Ring.* Sub-build 2 lemmas correctly not pinned | (no issue) |
| `ordFrac_stalkIso_naturality` private, correctly not pinned | (no issue) |

**Overall verdict**: All 21 blueprint `\lean{...}` pins are correctly resolved and signature-faithful; the 5 new `sync_leanok` markers all land correctly. The primary finding is that the one public iter-201 declaration (`Scheme.Opens.functionFieldIso`) lacks a `\lean{...}` blueprint pin — a major gap since Sub-build 3 (iter-202) will need this as an entry point. No must-fix-this-iter blockers: the missing pin does not block the iter-202 prover work, only the blueprint coverage.
