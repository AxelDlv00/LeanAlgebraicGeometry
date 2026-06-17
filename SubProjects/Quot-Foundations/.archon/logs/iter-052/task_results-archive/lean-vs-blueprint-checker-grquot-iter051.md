# Lean ↔ Blueprint Check Report

## Slug
grquot-iter051

## Iteration
051

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : (SheafOfModules.unit X.ringCatSheaf).sections`; blueprint says "a ∈ Γ(X, O_X) determines a global section of the unit module"; exact match.
- **Proof follows sketch**: yes — body constructs the section via `PresheafOfModules.sectionsMk` restricting `a` to each open; compatible with blueprint's "on each open V take the restriction a|_V".
- **notes**: Non-sorry, closed. ✓

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes
- **Signature matches**: yes — `(a : Γ(X, ⊤)) : SheafOfModules.unit X.ringCatSheaf ⟶ SheafOfModules.unit X.ringCatSheaf`; blueprint says "scalar endomorphism … under End(1) ≅ Γ(X,1)"; matches.
- **Proof follows sketch**: yes — body uses `unitHomEquiv.symm (globalUnitSection a)`, which is the exact canonical identification cited in the blueprint.
- **notes**: Non-sorry, closed. ✓

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` (def:gr_chart_quotient)
- **Lean target exists**: yes
- **Signature matches**: yes — source `SheafOfModules.free (Fin r)`, target `SheafOfModules.free (Fin d)`, on the affine chart of `(d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d)`; blueprint says `u^I : O_{U^I}^r → O_{U^I}^d` by the universal matrix; matches.
- **Proof follows sketch**: yes — body assembles `scalarEnd` of each matrix entry via `biproduct.matrix`, which is exactly the "entry-by-entry assembly via the finite biproduct" route described in the blueprint's Realisation paragraph.
- **notes**: Non-sorry, closed. ✓

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_epi}` (lem:gr_chartQuotientMap_epi)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d r : ℕ) (I : Finset (Fin r)) (hI : I.card = d) : Epi (chartQuotientMap d r I hI)`; blueprint says "u^I is an epimorphism of sheaves of modules"; exact match.
- **Proof follows sketch**: yes — blueprint proof constructs the section `s_I = freeMap (i ↦ I.orderIsoOfFin hI i)` and verifies `u^I ∘ s_I = id` by checking on each coordinate; Lean proof does exactly this via `Cofan.IsColimit.hom_ext` + `chartQuotientMap_ιFree` per coordinate + `IsSplitEpi.mk'`. Mathematical content identical.
- **notes**: Non-sorry, closed. ✓ **Minor**: blueprint proof block for `lem:gr_chartQuotientMap_epi` lacks `\leanok` despite proof being closed; this is `sync_leanok` domain, not review-agent domain — flag for infrastructure.

### `\lean{AlgebraicGeometry.Scheme.Modules.glue}` (def:scheme_modules_glue)
- **Lean target exists**: yes
- **Signature matches**: **partial** — see C1/C2 analysis below.
- **Proof follows sketch**: N/A (body is `:= sorry`, scaffold).
- **notes**: Body is `:= sorry` with honest scaffold comment. Blueprint `\leanok` on statement block is consistent (sorry-present = `\leanok` on statement). **MAJOR finding: C2 hypothesis absent — see Red Flags.**

#### C1/C2 analysis (directive focus)

The blueprint (`def:scheme_modules_glue`) explicitly names **both** cocycle conditions as required hypotheses on the family `(g_{ij})`:

> (C1) self-identity: `g_{ii} = id`  
> (C2) triple-overlap multiplicativity: `g_{jk} ∘ g_{ij} = g_{ik}`

The Lean signature carries `_hC1` (C1, formalised as `∀ i, g i i = eqToIso (...)`) but has **no C2 parameter**. The body is `:= sorry`. The Lean file's own doc-comment acknowledges this:

> "NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled; the transition data `g` (per-overlap pullback isos) is recorded in the signature, the multiplicative cocycle conditions remain to be added before the construction is closed."

