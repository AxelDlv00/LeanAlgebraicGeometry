# Blueprint Writer Report

## Slug
fbc-seams2

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made

### Must-fix 1 — pin the landed helper + Mathlib anchors
- **Added lemma** `\lemma`/`\label{lem:pullbackPushforward_unit_comp}`/`\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` — pseudofunctoriality of the pullback–pushforward unit (the leg-reindex engine). Placed in the "section-level mate computation" subsection (`\subsection{The section-level base-change identity}`) IMMEDIATELY BEFORE `lem:base_change_mate_fstar_reindex`, as directed. Statement is the exact equation from the directive (`η_b ∘ b_*(η_a) ∘ pushforwardComp.hom = η_{a∘b} ∘ (a∘b)_*(pullbackComp.inv)`), with a one-paragraph informal proof: `unit_conjugateEquiv` for the composite adjunction, mate rewritten by `conjugateEquiv_pullbackComp_inv`, unit expanded by `comp_unit_app`, then reassociation. Matches the landed Lean proof at `FlatBaseChange.lean:1140`.
- **Added 3 Mathlib dependency anchors** (`\mathlibok`, no `% SOURCE`):
  - `\label{lem:unit_conjugateEquiv_mathlib}`/`\lean{CategoryTheory.unit_conjugateEquiv}` (import `Mathlib.CategoryTheory.Adjunction.Mates`).
  - `\label{lem:comp_unit_app_mathlib}`/`\lean{CategoryTheory.Adjunction.comp_unit_app}` (import `Mathlib.CategoryTheory.Adjunction.Basic`).
  - `\label{lem:conjugateEquiv_pullbackComp_inv_mathlib}`/`\lean{AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv}` (import `Mathlib.AlgebraicGeometry.Modules.Sheaf`).
  - All three signatures were verified via LSP hover against the live project (full signatures + Mathlib import paths confirmed) before marking `\mathlibok`.
  - The helper lemma `\uses` all three anchors (statement + proof), giving them incoming edges (none isolated).
- **Revised** `lem:base_change_mate_fstar_reindex` — added `\uses{lem:pullbackPushforward_unit_comp}` to both the statement and proof `\uses` blocks.

### Must-fix 2 — expand Seam 2 for the dependent-type wall
- **Rewrote the proof** of `lem:base_change_mate_fstar_reindex`. The new proof:
  - Names the four-factor structure of `θ_in` and the leg factorizations `g' = e ∘ Spec ι_A`, `f' = e ∘ Spec ι_{R'}`.
  - Adds a **"dependent-type obstruction"** paragraph: enumerates the four dependent positions where the legs sit (adjunction index of `η^{g'}`; the equality proof `w` inside `pushforwardCongr w`; the `gammaPushforwardIso ψ` argument; and inside the *type* of the opaque `base_change_mate_codomain_read`), and states the naive substitution yields an ill-typed motive — so this is **not a single rewrite**.
  - **(i) Abstract variable-legs restatement** — restate codomain-read + the whole chain for generic `g' f'` with the cone-leg equalities as hypotheses, making the legs `subst`-able free variables on a well-typed motive.
  - **(ii) Γ-collapse of the transparent coherences** — names the section-level collapses: `pushforwardComp^{hom/inv}_{app,app} = id` and `pushforwardCongr^{hom}_{app,app} = eqToHom`, leaving only `f_*(η^{g'})` non-trivial on Γ.
  - **(iii) Reduction to Seam 1 via the leg-reindex engine** — `pullbackPushforward_unit_comp` (a := e, b := Spec ι_A, N := tilde M) rewrites `η^{g'}` into the affine `Spec ι_A`-unit; the `e`-unit is invertible (`pullback_isEquivalence_of_iso`) and absorbed into `Θ_tgt`; the surviving `Spec ι_A`-unit value is Seam 1's `η_M`; composing with `Θ_tgt` and reading over `Spec R` by `restrictScalars ψ` lands on `ρ = base_change_mate_inner_value`.
  - States each of (i)–(iii) extracts as a named lemma.

