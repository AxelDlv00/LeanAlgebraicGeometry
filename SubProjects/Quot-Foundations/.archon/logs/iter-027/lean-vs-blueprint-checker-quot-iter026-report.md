# Lean ↔ Blueprint Check Report

## Slug
quot-iter026

## Iteration
027

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration (new iter-026 work)

### `isIso_fromTildeΓ_of_isLocalizedModule_restrict` (no blueprint node)
- **Lean target exists**: yes — at line 614, public theorem in `AlgebraicGeometry`
- **Signature matches**: N/A — no `\lean{...}` blueprint block points to this name
- **Proof follows sketch**: partial — the gap1 proof sketch at `lem:qcoh_affine_isIso_fromTildeΓ`
  (lines 2666–2679) describes exactly this assembly logic, but the blueprint does not have a
  standalone lemma node for the G1-assemble step as an independently-usable lemma
- **Notes**: The Lean declaration packages the "G1-assemble" step: given
  `H : ∀ f, IsLocalizedModule (powers f) (restriction to D(f))`, conclude `IsIso M.fromTildeΓ`.
  This is the assembly described in the gap1 proof sketch. The prover flagged that
  `lem:qcoh_affine_isIso_fromTildeΓ` may need its `\lean{}` re-pointed here — **this is wrong**.
  Gap1's Lean target is `isIso_fromTildeΓ_of_isQuasicoherent` (takes `IsQuasicoherent M`);
  the new Lean decl takes explicit hypothesis H (per-basic-open localization). Different inputs,
  different signatures. The pin should NOT be re-pointed; a new blueprint node is needed instead.

### `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` (no blueprint node)
- **Lean target exists**: yes — at line 653, public theorem in `AlgebraicGeometry`
- **Signature matches**: N/A — no `\lean{...}` blueprint block points to this name
- **Proof follows sketch**: N/A (no blueprint proof body to compare against)
- **Notes**: Packages both directions into a single iff: `IsIso M.fromTildeΓ ↔ ∀ f,
  IsLocalizedModule (powers f) (restriction to D(f))`. Substantive public characterization
  lemma; useful as a reference for downstream G1-core completion. No blueprint node exists.

### `isIso_sheaf_of_isIso_app_basicOpen` (private)
- **Lean target exists**: yes — at line 554, `private theorem`
- **Signature matches**: N/A — private helper, no blueprint pin expected
- **Proof follows sketch**: yes — implements the "isomorphism on each basic open ⟹ isomorphism"
  step mentioned in the gap1 proof sketch (line 2671). Uses
  `PrimeSpectrum.isBasis_basic_opens`, stalk injectivity/surjectivity, and
  `isIso_of_stalkFunctor_map_iso`. Mathematically correct.
- **Notes**: Acceptable uncovered private helper.

### `bijective_comp_of_localizations` (private)
- **Lean target exists**: yes — at line 579, `private theorem`
- **Signature matches**: N/A — private helper, no blueprint pin expected
- **Proof follows sketch**: yes — implements "two localizations of the same module at the same
  submonoid intertwined by the localization maps are uniquely isomorphic" mentioned at blueprint
  line 2677. Uses `IsLocalizedModule.linearEquiv` and `linearMap_ext`. Mathematically correct.
- **Notes**: Acceptable uncovered private helper.

---

## Per-declaration (pre-existing blueprint-pinned decls)

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (`def:hilbert_polynomial`)
- **Lean target exists**: yes — line 123, `noncomputable def`
- **Signature matches**: yes — returns `Polynomial ℚ` keyed by `_s : S`, matches blueprint
- **Proof follows sketch**: N/A — body is `:= sorry` (blueprint `\leanok` on statement only;
  docstring says "iter-176 file-skeleton, body is a typed sorry")
- **Notes**: No red flag — `\leanok` on statement means sorry body is correctly expected.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (`def:quot_functor`)
- **Lean target exists**: yes — line 161, `noncomputable def`
- **Signature matches**: yes — returns `(Over S)ᵒᵖ ⥤ Type u`, matches blueprint
- **Proof follows sketch**: N/A — body `:= sorry`, iter-176 skeleton
- **Notes**: Blueprint `\leanok` on statement; sorry body expected.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (`def:grassmannian_scheme`)
- **Lean target exists**: yes — line 198
- **Signature matches**: yes — returns `(Over S)ᵒᵖ ⥤ Type u`
- **Proof follows sketch**: N/A — body `:= sorry`, iter-176 skeleton
- **Notes**: Blueprint `\leanok` on statement; sorry body expected.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (`thm:grassmannian_representable`)
- **Lean target exists**: yes — line 225
- **Signature matches**: partial — blueprint statement mentions smooth/projective/Plücker structure;
  Lean packages conclusion as `∃ Y : Over S, Nonempty ((Grassmannian V d).RepresentableBy Y)`.
  The blueprint docstring at lines 203–218 acknowledges that smooth/Plücker structure is
  "iter-177+ refinement work"; the weaker Lean conclusion is the intentional skeleton.
