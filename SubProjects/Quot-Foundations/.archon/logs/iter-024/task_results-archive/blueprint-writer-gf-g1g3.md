# Blueprint Writer Report

## Slug
gf-g1g3

## Status
COMPLETE

All five required FIXes landed. The keystone G1 bridge is backed by a freshly
retrieved verbatim Stacks citation (Tag 01PB). Dependency graph verified with
`leandag` (isolated: 0, unknown_uses: [], no conflicts).

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
- **FIX 1 — `thm:generic_flatness` header de-staled.** Updated the
  `% LEAN SIGNATURE HEADER` block to carry `[QuasiCompact p]` (now
  `[LocallyOfFiniteType p] [QuasiCompact p]`), matching the landed Lean signature
  `AlgebraicGeometry.genericFlatness` (verified at
  `AlgebraicJacobian/Picard/FlatteningStratification.lean:2173-2175`). Consolidated
  the iter-023 `% NOTE` into a single self-consistent essential-hypothesis note (the
  `⊔_i Spec ℤ → Spec ℤ` counterexample, "no instance `LocallyOfFiniteType → QuasiCompact`");
  the header is no longer described as STALE.
- **FIX 2 — false prose claim removed.** Rewrote Step 1 of the geometric proof: was
  "Since `p` is locally of finite type it is in particular quasi-compact …" (FALSE in
  Mathlib); now "Since `p` is quasi-compact (by the `[QuasiCompact p]` hypothesis) and
  `U_0` is affine hence quasi-compact, the preimage `X_{U_0} = p⁻¹(U_0)` is
  quasi-compact; choose a finite affine cover …".
- **FIX 3 — added lemma G1** `\lemma`/`\label{lem:gf_qcoh_fintype_finite_sections}`/
  `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` — for an affine open
  `W ⊆ X`, `Γ(F, W)` is finite over `Γ(X, W)` for a finite-type quasi-coherent `F`.
  - Proof sketch added: Y — identifies `F|_W ≅ Ñ` (via
    `\uses{lem:qcoh_section_localization_basicOpen}`, the QUOT keystone giving
    `Γ(F,D(g)) = N_g`), reduces finite-type to a standard open cover `W = ⋃ D(g_i)`
    with each `N_{g_i}` finite over `R_{g_i}`, then glues finite generation since the
    `g_i` generate the unit ideal.
  - `% LEAN STATUS: G1 — project-built (mathlib-build target this iter)` marker added;
    `% NOTE:` recording the overlap with the QUOT keystone (shared qcoh-affine-local
    infra) added. NOT marked `\mathlibok` (project-built).
  - `% SOURCE:` + verbatim `% SOURCE QUOTE:` = Stacks "Properties of Schemes" Tag 01PB,
    retrieved this session (see Reference-retriever dispatches).
- **FIX 4 — added lemma G3** `\lemma`/`\label{lem:gf_flat_locality_assembly}`/
  `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` — from per-patch freeness
  `(M_j)_f` over `A_f` on a finite source cover, `Γ(F, W)` is flat over `Γ(S, U)` for
  every affine `U ≤ V = D(f)` and affine `W ≤ p⁻¹(U)`.
  - Proof sketch added: Y (stub-level) — free ⟹ flat; flatness local on the source
    cover (flat-at-every-maximal criterion); stable under base-restriction along the
    open immersion `U ↪ V` (localization of `A_f` and of the section module).
  - `% LEAN STATUS: G3 — project-built; … stub-level this iter; built after G1.` added.
    NOT marked `\mathlibok`.
- **FIX 5 — proof body wired.** Step 2 now `\cref{lem:gf_qcoh_fintype_finite_sections}`;
  Step 4 now `\cref{lem:gf_flat_locality_assembly}`. Added a `\uses{thm:generic_flatness_algebraic,
  lem:gf_qcoh_fintype_finite_sections, lem:gf_flat_locality_assembly}` to the geometric
  proof block.
- **Added subsection** `\subsection{Geometric bridges for the affine assembly}`
  (`\label{sec:gf_geometric_bridges}`) introducing G1/G3 before the geometric theorem.

## Lean names chosen (for the plan / scaffolder agent)
- G1: `AlgebraicGeometry.gf_qcoh_fintype_finite_sections`
  Lean shape: `∀ {W : X.Opens}, IsAffineOpen W → Module.Finite Γ(X, W) Γ(F, W)`
  (matching the GAP G1 note at `FlatteningStratification.lean:2245-2250`).
