# Blueprint Writer Report

## Slug
rigiditykbar-piecei-iterb-prep-iter133

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

### Edit 1 — MED-B bundle: promoted `cotangentSpaceAtIdentity_eq_extendScalars` to a first-class blueprint citizen
- **Added lemma** `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` / `\label{lem:GrpObj_cotangentSpace_extendScalars_witness}` — the iter-131 strong-acceptance companion lemma at `AlgebraicJacobian/Cotangent/GrpObj.lean:198–219`, now a first-class blueprint declaration with a full Lean signature stub matching the in-tree signature verbatim. Placed between `lem:GrpObj_cotangentSpace`'s proof and `lem:GrpObj_cotangent_bridge`'s lemma block.
  - Statement: under the hypotheses of `lem:GrpObj_cotangentSpace`, there exist affine opens $U, V$, an inclusion $e$, a top-inclusion $h_{\mathrm{top}}$, and a ring map $\psi_V$ such that `cotangentSpaceAtIdentity G` equals the explicit chart-base-changed Kähler module.
  - Proof sketch: reproduce the body's `Classical.choose`-chain on `smooth_locally_free_omega`'s existential; close by `rfl` once the same extraction is unpacked on both sides.
  - No `\leanok` added by me (per blueprint-writer MUST NOT rule; the `sync_leanok` phase handles this).
- **Updated by-name reference at line 121**: `\texttt{cotangentSpaceAtIdentity\_eq\_extendScalars}` → `\cref{lem:GrpObj_cotangentSpace_extendScalars_witness}`. Lines 206 and 307 (now line ~411 and ~492 after insertions) retain `\texttt{...}` references which contextually make sense as Lean-name mentions; line 492 (the `Classical.choose`-chain body-shape footer paragraph) was updated to use `\cref{...}` in addition to keeping the Lean-name mention.

