# Blueprint Writer Report

## Slug
ltfirst215

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Changes Made

- **Revised** `lem:islocallyinjective_whisker_of_W` (statement closing prose + proof) —
  added the **PRIMARY locally-trivial proof route** and relabelled the existing
  stalkwise argument as the explicit **FALLBACK**.
  - Statement: the closing paragraph now frames the lemma as the load-bearing field
    of the *full-generality* route~(e) `LocalizedMonoidal` path (arbitrary `F`), and
    notes that the consumer (the associator) always supplies a *locally trivial* `F`,
    for which a stalk-free proof exists (PRIMARY route). `\lean{...}` pin UNCHANGED.
  - Proof PRIMARY route (new): for `F` locally trivial
    (`LineBundle.IsLocallyTrivial F`), on a trivialising cover `{V}` (`F|_V ≅ 𝒪_V`),
    `lem:tensorobj_restrict_iso` gives `(F ◁ g)|_V ≅ (F|_V) ◁ (g|_V)` and the left
    unitor `lem:tensorobj_unit_iso` identifies this with `g|_V`; `g ∈ J.W` is stable
    under restriction so `g|_V ∈ J.W` is locally injective; local injectivity is
    local on the cover. Explicitly states: **no stalks, no (d.2)**; trades (d.2) for
    `lem:tensorobj_restrict_iso` (which thereby moves ONTO the critical path);
    explicitly distinguished from the section-level Tor₁/flatness dead end (here
    sheaf-level, uses `g` locally *bijective*, never tensors a bare injection).
  - Proof FALLBACK route: the prior stalkwise (d.1-done / d.1-bridge / d.2) argument
    is kept verbatim, prefixed "arbitrary `F`; required only for the full route~(e)",
    and closed with a note that it is needed only for full monoidal generality.
  - Proof `\uses` extended with `lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso`
    (no cycle: both depend only on `def:scheme_modules_tensorobj`).

- **Revised** `lem:tensorobj_isoclass_commgroup` (`\uses`, statement body, proof) —
  reframed so the **PRIMARY construction builds the commutative group directly on
  iso-classes of locally-trivial (invertible) sheaves**, mirroring
  `Module.Invertible` / `CommRing.Pic` (`Mathlib/RingTheory/PicardGroup.lean`):
  op `[L]·[M]=[L⊗M]` (well-defined + locally trivial by `lem:tensorobj_lift_onproduct`),
  identity `[𝒪_X]`, inverse the dual `[L⁻¹]` from `lem:tensorobj_inverse_invertible`,
  associativity `lem:tensorobj_assoc_iso`, unit laws `lem:tensorobj_unit_iso`,
  commutativity `lem:tensorobj_comm_iso`. States explicitly: NO `(J.W).IsMonoidal`,
  NO `LocalizedMonoidal`, NO `Skeleton` for the group; lower-risk because every
  ingredient is already proved or LT-scoped+assembled; remaining obligations on the
  critical path are `lem:tensorobj_restrict_iso` and `lem:tensorobj_inverse_invertible`.
  The `Units(Skeleton(...))` route~(e) presentation is retained as the labelled
  FALLBACK. `\lean{...}` pin UNCHANGED. `\uses` swapped `lem:jw_ismonoidal` →
  `lem:tensorobj_lift_onproduct, lem:tensorobj_inverse_invertible`.

- **Added** `\paragraph{Two-tier strategy.}` in `sec:tensorobj_route_e` intro —
  one paragraph contrasting (PRIMARY) group on locally-trivial iso-classes à la
  `Module.Invertible`, needing only `lem:tensorobj_restrict_iso` +
  `lem:tensorobj_inverse_invertible` atop the assembled LT associator/unitors/braiding,
  vs (FALLBACK) the full `(J.W).IsMonoidal → LocalizedMonoidal` monoidal category on
  all of `SheafOfModules`, deferred because its load-bearing field needs (d.2)
  (stalk-⊗ over a varying ring, multi-iter).

