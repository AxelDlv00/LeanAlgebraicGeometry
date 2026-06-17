# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
022

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.sectionCech_homology_exact}` (chapter: `lem:section_cech_homology_exact`)
- **Lean target exists**: yes — public theorem, line 1587, no sorry
- **Signature matches**: partial (see note) — the blueprint prose describes the result for an arbitrary quasi-coherent F, but the Lean statement restricts to `F = (Scheme.Modules.toPresheafOfModules (Spec R)).obj (tilde M)`. The blueprint explicitly authorizes this restriction: the proof text (lines 706–711, 1273–1280) states "The active target is the tilde case F = ~M ... a general quasi-coherent F is reduced to this case via F ≅ ~(ΓF) (Stacks Tag 01I8), the separately-deferred globalisation gap." No unauthorised weakening.
- **Proof follows sketch**: yes — the three-step reduction `exactAt_iff_isZero_homology → ShortComplex.ab_exact_iff_function_exact → Function.Exact.of_ladder_addEquiv_of_exact` is exactly the blueprint proof skeleton (§Proof of `lem:section_cech_ab_exact`, lines 996–1020).
- **Notes**: Axiom-clean. The tilde-case scoping is explicitly sanctioned by the blueprint. ✓

### `\lean{AlgebraicGeometry.sectionCech_affine_vanishing}` (chapter: `lem:cech_acyclic_affine`, section form)
- **Lean target exists**: yes — public theorem, lines 1600–1605, no sorry
- **Signature matches**: partial (same tilde-F restriction, blueprint-authorized). The blueprint `% NOTE:` at lines 1148–1154 explicitly names `sectionCech_affine_vanishing` as the proposed re-signed landing and keeps the old name `CechAcyclic.affine` only for coverage continuity.
- **Proof follows sketch**: yes — thin wrapper calling `sectionCech_homology_exact`. ✓
- **Notes**: The blueprint's `lem:cech_acyclic_affine` block has **no `\leanok`** on statement or proof, consistent with the general-F form being unformalized. The tilde-case theorem is proved and axiom-clean.

### `\lean{AlgebraicGeometry.CechAcyclic.affine}` (chapter: `lem:cech_acyclic_affine`, old target)
- **Lean target exists**: yes — line 75, body is `:= sorry`
- **Signature matches**: yes — the original relative-pushforward statement (`IsZero (CechComplex f ... F).homology p` for `p ≥ 1`).
- **Proof follows sketch**: N/A — proof is sorry
- **Notes**: Blueprint `% NOTE:` at lines 1148–1154 explicitly authorizes the sorry as a transitional state ("kept in the `\lean{}` list until the planner refactor lands"). No `\leanok` on the block. This is **not** a blocking finding by the blueprint's own authorization, but it is the sole remaining sorry in the file. See also severity summary.

### `\lean{AlgebraicGeometry.sectionCechCofaceMatch}` (chapter: `lem:section_cech_coface_match`)
- **Lean target exists**: yes — `private lemma sectionCechCofaceMatch`, line 1540, no sorry
- **Signature matches**: yes — shows that `sectionToModuleAddEquiv ∘ objD q = dDiff ∘ sectionToModuleAddEquiv` (the coface-match identity that identifies the abstract section Čech differential with the localisation differential `dDiff`). Matches blueprint statement (lines 880–896).
- **Proof follows sketch**: yes — two-step proof: (i) abstract unfold via `sectionCech_objD_apply`; (ii) per-coface tilde-bridge via `phi_naturality`. Blueprint proof sketch (lines 908–954) describes precisely these two steps. ✓
- **Notes**: Declaration is `private`; the `\lean{}` tag uses the fully-qualified name for documentation purposes, which is fine within-project. `\leanok` on both statement (line 877) and proof (line 908) of the blueprint is consistent with the Lean state. ✓

### `\lean{AlgebraicGeometry.sectionCechAbExact}` (chapter: `lem:section_cech_ab_exact`)
- **Lean target exists**: yes — `private lemma sectionCechAbExact`, line 1558, no sorry
- **Signature matches**: yes — `Function.Exact (objD q) (objD (q+1))` for the tilde section Čech complex, given `Ideal.span (Set.range s) = ⊤`. Matches blueprint statement (lines 958–991).
- **Proof follows sketch**: yes — ladder transport `Function.Exact.of_ladder_addEquiv_of_exact` with `sectionCechCofaceMatch` as the commuting squares and `dDiff_exact` as the horizontal exactness, matching blueprint proof description (lines 994–1021). ✓

### `\lean{AlgebraicGeometry.sectionCech_isZero_homology_of_objD_exact}` (chapter: `lem:section_cech_ab_exact`, precursor)
- **Lean target exists**: yes — lines 1247–1267, no sorry
- **Signature matches**: yes — given `Function.Exact` of two consecutive `objD` maps, concludes `IsZero` of the section Čech homology. ✓
- **Proof follows sketch**: yes — `exactAt_iff_isZero_homology`, `exactAt_iff'`, `ShortComplex.ab_exact_iff_function_exact`. Matches blueprint description at lines 974–991. ✓

