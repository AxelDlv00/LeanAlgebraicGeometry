# Blueprint Review Report

## Slug
br254

## Iteration
254

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Sub-step (a) rewrite: sectionwise form is mathematically correct and satisfiable — see detail below.
  - New `lem:scheme_modules_hom_local_section` proof block: faithful and adequate — see detail below.
  - All D1′ and dual-chain lemmas confirmed intact (no regression from br-fix253).

---

### Detailed gate findings

#### 1. Sub-step (a) — sectionwise hypothesis is correct and satisfiable

The new hypothesis reads: *for all i, j and every open V ⊆ Uᵢ ∩ Uⱼ, the section maps (fᵢ).app(V) and (fⱼ).app(V) agree as morphisms in the single fixed abelian-group hom-type M(V) → N(V).*

This is **mathematically correct**: given fᵢ : M|_{Uᵢ} → N|_{Uᵢ}, for any V ⊆ Uᵢ the component (fᵢ).app(V) is well-defined after conjugation by the canonical eqToHom arising from the down-set identity ι_i(ι_i⁻¹(V)) = V (valid precisely because ι_i is an open immersion), and lands in the single fixed type M(V) → N(V). This form is **satisfiable**: any caller who constructs the family (fᵢ) from a common source (e.g., restricting local trivializations of a canonical construction) will have sectionwise equality at every V ⊆ Uᵢ ∩ Uⱼ as a direct consequence.

The contrast paragraph correctly diagnoses why the naïve HEq form (comparing double-restrictions as whole module morphisms) fails: the two double-restrictions land in the sheafifications of pullback presheaves along *different* morphisms, which are isomorphic but not propositionally equal, making HEq unsatisfiable. No Subsingleton.elim can bridge distinct sheafified objects. This is accurate and will prevent provers from attempting the wrong formulation.

#### 2. IsCompatible bridge — sound; Subsingleton.elim confined to legitimate use

The proof of step (a) (lines 5829–5886) proceeds as follows:

1. Restrict `localSection i` to Uᵢ ⊓ Uⱼ and evaluate at V ⊆ Uᵢ ⊓ Uⱼ; by `lem:scheme_modules_hom_local_section`, this gives (fᵢ).app(V') conjugated by eqToHom (the down-set identity for Uᵢ). Same for j.
2. Both conjugated terms land in the fixed group M(V) → N(V). The sectionwise hypothesis directly equates the middle terms (fᵢ).app(V') and (fⱼ).app(V').
3. The only residual identification is that the two eqToHom-conjugation routes — built from the down-set identities for Uᵢ and Uⱼ respectively — agree; these are *parallel morphisms in the thin poset* (Opens X)^op, so Subsingleton.elim applies.

The division of labour is correctly drawn: Subsingleton.elim collapses the thin-poset path difference; it is **not** asked to bridge the section maps themselves. This is the legitimate use. The bridge to `IsCompatible` is therefore **sound** with no hand-wave.

#### 3. `lem:scheme_modules_hom_local_section` — new proof is faithful and adequate

The proof block (lines 5737–5763) provides:

- An explicit construction of the component at (V, h : V → Uᵢ): take (fᵢ).app(V') where V' = ι_i⁻¹(V), conjugate by M(eqToHom) on source and N(eqToHom) on target (arising from ι_i(ι_i⁻¹(V)) = V).
- The naturality condition (for a morphism φ of Over Uᵢ): the two composite routes each reduce to an equality of parallel morphisms in the thin poset (Opens X)^op and thus hold by Subsingleton.elim; combined with the naturality of the underlying ab-presheaf morphism of fᵢ across the induced inclusion κ, both routes agree.
- The link to `lem:open_immersion_slice_sheaf_equiv` as the named authority for this pattern.

This is **adequate for formalization**: the prover receives the definition of the local section component, the key eqToHom identity, and the precise location of the coherence burden (the naturality check, resolved by Subsingleton.elim on the thin poset). The build scope warning (multi-piece, naturality first) is actionable.

#### 4. No new dangling `\uses{}`/`\cref{}`

- `lem:scheme_modules_hom_local_section` (statement block, line 5719): `\uses{lem:open_immersion_slice_sheaf_equiv}` → label exists at line 5385. ✓
- `lem:scheme_modules_hom_local_section` (proof block, line 5738): `\uses{lem:open_immersion_slice_sheaf_equiv}` → same label. ✓
- `lem:sheafofmodules_hom_of_local_compat` (proof block, line 5779): `\uses{def:scheme_modules_homMk, lem:open_immersion_slice_sheaf_equiv}` → both labels exist (lines 5698 and 5385 respectively). ✓

No other new references were introduced. No dangling cross-references.

#### 5. D1′/comparison-iso lemmas — unchanged, no regression

- `lem:pullback_tensor_map` (line 3042): `\leanok`, complete proof. ✓
- `lem:pullback_tensor_map_natural` (line 3285): `\leanok`, complete proof. ✓
- `lem:isiso_pullbacktensormap_of_sheafifydelta` (line 3089): `\leanok`. ✓
- `lem:pullback_tensor_map_basechange` (line 3846): present. ✓

No regression from br-fix253.

#### 6. Dual chain — unchanged, complete+correct

- `lem:dual_restrict_iso` (line 5450): complete statement + proof (legs A and B spelled out, ring-iso transport via `lem:restrictscalars_ringiso_dualequiv`, poset-thin naturality by Subsingleton.elim, alternative route noted). All referenced labels exist. ✓
- `lem:dual_unit_iso` (line 5566): complete statement + proof (evaluation-at-1 isomorphism, sheafification through `lem:internal_hom_isSheaf`). All referenced labels exist. ✓
- `lem:dual_isLocallyTrivial` (line 5598): complete statement + three-step proof chain (`lem:dual_restrict_iso` → `def:scheme_modules_dual_iso_of_iso` → `lem:dual_unit_iso`). All referenced labels exist. ✓

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: `Picard_TensorObjSubstrate.tex` is complete and correct after bw254's patch; sub-step (a) is mathematically correct with a satisfiable sectionwise hypothesis, the IsCompatible bridge is sound with Subsingleton.elim confined to the legitimate thin-poset collapse, the new `lem:scheme_modules_hom_local_section` proof is adequate for formalization, no dangling references were introduced, and the D1′/dual-chain lemmas are unchanged from br-fix253. Both `Picard/TensorObjSubstrate.lean` and `Picard/TensorObjSubstrate/DualInverse.lean` may proceed to prover dispatch this iter.
