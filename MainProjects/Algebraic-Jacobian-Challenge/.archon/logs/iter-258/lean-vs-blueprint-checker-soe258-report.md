# Lean ↔ Blueprint Check Report

## Slug
soe258

## Iteration
258

## Files audited
- Lean: `AlgebraicJacobian/Picard/SheafOverEquivalence.lean`
- Blueprint: `blueprint/src/chapters/Picard_SheafOverEquivalence.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.overEquivalence}` (chapter: `def:sheafofmodules_over_equivalence`)

- **Lean target exists**: yes — `noncomputable def overEquivalence` at L178
- **Signature matches**: yes — `SheafOfModules ((↑U : Scheme).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U)` matches the blueprint's diagram exactly
- **Proof follows sketch**: yes — assembles `pushforwardPushforwardEquivalence` with `phiOver U`, `psiOver U`, and two sectionwise coherences `H₁`/`H₂` exactly as described; the ring morphism φ is built from `eqToHom (image_overEquiv_functor_obj …).op`, matching the blueprint's "ι.appIso section-level isomorphism" description; continuity comes from the chain dense-subsite → `IsContinuous` by inference, matching the blueprint's "Continuity (no work)" paragraph
- **notes**: CLOSED axiom-clean. The blueprint statement block carries `\leanok`; the proof block is appropriately unmarked (the `sync_leanok` mechanism will add it). The `phiOver`/`psiOver` helpers are `private`; the blueprint mentions them as φ/ψ in prose without `\lean{...}` pins, which is acceptable for private helpers.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.restrictOverIso}` (chapter: `lem:sheafofmodules_restrict_over_iso`)

- **Lean target exists**: yes — `noncomputable def restrictOverIso` at L233
- **Signature matches**: yes — `(overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U` matches the blueprint's diagram
- **Proof follows sketch**: N/A — body is `exact sorry` (L235); the proof has not been started. The blueprint's proof block is not marked `\leanok`, consistent with being open.
- **notes**: KNOWN OPEN sorry (named in directive). The blueprint's `\leanok` on the statement block is correct per marker semantics ("at least a sorry present"). Blueprint proof sketch gives the specific route: `restrictFunctor` = `SheafOfModules.pushforward (ι.opensFunctor)`; compose via `pushforwardComp`; identify two index functors via equality; use `pushforwardNatIso` on `eqToIso`; mirrors `restrictFunctorAdjCounitIso`. This is adequate to guide formalization — the key Mathlib lemma names are stated.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.unitOverIso}` (chapter: `lem:sheafofmodules_unit_over_iso`)

- **Lean target exists**: yes — `noncomputable def unitOverIso` at L249
- **Signature matches**: yes — `(overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf) ≅ SheafOfModules.unit (X.ringCatSheaf.over U)` matches
- **Proof follows sketch**: partial — the proof outer structure is built: `hφ : IsIso (phiOver U)` proven at L258–265 (reflects through `sheafToPresheaf`; sectionwise components are `eqToHom` images hence isos); the `IsIso (unitToPushforwardObjUnit (phiOver U))` reflection chain is set up (L266–276) via `isIso_iff_of_reflects_iso` through `SheafOfModules.forget` → `PresheafOfModules.toPresheaf` → `NatTrans.isIso_iff_isIso_app`; then `asIso(unitToPushforwardObjUnit (phiOver U)).symm` at L277. The single remaining sorry at L276 is the leaf: showing `IsIso` of the application at `W` of the natural transformation after the two reflections (concretely: `IsIso ((overEquivalence U).functor.obj …).val.toPresheaf.app W`).
- **notes**: KNOWN OPEN sorry at L276 (named in directive). The blueprint proof sketch correctly identifies the conceptual approach ("pushforward-of-unit computation produces unit of the codomain ring sheaf up to φ, and φ being an isomorphism makes this a genuine isomorphism") and names `pullbackObjUnitToUnitIso` as the analogue. **However**, the blueprint does NOT name `SheafOfModules.unitToPushforwardObjUnit` or its sectionwise characterisation lemma `unitToPushforwardObjUnit_val_app_apply`. The leaf sorry closes by establishing that, at section `W`, the stalk map equals `(phiOver U).hom.app W` (which is an iso by `hφ`), and reflecting that `RingCat`-iso back up to an `AddCommGrp`-iso — a non-trivial passage that the blueprint does not guide.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.chartOverIso}` (chapter: `lem:chart_over_iso`)

- **Lean target exists**: yes — `noncomputable def chartOverIso` at L299
- **Signature matches**: yes — `(M : X.Modules) → (e : M.restrict U.ι ≅ SheafOfModules.unit (↑U : Scheme).ringCatSheaf) → M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U)` matches; the variable `U : X.Opens` is in scope, consistent with the blueprint's "Let M ∈ Scheme.Modules X and U ⊆ X open"
- **Proof follows sketch**: yes — body is exactly the three-step composite `(restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U`, matching the blueprint's three-arrow diagram step for step
- **notes**: CLOSED (no sorry), despite depending on the two open consumers — the definition telescopes the sorry-bearing `restrictOverIso` and `unitOverIso` without needing them proven. Blueprint statement block has `\leanok`, appropriate.

---

## Red flags

### Placeholder / suspect bodies

- `restrictOverIso` at L235: body is `exact sorry`. Blueprint proof block claims a substantive argument (pushforwardComp + pushforwardNatIso composite). **This is expected OPEN work explicitly named in the directive, not a surprise placeholder.** The proof block has no `\leanok`, confirming the project's open state is correctly represented.

- `unitOverIso` at L276: one `sorry` leaf inside the `NatTrans.isIso_iff_isIso_app` intro. **Also expected OPEN work named in the directive.** The proof block has no `\leanok`.

### Axioms / Classical.choice on non-trivial claims

None found. No `axiom` declarations in the file. The two `sorry`s are confined to the two open proof bodies.

### Excuse-comments

None. The planner strategy comments (L49–91, L210–231, L237–247, L281–297) are forward-looking implementation guides, NOT excuse-comments for wrong or incomplete code; they do not claim closed work is open or vice versa.

---

## Unreferenced declarations (informational)

The following declarations have no `\lean{...}` blueprint pin. All are either `private` or instance-level infrastructure:

| Declaration | Kind | Status |
|---|---|---|
| `overEquivInverseIsContinuous` (L105) | `instance` | Continuity prerequisite for `overEquivalence`; mentioned in blueprint prose ("Continuity (no work)"). Not pinned, acceptable. |
| `overEquivFunctorIsContinuous` (L113) | `instance` | Same as above, symmetric leg. |
| `image_overEquiv_functor_obj` (L123) | `private lemma` | Geometric helper for φ. Private, no pin needed. |
| `phiOver` (L137) | `private def` | Blueprint mentions it as φ; the `\lean{...}` pin for `overEquivalence` covers it. |
| `left_overEquiv_inverse_obj` (L152) | `private lemma` | Geometric helper for ψ. Private. |
| `psiOver` (L160) | `private def` | Blueprint mentions it as ψ. Private. |

None of these are substantive public-API declarations that should be pinned in the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 public declarations have a `\lean{...}` block (`overEquivalence`, `restrictOverIso`, `unitOverIso`, `chartOverIso`). 6 private/instance helpers are unreferenced, all acceptable. **Full coverage.**

- **Proof-sketch depth**: **partially adequate**.
  - For `overEquivalence`: adequate — the continuity chain, the φ construction from `ι.appIso`, and the `pushforwardPushforwardEquivalence` assembly are all named precisely enough that a prover unfamiliar with this file could reproduce the proof.
  - For `restrictOverIso`: adequate — the Mathlib lemmas `pushforwardComp`, `pushforwardNatIso`, `eqToIso`, and the mirror `restrictFunctorAdjCounitIso` are all named. A prover can follow this route.
  - For `unitOverIso` (the open sorry leaf): **under-specified**. The blueprint says "the pushforward-of-unit computation produces unit of the codomain ring sheaf up to φ, and φ being an isomorphism makes this a genuine isomorphism." This correctly identifies the approach but does NOT name:
    1. `SheafOfModules.unitToPushforwardObjUnit` — the canonical comparison map to instantiate
    2. `unitToPushforwardObjUnit_val_app_apply` — the sectionwise characterisation (`(val.app W) = (phiOver U).hom.app W`) that enables the iso reflection
    3. The reflection chain: `isIso_iff_of_reflects_iso` through `SheafOfModules.forget`, then `PresheafOfModules.toPresheaf`, then `NatTrans.isIso_iff_isIso_app`
    4. The `RingCat`→`AddCommGrp` iso reflection at the leaf (the section map is an iso of rings; the proof needs it as an iso of additive groups)
  - For `chartOverIso`: N/A (CLOSED).

- **Hint precision**: **precise** for `overEquivalence` and `chartOverIso`. **Adequate** for `restrictOverIso` (Mathlib names given). **Loose** for `unitOverIso` — the comparison map `unitToPushforwardObjUnit` is not named in the blueprint, leaving the prover to search.

- **Generality**: matches need — the declarations are stated over an arbitrary `{X : Scheme} (U : X.Opens)` and generic `M : X.Modules`; the blueprint matches this generality.

- **Recommended chapter-side actions** (major, not must-fix-this-iter):
  1. In the proof of `lem:sheafofmodules_unit_over_iso`, add: "Concretely, the comparison map is `SheafOfModules.unitToPushforwardObjUnit (phiOver U)`. By `unitToPushforwardObjUnit_val_app_apply` its section at `W` equals `(phiOver U).hom.app W`, which is an iso because `phiOver U` is an iso of ring sheaves. Reflect this sectionwise iso through `SheafOfModules.forget` → `PresheafOfModules.toPresheaf` → `NatTrans.isIso_iff_isIso_app` to obtain `IsIso (unitToPushforwardObjUnit (phiOver U))`; then the desired iso is `asIso(…).symm`." This closes the gap between the conceptual description and the implementation.

---

## Severity summary

- **must-fix-this-iter**: none. Both open sorries are expected workflow items correctly represented in the blueprint and Lean file; no signature mismatches, no axioms, no excuse-comments, no weakened-wrong definitions.

- **major**: one — Blueprint proof sketch for `lem:sheafofmodules_unit_over_iso` does not name `unitToPushforwardObjUnit` or its `_val_app_apply` lemma, nor the reflection chain. A prover working from the blueprint alone would know the conceptual goal but not the specific Lean API path to close the leaf sorry at L276. Recommended action: expand the proof sketch with the concrete Mathlib names (see above).

- **minor**: none.

**Overall verdict**: The Lean file is faithful to the blueprint on all four pinned declarations; `overEquivalence` and `chartOverIso` are closed and match exactly, and the two open sorries are correctly marked as in-progress. The single actionable finding is that the blueprint's proof sketch for `unitOverIso` should name `unitToPushforwardObjUnit` and its `_val_app_apply` characterisation to give the prover a direct path to the remaining leaf.
