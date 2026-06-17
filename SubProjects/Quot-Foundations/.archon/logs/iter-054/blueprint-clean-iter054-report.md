# Blueprint-clean report — iter-054

## Status: DONE

All three edited chapters cleaned. No new SOURCE quotes needed (all new blocks are
Archon-original / standard-fact restatements). No `\mathlibok` removed. No `\leanok`
touched. All LaTeX environments balanced.

---

## Changes made

### `Picard_FlatteningStratification.tex`

**G3 proof (`lem:gf_flat_locality_assembly`):**
- Removed informal citation references `\cite{nitsure-hilbert-quot}~\S4 (cf.\ Hartshorne, \emph{Algebraic Geometry}, III.9, flat families)` from the opening sentence of the proof.
  Reason: all four new B2 blocks (`gf_crossChart_basicOpen_eq`, `gf_section_localization_twoleg`, `gf_base_localization_comparison`, `gf_crossChart_spanning_cover`) and the G3 assembly are Archon-original; no citation belongs in the proof under the surrounding unsourced-block convention.

No other changes needed: all new B2 blocks have correct `\label`, `\lean{}`, `\uses{}`; the Mathlib anchor `lem:mathlib_scheme_basicOpen_res` retains its `\mathlibok`.

---

### `Picard_GrassmannianQuot.tex`

**`lem:gr_opensMap_final` proof:**
- Removed trailing sentence "This is the general ``pullback of free is free'' unlock, reusable beyond this chapter." — project-specific meta-commentary not appropriate in a timeless mathematical document.

**Connecting prose between `lem:gr_pullbackObjUnitToUnit_comp` and `def:grassmannian_functor`:**
- Replaced `(\(\mathrm{map\_id}\) and \(\mathrm{map\_comp}\))` with `(identity and composition)` — `map_id`/`map_comp` are Lean functor-field names, not mathematical terminology.

All six new blocks (`gr_opensMap_final`, `gr_pullbackFreeIso`, `gr_pullback_isLocallyFreeOfRank`, `def:gr_rankQuotient`, `gr_pullbackObjUnitToUnit_id`, `gr_pullbackObjUnitToUnit_comp`) have correct `\label`, `\lean{}`, `\uses{}` (where applicable). No source quotes needed.

---

### `Picard_SectionGradedRing.tex`

**`lem:relativeTensor_objectwise_coequalizer` proof:**
- Removed the closing paragraph listing Lean declaration names (`actLmap`, `actRmap`, `projL`, `projL_surjective`, `projL_comp_act`, `aL`, `aR`, `piMor`, `piMor_epi`, `coeq_condition`, `cofork`, `descHom`, `descMor`, `descFac`, `isColimitCofork`, and the `*_tmul`/`*_apply` rfl-computation note). These are Lean implementation internals; the mathematical content of the proof is fully covered by the preceding paragraphs.

**`lem:relativeTensor_as_coequalizer` proof:**
- Removed the "Caveat to verify in formalisation" paragraph, which leaked `\mathrm{GrothendieckTopology.W.monoidal}` and `\texttt{Sites/Monoidal.lean}` — Lean identifier and source-file names with no place in a mathematical blueprint. The identification of the apex (step 3) now ends cleanly after establishing the coequalizer characterisation.

Three Mathlib anchors (`lem:tensorProduct_liftAddHom_mathlib`, `lem:evaluationJointlyReflectsColimits_mathlib`, `lem:presheaf_tensorObj_obj_mathlib`) retain their `\mathlibok` markers and are unchanged.

---

## Validation summary

| Chapter | Env balance | `\leanok` modified | `\mathlibok` removed | New SOURCE quotes added |
|---------|-------------|-------------------|---------------------|------------------------|
| Picard_FlatteningStratification.tex | OK | No | No | No |
| Picard_GrassmannianQuot.tex | OK | No | No | No |
| Picard_SectionGradedRing.tex | OK | No | No | No |