- **Revised (consistency upkeep)** two bullets in `sec:tensorobj_consistency_check`
  so the enumerated `\uses` chain matches the edited blocks: the
  `lem:tensorobj_isoclass_commgroup` bullet now lists the new `\uses` and describes
  the primary/fallback split; the whisker-lemmas bullet now describes the
  PRIMARY (LT, sheaf-level) vs FALLBACK (stalkwise d.1/d.2) routes and marks the
  open obligation as route~(e)-specific.

## Cross-references introduced
- `lem:tensorobj_restrict_iso`, `lem:tensorobj_unit_iso` added to the `\uses` of the
  proof of `lem:islocallyinjective_whisker_of_W` — both exist in this chapter.
- `lem:tensorobj_lift_onproduct`, `lem:tensorobj_inverse_invertible` added to the
  `\uses` of `lem:tensorobj_isoclass_commgroup` (statement + proof) — both exist in
  this chapter. `lem:jw_ismonoidal` removed from that block's `\uses` (it is now the
  fallback only; still referenced in prose and still used by `lem:tensorobj_assoc_iso`
  and `rem:scheme_modules_monoidal_off_path`, so not orphaned).
- No new cross-chapter references; `LineBundle.IsLocallyTrivial` named in prose as
  directed (its definition `def:IsLocallyTrivial` lives in a sibling chapter, already
  cross-referenced elsewhere in this chapter).

## References consulted
None opened this session. Per directive, `Module.Invertible` / `CommRing.Pic` are
Mathlib *software* references named in prose only (file `Mathlib/RingTheory/PicardGroup.lean`);
no `% SOURCE QUOTE` literature transcription required and none added. No external
reference material was needed, so no reference-retriever was dispatched. (Existing
`% SOURCE`/`% SOURCE QUOTE` Stacks/Kleiman blocks on the edited declarations were
left untouched.)

## Macros needed (if any)
None. All commands used (`\Scheme`, `\MonoidalCategory`, `\Pic`, `\cref`, `\paragraph`)
already appear in the chapter.

## Notes for Plan Agent
- **LaTeX balance:** `grep` shows 56 `\begin{` vs 55 `\end{`. The single discrepancy is
  PRE-EXISTING and inside a `% SOURCE QUOTE` comment: the truncated `% "\begin{lemma}`
  at line ~1192 in `lem:tensorobj_inverse_invertible` has no commented `\end{lemma}`
  (the quote is `...`-truncated). It has no compile effect and was not introduced by
  this edit. All real (non-comment) environments — `proof` 18/18, `itemize` 3/3 — are
  balanced.
- The associator block `lem:tensorobj_assoc_iso` still carries `\leanok` and is pinned
  with vestigial `IsLocallyTrivial` hypotheses and a `\uses{lem:jw_ismonoidal}`. Under
  the new PRIMARY route those LT hypotheses are *load-bearing* (the primary route is
  scoped to locally-trivial objects), so they are no longer "vestigial" from the
  group law's perspective — the existing prose in that block (out of scope this round)
  calls them vestigial *under route~(e)*. Consider a future pass to reconcile the
  associator block's framing with the now-primary locally-trivial route. Flagged, not
  edited (out of scope).
- `lem:tensorobj_restrict_iso` and `lem:tensorobj_inverse_invertible` both carry
  `\leanok` but their proof prose says the full proof is deferred / they are off-path.
  Under the new strategy both are now ON the critical path. The `sync_leanok` phase
  will reconcile the markers against actual sorry status; no marker edits made here.

## Strategy-modifying findings
None. The edit implements a strategy refinement already decided by the directive
(locally-trivial-first as PRIMARY, route~(e) as FALLBACK); it surfaced no new
strategy-level obstruction. The one item worth the plan agent's attention — that the
associator's `IsLocallyTrivial` hypotheses become load-bearing rather than vestigial
under the primary route — is a prose-reconciliation note (above), not a soundness
issue: the primary group law only ever applies the associator to locally-trivial
objects.