- G3: `AlgebraicGeometry.gf_flat_locality_assembly`
  (matching the GAP G3 note at `FlatteningStratification.lean:2252-2259`).
Both names are in the `AlgebraicGeometry` namespace per the directive; neither Lean
decl exists yet (project-built, to be scaffolded). `leandag` matches both blueprint
nodes to these names with no conflict.

## Cross-references introduced
- `\uses{lem:qcoh_section_localization_basicOpen}` in `lem:gf_qcoh_fintype_finite_sections`
  (statement + proof) — target EXISTS in `Picard_QuotScheme.tex:2465`
  (`AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`). Cross-chapter edge,
  resolves cleanly in leandag.
- `\uses{lem:gf_qcoh_fintype_finite_sections}` in `lem:gf_flat_locality_assembly` — same
  chapter.
- `\uses{thm:generic_flatness_algebraic, lem:gf_qcoh_fintype_finite_sections,
  lem:gf_flat_locality_assembly}` added to the geometric proof — all same chapter.
- leandag: `isolated: 0`, `unknown_uses: []`, `conflicts: []` after edits.

## References consulted
- `references/summary.md` — index; confirmed no local source covered the
  Properties-of-Schemes finite-type-qcoh-on-affines finiteness before dispatch.
- `references/stacks-properties.tex` (L2092-L2098) — verbatim `% SOURCE QUOTE:` for
  `lem:gf_qcoh_fintype_finite_sections` (Tag 01PB, lemma + proof sketch). Newly
  retrieved this session.
- `references/stacks-schemes.tex` — checked for the finiteness fact (absent; only the
  `M̃`-localization lemma 01I9 is there).
- `blueprint/src/chapters/Picard_QuotScheme.tex` (L2455-2514) — read the QUOT keystone
  `lem:qcoh_section_localization_basicOpen` to wire G1's `\uses{}` and align the
  affine-local `F|_W ≅ Ñ` / `Γ(F,D(g)) = N_g` language.

## Macros needed (if any)
None. All commands used (`\Spec`, `\OO`, `\F`, `\Gamma`, `\widetilde`, `\cref`) are
already defined/used in the chapter.

## Reference-retriever dispatches (if any)
- slug `stacks-properties`: requested Stacks "Properties of Schemes" qcoh finite-type
  affine-characterization tag. Status: COMPLETE. Downloaded
  `references/stacks-properties.tex` (5424 lines); pointer at
  `references/stacks-properties.md`; registered in `references/summary.md`. Exact hit:
  **Tag 01PB** `lemma-finite-type-module`, lines 2092–2110 — "`M̃` is a finite type
  `O_X`-module iff `M` is a finite `R`-module". Used verbatim as G1's `% SOURCE QUOTE:`.

## Notes for Plan Agent
- **G1 ↔ QUOT keystone overlap.** `lem:gf_qcoh_fintype_finite_sections` and
  `lem:qcoh_section_localization_basicOpen` (QUOT chapter) both route through the
  affine-local `F|_W ≅ Ñ` identification. The directive flagged extracting this to
  shared qcoh-affine-local infra; recorded as a `% NOTE:` in the block. If a shared
  helper is created, both chapters' `\uses{}` should point at it. Not actioned here
  (cross-chapter).
- **G1 is the witness-blocking gap.** The Lean `genericFlatness` terminates in an honest
  `sorry` at `FlatteningStratification.lean:2264` precisely because G1 is unavailable
  to produce the per-patch `f_j`. G1 is the correct `mathlib-build` prover target this
  iter; G3 is stub-level and should be built after G1.
- **G3 stub caveat.** The G3 proof sketch asserts the base-restriction identification of
  `Γ(F, W∩W_j)` localizations across the source cover at a stub level of detail; the
  precise plumbing (which patch `W_j` a given affine `W ≤ p⁻¹(U)` localizes from, and
  the compatibility of the `p.appLE` module structures) is the genuine missing content
  and may warrant its own sub-lemma when a prover targets G3.
- **Tag 01B5 (finite-type O_X-module definition)** lives in Stacks `modules.tex`, not
  yet on disk. Not needed for the G1 citation (01PB is self-contained as quoted), but if
  a future block needs the base definition verbatim, dispatch a retriever for
  `modules.tex`.

## Strategy-modifying findings
None. The blueprint changes reflect the existing GF-geo route exactly; no strategy-level
issue surfaced.
