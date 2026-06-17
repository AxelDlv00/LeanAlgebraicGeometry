# Lean ↔ Blueprint Check Report

## Slug
ocofp

## Iteration
196

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_OCofP.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierPresheaf}` (def:lineBundleAtClosedPoint_carrierPresheaf)
- **Lean target exists**: yes — `private noncomputable def lineBundleAtClosedPoint.carrierPresheaf` at L488
- **Signature matches**: yes — functor `(Opens C.left)ᵒᵖ ⥤ ModuleCat kbar`, values are `carrierSubmoduleSheaf` submodules
- **Proof follows sketch**: yes — case-based restriction (zero on bot, `Submodule.inclusion` otherwise); `map_id` and `map_comp` are axiom-clean, consistent with blueprint's description
- **Notes**: Declaration is `private`. Blueprint appropriately references it as a substrate helper. The `\leanok` marker on the statement block is correct.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierPresheaf_isSheaf}` (lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf)
- **Lean target exists**: yes — `private lemma lineBundleAtClosedPoint.carrierPresheaf_isSheaf` at L577
- **Signature matches**: yes — `Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat) (carrierPresheaf P hPcoh)`
- **Proof follows sketch**: yes — two cases: (A) empty cover via `hcsBot`/`hSubAt0`; (B) nonempty cover via `inter_ne_bot` irreducibility argument and `key_val` uniformity. Both case A and case B are fully worked out with no sorry.
- **Notes**: Declaration is `private`. The full proof is axiom-clean. Blueprint says `\leanok` on statement; no proof block in blueprint (definition-style lemma). Consistent.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.carrierSubmoduleSheaf}` (def:lineBundleAtClosedPoint_carrierSubmoduleSheaf)
- **Lean target exists**: yes — `private noncomputable def lineBundleAtClosedPoint.carrierSubmoduleSheaf` at L388
- **Signature matches**: yes — `carrierSubmodule P hPcoh U ⊓ trivAtBot U`, enforcing `F(⊥) = 0`
- **Proof follows sketch**: N/A (definition body)
- **Notes**: Declaration is `private`. Blueprint correctly describes the `⊓ trivAtBot` construction and its motivation.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint}` (def:lineBundleAtClosedPoint)
- **Lean target exists**: yes — `noncomputable def lineBundleAtClosedPoint` at L806
- **Signature matches**: yes — takes `P : C.left`, `_hP : IsClosed ({P} : Set C.left)`, `hPcoh : Order.coheight P = 1`; returns `Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`
- **Proof follows sketch**: N/A (definition is the pair `⟨carrierPresheaf P hPcoh, carrierPresheaf_isSheaf P hPcoh⟩`)
- **Notes**: Body is substantive and axiom-clean. Blueprint's `\leanok` on statement is correct.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}` (def:lineBundleAtClosedPoint_toFunctionField)
- **Lean target exists**: yes — `noncomputable def lineBundleAtClosedPoint.toFunctionField` at L848
- **Signature matches**: yes — takes `s : Scheme.HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 0`, returns `C.left.functionField`
- **Proof follows sketch**: yes — 4-step chain: `HModule_zero_linearEquiv → sheafToPresheaf.map → constantSheafAdj → Subtype.val`; matches blueprint's layer (1)–(5) description
- **Notes**: Body is substantive and axiom-clean. Blueprint `\leanok` on statement is correct.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff}` (lem:lineBundleAtClosedPoint_globalSections_iff)
- **Lean target exists**: yes — `lemma globalSections_iff` at L1095 (within `namespace lineBundleAtClosedPoint`)
- **Signature matches**: yes — iff between order conditions `(∀ Q ≠ P, 0 ≤ order Q f) ∧ -1 ≤ order ⟨P, hPcoh⟩ f` and existence of a global section mapping to `f`
- **Proof follows sketch**: yes — combinator `⟨globalSections_iff_mp, globalSections_iff_mpr⟩`; both directional helpers (L923, L1024) are axiom-clean
- **Notes**: Blueprint marks both statement and proof as `\leanok`. Correct.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.h1_vanishing_genusZero}` (lem:H1_vanishing_lineBundleAtClosedPoint_genusZero)
- **Lean target exists**: yes — `lemma h1_vanishing_genusZero` at L1147
- **Signature matches**: yes — `Module.finrank kbar (Scheme.HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 1) = 0` under genus-0 hypothesis
- **Proof follows sketch**: no — body is bare `sorry`. Blueprint has statement `\leanok` but no proof `\leanok`. Consistent — this is a known substrate-gated sorry (LES + skyscraper cohomology substrate).
- **Notes**: Expected sorry. Directive confirms off-critical-path, substrate-gated on OcOfD + RRFormula lanes. No finding.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.dim_eq_two_of_genusZero}` (thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero)
- **Lean target exists**: yes — `theorem dim_eq_two_of_genusZero` at L1247
- **Signature matches**: yes — `Module.finrank kbar (Scheme.HModule kbar (lineBundleAtClosedPoint P hP hPcoh) 0) = 2` under genus-0 hypothesis
- **Proof follows sketch**: yes — delegates to `h1_vanishing_genusZero` (H¹ = 0) and `h0_sub_h1_lineBundleAtClosedPoint_eq_two` (χ-arithmetic), then combines via `Int → Nat` cast. Direct proof body has no sorry.
- **Notes**: Blueprint has `\leanok` on both statement and proof. The proof body is sorry-free (delegates to named substrate helpers that carry the sorries). Correct by `sync_leanok` semantics.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField_injective}` (lem:lineBundleAtClosedPoint_toFunctionField_injective)
- **Lean target exists**: yes — `private lemma toFunctionField_injective` at L1287
- **Signature matches**: yes — `Function.Injective (Scheme.lineBundleAtClosedPoint.toFunctionField P hP hPcoh)`
- **Proof follows sketch**: yes — 5-step chain peeling `Subtype.val` (Subtype.ext), `homEquiv_unit` rewrite, `LinearMap.ext_ring`, `adj.homEquiv.injective`, `HModule_zero_linearEquiv.injective`. Matches blueprint's layer (1)–(5) proof sketch exactly. Axiom-clean.
- **Notes**: iter-196 new addition. Declaration is `private`. Blueprint has statement `\leanok` (no proof block marked). Statement marker is correct.

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection}` (lem:lineBundleAtClosedPoint_order_conditions_of_globalSection)
- **Lean target exists**: **NO** — no standalone declaration by this name exists in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: The mathematical content (applying `globalSections_iff_mpr` with witness `⟨s, hf_def.symm⟩`) is inlined as `have h_orders` at L1594–1595 inside `exists_nonconstant_rational_from_dim_eq_two`. The blueprint sub-claim (b) expected this to be extracted as a standalone named declaration, but the iter-196 prover left it inlined. **See Red flags.**

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant}` (lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant)
- **Lean target exists**: **NO** — no standalone declaration by this name exists in either `OCofP.lean` or `WeilDivisor.lean`
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: The blueprint sub-claim (c) expected a standalone extraction. The contrapositive logic is inlined (L1596–1635 of `exists_nonconstant_rational_from_dim_eq_two`). The Mathlib gap substep was extracted as the private helper `functionField_const_of_complete_curve_of_orderZero` (L1390, sorry), but the outer lemma `principal_ne_zero_of_nonconstant` was not created. **See Red flags.**

