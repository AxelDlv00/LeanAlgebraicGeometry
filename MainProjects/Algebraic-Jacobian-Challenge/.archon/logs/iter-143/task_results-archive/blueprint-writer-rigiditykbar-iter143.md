# Blueprint Writer Report

## Slug
rigiditykbar-iter143

## Status
COMPLETE — all four directive edits landed (Edits 1–4, including the optional Edit 3 on Route (b'2) items 2–4 decomposition).

## Target chapter
`blueprint/src/chapters/RigidityKbar.tex`
(1349 LOC at iter-141 close → **1634 LOC after iter-143 edits**; net delta **+285 LOC**, no deletions).

## Changes Made

### Edit 1: d_app recipe iter-142 empirical lessons + Step 3 sub-recipe decomposition

Inserted in the d_app NOTE block of `lem:GrpObj_omega_basechange_proj`'s proof, immediately after the iter-141 `Implementation note` (the `d_map`-pattern verbatim example block):

- **Replaced the iter-141 combined LOC estimate** `~50–90 LOC` with the iter-142 empirical band `~40–80 LOC`. The new envelope breakdown is `~20–40 LOC` for Step 3 chase + `~5–10 LOC` for `d_map` discharge + `~15–30 LOC` for the explicit `change`-skeleton wiring (the d_map closure landed in the lower portion of the band, validating the iter-142 estimate).
- **Added "NOTE iter-142 (empirical lessons; d_map closure transferable to d_app)"** containing Rules 1–3:
  - **Rule 1 (fully-explicit `change`)**: any `change` block crossing a `pushforward₀`-annotated definition must spell both LHS and RHS fully explicitly; placeholder triggers a deterministic `whnf` timeout at `maxHeartbeats=200000`. Concrete d_app form spelled out (the `KD.d ((ψ.app X).hom ((φ_G.app X).hom a)) = 0` shape; the iter-142 d_app skeleton at `Cotangent/GrpObj.lean:611–618` already lands this).
  - **Rule 2 (`NatTrans.naturality_apply` packaging)**: bare `rw [NatTrans.naturality_apply ψ.hom f x]` fails on `RingCat.Hom.hom`/`CommRingCat.Hom.hom`-form goals (kernel-form mismatch); the working idiom is `rw [show ... = ... from NatTrans.naturality_apply ...]`. Concrete code excerpt included verbatim from the iter-142 d_map closure for reuse on the d_app Step 3.b $\psi$-naturality step.
  - **Rule 3 (`pushforward_obj_map_apply'` named-lemma alternative)**: the iter-141-located `@[simp]` lemma at `Pushforward.lean:99–106` is the explicit alternative for kernel-form unfolding when the goal's surface shape does not align with a single fully-explicit `change`. For d_app both options are available; iter-142 d_map preferred the fully-explicit `change`.
- **Added "Step 3 (adjunction-transpose) sub-recipe (iter-142 decomposition; ~20–40 LOC bespoke chase)"** with sub-steps 3.a–3.d:
  - 3.a (~3–5 LOC): scheme-level categorical equality $(\mathrm{fst}\,G\,G).\mathrm{left} \circ G.\mathrm{hom} = (\mathrm{snd}\,G\,G).\mathrm{left} \circ G.\mathrm{hom}$ from `(fst G G).w` + `(snd G G).w`.
  - 3.b (~10–15 LOC): lift to c-components via `LocallyRingedSpace.comp_c_app` (or `PresheafedSpace.comp_c_app`); $\psi$-naturality applied here via Rule 2's idiom.
  - 3.c (~5–15 LOC, **load-bearing residual; NEEDS_MATHLIB_GAP_FILL per `analogies/d-app-d-map-recipe-shape.md` Decision 2**): construct the witness ring map $h : ((\mathrm{TopCat.Presheaf.pullback}\,G.\mathrm{hom}.\mathrm{base}).\mathrm{obj}\,(\Spec k).\mathrm{presheaf}).\mathrm{obj}\,X \to ((\mathrm{TopCat.Presheaf.pullback}\,(\mathrm{fst}\,G\,G).\mathrm{left}.\mathrm{base}).\mathrm{obj}\,G.\mathrm{left}.\mathrm{presheaf}).\mathrm{obj}\,(\mathrm{snd}^{-1}\,X)$ satisfying $(\varphi_{\mathrm{LHS}}.\mathrm{app}\,(\mathrm{snd}^{-1}\,X)) \circ h = (\psi.\mathrm{app}\,X) \circ (\varphi_G.\mathrm{app}\,X)$, described mathematically via the colimit presentation of `TopCat.Presheaf.pullback`. This is flagged as the iter-143 prover lane's single concrete target (IsIso deferred to iter-144+).
  - 3.d (~5–10 LOC): discharge via the streamlined `(CommRingCat.KaehlerDifferential.D _).d_map _` pattern after a fully-explicit `change` aligns the argument shape.

### Edit 2: IsIso recipe iter-143 Lean-shape refactor NOTE

Inserted at the top of the `Route (b'2)` block in `lem:GrpObj_omega_basechange_proj`'s proof:

- **Added "NOTE iter-143 (Lean-shape refactor; in-Lean only, recipe unchanged)"** documenting that the in-line `letI := isIso_of_app_iso_module ... (fun _ => sorry)` pattern at `Cotangent/GrpObj.lean:719–721` (pre-refactor) has been extracted into a named sorry-bodied theorem `basechange_along_proj_two_inv_app_isIso`. The NOTE includes a `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` reference (per directive: only `\lean{...}` allowance was for the post-refactor name).
- **Explicit recipe-invariance assertion**: items 2–4 of Route (b'2) are unchanged; the iter-144+ prover lane closes the body of the named theorem rather than filling a `(fun _ => sorry)` argument inside the consumer.
- **Provenance trail**: cites `lean-auditor-review142` MAJOR finding + `progress-critic-iter143` CHURNING primary corrective + `strategy-critic-iter143` definition-level diagnostic.
- **Iter-143 prover-lane scope clarification**: iter-143 targets *only* the d_app sub-sorry; the named IsIso theorem is a separate iter-144+ prover round.

### Edit 3 (optional): Route (b'2) items 2–4 concrete sub-recipe sketches

Decomposed each iter-141+ target item with a "Concrete recipe sketch (iter-143)" sentence-cluster:

- **Item 2** (`Algebra.IsPushout`-from-affine-product, ~80–150 LOC): chains `CommRingCat.isPushout_iff_isPushout` (`Mathlib.Algebra.Category.Ring.Pushout`) + `pullbackSpecIso` (`Mathlib.AlgebraicGeometry.Pullbacks`) + `isPullback_SpecMap_of_isPushout` (`Mathlib.AlgebraicGeometry.Pullbacks`). Cross-references Rule 1 of the iter-142 empirical lessons (any `change`-based alignment must spell both LHS and RHS).
- **Item 3** (`pullbackObjEquivTensor` chart-unfolding helper, ~30–60 LOC): unfolds `((pullback φ).obj M).obj V` via the unit/counit of `pullbackPushforwardAdjunction` at `Pullback.lean:50`; definitional equality on `pushforward.leftAdjoint.obj`. Helper is shared verbatim by Routes (a) and (b'2); does not escape `pullback`-opacity but exposes the chart-level tensor shape needed by item 4.
- **Item 4** (per-open identification with `tensorKaehlerEquiv.symm`, ~80–150 LOC): per-open iso for affine $X = W$ is the value of `KaehlerDifferential.tensorKaehlerEquiv.symm` applied to item 2's `Algebra.IsPushout` square, re-presented through item 3's chart-unfolding. Algebra-side value identity is `tensorKaehlerEquiv_symm_D_tmul` ($D\,b \mapsto 1 \otimes D\,b$). Composition lifts to a `PresheafOfModules` iso via the iter-138 Route (b) bridge `isIso_of_app_iso_module` (item 1, closed iter-140).

Also updated the items' `[iter-141+ target]` tags to `[iter-144+ target]` to reflect current scheduling (iter-143 prover lane = d_app only).

### Edit 4: d_map block iter-142 closed status note (in-prose)

Inserted at the very top of the `NOTE iter-138 (d\_map closure recipe)` block (just before the existing iter-138 mathematical description):

- **"NOTE iter-142 status (d_map sub-recipe block below): CLOSED substantively in `AlgebraicJacobian/Cotangent/GrpObj.lean:638–674`"**, documenting:
  - The 3-step ALIGN_WITH_MATHLIB chase recipe was applied with two empirical refinements (Rule 1 explicit `change` on both LHS and RHS; Rule 2 `rw [show ... from NatTrans.naturality_apply ...]` packaging).
  - The iter-142 closure used Rule 1's fully-explicit `change` to perform the `((pushforward ψ).obj LHS).map f` unfolding implicitly (without an explicit `simp only [pushforward_obj_map_apply']` step, contrary to the iter-141 framing); both options remain valid per Rule 3.
  - Status recorded **in-prose only** per directive; `\leanok` marker management is left to `sync_leanok`. No `\leanok` added by this writer.

## Cross-references introduced

No new `\uses{...}` cross-refs introduced — all edits live inside existing proof/NOTE blocks of `lem:GrpObj_omega_basechange_proj` and adjacent lemmas; the existing `\uses{...}` lines are unchanged.

One **new `\lean{...}` hint** added per directive's narrow allowance:
- `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_app_isIso}` inside the iter-143 Lean-shape refactor NOTE (Edit 2). This is the post-refactor named theorem's fully-qualified path; the refactor subagent is expected to land this declaration at `Cotangent/GrpObj.lean` in parallel.

## Macros needed (if any)
None — all new content uses existing `\texttt`, `\emph`, `\textbf`, `\app`, `\obj`, `\hom`, `\Spec`, `\CommRingCat`, `\Scheme`, `\Hom`, `\Over`, `\PresheafOfModules`, `\Omega_{...}`, etc. macros already in use elsewhere in the chapter. No new macro shapes introduced.

## Reference-retriever dispatches (if any)
None. All referenced sources (`task_results/Cotangent_GrpObj.lean.md`, `analogies/d-app-d-map-recipe-shape.md`, `analogies/isiso-basechange-along-proj-two-inv.md`, `analogies/kaehler-tensorequiv-presheafpullback.md`) are already in the project tree; the directive's empirical lessons + Step 3 decomposition were sourced verbatim from the directive's References block.

## Notes for Plan Agent

### Confirmed informational item (directive flag)

- **Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` L46–L49** lists the three sub-sorries on `relativeDifferentialsPresheaf_basechange_along_proj_two` (Statement `lem:GrpObj_omega_basechange_proj`) as still open, but iter-142 closed d_map. The pointer text should be revised to read "two concrete sub-sorries remain (d_app + IsIso; d_map closed iter-142)" — this is out of my single-chapter write-domain, but the directive already pre-flagged it as known informational.

- **Pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` L56–L58** likewise states that both `d_app` and `d_map` "remain `sorry`-bodied (iter-140 prover targets)" on `basechange_along_proj_two_inv_derivation`. This is stale post-iter-142; the pointer text should be revised to say `d_map` is closed iter-142 and only `d_app` remains (iter-143+ target). Same out-of-domain caveat applies.

### Other observations

- **The chapter is now 1634 LOC** (up from 1349 at iter-141 close; +285 in this round). The directive's "+30–80 LOC" estimate underestimated the actual size of the empirical-lessons NOTE + Step 3 decomposition + items 2–4 sub-recipes. The content density is justified by the directive's explicit ask (3 rules × concrete code excerpts + 4 sub-steps + 3 item-decompositions), but if chapter length is a concern, a future iter could consider extracting the iter-142 empirical lessons NOTE into a dedicated `proof_appendix/` macro or a sub-section. Not actioned here.

- **The d_app block's `Implementation note (iter-141)`** (the verbatim `d_map`-pattern example block at the original L672–L703) is now preserved unchanged below the new combined LOC estimate but above the new iter-142 NOTE. This redundancy is intentional: the iter-141 example is the canonical d_map closure pattern, and the iter-142 NOTE is the empirical-rule generalisation. A future cleanup could merge or excise the iter-141 example block once `sync_leanok` confirms d_map is `\leanok`-stamped.

- **No semantic changes** to any `lem:*` statement block, proof block proper, or `\lean{...}` hint (other than the one allowed new `\lean{}` in Edit 2). All edits are NOTE-comment expansions in proof bodies of `lem:GrpObj_omega_basechange_proj` and surrounding helpers, all in-domain for this writer.

## Strategy-modifying findings

None. The chapter's recipes are now better factored, but no strategy-level claim was found to be wrong or to require revision. The pointer-chapter stale text (item 1 + 2 above) is a documentation lag, not a strategy-level issue.
