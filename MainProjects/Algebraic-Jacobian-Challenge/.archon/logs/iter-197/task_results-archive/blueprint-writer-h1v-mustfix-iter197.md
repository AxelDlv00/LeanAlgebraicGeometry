# Blueprint Writer Report

## Slug
h1v-mustfix-iter197

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

## Summary

Patched the H1Vanishing chapter to address all 3 must-fix-this-iter
findings (M-1, M-2, M-3) and the 3 major findings (J-1, J-2, J-3) of
the iter-196 lean-vs-blueprint-checker report. The edits add precise
`% NOTE:` blocks acknowledging the two known Mathlib gaps (the
constantSheaf sheafification-unit-iso on irreducible spaces, and the
`j_!` extension-by-zero functor in the sheaf-of-modules generality),
isolate the actual Lean blocking step (the inner iso
`skyscraperSheaf PUnit.unit A ≅ constantSheaf J_punit A`) into its
own pinned sub-lemma block with both Route A (Mathlib upstreaming) and
Route B (project-local) recipes, prune the stale `\uses{...}` set on
`lem:skyscraperSheaf_isFlasque`, refresh `\uses{...}` on
`thm:H1_vanishing_flasque` to honestly reflect the substrate
dependencies the Lean proof actually consumes, and pin
`AlgebraicGeometry.Scheme.IsFlasque.injective_flasque` so
`sync_leanok` can independently track the still-open `j_!` gap. No
existing `\leanok` or `\mathlibok` markers were touched; the chapter
remains valid LaTeX (begin/end environments balanced;
`leanblueprint web` reports no errors on this chapter file — the build
error in the trace is in the sibling `RiemannRoch_OCofP.tex` L657 and
is unrelated to this directive).

## Must-fix items addressed

- **M-1** — Added a `% NOTE:` block to the proof of
  `lem:isFlasque_constant_irreducible` acknowledging the Mathlib gap
  in the non-empty branch (the sheafification-unit-iso on irreducible
  spaces is not in Mathlib `b80f227`). The note describes both
  closure routes:
  - Route A (preferred, Mathlib upstreaming): `Full` + `Faithful`
    instances for `(constantSheaf J D)` on `IrreducibleSpace X`.
  - Route B (fallback, no upstream): build alternate sheaf `P'` with
    `P'(U) = A` for `U ≠ ⊥`, `P'(⊥) = 0`; exhibit iso with
    `(constantSheaf J D).obj A`.
  Cross-referenced to the Lean comment at H1Vanishing.lean:150-154
  that documents the gap on the Lean side.

- **M-2** — Updated the prose of `lem:skyscraperSheaf_eq_pushforward`
  to drop the misleading "naturally isomorphic" claim (changed to
  the weaker "isomorphic"), and added a `% NOTE:` documenting that
  the Lean signature is `Nonempty (iso)`, forced by `Classical.choice`
  on the inner iso. The note also records the upgrade path: when the
  inner iso is constructed explicitly, the `Nonempty` wrapper can be
  dropped to a direct iso statement; no consumer change is required
  at the headline `H1_skyscraperSheaf_finrank_eq_zero` (which does
  not extract morphism components).

- **M-3** — Inserted a new sub-lemma block
  `lem:skyscraperSheaf_iso_constantSheaf_punit` (pinned to
  `AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit`)
  capturing the actual blocking technical step:
  `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A` on
  PUnit. The proof block describes:
  - the forward map via `constantSheafAdj.homEquiv.symm` and the
    `simp [skyscraperPresheaf]` identification at `⊤`;
  - the inverse map pointwise on the two opens of PUnit (`⊥` via
    `IsTerminal.uniqueUpToIso`; `⊤` via the constantSheaf-unit-iso
    on PUnit);
  - naturality on `⊥ ≤ ⊤` via `Subsingleton` of terminal;
  - both Route A and Route B for the underlying Mathlib gap (the
    `Full`/`Faithful` instances on the one-point space).
  The parent `lem:skyscraperSheaf_eq_pushforward` proof block has been
  updated to add `\uses{lem:skyscraperSheaf_iso_constantSheaf_punit}`
  and to explain the outer-vs-inner step decomposition that the Lean
  formalisation uses (replacing the pre-existing prose's silent
  presheaf-level argument).

