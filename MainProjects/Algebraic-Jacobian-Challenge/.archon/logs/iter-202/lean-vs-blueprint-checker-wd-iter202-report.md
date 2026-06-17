# Lean ↔ Blueprint Check Report

## Slug
wd-iter202

## Iteration
202

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (1735 lines)
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (1222 lines)

---

## Per-declaration — existing `\lean{...}`-pinned blocks

All 22 pre-existing `\lean{...}` pins were checked. The two new Sub-build 3 declarations
have **no** `\lean{...}` blocks; they are handled separately under "Blueprint adequacy".

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor}` (def:prime_divisor)
- **Lean target exists**: yes (L94, structure)
- **Signature matches**: yes — `point : X`, `coheight : Order.coheight point = 1`
- **Proof follows sketch**: N/A (structure, no proof body)

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (def:codim1_cycles)
- **Lean target exists**: yes (L107, `def`)
- **Signature matches**: yes — `X.PrimeDivisor →₀ ℤ`
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne}` (def:isRegularInCodimensionOne)
- **Lean target exists**: yes (L451, `class`)
- **Signature matches**: yes — one-field `Prop` class, `∀ Y : PrimeDivisor X, IsDiscreteValuationRing (X.presheaf.stalk Y.point)`
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.restrictToOpen}` (def:primeDivisor_restrictToOpen)
- **Lean target exists**: yes (L162, `def`)
- **Signature matches**: yes — `(U : X.Opens) → Y → Y.point ∈ U → U.toScheme.PrimeDivisor`
- **Proof follows sketch**: N/A (definition body uses `Order.coheight_eq_of_isOpenEmbedding`)

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.ofOpen}` (def:primeDivisor_ofOpen)
- **Lean target exists**: yes (L174)
- **Signature matches**: yes
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.equivOpen}` (lem:primeDivisor_equivOpen)
- **Lean target exists**: yes (L195)
- **Signature matches**: yes — `{ Y : X.PrimeDivisor // Y.point ∈ U } ≃ U.toScheme.PrimeDivisor`
- **Proof follows sketch**: yes — both `left_inv` and `right_inv` close by `rfl`, as blueprint states

### `\lean{AlgebraicGeometry.Scheme.PrimeDivisor.stalkIso}` (lem:primeDivisor_stalkIso)
- **Lean target exists**: yes (L210, noncomputable def)
- **Signature matches**: yes — wraps `Scheme.Opens.stalkIso`
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.Scheme.IsRegularInCodimensionOne.instOpen}` (thm:isRegularInCodimensionOne_open)
- **Lean target exists**: yes (L478, `instance`)
- **Signature matches**: yes — transports DVR property via `stalkIso`
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.Scheme.Opens.functionFieldIso}` (def:functionFieldIso)
- **Lean target exists**: yes (L380)
- **Signature matches**: partial — blueprint mentions `[IsIntegral U.toScheme]` as a standing hypothesis, but the Lean signature only has `[IsIntegral X]` and `[Nonempty U]`. In practice `IsIntegral U.toScheme` is likely synthesised transitively, but the blueprint prose lists it explicitly. **Pre-existing minor discrepancy** (predates iter-202).
- **Proof follows sketch**: yes — composes `Scheme.Opens.stalkIso` with `stalkCongr` on `genericPoint_eq_of_isOpenImmersion`

### `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (def:order_at_point)
- **Lean target exists**: yes (L426, noncomputable def)
- **Signature matches**: yes — `WithZero.log (Ring.ordFrac ... f)` with `[IsIntegral X]`, `[IsLocallyNoetherian X]`, explicit `[Ring.KrullDimLE 1 ...]`, junk-on-zero convention
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (def:divisor_closed_point)
- **Lean target exists**: yes (L865)
- **Signature matches**: yes — junk-defined outside coheight-1 regime
- **Proof follows sketch**: N/A (definition)
- **notes**: `ofClosedPoint_eq_single` (L873) and `ofClosedPoint_eq_zero` (L882) are correctly pinned

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}` (lem:ofClosedPoint_eq_single)
- **Lean target exists**: yes (L873)
- **Signature matches**: yes
- **Proof follows sketch**: yes (unfolds dependent-if, one line)

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}` (lem:ofClosedPoint_eq_zero)
- **Lean target exists**: yes (L882)
- **Signature matches**: yes
- **Proof follows sketch**: yes

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (def:divisor_degree)
- **Lean target exists**: yes (L904)
- **Signature matches**: yes — `Finsupp.sum D (fun _ n => n)`
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (thm:divisor_degree_hom)
- **Lean target exists**: yes (L919, `AddMonoidHom`)
- **Signature matches**: yes — `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`
- **Proof follows sketch**: yes — `map_add` and `map_neg` close from the `AddMonoidHom` structure

