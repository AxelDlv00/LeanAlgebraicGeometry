# Blueprint Writer Report

## Slug
tensorobj229

## Status
COMPLETE — all 5 directive edits addressed (Edit 5 deliberately skipped as a no-op; see below).

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Added lemma** `\label{lem:open_immersion_slice_sheaf_equiv}` / `\lean{AlgebraicGeometry.Scheme.Modules.overSliceSheafEquiv}` (Edit 1) — the shared open-immersion ↔ slice sheaf-site equivalence. Placed immediately before `lem:dual_isLocallyTrivial`. Statement: `overEquivalence U : Over U ≌ Opens ↥U` upgrades to a sheaf-category equivalence `Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology U) A`, compatible with `restrictFunctorIsoPullback`; framed as the completion of the Mathlib TODO `Topology/Sheaves/Over.lean:19-22` and as the shared root of both `lem:dual_isLocallyTrivial` and `lem:sheafofmodules_hom_of_local_compat`. `\uses{}` empty (foundational). Proof sketch: dense-subsite transfer via `Functor.IsDenseSubsite.sheafEquiv` + `Sites/Over.lean` continuity instances; over-category coherence automatic on the thin poset `Opens X` by `Subsingleton.elim`/`Subsingleton.helim`; sole sectionwise content is the down-set identity `ι₊(ι⁻¹ V) = V` for `V ≤ U`. Added a `% SOURCE:` comment naming the Mathlib code-location provenance (TODO at `Topology/Sheaves/Over.lean:19-22`), explicitly flagged as a code-location pointer, NOT a literature citation — so NO `% SOURCE QUOTE:` (no `references/` file backs it). No `\leanok`.

