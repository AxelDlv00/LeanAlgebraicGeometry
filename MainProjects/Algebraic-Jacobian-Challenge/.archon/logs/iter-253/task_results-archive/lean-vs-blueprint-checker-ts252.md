# Lean ↔ Blueprint Check Report

## Slug
ts252

## Iteration
252

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2031 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Active sorry inventory (3 sorries)

Confirmed by grep:

| Line | Declaration | Status |
|------|-------------|--------|
| 708  | `exists_tensorObj_inverse` | Long-standing, fully documented |
| 1993 | `sheafifyTensorUnitIso_hom_natural` | **NEW iter-252 residual** — element-level step |
| 2022 | `pullbackTensorMap_natural` | Gated on line 1993 |

---

## Per-declaration (blueprint `\lean{...}` blocks relevant to this iter)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (`lem:pullback_tensor_map_natural`, blueprint line 3288)

- **Lean target exists**: yes — line 1999
- **Signature matches**: yes
  The blueprint states the naturality square for `pullbackTensorMap`: `f^*(a ⊗ b) ≫ δ_{M',N'} = δ_{M,N} ≫ f^*a ⊗ f^*b`. The Lean signature is `(pullback f).map (tensorObj_functoriality a b) ≫ pullbackTensorMap f M' N' = pullbackTensorMap f M N ≫ tensorObj_functoriality ((pullback f).map a) ((pullback f).map b)`. Matches.
- **Proof follows sketch**: partial — `sorry` at line 2022, gated on `sheafifyTensorUnitIso_hom_natural`.
  Blueprint says: proof pastes four naturality squares, with the fourth (naturality of `sheafifyTensorUnitIso`) closing by "monoidal interchange (whisker-exchange) law." Lean prover in iter-252 has established this route is **BLOCKED** (see red flag below); the Lean body has `simp only [pullbackTensorMap, tensorObj_functoriality]; sorry`.
- **Blueprint `\leanok` marker on statement block**: yes (line 3285) — correct per the marker vocabulary (at least a sorry present).
- **Blueprint `\leanok` marker on proof block**: absent — correct (proof not closed).
- **Notes**: Partial progress; the lemma is correctly authored and gated on its helper. No false claims made.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (`lem:tensorobj_inverse_invertible`, blueprint line 1616)

- **Lean target exists**: yes — line 686
- **Signature matches**: yes
- **Proof follows sketch**: sorry — documented long-standing; two bridges (C-bridge `dual_isLocallyTrivial` and A-bridge `homOfLocalCompat`) remain. Blueprint accurately describes this.
- **Notes**: No change this iter.

### All other iter-252-relevant `\lean{...}` entries (pullbackTensorMap_unit_isIso, pullbackEtaUnitSquare, isIso_sheafifyEta_of_unitSquare, presheafUnit_comp_map_eta, etc.)

- **All CLOSED axiom-clean**, consistent with the blueprint marking and the iter-252 status note in the file header.
- **Signatures match**, **proofs follow sketches** — no findings.

---

## Red flags

### Placeholder / suspect bodies

- `sheafifyTensorUnitIso_hom_natural` at line 1993: body ends in `sorry` on the element-level ModuleCat interchange. The declaration is not `private` and is a substantive helper for the `\lean{...}`-pinned D1′ lemma. Its sorry is the single remaining element-level step.

  The in-proof comment at lines 1947–1992 documents in detail:
  > "WHISKER ROUTE IS BLOCKED (verified iter-252, lean_multi_attempt): the `η`-whiskers from `sheafifyTensorUnitIso_hom_eq` carry `PresheafOfModules.monoidalCategoryStruct` while the `tensorHom_def`-expanded `p ⊗ₘ q` whiskers carry `monoidalCategory.toMonoidalCategoryStruct` (a defeq-but-non-syntactic projection). `whisker_exchange`/`comp_whiskerRight`/`whiskerLeft_comp` fire only WITHIN a single-instance group and CANNOT bridge the cross-group crossing — NOT even via `erw`..."
  > The section-level route (simp + erw on `.app U`) WORKS for distributing but leaves a final `TensorProduct` element-level identity open.

  This is an in-proof sorry with partial progress — not a trivial `:= sorry`.

- `pullbackTensorMap_natural` at line 2022: `simp only [...]; sorry`. Gated on the above.

### Excuse-comments

None. The in-proof comments are accurate engineering documentation (diagnosed obstacle, next step described), not excuses for wrong code.

### Axioms / Classical.choice

None introduced this iter.

---

## Unreferenced declarations (informational)

The following non-private substantive declarations in the file have no corresponding `\lean{...}` pin in the chapter:

| Declaration | Line | Nature |
|-------------|------|--------|
| `sheafifyTensorUnitIso_hom_natural` | 1914 | Helper for `pullbackTensorMap_natural` (D1′); has sorry |
| `pullbackValIso_hom_natural` | 1879 | Helper for D1′; **CLOSED axiom-clean** |
| `restrictIsoUnitOfLE` | 387 | Helper for `tensorObj_isLocallyTrivial` |
| `tensorObjIsoOfIso` | 256 | Helper for various proofs |
| `tensorObj_unit_iso` | 272 | Building block for unitors (covered implicitly by `lem:tensorobj_unit_iso` prose) |
| `pullbackObjUnitToUnitIso` | 1029 | Helper for `pullbackUnitIso`; closed |
| `sheafifyUnitIso` | 1494 | Helper for D2′ telescope; closed |
| `restrictScalarsId_map` | 1653 | Key syntactic lemma for D2′ `(∗∗)` close |
| `pullbackSheafifyUnitEtaTriangle` | 1703 | Helper for D2′ `(∗∗)`; closed |
| `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` | 1395 | Sub-brick for D2′; closed |
| `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` | 1444 | Sub-brick for D2′; closed |