### `\lean{AlgebraicGeometry.rationalMap_order_finite_support}` (lem:rationalMap_order_finite_support)
- **Lean target exists**: yes (L773, `private theorem`)
- **Signature matches**: yes
- **Proof follows sketch**: partial — the `f = 0` branch is closed (sorry-free); the `f ≠ 0` branch is a USER-blocked sorry (Route C PAUSE pending `[IsNoetherian X]` strengthening). Blueprint §5 "Hypothesis health" paragraph accurately describes this blocker. **No misrepresentation.**
- **notes**: declaration is `private`; the blueprint notes this and explains that `sync_leanok` may not resolve it

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (def:principal_divisor)
- **Lean target exists**: yes (L979)
- **Signature matches**: yes — `Finsupp.ofSupportFinite ... (rationalMap_order_finite_support f)`
- **Proof follows sketch**: N/A (definition)

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (thm:principal_hom)
- **Lean target exists**: yes (L1042, `MonoidHom`)
- **Signature matches**: yes — `(X.functionField)ˣ →* Multiplicative X.WeilDivisor`
- **Proof follows sketch**: yes — `map_one'` closes via `WithZero.log_one`; `map_mul'` via `WithZero.log_mul` with `Units.ne_zero`

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (thm:principal_deg_zero)
- **Lean target exists**: yes (L1104)
- **Signature matches**: yes — full curve-layer typeclass set
- **Proof follows sketch**: partial — constant branch closes sorry-free; non-constant branch is a pending sub-build sorry (gated on finite morphism construction + Hartshorne II.6.9). Blueprint's "Sub-build note" correctly describes this. **No misrepresentation.**

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.positivePart}` (def:WeilDivisor_positivePart)
- **Lean target exists**: yes (L1178)
- **Signature matches**: yes — `Finsupp.mapRange (fun n : ℤ => n ⊔ 0)`
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank}` (lem:degree_positivePart_principal_eq_finrank)
- **Lean target exists**: yes (L1605)
- **Signature matches**: yes — pins to `ProjectiveLineBar kbar` + `hLPUnif` uniformiser hypothesis
- **Proof follows sketch**: partial — Steps A+B+C reduce to the ramification-inertia sum; terminal `sorry` (L1709) is a USER-blocked pending substrate. Blueprint proof body correctly describes the Hartshorne II.6.9 path and flags the `Scheme.Hom.ofFunctionFieldEmbedding` gap. **No misrepresentation.**

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (def:linear_equivalence)
- **Lean target exists**: yes (L1728)
- **Signature matches**: yes — `∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf`
- **Proof follows sketch**: N/A (definition)

---

## Red flags

### Placeholder / suspect bodies

The following `sorry` bodies are all **USER-blocked / Route-C-paused** and the blueprint correctly represents their status (verified above). They are **not** red flags under the checker's rule ("blueprint claims a substantive proof" ← not the case here; the blueprint explicitly marks them as pending sub-builds):

- `rationalMap_order_finite_support` L831: sorry in `f ≠ 0` branch. Route-C-paused; `[IsNoetherian X]` strengthening pending USER approval.
- `principal_degree_zero` L1139: sorry in non-constant branch. Gated on finite morphism + Hartshorne II.6.9.
- `degree_positivePart_principal_eq_finrank` L1709: sorry in ramification-inertia body. Gated on `Scheme.Hom.ofFunctionFieldEmbedding` substrate.
- `isRegularInCodimOneProjectiveLineBar` L1351: no sorry — axiom-clean per iter-196 structural advance.

### Axioms / Classical.choice
None introduced by Sub-build 3. Both new declarations (`functionFieldIso_compat`, `order_eq_order_restrict`) are sorry-free and use only Mathlib lemmas.

---

## Unreferenced declarations (informational)

