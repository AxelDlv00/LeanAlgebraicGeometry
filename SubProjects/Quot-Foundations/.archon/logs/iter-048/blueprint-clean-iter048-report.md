# Blueprint Clean — iter-048

**Files cleaned:**
- `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Changes made

### `Picard_FlatteningStratification.tex`

**1. Lean identifier leakage in `lem:gf_noether_clear_denominators` proof, Step 2 (~line 489)**

Removed three Lean-specific references from the mathematical prose:
- `\texttt{IsIntegral.exists\_multiple\_integral\_of\_isLocalization}` (Lean declaration name)
- `\mathrm{MvPoly}\,A` and `\mathrm{MvPoly}\,K` (Lean shorthand for `MvPolynomial`)
- `C(a_x)` (Lean notation for constant polynomial injection)
- "the landed proof discharges" (project-narrative language)

Replaced Step 2 with a clean mathematical statement: "a standard integrality-and-localization descent argument yields a non-zero $a_x \in A$ such that $a_x \cdot (1 \otimes x)$ is integral over $A[b_1,\dots,b_n]$".

**2. Lean identifier leakage in G3 proof (`lem:gf_flat_locality_assembly`, ~line 1977)**

Removed all `\mathrm{Module.Flat.of_*}` and `\texttt{[expected]}` patterns from the proof prose:
- `\(\mathrm{Module.Flat.of\_free}\) \texttt{[expected]}`
- `\(\mathrm{Module.Flat.of\_projective}\) \texttt{[expected]}`
- `\(\mathrm{Module.Flat.of\_localization\_span}\) \texttt{[expected]}`
- `\(\mathrm{Module.flat\_of\_isLocalized\_maximal}\) \texttt{[expected]}`
- `\(\mathrm{Module.Flat.of\_isLocalization}\) \texttt{[expected]}`
- "captured by \(\mathrm{IsLocalization}\)" (Lean typeclass name)
- "the applicable Mathlib criterion is the localize-on-a-span / localize-at-maximals statement" (Lean-specific description)
- "the cover $\{W_j\}$ is the spanning family fed to \(\mathrm{Module.Flat.of\_localization\_span}\)"

Replaced with clean mathematical language: "a free module is flat (via free ⇒ projective ⇒ flat)", "the flat-locality criterion assembles the per-patch flatness", "localization preserves flatness of both ring and module: a localization of a flat module along a localization of the base ring is again flat."

### `Picard_SectionGradedRing.tex`

**3. Project-history language in introductory paragraph (~line 25)**

`"have no direct Mathlib counterpart at the pinned commit"` → `"have no direct Mathlib counterpart"`

**4. Project-history language in `lem:sheafTensorPow_add` proof remark (~line 342)**

`"which is not available at the pinned commit"` → `"that is not built in this chapter"` (describing a mathematical scope boundary, not a snapshot of implementation state).

---

## Source quote verification

All `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:` comments in the newly edited blocks were verified against the local reference files:

| Quote | Reference | Lines | Status |
|---|---|---|---|
| `lem:gf_finiteType_affine_finite_cover_generated` proof | `references/stacks-properties.tex` L2101–2107 | Verbatim ✓ |
| `lem:gf_qcoh_sections_free_epi` proof | `references/stacks-properties.tex` L2106–2107 | Verbatim ✓ |
| `lem:sheafTensorPow_add` | `references/stacks-modules.tex` L4249–4254 | Verbatim ✓ |

New seam-1 lemmas (`lem:gf_localGenerators_restrict`, `lem:gf_affine_finite_standard_subcover`, `lem:gf_finite_gen_iff_free_epi`) are project-built and require no source quotes.

---

## Markers preserved

- All `\leanok` and `\mathlibok` markers untouched.
- All `\lean{}` pins and `\uses{}` edges untouched.
- All `% SOURCE`, `% SOURCE QUOTE`, `% NOTE`, and `% LEAN STATUS` comment blocks untouched.

---

## Flag for review agent

**Mathematical inconsistency in `lem:gf_qcoh_sections_free_epi` proof:** The proof asserts "the left adjoint $\widetilde{(-)}$ is fully faithful" and "a fully-faithful left adjoint has invertible counit on its image", but `lem:tilde_adjunction_mathlib` (the Mathlib-provided lemma it cites) only states that the left adjoint is *faithful*, not fully faithful. The unit isomorphism $N \xrightarrow{\sim} \Gamma(\widetilde{N}, V)$ is a stronger claim. Mathematically, the unit is indeed always an isomorphism for the tilde functor on an affine scheme; however `lem:tilde_adjunction_mathlib` should be strengthened to explicitly record full faithfulness (or the unit-iso fact), or the proof should cite an explicit unit-iso lemma. This is a review-agent concern, not a cleaning issue.
