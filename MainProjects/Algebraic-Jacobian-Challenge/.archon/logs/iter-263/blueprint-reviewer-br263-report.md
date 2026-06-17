# Blueprint Review Report

## Slug
br263

## Iteration
263

## Scope
Fast-path scoped re-review of two writer-edited chapters only (sanctioned). Both chapters read in
full; cross-refs consulted as needed.

---

## Per-chapter

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex

- **complete**: true
- **correct**: true
- **notes**:
  - `lem:slice_dual_transport` proof: the revised two-step enumerate structure adequately warns the
    prover that identifying the `internalHomObjModule` module action with the pointwise
    `PresheafOfModules.Hom` add/scalar is a **required first move** (step (i)) before the
    change-of-rings compatibility (step (ii)) can apply. The text is explicit: "Until this
    identification is made, the additivity and scalar-compatibility obligations of the transport
    cannot be read off the change-of-rings compatibility, because their sums and scalar multiples
    are taken in the internal-hom structure, not the morphism structure." This directly and
    correctly addresses the lvb-di262 finding. ✓
  - Step (i) characterises the identification as "definitional" — which is mathematically accurate
    (the two module structures are definitionally equal). Iter memory records that the Lean proof
    requires explicit `letI lhsMod/rhsMod` + `LinearEquiv.toModuleIso (m₁:=)(m₂:=)` instance
    pinning rather than bare `rfl`, but this does not invalidate the "definitional" claim at the
    mathematical level. The blueprint is not a tactic script; the characterisation is sound.
    **(Informational)**: a `\lean{LinearEquiv.toModuleIso}` hint with a note that explicit
    `(m₁:=)(m₂:=)` parameter binding is needed might help the prover skip the instance-search
    wall, but this does not block the gate.
  - Two inline `\lean{}` hints added in leg-B: `dualUnitRingSwap` (line 5730) and
    `isIso_ε_restrictScalars_appIso` (line 5733), plus `PresheafOfModules.dualUnitIsoGen` (line
    5736) — all present and in the correct location. ✓
  - `\uses` in proof (`lem:internal_hom_isSheaf`, `lem:restrictscalars_ringiso_dualequiv`) are
    real labels and correctly stated. ✓
  - `\cref{def:presheaf_internal_hom_slice_value}` referenced in the linearity section points to a
    real label (line 5186, `\lean{PresheafOfModules.InternalHom.internalHomObjModule}`). ✓
  - Prior Sq1/D3′ content (cleared by lvb-tos262) is entirely unchanged; the dual edit is
    cleanly isolated to `lem:slice_dual_transport` and its proof. ✓

**HARD GATE**: **SATISFIED** — complete: true, correct: true, no must-fix findings.
Active lanes `Picard/TensorObjSubstrate.lean` (D3′ Sq1) and
`Picard/TensorObjSubstrate/DualInverse.lean` (dual `sliceDualTransport`) may proceed.

---

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: true
- **notes**:
  - **Cosimplicial terminology**: `def:cech_nerve` now correctly uses "cosimplicial" throughout.
    The variance paragraph (lines 84–96) explicitly explains: the geometric nerve is simplicial in
    schemes; applying the covariant direct-image functor yields a cosimplicial object in QCoh(X);
    the associated alternating-coface complex is a cochain complex (differentials raising degree).
    Correct and unambiguous. ✓
  - **`sec:cech_three_part` (new)**: Three-part decomposition present with adequate detail.
    - (1) Geometric backbone (lines 171–189): correctly identifies the backbone as an augmented
      simplicial scheme (not a module-level object), notes it exists unconditionally using only
      coproducts and finite limits. ✓
    - (2) Push-pull functor G (lines 192–219): functor G explicitly defined
      `G : (X/Sch)^op → QCoh(X), (Y →^p X) ↦ p_*(p^*F)`. Functoriality identified as the
      non-formal step, and **explicitly linked** to the coherence of `(p∘q)_* ≅ p_*q_*` and
      `(p∘q)^* ≅ q^*p^*` plus adjunction-unit compatibility — the same coherence machinery
      as the tensor-pullback substrate. This makes the coherence dependency on composition isos
      explicit and traceable. ✓
    - (3) Coherence-free plumbing (lines 221–238): passage from cosimplicial object to cochain
      complex is correctly identified as purely formal (preadditivity of QCoh(S) suffices,
      alternating-sum differential squares to zero by cosimplicial identities). ✓
    - blueprint-clean removed the Lean-name leak; no `\lean{}` or backtick identifiers remain in
      the informal three-part prose. ✓
  - **`lem:cech_computes_cohomology` weakenings**: both documented (lines 407–424).
    - `[HasInjectiveResolutions]` hypothesis: "the derived-functor higher direct image on the
      right-hand side is available only when the category of O_X-modules has enough injectives;
      accordingly this comparison is asserted under the hypothesis that injective resolutions
      exist." ✓
    - `Nonempty(≅)` weakening: "we assert the comparison in the weak form of the existence of an
      isomorphism... without singling out a chosen natural isomorphism." Rationale given:
      downstream consumers need only object-level agreement, not a specific natural transformation.
      ✓
  - **Mathlib-gap notes** on the three downstream lemmas:
    - `lem:cech_acyclic_affine` (lines 347–353): gap stated (standard-cover Cech complex as complex
      of localisations + prime-local contracting homotopy, neither available for sheaves of modules
      on a scheme). ✓
    - `lem:cech_computes_cohomology` (lines 474–478): gap stated (Cech-to-derived-functor spectral
      sequence + Leray spectral sequence for sheaves of modules, both absent from Mathlib). ✓
    - `lem:cech_flat_base_change` (lines 649–655): gap stated (term-wise affine base change of
      Cech complex + exactness of `−⊗_A B` for sheaves of modules, both absent). ✓
  - **Citation discipline**: all `% SOURCE:` lines carry `(read from references/stacks-coherent.tex
    ...)` parentheticals; `references/stacks-coherent.tex` exists on disk; spot-checked
    `def:cech_nerve` source quote at `stacks-coherent.tex` L36–67 — verbatim match confirmed. ✓
  - **Informational note**: `def:cech_higher_direct_image` invokes `lem:cech_computes_cohomology`
    (via `\uses` and prose) only for the subsidiary cover-independence remark; the unconditional
    core definition `R^i f_*F := H^i(Č^•(U,F))` does not actually depend on that lemma. This
    was pre-existing before the bw-cech263 edits and was not part of the flagged findings; it
    does not block the gate. A future cleanup could annotate this `\uses` as "for the cover-
    independence remark only, not the definition itself."

**HARD GATE**: **SATISFIED** — complete: true, correct: true, no must-fix findings.
Active lane `Cohomology/CechHigherDirectImage.lean` (engine `Rⁱf_*`) may proceed.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix findings. Both chapters pass. Two informational
notes recorded (no prover action required).

**Overall verdict**: Both chapters clear the hard gate for their active prover lanes.
`Picard_TensorObjSubstrate.tex` is correct with the `internalHomObjModule`↦morphism-level
identification now adequately documented as the required first move in `lem:slice_dual_transport`.
`Cohomology_CechHigherDirectImage.tex` is now adequate for the `CechNerve` build with backbone,
push-pull functor, and plumbing documented, cosimplicial variance corrected, and all three Mathlib
gaps honestly flagged. — 2 chapters audited, 0 must-fix findings, 0 unstarted-phase proposals.
