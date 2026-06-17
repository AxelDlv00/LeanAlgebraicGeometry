Target: blueprint/src/chapters/Picard_FlatteningStratification.tex — ONLY the
block `lem:gf_flat_locality_assembly` (G3, ~line 1822) and its proof. Do NOT edit
any other block (seam-1 / `lem:gf_qcoh_finite_sections_globally_generated` /
`lem:gf_qcoh_sections_free_epi` are reviewed-correct — leave them verbatim).

Action: Rewrite the G3 proof. The blueprint-reviewer iter-049 found TWO concrete
math errors that must be removed:

  ERROR 1 — "Flat-locality on the source" step: the current proof claims the
  geometric patches `W_j = Spec B_j` on the SOURCE X form a covering family of the
  BASE ring `A_f`, assembling per-patch flatness of `(M_j)_f` over `A_f` into
  global flatness. This conflates source patches with localizations of the base
  ring; no Mathlib lemma supports it.

  ERROR 2 — "Stability under base-restriction" step: claims `Γ(S,U)` is a
  localization of `A_f` for a GENERAL affine `U ≤ D(f)`. FALSE — true only when
  `U = D(fg)` is a BASIC open of `Spec A_f`. Also misuses
  `lem:gf_qcoh_fintype_finite_sections` (gives finiteness, not a localization id).

Correct route to write (reviewer-supplied):
  - Prove `M` flat over `A_f` by the ring-level locality criterion
    `Module.Flat.of_localizationSpan` (or `Module.Flat` localization-span family)
    applied to the BASE `A_f`: check `M_𝔭` flat over `(A_f)_𝔭` for primes 𝔭,
    using quasi-coherence to identify sections on the basic-open cover `D(f g_k)`
    via `lem:qcoh_section_localization_basicOpen` (gap2, DONE) and the per-patch
    freeness of `(M_j)_f`. Restrict to BASIC opens only; do not assert general-U
    localization.
  - State the concrete Mathlib flat-locality lemma name(s) you rely on (verify
    they exist; tag `[verified]`/`[expected]` in a `% NOTE:` if unsure — do NOT
    invent). Candidates: `Module.Flat.of_localizationSpan`,
    `Module.flat_of_isLocalized_maximal`, `Module.Flat.of_localization_span`.

Constraints:
  - Keep statement + `\label`/`\lean{}`/`\uses{}` intact (re-point `\uses{}` only to
    add `lem:qcoh_section_localization_basicOpen` if the proof now uses it).
  - Citation discipline if you quote Stacks/Nitsure; otherwise project-original is OK.
  - Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors.
  - Out of scope: the G1 base case and seam-1 (already correct). G3 only.
