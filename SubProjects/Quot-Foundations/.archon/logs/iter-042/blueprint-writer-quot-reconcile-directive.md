# Blueprint-writer directive — Picard_QuotScheme.tex reconciliation (iter-042)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (only this file).

## Strategy context (the slice that matters)

iter-041 closed QUOT **gap1** axiom-clean. The Lean prover absorbed three planned
sub-lemmas inline into one opaque-immersion core (`section_localization_hfr_aux`)
instead of building them standalone. The blueprint now has stale `\lean{}` pins
pointing at non-existent decls and four prover helpers with no blueprint block.
This must be reconciled so the DAG is honest and the **G1-core** block is gate-clear
for a prover THIS iter. The iter-041 lean-vs-blueprint checker
(`task_results/lean-vs-blueprint-checker-quot-iter041.md`) and the iter-042
blueprint-review (`task_results/blueprint-reviewer-iter042.md` §1, §5) give the
exact line numbers and recommended actions.

## Required edits (precise)

### A. Fix three stale `\lean{}` pin mismatches (content absorbed inline iter-041)

1. **`lem:composite_immersion_flocus_basicOpen`** (~line 4330): the pin
   `compositeBasicOpenImmersion_flocus_image` does not exist. The content is two
   claims: (a) `σ(f') = algebraMap R R_s f` (discharged inline as
   `σ.apply_symm_apply`), and (b) `j ''ᵁ D(f') = D(f) ⊓ D(s)` (computed inline via
   `compositeBasicOpenImmersion_image_basicOpen` + `image_basicOpen_eq_inf`). EITHER
   split this block into two with correct pins to the real decls
   `compositeBasicOpenImmersion_image_basicOpen` and `image_basicOpen_eq_inf`, OR
   keep one block, REMOVE the bad `\lean{}` pin, and add
   `% NOTE: content absorbed inline into section_localization_hfr_aux (iter-041); σ-identity = σ.apply_symm_apply, image via compositeBasicOpenImmersion_image_basicOpen + image_basicOpen_eq_inf`.
   Prefer the SPLIT so the real decls get blueprint nodes (see C).

2. **`lem:gamma_image_iso_semilinear_top`** (~line 4357): pin
   `gamma_image_iso_semilinear_top` does not exist (the `he₁`/`he₂` semilinearity
   hypotheses are inline in `section_localization_hfr_aux`). REMOVE the `\lean{}`
   pin and add `% NOTE: absorbed inline into section_localization_hfr_aux (iter-041)`.
   Keep the prose as the mathematical record; fix the `\uses{}` of any block that
   cited it (re-point to `lem:section_localization_hfr_aux`, the new block from C).

3. **`lem:flocus_section_scalar_tower`** (~line 4384): pin
   `flocus_section_scalar_tower` does not exist (the `IsScalarTower` instances are
   inline). REMOVE the `\lean{}` pin and add the same absorbed-inline note. Fix
   citing `\uses{}` to point at `lem:section_localization_hfr_aux`.

### B. Add four missing helper blocks (clear leandag `unmatched`)

Author a `\begin{lemma}` block for each real Lean decl below, with `\label`,
`\lean{<full name>}`, an accurate `\uses{}` reflecting what its Lean proof needs, and
a one-to-three-line informal proof. These are implementation helpers — terse blocks
are fine; the point is the DAG edges. Lean names (in namespace
`AlgebraicGeometry.Scheme.Modules`, except the first which may be elsewhere — verify):

1. `image_basicOpen_of_affine` (~line 2027): for an open immersion `j` of affine
   schemes, `j ''ᵁ D(f') = (Spec R).basicOpen ((j.appIso ⊤).inv ((ΓSpecIso S).inv f'))`.
   Proof: `← basicOpen_eq_of_affine` + `Scheme.image_basicOpen`.
2. `compositeBasicOpenImmersion_image_basicOpen` (~line 2038): instantiation of the
   above at the concrete composite immersion `j = compositeBasicOpenImmersion`.
3. `image_basicOpen_eq_inf` (~line 2051): `j ''ᵁ D(f') = (j ''ᵁ ⊤) ⊓ (Spec R).basicOpen g`
   under the transport hypothesis. Proof: `Scheme.basicOpen_res`.
4. `section_localization_hfr_aux` (~line 2075): the opaque-`j` proof engine for the
   geometric `Hfr` producer (combiner `isLocalizedModule_powers_transport` + section
   isos `e₁/e₂` + restriction intertwiner + `eqToHom`/`of_linearEquiv` open-transport;
   `maxHeartbeats 1600000`). This is the block that ABSORBS the content of the three
   blocks in A — its `\uses{}` should cite the tilde/section infra those blocks
   describe. `lem:section_localization_hfr_basicOpen` should `\uses{lem:section_localization_hfr_aux}`.
   Record the load-bearing lesson in the proof prose: the immersion `j` must stay
   OPAQUE in this helper or the final form-coercion is a >3.2M-heartbeat `whnf`
   runaway.

### C. Confirm G1-core + gap2 blocks are prover-ready (do NOT mark `\leanok`)

- **G1-core** `lem:qcoh_affine_section_localization` (~lines 2716–2762), Lean target
  `isLocalizedModule_basicOpen_of_isQuasicoherent` (not yet built). The proof is a
  one-line corollary of gap1: `isLocalizedModule_restrict_of_isIso_fromTildeΓ M.fromTildeΓ (isIso_fromTildeΓ_of_isQuasicoherent hqc)`.
  KEEP the `% NOTE: the Lean decl does NOT yet exist` — it is accurate and marks the
  prover objective. Confirm the `\uses{}` (lines ~2719) is
  `{lem:qcoh_affine_isIso_fromTildeΓ, lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ, lem:isLocalization_basicOpen_mathlib}`.
- **gap2** `lem:qcoh_section_localization_basicOpen` (~line 2478), Lean target
  `isLocalizedModule_basicOpen` (general scheme X, not yet built). Upgrade its proof
  sketch so a prover can ATTEMPT it AFTER G1-core: cover X by affine opens `Spec A_i`,
  apply G1-core (`isLocalizedModule_basicOpen_of_isQuasicoherent`) on each affine
  patch, and glue (the localization property is local on the base). Add `\uses{lem:qcoh_affine_section_localization}`.
  Keep its `% NOTE` flagging it as the next step after G1-core. If you judge the
  affine-cover gluing argument needs a genuinely new gluing lemma not yet in the
  chapter, say so explicitly in the prose (do not paper over it) — the planner flagged
  an "infinite onion" gluing risk.

## Out of scope
- The 4 protected iter-176 stubs (`hilbertPolynomial`/`QuotFunctor`/`Grassmannian`/
  `representable`).
- The annihilator reverse inclusion (line ~2334) — leave the existing note; not this iter.
- Do NOT add or remove `\leanok` (the deterministic sync owns it).
- Do NOT touch any other chapter.

## References
Hartshorne II.5.3 / Stacks `lemma-invert-f-sections` back the producer; cite from the
existing chapter source comments. `references/**` is authorized if you need to verify a
quote, but no new source should be necessary for this reconciliation.
