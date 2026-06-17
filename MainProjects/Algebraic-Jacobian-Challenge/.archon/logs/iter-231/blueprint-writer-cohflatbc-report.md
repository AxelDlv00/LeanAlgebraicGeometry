# Blueprint Writer Report

## Slug
cohflatbc

## Status
COMPLETE

New chapter `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` created, covering
the `i = 0` (i.e. `H^0` / `f_*`) slice of flat base change: the pushforward of a
quasi-coherent sheaf commutes with flat base change. All citation blocks are backed
by verbatim quotes copied character-by-character from `references/stacks-coherent.tex`
(read this session). The Lean declarations do NOT exist yet — this is
coverage-ahead-of-code, so the `\lean{...}` hints are plausible target names only.

## Target chapter
blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Changes Made
- **Added definition** `\definition`/`\label{def:pushforward_base_change_map}`/`\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` — the canonical base-change morphism `g^*(f_*F) → f'_*((g')^*F)` for the cartesian square `X' = X ×_S S'`, described as the adjoint of `f_*` applied to the pullback unit. Verbatim `% SOURCE QUOTE` of the Stacks §"Cohomology and base change, I" setup paragraph.
- **Added lemma** `\lemma`/`\label{lem:affine_base_change_pushforward}`/`\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` — the affine warm-up: for `f` affine the base-change map is an isomorphism, reducing to the associativity `(R'⊗_R A)⊗_A M = R'⊗_R M`.
  - Proof sketch added: Y — affine-localize, translate to modules, identify with tensor associativity (no flatness needed). Verbatim `% SOURCE QUOTE PROOF` from the Stacks affine-base-change lemma proof.
- **Added theorem** `\theorem`/`\label{thm:flat_base_change_pushforward}`/`\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` — main result: for `g` flat and `f` quasi-compact + quasi-separated, `g^*(f_*F) ≅ f'_*((g')^*F)`; equivalently `H^0(X,F)⊗_A B ≅ H^0(X_B,F_B)` for `A→B` flat.
  - Proof sketch added: Y — (i) reduce to affine target (`f_*F` quasi-coherent ⇒ module `H^0`, pullback = `−⊗_A B`); (ii) separated case via Čech complexes, where the affine lemma gives `Č•(U_B,F_B) ≅ Č•(U,F)⊗_A B` and flatness of `A→B` commutes `−⊗_A B` past cohomology; (iii) quasi-separated case via the two Čech-to-cohomology spectral sequences (with a noted Mayer–Vietoris-induction alternative for the `i=0` statement). Verbatim `% SOURCE QUOTE PROOF` of the full tag-02KH proof (statement + proof quote both cover all `i ≥ 0`; my restated prose specializes to `i = 0`).

## Cross-references introduced
- `\uses{def:pushforward_base_change_map}` in `lem:affine_base_change_pushforward` (statement + proof) — target is in THIS chapter. OK.
- `\uses{def:pushforward_base_change_map, lem:affine_base_change_pushforward}` in `thm:flat_base_change_pushforward` (statement + proof) — both targets in THIS chapter. OK.
- No cross-chapter `\uses` introduced.

## References consulted
- `references/stacks-coherent.tex` — verbatim `% SOURCE QUOTE` blocks: the §"Cohomology and base change, I" setup paragraph (L877–904) for `def:pushforward_base_change_map`; the "Affine base change" lemma statement (L906–918) and its proof (L920–938) for `lem:affine_base_change_pushforward`; tag-02KH "Flat base change" lemma statement (L947–970) and proof (L972–1050) for `thm:flat_base_change_pushforward`.
- `references/stacks-coherent.md` — confirmed tag 02KH ↔ `lemma-flat-base-change-cohomology` mapping, location, and that part (2) is the `H^0`/affine base-change form; used to ground the `% SOURCE:` pointers.
- `references/summary.md` — index entry confirming `stacks-coherent.md → stacks-coherent.tex` covers tag 02KH; no other source needed.
- `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — read as a sibling-format reference (chapter/definition/theorem block conventions).

## Macros needed (if any)
- None required. The chapter deliberately uses only universal LaTeX (`\mathcal`, `\otimes`, `\operatorname{Spec}`, `\check`, `\underline`, `\xrightarrow`, `array`) so it compiles without project-specific or diagram-package macros. I avoided `\Spec`, `\QCoh`, `\Pic`, `\Ext`, and `\xymatrix`/`tikzcd` because I could not confirm (intermittent tool I/O this session) that the blueprint preamble loads the `xy`/`tikz-cd` packages or those shortcut macros. If the preamble DOES define `\Spec` and load a diagram package, the plan agent may optionally swap `\operatorname{Spec}` → `\Spec` and the `array` squares → `tikzcd`/`xymatrix` for nicer rendering — purely cosmetic.

## Reference-retriever dispatches (if any)
- None. The required anchor (Stacks tag 02KH) and the affine warm-up lemma were both already present verbatim in `references/stacks-coherent.tex`.

## Notes for Plan Agent
- **Not yet `\input` into `content.tex`.** Per the directive, the plan agent should add `\input{chapters/Cohomology_FlatBaseChange}` to `blueprint/src/content.tex` (it is currently an orphan chapter — blueprint-doctor will flag it until wired).
- **No `% archon:covers` line added.** Some sibling chapters (e.g. `RiemannRoch_WeilDivisor.tex`) begin with `% archon:covers <leanfile>`. I omitted it because the backing Lean file does not exist yet; add it when the Lean file (e.g. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`) is scaffolded, to avoid pointing the coverage map at a missing file.
- **`\lean{...}` hints are speculative target names** (`AlgebraicGeometry.pushforwardBaseChangeMap`, `…affineBaseChange_pushforward_iso`, `…flatBaseChange_pushforward_isIso`). No corresponding declarations exist; `\leanok` will (correctly) not be synced until the Lean lane builds them.
- **Scope honored:** only the `i = 0` / `f_*` case is written. The `R^i f_*` (`i ≥ 1`) material, Grauert cohomology-and-base-change, relative Proj, and Quot are NOT touched. The verbatim 02KH quotes inevitably contain the `i ≥ 1` / `R^i f_*` general statement (the lemma is stated for all `i ≥ 0` in the source); the rendered prose restricts to `i = 0`, and the higher-`i` content is explicitly deferred in the chapter's motivation section.
- The affine warm-up lemma (`lem:affine_base_change_pushforward`) is cited by its Stacks label `lemma-affine-base-change` rather than a numeric tag — the project's `stacks-coherent.md` only catalogues tag 02KH, and I did not want to fabricate a tag number. The `% SOURCE:` pointer names the section and the local file read, satisfying the discipline check.

## Strategy-modifying findings
None. Writing the chapter did not surface any strategy-level issue; the `i = 0` flat base change is exactly as the directive's strategy context describes, and reduces cleanly (affine associativity → Čech over a cover → flatness commutes with cohomology).