- **J-1** — Pruned the stale `\uses{...}` set on
  `lem:skyscraperSheaf_isFlasque` (statement and proof) to
  `def:isFlasque_sheaf` only. Added a `% NOTE:` in the proof block
  explaining that the Lean proof at H1Vanishing.lean:903-939 takes a
  direct route via `skyscraperPresheaf_map` on a `P.point ∈ V` case
  split, bypassing the four-lemma chain originally listed. The
  informal mathematical sketch in the proof body is preserved
  because it is shorter and more illuminating than the case split;
  readers wanting to track the actual Lean proof are pointed to the
  file.

- **J-2** — Added a new `\begin{lemma}` block
  `lem:isFlasque_injective` immediately before
  `thm:H1_vanishing_flasque`, pinned to
  `AlgebraicGeometry.Scheme.IsFlasque.injective_flasque`. The block
  states Hartshorne III.2.4 (injective ⇒ flasque), gives the classical
  `j_!` extension-by-zero proof sketch, and carries a `% NOTE:` in the
  proof block recording the out-of-loop scope reduction, the
  `j_!`-in-`Sheaf (J, ModuleCat kbar)` Mathlib gap, the
  ~100-150 LOC closure estimate, and the Lean file location
  (H1Vanishing.lean:613-618) of the typed sorry. Per directive J-2,
  no `% SOURCE QUOTE:` was included — only the citation pointer.

- **J-3** — Updated `\uses{...}` on `thm:H1_vanishing_flasque` to
  include `lem:isFlasque_injective` (the new J-2 block),
  `lem:flasque_cokernel_short_exact`, and
  `lem:ext_succ_zero_of_injective_lower_zero`. This makes the
  dependency graph honest about the three substrate inputs the Lean
  proof of `HModule_flasque_eq_zero` actually consumes
  (Hartshorne III.2.4 input via the private auxiliary chain;
  the flasque-quotient lemma; the higher-degree LES vanishing lemma).
  All three labels were verified to exist in the chapter (lines 237,
  280, and the new 314).

## Cross-references introduced / modified

- `\uses{lem:skyscraperSheaf_iso_constantSheaf_punit}` added in the
  proof block of `lem:skyscraperSheaf_eq_pushforward`. The label
  resolves to the new sub-lemma added immediately below.
- `\uses{lem:isFlasque_injective, lem:flasque_cokernel_short_exact,
  lem:ext_succ_zero_of_injective_lower_zero}` added to the statement
  block of `thm:H1_vanishing_flasque` (replacing the prior
  `\uses{def:isFlasque_sheaf}`). All three labels verified to exist
  in the file (`grep` confirmed lines 237 / 280 / 314).
- `\uses{def:isFlasque_sheaf, lem:isFlasque_pushforward}` on the new
  `lem:isFlasque_injective` statement and proof blocks. Both labels
  exist in the chapter (`def:isFlasque_sheaf` at L76,
  `lem:isFlasque_pushforward` at L122).
- `\uses{def:isFlasque_sheaf, lem:isFlasque_constant_irreducible}` on
  the new `lem:skyscraperSheaf_iso_constantSheaf_punit` proof block.
  The latter label exists at L157.
- Pruned `\uses{...}` on `lem:skyscraperSheaf_isFlasque` (statement
  and proof) from the 5-label set down to `{def:isFlasque_sheaf}` —
  removing `lem:skyscraperSheaf_eq_pushforward`,
  `lem:closedPoint_closure_irreducible`,
  `lem:isFlasque_pushforward`, and `lem:isFlasque_constant_irreducible`
  (none of which the Lean proof uses).

## New `\lean{...}` pins (future substrate targets)

Both new pins reference Lean declarations that do NOT yet exist; the
iter-197+ prover will author them as typed substrate helpers, and the
existing surrounding Lean declarations will then consume them:

- `\lean{AlgebraicGeometry.Scheme.IsFlasque.injective_flasque}` — exists
  in the Lean file as a typed sorry (L613-618); the new blueprint
  block makes the existing declaration visible to `sync_leanok`.
- `\lean{AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit}`
  — does NOT yet exist in the Lean file; the iter-197+ prover will
  create it, and the existing `skyscraperSheaf_eq_pushforward_const`
  will then consume it (replacing the inner `sorry` and dropping the
  `Nonempty` wrapper). Per directive: the writer is not the author —
  the pin clarifies the substrate target for the prover.

## References consulted

