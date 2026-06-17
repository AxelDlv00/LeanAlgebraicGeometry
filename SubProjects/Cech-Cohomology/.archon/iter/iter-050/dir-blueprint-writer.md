# Blueprint-writer directive — fix the 02KG change-of-base sketch + clear coverage debt

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated chapter; it
`% archon:covers` `AffineSerreVanishing.lean` among others).

## Strategy context (the slice that matters)
02KG affine Serre vanishing. iter-049's prover reduced BOTH targets — `lem:affine_cech_vanishing_qcoh`
(the seed) and `lem:affine_serre_vanishing` (the top) — to a SINGLE residual: positive-degree section
Čech vanishing of the tilde sheaf `~M` (`M = Γ(Spec R, F)`) over a standard cover of a **proper**
distinguished open `D(f)`. The existing sketch of `lem:affine_cech_vanishing_qcoh` (chapter lines
~6082–6093) is **mathematically incorrect** and must be fixed (see `% NOTE` already in the block at
lines 6056–6066, and `task_results/lean-vs-blueprint-checker-iter049-asv.md`).

## Task 1 — FIX the proof of `lem:affine_cech_vanishing_qcoh` (the must-fix)
The current proof claims "the standard-cover Čech vanishing of `lem:cech_acyclic_affine`
(`sectionCech_affine_vanishing`) applies to `~M` over **any** standard cover." This is FALSE:
`lem:cech_acyclic_affine` requires the cover family to span the **whole** unit ideal of `R`
(`Ideal.span (range s) = ⊤`, i.e. a cover of all of `Spec R`). But the affine cover system's covers
are of an arbitrary distinguished open `D(f)`, where `{gᵢ}` only generate an ideal whose radical
contains `f` — they do NOT span `R` for proper `D(f)`.

Rewrite the proof to the **change-of-base-to-`R_f`** argument (Stacks 02KG "Write `U = Spec(A)`",
which invokes `lemma-cech-cohomology-quasi-coherent-trivial`). Structure:
1. By `lem:qcoh_iso_tilde_sections` (now unconditional), `F ≅ ~M`, `M = Γ(X,F)`; transport reduces the
   claim for `F` to the same claim for `~M` (cite the transport helper — see Task 3, the
   `cechCohomology_isZero_of_iso` block).
2. The residual for `~M`: for a standard cover `D(f) = ⨆ᵢ D(gᵢ)` and `p>0`,
   `Ȟᵖ({D(gᵢ)}, ~M) = 0`. Proof: set `R_f = Localization.Away f`. Each section
   `Γ(D_R(g_σ), ~_R M) = M_{g_σ}`; since `D(g_σ) ⊆ D(f)`, `f` is already invertible in `R_{g_σ}`, so
   `M_{g_σ} = (M_f)_{g_σ}`. The whole section Čech complex over `{D_R(gᵢ)}` is therefore isomorphic,
   AS A COCHAIN COMPLEX of abelian groups, to the section Čech complex of `~_{R_f} M_f` over
   `{D_{R_f}(gᵢ/1)}` (degreewise the per-`σ` localization iso; differentials = alternating sums of
   restriction/localization maps, which commute). Over `R_f` the family `{gᵢ/1}` spans `⊤`
   (Task 2 lemma), so `lem:cech_acyclic_affine` applies to `~_{R_f} M_f` and kills positive homology;
   transport along the cochain iso gives the `~_R M` vanishing.

Make the `\uses{}` of the proof reflect the real deps: keep `lem:cech_acyclic_affine`,
`lem:qcoh_iso_tilde_sections`; ADD the new sub-lemma labels you create in Tasks 2–3.

## Task 2 — give the new sub-lemmas their own \label/\lean blocks (the change-of-base chain)
Author small lemma blocks (statement + one-paragraph informal proof + accurate `\uses{}`) for the
decomposition. Use these Lean targets (all real, axiom-clean unless noted):
- **`lem:affine_cover_span_localizationAway`** → `\lean{AlgebraicGeometry.affine_cover_span_localizationAway}`
  (DONE). Statement: if `D(gᵢ)` cover `D(f)` in `Spec R`, the images `algebraMap R (Localization.Away f) (gᵢ)`
  span `⊤`. Proof: `D(f)=⨆ D(gᵢ)` pulls back under `Spec R_f ≅ D(f)` to `⨆ D(gᵢ/1) = ⊤`, and `f` is a unit
  in `R_f`. `\uses{}` may cite the Mathlib spanning/basicOpen anchors.
- The residual itself — name it e.g. **`lem:affine_cech_vanishing_tilde_subcover`** (the `htilde` form):
  for an `R`-module `M`, `f`, `g : Fin n → R` with `D(f) = ⨆ D(gᵢ)` and `p>0`,
  `Ȟᵖ({D(gᵢ)}, ~M) = 0`. Proof = the change-of-base argument of Task 1 step 2. `\uses` =
  `lem:cech_acyclic_affine, lem:affine_cover_span_localizationAway`, plus the two NEW infra lemmas below.
- The two pieces of infra the residual proof needs (state them; they are NOT yet Lean decls — leave
  unpinned or pin with a `% TODO` placeholder name the prover will create):
  (a) per-`σ` section iso `Γ(D_R(g_σ),~_R M) ≅ Γ(D_{R_f}(g_σ/1),~_{R_f} M_f)` (both `= M_{g_σ}`);
  (b) the cochain-complex iso assembling (a) degreewise. Give each a `\label` so the residual can `\uses`
  them; note in prose that `QcohRestrictBasicOpen` (`modulesRestrictBasicOpen`,
  `modulesRestrictBasicOpenIso`, `presentationModulesRestrictBasicOpen`) is the intended engine.

## Task 3 — coverage-debt blocks for the remaining new lean_aux nodes
- **`cechCohomology_isZero_of_iso`** → `\lean{AlgebraicGeometry.cechCohomology_isZero_of_iso}`. A reusable
  transport lemma: an iso `F ≅ G` of presheaves transports Čech-vanishing from `F` to `G`
  (`(homologyFunctor).mapIso ∘ (sectionCechComplexFunctor U).mapIso`). One-line proof. Cite it from
  `lem:affine_cech_vanishing_qcoh`'s proof for step 1.
- **`affine_cech_vanishing_qcoh_of_tildeVanishing`** and **`affine_serre_vanishing_of_tildeVanishing`**
  are the CURRENT reduced (conditional-on-`htilde`) formalization forms of `lem:affine_cech_vanishing_qcoh`
  and `lem:affine_serre_vanishing`. Bundle each Lean name into the existing target block's `\lean{...}`
  list (so the unmatched scan clears), and add ONE sentence to each block noting "currently formalized in
  the reduced `_of_tildeVanishing` form pending the residual `lem:affine_cech_vanishing_tilde_subcover`."

## References
- `references/stacks-coherent.tex` Tag **02KG** (`lemma-quasi-coherent-affine-cohomology-zero`, proof,
  condition (3)) and `lemma-cech-cohomology-quasi-coherent-trivial` (the "Write U = Spec A" change-of-base).
  Read these and insert a verbatim `% SOURCE QUOTE:` for the change-of-base step.

## Out of scope
- Do NOT touch `lem:cech_augmented_resolution` / any P5a block (separate lane, already gate-cleared).
- Do NOT add `\leanok` anywhere (deterministic sync_leanok owns it).
- Do NOT alter the protected/frozen `cech_computes_higherDirectImage` block.
- Do NOT rewrite the cover-system `def:affine_cover_system` or its field lemmas (they are correct/DONE).