### `\lean{AlgebraicGeometry.ab_hom_finsetSum_apply}` (chapter: `lem:section_cech_ab_exact`)
- **Lean target exists**: yes — `private lemma ab_hom_finsetSum_apply`, line 1270, no sorry
- **Signature matches**: yes — application of a finite sum of Ab-morphisms distributes. ✓

### `\lean{AlgebraicGeometry.sectionCechProductEquiv}` (chapter: `lem:section_cech_product_equiv`)
- **Lean target exists**: yes — line 1221, no sorry
- **Signature matches**: yes — `ToType (∏ᶜ F_σ) ≃ ∀ σ, ToType (F_σ)` via `Concrete.productEquiv`. Matches blueprint (lines 765–793). ✓

### `\lean{AlgebraicGeometry.sectionCechProductEquiv_apply}` (chapter: `lem:section_cech_product_equiv`)
- **Lean target exists**: yes — line 1232, no sorry
- **Signature matches**: yes — coordinate projection formula. ✓

### `\lean{AlgebraicGeometry.sectionCech_objD_apply}` (chapter: `lem:section_cech_objd_apply`)
- **Lean target exists**: yes — line 1296, no sorry
- **Signature matches**: yes — alternating sum of face restrictions read through `sectionCechProductEquiv`. Matches blueprint (lines 838–852). ✓

### `\lean{AlgebraicGeometry.sectionCechFaceRestr}` (chapter: `lem:section_cech_objd_apply`)
- **Lean target exists**: yes — `noncomputable def`, line 1284, no sorry
- **Signature matches**: yes — the i-th presheaf face restriction at multi-index σ. ✓