### Edit 2 — MED-C bundle: rewrote the recommended downstream rewrite pattern (former lines 302–306)
- **Revised paragraph** "Iter-131 `Classical.choose`-chain body shape (Lean encoding note)" — the second half ("recommended downstream rewrite pattern") replaced with a bulleted `itemize` of TWO routes:
  - **Direct `change`-based route (primary recommendation).** Describes the iter-132 actual closure path at `Cotangent/GrpObj.lean:276–282`: `change Module.finrank k (TensorProduct …) = n` (exposing the body's underlying `TensorProduct` via `ModuleCat.ExtendScalars.obj'`'s definitional unfolding) followed by `rw [Module.finrank_baseChange]; exact Module.finrank_eq_of_rank_eq hrank`. Cites Mathlib's `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings:396` for the carrier identity. Notes that this is "the shorter route, and what the rank lemma's iter-132 body actually does."
  - **`obtain`+`rw [heq]` alternative.** Preserved for downstream consumers that prefer to make the rewrite step explicit; explicitly cites `cref{lem:GrpObj_cotangentSpace_extendScalars_witness}` as the lemma supplying the destructure handle. Notes that this route is preferred "when the consumer's goal does not unify with the body's underlying `TensorProduct` carrier via `change` alone".
- The two routes are explicitly noted to be mathematically equivalent ("the body's carrier and the `extendScalars`-of-`ModuleCat.of` form share the same `Classical.choose` extraction, hence are definitionally equal once the `ModuleCat.ExtendScalars.obj'` carrier identity is unfolded").

### Edit 3 — must-fix-this-iter (HARD GATE Q1): hardened `lem:GrpObj_mulRight_globalises`
This is the central edit per the iter-133 blueprint-reviewer's HARD GATE Q1. All four sub-items requested were addressed:

(a) **Added `% Lean signature stub:` comment block** inside the lemma block, after `\lean{...}` (mirroring the style of `lem:GrpObj_cotangentSpace` and `lem:GrpObj_lieAlgebra_finrank` stubs). The stub pins:
  - Target name: `AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`
  - Full signature with `Over (Spec (.of k))`, `[CategoryTheory.GrpObj G]`, `{n : ℕ} [SmoothOfRelativeDimension n G.hom]`, `[IsProper G.hom]`, `[GeometricallyIrreducible G.hom]`
  - RHS at the **sheaf-level** (`PresheafOfModules`): `relativeDifferentialsPresheaf G.hom ≅ (PresheafOfModules.pullback (φ_str G)).obj ((PresheafOfModules.pullback (φ_η G)).obj (relativeDifferentialsPresheaf G.hom))`, NOT at the value-level `cotangentSpaceAtIdentity G` (per the iter-133 mathlib-analogist Decision 4)
  - Names the Mathlib categorical home: `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback` (the `PresheafOfModules.pullback` functor)
  - Notes that the `φ_str`/`φ_η` compatibility morphisms follow the same shape as `Differentials.lean:52`'s `φ'` (built via `TopCat.Presheaf.pullbackPushforwardAdjunction`)
  - Confirms presheaf-of-modules level (NOT sheafified)
  - Documents the LOC envelope (210–440) and the decoupling rationale (the chart-localisation bridge to `cotangentSpaceAtIdentity G` is a separate ~100–200 LOC lemma consumed in piece (i.c), NOT inside this lemma's body)

(b) **Added `\paragraph{Lean target name vs.\ construction (option (i), iter-133).}`** explaining the `mulRight`-vs-σ relationship per **option (i)** of the directive (default). Explains that:
  - The shear iso σ = ⟨pr₁, μ⟩ on G ⨯ G is the binary-product upgrade of `CategoryTheory.GrpObj.mulRight` (cites `Mathlib.CategoryTheory.Monoidal.Grp_.lean:277–281`).
  - σ parametrises the family {mulRight a}_{a∈G} globally across G by taking the first coordinate as the parameter; pr₂ ∘ σ = μ realises the right-translation action on the second coordinate.
  - The "globalises the cotangent" phrasing in the name records that this family-of-translations triviallises Ω_{G/k} via pullback along σ.
  - Cites `CategoryTheory.GrpObj.isPullback` (Grp_.lean:293–323) as the inverse-pair proof-shape template.
  - **No standalone `mulRight`-name function appears in the Lean signature itself** — the connection is nomenclatural.

(c) **Added new helper sub-lemma** `\label{lem:GrpObj_omega_basechange_proj}` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` — the load-bearing piece-(i.b) helper for the base-change-of-differentials identification `Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}`. NEEDS_MATHLIB_GAP_FILL, ~150–300 LOC.
  - Lean signature stub present
  - Proof sketch describes the chain explicitly: chart-level Kähler identity via `KaehlerDifferential.tensorKaehlerEquiv` (`Mathlib.RingTheory.Kaehler.TensorProduct`) + presheaf-level promotion via `TopCat.Presheaf.pullback` (`Mathlib.Topology.Sheaves.Pullback`) + project-side `relativeDifferentialsPresheaf_obj_kaehler` (`AlgebraicJacobian/Differentials.lean:60–66`)
  - Cites the `Algebra.IsPushout` square structure from the binary-product universal property
  - Marked `\notready`

(d) **Factored "restriction along the section ⟨id_G, η_G⟩" into a sub-lemma** `\label{lem:GrpObj_omega_restrict_to_identity_section}` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` per the directive's default (option: sub-lemma rather than inline proof prose). ~30–80 LOC.
  - Lean signature stub present
  - Proof: applies `PresheafOfModules.pullbackComp` (`Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback`) to the section identity `pr_2 ∘ s = η_G ∘ π_G`
  - Marked `\notready`

(e) **Expanded the main proof of `lem:GrpObj_mulRight_globalises`** into a three-step structure (Step 1: build shear iso; Step 2: base-change of differentials; Step 3: restrict along section), with a "Mathlib name summary" block at the end and a total-LOC-envelope summary tying back to the iter-133 mathlib-analogist verdict.

The `\notready` marker on `lem:GrpObj_mulRight_globalises` is preserved (per directive: stays `\notready`). The iter-127 over-k risk register paragraph is preserved verbatim (and extended with a citation to `analogies/mulright-globalises-cotangent.md` Decision 4 listing the forbidden alternatives).

## Cross-references introduced

- `\cref{lem:GrpObj_cotangentSpace_extendScalars_witness}` — added at lines 121 and 492 (the body-shape footer paragraph). Defined at line 125. `\uses` annotations on the new lemma's statement and proof point at `lem:GrpObj_cotangentSpace` and `thm:smooth_locally_free_omega`, both verified to exist.
- `\cref{lem:GrpObj_omega_basechange_proj}` — added at lines 325 (in `mulRight_globalises_cotangent`'s statement), 353 (in its proof), 369 (in its Mathlib-name summary). Defined at line 375. `\uses{def:relative_kaehler_presheaf, lem:relative_kaehler_presheaf_obj}` — both labels verified to exist in `Differentials.tex`.
- `\cref{lem:GrpObj_omega_restrict_to_identity_section}` — added at line 362 (in `mulRight_globalises_cotangent`'s proof) and the Mathlib-name summary. Defined at line 423. `\uses{lem:GrpObj_cotangentSpace}`.
- `\uses{lem:GrpObj_cotangentSpace, lem:GrpObj_omega_basechange_proj, lem:GrpObj_omega_restrict_to_identity_section}` on the revised `lem:GrpObj_mulRight_globalises` statement and proof — replaces the prior `\uses{lem:GrpObj_cotangentSpace}` to capture the new helper sub-lemma dependencies.

## Macros needed (if any)
None. All LaTeX commands used (`\cref`, `\label`, `\lean`, `\uses`, `\notready`, `\texttt`, `\emph`, `\paragraph`, `\bigl`, `\bigr`, `\langle`, `\rangle`, `\colon`, `\Over`, `\Spec`, `\GrpObj`, `\pr`, etc.) are already in use elsewhere in this chapter.

## Reference-retriever dispatches (if any)
None. All references named in the directive were already in `references/` or already cited elsewhere in `RigidityKbar.tex` / `Differentials.tex`. The mathlib-analogist verdict file (`task_results/mathlib-analogist-mulright-globalises-iter133.md`) and persistent design file (`analogies/mulright-globalises-cotangent.md`) supplied all needed Mathlib API names; the iter-131 body-shape file (`analogies/cotangent-body-shape.md`) supplied the bridge-cost context for the MED-C paragraph rewrite.

## Verification

After all edits:
- **Balanced LaTeX environments**: 28 `\begin{...}` + 28 `\end{...}` for lemma/proof/theorem/remark/itemize, verified via `grep`.
- **Total chapter length**: 511 lines (was 324 lines pre-edit). The +187 line growth is dominated by the three new lemma blocks + extended proof prose for `mulRight_globalises_cotangent` (now ~94 lines including stub + 3 paragraphs + 3-step proof + 5 helper paragraphs).
- **All `\cref{...}` and `\uses{...}` targets resolve** to existing labels (verified by grep against this chapter and `Differentials.tex`).
- **`\leanok` / `\notready` markers**:
  - `lem:GrpObj_mulRight_globalises` retains `\notready` ✓
  - `lem:GrpObj_omega_basechange_proj` and `lem:GrpObj_omega_restrict_to_identity_section` (newly added) carry `\notready` ✓ (the Lean is not yet built)
  - `lem:GrpObj_cotangentSpace_extendScalars_witness` (newly added): no marker added by me ⚠️ — see "Notes for Plan Agent" below.

## Notes for Plan Agent

1. **`\leanok` on `lem:GrpObj_cotangentSpace_extendScalars_witness`** (directive vs. blueprint-writer rules conflict). The directive (under "Verification") states "new `lem:GrpObj_cotangentSpace_extendScalars_witness` gets `\leanok` (the Lean proof is closed at `Cotangent/GrpObj.lean:198`)". The blueprint-writer descriptor (`.archon/subagents/blueprint-writer.md` under "What you MUST NOT do") states "Do NOT add `\leanok` or `\mathlibok` markers. Those are managed by the `sync_leanok` phase + the review agent — never by you." I followed the writer's MUST NOT rule and did **not** add `\leanok`; the `sync_leanok` phase scheduled for between prover and review should pick up that the Lean declaration `cotangentSpaceAtIdentity_eq_extendScalars` is closed at `Cotangent/GrpObj.lean:198` and add `\leanok` automatically. Plan agent: verify this happened post-`sync_leanok`; if not, the deterministic phase or the review agent should add it (not me).

2. **Two `\texttt{cotangentSpaceAtIdentity\_eq\_extendScalars}` references retained as Lean-name mentions.** The directive said "you may keep some of the `\texttt{...}` references that contextually make sense as Lean-name mentions, but at least one of the three should become a `\cref{...}`." I converted **line 121** to `\cref{...}` (the "see also" cross-reference, which is the natural fit), and within line 492 (the body-shape footer), I added a `\cref{...}` alongside the kept `\texttt{...}` Lean-name mention. The remaining instance at line ~411 (in the rank-lemma proof Step 1) was retained as `\texttt{cotangentSpaceAtIdentity\_eq\_extendScalars}` because it's a Lean-name mention used to point to the in-tree companion; that contextually-appropriate use is preserved. Plan agent: feel free to push more conversions in a future cleanup pass; this iter's directive is satisfied.

3. **Step 2 of `mulRight_globalises_cotangent`'s proof is described at the conceptual level, not as a literal chain of `\sigma^*` applications.** I made one drafting revision after spotting that my first-pass Step 2/Step 3 prose accidentally inlined some "let me reread" meta-prose that didn't survive cleanup. The final Step 2 is now anchored on `lem:GrpObj_omega_basechange_proj` (the helper) plus a one-paragraph note that σ is an iso over pr₁, with the σ-vs-(pr₁, pr₂) functorial book-keeping deferred to the prover lane to flesh out. Step 3 is similarly anchored on `lem:GrpObj_omega_restrict_to_identity_section`. The proof is a sketch (it doesn't claim to literally compute each pullback chain); the iter-134+ prover lane will need to fill in the precise σ^*-on-Step-2 transport (which is one of the steps in the analogist's "step 3 (~30–80 LOC)" budget). If the iter-134+ prover lane finds the proof sketch underspecified for that transport, plan agent can dispatch a follow-up writer pass; I judged the current sketch sufficient for the dispatch decision but more elaboration is possible.

4. **Helper-lemma Lean target names are fresh and not yet committed in `archon-protected.yaml`**: `relativeDifferentialsPresheaf_basechange_along_proj_two` and `relativeDifferentialsPresheaf_restrict_along_identity_section`. These are placeholders the iter-134+ prover lane can rename if Mathlib idiom suggests a cleaner naming convention (e.g., once the upstream `tensorKaehlerEquiv` sheaf-level version is identified, the helper might be renamed to match it). Plan agent: do not pin these names into `archon-protected.yaml` until the prover lane has scaffolded the declarations.

5. **The `lem:GrpObj_omega_free` and `lem:GrpObj_omega_rank_eq_dim` blocks** (lines 456–480, piece (i.c) lemmas) were explicitly out of scope per the directive (deferred to iter-137+ pre-prover hardening). I did NOT touch them. The new helper sub-lemmas I added (`lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`) are tagged "(i.b-helper)" in their title, distinguishing them clearly from the existing "(i.c)" lemmas; placement is between `mulRight_globalises_cotangent` and `omega_free`, which keeps the section's top-to-bottom logical flow (headline + supporting decomposition, then piece (i.c) consumers).

6. **Cross-chapter notes (out of scope per directive)**:
   - `Jacobian.tex` C.2.a–C.2.e over-`\bar k` prose drift — unchanged (deferred iter-134+ per directive).
   - `Cohomology_MayerVietoris.tex` broken `\ref{...}` cross-refs — unchanged (deferred per directive).

## Strategy-modifying findings

None. The iter-133 mathlib-analogist verdict (`task_results/mathlib-analogist-mulright-globalises-iter133.md`) is fully incorporated; the iter-127 over-k commitment is preserved; the Replacement (B) trio→duo collapse on piece (i.a) (closed iter-132) is untouched; the iter-130 trigger (a') refinement (sheaf-level RHS keeps trigger (a') from firing) is documented in the new Lean signature stub for `mulRight_globalises_cotangent`. The piece (i.b) prover-lane LOC envelope holds at 210–440 LOC per the analogist's verdict.