The following substantive public declarations have no `\lean{...}` blueprint pin:

### Flagged — Sub-build 3 additions lacking `\lean{...}` pins (priority)

- **`Scheme.PrimeDivisor.functionFieldIso_compat`** (L572, `theorem`, sorry-free): described only in the Sub-build 3 prose bullet (blueprint §"End-to-end map" L441–L457 enumerated item). No `\begin{theorem}...\lean{...}` block exists.
- **`Scheme.PrimeDivisor.order_eq_order_restrict`** (L603, `theorem`, sorry-free): described in the same Sub-build 3 bullet (blueprint L458–L465). No `\begin{theorem}...\lean{...}` block exists.

### Flagged — other notable unreferenced public declaration

- **`isRegularInCodimOneProjectiveLineBar`** (L1351, `theorem`, axiom-clean after iter-196 structural advance): closes the per-prime-divisor DVR obligation for `ProjectiveLineBar` via the 2-chart affine cover + Dedekind structure. This is a substantial sorry-free theorem (~220 LOC proof) with no `\lean{...}` pin. Lower priority than the Sub-build 3 items but worth adding a `\lean{...}` block in §"Typed-sorry scaffolding" or a new lemma environment.

### Acceptable helpers (no pin needed)
Instances (`AddCommGroup`, `Inhabited`, `instIsDiscreteValuationRingStalk`, `instKrullDimLEStalk`, `instIsLocallyNoetherianProjectiveLineBar`, `instOpen`), `@[ext]` lemma `PrimeDivisor.ext`, `@[simp]` field-extraction lemmas (`restrictToOpen_point`, `ofOpen_point`), algebraic identities on `order` (`order_zero`, `order_mul_of_ne_zero`, `order_inv`, `order_units_inv`, `order_neg`, `order_pow_of_ne_zero`, `order_one`), structural helpers (`degree_hom_apply`, `degree_zero`, `degree_add`, `degree_neg`, `degree_sub`, `principal_apply`, `principal_one`, `positivePart_zero`, `degree_positivePart_eq_sum_max`, `positivePart_single`, `degree_single`, `one_le_degree_positivePart_principal_of_order_one`, `Finsupp.sum_max_zero_eq_sum_filter_pos`).

---

## Blueprint adequacy for this file

### Focus on Sub-build 3 (iter-202)

**`Scheme.PrimeDivisor.functionFieldIso_compat`** — verified faithful to blueprint prose:

- *Mathematical content*: The Lean statement is the commutativity of the square
  ```
  stalk_U Y ──stalkSpec_U──► functionField U
      |                            |
   stalkIso                   functionFieldIso
      ▼                            ▼
  stalk_X Y ──stalkSpec_X──► functionField X
  ```
  in `CommRingCat`. Blueprint (L448–L456) describes exactly this equation as the step-1 morphism-level compatibility.
- *Proof*: germ-chase via `TopCat.Presheaf.stalk_hom_ext` + `germ_stalkSpecializes` + `Scheme.Opens.germ_stalkIso_hom`. Blueprint references `germ_stalkSpecializes_stalkMap_assoc`; the Lean uses a slightly different decomposition (`germ_stalkIso_hom_assoc` + two `germ_stalkSpecializes`) but arrives at the same commutative diagram. Mathematical content is faithful.
- *Hypotheses*: `[IsIntegral X]`, `[Nonempty U]`, `[IsIntegral U.toScheme]`. The blueprint prose does not enumerate these explicitly for Sub-build 3, but they are consistent with `def:functionFieldIso` and `def:primeDivisor_stalkIso`.
- *Blueprint gap*: **No `\lean{...}` pin.** `sync_leanok` cannot mark this sorry-free theorem.

**`Scheme.PrimeDivisor.order_eq_order_restrict`** — verified faithful to blueprint prose:

