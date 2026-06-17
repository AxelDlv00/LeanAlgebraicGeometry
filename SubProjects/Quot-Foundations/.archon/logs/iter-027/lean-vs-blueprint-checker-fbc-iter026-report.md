# Lean ↔ Blueprint Check Report

## Slug
fbc-iter026

## Iteration
027

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2027 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (~3152 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (~line 242)
- **Signature matches**: yes — `pushforwardBaseChangeMap (sq : IsPullback g' f' f g) (F : X.Modules)` returning `g.op.pullback (f.pushforward F) ⟶ f'.pushforward (g'.op.pullback F)`, fully consistent with the blueprint's "canonical mate" definition.
- **Proof follows sketch**: yes / N/A (it is a definition)
- **notes**: `\leanok` on both statement and proof blocks. Proved without sorry.

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (~line 290)
- **Signature matches**: yes — tilde-module dictionary: pushforward of tilde = tilde of restriction of scalars.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (~line 433)
- **Signature matches**: yes — pullback of tilde = tilde of extension of scalars.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (~line 987)
- **Signature matches**: yes — Seam 1, sections of the unit factor. Proved fully.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. No sorry. Seam 1 is complete.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (lem:base_change_mate_codomain_read_legs)
- **Lean target exists**: yes (~line 1082)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved. Blueprint correctly labels this as "Superseded" (belongs to the first/abandoned route). Active and proved; the superseded label is a narrative note, not a correctness issue.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (lem:base_change_mate_fstar_reindex_legs_unitExpand)
- **Lean target exists**: yes (~line 1253)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved. Blueprint labels "Superseded". Proved and correct; the superseded label is appropriate (dead-route but accurately formalized). The `erw` unlock at line 1388 uses this lemma.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (lem:base_change_mate_fstar_reindex_legs_gammaDistribute)
- **Lean target exists**: yes (~line 1319)
- **Signature matches**: yes
- **Proof follows sketch**: yes — term-mode `(F.map_comp _ _).trans (congrArg ...)` triple composition at lines 1319–1321, matching the blueprint's "distribute unit on free composite first" step.
- **notes**: `\leanok` on both blocks. Proved. This is the critical term-mode `gammaDistribute` atom that the prover needs before the `eCancel_*` chain.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (lem:base_change_mate_fstar_reindex_legs)
- **Lean target exists**: yes (~line 1413)
- **Signature matches**: yes — `% LEAN SIGNATURE` comment in blueprint exactly matches the actual Lean signature (implicit `e : IsIso f.base`, `inclA`, `M` arguments).
- **Proof follows sketch**: partial — body is `:= by sorry`. Blueprint labels "Superseded" and marks it as belonging to the abandoned first route. The blueprint's 5-step proof outline (including step iii.2: "distribute via `gammaDistribute`, then cancel with three atoms") is correct for the intended proof but the Lean proof is not yet written.
- **notes**: **SORRY PRESENT.** Blueprint labels this block "Superseded" and marks statement `\leanok`. This is dead-code on the superseded route; the live path goes through `base_change_mate_inner_value_eq`. The sorry here is a structural scaffold hold, not a live proof obligation, per the blueprint's own labeling. See **Red flags** below.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (~line 1477)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved. Blueprint labels "Superseded". The step from `_legs` to `_fstar_reindex` is a consequence of the legs cancellation; this lemma is proved.

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (lem:base_change_mate_inner_eCancel_eUnit)
- **Lean target exists**: yes (~line 1506)
- **Signature matches**: yes — first of the three eCancel atoms.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (lem:base_change_mate_inner_eCancel_pushforwardComp)
- **Lean target exists**: yes (~line 1517)
- **Signature matches**: yes — second eCancel atom.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (lem:base_change_mate_inner_eCancel_pullbackComp)
- **Lean target exists**: yes (~line 1526)
- **Signature matches**: yes — third eCancel atom.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (lem:base_change_mate_gstar_generator_close)
- **Lean target exists**: yes (~line 1537)
- **Signature matches**: yes — Seam B. Ends with `rfl`.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved. Seam B (generator-close) is complete.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (lem:base_change_mate_inner_unitReduce AND lem:base_change_mate_inner_eCancel)
- **Lean target exists**: yes (~line 1646)
- **Signature matches**: yes — equates the inner factor of the mate to the unit-composed chain. Blueprint documents the deliberate "dual pin" (both `lem:base_change_mate_inner_unitReduce` and `lem:base_change_mate_inner_eCancel` pin `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}`), consistent with the assembly narrative.
- **Proof follows sketch**: N/A — body is `:= by sorry`. This is a **live-path sorry** (Seam A).
- **notes**: **SORRY PRESENT.** `\leanok` on statement block only (correct per `sync_leanok` policy: statement formalized, proof open). The blueprint proof sketch prescribes the `gammaDistribute`→`eCancel_*`→`codomain_read_legs` sequence with explicit load-bearing ordering. This is must-fix-this-iter. See **Red flags**.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (lem:base_change_mate_gstar_counit_transport)
- **Lean target exists**: yes (~line 1658)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved. Seam C component is complete.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (~line 1829)
- **Signature matches**: yes — `% LEAN SIGNATURE` comment in blueprint exactly matches the actual Lean signature.
- **Proof follows sketch**: N/A — body is `:= by sorry`. This is the **live crux sorry** (Seam 3).
- **notes**: **SORRY PRESENT.** `\leanok` on statement block only. Blueprint proof sketch identifies this as the central mate identity and prescribes the categorical conjugation argument. This is must-fix-this-iter. See **Red flags**.

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (~line 1854)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — transitively sorry (depends on `gstar_transpose`).
- **notes**: `\leanok` on statement block only. Downstream of the live crux; will close once `gstar_transpose` is proved.

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes
- **Signature matches**: yes — bundled R'-linear isomorphism using `Algebra.IsPushout.cancelBaseChange`.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-line corollary of `section_identity`, as blueprint notes.
- **notes**: `\leanok` on both blocks. Proved (modulo transitive sorry from `section_identity`/`gstar_transpose`). Blueprint correctly notes "now a one-line corollary".

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes
- **Signature matches**: yes — identification of cone legs with Spec-of-tensor inclusions.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.cancelBaseChange_mathlib}` (lem:cancelBaseChange_mathlib) — `\mathlibok`
- **Lean target exists**: yes — alias/re-export of Mathlib's `Algebra.IsPushout.cancelBaseChange`.
- **Signature matches**: yes
- **notes**: `\mathlibok` on statement block. Correct.

### `\lean{LinearMap.tensorEqLocusEquiv}` (lem:flat_preserves_equalizer_mathlib) — `\mathlibok`
- **Lean target exists**: yes — Mathlib upstream declaration.
- **Signature matches**: yes
- **notes**: `\mathlibok`. Correct.

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.modules_isIso_iff_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` on both blocks. Proved.

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes
- **Signature matches**: yes — blueprint note correctly documents that the Lean decl formalizes `IsIso (Γ(α))` rather than the literal equality, and explains why this is the faithful non-vacuous choice.
- **Proof follows sketch**: yes
- **notes**: `\leanok` on statement block. Proved (modulo transitive sorry from `gstar_transpose`). Blueprint comment accurately describes the deliberate delta from the full equality form.

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (~line 2002)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — body is `:= by sorry`.
- **notes**: **SORRY PRESENT.** `\leanok` on statement block only. This is the affine-reduction step; it is blocked by the live-path sorries above (transitively depends on `gstar_transpose`). This is a deferred sorry, not a direct live-crux.

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (~line 2024)
- **Signature matches**: yes — quasi-compact and quasi-separated `f`, flat `g`, quasi-coherent `F`.
- **Proof follows sketch**: N/A — body is `:= by sorry`.
- **notes**: **SORRY PRESENT.** `\leanok` on statement block only. Blueprint correctly identifies that this needs Čech infrastructure (finite equalizer + flatness commutes with equalizer). Deferred, not a live-path crux — the crux lives in `gstar_transpose`.