### Must-fix 3 — expand Seam 3 (concrete counit coherence)
- **Rewrote the "Conjugation by the section dictionaries" step** of `lem:base_change_mate_gstar_transpose` into two paragraphs:
  - **"The concrete counit coherence — why it is not a bare computation"** — names that `pullback_spec_tilde_iso ψ` (= `Π_ψ`) is built as the component of `(conjIso(adj_L, adj_R)^{-1}(γ_ψ))^{-1}` (the uniqueness-of-left-adjoints comparison from `gammaPushforwardNatIso`), with `adj_L = (tilde ⊣ Γ) . (g^* ⊣ g_*)` and `adj_R = (extendScalars ⊣ restrictScalars) . (tilde ⊣ Γ)`; therefore its interaction with the counit is **not** `rfl`/`simp`.
  - **"Conjugation via the composed-adjunction counit-triangle identity"** — the counit-triangle (zig-zag) coherence for the composed adjunction `(tilde ⊣ Γ)_{R'} . (g^* ⊣ g_*)`, stated concretely: `Π_ψ` composed with `ε_g` and the tilde–Γ counit equals the algebraic counit of `extendRestrictScalarsAdj ψ`; equivalently conjugating `Γ(ε_g)` by the tilde dictionaries identifies it with the module-level adjunction counit. Identified as the dual companion of `unit_conjugateEquiv`. Result: transpose becomes `extendScalars ψ ∘ ρ`.
- Counit factorization paragraph updated to name the `homEquiv`-counit identity for the transpose (matching `Adjunction.homEquiv_counit` in the Lean).

## Cross-references introduced
- `\uses{lem:pullbackPushforward_unit_comp}` added in `lem:base_change_mate_fstar_reindex` (statement + proof) — target added this session in same chapter. OK.
- `lem:pullbackPushforward_unit_comp` `\uses` `lem:unit_conjugateEquiv_mathlib`, `lem:comp_unit_app_mathlib`, `lem:conjugateEquiv_pullbackComp_inv_mathlib` — all three added this session in same chapter. OK.
- Seam 3 proof `\uses` extended with `lem:gammaPushforwardNatIso` (pre-existing, same chapter) and `lem:unit_conjugateEquiv_mathlib` (added this session). OK.
- `leandag build --json`: `isolated: 0`, `unknown_uses: []`, `conflicts: []`. The three Mathlib anchors appear in `unmatched_lean` — expected and correct: their `\lean{}` targets are Mathlib declarations not present in the project's Lean source, and they are `\mathlibok` so the DAG treats them as done (`mathlib_ok` rose to 29).

## References consulted
- None opened this session. Seam 2/Seam 3 are project-bespoke categorical bookkeeping with no external source (per the directive's citation-discipline note); the existing blocks carry no `% SOURCE` and I kept it that way. The three Mathlib anchors carry no `% SOURCE` (the `\lean{}` target is the citation), and their statements were verified by LSP hover against the live build, not from memory.

## Macros needed (if any)
- None. New commands used are all `\operatorname{...}`/`\mathrm{...}` (`\operatorname{conj}`, `\operatorname{conjIso}`, `\operatorname{homEquiv}`, `\operatorname{extendRestrictScalarsAdj}`), which need no macro definition. `\mathlibok` is already used throughout the chapter.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The Lean `FlatBaseChange.lean:1234–1247` comment block already lays out exactly the (i)/(ii)/(iii) restructure the new Seam-2 prose now mirrors, and the `pullbackPushforward_unit_comp` helper (`:1140`) is fully proved/axiom-clean — so the prover has a tight prose↔Lean correspondence to extract the named sub-lemmas from. The remaining Seam-2 `sorry` is at `:1248`; Seam-3 `sorry` at `:1293`.
- LaTeX balance verified: all `lemma`/`proof`/`definition` environments matched; display-math `\[`/`\]` balanced at 44/44 (the raw count anomaly is `\\[2pt]` line-break spacing inside `array`s, not math delimiters).

## Strategy-modifying findings
None. The chapter's strategy (FBC-A direct-on-sections via three section-level mate seams) is unchanged; this round only made the Seam-2/Seam-3 mechanism and the landed helper formalizable in prose.