### `\lean{AlgebraicGeometry.qcohSectionsAwayLocalized}` (chapter: `def:qcoh_sections_localized`)
- **Lean target exists**: yes — line 1165, no sorry
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers (∏ k, s (σ k))) (tilde.toOpen M ...).hom`. Matches blueprint item (4), lines 553–556. ✓

### `\lean{AlgebraicGeometry.basicOpen_sprod}` (chapter: `def:qcoh_sections_localized`)
- **Lean target exists**: yes — line 1141, no sorry
- **Signature matches**: yes — `⨅ k, D(s (σ k)) = D(∏ k, s (σ k))`. ✓

### `\lean{AlgebraicGeometry.iInf_fin_succ}` (chapter: `def:qcoh_sections_localized`)
- **Lean target exists**: yes, but as `private lemma iInf_fin_succ` (line 1129)
- **Signature matches**: yes — `⨅ i, f i = f 0 ⊓ ⨅ i : Fin n, f i.succ`
- **Notes**: **minor** — declaration is `private` in the Lean file but the blueprint's `\lean{}` entry lists it as the public name `AlgebraicGeometry.iInf_fin_succ`. The declaration is inaccessible by that name from other Lean files. The blueprint link is slightly misleading.

### `\lean{AlgebraicGeometry.qcohRestriction_eq_comparison}` (chapter: `def:qcoh_sections_localized`)
- **Lean target exists**: yes — line 1183, public lemma, no sorry
- **Signature matches**: yes — the presheaf restriction of tilde M between basic-open section groups equals `AwayComparison.comparison`. Matches blueprint item (5) / `qcohRestriction_eq_comparison` description (lines 596–601). ✓

### `\lean{AlgebraicGeometry.SectionCechModule.dDiff_exact}` (chapter: `lem:section_cech_module_exact`)
- **Lean target exists**: yes — line 1082, no sorry
- **Signature matches**: yes — `Function.Exact (dDiff s M (m+1)) (dDiff s M (m+2))` for a spanning family. ✓
- **Proof follows sketch**: yes — `exact_of_isLocalized_span` + `map_dDiff_eq_locDiff` + `locDiff_exact` matches blueprint proof sketch (lines 1122–1142). ✓

### `\lean{AlgebraicGeometry.CechLocalized.cechLocalized_exact}` (chapter: `lem:section_cech_homology_exact`)
- **Lean target exists**: yes — line 849, no sorry. ✓

### AwayComparison.*, CechLocalized.*, SectionCechModule.* bundle (`lem:section_cech_homology_exact`)
All declarations in the extensive `\lean{}` list of `lem:section_cech_homology_exact` (blueprint lines 607–629) were checked in prior iterations and are axiom-clean in the current file state. No sorry, no suspicious bodies.

### CombinatorialCech.* declarations (`lem:cech_acyclic_affine`)
All `CombinatorialCech.combDifferential`, `combHomotopy`, `depDiff`, `depDiff_exact`, etc. are `private` in the Lean file, axiom-clean, no sorry. Blueprint references them as public names — same minor naming-visibility issue as `iInf_fin_succ`.

---

## Red flags

### Placeholder / suspect bodies
- `AlgebraicGeometry.CechAcyclic.affine` at line 110: body is `:= sorry`. The blueprint lists this in `\lean{}` of `lem:cech_acyclic_affine` but has **no `\leanok`** on the block. The blueprint `% NOTE:` (lines 1148–1154) explicitly authorizes this: "The old name AlgebraicGeometry.CechAcyclic.affine is kept in the `\lean{}` list until the planner refactor lands so coverage is not lost." The replacement target `sectionCech_affine_vanishing` is proved. **Severity: informational only** (authorized placeholder), not must-fix-this-iter by blueprint's own criteria. Plan agent should track the eventual refactor.

### Excuse-comments
None. The section comment on `CechAcyclic.affine` (lines 80–110) accurately describes the remaining L1 bridge gap — it does not excuse incorrect code, it correctly describes the mathematical state.

### Axioms / Classical.choice on non-trivial claims
None introduced this iteration. The `private noncomputable def spanIdx` (line 1069) uses `Classical.choice` implicitly via `.choose`, but this is a routine construction selecting a witness from a span-range membership proof — authorized by the blueprint ("the auxiliary spanIdx/spanIdx_spec select a witnessing index of the spanning relation", blueprint line 1071–1072).

---

## Unreferenced declarations (informational)

The following `section SectionCechTilde` declarations (landed iter-022) have no `\lean{}` reference in the blueprint. All are `private`; none should be must-fix. Recommended attachment blocks:

| Declaration | Lean location | Recommended blueprint block |
|---|---|---|
| `phiL_naturality` (private) | line 1362 | `lem:section_cech_coface_match` — it IS the linear naturality square described there |
| `tP` (private abbrev) | line 1429 | `lem:section_cech_coface_match` notation |
| `tU` (private abbrev) | line 1433 | `lem:section_cech_coface_match` notation |
| `phiL` (private def) | line 1441 | `def:qcoh_sections_localized` — the per-σ comparison φ_σ = `IsLocalizedModule.iso` |
| `phi` (private def) | line 1451 | `def:qcoh_sections_localized` — additive version of φ_σ |
| `phi_eq_phiL` (private lemma) | line 1458 | `def:qcoh_sections_localized` — definitional bridge |
| `restr_bridge` (private lemma) | line 1467 | `def:qcoh_sections_localized` — accessor-1 / accessor-2 restriction compatibility for tilde M |
| `phi_naturality` (private lemma) | line 1478 | `lem:section_cech_coface_match` — additive version of the naturality square |
| `sectionProdAddEquiv` (private def) | line 1494 | `lem:section_cech_product_equiv` — additive upgrade of `sectionCechProductEquiv` |
| `sectionToModuleAddEquiv` (private def) | line 1511 | `lem:section_cech_ab_exact` — the ladder vertical isomorphism e_p described in proof lines 1005–1006 |
| `sectionToModuleAddEquiv_apply` (private lemma) | line 1517 | `lem:section_cech_ab_exact` |
| `sectionProdEquiv_symm_apply` (private lemma) | line 1525 | `lem:section_cech_ab_exact` |

Additionally, several `private` declarations throughout the file (`CombinatorialCech.*`, `CechLocalized.*` helpers, `SectionCechBridge.*` helpers) are blueprint-referenced by public name despite being private — the same minor visibility issue as `iInf_fin_succ`.

---

## Blueprint adequacy for this file

- **Coverage**: 16/16 landed declarations in `SectionCechTilde` are traceable to blueprint content, though 12 are private and lack explicit `\lean{}` tags. Public-facing declarations are well-covered. The private helper cluster is informally described in proof sketches but not named.

- **Proof-sketch depth**: **adequate**. The proof sketches for `lem:section_cech_coface_match` (two-step: abstract unfold + tilde bridge) and `lem:section_cech_ab_exact` (ladder transport) are sufficiently detailed to guide formalization. One Lean-specific engineering detail — the `set g ... with hg_def` technique in `phiL_naturality` (line 1379) to avoid heartbeat explosion from elaborating the `modulesSpecToSheaf` restriction — is not described in the blueprint, but this is a pure proof-engineering artifact, not a mathematical gap.

- **Hint precision**: **loose** for the private helper cluster. `def:qcoh_sections_localized` describes "the comparison of the two IsLocalizedModule structures... supplied by IsLocalizedModule.iso" without naming `phiL`/`phi`. The `sectionToModuleAddEquiv` ladder construction is described conceptually in the proof of `lem:section_cech_ab_exact` ("the degreewise additive isomorphisms e_p = ∏_σ φ_σ ∘ sectionCechProductEquiv_p") but not named. This looseness is acceptable for private helpers but reduces traceability.

- **Generality**: **matches need**. The blueprint correctly scopes the tilde-case delivery and explicitly defers the F ≅ ~(ΓF) reduction (Stacks Tag 01I8) as a named open gap in `def:qcoh_sections_localized` (lines 574–601). The scoping is accurate and non-misleading.

- **Recommended chapter-side actions**:
  1. Add `\lean{}` tags for `phiL`, `phi`, `restr_bridge` to `def:qcoh_sections_localized`.
  2. Add `\lean{}` tags for `phiL_naturality`, `phi_naturality` to `lem:section_cech_coface_match`.
  3. Add `\lean{}` tags for `sectionProdAddEquiv`, `sectionToModuleAddEquiv`, `sectionToModuleAddEquiv_apply`, `sectionProdEquiv_symm_apply` to `lem:section_cech_ab_exact`.
  4. Either make `iInf_fin_succ` and the `CombinatorialCech.*` helpers non-private, or remove them from the blueprint's `\lean{}` lists (they're internal helpers and the public API is correctly tagged).
  5. Track the `CechAcyclic.affine` sorry for eventual refactor: once the planner lands the re-sign, remove the old name from the `\lean{}` list of `lem:cech_acyclic_affine` and add `\leanok` to the block for `sectionCech_affine_vanishing`.

---

## Severity summary

**must-fix-this-iter**: **0**

The one sorry (`CechAcyclic.affine`) is explicitly authorized by the blueprint's `% NOTE:` annotation and lack of `\leanok`. The replacement target `sectionCech_affine_vanishing` is axiom-clean. No signature mismatches that weaken hypotheses. No excuse-comments on declarations the blueprint claims are substantive. No unauthorized axioms or `Classical.choice` on non-trivial claims.

**major**: **0**

The tilde-F restriction in `sectionCech_homology_exact` / `sectionCech_affine_vanishing` is explicitly authorized by the blueprint. No partial signature mismatch introduces a genuine gap beyond what the blueprint acknowledges.

**minor**: **3**

1. `iInf_fin_succ` is `private` in Lean but listed under the public name `AlgebraicGeometry.iInf_fin_succ` in the blueprint's `\lean{}` tag for `def:qcoh_sections_localized`. Similarly, `CombinatorialCech.*` private helpers are listed by public names. These `\lean{}` links are technically incorrect (declarations are not accessible by those names from other files).

2. 12 private helpers in `SectionCechTilde` (`phiL`, `phi`, `restr_bridge`, `phi_naturality`, `sectionToModuleAddEquiv`, etc.) are unlisted from blueprint `\lean{}` tags, reducing proof-architecture traceability. Soft coupling between proof and blueprint.

3. `CechAcyclic.affine := sorry` — the original named target. Blueprint-authorized transitional state, but the plan agent should schedule the eventual `CechAcyclic.affine`-proof-or-removal refactor (replacing `sorry` with a call to `sectionCech_affine_vanishing` once the signature alignment is done).

**Overall verdict**: The 16 `SectionCechTilde` declarations are axiom-clean with signatures faithfully matching the blueprint's tilde-scoped targets; the blueprint correctly authorizes the tilde-only delivery and explicitly defers the F ≅ ~(ΓF) gap — 0 must-fix-this-iter, 0 major, 3 minor findings (all informational or pre-existing).
