# Lean ↔ Blueprint Check Report

## Slug
csi-iter063

## Iteration
063

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks `lem:pushPull_binary_coprod_prod`, `lem:pushPull_binary_leg_coherence`,
  `lem:pushPull_coprod_prod`, `lem:pushPull_sigma_iso`, `lem:pushPull_eval_prod_iso`,
  `lem:cechSection_complex_iso`, `lem:cechSection_contractible`,
  plus the new `sigmaOptionIso` helper)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushPull_binary_coprod_prod}` (chapter: `lem:pushPull_binary_coprod_prod`)
- **Lean target exists**: yes — `noncomputable def pushPull_binary_coprod_prod` at line 855.
- **Signature matches**: yes — both state `pushPullObj F (Over.mk (coprod.desc Y₀.hom Y₁.hom)) ≅ pushPullObj F Y₀ ⨯ pushPullObj F Y₁` in `X.Modules`.
- **Proof follows sketch**: yes — the Lean proof uses the `coprodDecompMap` chain, `PreservesLimitPair.iso`, the per-leg `pushPullCoprodLegIso`, and the `pushPull_binary_leg_coherence` bridge; the blueprint proof sketch at lines 8058–8134 describes exactly this structure in the same order.
- **notes**: No `\leanok` on the statement block yet; `sync_leanok` has not run post-iter-063. This will be added automatically. The blueprint also lists four **private** helpers in the same `\lean{}` block — see Red Flags §2.

### `\lean{AlgebraicGeometry.pushPull_binary_leg_coherence}` (chapter: `lem:pushPull_binary_leg_coherence`)
- **Lean target exists**: yes — `private lemma pushPull_binary_leg_coherence` at line 823. (Declaration is `private`; see Red Flags §2.)
- **Signature matches**: yes — both state that `pushPullMap F (Over.homMk c wC) = (pushforward q).map ((restrictAdjunction c).unit.app M) ≫ (pushPullCoprodLegIso q c pC wC F).hom`.
- **Proof follows sketch**: yes — the Lean proof uses `rawPushPullMap_self_gen` to unfold, then `Adjunction.unit_leftAdjointUniq_hom_app` to rewrite the restriction unit; the blueprint proof at lines 8169–8191 describes the same two-step reduction (unfold to raw form, rewrite via `lem:unit_leftAdjointUniq_mathlib`).
- **notes**: Rename from `pushPullCoprodLeg_coherence` is complete in both Lean and blueprint. No `\leanok` yet (sync lag, as above).

### `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (chapter: `lem:pushPull_coprod_prod`)
- **Lean target exists**: **NO**. There is no `def pushPull_coprod_prod` in the Lean file. It is mentioned only in inline comments at lines 394 and 727 as a future induction target. The blueprint `\lean{AlgebraicGeometry.pushPull_coprod_prod}` at line 8196 points to a non-existent declaration.
- **Signature matches**: N/A (declaration absent).
- **Proof follows sketch**: N/A.
- **notes**: **must-fix-this-iter** — see Red Flags §1.

### `\lean{CategoryTheory.sigmaOptionIso}` — no blueprint block
- **Lean target exists**: yes — `noncomputable def sigmaOptionIso` at line 396, proved axiom-clean. Splits a coproduct over `Option α` as `∐ Z ≅ Z none ⨿ (∐ a, Z (some a))`.
- **Blueprint coverage**: **NONE**. No `\lean{}` hint, no `def:sigmaOptionIso`, no `lem:sigmaOptionIso` anywhere in the chapter. This is the `Option`-split combinator that drives the inductive step of the planned `pushPull_coprod_prod`.
- **notes**: major — see Blueprint Adequacy and Red Flags §3.

### `\lean{AlgebraicGeometry.pushPull_sigma_iso}` (chapter: `lem:pushPull_sigma_iso`)
- **Lean target exists**: yes — `noncomputable def pushPull_sigma_iso` at line 946, body `:= sorry`.
- **Signature matches**: yes — both state `pushPullObj F ((coverCechNerveOver 𝒰).obj (op (mk p))) ≅ ∏ᶜ fun σ : Fin(p+1) → 𝒰.I₀ => pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ)))`.
- **Proof follows sketch**: N/A (sorry). Blueprint sketch is adequate for assembly but depends on `pushPull_coprod_prod` which is absent.
- **notes**: `\leanok` on statement block (line 8246) is correct per "at least a sorry present" semantics. Proof remains open as Stub 2.

