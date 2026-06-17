# Blueprint-clean report — iter-060

## Scope reviewed

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

Blocks touched by the two iter-060 writer rounds:
- `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`
- `lem:subsingleton_ext_of_iso_fst`
- `lem:enoughInjectives_of_hasInjectiveResolutions`
- `lem:overProd_coproduct_distrib_right`
- `lem:coproduct_distrib_fibrePower` (expanded sketch)
- `lem:cech_backbone_left_sigma` (expanded sketch)
- `lem:jshriek_transport_along_iso` (rewritten to coyoneda route)
- `lem:pushforward_commutes_restriction` (new R1 lemma)
- `lem:pushforward_iso_preserves_qcoh` (rewritten to of_coversTop/R1 route)
- `lem:ext_jShriekOU_eq_zero_of_specIso`
- 4 new Mathlib anchors (`isQuasicoherent_of_coversTop`, `nonempty_quasicoherentData`,
  `coyoneda_fullyFaithful`, `isAffineOpen_image_of_iso`)

## Findings

### Lean leakage in prose — fixed

**1. `lem:coproduct_distrib_fibrePower` statement body (previously line ~7790)**

The "Slice-product normal form" paragraph contained two Lean-specific phrases:
- `"In the formalization the recursion is carried out in"` — references the Lean formalization
  context, not the mathematical argument.
- `"reusable and Mathlib-aligned"` — Mathlib is an implementation detail.

Fixed to: `"The proof carries out the recursion in"` and `"reusable"`.

**2. `lem:pushforward_iso_preserves_qcoh` proof closing paragraph (previously lines ~9683-9688)**

The closing paragraph correctly opened with the Stacks attribution remark (kept), but
then added two Lean-specific sentences:
- `"Mathlib packages no reusable quasi-coherence-preservation lemma for
  \operatorname{Scheme.Modules.pushforward}, so the proof realises the transport explicitly ..."`
- `"structurally mirroring the \operatorname{presentation} field of the quasi-coherent-data
  \operatorname{bind} construction."`

Both removed. The first is a meta-remark about Mathlib's library state; the second names
a Lean structure field (`presentation`) and a Lean monadic idiom (`bind`). Neither belongs
in the math blueprint.

### No issues found

- **`lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`**: clean math proof, no Lean leakage.
- **`lem:subsingleton_ext_of_iso_fst`**: clean.
- **`lem:enoughInjectives_of_hasInjectiveResolutions`**: clean.
- **`lem:overProd_coproduct_distrib_right`**: clean.
- **`lem:jshriek_transport_along_iso`**: coyoneda-corepresentability route is pure math; clean.
- **`lem:pushforward_commutes_restriction`**: clean.
- **`lem:ext_jShriekOU_eq_zero_of_specIso`**: clean.
- **4 new Mathlib anchors**: standard `\mathlibok` blocks, clean.
- **`lem:cech_backbone_left_sigma` "Universe reduction" paragraph**: mathematical universe
  argument (FinitaryPreExtensive Type 0 constraint), no Lean syntax in prose.

### SOURCE / SOURCE QUOTE discipline

- `lem:pushforward_iso_preserves_qcoh`: has `% SOURCE` + `% SOURCE QUOTE` from Stacks Schemes. ✓
- `lem:open_immersion_pushforward_comp`: has `% SOURCE` + `% SOURCE QUOTE PROOF` from
  Stacks coherent. ✓
- Remaining new blocks derive results not directly from references; no SOURCE annotation
  required.

### `\leanok` / `\mathlibok` markers

Not touched (per directive).

## leandag build verification

Before and after edits:
- `unknown_uses: []`
- `isolated count: 0`
- Status: **CLEAN**
