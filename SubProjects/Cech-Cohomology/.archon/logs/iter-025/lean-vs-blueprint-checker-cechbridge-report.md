# Lean ↔ Blueprint Check Report

## Slug
cechbridge

## Iteration
025

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechBridge.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CeckHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.injective_cech_acyclic}` (chapter: `lem:injective_cech_acyclic`)
- **Lean target exists**: yes — line 872
- **Signature matches**: partial (see note)
- **Proof follows sketch**: yes
- **notes**: The Lean declaration covers only the **p > 0** half of the Stacks statement (`IsZero (sectionCechComplex ... .homology p)` given `0 < p`). The `Ȟ⁰ = I(U)` clause is deliberately absent. This is **not a faked statement** — the proved claim is a genuine, correct partial realization of the informal lemma. The module docstring is explicit ("positive-degree Čech vanishing"). The `lean_verify` result: axioms `{propext, Classical.choice, Quot.sound}`, no warnings, no sorries. The proof faithfully follows the blueprint's categorical-assembly sketch (Part 1 via `injective_toPresheafOfModules`, Part 2 via `cechFreeComplex_quasiIso` + `quasiIso_map_preadditiveYoneda_of_injective` + `sectionCechComplexMapOpIso`). **Gap**: the blueprint statement block presents the full Stacks result (including p = 0) under a single `\lean{...}` pin, with no `% NOTE:` flagging that p = 0 is currently unformalized. See Blueprint adequacy section.

### `\lean{AlgebraicGeometry.injective_toPresheafOfModules}` (co-pin of `lem:injective_cech_acyclic`)
- **Lean target exists**: yes — in `PresheafCech.lean` line 216, correctly imported
- **Signature matches**: yes — injectivity transport from `X.Modules` to `X.PresheafOfModules`
- **Proof follows sketch**: yes (Part 1 of the blueprint proof for `lem:injective_cech_acyclic`)
- **notes**: `lean_verify`: axioms `{propext, Classical.choice, Quot.sound}`, clean.

### `\lean{AlgebraicGeometry.preadditiveYoneda_obj_preservesFiniteColimits_of_injective}` and `quasiIso_map_preadditiveYoneda_of_injective` (chapter: `lem:hom_into_injective_exact`)
- **Lean target exists**: yes — lines 401 and 421
- **Signature matches**: yes — general abelian-category statement, correct level of generality for downstream reuse
- **Proof follows sketch**: yes — blueprint proof: `injective_iff_preservesEpimorphisms_preadditiveYoneda_obj` → `preservesFiniteColimits_iff_forall_exact_map_and_epi` → `PreservesHomology` → `quasiIsoAt_map_of_preservesHomology`; matches Lean proof step by step
- **notes**: `lean_verify` both: axioms `{propext, Classical.choice, Quot.sound}`, clean. No `\leanok` present in blueprint block — see Blueprint adequacy.

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes — line 266
- **Signature matches**: yes — cochain-complex iso `homCechComplex 𝒰 F ≅ sectionCechComplex (coverOpen 𝒰) F`
- **Proof follows sketch**: yes — blueprint sketches: (i) per-degree iso via free-Yoneda adjunction + coproduct-hom duality, (ii) differential intertwining via cosimplicial naturality; Lean: `(alternatingCofaceMapComplex Ab).mapIso (homCechSectionCosimplicialIso 𝒰 F)`, exactly assembly via cosimplicial iso functor
- **notes**: `lean_verify`: axioms `{propext, Classical.choice, Quot.sound}`, clean.

### `\lean{AlgebraicGeometry.homCechComplexMapOpIso}` (chapter: `lem:cech_complex_op_identification`)
- **Lean target exists**: yes — line 341
- **Signature matches**: yes
- **Proof follows sketch**: yes — identity components + `homCechComplex_d_eq`
- **notes**: Clean. `\leanok` present in blueprint (`lem:cech_complex_op_identification` block lacks it — actually this block has no `\leanok` in the source at lines 2476-2510, but `lem:section_cech_complex_mapop_iso` at line 2514 does).

### `\lean{AlgebraicGeometry.sectionCechComplexMapOpIso}` (chapter: `lem:section_cech_complex_mapop_iso`)
- **Lean target exists**: yes — line 363
- **Signature matches**: yes — `(preadditiveYoneda.obj F).mapHomologicalComplex ... (HomologicalComplex.op (cechFreePresheafComplex 𝒰)) ≅ sectionCechComplex (coverOpen 𝒰) F`
- **Proof follows sketch**: yes — one-line assembly `(homCechComplexMapOpIso 𝒰 F).symm ≪≫ cechComplex_hom_identification 𝒰 F`
- **notes**: `\leanok` present in blueprint (line 2514). Axiom-clean.

### `\lean{AlgebraicGeometry.ses_cech_h1}` (chapter: `lem:ses_cech_h1`)
- **Lean target exists**: yes — line 658
- **Signature matches**: yes — takes a single covering with `hH1 : IsZero ((sectionCechComplex U F).homology 1)` plus explicit local lifts `sLoc` and `hlift`; the Lean docstring explicitly notes that "the cofinal system of covers of the Stacks statement is captured here by taking a single cover satisfying both `Ȟ¹ = 0` and the local-lift property as hypotheses." This is an acceptable and clearly-documented scope decision.
- **Proof follows sketch**: yes — blueprint: form differences `s_{ij}`, lift to F via exactness, Čech-H¹ vanishing gives coboundary, correct sections, sheaf gluing; Lean: `g'coord = sLoc'coord - fι t`, agreement via `hg'coc`, glued by `isSheafUniqueGluing`, separatedness via `H.presheaf.isSheafUniqueGluing`
- **notes**: `lean_verify`: axioms `{propext, Classical.choice, Quot.sound}`, clean. No `\leanok` in blueprint — see Blueprint adequacy. All sub-lemmas (`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`, helper family) also axiom-clean.

