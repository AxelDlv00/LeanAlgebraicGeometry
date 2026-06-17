# Blueprint Writer Report

## Slug
Picard_IdentityComponent-cov273

## Status
COMPLETE — all 11 uncovered `lean-aux` declarations now have exactly one
`\lean{}`-pinned blueprint block, each wired into the chapter's
identity-component cone; no new isolated nodes, no broken `\uses{}`.

## Target chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Changes Made

Added a new subsection `\subsection{Topological and connectedness substrate
(helper lemmas)}` (`\label{subsec:identity_component_substrate}`) at the end
of §2 (before the Picard-scheme specialisation), containing 11 new blocks —
one per uncovered Lean decl. Each carries a one-to-three-sentence
mathematical statement and a `Proved directly in Lean.` proof block (these
are internal helpers under the already-blueprinted public API; no external
citation required).

| Block | `\lean{}` (all under `AlgebraicGeometry.GroupScheme.`) | env |
|---|---|---|
| `lem:noetherian_finite_connected_components` | `noetherianSpace_finite_connectedComponents` | lemma |
| `lem:noetherian_isopen_connected_component` | `noetherianSpace_isOpen_connectedComponent` | lemma |
| `lem:identity_component_locally_connected` | `identityComponent_locallyConnectedSpace` | lemma (instance) |
| `def:identity_section_point` | `identitySectionPoint` | definition |
| `def:identity_component_carrier` | `identityComponentCarrier` | definition |
| `lem:identity_component_carrier_connected` | `identityComponentCarrier_connectedSpace` | lemma (instance) |
| `lem:identity_component_connected` | `identityComponent_connectedSpace` | lemma (instance) |
| `lem:identity_component_section_range_subset` | `identityComponentSection_range_subset` | lemma |
| `def:identity_component_section` | `identityComponentSection` | definition |
| `lem:identity_component_section_is_section` | `identityComponentSection_isSection` | lemma |
| `lem:identity_component_geometrically_connected` | `identityComponent_geometricallyConnected` | lemma (theorem) |

- **Added macro** `\providecommand{\connComp}{\operatorname{Comp}}` at the
  chapter top (chapter-local) for the connected-component notation used in
  the new prose. See "Macros needed" below.

## Cross-references introduced (wiring)

Intra-substrate edges (helper → its Lean dependencies), all verified to
resolve via `leandag` (`unknown_uses: 0`):

- `lem:noetherian_isopen_connected_component` `\uses{lem:noetherian_finite_connected_components}`
- `lem:identity_component_locally_connected` `\uses{lem:noetherian_isopen_connected_component}`
- `def:identity_component_carrier` `\uses{def:identity_section_point, lem:identity_component_locally_connected}`
- `lem:identity_component_carrier_connected` `\uses{def:identity_component_carrier, def:identity_section_point}`
- `lem:identity_component_connected` `\uses{lem:identity_component_carrier_connected, def:identity_component_group_scheme}`
- `lem:identity_component_section_range_subset` `\uses{def:identity_component_carrier, def:identity_section_point}`
- `def:identity_component_section` `\uses{def:identity_component_carrier, lem:identity_component_section_range_subset, def:identity_component_group_scheme}`
- `lem:identity_component_section_is_section` `\uses{def:identity_component_section, lem:identity_component_section_range_subset, def:identity_component_group_scheme}`
- `lem:identity_component_geometrically_connected` `\uses{lem:geometricallyConnected_of_connected_of_section, def:identity_component_section, lem:identity_component_section_is_section, lem:identity_component_connected}`

Edges added to the EXISTING public-cone blocks to absorb the new helpers
(so none is isolated and the chapter goal transitively `\uses{}` all of
them):

- `def:identity_component_group_scheme` (`IdentityComponent`) — added `\uses{def:identity_component_carrier}` (it is literally built from the carrier).
- `thm:identity_component_open_subgroup` proof — extended `\uses{...}` with `def:identity_component_carrier, lem:identity_component_locally_connected` (the clopen proof builds the inclusion from the carrier and uses local connectedness for closedness).
- `thm:identity_component_base_change_commutes` (statement + proof) — added `lem:identity_component_geometrically_connected` to `\uses{...}` (the Lean `baseChangeIso` proof invokes `identityComponent_geometricallyConnected`).

End state: the carrier/topology chain reaches the cone via
`def:identity_component_carrier → {def:identity_component_group_scheme,
thm:identity_component_open_subgroup}`; the section/connectedness chain
reaches it via `lem:identity_component_geometrically_connected →
thm:identity_component_base_change_commutes`. Both public results already
sit under `thm:pic_zero_is_abelian_variety` (the chapter goal).

## REF placeholders fixed
0 in rendered prose. The only literal `REF` in the file (line ~557,
`Exercise~REF`) is inside a verbatim `% SOURCE QUOTE` comment reproducing
Kleiman's `rmk:Jac` text — it does not render and altering it would violate
the verbatim-quote citation rule, so it was left untouched (flagged here).

## leandag verification
- `leandag build --json`: `unknown_uses: 0`; all 11 target decls dropped
  out of `unmatched_lean` (confirmed each now matched).
- `leandag query --isolated --chapter Picard_IdentityComponent`: 0 results.
- `leandag show isolated`: none of the new labels appear.

## References consulted
None — all 11 blocks are internal helper declarations under an
already-blueprinted, already-cited public API; no new external source text
was used (per directive, "Proved directly in Lean." proofs, no `% SOURCE`
required). The faithful statements were read directly from
`AlgebraicJacobian/Picard/IdentityComponent.lean` (signatures + docstrings).

## Macros needed
- `\connComp` — used in the new substrate prose for the connected-component
  operator. Defined chapter-locally via `\providecommand{\connComp}{\operatorname{Comp}}`
  at the chapter top (safe, no clash). If a project-wide connected-component
  macro already exists in `macros/common.tex`, the `\providecommand` yields
  to it automatically; otherwise consider promoting it. NOT added to
  `macros/common.tex` by me (out of write-domain).

## Notes for Plan Agent
- `lem:identity_component_geometrically_connected` (`identityComponent_geometricallyConnected`)
  is currently sorry-free *only modulo* the residual sorry inside its
  dependency `lem:geometricallyConnected_of_connected_of_section` (the
  Stacks 037Q / 04KV gap). Its own body is a direct application; the
  `\leanok` status will be set by `sync_leanok` per the actual sorry
  analysis. No action needed — flagged for awareness.

## Strategy-modifying findings
None.