The most notable: `sheafifyTensorUnitIso_hom_natural` is substantive (contains the sorry that gates D1′) and merits its own `\lean{...}` pin. `pullbackValIso_hom_natural` is a helper that is closed axiom-clean and also merits pinning.

Other entries (`restrictIsoUnitOfLE`, `tensorObjIsoOfIso`, etc.) are acceptable unlisted helpers.

---

## Blueprint adequacy for this file

- **Coverage**: The chapter pins the two primary iter-252 targets correctly. The helper `sheafifyTensorUnitIso_hom_natural` (with an open sorry gating D1′) is not pinned. The helper `pullbackValIso_hom_natural` (closed) is also not pinned. Other substantive helpers for D1′ are likewise absent from `\lean{...}` references.

- **Proof-sketch depth**: **UNDER-SPECIFIED** for `lem:pullback_tensor_map_natural` (D1′), **at the critical step**. The blueprint proof sketch (lines 3310–3329) states:

  > "The fourth square — the naturality of `sheafifyTensorUnitIso` — reduces, once the comparison is expanded into its whisker factors, to the naturality of the sheafification unit η in each tensor argument (the identity p followed by η equals η followed by the sheafification of p), the middle crossings being resolved by the monoidal interchange (whisker-exchange) law."

  This claim is **incorrect as stated**: the Lean prover (iter-252) has verified via `lean_multi_attempt` that the whisker-exchange lemmas (`whisker_exchange`, `comp_whiskerRight`, `whiskerLeft_comp`) **cannot** close the step because the two monoidal-structure instances involved (`PresheafOfModules.monoidalCategoryStruct` and `monoidalCategory.toMonoidalCategoryStruct`) are defeq-but-not-syntactically-equal, and the lemmas only fire within a single-instance group. The correct approach (section-level descent to elements via `PresheafOfModules.Hom.ext` + `simp only` + `erw`, reducing to a ModuleCat element identity) is documented in the Lean file but leaves an open sorry on the final `TensorProduct` step.

  **The blueprint proof sketch actively prescribes an approach the prover has now proved does not work in Lean.** This is a blueprint adequacy failure at must-fix severity: the chapter's proof description of the fourth square must be corrected to (a) note the whisker-exchange route is blocked by the instance split, and (b) describe the correct section-level + element-level strategy.

- **Hint precision**: **precise** for all pinned declarations — names match, types described correctly.

- **Generality**: matches need.

- **Recommended chapter-side actions** (for blueprint-writing subagent):
  1. **Correct the D1′ proof sketch** (`lem:pullback_tensor_map_natural`, lines 3310–3329): Replace "the middle crossings being resolved by the monoidal interchange (whisker-exchange) law" with a description of the section-level route: "descend via `PresheafOfModules.Hom.ext` to sections over each open `U`; use `simp only` + `erw` to distribute `tensorHom_app` and `comp_app`, dissolving the instance abstraction into concrete `ModuleCat` maps; the residual is the `TensorProduct.induction_on` element-identity `(p.app U ≫ η_{P'}.app U = η_P.app U ≫ (a.map p).val.app U)` and `(q.app U ≫ η_{Q'}.app U = η_Q.app U ≫ (a.map q).val.app U)`."
  2. **Add a `\lean{...}` pin** for `AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso_hom_natural` in the D1′ section (it is the substantive helper with the open sorry that gates the pinned D1′ lemma).
  3. **Add a `\lean{...}` pin** for `AlgebraicGeometry.Scheme.Modules.pullbackValIso_hom_natural` (closed helper for D1′ pasting).

---

## Severity summary

### must-fix-this-iter

**Blueprint adequacy failure — `lem:pullback_tensor_map_natural` (D1′) proof sketch prescribes a blocked Lean approach.**

The chapter's proof body for D1′ asserts the fourth naturality square closes by "monoidal interchange (whisker-exchange) law" — but the Lean prover has now established (iter-252) that this approach is definitively blocked by a cross-instance defeq problem in Lean's `PresheafOfModules` monoidal category. The blueprint is actively misleading for any future prover picking up the sorry. The correct approach (section-level element descent) leaves a `TensorProduct` identity open; neither this approach nor its residual is documented in the chapter.

**Action required**: Dispatch blueprint-writing subagent to correct the D1′ proof sketch (`lem:pullback_tensor_map_natural`) and add `\lean{...}` pins for `sheafifyTensorUnitIso_hom_natural` and `pullbackValIso_hom_natural`.

### major

None beyond the must-fix above.

### minor

- `pullbackValIso_hom_natural` (closed, axiom-clean) has no `\lean{...}` pin; it is a substantive named helper for D1′ and merits promotion to the blueprint.
- Several other substantive closed helpers (`sheafifyUnitIso`, `restrictScalarsId_map`, `pullbackSheafifyUnitEtaTriangle`) are unlisted.

---

**Overall verdict**: `pullbackTensorMap_natural` (D1′) is correctly authored and `\lean{}`-pinned with the expected sorry state; the open sorry is gated on the unblueprinted helper `sheafifyTensorUnitIso_hom_natural` (element-level ModuleCat interchange, iter-252 residual). The blueprint proof sketch for D1′ incorrectly prescribes "whisker-exchange" as the closing tactic — this is a must-fix blueprint adequacy finding; the chapter must be corrected to describe the section-level approach and the outstanding element-level residual.