### `\lean{AlgebraicGeometry.pushPull_leg_sections}` (chapter: `lem:pushPull_leg_sections`)
- **Lean target exists**: yes — `noncomputable def pushPull_leg_sections` at line 984, complete proof.
- **Signature matches**: yes — both give `((SheafOfModules.forget …).obj (pushPullObj F (Over.mk (Scheme.Opens.ι (coverInterOpen 𝒰 σ))))).presheaf.obj (op V) ≅ ((SheafOfModules.forget …).obj F).presheaf.obj (op (coverInterOpen 𝒰 σ ⊓ V))`.
- **Proof follows sketch**: yes — three-step chain (pushforward sections = preimage sections, pullback ≅ restriction, restrict sections = image-open sections); both the blueprint and Lean follow the same path.
- **notes**: clean. `\leanok` present. No issues.

### `\lean{AlgebraicGeometry.pushPull_eval_prod_iso}` (chapter: `lem:pushPull_eval_prod_iso`)
- **Lean target exists**: yes — `noncomputable def pushPull_eval_prod_iso` at line 1033, body `:= sorry`.
- **Signature matches**: yes — both state the isomorphism `Γ(V, pushPullObj F Y_p) ≅ ∏ᶜ fun σ => Γ(coverInterOpen 𝒰 σ ⊓ V, F)` with the correct presheaf evaluation wrapping.
- **Proof follows sketch**: N/A (sorry). Blueprint assembly sketch (three pieces: `pushPull_sigma_iso` → evaluation preserves products → `pushPull_leg_sections`) is adequate.
- **notes**: `\leanok` present. Proof open as Stub 4. Depends on Stub 2 (`pushPull_sigma_iso`), hence transitively on the missing `pushPull_coprod_prod`.

### `\lean{AlgebraicGeometry.cechSection_complex_iso}` (chapter: `lem:cechSection_complex_iso`)
- **Lean target exists**: yes — `noncomputable def cechSection_complex_iso` at line 1097, body `:= sorry`. Auxiliary `noncomputable abbrev sectionCechComplexV` at line 1049, also declared.
- **Signature matches**: yes — both target the augmented form: `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` where `D` is the evaluated augmented Čech complex (the blueprint `% NOTE:` annotation at line 8347 explicitly records this).
- **Proof follows sketch**: N/A (sorry). Blueprint sketch is mostly adequate — see Blueprint Adequacy §minor note.
- **notes**: No `\leanok` on statement block (line 8341 area), despite the declaration existing with `sorry`. Likely a sync artifact: `sectionCechComplexV` (the second `\lean{}` target in the same block) is an `abbrev`; `sync_leanok` may treat compound blocks differently. Minor — both declarations exist. Proof open as Stub 5.

### `\lean{AlgebraicGeometry.cechSection_contractible}` (chapter: `lem:cechSection_contractible`)
- **Lean target exists**: yes — `noncomputable def cechSection_contractible` at line 1164, body `:= sorry`.
- **Signature matches**: yes — both target `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment ε hε)) 0` under hypothesis `V ≤ coverOpen 𝒰 i_fix`. The `% NOTE:` annotation at line 8422 in the blueprint records the augmented-form requirement explicitly.
- **Proof follows sketch**: N/A (sorry). Blueprint proof sketch (lines 8455–8496) is detailed and adequate, explicitly splitting the positive-degree `dep*` engine part from the augmentation-node computation.
- **notes**: `\leanok` present. Proof open as Stub 6.

---

## Red flags

### Placeholder / suspect bodies

1. **`AlgebraicGeometry.pushPull_sigma_iso` at line 951**: body `:= sorry`. Blueprint `lem:pushPull_sigma_iso` claims a substantive isomorphism. This is a known open stub (Stub 2); the `\leanok` on the statement block is consistent with the project's "at least sorry present" policy. However the proof is blocked on the missing `pushPull_coprod_prod` (see below).

2. **`AlgebraicGeometry.pushPull_eval_prod_iso` at line 1042**: body `:= sorry`. Known open stub (Stub 4). Unblocked once Stubs 2–3 land.

3. **`AlgebraicGeometry.cechSection_complex_iso` at line 1112**: body `:= sorry`. Known open stub (Stub 5).

4. **`AlgebraicGeometry.cechSection_contractible` at line 1171**: body `:= sorry`. Known open stub (Stub 6). Not blocked on any of the other stubs; can be proved independently.

### Missing declaration — critical

5. **`AlgebraicGeometry.pushPull_coprod_prod`**: The blueprint `\lean{AlgebraicGeometry.pushPull_coprod_prod}` (line 8196) points to a declaration that **does not exist** in the Lean file. The declaration is mentioned only in Lean comments (lines 394, 727) as a future target. This is a **must-fix-this-iter** finding: the `\lean{}` hint is broken, and `pushPull_sigma_iso` (Stub 2) structurally depends on it.

