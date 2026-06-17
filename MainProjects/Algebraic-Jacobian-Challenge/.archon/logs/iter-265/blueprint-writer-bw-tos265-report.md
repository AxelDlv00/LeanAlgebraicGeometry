# Blueprint Writer Report

## Slug
bw-tos265

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

### Task 1 — Sq1-tail micro-assembly in `lem:pullback_tensor_map_basechange`

- **Added lemma** `\lemma`/`\label{lem:leftadjointuniq_app_unit_eta_general}`/`\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app}`
  — the **`P`-general** recovery brick (step-1 of the tail), placed immediately after
  `lem:leftadjointuniq_app_unit_eta` (its `𝟙_`-specialization twin). States
  `A_φ.homEquiv P _ ((sheafCompPb φ).hom.app P) = B_φ.unit.app P` for the composite adjunction
  `A_φ = (PresheafPullbackPushforwardAdj φ').comp sheafAdj` and its sheaf-level counterpart `B_φ`.
  Inline proof sketch mirrors the existing twin (homEquiv_leftAdjointUniq_hom_app at P).
  `\uses{lem:leftadjointuniq_app_unit_eta, lem:sheafification_comp_pullback_eq_leftadjointuniq}`.

- **Revised** the `\emph{The reduced tail goal.}` paragraph (proof of `lem:pullback_tensor_map_basechange`)
  — replaced the 3-sentence macro description with an explicit ordered `enumerate` (a)–(e) for
  `sheafificationCompPullback_comp_tail`, mirroring `lem:pullbackObjUnitToUnit_comp`:
  (a) strip outer `restrictScalars(𝟙)` wrapper; (b) distribute the RHS sheaf composite under
  `forget` exposing factors R1 (f-layer) / R5 (h-layer) without disturbing `B_{h∘f}.unit`;
  (c) apply `leftAdjointUniqUnitEta_app` (cref to the new general lemma) to rewrite R1 → `B_f.unit.app P`
  and R5 → `B_h.unit.app (PresheafPullback_f P)`; (d) slide `pushforwardComp h f` past the recovered units
  by naturality; (e) reassemble `B_{h∘f}.unit` via `comp_unit_app` + `unit_naturality`.
  - Added a dedicated `\emph{The precise binding obligation.}` paragraph naming the
    `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget` compatibility as the sub-lemma to
    isolate **before** the assembly (so steps (a)–(e) become a mechanical paste).
  - Added the one-line note that `sheafificationCompPullback_comp` **consumes** the tail, plus the
    "transposing the whole tail back is circular (verified)" warning.

### Task 2 — ε-naturality helper in `lem:slice_dual_transport`

- **Revised** the `\emph{Naturality of the section family in W.}` step (b) — added a `% NOTE:` plus a prose
  sentence naming `PresheafOfModules.restrictScalarsLaxε` (the `NatTrans` with components
  `Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (α.app X).hom)`), stating its `NatTrans` naturality
  field delivers exactly the ε-commutativity-with-restriction-maps square step (b) needs. Step (a)
  (`Subsingleton.elim`, thin poset) left as written.

### Minor

- **Revised** proof of `lem:dual_unit_iso` — added inline
  `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` pinning the scheme-level alias consumed
  there.
- **Revised** proof of `lem:dual_restrict_iso` (the `isoMk` paragraph) — added one line noting the outer
  `isoMk` naturality is discharged **after** and consumes the per-section family naturality
  `sliceDualTransport.naturality`.

## Cross-references introduced
- `\cref{lem:leftadjointuniq_app_unit_eta_general}` — new label, defined in this same chapter (after
  `lem:leftadjointuniq_app_unit_eta`); cited in step (c) of the tail assembly.
- `\uses{lem:leftadjointuniq_app_unit_eta, lem:sheafification_comp_pullback_eq_leftadjointuniq}` on the new
  lemma — both labels pre-exist in this chapter.

## References consulted
None — purely additive proof-sketch detail on an Archon-original/project-bespoke chapter. No `% SOURCE`
/ `% SOURCE QUOTE` block was added, removed, or altered.

## Macros needed (if any)
None. All commands used (`\mathtt`, `\mathrm`, `\cref`, `\lean`, `enumerate`) are already in use in this
chapter.

## Notes for Plan Agent
- The whole-file `\begin{lemma}` vs `\end{lemma}` count is unbalanced by **+1**, but this is
  **pre-existing** (verified: same count before and after my edits — delta 0). My additions are internally
  balanced (`enumerate` delta 0, `lemma`/`proof` delta 0). Worth a separate pass to locate the stray
  `\begin{lemma}` if a clean typeset is wanted, but it is not introduced by this round.
- No statement body, `\lean{}` target, signature, or `% SOURCE` block was modified. No `\leanok`/`\mathlibok`
  added or removed.

## Strategy-modifying findings
None.