Assessment: the Lean signature is **not yet faithful** to the blueprint. C2 is a stated hypothesis in the blueprint's definition, absent from the Lean signature. This is an acknowledged, documented scaffold gap — not an excuse comment or fake signature — but it is a partial signature mismatch.

**Recommended blueprint action**: add a `% NOTE` to `def:scheme_modules_glue` in the blueprint recording that the Lean scaffold currently carries only C1 (`_hC1`); C2 (triple-overlap multiplicativity) is pending and must be added to the signature before the `sorry` body can be filled.

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (def:gr_universal_quotient_sheaf)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d r : ℕ) : (scheme d r).Modules`; blueprint defines `U` as a locally free O_{Gr(d,r)}-module of rank d; the type `(scheme d r).Modules` is the correct Lean type for a sheaf of modules on `Gr(d,r)`.
- **Proof follows sketch**: N/A (`:= sorry`, scaffold).
- **notes**: Honest scaffold. Doc-comment: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Blueprint `\leanok` on statement is consistent. ✓

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def:tautological_quotient)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d r : ℕ) : SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶ universalQuotient d r`; blueprint says `u : O_{Gr(d,r)}^r ↠ U`, i.e. a morphism from the free rank-r sheaf to U; matches.
- **Proof follows sketch**: N/A (`:= sorry`, scaffold).
- **notes**: Honest scaffold. Doc-comment: "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Blueprint `\leanok` on statement is consistent. ✓

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (def:grassmannian_functor)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type`; blueprint says "contravariant functor from schemes to sets"; `Scheme.{0}ᵒᵖ ⥤ Type` is exactly a contravariant functor to sets (universe 0 consistent with blueprint's base-ring setup). Matches.
- **Proof follows sketch**: N/A (`:= sorry`, scaffold).
- **notes**: Honest scaffold. Doc-comment: "NOTE (scaffold): body (the quotient-of-`Setoid` on rank-d quotients + pullback functoriality) to be filled; reuses `SheafOfModules.IsLocallyFreeOfRank`." Blueprint `\leanok` on statement is consistent. ✓

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes
- **Signature matches**: yes — `(d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) : (functor d r).RepresentableBy (scheme d r)`; blueprint says "Gr(d,r) represents Grass(r,d)" with assumption r ≥ d ≥ 1; `RepresentableBy` is the Mathlib type encoding the natural bijection `Hom(T, Gr(d,r)) ≅ Grass(r,d)(T)`. Matches. Hypotheses `hd`, `hdr` correspond to the blueprint's `r ≥ d ≥ 1`.
- **Proof follows sketch**: N/A (`:= sorry`, scaffold).
- **notes**: Honest scaffold. Doc-comment: "NOTE (scaffold): body (the local-to-global inverse construction of Nitsure §1) to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." Blueprint `\leanok` on statement (not proof block) is consistent with `:= sorry`. ✓

---

## Red flags

### Partial signature mismatch
- `Scheme.Modules.glue` (line 183): **C2 (triple-overlap multiplicativity) is absent from the Lean signature** but is listed as a required hypothesis in the blueprint's `def:scheme_modules_glue`. The body is `:= sorry` and the Lean doc-comment explicitly acknowledges C2 is pending ("the multiplicative cocycle conditions remain to be added before the construction is closed"). This is an **honest, documented scaffold gap** — not an excuse comment — but it is a partial signature mismatch with the blueprint that requires a `% NOTE` annotation.

### Placeholder bodies (`:= sorry`) — informational, not red flags
The following 5 declarations have `:= sorry` bodies with honest scaffold comments and consistent blueprint `\leanok` on their statement blocks:
- `Scheme.Modules.glue` (line 193)
- `universalQuotient` (line 207)
- `tautologicalQuotient` (line 215)
- `functor` (line 227)
- `represents` (line 237)

None of these is a fake or misleading placeholder: each doc-comment correctly states what is pending and why the body is deferred. The blueprint marks these at `\leanok` on the statement block (meaning "at least a sorry present"), which is consistent. These are NOT red flags by project convention — they are expected scaffold state for declarations pending a prerequisite (`glue`).

### Axioms / Classical.choice
None found.

### Excuse-comments
None found. All `NOTE (scaffold)` comments are factually accurate and non-misleading.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Kind | Status |
|---|---|---|
| `scalarEnd_one` | `lemma` | Internal helper; used in `chartQuotientMap_ιFree` proof (lines 137-138) to identify diagonal matrix entries as the identity endomorphism. Pure lemma about `scalarEnd`. |
| `scalarEnd_zero` | `lemma` | Internal helper; used in `chartQuotientMap_ιFree` proof (line 138) to identify off-diagonal matrix entries as the zero endomorphism. |
| `chartQuotientMap_ιFree` | `private lemma` | Internal helper for `chartQuotientMap_epi`; proves `ιFree (I.orderIsoOfFin hI k) ≫ chartQuotientMap = ιFree k`. The blueprint's proof sketch for `chartQuotientMap_epi` covers this step at a higher level ("the (p,k)-component of u^I ∘ s_I is the I-th minor of X^I… the identity"). Extracting it as a private lemma is appropriate and does not require a blueprint block. |

None of these warrant a blueprint block: `scalarEnd_one` / `scalarEnd_zero` are sub-lemmas below the blueprint's abstraction level; `chartQuotientMap_ιFree` is private and fully subsumed by the `chartQuotientMap_epi` proof block.

---

## Blueprint adequacy for this file

- **Coverage**: 9/12 public-namespace declarations have a corresponding `\lean{...}` block. The 3 unreferenced declarations (`scalarEnd_one`, `scalarEnd_zero`, `chartQuotientMap_ιFree`) are all helpers or private — acceptable.
- **Proof-sketch depth**: **adequate**. The `def:gr_chart_quotient` Realisation paragraph and the `lem:gr_chartQuotientMap_epi` proof block provide enough detail (entry-by-entry biproduct assembly, I-minor = identity, split-epi argument) to have guided the Lean proofs correctly.
- **Hint precision**: **precise** for all 9 referenced declarations; `\lean{...}` names match Lean identifiers exactly.
- **Generality**: **matches need** — the blueprint's formulation covers the level of generality the Lean file uses (arbitrary `d`, `r`, `I`; scheme-level free sheaves; `SheafOfModules.free`).
- **Recommended chapter-side actions**:
  1. **(review agent)** Add `% NOTE: C2 (triple-overlap multiplicativity hypothesis) is not yet present in the Lean signature of `AlgebraicGeometry.Scheme.Modules.glue`; the Lean scaffold carries only C1 (`_hC1`). C2 must be added to the signature before the sorry body can be filled.` to the `def:scheme_modules_glue` block.
  2. **(sync_leanok / infrastructure)** `\leanok` is present on the statement block of `lem:gr_chartQuotientMap_epi` but **absent from the proof block** — however the Lean proof is closed (non-sorry). `sync_leanok` should add `\leanok` to the proof block of `lem:gr_chartQuotientMap_epi`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `glue`: C2 hypothesis absent from Lean signature (acknowledged scaffold gap, `% NOTE` needed in blueprint) | **major** |
| Proof block of `lem:gr_chartQuotientMap_epi` missing `\leanok` despite proof being closed (sync_leanok domain) | **minor** |
| 5 `:= sorry` scaffolds consistent with `\leanok`-statement blueprint markers | informational (not red flags) |
| 3 unreferenced helpers (`scalarEnd_one`, `scalarEnd_zero`, `chartQuotientMap_ιFree`) | informational |

**Overall verdict**: One major finding (`glue` signature missing C2, acknowledged as pending in the Lean comment and requiring a `% NOTE` in the blueprint); no must-fix issues; all 5 sorry-scaffolds are honest and faithful to their blueprint statements; the 4 closed declarations (`globalUnitSection`, `scalarEnd`, `chartQuotientMap`, `chartQuotientMap_epi`) match the blueprint in both signature and proof strategy.