### Private declarations referenced by public names in `\lean{}`

6. The following declarations are **`private`** in the Lean file but appear in blueprint `\lean{}` hints as if they were public:
   - `AlgebraicGeometry.pushPull_binary_leg_coherence` (line 8153 in blueprint; `private lemma` at Lean:823)
   - `AlgebraicGeometry.coprodDecompMap` (line 8035; `private noncomputable def` at Lean:687)
   - `AlgebraicGeometry.isIso_coprodDecompMap` (line 8035; `private theorem` at Lean:736)
   - `AlgebraicGeometry.isIso_prodLift_of_isLimit` (line 8033; `private lemma` at Lean:651)
   - `AlgebraicGeometry.isIso_map_prodLift_of_isLimit` (line 8034; `private lemma` at Lean:665)

   In Lean 4, `private` declarations are given mangled internal names (e.g. `_root_._private.…`), so `lean_verify` would fail for the blueprint names above. This is a **major** issue: either these declarations should be made non-private (so the names are accurate), or the blueprint `\lean{}` hints should note they are internal helpers.

### Unreferenced substantive declaration

7. **`CategoryTheory.sigmaOptionIso`** (Lean:396) — a complete, axiom-clean, public (`noncomputable def`) declaration added this iter with no blueprint `\lean{}` reference. This is the `Option`-indexed coproduct split `∐ Z ≅ Z none ⨿ (∐ a, Z (some a))`, used as the inductive combinator for the planned `pushPull_coprod_prod`. The blueprint should carry a `\lean{}` anchor for it.

---

## Unreferenced declarations (informational)

The following public non-private declarations in the Lean file have no `\lean{}` reference in the blueprint chapter. They are categorical/geometric helpers; several should be promoted to named blueprint blocks:

- `CategoryTheory.widePullback_overX_isLimit` (Lean:54) — already referenced in `\lean{CategoryTheory.widePullback_overX_eq_prod, CategoryTheory.widePullback_overX_isLimit}` at blueprint line 7565. ✓ covered.
- `CategoryTheory.widePullback_overX_eq_prod` ✓ covered at line 7565.
- `CategoryTheory.overSigmaDescCofan`, `CategoryTheory.overSigmaDescIsColimit`, `CategoryTheory.overSigmaDescIso` — no blueprint `\lean{}`. These are small colimit helpers. Low priority.
- `CategoryTheory.FinitaryPreExtensive.prodFinSuccIso` — covered by `\lean{…, CategoryTheory.FinitaryPreExtensive.prodFinSuccIso}` at blueprint line 7769. ✓.
- **`CategoryTheory.sigmaOptionIso`** — **not covered** (see Red Flags §7). Should have a blueprint `\lean{}` anchor.
- `AlgebraicGeometry.widePullback_openImm_inter`, `AlgebraicGeometry.mem_iInf_opens_of_finite` — covered at blueprint line 7848. ✓.
- `AlgebraicGeometry.coverArrowOverCofan`, `AlgebraicGeometry.coverArrowOverIsColimit`, `AlgebraicGeometry.coverArrowOverSigmaIso` — covered at blueprint lines 7884–7885 under `lem:cech_backbone_left_sigma`. ✓.
- `AlgebraicGeometry.widePullbackBaseCongr`, `AlgebraicGeometry.coverInterProdIso`, `AlgebraicGeometry.cechBackbone_obj_widePullback` — covered at blueprint line 7884–7886. ✓.
- `AlgebraicGeometry.isIso_modules_of_toPresheaf` — covered at line 8011. ✓.
- `AlgebraicGeometry.pushPullCoprodLegIso` (`private`) — no `\lean{}` reference; it is an internal helper of `pushPull_binary_coprod_prod`. Acceptable as private.
- `AlgebraicGeometry.sectionCechComplexV` — covered at line 8346. ✓.

---

## Blueprint adequacy for this file