- **Proof follows sketch**: N/A — body `:= sorry`, iter-176 skeleton
- **Notes**: Blueprint `\leanok` on statement; the weakening is documented and intentional.
  Not a red flag this iter.

### `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` (`lem:isLocalizedModule_tilde_restrict`)
- **Lean target exists**: yes — line 467
- **Signature matches**: yes — `IsLocalizedModule (powers f) (presheaf restriction of tilde N)`
- **Proof follows sketch**: yes — blueprint proof sketch (lines 2560–2568) matches the Lean
  proof: uses `tilde.toOpen_res`, `tilde.isoTop`, `IsLocalizedModule.of_linearEquiv_right`
- **Notes**: Axiom-clean (confirmed); no issues.

### `\lean{AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ}` (`lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`)
- **Lean target exists**: yes — line 510
- **Signature matches**: yes — takes `[IsIso M.fromTildeΓ]`, concludes `IsLocalizedModule
  (powers f) (restriction of M)`
- **Proof follows sketch**: yes — blueprint sketch (lines 2584–2591) matches the Lean proof:
  uses the component isomorphisms of `ψ = modulesSpecToSheaf.map M.fromTildeΓ`, naturality
  square, and linear-equiv transport of `IsLocalizedModule`
- **Notes**: Axiom-clean; no issues.

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (`lem:annihilator_localization_eq_map`)
- **Lean target exists**: yes — line 362
- **Signature matches**: yes — `annihilator Rₚ Mₚ = (annihilator R M).map (algebraMap R Rₚ)`;
  finite-generation hypothesis correctly present
- **Proof follows sketch**: yes — the two-direction proof in the blueprint matches the Lean
  `le_antisymm` structure
- **Notes**: Axiom-clean; no issues.

### Other pre-existing blueprint-pinned decls (`SheafOfModules.IsLocallyFreeOfRank`, `Scheme.Modules.annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`, `HasProperSupport`)
- **All exist** with matching signatures; all axiom-clean or expected sorry bodies as documented
- **No issues** beyond what was pre-existing

---

## Red flags

### Placeholder / suspect bodies

All four iter-026 new declarations have substantive, closed proofs (no sorry). The four
pre-existing sorry bodies (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
`Grassmannian.representable`) are covered by `\leanok` on statement blocks and are documented
as iter-176 file-skeleton — no red flag.

### Excuse-comments

None of the new declarations carry excuse-comments. The comment at Lean line 119–122
("For the iter-176 file-skeleton the body is a typed `sorry`") is a factual progress note
in the docstring, not an excuse for wrong code.

### Axioms / Classical.choice on non-trivial claims

No new `axiom` declarations. The file uses `classical` (line 369) for `obtain` over a finite
span, which is the standard Lean pattern and not a red flag.

---

## Unreferenced declarations (informational)

Lean declarations that have NO `\lean{...}` blueprint pin:

1. **`isIso_fromTildeΓ_of_isLocalizedModule_restrict`** (public) — substantive G1-assemble
   step; the blueprint's gap1 proof sketch describes exactly this content but as inline prose.
   **Should be a blueprint lemma node** (see Recommended actions below).

2. **`isIso_fromTildeΓ_iff_isLocalizedModule_restrict`** (public) — the iff-packaging of the
   two localization directions. **Should be a blueprint lemma node.**

3. **`isIso_sheaf_of_isIso_app_basicOpen`** (private) — acceptable uncovered helper.

4. **`bijective_comp_of_localizations`** (private) — acceptable uncovered helper.

---

## Blueprint adequacy for this file

- **Coverage**: 11/13 named Lean declarations have a corresponding `\lean{...}` block (the 2
  private helpers are excluded as helpers-only). 2 substantive public declarations are
  unreferenced. Unreferenced private helpers: 2 (acceptable). Unreferenced public: 2 (flagged).

- **Proof-sketch depth**: **adequate for the pre-existing declarations**. The gap1 proof sketch
  (lines 2666–2679) is detailed enough that the four iter-026 private and public helpers could
  be reconstructed. However, the G1-assemble factoring (exposing `H` as an explicit hypothesis
  rather than using QC → G1-core → H inline) is a non-obvious design choice that the blueprint
  does not document at the lemma level, making independent re-derivation uncertain.

