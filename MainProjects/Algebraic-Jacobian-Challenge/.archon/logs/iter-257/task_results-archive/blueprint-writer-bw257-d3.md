# Blueprint Writer Report

## Slug
bw257-d3

## Status
COMPLETE — Corrections 1, 2, and 3(a) applied to the chapter; Correction 3(b) was found
to target a `.lean` module header (outside the writer's write-domain) that is already fixed.
See "Notes for Plan Agent".

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** `lem:pullback_tensor_map_basechange` (Correction 1) — statement realigned from the
  base-change-square specialization to the **general composition coherence** of the sheaf-level
  pullback tensorator δ for ANY composable `h : Z → Y`, `f : Y → X` and `M N : X.Modules`:
  ```
  δ^{h∘f}(M,N) = (pullbackComp h f).inv ; h^*(δ^f(M,N)) ; δ^h(f^*M,f^*N)
                  ; tensorObjIsoOfIso((pullbackComp h f)_M,(pullbackComp h f)_N).hom
  ```
  mirroring the actual Lean signature of `pullbackTensorMap_restrict`
  (`TensorObjSubstrate.lean:2138`). Kept `\label` and `\lean{}` pin and the `\leanok` marker.
  Retitled to "Composition coherence of the pullback tensorator δ (D3′)". Added an
  `\emph{Remark}` deriving the open-immersion base-change-square form (`f∘j' = j∘g`) as the
  specialization `h := j'` obtained by equating the two factorisations `j' ; f = g ; j` — so a
  separate corollary block was not needed (the downstream `\cref` in
  `lem:pullback_tensor_iso_loctriv` still resolves and reads correctly against the Remark).
  Adjusted `\uses` from `{…, lem:pullbackObjUnitToUnit_comp, …}` to
  `{lem:pullback_tensor_map, lem:pullback_tensor_map_natural, lem:presheaf_pullback_oplaxmonoidal,
  lem:tensorobj_restrict_iso}` (dropped the now-non-dependency on the unit analog; all four
  targets are existing labels).

- **Revised** proof of `lem:pullback_tensor_map_basechange` (Correction 2) — deleted the
  disproven "same mate calculus as `lem:pullbackObjUnitToUnit_comp`" / `homEquiv.injective`
  sketch and replaced it with the genuine **four-square composition-coherence** route:
  `simp [pullbackTensorMap]` exposes both sides as the 4-fold composite `S1 ; a.map δ ; S3 ; S4`;
  then Sq2 (δ-core via `Functor.OplaxMonoidal.comp_δ` + `PresheafOfModules.pullbackComp`, with the
  ring-map reconciliation prerequisite and `Opens.map_comp` transport, atoms
  `pullbackId/pullback_assoc/pullback_comp_id/pullback_id_comp`), **Sq1** (sheafificationCompPullback
  composition coherence — named explicitly as a Mathlib-absent standalone project sub-lemma),
  Sq3 (`sheafifyTensorUnitIso` carried through the same `pullbackComp`), and **Sq4** (pullbackValIso
  composition coherence — the second Mathlib-absent standalone project sub-lemma, producing the
  final `tensorObjIsoOfIso`). States explicitly that Sq1 and Sq4 are the two genuine missing
  ingredients, names `conjugateEquiv_pullbackComp_inv` as the adjunction-mate bridge used inside
  Sq2/Sq4, and adds one paragraph explaining WHY the unit-analog mirror fails (pullbackTensorMap is
  not an adjunction transpose).

- **Revised** the `% NOTE` comment block before the D3′ lemma and the **(D3′) overview itemized
  entry** (in the `\paragraph{The construction route.}` list, ~L2683) — removed the misleading
  "tensorator analog … same mate calculus" framing from both and replaced with the general
  composition-coherence + four-square description, consistent with the lemma. (The stale
  `% NOTE (review iter-256)` block instructing the realignment was removed since its instruction is
  now satisfied.)

- **Revised** `lem:dual_restrict_iso` proof (Correction 3a) — added one concise paragraph
  "*The leg-(A) atom `sliceDualTransport`*" naming the pinned atoms from
  `analogies/dualstep4-257.md`: the Hom-set bijection `Functor.FullyFaithful.homEquiv` of the
  fully-faithful `f.opensFunctor`, realised in the thin-poset setting as an `eqToHom`-conjugation
  along the down-set identity `image_preimage_of_le` with `Subsingleton.elim` naturality, wrapped in
  `PresheafOfModules.isoMk` (the `homLocalSection`/`dualUnitIsoGen` pattern); the residual is then
  `isoMk` of (leg A `sliceDualTransport`) ∘ (leg B `restrictScalarsRingIsoDualEquiv`). Replaced the
  old "*An alternative route … candidate should the inverse-uniqueness glue prove cheaper*"
  paragraph with "*The inverse-uniqueness shortcut is not viable*", recording the four absent
  structures (no `MonoidalCategory` instance on `PresheafOfModules`, not strong-monoidal, not an
  equivalence, no `ExactPairing` for general M).

## Cross-references introduced / adjusted
- `lem:pullback_tensor_map_basechange` `\uses` now `{lem:pullback_tensor_map,
  lem:pullback_tensor_map_natural, lem:presheaf_pullback_oplaxmonoidal, lem:tensorobj_restrict_iso}`
  — all four labels exist in this chapter.
- Proof `\uses` updated to match.
- No new `\uses` to non-existent labels: the two missing sub-lemmas (Sq1 sheafificationCompPullback-comp,
  Sq4 pullbackValIso-comp) are named in prose as deferred sub-lemmas only (no `\label`/`\lean` block
  created — they are not yet Lean declarations, so adding labels would create broken `\uses`/`\ref`
  for blueprint-doctor).

## References consulted
- `analogies/dualstep4-257.md` — the mathlib-analogist consult: leg-(A) atom `sliceDualTransport`
  from `Functor.FullyFaithful.homEquiv` + thin-poset `eqToHom`-conjugation; the inverse-uniqueness
  route NEEDS_MATHLIB_GAP_FILL (not viable). Used for Correction 3(a).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2120-2188` — the actual Lean signature and
  docstring/roadmap of `pullbackTensorMap_restrict`. Used to write the exact general-form statement
  (Correction 1) and the four-square route (Correction 2). (Read for fidelity; not edited.)
- `.archon/task_results/blueprint-reviewer-br257.md` — located the stale status block at "L41–43"
  (the `.lean` module header, not the chapter).

No external-source `% SOURCE` / `% SOURCE QUOTE` blocks were added or modified; all existing
citation blocks in the edited lemmas (the Stacks `lemma-pullback-internal-hom` quote on
`lem:dual_restrict_iso`, etc.) are intact. No reference-retriever needed.

## Macros needed (if any)
- None. All commands used (`\mathtt`, `\cref`, `\emph`, `\Scheme`, `\mathrm`, etc.) are already in use
  throughout the chapter.

## Notes for Plan Agent

- **Correction 3(b) targets a `.lean` file, not the chapter — and is already fixed.** The
  "TWO residuals (iter-254)" status prose the directive describes is **not in the `.tex` chapter**;
  it lives in the `.lean` module headers (`DualInverse.lean:9-41` and `TensorObjSubstrate.lean:39-69`),
  which are outside the blueprint-writer write-domain. The br257 reviewer's pointer "Status block at
  L41–43" refers to `TensorObjSubstrate.lean`, where the block **already reads "ONE tracked
  typed-`sorry` residual"** (`TensorObjSubstrate.lean:43`) and correctly records D1′ closed (iter-255).
  The `DualInverse.lean` header already lists `homOfLocalCompat` as **CLOSED (iter-256)** and
  `dual_restrict_iso` as PARTIAL. So no chapter edit was applicable for 3(b); I verified the `.tex`
  chapter carries no stale "two open residuals (D1′ + homOfLocalCompat)" prose. If you still want the
  `.lean` headers' per-iteration narrative trimmed, that is a prover/lean-scaffolder task, not a
  blueprint-writer one.

- The chapter's `lem:tensorobj_restrict_iso` H1 status prose (~L655–714) still calls the
  `pushforward β ≅ pullback φ` residual "the single open substrate obligation of this chapter."
  Given the group law has landed (`picCommGroup`), this is likely stale too, but it was outside this
  directive's scope (Correction 3 was specifically about D3′ and the dual Step-4). Flagging for a
  future status-prose pass.

- File-level LaTeX sanity: non-comment `\begin{lemma}`/`\end{lemma}` are balanced 66/66 and
  `\begin{proof}`/`\end{proof}` 64/64; the only aggregate mismatches are inside `% SOURCE QUOTE`
  comment blocks (a truncated Stacks `\begin{lemma}…[\dots]` quote) — pre-existing and harmless.
  My edits are environment-neutral (added/removed zero lemma/proof delimiters).

## Strategy-modifying findings
None. The corrections align the chapter with an already-established Lean signature and an
already-completed analogist consult; no strategy-level issue surfaced.