### Helper declarations (`homCechSectionCosimplicialIso`, `homCechSectionIsoApp`, etc.)
- All referenced in `lem:cech_complex_hom_identification` `\lean{...}` list ✓
- All present in Lean file ✓
- No sorries, no excuse-comments

---

## Red flags

No red flags found:
- Zero `:= sorry` occurrences in the file
- Zero `axiom` declarations
- Zero excuse-comments or placeholder comments attached to substantive declarations
- `set_option maxHeartbeats 2000000` at line 851 (for `injective_cech_acyclic`) and `1600000` at line 637 (for `ses_cech_h1`) are performance pragmas, not red flags — correctly documented in the module docstring with the reason (op-transport defeq chains)
- `classical` at line 675 in `ses_cech_h1` is standard for classical choice in `obtain ⟨b, hb⟩`

---

## Unreferenced declarations (informational)

The following `private` helpers in the `SesCechH1` section are pinned by `lem:ses_cech_h1`'s `\lean{...}` but are `private` in Lean 4:
- `restr_trans`, `restr_inj_of_eq`, `restr_op_unique`, `restr_g'_transport`, `fι_sectionCechFaceRestr`, `coverConst_iInf`, `coverPair_iInf`, `pair_comp_δ0`, `pair_comp_δ1`

In Lean 4, `private` declarations receive mangled internal names (not `AlgebraicGeometry.restr_trans`). The `\lean{...}` pins using `AlgebraicGeometry.` prefixed names are therefore technically unreachable by the `lean_verify` tool. This is informational only — the conceptual purpose of each helper is clear and the mathematical content is correct.

---

## Blueprint adequacy for this file

- **Coverage**: All 13+ substantive declarations in CechBridge.lean (public and private helpers) have a corresponding `\lean{...}` reference in the chapter. Coverage is 13/13 for public declarations plus private helpers mapped to their parent lemma blocks. No orphaned declarations.

