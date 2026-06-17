# Blueprint Writer Report

## Slug
fbc-affinelocal

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Revised** the `\begin{proof}` block of `lem:base_change_map_affine_local`
  (Affine-local compatibility of the base-change map). Replaced the single
  asserted sentence ("…because `pushforwardBaseChangeMap` is built from the
  (pullback ⊣ pushforward) units and counits, all of which commute with
  restriction to an open. Granting this base-change-of-the-base-change-map
  compatibility — itself absent from the pinned Mathlib and recorded here as the
  named obligation — …") with an explicit three-step derivation:
  1. **Unfold the map** — per `def:pushforward_base_change_map`,
     `pushforwardBaseChangeMap` is the `(g^*, g_*)`-adjunction transpose of
     `f_*(η_F) : f_*F → f_*(g')_*(g')^*F = g_* f'_*(g')^*F`, where `η_F` is the
     `((g')^*,(g')_*)`-unit and `f_*(g')_* = g_* f'_*` is pseudofunctoriality on
     the commuting square. Recorded as a composite of adjunction data + pushforward
     functors only.
  2. **Restriction to `U` commutes with each block** — `ρ_U = Γ(U,-)` is a
     functor; the constituents are natural transformations / natural bijections.
     Itemised (a) unit restricts to the restricted-square unit; (b) `f_*` of a
     restricted morphism is the restriction of `f_*` of the morphism, since
     `(f_*G)|_U = (f|_{f^{-1}U})_*(G|_{f^{-1}U})` naturally in `G` (and likewise
     `(g')_*`, `f'_*`); (c) the `(g^*,g_*)`-transpose is natural in both variables.
     Chaining (a)–(c) identifies `(pushforwardBaseChangeMap …).app U` with
     `pushforwardBaseChangeMap` of the square restricted over `U` (and a chosen
     affine `Spec R ⊆ S` containing `g(U)`, where `IsAffineHom f` gives
     `X|_… = Spec A` and quasi-coherence gives `F|_… = M̃`).
  3. **Conclude the reduction** — under the Step 2 identification, the
     per-affine-open hypothesis of `lem:modules_isIso_iff_affineOpens` is exactly
     the affine–affine section assertion that
     `lem:pushforward_base_change_mate_cancelBaseChange` supplies (no flatness);
     applying the locality criterion yields `IsIso (pushforwardBaseChangeMap …)`.
  - The directive's required reframing is done: the "named obligation absent from
    the pinned Mathlib" language is removed, and the proof now states explicitly
    that the compatibility is naturality-of-the-transpose + pushforward-commutes-
    with-restriction, i.e. definitional + naturality, NOT an external coherence
    lemma.

## Cross-references introduced
- No new `\uses{}` edges. The proof keeps
  `\uses{def:pushforward_base_change_map, lem:modules_isIso_iff_affineOpens}`,
  matching the formalized signature (a locality implication: the proof unfolds the
  *definition* and applies the *locality criterion*).
- `Lemma~\ref{lem:pushforward_base_change_mate_cancelBaseChange}` is cited in
  Step 3 prose as the supplier of the per-open hypothesis (discharged at the call
  site in `lem:affine_base_change_pushforward`, which already `\uses` it). It is a
  contextual `\ref`, not a dependency edge of this implication, so it is
  deliberately not added to this proof's `\uses{}` — consistent with the prior
  proof and with the "Intended formalized signature" (which takes
  `∀ U, IsIso (app U)` as hypothesis).
- `leandag build --json`: `unknown_uses: []`, `conflicts: []`. The only isolated
  nodes are the 4 auxiliary Lean nodes (pre-existing, unrelated); no blueprint
  declaration in this chapter is isolated, and `lem:base_change_map_affine_local`
  remains wired in (used by `lem:affine_base_change_pushforward`). The
  `unmatched_lean` entry for `AlgebraicGeometry.TODO.base_change_map_affine_local`
  is the expected TODO pin left untouched per directive (scaffold repoints later).

## References consulted
- None opened this session for a citation block. The edit is confined to the
  `\begin{proof}` body, which is Archon-original elaboration of the single
  Stacks "local on S and S'" sentence already quoted verbatim in the (untouched)
  `% SOURCE QUOTE:` on the lemma statement. No new verbatim source quote is
  required and none was fabricated; the existing `% SOURCE:` / `% SOURCE QUOTE:`
  on the statement are preserved unchanged.

## Macros needed (if any)
- None. The proof uses only existing constructs (`\texttt{}`, `\operatorname{}`,
  `\mathrm{}`, `\widetilde{}`, standard math) already in use throughout the chapter.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- I did **not** add a separate named helper block for "pushforward commutes with
  restriction to an open of the base" (the directive permitted but did not require
  it). Rationale: it is standard naturality stated inline in Step 2(b); minting a
  new node would require its own `\lean{}` TODO pin and a DAG obligation for what
  is a single naturality fact, which reads as padding rather than a sharpened
  prover target. If a later prover finds that fact is the genuine hard sub-step and
  wants to target it separately, it can be promoted to its own block then. Flagging
  here so the choice is visible.
- Minor consistency observation (not edited — out of scope): the lemma's "Intended
  formalized signature" frames the result as a pure implication
  `(∀ U, IsIso (app U)) ⟹ IsIso (…)`, while the surrounding section prose and the
  new Step 3 describe it as concluding `IsIso` by combining the Step 2
  identification with the mate lemma. The proof prose is written to be faithful to
  both readings (the identification is the content; the locality criterion is the
  conclusion step), but if a future pass tightens the statement, the planner may
  want to make the signature and prose say the same thing about where the per-open
  iso hypothesis is discharged.

## Strategy-modifying findings
(none)
