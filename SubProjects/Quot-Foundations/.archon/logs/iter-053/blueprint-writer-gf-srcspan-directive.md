Target: blueprint/src/chapters/Picard_FlatteningStratification.tex
Action: RE-SPEC the G3.2 / assembly / `genericFlatness`-close section around a SOURCE-SPAN descent. The blueprinted stalk route is a confirmed DEAD END (Mathlib has NO `SheafOfModules.stalk`; G3.2 `lem:gf_stalk_flat_over_base` and the assembly cannot even be typed over stalks). Replace the stalk machinery with:

(B1) NEW algebraic Mathlib-gradient sub-lemma `lem:gf_flat_localizedModule_sameBase`,
  \lean{AlgebraicGeometry.gf_flat_localizedModule_sameBase}. Statement: for a tower R→B→N (N a B-module, hence R-module) and a submonoid T ⊆ B, if N is R-flat then `LocalizedModule T N` is R-flat. Proof sketch: localization commutes with `lTensor` — `LocalizedModule T (N ⊗_R K) ≅ (LocalizedModule T N) ⊗_R K` naturally for every R-module K — and localization at T is exact, so it preserves the injectivity of `K ↪ K'  ⟹  N⊗K ↪ N⊗K'` that defines R-flatness. This is the one genuine Mathlib gap (the existing `Module.Flat.localizedModule`/`of_isLocalizedModule` localize over a submonoid of the BASE R, not the source B).

(B2) NEW geometric sub-lemma: chart-independent section-localization `Γ(F, D(g)) ≅ (M_j)_g` for basic opens `D(g) ⊆ W ∩ W_j` (QC-module sheaf condition — reuse the project's gap2 `isLocalizedModule_basicOpen` machinery), plus the base-ring comparison `Γ(S,U)` vs `A_f` as A-algebras. Give it a `\label`+`\lean{}` placeholder name `lem:gf_section_localization_flat_descent`.

(NEW assembly) Rewrite `lem:gf_flat_locality_assembly` to close `Module.Flat Γ(S,U) Γ(F,W)` (arbitrary affine W ≤ p⁻¹U) via the SOURCE-side span criterion `Module.flat_of_isLocalized_span` on the finite basic-open cover `{D(g) ⊆ W ∩ W_j}` aligned to the patches, feeding B1 + B2 + the DONE per-patch freeness on each cover element. Repoint `genericFlatness`'s `\uses{}` to the new assembly and DROP the dead stalk `\uses` (`lem:gf_stalk_flat_over_base`). Keep the 3 DONE anchors `lem:gf_patch_free_imp_flat`, `lem:gf_flat_base_local_on_source`, `lem:gf_stalk_flat_localBase` intact (they stay in the new chain).

Add a Mathlib dependency anchor block (\mathlibok) for `Module.flat_of_isLocalized_span` (\lean naming the real Mathlib decl in `Mathlib.RingTheory.Flat.Localization`) if not already present.

References: Nitsure §4 "Lemma on Generic Flatness" (references/nitsure-hilbert-quot.pdf / -src) — source-span flat-locality is the standard descent; cite it. Hartshorne III.9 flat families as companion.
Constraints: math-only prose, NO Lean tactics, NO `\leanok`. Keep the existing source-quote citations. Do not delete the stalk blocks' `% NOTE:` history; supersede them. <180 words of new prose per block.