- **Proof-sketch depth**: **Adequate**. The blueprint proof for `lem:injective_cech_acyclic` (lines 2638–2692) is unusually detailed, explicitly naming the two-part structure, the specific Mathlib lemmas to call (`Injective.injective_iff_preservesEpimorphisms_preadditiveYoneda_obj`, `quasiIsoAt_map_of_preservesHomology`), and the specific isomorphisms to transport across (`homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`). The Lean proof is a one-to-one instantiation of this sketch, confirming it was guideable from the chapter. The `lem:ses_cech_h1` proof sketch (lines 2758–2780) similarly covers all key steps.

- **Hint precision**: **Loose for `lem:injective_cech_acyclic`** — the `\lean{...}` pin names `injective_cech_acyclic` for the full Stacks result (two-clause: p=0 AND p>0), but the Lean declaration only covers `p>0`. No `% NOTE:` in the blueprint statement block or `\lean{}` comment flags this split. A reader of the blueprint who checks `injective_cech_acyclic`'s signature would find the stronger hypothesis `hp : 0 < p` and know the p=0 clause is not here, but the blueprint itself gives no explicit signal. **Recommended blueprint action**: add a `% NOTE:` annotation to `lem:injective_cech_acyclic` explaining that the Lean formalization covers only the `p>0` vanishing, and that the `Ȟ⁰ = I(U)` identification is a separate open target.

- **`\leanok` gaps**: `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:hom_into_injective_exact`, and `lem:cech_complex_op_identification` all lack `\leanok` despite their constituent declarations being fully axiom-clean. This is a `sync_leanok` bookkeeping matter (not a proof error), but worth flagging: `sync_leanok` should add `\leanok` to these blocks this iter.

- **Generality**: Matches need. The `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` and `quasiIso_map_preadditiveYoneda_of_injective` are correctly stated for a general abelian category `C`, not just `X.PresheafOfModules`. The blueprint explicitly says "Both statements are for a general abelian category, the right generality for reuse" — confirmed by the Lean signature `{C : Type*} [Category C] [Abelian C]`.

- **Recommended chapter-side actions**:
  1. Add `% NOTE: Lean formalization of this lemma covers the p > 0 vanishing only (hypothesis `hp : 0 < p` in `injective_cech_acyclic`). The p = 0 clause (Ȟ⁰(𝒰, I) = I(U)) is not yet formalized.` to `lem:injective_cech_acyclic`.
  2. Allow `sync_leanok` to add `\leanok` to `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:hom_into_injective_exact`, `lem:cech_complex_op_identification`.
  3. (Optional, minor) Note in `lem:ses_cech_h1` that the "cofinal system" is handled by taking a single covering with both properties as hypotheses — this is already partially covered in the Lean docstring but not reflected in the blueprint prose.

---

## Severity summary

| Finding | Direction | Severity |
|---------|-----------|----------|
| `lem:injective_cech_acyclic` `\lean{}` pin covers full statement but Lean proves p>0 only; no `% NOTE:` in blueprint to flag the p=0 gap | Blueprint → Lean | **major** |
| Private helpers (`restr_trans` et al.) in `lem:ses_cech_h1` `\lean{}` pins are unreachable by `lean_verify` due to Lean 4 name-mangling of `private` | Blueprint → Lean | **minor** |
| `\leanok` absent for `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:hom_into_injective_exact`, `lem:cech_complex_op_identification` despite all declarations being axiom-clean | Blueprint (sync gap) | **minor** |

**No must-fix-this-iter findings.**

**Overall verdict**: `injective_cech_acyclic` is a faithful, axiom-clean realization of the p>0 half of `lem:injective_cech_acyclic` — the p=0 split is deliberate and correctly scoped, not a fake; the blueprint proof sketch is detailed enough to have fully guided the formalization; one major blueprint-side action (add `% NOTE:` for the p=0 gap) and two minor items remain.