- `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — read-then-edit
  baseline; needed to find label positions, existing `\uses{...}`
  contents, and the existing `% SOURCE QUOTE:` precedent for
  Hartshorne citations.
- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (offsets 130-180,
  600-650, 810-940) — needed to confirm the directive's claims about
  current sorry locations (L178 non-empty branch of
  `constant_of_irreducible`; L613 `injective_flasque`; L855 inner
  iso in `skyscraperSheaf_eq_pushforward_const`) and the precise
  shapes of the existing Lean signatures.
- `.archon/task_results/lean-vs-blueprint-checker-h1v.md` — read in
  full to ground the must-fix and major findings.
- `blueprint/src/macros/common.tex` — checked which macros are
  defined; confirmed `\PUnit`, `\Module`, `\Opens`, `\HModule`, `\op`
  are available (used in the new sub-lemma block).

No verbatim source quotes were copied from external references in
this round — the new `lem:isFlasque_injective` block explicitly omits
the `% SOURCE QUOTE:` per the directive (J-2 said "leave the citation
pointer only"; the local `references/hartshorne-algebraic-geometry.md`
appears not to extend to the III.2.4 passage), and the new
`lem:skyscraperSheaf_iso_constantSheaf_punit` block is a
project-bespoke Lean-substrate technical sub-lemma (no external
source). The existing `% SOURCE QUOTE:` blocks elsewhere in the
chapter were left intact.

## Reference-retriever dispatches

None. Per directive J-2, no source quote was required for the new
`lem:isFlasque_injective` block; the existing citations elsewhere
in the chapter cover Hartshorne II.1 Exercise 1.16, II.1 Exercise
1.17, and III.2 Proposition 2.5 — all of which were already pasted
in pre-existing blocks.

## Macros needed

None new. The new blocks use only the macros already defined in
`blueprint/src/macros/common.tex` (`\PUnit`, `\Module`, `\Opens`,
`\HModule`, `\op`) together with stdlib LaTeX (`\mathrm`, `\mathtt`,
`\mathcal`, `\cref`, `\emph`).

## Notes for Plan Agent

- **Pre-existing sibling-chapter build error**: `leanblueprint web`
  fails at `./chapters/RiemannRoch_OCofP.tex` line 657 with
  `'math' object has no attribute 'strip'`. The trace confirms
  `RiemannRoch_H1Vanishing.tex` parsed cleanly with no errors —
  the failure is in a different chapter and is unrelated to this
  directive. Flagging for plan-agent awareness; no action taken
  per single-chapter scope.

- **`skyscraperSheaf_iso_constantSheaf_punit` does not yet exist in
  Lean**: the new sub-lemma block pins a Lean name that the iter-197+
  prover must create. Suggested signature (for the directive of that
  prover round, NOT for any writer action):

  ```lean
  theorem Scheme.skyscraperSheaf_iso_constantSheaf_punit
      (kbar : Type u) [Field kbar]
      [∀ U : TopologicalSpace.Opens (TopCat.of PUnit.{u + 1}),
        Decidable (PUnit.unit ∈ U)]
      (A : ModuleCat.{u} kbar) :
      skyscraperSheaf (C := ModuleCat.{u} kbar) PUnit.unit A ≅
        (constantSheaf
            (Opens.grothendieckTopology (TopCat.of PUnit.{u + 1}))
            (ModuleCat.{u} kbar)).obj A
  ```

  Once this declaration is closed (via Route A or Route B from the
  blueprint block), the inner `sorry` at H1Vanishing.lean:855 can be
  replaced with `Nonempty.intro (skyscraperSheaf_iso_constantSheaf_punit
  kbar A)`, and the outer `Nonempty (iso)` wrapper of
  `skyscraperSheaf_eq_pushforward_const` becomes droppable (the Lean
  return type can be tightened to a direct iso).

- **Existing `\leanok` markers on `thm:H1_vanishing_flasque` and
  `lem:H1_skyscraperSheaf_finrank_eq_zero_main`**: the
  lean-vs-blueprint-checker (severity: major) flagged that these
  markers may overstate closure because both transitively depend on
  the `injective_flasque` sorry. This is `sync_leanok`'s concern, not
  the writer's — I did not add or remove any `\leanok` marker. The
  J-2 block I added makes `injective_flasque` visible to
  `sync_leanok` as its own pinned target so the dependency graph is
  honest going forward.

## Strategy-modifying findings

None. The directive's must-fix and major items were all resolvable
within the chapter without requiring a strategy-level change. The
two Mathlib gaps (constantSheaf sheafification-unit-iso on
irreducible spaces; `j_!` extension-by-zero) are already named in
STRATEGY-style language by the chapter's existing
`% NOTE:` blocks at H1Vanishing.lean:150-154 and L600-610, and the
new blueprint blocks make them visible to the dependency graph
without changing the project's overall strategy (Route C / RR.2.H¹
remains intact; only the per-step closure path is refined).