### `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero}` (cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero)
- **Lean target exists**: yes — `theorem exists_nonconstant_genusZero` at L1679
- **Signature matches**: yes — `∃ (f : C.left.functionField) (hf : f ≠ 0), (∀ Q ≠ P, 0 ≤ order Q f) ∧ -1 ≤ order ⟨P, hPcoh⟩ f ∧ WeilDivisor.principal f hf ≠ 0`
- **Proof follows sketch**: yes — one-line delegation to `exists_nonconstant_rational_from_dim_eq_two` supplied with `dim_eq_two_of_genusZero`. Direct proof body has no sorry.
- **Notes**: Blueprint has `\leanok` on both statement and proof. The proof body is sorry-free. Correct.

---

## Red flags

### Placeholder / suspect bodies

- `h1_vanishing_genusZero` at L1154: body is `:= by sorry`. This is an expected substrate-gated sorry (directive-confirmed, LES + skyscraper cohomology). Blueprint correctly has statement `\leanok` only (no proof `\leanok`). **Not a finding.**

- `h0_sub_h1_lineBundleAtClosedPoint_eq_two` at L1219 (private): body is `:= by sorry`. Private helper gated on OcOfD.lean (STRUCTURALLY BLOCKED) + RRFormula.lean χ-additivity. Directive-confirmed off-critical-path. Blueprint has a `% NOTE` annotation acknowledging these substrate helpers. **Not a finding.**