- *Mathematical content*: Blueprint (L458–L464) describes: "Naturality of `order` across the stalk iso of Sub-build 1 follows by: `order Y f = order (restrictToOpen U Y h) f'` with `f'` the image of `f`." The Lean states `order Y (functionFieldIso U f) = order (restrictToOpen U Y hYU) f` with `f : U.toScheme.functionField`. This is the same equation written with the iso applied on the opposite side (equivalent by bijectivity). The mathematical content is faithful.
- *Proof*: discharges `h_compat` from `functionFieldIso_compat`, then calls `ordFrac_stalkIso_naturality`. This is exactly the blueprint's "Direct consumer of Sub-build 2" plan.
- *Hypotheses*: `[IsLocallyNoetherian X]`, `[Scheme.IsRegularInCodimensionOne X]` additionally required. These are synthesized by the `ordFrac_stalkIso_naturality` call and the `IsRegularInCodimensionOne.instKrullDimLEStalk` bridge. The blueprint Sub-build 3 bullet does not enumerate the hypothesis strengthening explicitly but the requirements are mathematically necessary.
- *Minor directional note*: The blueprint says `f ∈ X.functionField` maps to `f' ∈ U.functionField`; the Lean takes `f ∈ U.functionField` and applies `functionFieldIso`. Both express the same naturality with the iso direction transposed. **Not a mismatch; minor.**
- *Blueprint gap*: **No `\lean{...}` pin.** `sync_leanok` cannot mark this sorry-free theorem.

### Overall adequacy

- **Coverage**: 22/~52 public Lean declarations have a `\lean{...}` pin. The 2 new Sub-build 3 declarations are substantive sorry-free theorems that should be pinned; the remainder are helpers, instances, or private. **Coverage is adequate for pinned substantive items, except the 2 new Sub-build 3 declarations.**
- **Proof-sketch depth**: **adequate** for the pinned blocks. The Sub-build 3 bullet is detailed enough that the prover could have formalized correctly (the mathematical steps are enumerated), but the lack of `\lean{...}` blocks means the blueprint-sync tooling has no hook.
- **Hint precision**: **precise** for all existing pins. The minor `[IsIntegral U.toScheme]` absence in `functionFieldIso`'s Lean signature vs. blueprint prose is pre-existing and does not affect Sub-build 3.
- **Generality**: **matches need** for both new declarations.
- **Recommended chapter-side actions**:
  1. **(Major)** Add a `\begin{lemma}...\lean{AlgebraicGeometry.Scheme.PrimeDivisor.functionFieldIso_compat}...\end{lemma}` block in the Sub-build 3 section (between the current `def:functionFieldIso` block and the "End-to-end map" paragraph). The statement is the commutativity square for `stalkSpecializes ≫ functionFieldIso = stalkIso ≫ stalkSpecializes`.
  2. **(Major)** Add a `\begin{theorem}...\lean{AlgebraicGeometry.Scheme.PrimeDivisor.order_eq_order_restrict}...\end{theorem}` block in the same section, stating the naturality `order Y (functionFieldIso U f) = order (restrictToOpen U Y hYU) f`. Use `\uses{def:functionFieldIso, lem:primeDivisor_stalkIso}`.
  3. **(Minor)** Consider adding a `\begin{theorem}...\lean{AlgebraicGeometry.isRegularInCodimOneProjectiveLineBar}...\end{theorem}` block in §"Typed-sorry scaffolding" for the sorry-free `isRegularInCodimOneProjectiveLineBar` (iter-196 structural advance, ~220 LOC, currently undocumented in `\lean{...}` blocks).

---

## Severity summary

| Finding | Item | Severity |
|---------|------|----------|
| Missing `\lean{...}` pin | `Scheme.PrimeDivisor.functionFieldIso_compat` | **major** |
| Missing `\lean{...}` pin | `Scheme.PrimeDivisor.order_eq_order_restrict` | **major** |
| Minor directional flip in blueprint prose vs. Lean signature | `order_eq_order_restrict` direction of iso | **minor** |
| Missing `\lean{...}` pin | `isRegularInCodimOneProjectiveLineBar` (pre-existing) | **minor** |
| `[IsIntegral U.toScheme]` mentioned in blueprint prose but absent from Lean `functionFieldIso` signature | `def:functionFieldIso` (pre-existing) | **minor** |

No **must-fix-this-iter** items: both new declarations are sorry-free and mathematically faithful to the blueprint, and none of the pending sorries are misrepresented by the chapter.

**Overall verdict**: Sub-build 3 added 2 sorry-free, mathematically correct declarations whose Lean content faithfully follows the blueprint prose; the chapter's only gaps are the 2 missing `\lean{...}` pins preventing `sync_leanok` from tracking them, which the plan agent should fill this iteration or the next.