- **Added definition** `\label{def:presheaf_dual_precomp_equiv}` / `\lean{PresheafOfModules.dualPrecompEquiv}` (Edit 4 #1) — the section-level `R(U)`-linear precomposition equivalence on dual sections induced by an iso `e : M ≅ M'`. `\uses{def:presheaf_dual}`.

- **Added definition** `\label{def:presheaf_dual_iso_of_iso}` / `\lean{PresheafOfModules.dualIsoOfIso}` (Edit 4 #2) — an iso `e : M ≅ M'` induces `M'^∨ ≅ M^∨` (direction reversed; contravariant), assembled sectionwise from `dualPrecompEquiv`. `\uses{def:presheaf_dual, def:presheaf_dual_precomp_equiv}`.

- **Added definition** `\label{def:scheme_modules_dual_iso_of_iso}` / `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (Edit 4 #3) — the sheaf-level analogue: an iso `e : M ≅ M'` in `X.Modules` induces `dual M' ≅ dual M` by sheafifying the presheaf `dualIsoOfIso`; described as the dual/contravariant analogue of tensor-product functoriality in isos. `\uses{lem:internal_hom_isSheaf, def:presheaf_dual_iso_of_iso}`. (Placed the three helpers in dependency order just before the Edit-1 block, all in the dual-infrastructure run before `lem:dual_isLocallyTrivial`.) No `\leanok` on any.

- **Revised** `lem:dual_isLocallyTrivial` (Edit 2):
  - Statement `\uses{}` and proof `\uses{}` both gained `lem:open_immersion_slice_sheaf_equiv`; `lem:restrictscalars_ringiso_dualequiv` **kept** in both (it genuinely appears as the ModuleCat-level sectionwise shadow, per the iter-228 NOTE and the slice analogist report).
  - Updated the closing line of the `% NOTE (iter-228 …)` block: replaced "The writer must correct Steps/H2′ before this lemma is re-dispatched" with a CORRECTION line stating the residual is discharged by `lem:open_immersion_slice_sheaf_equiv` (the open-immersion↔slice transport on the thin poset), NOT by `restrictScalarsRingIsoDualEquiv` (shadow only). The body of the NOTE and the Stacks 01CR `% SOURCE:`/`% SOURCE QUOTE:` block are preserved verbatim.
  - **Rewrote the proof body**: Steps 1–3 + H1 retained as the verbatim-mirror part that *does* typecheck; then an explicit "here the parallel ends" passage giving the post-H1 residual `(pushforward β)(dual A) ≅ dual((pushforward β) A)`, explaining why the tensor's sectionwise `restrictScalars`-image argument fails for the slice internal hom, and discharging the residual via the shared slice-site equivalence (poset-thin reindexing of `overEquivalence U`, `Subsingleton.elim` naturality). The dropped framing is the false "H2′ closes it via `restrictScalarsRingIsoDualEquiv`"; the ring-iso/dual lemma now appears only as the sectionwise algebraic shadow. Closing paragraph re-pointed from generic "slice/Over-reindexing" to `lem:open_immersion_slice_sheaf_equiv`. Stacks 01CR equivalence note retained.

- **Revised** `lem:sheafofmodules_hom_of_local_compat` proof (Edit 3):
  - Proof `\uses{}` gained `lem:open_immersion_slice_sheaf_equiv`.
  - Added a paragraph after the `localSection`-naturality discussion stating that this naturality is the **section-direction slice** of the comparison in `lem:open_immersion_slice_sheaf_equiv` (one-sided realisation of the open-immersion↔slice transport; `eqToHom`-conjugation controlled by `ιᵢ(ιᵢ⁻¹ V) = V`, coherence automatic on the thin poset), and that the dual restriction-iso consumes the functor-direction face of the *same* equivalence — making explicit the shared-root unblocking.
  - Named the ⊤→morphism conversion as the global-sections equivalence `presheafHomSectionsEquiv`/`sheafHomSectionsEquiv` (⊤ terminal in `Opens X`), explicitly NOT a hand ⊤-unfold, per the ts229glue idiom (`presheafHom` via `Presheaf.IsSheaf.hom` → `existsUnique_gluing` → sections-equiv → `homMk`).
  - Softened the size language: removed the hard "~120–190 lines" figure; replaced with qualitative prose noting the cost is dominated by the `localSection` naturality and is bounded below by building the shared bridge.

## Edit 5 (vestigial eval `\uses`) — SKIPPED (deliberate no-op)
`lem:tensorobj_inverse_invertible`'s proof body cites `lem:internal_hom_eval`, but this is **not** vestigial: `internal_hom_eval` (`PresheafOfModules.internalHomEval`) is a live, closed-axiom-clean lemma (iter-224), and the proof genuinely uses it to construct the contraction `ε_L : L ⊗ L⁻¹ → 𝒪_X` (referenced in the body prose). The "excised eval route" was the *descended* `dual_eval`, not `internal_hom_eval`. Dropping the `\uses` would make the dependency graph inaccurate. Edit 5 was explicitly non-blocking ("skip if it risks touching unrelated prose"), so I left it untouched.

## Cross-references introduced
- `\uses{lem:open_immersion_slice_sheaf_equiv}` added to `lem:dual_isLocallyTrivial` (statement + proof) and to `lem:sheafofmodules_hom_of_local_compat` (proof) — target label is the new Edit-1 block in this same chapter. ✓
- `\uses{def:presheaf_dual_precomp_equiv}` in `def:presheaf_dual_iso_of_iso` — same chapter. ✓
- `\uses{def:presheaf_dual_iso_of_iso}` in `def:scheme_modules_dual_iso_of_iso` — same chapter. ✓
- New blocks `\uses` `def:presheaf_dual` and `lem:internal_hom_isSheaf` — both pre-existing in this chapter. ✓

## References consulted
- None opened this session for citation purposes. All edits are formalization-engineering (Mathlib infrastructure / TODO completion) plus reuse of the already-present Stacks 01CR quote on `lem:dual_isLocallyTrivial` (preserved verbatim, not re-derived). The Edit-1 `% SOURCE:` is a Mathlib **code-location** provenance pointer (`Topology/Sheaves/Over.lean:19-22`), not a `references/`-backed literature citation, and carries no verbatim `% SOURCE QUOTE:`. Mathlib line numbers/TODO text taken from the two analogist reports (`mathlib-analogist-ts229slice.md`, `mathlib-analogist-ts229glue.md`).

## Macros needed
- None. Used only `\widetilde`, `\iota`, `\mathtt`, `\cref`, and the existing `\Scheme`/`\Pic`/`\Spec` macros; avoided an undefined `\Opens` macro by writing `\mathtt{Opens}`.

## Reference-retriever dispatches
- None.

## Notes for Plan Agent
- LaTeX block balance verified: uncommented `\begin/\end` are 28/28 (lemma), 27/27 (proof), 13/13 (definition). The raw `grep -c` shows 32/31 for lemma only because of commented `% \end{lemma}` lines inside two SOURCE-QUOTE blocks (pre-existing, harmless).
- The three Edit-4 dual-iso helpers and the Edit-1 bridge are all forward `\lean{}` pins to not-yet-formalized declarations (`dualPrecompEquiv`, `dualIsoOfIso` ×2, `overSliceSheafEquiv`); the sync_leanok phase owns marker state — I added no `\leanok`.
- Strategy-aligned framing: both analogist reports converge that `exists_tensorObj_inverse` needs BOTH the A-engine and the C-bridge, which share `lem:open_immersion_slice_sheaf_equiv` as their single root. The chapter now records that shared dependency explicitly. This matches the planner's apparent intent to make `overSliceSheafEquiv` the iter-229 prover target; building the A-engine alone closes nothing route-relevant (it leaves the C-bridge on the same wall).

## Strategy-modifying findings
None. The convergent reframe (shared slice-site root; A-engine not independent) is a sharpening of the existing route, not a contradiction of STRATEGY.md; it is now faithfully reflected in the chapter prose.