- `functionField_const_of_complete_curve_of_orderZero` at L1430 (private): body is `:= by sorry`. Documented Mathlib gap (Stacks 02P0 / Hartshorne I.3.4). Blueprint proof of sub-claim (c) explicitly acknowledges this as a Mathlib-infrastructure gap requiring future Lean landing. **Not a finding for the sorry itself.** The named extraction is correct design.

### Missing declarations (blueprint `\lean{...}` pins to non-existent Lean targets)

**MAJOR — `order_conditions_of_globalSection` absent:** Blueprint lemma `lem:lineBundleAtClosedPoint_order_conditions_of_globalSection` carries `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.order_conditions_of_globalSection}` (blueprint line 775), but this declaration does not exist as a standalone Lean lemma. The iter-196 prover left the content inlined in `exists_nonconstant_rational_from_dim_eq_two` as `have h_orders := globalSections_iff_mpr ... ⟨s, hf_def.symm⟩` (L1594–1595) rather than extracting it. The `\lean{...}` pin is therefore broken.

**MAJOR — `principal_ne_zero_of_nonconstant` absent:** Blueprint lemma `lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant` carries `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_ne_zero_of_nonconstant}` (blueprint line 827), but this declaration does not exist anywhere. The contrapositive proof (sub-claim (c)) is inlined in `exists_nonconstant_rational_from_dim_eq_two` (L1596–1635). The substrate step was extracted as `functionField_const_of_complete_curve_of_orderZero` (different name; not what the blueprint pins).

### Broken blueprint `\uses{...}` reference

**MAJOR — `\leanok` embedded inside `\uses{...}` argument:** In the proof block of `lem:lineBundleAtClosedPoint_toFunctionField_injective` (blueprint lines 692–695):

```latex
\begin{proof}
  \uses{lem:lineBundleAtClosedPoint_globalSections_iff,
  \leanok
        def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}
```

The `\leanok` macro is injected as a mid-argument token inside `\uses{...}`, breaking the blueprint parser's dependency-label resolution. The label `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` itself exists correctly (defined at blueprint line 158); this is a formatting error, not a missing label. This is what the blueprint doctor flagged as a broken `\uses{...def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}` reference.

**Fix:** Move `\leanok` to a separate line immediately after the `\uses{...}` block closes, e.g.:
```latex
\begin{proof}
  \uses{lem:lineBundleAtClosedPoint_globalSections_iff,
        def:lineBundleAtClosedPoint_carrierSubmoduleSheaf}
  \leanok
  The map \(\iota\) factors...
```

---

## Unreferenced declarations (informational)

The following Lean declarations have no direct `\lean{...}` pin in the blueprint. All are `private` helpers that are reasonable to omit from the public blueprint API:

- `lineBundleAtClosedPoint.carrierSet` (L153) — underlying set-carrier; blueprint describes it in prose but does not pin it.
- `lineBundleAtClosedPoint.carrierSet_mono` (L181) — monotonicity; blueprint mentions it by name in prose.
- `lineBundleAtClosedPoint.instNonemptyTopOpen` (L199) — instance; internal setup.
- `lineBundleAtClosedPoint.instAlgebraKbarFunctionField` (L213) — instance; internal setup.
- `lineBundleAtClosedPoint.carrierSubmodule` (L238) — raw (pre-bot-fix) submodule; blueprint references `carrierSubmoduleSheaf` instead.
- `lineBundleAtClosedPoint.trivAtBot` (L364) — bot-trivialization; blueprint describes the construction inline in `carrierSubmoduleSheaf` prose.
- `lineBundleAtClosedPoint.carrierSubmoduleSheaf_le` (L405) — monotonicity for sheaf-corrected carrier; internal.
- `lineBundleAtClosedPoint.carrierTypeSubfunctor` (L439) — Subfunctor structure; iter-189 restructure helper; blueprint describes the approach in `carrierPresheaf_isSheaf` prose but does not pin it separately.
- `globalSections_iff_mp` (L923), `globalSections_iff_mpr` (L1024) — directional helpers for `globalSections_iff`; appropriately private.
- `h0_sub_h1_lineBundleAtClosedPoint_eq_two` (L1209) — χ-arithmetic helper for `dim_eq_two_of_genusZero`; substrate sorry; noted in blueprint `% NOTE` comment.
- `functionField_const_of_complete_curve_of_orderZero` (L1390) — Mathlib-gap sorry for Stacks 02P0; blueprint prose describes it in proof of sub-claim (c) but it differs from the pinned name `principal_ne_zero_of_nonconstant`.
- `exists_nonconstant_rational_from_dim_eq_two` (L1479) — substantive inner helper; blueprint routes through the public `exists_nonconstant_genusZero` corollary.