- **Hint precision**: **partially wrong for gap1**. The `\lean{}` pin for
  `lem:qcoh_affine_isIso_fromTildeΓ` (line 2644) names
  `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent`, which does NOT exist.
  The NOTE (line 2646) already acknowledges this. The prover's suggestion to re-point the pin to
  `isIso_fromTildeΓ_of_isLocalizedModule_restrict` is **incorrect**: that declaration takes
  `H : ∀ f, IsLocalizedModule ...` (not `IsQuasicoherent M`); re-pointing would mismatch the
  prose. The correct action is to keep the pin as-is (targeting the not-yet-built gap1 declaration)
  and add a NEW lemma node for the G1-assemble step.

- **Generality**: matches need. The blueprint correctly describes the factoring into G1-core +
  G1-assemble; the Lean file correctly factors into these two pieces.

- **G1-core → gap1 → keystone ordering**: acyclic and honest.
  - G1-core (`lem:qcoh_affine_section_localization`) \uses only `lem:isLocalization_basicOpen_mathlib`
  - gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) \uses G1-core + `lem:isLocalizedModule_tilde_restrict`
  - `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` \uses only `lem:isLocalizedModule_tilde_restrict` (NOT gap1 — no cycle)
  - keystone \uses gap1 + `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`
  - No circular dependency found.

- **G1-core adequacy for a future prover**: adequate. Lines 2614–2639 give the 4-step proof
  (cover-refine → local tilde → flat-equalizer descent → conclusion), which is detailed enough
  to guide formalization. This is the genuine Stacks-01HA content.

- **Recommended chapter-side actions**:
  1. Add a standalone lemma node for the G1-assemble step, pinned to
     `AlgebraicGeometry.isIso_fromTildeΓ_of_isLocalizedModule_restrict`. Statement: given
     `H : ∀ f : R, IsLocalizedModule (powers f) (restriction to D(f))`, conclude
     `IsIso M.fromTildeΓ`. Mark `\leanok`. This is the content the blueprint's gap1 proof sketch
     already describes; it deserves its own node now that the Lean declaration exists.
  2. Add a standalone lemma node for the iff-characterization, pinned to
     `AlgebraicGeometry.isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. Statement:
     `IsIso M.fromTildeΓ ↔ ∀ f, IsLocalizedModule (powers f) (restriction)`.
  3. Add a `\uses{lem:G1-assemble}` to `lem:qcoh_affine_isIso_fromTildeΓ` once the new node
     exists, clarifying that gap1 = G1-assemble(H) where H comes from G1-core.
  4. Do NOT re-point `lem:qcoh_affine_isIso_fromTildeΓ` to `isIso_fromTildeΓ_of_isLocalizedModule_restrict`
     (signatures differ; gap1 proper takes IsQuasicoherent, not H).

---

## Severity summary

### major

- **`isIso_fromTildeΓ_of_isLocalizedModule_restrict` uncovered**: substantive public declaration
  (the G1-assemble step) delivered this iter with no blueprint lemma node. A future prover
  targeting this area must re-derive it from the inline proof sketch rather than from a named
  node. The blueprint should add a node (blueprint-writing subagent action needed).

- **`isIso_fromTildeΓ_iff_isLocalizedModule_restrict` uncovered**: substantive public iff
  characterization with no blueprint lemma node. Same issue.

- **Prover suggestion clarification**: the directive notes the prover flagged possible
  re-pointing of `lem:qcoh_affine_isIso_fromTildeΓ` to `isIso_fromTildeΓ_of_isLocalizedModule_restrict`.
  This must NOT happen (signature mismatch). The plan agent should record this correction.

### minor

- The pre-existing stale `\lean{}` pin (`isIso_fromTildeΓ_of_isQuasicoherent` not yet existing)
  is already acknowledged in the blueprint NOTE. Informational only.

- `Grassmannian.representable` body `:= sorry` with weaker conclusion than the blueprint's
  informal statement (smooth/Plücker omitted). Documented as intentional; not a red flag this
  iter but worth tracking.

---

**Overall verdict**: The 4 new iter-026 declarations are axiom-clean, mathematically correct,
and match the blueprint's logical intent; the G1-core → gap1 → keystone dependency chain is
acyclic and honest — but 2 of 4 new public declarations are missing blueprint lemma nodes,
and the prover's suggested `\lean{}` re-pointing is incorrect and should be blocked.