- **Coverage**: Of the primary named declarations in the Lean file, 9/10 have a `\lean{}` block (the 10th being `sigmaOptionIso`). Helper-only unreferenced declarations: ~12 (acceptable). Substantive unreferenced: 1 (`sigmaOptionIso`) — flagged.
- **Proof-sketch depth**: **mixed**.
  - `lem:pushPull_coprod_prod`: **under-specified**. The blueprint gives the mathematical idea (empty-case zero-sections; inductive step via `lem:pushPull_binary_coprod_prod`), but does NOT name the key Lean API sub-lemmas the prover confirmed are needed: `sigmaOptionIso` (the `Option`-split combinator), a product counterpart (informally called `piOptionIso`), `pushPullObjCongr` (transport of push-pull through a backbone iso), and the `induction_empty_option` pattern for the `Option`-indexed induction. A prover working only from the blueprint prose would not know how to implement the inductive step in Lean without significant API discovery work.
  - `lem:pushPull_sigma_iso`: **adequate** — two-step assembly (`cechBackbone_left_sigma` + `pushPull_coprod_prod`). Thin but correct.
  - `lem:pushPull_eval_prod_iso`: **adequate** — three-step assembly with named lemma references.
  - `lem:cechSection_complex_iso`: **mostly adequate** — the proof sketch describes augmentation-node, Čech-differential, and augmentation-differential match. One gap: the blueprint does not document the `PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.obj)` adapter between `SheafOfModules.forget` and `PresheafOfModules.toPresheaf` (the Lean comment at line 1082 flags this as an AMBIGUITY requiring careful verification). This is a non-obvious Lean-API wrinkle that the blueprint should warn about.
  - `lem:cechSection_contractible`: **adequate** — the blueprint is unusually detailed for this stub, explicitly separating the `dep*` engine application (positive degrees) from the augmentation-node check.
- **Hint precision**: **loose** for `pushPull_coprod_prod` (no sub-lemma names), **wrong** for the five private declarations (names will not resolve), **adequate** for all other blocks.
- **Generality**: matches need for all other declarations.

**Recommended chapter-side actions:**
1. Add a blueprint block (statement + `\lean{CategoryTheory.sigmaOptionIso}`) for `sigmaOptionIso`. Suggested placement: between `lem:overProd_coproduct_distrib_right` and `lem:coproduct_distrib_fibrePower` (or as a named auxiliary under `lem:pushPull_coprod_prod`'s `\uses`).
2. Expand `lem:pushPull_coprod_prod` proof sketch to name the Lean API path: `sigmaOptionIso` for the `Option`-indexed coproduct split, the product counterpart (`∏ᶜ (Option α → C) ≅ C none ⨯ ∏ᶜ (a, C (some a))`), `pushPullObjCongr` (transport of push-pull through a backbone iso), and the `induction_empty_option` tactic/pattern for the Option-indexed induction.
3. Either make `pushPull_binary_leg_coherence`, `coprodDecompMap`, `isIso_coprodDecompMap`, `isIso_prodLift_of_isLimit`, `isIso_map_prodLift_of_isLimit` non-private, or remove them from `\lean{}` hints and treat them as purely internal helpers.
4. Add a `% NOTE:` to `lem:cechSection_complex_iso`'s proof block about the `PresheafOfModules.restrictScalars` adapter type required to connect `SheafOfModules.forget` to `PresheafOfModules.toPresheaf`.

---

## Severity summary

### must-fix-this-iter
- **`AlgebraicGeometry.pushPull_coprod_prod` does not exist** in the Lean file (blueprint `\lean{}` hint is broken; `pushPull_sigma_iso` is structurally blocked). The prover must add this declaration.
- **Blueprint adequacy failure** for `lem:pushPull_coprod_prod`: the proof sketch is too thin for formalization — key Lean API sub-lemma names (`sigmaOptionIso`, product counterpart, `pushPullObjCongr`, induction pattern) are absent. A blueprint-writing pass is required before the next proving attempt.

### major
- `sigmaOptionIso` (new, proved, public) has no `\lean{}` reference in the blueprint.
- Five private declarations referenced by public (unresolvable) names in `\lean{}` hints: `pushPull_binary_leg_coherence`, `coprodDecompMap`, `isIso_coprodDecompMap`, `isIso_prodLift_of_isLimit`, `isIso_map_prodLift_of_isLimit`.

### minor
- `lem:pushPull_binary_coprod_prod` and `lem:pushPull_binary_leg_coherence` are proved this iter but lack `\leanok` on statement blocks (sync lag; will be resolved by `sync_leanok`).
- `lem:cechSection_complex_iso` lacks `\leanok` despite declaration existing (possible `abbrev`/compound-block sync artifact).
- Blueprint proof of `lem:cechSection_complex_iso` does not document the `PresheafOfModules.restrictScalars` adapter ambiguity that the Lean comment flags.

**Overall verdict**: two must-fix-this-iter findings (missing `pushPull_coprod_prod` declaration + thin blueprint for it), two major blueprint coverage gaps (`sigmaOptionIso` unanchored, five private-declaration name mismatches); the four proved this-iter declarations (`pushPull_binary_coprod_prod`, `pushPull_binary_leg_coherence`, `pushPull_leg_sections`, `sigmaOptionIso`) are all mathematically faithful to their blueprint statements (where those statements exist).

---

*Declarations checked: 10 primary (9 `\lean{}`-referenced + 1 blueprint-absent); red flags: 2 must-fix-this-iter, 2 major, 3 minor.*