---

## Blueprint adequacy for this file

- **Coverage**: 10/12 Lean public-facing declarations have a corresponding `\lean{...}` block (the 2 missing ones are `order_conditions_of_globalSection` and `principal_ne_zero_of_nonconstant`, which the blueprint pins but Lean doesn't have). The ~14 private helpers are appropriately treated as internal.

- **Proof-sketch depth**: **adequate** for the formalized declarations. The `toFunctionField_injective` sketch (5-layer chain, ~50 LOC estimate) was followed faithfully. The `carrierPresheaf_isSheaf` case-B approach via irreducibility is described well enough in the blueprint comment block (though not in a formal `\begin{proof}` block). The `globalSections_iff` directional helpers are well-guided. The substrate-gated sorries (`h1_vanishing_genusZero`, `h0_sub_h1...`) are correctly described as blocked.

- **Hint precision**: **precise** for all formalized declarations. The `\lean{...}` names match the Lean declarations where the declarations exist. The two missing declarations (`order_conditions_of_globalSection`, `principal_ne_zero_of_nonconstant`) are pinned to names that do not yet exist — these are blueprint-side ahead-of-Lean references.

- **Generality**: **matches need** — no parallel API issues observed.

- **Recommended chapter-side actions**:
  1. **Remove `\leanok` from inside `\uses{...}` argument** in the proof block of `lem:lineBundleAtClosedPoint_toFunctionField_injective` (blueprint lines 692–695). Place `\leanok` on its own line after the `\uses{...}` closes. This fixes the blueprint doctor's broken-reference report.
  2. **Update `lem:lineBundleAtClosedPoint_order_conditions_of_globalSection`**: either (a) extract `order_conditions_of_globalSection` as a named Lean declaration (small, ~10 LOC), or (b) update the blueprint to remove the `\lean{...}` pin and reference the inlined step via a `% NOTE` comment.
  3. **Update `lem:lineBundleAtClosedPoint_principal_ne_zero_of_nonconstant`**: either (a) extract `WeilDivisor.principal_ne_zero_of_nonconstant` as a named Lean declaration (gated on `functionField_const_of_complete_curve_of_orderZero` sorry), or (b) update the blueprint `\lean{...}` to reference `functionField_const_of_complete_curve_of_orderZero` (the actually-extracted helper) and note that the outer lemma is still inlined.

---

## Severity summary

| # | Finding | Severity |
|---|---------|----------|
| 1 | `order_conditions_of_globalSection` — blueprint `\lean{...}` pin targets a non-existent standalone Lean declaration; content inlined in `exists_nonconstant_rational_from_dim_eq_two` | **major** |
| 2 | `principal_ne_zero_of_nonconstant` — blueprint `\lean{...}` pin targets a non-existent standalone Lean declaration; partial content inlined, Mathlib-gap substep extracted under different name | **major** |
| 3 | `\leanok` embedded inside `\uses{...}` argument in proof block of `lem:lineBundleAtClosedPoint_toFunctionField_injective` (blueprint lines 692–695) — breaks blueprint dependency resolution | **major** |
| 4 | `carrierPresheaf`, `carrierPresheaf_isSheaf`, `carrierSubmoduleSheaf` are `private` Lean declarations but are `\lean{...}`-pinned in the blueprint | **minor** |

No **must-fix-this-iter** findings. The Lean file contains no wrong signatures, no excuse-comments, no unauthorized axioms, and no structurally-wrong definitions. The mathematical content for all blueprint claims is present and correct; the major findings are blueprint-reference housekeeping.

**Overall verdict**: The Lean file is substantially faithful to the blueprint. Three major issues require blueprint-side repair (two broken `\lean{...}` pins to non-existent declarations for sub-claims (b) and (c), and one `\leanok`-inside-`\uses` formatting bug that explains the blueprint doctor's broken-reference report). The iter-196 additions (`toFunctionField_injective` axiom-clean close, `functionField_const_of_complete_curve_of_orderZero` named Mathlib-gap sorry, sub-claims (a)+(b) closes) are correctly implemented and faithful to the blueprint intent.