---

## Red flags

### Placeholder / suspect bodies

- **`base_change_mate_fstar_reindex_legs`** at line 1413: `:= by sorry`. Blueprint labels this "Superseded" (abandoned first route). The sorry is a structural scaffold on dead code; the live path bypasses this lemma. **Classification: major** — the blueprint is accurate about the superseded status, but the sorry propagates and should either be filled (as the blueprint's 5-step outline prescribes) or the dead code should be explicitly removed. Blueprint proof outline is present and detailed enough that filling the sorry is feasible without blueprint changes.

- **`base_change_mate_inner_value_eq`** at line 1646: `:= by sorry`. **LIVE PATH.** This is Seam A of the mate computation. The blueprint prescribes: (1) `erw [base_change_mate_fstar_reindex_legs_unitExpand ...]` to unfold the codomain read legs (using the proved `_unitExpand` lemma); (2) distribute via term-mode `gammaDistribute` (proved `_gammaDistribute` lemma); (3) cancel e-factors with the three proved `eCancel_*` atoms in sequence; (4) fold back through `codomain_read_legs`. The ordering is load-bearing (cannot cancel before distributing, cannot use `simp [Functor.map_comp]` due to `X.Modules` instance diamond). **Classification: must-fix-this-iter.**

- **`base_change_mate_gstar_transpose`** at line 1829: `:= by sorry`. **LIVE CRUX.** This is Seam 3, the central categorical identity that propagates to `section_identity`, `generator_trace`, `pushforward_base_change_mate_cancelBaseChange`, `affineBaseChange_pushforward_iso`, and `flatBaseChange_pushforward_isIso`. The blueprint prescribes the mate conjugation argument and identifies the `pullbackSpecIso` leg identification as the key sub-step (isolated in `pullback_fst_snd_specMap_tensor`, which is proved). **Classification: must-fix-this-iter.**

- **`affineBaseChange_pushforward_iso`** at line 2002: `:= by sorry`. Deferred (transitively blocked by `gstar_transpose`). Once `gstar_transpose` is proved this should close by the affine-locality chain already proved. **Classification: major (deferred).**

- **`flatBaseChange_pushforward_isIso`** at line 2024: `:= by sorry`. Final theorem; needs Čech infrastructure not yet present in the file. **Classification: major (deferred, different blocker from `gstar_transpose`).**

### Excuse-comments

None found. No `-- TODO replace with real def`, `-- placeholder`, `-- temporary`, or `-- wrong but works for now` comments attached to substantive declarations.

### Axioms / Classical.choice on non-trivial claims

None found. The three `private lemma` declarations (`gammaMap_pushforwardComp_hom_eq_id` at line 1174, `gammaMap_pushforwardComp_inv_eq_id` at line 1181, `gammaMap_pushforwardCongr_hom` at line 1193) are all proved (end with `rfl` or similar) and are genuine helpers.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have no corresponding `\lean{...}` blueprint block. These are helpers; none has a name suggesting it should be a standalone blueprint lemma.

- `gammaMap_pushforwardComp_hom_eq_id` (line 1174, `private`) — internal helper for the `gammaMap` API. `private` scope is appropriate; blueprint's `% LEAN SIGNATURE` comment in `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` implicitly documents it.
- `gammaMap_pushforwardComp_inv_eq_id` (line 1181, `private`) — companion.
- `gammaMap_pushforwardCongr_hom` (line 1193, `private`) — companion.

**Note on `private` + blueprint `\lean{}` pins**: The blueprint's `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` has `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` which exists at line 1319 and is **not** `private`. The three `private` lemmas above are unblueprinted helpers, not the target of any `\lean{...}` pin. No inconsistency.

---

## Blueprint adequacy for this file

### Directive questions answered

**Q1: Does the blueprint faithfully describe the actual Lean statements/signatures for the `lem:base_change_mate_*` chain?**

Yes. Every `\lean{...}` pin in the chapter names a declaration that exists in the Lean file with a matching signature. The `% LEAN SIGNATURE` inline comments in `lem:base_change_mate_fstar_reindex_legs` and `lem:base_change_mate_gstar_transpose` are verbatim-accurate transcriptions of the Lean signatures (verified against the actual Lean source). The "deliberate duplicate pin" pattern — where `lem:base_change_mate_inner_unitReduce` and `lem:base_change_mate_inner_eCancel` both pin `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` — is correctly documented in blueprint `% LEAN INTERNAL` comments and reflects the actual Lean structure (assembly narrative blocks sharing one Lean target).

**Q2: Is the chapter detailed enough to guide the `_legs` cancellation assembly (term-mode `gammaDistribute` + unfolding `base_change_mate_codomain_read_legs`, NOT `simp [Functor.map_comp]`)?**

Yes — adequate. The `lem:base_change_mate_inner_eCancel` proof block contains the explicit load-bearing ordering comment: "Order of operations (load-bearing): distribute unit on free composite first; cancel with three atoms; then read through Lemma codomain_read." The `lem:base_change_mate_fstar_reindex_legs` proof block (step iii.2) names `lem:base_change_mate_fstar_reindex_legs_gammaDistribute` as the distribution step. The three `eCancel_*` atoms are individually named and proved. The `erw` unlock (using `_unitExpand`) is documented. The `simp [Functor.map_comp]` prohibition is implicit in the `gammaDistribute` lemma's existence (its proved body uses term-mode `F.map_comp _ _` exactly because `simp` would loop on `X.Modules`). The blueprint does not explicitly say "do not use `simp [Functor.map_comp]`" — this is a minor gap, but the prescribed term-mode route is clear enough that a prover following the blueprint would not reach for `simp`.

**Q3: Any signature mismatches, fake/placeholder statements, or wrong `\lean{}` pins?**

No signature mismatches. No fake statements. No wrong `\lean{}` pins. The five sorry bodies are correctly predicted by the blueprint: two are labeled "must-close" live-path sorries (`inner_value_eq`, `gstar_transpose`), one is labeled "Superseded" dead-route sorry (`fstar_reindex_legs`), and two are labeled deferred downstream (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`).

---

### Standard adequacy assessment

- **Coverage**: 37 `\lean{...}` blocks checked. All 37 pin declarations that exist in the Lean file. Three `private` helper lemmas are unblueprinted — acceptable (helpers). No substantive public declaration lacks a blueprint reference.
- **Proof-sketch depth**: **adequate**. The four Seam decomposition (unit_value → inner_value_eq → gstar_transpose → section_identity) is explicitly described. The `gammaDistribute`→`eCancel_*`→`codomain_read_legs` assembly sequence is explicitly ordered and each sub-lemma is individually stated and proved. The lone gap (absence of explicit `simp [Functor.map_comp]` warning) is minor and does not impede a careful prover.
- **Hint precision**: **precise**. All `\lean{...}` pins name the correct Lean declaration. No pin uses an ambiguous predicate name or wrong Mathlib analog.
- **Generality**: **matches need**. The tilde-dictionary lemmas (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`) are stated at exactly the generality consumed by the mate computation. No parallel API was written to plug a blueprint-generality gap.
- **Recommended chapter-side actions**: None required for the live-path sorries. The blueprint already contains all the guidance needed for `inner_value_eq` and `gstar_transpose`. Optional improvement: add a one-line note in the `lem:base_change_mate_inner_eCancel` proof block: "Do not use `simp [Functor.map_comp]` — use term-mode `F.map_comp _ _` to avoid the `X.Modules` instance diamond." This would make the prohibition explicit rather than implicit.

---

## Severity summary

| Declaration | Line | Status | Severity |
|---|---|---|---|
| `base_change_mate_inner_value_eq` | 1646 | sorry, live-path Seam A | **must-fix-this-iter** |
| `base_change_mate_gstar_transpose` | 1829 | sorry, live crux Seam 3 | **must-fix-this-iter** |
| `base_change_mate_fstar_reindex_legs` | 1413 | sorry, superseded dead code | **major** |
| `affineBaseChange_pushforward_iso` | 2002 | sorry, deferred downstream | **major (deferred)** |
| `flatBaseChange_pushforward_isIso` | 2024 | sorry, deferred + Čech blocker | **major (deferred)** |
| Three `private` helpers not blueprinted | 1174, 1181, 1193 | unblueprinted helpers | **minor** |
| Implicit (not explicit) `simp` prohibition | chapter prose | minor omission in blueprint | **minor** |

**Overall verdict**: Blueprint is faithful and adequate — all 37 `\lean{...}` pins correct, no signature mismatches, no fake statements, no wrong pins; the chapter provides sufficient detail to guide both live-path sorry proofs; the two must-fix-this-iter sorries (`inner_value_eq` at line 1646, `gstar_transpose` at line 1829) are the sole blocking obligations, with the superseded `fstar_reindex_legs` sorry (line 1413) as a secondary major cleanup item.
